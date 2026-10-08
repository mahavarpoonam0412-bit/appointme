import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'patient_navigation.dart';
import 'forgot_password_screen.dart';

class PatientSigninScreen extends StatefulWidget {
  const PatientSigninScreen({super.key});

  @override
  State<PatientSigninScreen> createState() => _PatientSigninScreenState();
}

class _PatientSigninScreenState extends State<PatientSigninScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool hidePassword = true;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  Future<void> signIn() async {

    if (_formKey.currentState!.validate()) {

      try {

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const PatientNavigation(),
          ),
        );


      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );

      }
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F8FC),

      appBar: AppBar(
        title: const Text(
          'Patient Sign In',
        ),
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


                Container(
                  width:90,
                  height:90,

                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.person,
                    size:55,
                    color: Color(0xFF1565C0),
                  ),
                ),


                const SizedBox(height:20),


                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize:28,
                    fontWeight:FontWeight.bold,
                    color:Color(0xFF1565C0),
                  ),
                ),


                const SizedBox(height:40),



                // EMAIL FIELD

                TextFormField(

                  controller: emailController,

                  keyboardType:
                      TextInputType.emailAddress,


                  decoration: InputDecoration(

                    labelText:"Email",

                    hintText:
                    "Enter your registered email",

                    prefixIcon:
                    const Icon(Icons.email),


                    border:
                    OutlineInputBorder(

                      borderRadius:
                      BorderRadius.circular(15),

                    ),

                  ),


                  validator:(value){

                    if(value==null ||
                    value.trim().isEmpty){

                      return "Please enter email";

                    }


                    if(!value.contains("@")){

                      return "Enter valid email";

                    }


                    return null;

                  },

                ),



                const SizedBox(height:20),



                // PASSWORD FIELD


                TextFormField(

                  controller: passwordController,

                  obscureText: hidePassword,


                  decoration: InputDecoration(

                    labelText:"Password",

                    hintText:
                    "Enter your password",


                    prefixIcon:
                    const Icon(Icons.lock),


                    suffixIcon:
                    IconButton(

                      icon: Icon(

                        hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility,

                      ),


                      onPressed:(){

                        setState((){

                          hidePassword =
                          !hidePassword;

                        });

                      },

                    ),


                    border:
                    OutlineInputBorder(

                      borderRadius:
                      BorderRadius.circular(15),

                    ),

                  ),


                  validator:(value){

                    if(value==null ||
                    value.isEmpty){

                      return "Please enter password";

                    }


                    if(value.length < 6){

                      return
                      "Password must be at least 6 characters";

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


                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      const Color(0xFF1565C0),

                      foregroundColor:
                      Colors.white,


                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(15),

                      ),

                    ),


                    child:
                    const Text(

                      "Sign In",

                      style:TextStyle(

                        fontSize:18,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                  ),

                ),



                const SizedBox(height:20),



                TextButton(

                  onPressed:(){

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder:(context)=>
                        const ForgotPasswordScreen(),

                      ),

                    );

                  },


                  child:
                  const Text(

                    "Forgot Password?",

                    style:TextStyle(

                      color:
                      Color(0xFF1565C0),

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