import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _imagePath;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  String _name = 'Muhammad Ammar Fayiz';
  String _prodi = 'Teknik Informatika';
  String _npm = '23670024';
  String _email = 'ammarr3671@gmail.com';
  String _userId = 'USER0018';
  String _semester = 'Semester 5';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    print('Loading profile data...');
    print('Name: ${prefs.getString('user_profile_name')}');
    print('NPM: ${prefs.getString('user_profile_npm')}');

    setState(() {
      _name = prefs.getString('user_profile_name') ?? 'Muhammad Ammar Fayiz';
      _prodi = prefs.getString('user_profile_prodi') ?? 'Teknik Informatika';
      _npm = prefs.getString('user_profile_npm') ?? '23670024';
      _email = prefs.getString('user_profile_email') ?? 'ammarr3671@gmail.com';
      _userId = prefs.getString('user_profile_userId') ?? 'USER0024';
      _semester = prefs.getString('user_profile_semester') ?? 'Semester 5';

      if (kIsWeb) {
        String? base64Image = prefs.getString('user_profile_image_base64');
        if (base64Image != null) {
          try {
            _webImage = base64Decode(base64Image);
          } catch (e) {
            print('Error decoding image: $e');
          }
        }
      } else {
        _imagePath = prefs.getString('user_profile_image');
      }
    });

    print('Profile loaded: $_name');
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_profile_name', _name);
    await prefs.setString('user_profile_prodi', _prodi);
    await prefs.setString('user_profile_npm', _npm);
    await prefs.setString('user_profile_email', _email);
    await prefs.setString('user_profile_userId', _userId);
    await prefs.setString('user_profile_semester', _semester);

    print('Profile saved successfully!');
    print('Name: $_name');
    print('NPM: $_npm');
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final prefs = await SharedPreferences.getInstance();

        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          final base64Image = base64Encode(bytes);
          await prefs.setString('user_profile_image_base64', base64Image);

          setState(() {
            _webImage = bytes;
          });
        } else {
          await prefs.setString('user_profile_image', image.path);

          setState(() {
            _imagePath = image.path;
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto profil berhasil diperbarui'),
              backgroundColor: Color(0xFF92400E),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil gambar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Sumber Foto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1917),
                  ),
                ),
                const SizedBox(height: 20),
                if (!kIsWeb)
                  ListTile(
                    leading: const Icon(
                      Icons.camera_alt,
                      color: Color(0xFF92400E),
                    ),
                    title: const Text('Kamera'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xFF92400E),
                  ),
                  title: const Text('Galeri'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if ((kIsWeb && _webImage != null) ||
                    (!kIsWeb && _imagePath != null))
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Hapus Foto'),
                    onTap: () async {
                      Navigator.pop(context);
                      final prefs = await SharedPreferences.getInstance();
                      if (kIsWeb) {
                        await prefs.remove('user_profile_image_base64');
                        setState(() {
                          _webImage = null;
                        });
                      } else {
                        await prefs.remove('user_profile_image');
                        setState(() {
                          _imagePath = null;
                        });
                      }
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Foto profil berhasil dihapus'),
                            backgroundColor: Color(0xFF92400E),
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _name);
    final prodiController = TextEditingController(text: _prodi);
    final npmController = TextEditingController(text: _npm);
    final emailController = TextEditingController(text: _email);
    final userIdController = TextEditingController(text: _userId);
    final semesterController = TextEditingController(text: _semester);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit Profil',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1917),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: prodiController,
                  decoration: const InputDecoration(
                    labelText: 'Program Studi',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: npmController,
                  decoration: const InputDecoration(
                    labelText: 'NPM',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: userIdController,
                  decoration: const InputDecoration(
                    labelText: 'ID Pengguna',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: semesterController,
                  decoration: const InputDecoration(
                    labelText: 'Semester',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Color(0xFF57534E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _name = nameController.text;
                  _prodi = prodiController.text;
                  _npm = npmController.text;
                  _email = emailController.text;
                  _userId = userIdController.text;
                  _semester = semesterController.text;
                });

                await _saveProfileData();

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui'),
                      backgroundColor: Color(0xFF92400E),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF92400E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage() {
    if (kIsWeb && _webImage != null) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: const Color(0xFFE8D5C4),
        backgroundImage: MemoryImage(_webImage!),
      );
    } else if (!kIsWeb && _imagePath != null) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: const Color(0xFFE8D5C4),
        backgroundImage: FileImage(File(_imagePath!)),
      );
    } else {
      return const CircleAvatar(
        radius: 60,
        backgroundColor: Color(0xFFE8D5C4),
        child: Icon(Icons.person, size: 70, color: Color(0xFF8B7355)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD4A574), Color(0xFFB8966B), Color(0xFF8B7355)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text(
                      'Profil Saya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: _buildProfileImage(),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF92400E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                _name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _prodi,
                style: const TextStyle(
                  color: Color(0xFFFEF3C7),
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildInfoCard(
                          icon: Icons.badge_outlined,
                          iconColor: const Color(0xFF92400E),
                          title: 'NPM',
                          value: _npm,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.email_outlined,
                          iconColor: const Color(0xFF92400E),
                          title: 'Email',
                          value: _email,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.person_outline,
                          iconColor: const Color(0xFF92400E),
                          title: 'ID Pengguna',
                          value: _userId,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.school_outlined,
                          iconColor: const Color(0xFF92400E),
                          title: 'Semester',
                          value: _semester,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _showEditProfileDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF92400E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Edit Profil',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              _showLogoutDialog(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF92400E),
                              side: const BorderSide(
                                color: Color(0xFF92400E),
                                width: 2,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Kembali Ke Dashboard',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFEF3C7), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF8B7355),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1C1917),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Konfirmasi Keluar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 224, 92, 3),
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun?',
            style: TextStyle(color: Color(0xFF57534E)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Color(0xFF57534E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil keluar dari akun'),
                    backgroundColor: Color.fromARGB(255, 134, 68, 27),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 132, 76, 41),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Kembali ke dashboard',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
