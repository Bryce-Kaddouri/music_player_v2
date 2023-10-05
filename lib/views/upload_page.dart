import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:provider/provider.dart';

import '../providers/upload_provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKeyFile = GlobalKey<FormBuilderState>();
  // global key for the form
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: FormBuilder(
            key: _formKeyFile,
            child: Column(
              children: [
                SizedBox(height: 20),
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.always,
                  name: 'titre',
                  decoration: InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                    errorStyle: const TextStyle(color: Colors.redAccent),
                  ),
                  controller: _titleController,
                  // valueTransformer: (text) => num.tryParse(text),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.match(r"^[a-zA-Z0-9]*$",
                        errorText: 'Invalid Title'),
                  ]),
                  // initialValue: '12',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                FormBuilderFilePicker(
                  name: 'file_picker',
                  decoration: const InputDecoration(
                    labelText: 'File Picker',
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.redAccent),
                  ),
                  typeSelectors: [
                    TypeSelector(
                        type: FileType.audio,
                        selector: Container(
                          child: const Icon(Icons.add_circle_outline),
                        )),
                  ],
                  maxFiles: 1,
                  previewImages: true,
                  onChanged: (val) => print(val),
                  onFileLoading: (val) {
                    print(val);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKeyFile.currentState!.saveAndValidate()) {
                      print(_formKeyFile.currentState!.value);
                      PlatformFile file =
                          _formKeyFile.currentState!.value['file_picker'][0];
                      print(file.name);
                      print(file.size);
                      print(file.extension);
                      print(file.path);

                      context.read<UploadProvider>().uploadFile(
                            file.path!,
                            _formKeyFile.currentState!.value['titre'],
                          );

                      Navigator.pop(context);

                      /*Stream<TaskSnapshot> task = uploadProvider.uploadFile(
                        _formKeyFile.currentState!.value['file_picker'][0],
                        _formKeyFile.currentState!.value['titre'],
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: StreamBuilder<TaskSnapshot>(
                            stream: task,
                            builder: (BuildContext context,
                                AsyncSnapshot<TaskSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                final TaskSnapshot? taskSnapshot =
                                    snapshot.data;
                                final double progress =
                                    taskSnapshot!.bytesTransferred.toDouble() /
                                        taskSnapshot.totalBytes.toDouble();
                                return LinearProgressIndicator(value: progress);
                              } else {
                                return const Text('Starting...');
                              }
                            },
                          ),
                        ),
                      );
                      Navigator.pop(context);*/
                    } else {
                      print(_formKeyFile.currentState!.value);
                      print('validation failed');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
