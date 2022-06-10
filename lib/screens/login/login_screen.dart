import 'package:flutter/material.dart';
import 'package:app_tcc/helpers/validators.dart';
import 'package:app_tcc/models/user_app.dart';
import 'package:app_tcc/models/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(milliseconds: 2000), vsync: this)
          ..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: SizedBox(
                height: 150,
                width: 150,
                child: Image.asset('assets/image_login.png'),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Donanja'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: /*GoogleFonts.(*/ TextStyle(
                        letterSpacing: 4,
                        fontSize: 32,
                        fontFamily: 'MrsEavesOT',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('Gestão de Vendas',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                )
              ],
            ),
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          controller: emailController,
                          enabled: !userManager.loading,
                          decoration: InputDecoration(hintText: 'E-mail'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: (email) {
                            if (!emailValid(email!)) return 'E-mail inválido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: pwController,
                          enabled: !userManager.loading,
                          decoration: InputDecoration(hintText: 'Senha'),
                          autocorrect: false,
                          obscureText: true,
                          validator: (pw) {
                            if (pw!.isEmpty || pw.length < 6) return 'Senha inválida';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: userManager.loading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      userManager.signIn(
                                        userApp: UserApp(
                                          email: emailController.text,
                                          password: pwController.text,
                                        ),
                                        onFail: (e) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(4.0)),
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  alignment: Alignment.topCenter,
                                                  children: [
                                                    Container(
                                                      height: 220,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
                                                          10,
                                                          60,
                                                          10,
                                                          10,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                'Falha ao realizar login!',
                                                                textAlign:
                                                                    TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 5),
                                                              child: Text(
                                                                '$e',
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(context)
                                                                    .pop();
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                primary: Colors
                                                                    .blueGrey.shade700,
                                                              ),
                                                              child: Text(
                                                                'Fechar',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -40,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.redAccent,
                                                        radius: 40,
                                                        child: Icon(
                                                          Icons.assistant_photo,
                                                          color: Colors.white,
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        onSuccess: () {
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              '/base', (_) => false);
                                        },
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              onSurface: Theme.of(context).primaryColor,
                            ),
                            child: userManager.loading
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Consumer<UserManager>(
                              builder: (_, userManager, __) {
                                return TextButton(
                                  onPressed: () {
                                    if (emailController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: const Text(
                                            'Insira seu e-mail para recuperação'),
                                        backgroundColor: Colors.redAccent,
                                        duration: Duration(seconds: 4),
                                      ));
                                    } else if (!emailValid(emailController.text)) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: const Text('Insira um e-mail válido'),
                                          backgroundColor: Colors.redAccent,
                                          duration: Duration(seconds: 4)));
                                    } else {
                                      userManager.recoverPass(
                                        email: emailController.text,
                                        onFail: (e) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(4.0)),
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  alignment: Alignment.topCenter,
                                                  children: [
                                                    Container(
                                                      height: 180,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
                                                          10,
                                                          50,
                                                          10,
                                                          10,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.center,
                                                          children: [
                                                            Flexible(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal: 8),
                                                                child: Text(
                                                                  '${e}',
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(context)
                                                                    .pop();
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                primary: Colors
                                                                    .blueGrey.shade700,
                                                              ),
                                                              child: Text(
                                                                'Fechar',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -30,
                                                      child: CircleAvatar(
                                                        backgroundColor: Theme.of(context)
                                                            .primaryColor,
                                                        radius: 30,
                                                        child: Icon(
                                                          Icons.no_encryption_outlined,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        onSuccess: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(4.0)),
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  alignment: Alignment.topCenter,
                                                  children: [
                                                    Container(
                                                      height: 180,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
                                                          10,
                                                          50,
                                                          10,
                                                          10,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.center,
                                                          children: [
                                                            Flexible(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal: 8),
                                                                child: Text(
                                                                  'E-mail de recuperação enviado',
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(context)
                                                                    .pop();
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                primary: Colors
                                                                    .blueGrey.shade700,
                                                              ),
                                                              child: Text(
                                                                'Fechar',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -30,
                                                      child: CircleAvatar(
                                                        backgroundColor: Theme.of(context)
                                                            .primaryColor,
                                                        radius: 30,
                                                        child: Icon(
                                                          Icons.email_outlined,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Colors.black,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    'Esqueci minha senha',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                            )),
                        Align(
                          heightFactor: 0.5,
                          alignment: Alignment.center,
                          child: Consumer<UserManager>(
                            builder: (_, userManager, __) {
                              return TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/signup');
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.black,
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'Cadastre-se',
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
