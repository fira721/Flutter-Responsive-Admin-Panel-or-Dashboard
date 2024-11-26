import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON parsing
import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/Absensi/components/header.dart';
import 'package:admin/screens/Absensi/components/storage_details.dart';

class AbsensiScreen extends StatefulWidget {
  @override
  _AbsensiScreenState createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  // List to store the attendance data
  List<Map<String, String>> _absensiData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAbsensiData();
  }

  // Fetch attendance data from the API
  Future<void> _fetchAbsensiData() async {
    final url =
        'http://103.179.57.240/pantau/absensi/get_riwayatabsenforadmin.php?start_date=2024-11-01 00:00:00&end_date=2024-11-30 23:59:59&customer_id=customer_id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            // Map the dynamic data to Map<String, String>
            _absensiData = List<Map<String, String>>.from(
              responseData['data'].map((item) => {
                    'userid': item['userid'].toString(),
                    'fullname': item['fullname'].toString(),
                    'tanggal': item['tanggal'].toString(),
                    'absen_masuk': item['absen_masuk'].toString(),
                    'absen_pulang': item['absen_pulang'].toString(),
                    'latitude_masuk': item['latitude_masuk'].toString(),
                    'longitude_masuk': item['longitude_masuk'].toString(),
                    'link_gambar_masuk': item['link_gambar_masuk'].toString(),
                    'latitude_pulang': item['latitude_pulang'].toString(),
                    'longitude_pulang': item['longitude_pulang'].toString(),
                    'link_gambar_pulang': item['link_gambar_pulang'].toString(),
                  }),
            );
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        // Tabel untuk data absensi dengan pagination

                        DataTableTheme(
                          data: DataTableThemeData(
                            headingRowColor: MaterialStateProperty.all(
                                Colors.blue.shade100), // Warna header
                            dataRowColor: MaterialStateProperty.all(
                                Colors.grey.shade200), // Warna baris data
                            decoration: BoxDecoration(color: Colors.amber),
                            dividerThickness: 1, // Ketebalan pembatas
                          ),
                          child: PaginatedDataTable(
                            arrowHeadColor: Colors.black,
                            rowsPerPage: 10,
                            columns: [
                              // DataColumn(label: Text('User ID')),
                              DataColumn(label: Text('Tanggal')),
                              DataColumn(label: Text('Nama')),

                              DataColumn(label: Text('Absen Masuk')),
                              DataColumn(label: Text('Absen Pulang')),
                              DataColumn(label: Text('Latitude Masuk')),
                              DataColumn(label: Text('Latitude Pulang')),
                              DataColumn(label: Text('Link Gambar Masuk')),
                              DataColumn(label: Text('Link Gambar Pulang')),
                            ],
                            source: _DataSource(_absensiData),
                          ),
                        ),

                        SizedBox(height: defaultPadding),
                        // Responsive tampilkan StorageDetails jika mobile
                        if (Responsive.isMobile(context)) StorageDetails(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: defaultPadding),
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 2,
                      child: StorageDetails(),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// Class untuk data yang akan ditampilkan di paginated table
class _DataSource extends DataTableSource {
  final List<Map<String, String>> data;

  _DataSource(this.data);

  String extractTime(String datetime) {
    return datetime.substring(11); // Memotong untuk mendapatkan hanya waktu
  }

  @override
  DataRow getRow(int index) {
    final row = data[index];
    return DataRow(cells: [
      // DataCell(Text(row['userid']!)),
      DataCell(Text(row['tanggal']!)),
      DataCell(Text(row['fullname']!)),

      DataCell(Text(extractTime(row['absen_masuk']!))),
      DataCell(Text(extractTime(row['absen_pulang']!))),
      DataCell(Text(row['latitude_masuk']!)),
      DataCell(Text(row['latitude_pulang']!)),
      DataCell(Text(row['link_gambar_masuk']!)),
      // DataCell(Text(row['link_gambar_pulang']!)),
      DataCell(Row(
        children: [
          IconButton.filled(onPressed: () {}, icon: Icon(Icons.map)),
          IconButton.filled(
            onPressed: () {},
            icon: Icon(Icons.map),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue, // Warna latar belakang
              foregroundColor: Colors.white, // Warna ikon
            ),
          ),
          IconButton.filled(onPressed: () {}, icon: Icon(Icons.macro_off)),
          IconButton.filled(onPressed: () {}, icon: Icon(Icons.macro_off))
        ],
      )),
    ]);
  }

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  @override
  bool get isRowCountApproximate => false;
}
