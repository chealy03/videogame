import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _isLoading = true;
    });

    // Validate fields
    bool hasError = false;
    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Please enter your name';
        hasError = true;
      });
    }

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
        hasError = true;
      });
    } else if (!_emailController.text.contains('@')) {
      setState(() {
        _emailError = 'Please enter a valid email';
        hasError = true;
      });
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password';
        hasError = true;
      });
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
        hasError = true;
      });
    }

    if (hasError) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Create user with email and password
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Store additional user data in Firestore
      /*await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text,
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });*/

      // Navigate to welcome page
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          _passwordError = 'The password provided is too weak';
        } else if (e.code == 'email-already-in-use') {
          _emailError = 'An account already exists for this email';
        } else if (e.code == 'invalid-email') {
          _emailError = 'Please enter a valid email address';
        } else {
          _emailError = 'An error occurred. Please try again.';
        }
      });
    } catch (e) {
      setState(() {
        _emailError = 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // Penguin image
                Image.asset(
                  'img/Gunter.gif',
                  width: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.pets,
                      size: 100,
                      color: Colors.white,
                    );
                  },
                ),
                const SizedBox(height: 60),

                // Form fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Name field
                      const SizedBox(
                        width: 275,
                        child: Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 275,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: _nameError != null
                                ? Border.all(color: Colors.red, width: 1)
                                : null,
                          ),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              border: InputBorder.none,
                              hintStyle: const TextStyle(color: Colors.grey),
                              //errorText: _nameError,
                            ),
                          ),
                        ),
                      ),
                      if (_nameError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _nameError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Email field
                      const SizedBox(
                        width: 275,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 275,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: _emailError != null
                                ? Border.all(color: Colors.red, width: 1)
                                : null,
                          ),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              border: InputBorder.none,
                              hintStyle: const TextStyle(color: Colors.grey),
                              //errorText: _emailError,
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                      if (_emailError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _emailError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Password field
                      const SizedBox(
                        width: 275,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 275,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: _passwordError != null
                                ? Border.all(color: Colors.red, width: 1)
                                : null,
                          ),
                          child: TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              border: InputBorder.none,
                              hintStyle: const TextStyle(color: Colors.grey),
                              //errorText: _passwordError,
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                      if (_passwordError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _passwordError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 32),

                      // Sign Up button
                      SizedBox(
                        width: 275,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFDE74C),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                )
                              : const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
