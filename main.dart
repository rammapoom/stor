import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

//หน้าล๊อคอิน
class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อผู้ใช้',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'รหัสผ่าน',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // ตรวจสอบข้อมูลล็อกอิน
                  String username = _usernameController.text;
                  String password = _passwordController.text;
                  if (username == '1' && password == '1') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const StorePage()), // นำทางไปยัง StorePage
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('ข้อมูลไม่ถูกต้อง'),
                          content: const Text('ไปเเก้มาใหม่'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('ตกลง'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('เข้าสู่ระบบ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StorePageState createState() => _StorePageState();
}

//หน้าร้านค้า
class _StorePageState extends State<StorePage> {
  String _sortingOption = '';
  @override
  Widget build(BuildContext context) {
    List<Product> sortedProducts = [...products];
    if (_sortingOption == 'asc') {
      sortedProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortingOption == 'desc') {
      sortedProducts.sort((a, b) => b.price.compareTo(a.price));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('ร้านค้า'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart), //Icon ตะกรเา
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person), //Icon โปรไฟล์
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'สินค้า',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                PopupMenuButton(
                  onSelected: (String value) {
                    setState(() {
                      _sortingOption = value;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'asc',
                      child: Text('ราคา: น้อย-มาก'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'desc',
                      child: Text('ราคา: มาก-น้อย'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                sortedProducts.length,
                (index) => ProductCard(product: sortedProducts[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// เเสดงสินค้า
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product)),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageUrl,
              width: double.infinity,
              height: 150.0,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style:
                        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'ราคา: ${product.price} บาท',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 4.0),
                  ElevatedButton(
                    onPressed: () {
                      addToCart(context, product);
                    },
                    child: const Text('ซื้อสินค้า'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart(BuildContext context, Product product) {
    // เพิ่มสินค้าลงในตะกร้าสินค้า
    ShoppingCart.addItem(product);
    // แสดง Snackbar เพื่อแจ้งให้ทราบว่าได้เพิ่มสินค้าลงในตะกร้าสินค้าแล้ว
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ถูกเพิ่มลงในตะกร้าสินค้าแล้ว'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'ดูตะกร้าสินค้า',
          onPressed: () {
            double totalPrice = ShoppingCart.getTotalPrice();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ราคารวมของสินค้า: $totalPrice บาท'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}

// หนเารายละเอียดสินค้า
class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดสินค้า'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                product.imageUrl,
                width: 200,
              ),
              const SizedBox(height: 20.0),
              Text(
                'ชื่อ: ${product.name}',
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Text(
                'ราคา: ${product.price} บาท',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  addToCart(context, product);
                },
                child: const Text('ซื้อสินค้า'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addToCart(BuildContext context, Product product) {
    // เพิ่มสินค้าลงในตะกร้าสินค้า
    ShoppingCart.addItem(product);
    // แสดง Snackbar เพื่อแจ้งให้ทราบว่าได้เพิ่มสินค้าลงในตะกร้าสินค้าแล้ว
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ถูกเพิ่มลงในตะกร้าสินค้าแล้ว'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'ดูตะกร้าสินค้า',
          onPressed: () {
            double totalPrice = ShoppingCart.getTotalPrice();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ราคารวมของสินค้า: $totalPrice บาท'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String location;
  final String imageUrl;
  Product({
    required this.name,
    required this.price,
    required this.location,
    required this.imageUrl,
  });
}

final List<Product> products = [
  Product(
      name: 'สุนัข',
      price: 10,
      location: 'นครสวรรค์',
      imageUrl: 'images/dogs.jpg'),
  Product(
      name: 'เด็ก',
      price: 15,
      location: 'ปราจีนบุรี',
      imageUrl: 'images/arona.png'),
  Product(
      name: 'ทุเรียน',
      price: 45,
      location: 'ภูเก็ต',
      imageUrl: 'images/du.webp'),
  Product(
      name: 'นกอ้วน', price: 100, location: 'สระบุรี', imageUrl: 'images/fish.jpg'),
  Product(
      name: 'ถังขยะ',
      price: 1500,
      location: 'จารีโว่',
      imageUrl: 'images/bin.webp'),
  Product(
      name: 'วัตถุปริศนา',
      price: 500,
      location: 'คิโวทอส',
      imageUrl: 'images/what.webp'),
  Product(
      name: 'วิทยุ',
      price: 67,
      location: 'กาลศิลป์',
      imageUrl: 'images/tele.webp'),
  Product(
      name: 'ดอกไม้สำหรับ(เด็กที่รัก)',
      price: 90,
      location: 'ทำนบ',
      imageUrl: 'images/flo.webp'),
  Product(
      name: 'หิน',
      price: 1500,
      location: 'อินาสึมะ',
      imageUrl: 'images/MTL_SL_G3.png'),
  Product(
      name: 'ถุงเเกง',
      price: 64,
      location: 'ดาวพุด',
      imageUrl: 'images/Polyester_Pack.webp'),
];

//หน้าโปรไฟล์
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/profile_image.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'ชื่อ: ปอนด์',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'นามสกุล: เองงับ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'ออนไลน์',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('ออกจากระบบ'),
            ),
          ],
        ),
      ),
    );
  }
}

//ตะกร้าสินนค้า
class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    double totalPrice = ShoppingCart.getTotalPrice(); // รวมราคาสินค้า
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตะกร้าสินค้า'),
      ),
      body: Column(
        children: [
          const Expanded(
            child: ShoppingCart(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'รวมเป็นเงิน: $totalPrice บาท', // แสดงราคารวมทั้งหมด
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      // ปุ่มชำระเงิน
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('ชำระเงินเสร็จสิ้น'),
                content: const Text('ขอบคุณที่ใช้บริการ!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      ShoppingCart._items.clear();
                      // ล้างรายการสินค้าในตะกร้าทั้งหมดและกลับไปยังหน้าร้านค้า
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('ตกลง'),
                  ),
                ],
              );
            },
          );
        },
        child: const Text('ชำระเงิน'),
      ),
    );
  }
}

//หน้าตะกร้า
class ShoppingCart extends StatefulWidget {
  static final List<Product> _items = [];
  static final Map<Product, int> _itemCountMap = {};

  const ShoppingCart({super.key});

  static void addItem(Product product) {
    if (_itemCountMap.containsKey(product)) {
      _itemCountMap[product] = _itemCountMap[product]! + 1;
    } else {
      _items.add(product);
      _itemCountMap[product] = 1;
    }
  }

  static void removeItem(Product product) {
    if (_itemCountMap.containsKey(product)) {
      _itemCountMap[product] = _itemCountMap[product]! - 1;
      if (_itemCountMap[product] == 0) {
        _items.remove(product);
        _itemCountMap.remove(product);
      }
    }
  }

  static double getTotalPrice() {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * _itemCountMap[item]!;
    }
    return total;
  }

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingCartState createState() => _ShoppingCartState();
}

//สินค้าในตะกร้า
class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ShoppingCart._items.length,
      itemBuilder: (context, index) {
        final product = ShoppingCart._items[index];
        final itemCount = ShoppingCart._itemCountMap[product]!;
        return ListTile(
          leading: Image.network(
            product.imageUrl,
            width: 50,
            height: 50,
          ),
          title: Text(product.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ราคา: ${product.price} บาท'),
              Text('จำนวน: $itemCount'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    ShoppingCart.removeItem(product);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    ShoppingCart.addItem(product);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}