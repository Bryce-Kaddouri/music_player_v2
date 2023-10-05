import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:my_test_provider/providers/audio_files_provider.dart';
import 'package:provider/provider.dart';

import '../providers/upload_provider.dart';

class UploadPage extends StatefulWidget {
  String? idFile;
  UploadPage({super.key, this.idFile});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKeyFile = GlobalKey<FormBuilderState>();
  // global key for the form
  TextEditingController _titleController = TextEditingController();
  String _appBarTitle = '';
  PlatformFile? oldFile;

  void getTitle(String id, BuildContext context) async {
    if (context.mounted) {
      String? title =
          await context.read<AudioProvider>().getTitleById(widget.idFile!);
      if (title != null) {
        _titleController.text = title;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.idFile != null) {
      _appBarTitle = 'Update';
      getTitle(widget.idFile!, context);

      print('idFile : ${widget.idFile}');
    } else {
      _appBarTitle = 'Upload';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _formKeyFile.currentState?.dispose();
    oldFile = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
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
                if (widget.idFile == null)
                  FormBuilderFilePicker(
                    name: 'file_picker',
                    decoration: const InputDecoration(
                      labelText: 'File Picker',
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(color: Colors.redAccent),
                    ),
                    typeSelectors: [
                      TypeSelector(
                        type: FileType.custom,
                        selector: Container(
                          child: const Icon(Icons.add_circle_outline),
                        ),
                      ),
                    ],
                    maxFiles: 1,
                    previewImages: true,
                    onChanged: (val) => print(val),
                    onFileLoading: (val) {
                      print(val);
                    },
                    allowedExtensions: ['mp3'],
                  ),
                if (widget.idFile != null)
                  StreamBuilder(
                    stream: context
                        .read<UploadProvider>()
                        .getFile(widget.idFile!)
                        .snapshotEvents,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print('snapshot.data : ${snapshot.data}');
                        TaskSnapshot taskSnapshot =
                            snapshot.data as TaskSnapshot;
                        if (taskSnapshot.state == TaskState.success) {
                          oldFile = PlatformFile(
                            path:
                                '/data/user/0/com.example.my_test_provider/cache/file_picker/${widget.idFile}.mp3',
                            name: '${widget.idFile}.mp3',
                            size: taskSnapshot.totalBytes,
                          );
                          return FormBuilderFilePicker(
                            name: 'file_picker',
                            decoration: const InputDecoration(
                              labelText: 'File Picker',
                              border: OutlineInputBorder(),
                              errorStyle: TextStyle(color: Colors.redAccent),
                            ),
                            initialValue: [
                              PlatformFile(
                                path:
                                    '/data/user/0/com.example.my_test_provider/cache/file_picker/${widget.idFile}.mp3',
                                name: '${widget.idFile}.mp3',
                                size: taskSnapshot.totalBytes,
                              )
                            ],
                            typeSelectors: [
                              TypeSelector(
                                type: FileType.custom,
                                selector: Container(
                                  child: const Icon(Icons.add_circle_outline),
                                ),
                              ),
                            ],
                            maxFiles: 1,
                            previewImages: true,
                            onChanged: (val) => print(val),
                            onFileLoading: (val) {
                              print(val);
                            },
                            allowedExtensions: ['mp3'],
                          );
                        } else {
                          print('taskSnapshot.state : ${taskSnapshot.state}');
                          double progress = taskSnapshot.bytesTransferred /
                              taskSnapshot.totalBytes;
                          return Center(
                            child: CircularProgressIndicator(
                              value: progress,
                            ),
                          );
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKeyFile.currentState!.saveAndValidate()) {
                      print(_formKeyFile.currentState!.value);
                      PlatformFile file =
                          _formKeyFile.currentState!.value['file_picker'][0];
                      print('file : ${file.bytes}');
                      bool isFileUpdated = identical(file, oldFile);
                      print('file : ${file}');
                      print('oldFile : ${oldFile}');
                      print('isFileUpdated : $isFileUpdated');

                      if (widget.idFile != null) {
                        // check if file is updated

                        /*context.read<UploadProvider>().updateFile(
                              file.path!,
                              _formKeyFile.currentState!.value['titre'],
                              widget.idFile!,
                            );*/
                      } else {
                        context.read<UploadProvider>().uploadFile(
                              file.path!,
                              _formKeyFile.currentState!.value['titre'],
                            );
                      }

                      Navigator.pop(context);
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
