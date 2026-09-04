import 'package:flutter/material.dart';
import 'clinic_home_screen.dart';

class ClinicSigninScreen extends StatefulWidget {
  const ClinicSigninScreen({super.key});

  @override
  State<ClinicSigninScreen> createState() => _ClinicSigninScreenState();
}

class _ClinicSigninScreenState extends State<ClinicSigninScreen> {

  final _formKey = GlobalKey<FormState>();

  final emailMobileController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    emailMobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  void signIn() {

    if (_formKey.currentState!.validate()) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ClinicHomeScreen(),
        ),
      );

    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F8FC),

      appBar: AppBar(
        title: const Text('Clinic Sign In'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),


      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(25),

          child: Form(

            key: _formKey,

            child: Column(

              children: [


                const SizedBox(height:30),


                const Icon(
                  Icons.local_hospital,
                  size:80,
                  color: Color(0xFF1565C0),
                ),


                const SizedBox(height:20),


                const Text(
                  "Welcome, Clinic!",
                  style: TextStyle(
                    fontSize:28,
                    fontWeight:FontWeight.bold,
                    color:Color(0xFF1565C0),
                  ),
                ),


                const SizedBox(height:40),


                TextFormField(

                  controller: emailMobileController,

                  decoration: InputDecoration(

                    labelText:"Email / Mobile Number",

                    prefixIcon: const Icon(Icons.person),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                  ),


                  validator:(value){

                    if(value==null || value.isEmpty){

                      return "Please enter email or mobile number";

                    }

                    return null;

                  },

                ),



                const SizedBox(height:20),



                TextFormField(

                  controller: passwordController,

                  obscureText: hidePassword,


                  decoration: InputDecoration(

                    labelText:"Password",

                    prefixIcon: const Icon(Icons.lock),


                    suffixIcon: IconButton(

                      icon: Icon(

                        hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility,

                      ),


                      onPressed:(){

                        setState((){

                          hidePassword=!hidePassword;

                        });

                      },

                    ),


                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(15),

                    ),

                  ),


                  validator:(value){

                    if(value==null || value.isEmpty){

                      return "Please enter password";

                    }

                    if(value.length < 6){

                      return "Password must be 6 characters";

                    }

                    return null;

                  },

                ),



                const SizedBox(height:30),



                SizedBox(

                  width:double.infinity,

                  height:58,


                  child: ElevatedButton(


                    onPressed: signIn,


                    style: ElevatedButton.styleFrom(

                      backgroundColor: const Color(0xFF1565C0),

                      foregroundColor: Colors.white,


                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(15),

                      ),

                    ),


                    child: const Text(

                      "Sign In",

                      style:TextStyle(

                        fontSize:18,

                        fontWeight:FontWeight.bold,

                      ),

                    ),

                  ),

                ),



                const SizedBox(height:20),



                TextButton(

                  onPressed:(){},

                  child: const Text(

                    "Forgot Password?",

                    style:TextStyle(

                      color:Color(0xFF1565C0),

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