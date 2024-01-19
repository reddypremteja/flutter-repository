// import 'dart:convert';

// import 'package:flight_booking/global_var.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flight Booking App',
//       home: FlightSearchScreen(),
//     );
//   }
// }

// class FlightSearchScreen extends StatefulWidget {
//   const FlightSearchScreen({Key? key}) : super(key: key);

//   @override
//   State<FlightSearchScreen> createState() => _FlightSearchScreenState();
// }

// class _FlightSearchScreenState extends State<FlightSearchScreen> {
//   final TextEditingController originController = TextEditingController();
//   final TextEditingController destinationController = TextEditingController();
//   List<Map<String, dynamic>> places = [];
//   String origin = '';
//   String destination = '';
//   DateTime date = DateTime.now();
//   List<Map<String, dynamic>> flights = [];

//   Future<void> getData() async {
//     String apiUrl =
//         'https://partners.api.skyscanner.net/apiservices/v3/geo/hierarchy/flights/en-GB';
//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {
//         'x-api-key': GlobalVar.apiKey,
//         'Content-Type': 'application/json',
//       },
//     );
//     print(response.statusCode);
//     print(response.body);
//     if (response.statusCode == 200) {
//       setState(() {
//         places = List<Map<String, dynamic>>.from(
//           jsonDecode(response.body)["places"].values,
//         );
//       });
//     } else {
//       throw Exception('Failed to make a GET request');
//     }
//   }

//   String flightList = "";

//   Future<void> postData() async {
//     Map<String, dynamic> data = {
//       "query": {
//         "market": "UK",
//         "locale": "en-GB",
//         "currency": "GBP",
//         "queryLegs": [
//           {
//             "originPlace": {
//               "queryPlace": {"iata": origin}
//             },
//             "destinationPlace": {
//               "queryPlace": {"iata": destination}
//             },
//             "anytime": true
//             // "fixedDate": {
//             //   "year": date.year,
//             //   "month": date.month,
//             //   "day": date.day,
//             // }
//           },
//         ]
//       }
//     };
//     print(data);
//     String apiUrl =
//         'https://partners.api.skyscanner.net/apiservices/v3/flights/indicative/search';
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'x-api-key': GlobalVar.apiKey,
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(data),
//     );
//     setState(() {
//       flightList = response.body;
//     });
//     print(response.statusCode);
//     print(flightList.substring(1200, 2325));

//     if (response.statusCode == 200) {
//       // Parse and handle the response accordingly
//     } else {
//       // Handle error
//       throw Exception('Failed to make a POST request');
//     }
//   }

//   List<Map<String, dynamic>> searchPlaces(String query) {
//     return places.where((place) {
//       final String name = place["name"].toLowerCase();
//       final String iata = place["iata"].toLowerCase();
//       return name.contains(query.toLowerCase()) ||
//           iata.contains(query.toLowerCase());
//     }).toList();
//   }

//   void searchFlights() {
//     // Mock API call or use a real API for fetching flight data
//     // Replace this with actual API integration for flight booking
//     // In this example, we'll use a mock JSON payload
//     flights = [
//       {
//         "id": 1,
//         "origin": "CityA",
//         "destination": "CityB",
//         "date": "2024-01-20",
//         "price": 200
//       },
//       {
//         "id": 2,
//         "origin": "CityA",
//         "destination": "CityC",
//         "date": "2024-01-20",
//         "price": 250
//       },
//       // Add more flight data as needed
//     ];

//     setState(() {});
//   }

//   void bookFlight(int flightId) {
//     // Perform booking logic here
//     // In a real application, this would involve interacting with a booking API
//     // For this example, we'll print a message to the console
//     print("Flight booked with ID: $flightId");
//   }

//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flight Booking'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: originController,
//               onTap: () async {
//                 final String? selectedPlace = await showSearch<String?>(
//                   context: context,
//                   delegate: PlaceSearchDelegate(places),
//                 );
//                 if (selectedPlace != null) {
//                   setState(() {
//                     originController.text = selectedPlace;
//                     origin = selectedPlace;
//                   });
//                 }
//               },
//               decoration: const InputDecoration(labelText: 'Origin'),
//             ),
//             TextField(
//               controller: destinationController,
//               onTap: () async {
//                 final String? selectedPlace = await showSearch<String?>(
//                   context: context,
//                   delegate: PlaceSearchDelegate(places),
//                 );
//                 if (selectedPlace != null) {
//                   setState(() {
//                     destinationController.text = selectedPlace;
//                     destination = selectedPlace;
//                   });
//                 }
//               },
//               decoration: const InputDecoration(labelText: 'Destination'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: date,
//                   firstDate: DateTime(2022),
//                   lastDate: DateTime(2025),
//                 );
//                 if (pickedDate != null && pickedDate != date) {
//                   setState(() {
//                     date = pickedDate;
//                   });
//                 }
//               },
//               child: Text(
//                   'Select Date: ${date.toLocal().toString().substring(0, 11)}'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 postData();
//                 // Implement further logic based on the response if needed
//               },
//               child: const Text('Search Flights'),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: SingleChildScrollView(child: Text(flightList)),
//               // child: ListView.builder(
//               //   itemCount: flights.length,
//               //   itemBuilder: (context, index) {
//               //     return ListTile(
//               //       title: Text('Flight ${flights[index]["id"]}'),
//               //       subtitle: Text(
//               //           '${flights[index]["origin"]} to ${flights[index]["destination"]}'),
//               //       trailing: ElevatedButton(
//               //         onPressed: () => bookFlight(flights[index]["id"]),
//               //         child: const Text('Book'),
//               //       ),
//               //     );
//               // },
//               // ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PlaceSearchDelegate extends SearchDelegate<String?> {
//   final List<Map<String, dynamic>> places;

//   PlaceSearchDelegate(this.places);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [IconButton(onPressed: () => query = '', icon: Icon(Icons.clear))];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () => close(context, null),
//       icon: const Icon(Icons.arrow_back),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildSearchResults();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return _buildSearchResults();
//   }

//   Widget _buildSearchResults() {
//     final List<Map<String, dynamic>> searchResults = query.isEmpty
//         ? places
//         : places
//             .where((place) =>
//                 place["name"].toLowerCase().contains(query.toLowerCase()) ||
//                 place["iata"].toLowerCase().contains(query.toLowerCase()))
//             .toList();

// ignore_for_file: cast_from_null_always_fails, unnecessary_null_comparison, null_check_always_fails

//     return ListView.builder(
//       itemCount: searchResults.length,
//       itemBuilder: (context, index) {
//         final Map<String, dynamic> place = searchResults[index];
//         return ListTile(
//           title: Text(place["name"]),
//           subtitle: Text(place["iata"]),
//           onTap: () => close(context, place["iata"]),
//         );
//       },
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class GlobalVar {
  static const apiKey =
      'sh428739766321522266746152871799'; // Replace with your actual API key
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flight Booking App',
      home: FlightSearchScreen(),
    );
  }
}

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({Key? key}) : super(key: key);

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  List<Map<String, dynamic>> places = [];
  String origin = '';
  String destination = '';
  DateTime date = DateTime.now();
  List<Map<String, dynamic>> flights = [];

  // Define controllers for origin and destination TextFields
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  Future<void> getData() async {
    String apiUrl =
        'https://partners.api.skyscanner.net/apiservices/v3/geo/hierarchy/flights/en-GB';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'x-api-key': GlobalVar.apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        places = List<Map<String, dynamic>>.from(
          jsonDecode(response.body)["places"].values,
        );
      });
    } else {
      throw Exception('Failed to make a GET request');
    }
  }

  // List<Map<String, dynamic>> _parsePlacesResponse(
  //     Map<String, dynamic> jsonResponse) {
  //   Map<String, dynamic>? content = jsonResponse['content'];
  //   if (content == null) {
  //     // Handle error or return an empty list
  //     return [];
  //   }

  //   Map<String, dynamic>? results = content['results'];
  //   if (results == null) {
  //     // Handle error or return an empty list
  //     return [];
  //   }

  //   Map<String, dynamic>? placesMap = results['places'];
  //   if (placesMap == null) {
  //     // Handle error or return an empty list
  //     return [];
  //   }

  //   List<Map<String, dynamic>> parsedPlaces = placesMap.entries.map((entry) {
  //     return {entry.key: entry.value};
  //   }).toList();

  //   return parsedPlaces;
  // }

  Future<void> postData() async {
    String apiUrl =
        'https://partners.api.skyscanner.net/apiservices/v3/flights/indicative/search';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'x-api-key': GlobalVar.apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "query": {
          "market": "UK",
          "locale": "en-GB",
          "currency": "GBP",
          "queryLegs": [
            {
              "originPlace": {
                "queryPlace": {"iata": origin}
              },
              "destinationPlace": {
                "queryPlace": {"iata": destination}
              },
              "anytime": true,
              // "fixedDate": {
              //   "year": date.year,
              //   "month": date.month,
              //   "day": date.day,
              // }
            },
          ]
        }
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        flights = _parseFlightResponse(jsonDecode(response.body));
      });
    } else {
      // Handle error
      throw Exception('Failed to make a POST request');
    }
  }

  List<Map<String, dynamic>> _parseFlightResponse(
      Map<String, dynamic> jsonResponse) {
    List<Map<String, dynamic>> parsedFlights = [];
    Map<String, dynamic>? quotes = jsonResponse['content']['results']['quotes'];

    if (quotes == null) {
      // Handle error or return an empty list
      return [];
    }

    quotes.forEach((key, value) {
      dynamic outboundLeg = value['outboundLeg'];
      dynamic minPrice = value['minPrice'];

      if (outboundLeg is Map<String, dynamic> &&
          minPrice is Map<String, dynamic>) {
        String departureTime =
            outboundLeg['departureDateTime']?.toString() ?? '';
        String amount = minPrice['amount']?.toString() ?? '';

        String originPlaceId = outboundLeg['originPlaceId']?.toString() ?? '';
        String destinationPlaceId =
            outboundLeg['destinationPlaceId']?.toString() ?? '';

        // Assuming places is a list of maps with 'iata' key
        Map<String, dynamic>? originPlace = places.firstWhere(
          (place) => place['iata'] == originPlaceId,
          orElse: () => {},
        );

        Map<String, dynamic>? destinationPlace = places.firstWhere(
          (place) => place['iata'] == destinationPlaceId,
          orElse: () => {},
        );

        String originIata = originPlace['iata']?.toString() ?? '';
        String destinationIata = destinationPlace['iata']?.toString() ?? '';

        parsedFlights.add({
          'departureTime': departureTime.toString(),
          'amount': amount,
          'originIata': originIata,
          'destinationIata': destinationIata,
        });
      }
    });

    return parsedFlights;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: originController,
              onTap: () async {
                final String? selectedIata = await showSearch<String?>(
                  context: context,
                  delegate: PlaceSearchDelegate(places),
                );
                if (selectedIata != null) {
                  setState(() {
                    originController.text = selectedIata;
                    origin = selectedIata;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Origin'),
            ),
            TextField(
              controller: destinationController,
              onTap: () async {
                final String? selectedIata = await showSearch<String?>(
                  context: context,
                  delegate: PlaceSearchDelegate(places),
                );
                if (selectedIata != null) {
                  setState(() {
                    destinationController.text = selectedIata;
                    destination = selectedIata;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Destination'),
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025),
                );
                if (pickedDate != null && pickedDate != date) {
                  setState(() {
                    date = pickedDate;
                  });
                }
              },
              child: Text(
                  'Select Date: ${date.toLocal().toString().substring(0, 11)}'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                postData();
                // Implement further logic based on the response if needed
              },
              child: const Text('Search Flights'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: flights.length,
                itemBuilder: (context, index) {
                  return FlightListItem(
                    departureTime: flights[index]['departureTime'],
                    amount: flights[index]['amount'],
                    originIata: flights[index]['originIata'],
                    destinationIata: flights[index]['destinationIata'],
                    onBookPressed: () {
                      // Implement book button logic here
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlightListItem extends StatelessWidget {
  final String departureTime;
  final String amount;
  final String originIata;
  final String destinationIata;
  final VoidCallback onBookPressed;

  const FlightListItem({
    super.key,
    required this.departureTime,
    required this.amount,
    required this.originIata,
    required this.destinationIata,
    required this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Departure Time: $departureTime'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount: $amount'),
          Text('Origin IATA: $originIata'),
          Text('Destination IATA: $destinationIata'),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: onBookPressed,
        child: const Text('Book'),
      ),
    );
  }
}

class PlaceSearchDelegate extends SearchDelegate<String?> {
  final List<Map<String, dynamic>> places;

  PlaceSearchDelegate(this.places);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<Map<String, dynamic>> searchResults = query.isEmpty
        ? places
        : places
            .where((place) =>
                place["iata"].toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> place = searchResults[index];
        return ListTile(
          title: Text(place["iata"]),
          subtitle: Text(place["name"]),
          onTap: () => close(context, place["iata"]),
        );
      },
    );
  }
}
