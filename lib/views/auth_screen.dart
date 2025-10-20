import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/consignment_provider.dart';
import 'history_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController(text: 'user');
  final TextEditingController _passwordController = TextEditingController(text: 'pass');
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username and password can’t be empty.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = Provider.of<ConsignmentProvider>(context, listen: false);
    final success = await provider.login(username, password);

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HistoryScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 1200;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF3F7FA), Color(0xFFDDEAF4)],
            ),
          ),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isSmallScreen ? 500 : 1000,
                maxHeight: screenSize.height * 0.85,
              ),
              margin: const EdgeInsets.all(32),
              decoration: ShapeDecoration(
                color: const Color(0xFFF3F7FC),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFF528198),
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0xFFDDEAF4).withOpacity(0.5),
                    blurRadius: 50,
                    offset: const Offset(20, 20),
                    spreadRadius: 10,
                  )
                ],
              ),
              child: isSmallScreen ? _buildSingleColumnLayout() : _buildTwoColumnLayout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTwoColumnLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: _buildAuthForm(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              decoration: ShapeDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/img.png"),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleColumnLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: _buildAuthForm(),
      ),
    );
  }

  Widget _buildAuthForm() {
    return Consumer<ConsignmentProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign in',
              style: TextStyle(
                color: Color(0xFF5D6D7E),
                fontSize: 48,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 48),
            _label('Your username'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _usernameController,
              onFieldSubmitted: (_) => _login(),
              decoration: _inputDecoration('Enter your username'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 24),
            _label('Password'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              onFieldSubmitted: (_) => _login(),
              obscureText: !_isPasswordVisible,
              decoration: _inputDecoration('Enter your password').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF528198),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.isLoading ? null : _login,
                style: _buttonStyle(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: provider.isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    key: ValueKey('loading'),
                  )
                      : const Text(
                    'Sign in',
                    key: ValueKey('text'),
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                '© 2025 CourierDesk Inc.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF5D6D7E),
        fontSize: 18,
        fontWeight: FontWeight.w200,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: const Color(0xFF1E1E1E).withOpacity(0.6),
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
      filled: true,
      fillColor: const Color(0xFFF1F4F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 1, color: Color(0xFF528198)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 1, color: Color(0xFF528198)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 2, color: Color(0xFF528198)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(width: 1, color: Color(0xFF528198)),
      ),
      backgroundColor: const Color(0xFFCADCF1),
      elevation: 5,
    );
  }
}
