import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mac_store_app_flutter_vendor_app/controllers/category_controllers.dart';
import 'package:mac_store_app_flutter_vendor_app/controllers/subcategory_controller.dart';
import 'package:mac_store_app_flutter_vendor_app/models/category.dart';
import 'package:mac_store_app_flutter_vendor_app/models/subcategory.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategories;
  Future<List<Subcategory>>? futureSubcategories;
  Category? selectedCategory;
  Subcategory? selectedSubcategory;

  final ImagePicker picker = ImagePicker();

  List<File> images = [];

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  Future<void> chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      debugPrint('no Image Picked');
    } else {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  getSubcategoryByCategory(value) {
    futureSubcategories = SubcategoryController()
        .getSubCategoriesByCategoryName(value.name);
        // refresh the selected subcategory
    selectedSubcategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: images.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return index == 0
                  ? Center(
                      child: IconButton(
                        onPressed: () {
                          chooseImage();
                        },
                        icon: const Icon(Icons.add),
                      ),
                    )
                  : SizedBox(
                      width: 50,
                      height: 40,
                      child: Image.file(images[index - 1]),
                    );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter product name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Product Name',
                      hintText: 'Enter Product Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter product Price';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Product Price',
                      hintText: 'Enter Product Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter product Quantity';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Product Quantity',
                      hintText: 'Enter Product Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: FutureBuilder<List<Category>>(
                    future: futureCategories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No Category'));
                      } else {
                        return DropdownButton<Category>(
                          value: selectedCategory,
                          hint: const Text('Select Category'),
                          items: snapshot.data!.map((Category category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                            getSubcategoryByCategory(selectedCategory);
                          },
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: FutureBuilder<List<Subcategory>>(
                    future: futureSubcategories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No Subcategory'));
                      } else {
                        return DropdownButton<Subcategory>(
                          value: selectedSubcategory,
                          hint: const Text('Select Subcategory'),
                          items: snapshot.data!.map((Subcategory subcategory) {
                            return DropdownMenuItem(
                              value: subcategory,
                              child: Text(subcategory.subCategoryName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSubcategory = value;
                            });
                            getSubcategoryByCategory(selectedCategory);
                          },
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter product Description';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Product Description',
                      hintText: 'Enter Product Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    maxLines: 3,
                    maxLength: 500,
                    decoration: InputDecoration(
                      labelText: 'Enter Product Quantity',
                      hintText: 'Enter Product Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: (){
                if (_formKey.currentState!.validate()) {
                  print('Uploaded');
                } else {
                  print('Please enter all the fields');
                }
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    'Upload Product',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.7,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
