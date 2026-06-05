import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharely/app/theme/app_colors.dart';
import 'package:sharely/features/auth/domain/entities/auth_entity.dart';
import 'package:sharely/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:sharely/features/dashboard/presentation/pages/dashboard_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  final int initialIndex;
  const LoginPage({super.key, this.initialIndex = 0});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late int _selectedTab;
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;
  String _selectedCountryCode = '+977'; // Default Nepal

  final List<Map<String, String>> _countryCodes = [
    {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
    {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'name': 'USA', 'flag': '🇺🇸'},
    {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
    {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialIndex;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightBlueBackground,
              AppColors.backgroundWhite,
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _buildLogo(),
                const SizedBox(height: 30),
                _buildTabBar(),
                const SizedBox(height: 30),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedTab == 0
                      ? _buildLoginForm()
                      : _buildSignupForm(),
                ),
                const SizedBox(height: 20),
                _buildDivider(),
                const SizedBox(height: 20),
                _buildSocialLogin(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 60,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.ac_unit,
            color: AppColors.primaryBlue,
            size: 60,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'SHARELY',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Color(0xFF1B4E8C),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 0 ? AppColors.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Log In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedTab == 0 ? Colors.white : AppColors.textGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 1 ? AppColors.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedTab == 1 ? Colors.white : AppColors.textGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: const ValueKey('login'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _emailController,
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            hint: 'Enter your password',
            icon: Icons.lock_outlined,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onTogglePassword: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: AppColors.primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSubmitButton('Log In', () async {
            if (_loginFormKey.currentState!.validate()) {
              final authViewModel = ref.read(authViewModelProvider.notifier);
              await authViewModel.login(
                _emailController.text,
                _passwordController.text,
              );
              
              final authState = ref.read(authViewModelProvider);
              if (authState.isSuccess && mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                );
              } else if (authState.error != null && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(authState.error!)),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        key: const ValueKey('signup'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _nameController,
            hint: 'Enter your full name',
            icon: Icons.person_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildPhoneField(),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            hint: 'Enter your password',
            icon: Icons.lock_outlined,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onTogglePassword: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _confirmPasswordController,
            hint: 'Confirm your password',
            icon: Icons.lock_outlined,
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
            onTogglePassword: () {
              setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
            },
          ),
          const SizedBox(height: 16),
          _buildTermsCheckbox(),
          const SizedBox(height: 24),
          _buildSubmitButton('Sign Up', () async {
            if (!_agreedToTerms) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please agree to the Terms & Conditions')),
              );
              return;
            }
            if (_signupFormKey.currentState!.validate()) {
              final authViewModel = ref.read(authViewModelProvider.notifier);
              await authViewModel.register(
                AuthEntity(
                  fullName: _nameController.text,
                  email: _emailController.text,
                  username: _emailController.text.split('@')[0],
                  password: _passwordController.text,
                  phoneNumber: '$_selectedCountryCode${_phoneController.text}',
                ),
              );
              
              final authState = ref.read(authViewModelProvider);
              if (authState.isSuccess && mounted) {
                setState(() {
                  _selectedTab = 0;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account created successfully! Please log in.'),
                    backgroundColor: Colors.green,
                  ),
                );
                ref.read(authViewModelProvider.notifier).resetState();
              } else if (authState.error != null && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(authState.error!)),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 125,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _selectedCountryCode,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            ),
            items: _countryCodes.map((country) {
              return DropdownMenuItem<String>(
                value: country['code'],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      country['flag']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      country['code']!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCountryCode = value!;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTextField(
            controller: _phoneController,
            hint: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) {
              setState(() {
                _agreedToTerms = value ?? false;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'I agree to the Terms & Conditions',
            style: TextStyle(color: AppColors.textGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && !isPasswordVisible,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: AppColors.iconGrey),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.iconGrey,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          if (hint.contains('email') && !value.contains('@')) {
            return 'Please enter a valid email';
          }
          if (hint.contains('password') && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        const Text(
          'Continue with',
          style: TextStyle(color: AppColors.textGrey, fontSize: 14),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(Icons.g_mobiledata, 'Google', Colors.red),
            const SizedBox(width: 20),
            _buildSocialButton(Icons.apple, 'Apple', Colors.black),
            const SizedBox(width: 20),
            _buildSocialButton(Icons.facebook, 'Facebook', Colors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label, Color color) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
