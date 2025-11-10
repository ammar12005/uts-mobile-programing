import 'package:flutter/material.dart';
import 'payment_page.dart';
import 'profile_page.dart';

class HalamanUtamaAmare extends StatefulWidget {
  const HalamanUtamaAmare({super.key});

  @override
  State<HalamanUtamaAmare> createState() => _HalamanUtamaAmareState();
}

class _HalamanUtamaAmareState extends State<HalamanUtamaAmare> {
  final Set<int> favorites = {};
  bool isGridView = true; // true = Grid View, false = List View

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Kaos Vintage1',
      'price': 175000,
      'image': 'assets/images/kaos1.jpg',
      'rating': 4.8,
    },
    {
      'name': 'Kaos Vintage2',
      'price': 125000,
      'image': 'assets/images/kaos2.jpg',
      'rating': 4.9,
    },
    {
      'name': 'Jaket Vintage',
      'price': 220000,
      'image': 'assets/images/jaket1.jpg',
      'rating': 4.7,
    },
    {
      'name': 'Hoodie Vintage',
      'price': 95000,
      'image': 'assets/images/hoodie2.jpg',
      'rating': 4.6,
    },
    {
      'name': 'Sepatu Adidas Samba',
      'price': 200000,
      'image': 'assets/images/adidas samba.jpg',
      'rating': 4.8,
    },
    {
      'name': 'Sepatu New Balance',
      'price': 150000,
      'image': 'assets/images/sepatu new balance.jpg',
      'rating': 4.5,
    },
    {
      'name': 'Celana Baggy Jeans',
      'price': 185000,
      'image': 'assets/images/baggy jeans1.jpg',
      'rating': 4.7,
    },
    {
      'name': 'Celana Cargo Baggy Jeans',
      'price': 250000,
      'image': 'assets/images/baggy jeans2.jpg',
      'rating': 4.9,
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      if (favorites.contains(index)) {
        favorites.remove(index);
      } else {
        favorites.add(index);
      }
    });
  }

  void _navigateToPayment(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF78350F), // amber-900
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.shopping_bag_rounded,
              color: const Color(0xFFFBBF24), // amber-400
              size: 28,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'AMARÉ',
                  style: TextStyle(
                    color: Color(0xFFFEF3C7), // amber-50
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Vintage & Aesthetic Finds',
                  style: TextStyle(
                    color: Color(0xFFFCD34D), // amber-300
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Toggle View Button
          IconButton(
            icon: Icon(
              isGridView ? Icons.view_list : Icons.grid_view,
              color: const Color(0xFFFDE68A),
              size: 24,
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
            tooltip: isGridView ? 'Tampilan Daftar' : 'Tampilan Grid',
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Color(0xFFFDE68A),
              size: 24,
            ),
            onPressed: () {
              // Navigate to favorites page
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: Color(0xFFFDE68A),
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF57534E), // stone-700
                    Color(0xFF92400E), // amber-800
                    Color(0xFF404040), // neutral-700
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Column(
                children: const [
                  Text(
                    '✨ Selamat Datang di AMARÉ ✨',
                    style: TextStyle(
                      color: Color(0xFFFEF3C7), // amber-50
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Temukan Gaya Unikmu dengan Koleksi Vintage Pilihan',
                    style: TextStyle(
                      color: Color(0xFFFEF3C7), // amber-100
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Products View (Grid or List)
            Padding(
              padding: const EdgeInsets.all(24),
              child: isGridView ? _buildGridView() : _buildListView(),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF171717), // neutral-900
                    Color(0xFF1C1917), // stone-900
                    Color(0xFF451A03), // amber-950
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Column(
                children: const [
                  Text(
                    'AMARÉ Thrift Shop',
                    style: TextStyle(
                      color: Color(0xFFFEF3C7), // amber-100
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sustainable Fashion • Unique Style • Affordable Luxury',
                    style: TextStyle(
                      color: Color(0xFFFCD34D), // amber-300
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '© 2024 AMARÉ. All rights reserved.',
                    style: TextStyle(
                      color: Color(0xFFFBBF24), // amber-400
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grid View (Tampilan Grid)
  Widget _buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product, index);
      },
    );
  }

  // List View (Tampilan Daftar)
  Widget _buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isFavorite = favorites.contains(index);

        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFFFEF3C7), // amber-100
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Product Image (Thumbnail)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        product['image'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.checkroom,
                              size: 40,
                              color: Colors.grey[300],
                            ),
                          );
                        },
                      ),
                    ),
                    // Vintage Badge
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD97706), // amber-600
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'VINTAGE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Color(0xFFFBBF24), // amber-400
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product['rating']}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF57534E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Product Name
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C1917), // stone-800
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Price
                      Text(
                        'Rp ${product['price']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E), // amber-700
                        ),
                      ),
                    ],
                  ),
                ),
                // Action Buttons
                Column(
                  children: [
                    // Favorite Button
                    GestureDetector(
                      onTap: () => _toggleFavorite(index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFEF3C7),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isFavorite
                              ? Colors.red
                              : const Color(0xFF57534E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Buy Button
                    ElevatedButton(
                      onPressed: () => _navigateToPayment(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF92400E), // amber-700
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Beli',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    final isFavorite = favorites.contains(index);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFEF3C7), // amber-100
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with overlay
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: Image.asset(
                    product['image'],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.checkroom,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(index),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFavorite
                            ? Colors.red
                            : const Color(0xFF57534E),
                      ),
                    ),
                  ),
                ),
                // Vintage Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD97706), // amber-600
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Text(
                      'VINTAGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Color(0xFFFBBF24), // amber-400
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product['rating']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF57534E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Product Name
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1917), // stone-800
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Price
                  Text(
                    'Rp ${product['price']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF92400E), // amber-700
                    ),
                  ),
                  const Spacer(),
                  // Buy Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _navigateToPayment(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF92400E), // amber-700
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Beli Sekarang',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
