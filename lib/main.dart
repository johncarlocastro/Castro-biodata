import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BiodataPage(),
    );
  }
}

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final name = TextEditingController();
  final age = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final contact = TextEditingController();

  String gender = "Male";

  void saveBiodata() async {
    if (name.text.isEmpty ||
        age.text.isEmpty ||
        birthday.text.isEmpty ||
        address.text.isEmpty ||
        email.text.isEmpty ||
        contact.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill up all fields."),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("biodata").add({
      "name": name.text,
      "age": age.text,
      "birthday": birthday.text,
      "address": address.text,
      "email": email.text,
      "contact": contact.text,
      "gender": gender,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Biodata saved successfully!"),
      ),
    );

    name.clear();
    age.clear();
    birthday.clear();
    address.clear();
    email.clear();
    contact.clear();
  }

  Widget textField(String label, TextEditingController controller,
      IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: const Text(
          "My Biodata",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.blue,
                ),

                const SizedBox(height: 10),

                const Text(
                  "BIODATA FORM",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Please fill up your information",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 25),

                textField("Full Name", name, Icons.person_outline),

                textField("Age", age, Icons.cake_outlined),

                textField(
                  "Birthday",
                  birthday,
                  Icons.calendar_today,
                ),

                textField(
                  "Address",
                  address,
                  Icons.home_outlined,
                ),

                textField(
                  "Email",
                  email,
                  Icons.email_outlined,
                ),

                textField(
                  "Contact Number",
                  contact,
                  Icons.phone_outlined,
                ),

                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: InputDecoration(
                    labelText: "Gender",
                    prefixIcon: const Icon(Icons.people_outline),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: "Male",
                      child: Text("Male"),
                    ),
                    DropdownMenuItem(
                      value: "Female",
                      child: Text("Female"),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton.icon(
                    onPressed: saveBiodata,
                    icon: const Icon(Icons.save),
                    label: const Text(
                      "SAVE BIODATA",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
