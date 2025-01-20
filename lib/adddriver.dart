import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  _AddDriverScreenState createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _telNumberController = TextEditingController();
  final TextEditingController _nidController =
      TextEditingController(); // New Controller
  String _selectedWork = 'hospital'; // Default dropdown value
  bool _isLoading = false; // To track loading state

  // Function to add data to Firestore
  Future<void> _addDriverToFirestore() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        await FirebaseFirestore.instance.collection('drivers').add({
          'drivername': _driverNameController.text,
          'vehiclenumber': _vehicleNumberController.text,
          'telnumber': _telNumberController.text,
          'NID': _nidController.text, // Save National ID
          'work': _selectedWork,
        });

        setState(() {
          _isLoading = false; // Hide loading indicator
        });

        // Show success dialog
        _showAlertDialog('Success', 'Driver added successfully!');
        _formKey.currentState!.reset(); // Reset the form fields
        _driverNameController.clear();
        _vehicleNumberController.clear();
        _telNumberController.clear();
        _nidController.clear(); // Clear National ID field
        _selectedWork = 'hospital'; // Reset the dropdown
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });

        // Show error dialog
        _showAlertDialog('Error', 'Failed to add driver: $e');
      }
    }
  }

  // Function to show an alert dialog
  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Driver'),
        backgroundColor: const Color.fromARGB(255, 48, 199, 2),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/s05.jpg', // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _driverNameController,
                        decoration:
                            const InputDecoration(labelText: 'Driver Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the driver name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _vehicleNumberController,
                        decoration:
                            const InputDecoration(labelText: 'Vehicle Number'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the vehicle number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _telNumberController,
                        decoration: const InputDecoration(
                            labelText: 'Telephone Number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the telephone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nidController,
                        decoration:
                            const InputDecoration(labelText: 'National ID'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the National ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedWork,
                        items: ['hospital', 'pharmacy']
                            .map((work) => DropdownMenuItem(
                                  value: work,
                                  child: Text(work),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedWork = value!;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Work'),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                          onPressed: _addDriverToFirestore,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF30C702),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
