import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() async {
  runApp(const BloodDonorRegistrationApp());
}

class BloodDonorRegistrationApp extends StatelessWidget {
  const BloodDonorRegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donor Registration',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 249, 249, 247),
        ),
      ),
      home: BloodDonorRegistrationForm(),
    );
  }
}

class BloodDonorRegistrationForm extends StatefulWidget {
  @override
  _BloodDonorRegistrationFormState createState() =>
      _BloodDonorRegistrationFormState();
}

class _BloodDonorRegistrationFormState
    extends State<BloodDonorRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _usn = '';
  String _email = '';
  int _age = 0;
  String _gender = '';
  String _bloodGroup = '';
  String _mobile = '';
  String _additionalMobile = '';
  String _address = '';
  String _pinCode = '';
  String _donatedBefore = '';
  int _numberOfDonations = 0;
  DateTime? _lastDateOfDonation;
  String _medicalCondition = '';
  String _drinkingOrSmoking = '';
  String _experience = '';
  File? _donationPhoto;
  bool _isSubmitting = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  final List<String> _yesNoOptions = ['Yes', 'No'];

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _donationPhoto = File(image.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _lastDateOfDonation) {
      setState(() {
        _lastDateOfDonation = picked;
      });
    }
  }

  Widget _buildRadioButtonGroup(String title, List<String> options,
      String selectedOption, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 7, 96, 205)),
        ),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: selectedOption,
            onChanged: onChanged,
            activeColor: Color.fromARGB(255, 117, 37, 113),
          );
        }).toList(),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField(
      String label, Function(String?) onSaved, String validatorText,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 2, 103, 165)),
        ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            hintText: validatorText,
          ),
          onSaved: onSaved,
          validator: (value) {
            if (value!.isEmpty && validatorText.isNotEmpty) {
              return validatorText;
            }
            return null;
          },
          keyboardType: keyboardType,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 158, 54, 63),
        appBar: AppBar(
          title: Text(
            'Blood Donor Registration Form',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 119, 37, 126),
        ),
        body: Container(
          color: Color.fromARGB(255, 225, 197, 12),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField('Name of donor', (value) => _name = value!,
                      'Enter your name'),
                  _buildTextField(
                      'USN', (value) => _usn = value!, 'Eg. 1BM20CS001'),
                  _buildTextField('Email ID', (value) => _email = value!,
                      'Enter your email',
                      keyboardType: TextInputType.emailAddress),
                  _buildTextField('Donor Age',
                      (value) => _age = int.parse(value!), 'Enter your age',
                      keyboardType: TextInputType.number),
                  _buildRadioButtonGroup('Donor Gender', _genders, _gender,
                      (value) => setState(() => _gender = value!)),
                  _buildRadioButtonGroup(
                      'Donor Blood Group',
                      _bloodGroups,
                      _bloodGroup,
                      (value) => setState(() => _bloodGroup = value!)),
                  _buildTextField('Mobile Number', (value) => _mobile = value!,
                      'Enter 10 digit number',
                      keyboardType: TextInputType.phone),
                  _buildTextField(
                      'Additional Mobile Number',
                      (value) => _additionalMobile = value!,
                      'Enter 10 digit number',
                      keyboardType: TextInputType.phone),
                  _buildTextField('Address', (value) => _address = value!,
                      'Enter your address'),
                  _buildTextField('Pin Code', (value) => _pinCode = value!,
                      'Enter your pin code',
                      keyboardType: TextInputType.number),
                  _buildRadioButtonGroup(
                      'Have you donated before?',
                      _yesNoOptions,
                      _donatedBefore,
                      (value) => setState(() => _donatedBefore = value!)),
                  _buildTextField(
                      'Number of Donations',
                      (value) => _numberOfDonations = int.parse(value!),
                      'Enter number of donations',
                      keyboardType: TextInputType.number),
                  SizedBox(height: 16),
                  Text(
                    'Last Date of Donation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _lastDateOfDonation == null
                              ? 'Select Date'
                              : '${_lastDateOfDonation!.toLocal()}'
                                  .split(' ')[0],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today,
                            color: Color.fromARGB(255, 120, 32, 128)),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildRadioButtonGroup(
                      'Are you under any medical condition?',
                      _yesNoOptions,
                      _medicalCondition,
                      (value) => setState(() => _medicalCondition = value!)),
                  _buildRadioButtonGroup(
                      'Do you drink or smoke?',
                      _yesNoOptions,
                      _drinkingOrSmoking,
                      (value) => setState(() => _drinkingOrSmoking = value!)),
                  _buildTextField(
                      'Write a few lines about your blood donation experience',
                      (value) => _experience = value!,
                      'Enter your experience'),
                  SizedBox(height: 16),
                  Text(
                    'Upload Blood donation photo (for activity points)',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 115, 211)),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _donationPhoto == null
                              ? 'No file chosen'
                              : 'File chosen',
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.upload_file,
                            color: Color.fromARGB(255, 121, 30, 128)),
                        onPressed: _pickImage,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _isSubmitting
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                _isSubmitting = true;
                              });
                              // Handle form submission
                            }
                          },
                          child: Text('Submit',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ));
  }
}
