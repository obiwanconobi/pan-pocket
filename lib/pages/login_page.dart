import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pan_pocket/helpers/screen_helper.dart';
import 'package:pan_pocket/main.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  late final TextEditingController _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;
  late final TextEditingController _email2Controller = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  ScreenHelper screenHelper = ScreenHelper();
  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });



      var loginResponse = await supabase.auth.signInWithOtp(
        email: _emailController.text.trim(),
        emailRedirectTo:
        kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your email for a login link!')),
        );
        _emailController.clear();
      }
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _login()async{
    try {
      setState(() {
        _isLoading = true;
      });
      var response = await supabase.auth.signInWithPassword(
          email: _email2Controller.text.trim(),
          password: _passwordController.text.trim()
      );

      if(response.user == null){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Failed')),
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Success')),
        );
      }

    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {



    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;

        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(title: const Text('Sign In'), centerTitle: true,  leading: null),
        body:
        Container(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width:  screenHelper.screenWidthMoreThanHeight(context) ? 30.w : 100.w,
            child: Padding(
              padding: screenHelper.screenWidthMoreThanHeight(context) ? EdgeInsets.fromLTRB(2.w, 0, 2.w, 0) : EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                //padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                children: [
                  //Image.network('https://zhxydjehcrgxvhvlsqvl.supabase.co/storage/v1/object/public/paninvoice_images/landing-page/ic_launcher.png', fit: BoxFit.cover, height: 200, width: 200),
                  const Text('Sign in via the magic link with your email below'),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    child: Text(_isLoading ? 'Loading' : 'Send Magic Link'),
                  ),
                  const SizedBox(height: 18),
                  const Text('Sign in via email and Password'),
                  TextFormField(
                    controller: _email2Controller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: Text(_isLoading ? 'Loading' : 'Login'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}