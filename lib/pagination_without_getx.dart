import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model.dart';

import 'package:http/http.dart' as http;


class PaginationWithoutGetX extends StatefulWidget {
  PaginationWithoutGetX({Key? key}) : super(key: key);

  @override
  State<PaginationWithoutGetX> createState() => _PaginationWithoutGetXState();
}

class _PaginationWithoutGetXState extends State<PaginationWithoutGetX> {
  List<Result> result = [];
  ScrollController scrollController = ScrollController();
  bool loading = true;
  int offset = 0;

  @override
  void initState() {
    super.initState();
    fetchData(offset);
    handleNext();
  }

  void fetchData(paraOffset) async {
    setState(() {
      loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://pokeapi.co/api/v2/pokemon?offset=${paraOffset}&limit=15"));

    ModelClass modelClass = ModelClass.fromJson(jsonDecode(response.body));
    result = result + modelClass.results;
    int localOffset = offset + 15;
    setState(() {
      result;
      loading = false;
      offset = localOffset;
    });
  }

  void handleNext() {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        fetchData(offset);
      }
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Item"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Handle delete action here
                setState(() {
                  result.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    // You can implement the edit dialog here
    // For example: open a dialog to edit the item
    // You can use a form to collect new data from the user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ULANGAN EXAM "),
      ),
      body: ListView.builder(
          controller: scrollController,
          itemCount: result.length + 1,
          itemBuilder: (context, index) {
            if (index == result.length) {
              return loading
                  ? Container(
                      height: 200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                        ),
                      ),
                    )
                  : Container();
            }
            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.emoji_emotions),
                ),
                title: Text(
                  result[index].name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  result[index].url,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String newName = result[index].name;
                            String newUrl = result[index].url;
                            return AlertDialog(
                              title: Text("Edit Item"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      newName = value;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                    ),
                                    controller:
                                        TextEditingController(text: newName),
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      newUrl = value;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'URL',
                                    ),
                                    controller:
                                        TextEditingController(text: newUrl),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle update action here
                                    setState(() {
                                      result[index].name = newName;
                                      result[index].url = newUrl;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Update"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, index);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
);
}
}