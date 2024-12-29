import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> getDataPayType = <String>[
    "Commdity",
    "Cash",
    "Share",
    "Gold",
  ];
  List<String> getDataContainerSize = <String>[
    "40'Standard",
    "48'Medium",
    "58'Large",
    "70'Extra Large",
  ];

  //api serach data store on here
  List originSerachData = [];
  List destinationSerachData = [];

  //
  String getDataPayTypeDropDownText = "Selecte Type";
  String getDataContainerSizeDropDownText = "Selecte Size";

  //
  TextEditingController originInput = TextEditingController();
  TextEditingController destinationInput = TextEditingController();

  //
  String? dateStore;

  //
  bool originCheckBox = false,
      destinationCheckBox = false,
      fclCheckBox = true,
      lclCheckBox = false;

  //

  Future<dynamic> originSerachAPIdata(String input) async {
    String url = "http://universities.hipolabs.com/search?name=$input&limit=20";
    dynamic uri = Uri.parse(url);
    dynamic response = await http.get(uri);
    dynamic decode = jsonDecode(response.body);
    dynamic names = decode.map((university) => university['name']).toList();
    setState(() {
      originSerachData = names;
    });
  }

  Future<dynamic> destinationSerachAPIdata(String input) async {
    String url = "http://universities.hipolabs.com/search?name=$input&limit=20";
    dynamic uri = Uri.parse(url);
    dynamic response = await http.get(uri);
    dynamic decode = jsonDecode(response.body);
    dynamic names = decode.map((university) => university['name']).toList();
    setState(() {
      destinationSerachData = names;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE6EAF8),
      appBar: widgetAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          margin:
              const EdgeInsets.only(right: 32, left: 32, top: 25, bottom: 40),
          padding:
              const EdgeInsets.only(top: 32, bottom: 32, right: 20, left: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 8.0,
                spreadRadius: -3,
                color: Color.fromARGB(255, 183, 183, 185),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TypeAheadField(
                        controller: originInput,
                        itemBuilder: (context, value) {
                          return Text(
                            value.toString(),
                          );
                        },
                        onSelected: (v) {
                          originInput.text = v;
                        },
                        debounceDuration: const Duration(milliseconds: 500),
                        suggestionsCallback: (search) async {
                          if (originInput.text.isEmpty) {
                            return null;
                          }
                          await originSerachAPIdata(originInput.text);
                          return originSerachData.where((element) {
                            return element
                                .toLowerCase()
                                .contains(search.toLowerCase());
                          }).toList();
                        },
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: false,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(right: 15, left: 15),
                              prefixIconConstraints: BoxConstraints.tight(
                                const Size(35, 35),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/image/location.png",
                                ),
                              ),
                              hintText: "Origin",
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TypeAheadField(
                        controller: destinationInput,
                        itemBuilder: (context, value) {
                          return Text(
                            value.toString(),
                          );
                        },
                        onSelected: (v) {
                          destinationInput.text = v;
                        },
                        debounceDuration: const Duration(milliseconds: 500),
                        suggestionsCallback: (search) async {
                          if (destinationInput.text.isEmpty) {
                            return null;
                          }
                          await destinationSerachAPIdata(destinationInput.text);
                          return destinationSerachData.where((element) {
                            return element
                                .toLowerCase()
                                .contains(search.toLowerCase());
                          }).toList();
                        },
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: false,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(right: 15, left: 15),
                              prefixIconConstraints: BoxConstraints.tight(
                                const Size(35, 35),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/image/location.png",
                                ),
                              ),
                              hintText: "Destination",
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: originCheckBox,
                          onChanged: (bool? value) {
                            setState(() {
                              originCheckBox = value!;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          fillColor: MaterialStateProperty.resolveWith<Color?>(
                              (states) {
                            return originCheckBox
                                ? const Color(0xff0139FF)
                                : Colors.transparent;
                          }),
                        ),
                        const Expanded(
                          child: Text(
                            "Include Nearby Origin Ports",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: destinationCheckBox,
                          onChanged: (bool? value) {
                            setState(() {
                              destinationCheckBox = value!;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          fillColor: MaterialStateProperty.resolveWith<Color?>(
                              (states) {
                            return destinationCheckBox
                                ? const Color(0xff0139FF)
                                : Colors.transparent;
                          }),
                        ),
                        const Expanded(
                          child: Text(
                            "Include Nearby Destination Ports",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton(
                        icon: getDataPayType.isEmpty
                            ? Container(
                                padding: const EdgeInsets.only(
                                    top: 16, right: 8, bottom: 16, left: 24),
                                height: 45,
                                width: 45,
                                child: const CircularProgressIndicator(),
                              )
                            : const Icon(Icons.keyboard_arrow_down_rounded),
                        padding: const EdgeInsets.only(right: 8, left: 8),
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(getDataPayTypeDropDownText),
                        items: getDataPayType.map((e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            getDataPayTypeDropDownText = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  datePickContainer(context),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Shipment Types :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Checkbox(
                    value: fclCheckBox,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          fclCheckBox = value!;
                          lclCheckBox = false;
                        } else {
                          lclCheckBox = false;
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: MaterialStateBorderSide.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          );
                        } else {
                          return const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          );
                        }
                      },
                    ),
                    fillColor: MaterialStatePropertyAll(
                      fclCheckBox == true
                          ? const Color(0xff0139FF)
                          : Colors.transparent,
                    ),
                  ),
                  const Text("FCL"),
                  const SizedBox(width: 35),
                  Checkbox(
                    value: lclCheckBox,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          lclCheckBox = value!;
                          fclCheckBox = false;
                        } else {
                          fclCheckBox = false;
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: MaterialStateBorderSide.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          );
                        } else {
                          return const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          );
                        }
                      },
                    ),
                    fillColor: MaterialStatePropertyAll(
                      lclCheckBox == true
                          ? const Color(0xff0139FF)
                          : Colors.transparent,
                    ),
                  ),
                  const Text("LCL"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(8),
                            shape: BoxShape.rectangle,
                          ),
                          child: DropdownButton(
                            icon: getDataContainerSize.isEmpty
                                ? Container(
                                    padding: const EdgeInsets.only(
                                        top: 16,
                                        right: 8,
                                        bottom: 16,
                                        left: 24),
                                    height: 45,
                                    width: 45,
                                    child: const CircularProgressIndicator(),
                                  )
                                : const Icon(Icons.keyboard_arrow_down_rounded),
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(getDataContainerSizeDropDownText),
                            items: getDataContainerSize.map((e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                getDataContainerSizeDropDownText = value!;
                              });
                            },
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 1.5,
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            color: Colors.white,
                            child: const Text(
                              'Continer Size',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(right: 15, left: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                hintText: "No Of Boxes",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(right: 15, left: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                hintText: "Weight (kg)",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      "assets/image/infocircle.png",
                      height: 15,
                      width: 15,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      "To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.",
                      maxLines: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                "Container Internal Dimensions :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const SizedBox(
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [Text("Length")],
                        ),
                        Row(
                          children: [Text("Width")],
                        ),
                        Row(
                          children: [Text("Height")],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  const SizedBox(
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "39.46ft",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("7.70ft",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        Row(
                          children: [
                            Text("7.84ft",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    height: 90,
                    child: Image.asset(
                      "assets/image/container.png",
                    ),
                  )
                ],
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  padding: const EdgeInsets.only(right: 15, left: 12),
                  style: const ButtonStyle(
                    side: MaterialStatePropertyAll(
                      BorderSide(
                        width: 1,
                        color: Color(0xff0139FF),
                      ),
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 225, 231, 255),
                    ),
                  ),
                  onPressed: () {},
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: Image.asset(
                          "assets/image/search.png",
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Search",
                        style: TextStyle(color: Color(0xff0139FF)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded datePickContainer(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: GestureDetector(
          onTap: () {
            showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050))
                .then(
              (date) {
                setState(() {
                  if (date != null) {
                    dateStore = date.toString();
                  }
                });
              },
            );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dateStore?.substring(0, 10) ?? "Choose A Date",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/image/calender.png",
                  scale: 3.5,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar widgetAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 245, 247, 255),
      title: const Text(
        "Search the best Freight Rates",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          style: const ButtonStyle(
            side: MaterialStatePropertyAll(
              BorderSide(
                width: 1,
                color: Color(0xff0139FF),
              ),
            ),
            backgroundColor: MaterialStatePropertyAll(
              Color.fromARGB(255, 210, 219, 255),
            ),
          ),
          child: const Text(
            "History",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff0139FF),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.01,
        )
      ],
    );
  }
}
