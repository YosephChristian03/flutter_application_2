import 'package:flutter/material.dart';

void main() {
  runApp(const TokoBungaApp());
}

class TokoBungaApp extends StatelessWidget {
  const TokoBungaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toko Bunga Mekar Jaya',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('Username atau Password tidak boleh kosong!');
      return;
    }

    if (password.length < 8) {
      _showErrorDialog('Password harus lebih dari 8 karakter!');
      return;
    }

    if (username == 'admin' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductManagementScreen()),
      );
    } else {
      _showErrorDialog('Username atau Password salah!');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gagal Login'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Login')),
      body: Container(
        color: Colors.green.shade50,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Masukkan username Anda',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Masukkan password Anda',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final List<Product> _products = [];

  void _addProduct(Product product) {
    setState(() {
      _products.add(product);
    });
  }

  void _editProduct(int index, Product product) {
    setState(() {
      _products[index] = product;
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _showProfileDialog(BuildContext context) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Update Password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: const InputDecoration(
                labelText: 'Password Lama',
                hintText: 'Masukkan Password lama',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'Password Baru *minimal 8 karakter',
                hintText: 'Masukkan Password baru',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                hintText: 'Konfirmasi Password baru',
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (newPasswordController.text != confirmPasswordController.text) {
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('Kesalahan'),
                  content: Text('Password baru dan konfirmasi password tidak cocok!'),
                ),
              );
              return;
            }
            // Simpan perubahan password
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Produk')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.production_quantity_limits),
              title: const Text('Produk'),
              onTap: () {
                Navigator.pop(context); // Tutup Drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context); // Tutup Drawer
                _showProfileDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Tutup Drawer
                _logout(); // Proses logout
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.green.shade50,
        child: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return Card(
              child: ListTile(
                title: Text(product.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Harga: Rp${product.price}'),
                    Text('Deskripsi: ${product.description}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showProductDialog(context, product, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteProduct(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showProductDialog(BuildContext context, [Product? product, int? index]) {
    final TextEditingController nameController = TextEditingController(text: product?.name);
    final TextEditingController priceController = TextEditingController(text: product?.price.toString());
    final TextEditingController descriptionController = TextEditingController(text: product?.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'Tambah Produk' : 'Edit Produk'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Bunga'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newProduct = Product(
                name: nameController.text,
                price: double.tryParse(priceController.text) ?? 0,
                description: descriptionController.text,
              );

              if (product == null) {
                _addProduct(newProduct);
              } else {
                _editProduct(index!, newProduct);
              }

              Navigator.pop(context);
            },
            child: Text(product == null ? 'Simpan' : 'Update'),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String description;

  Product({required this.name, required this.price, required this.description});
}