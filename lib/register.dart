import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:my_app_new/database/AuthMethods.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _email = TextEditingController();
    TextEditingController _name = TextEditingController();
    TextEditingController _pwd = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 35, top: 130),
                child: Text(
                  'Create \n Account',
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
              ),
              SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.5,
                          right: 35,
                          left: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: _name,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                ),
                                fillColor: Color.fromARGB(255, 112, 223, 243),
                                filled: true,
                                hintText: "Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _email,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                fillColor: Color.fromARGB(255, 132, 227, 216),
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _pwd,
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                fillColor: Color.fromARGB(255, 112, 223, 243),
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    String res = await AuthMethods()
                                        .createAccount(
                                            name: _name.text,
                                            email: _email.text,
                                            pwd: _pwd.text);
                                    if (res == "Success") {
                                      ShowMessage(
                                          context, "Account created success");
                                    }
                                    Navigator.pushNamed(context, 'login');
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff4c505b),
                                    ),
                                  )),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {},
                                  icon: Icon(Icons.arrow_back),
                                ),
                              )
                            ],
                          ),
                        ],
                      ))),
            ],
          )),
    );
  }

  void ShowMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Response message"),
          content: Text(message),
        );
      },
    );
  }
}
