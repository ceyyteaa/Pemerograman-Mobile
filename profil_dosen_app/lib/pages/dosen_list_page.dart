import 'package:flutter/material.dart';
import '../models/dosen_model.dart';
import '../pages/dosen_detail_page.dart';

class DosenListPage extends StatefulWidget {
  @override
  _DosenListPageState createState() => _DosenListPageState();
}

class _DosenListPageState extends State<DosenListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Dosen> _filteredDosen = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredDosen = dummyDosen;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredDosen = dummyDosen;
      } else {
        _filteredDosen = dummyDosen.where((dosen) {
          return dosen.nama.toLowerCase().contains(_searchQuery) ||
              dosen.jabatan.toLowerCase().contains(_searchQuery) ||
              dosen.mataKuliah
                  .any((mk) => mk.toLowerCase().contains(_searchQuery));
        }).toList();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredDosen = dummyDosen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // App Bar dengan Search
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderBackground(),
              title: Text(
                'Daftar Dosen',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            backgroundColor: Color(0xFF4361EE),
            elevation: 10,
            shadowColor: Colors.black.withOpacity(0.3),
          ),

          // Search Bar
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),
          ),

          // Results Count
          if (_searchQuery.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${_filteredDosen.length} hasil ditemukan untuk "$_searchQuery"',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

          // Dosen List
          _filteredDosen.isEmpty
              ? SliverFillRemaining(
                  child: _buildEmptyState(),
                )
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final dosen = _filteredDosen[index];
                        return _buildDosenCard(context, dosen, index);
                      },
                      childCount: _filteredDosen.length,
                    ),
                  ),
                ),
        ],
      ),

      // Floating Action Button untuk refresh/action lainnya
      floatingActionButton: FloatingActionButton(
        onPressed: _clearSearch,
        backgroundColor: Color(0xFF4361EE),
        child: Icon(Icons.refresh, color: Colors.white),
        elevation: 4,
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4361EE),
            Color(0xFF3A0CA3),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background shapes
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Info stats
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.people, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    '${dummyDosen.length} Dosen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari dosen, jabatan, atau mata kuliah...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildDosenCard(BuildContext context, Dosen dosen, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: dosen.color.withOpacity(0.2),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _navigateToDetail(context, dosen, index);
          },
          onLongPress: () {
            _showQuickActions(context, dosen);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar dengan nomor urut
                Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [dosen.color, dosen.color.withOpacity(0.7)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: dosen.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          dosen.foto,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: dosen.color, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: dosen.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),

                // Info Dosen
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama dan Status
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              dosen.nama,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),

                      // Jabatan
                      Text(
                        dosen.jabatan,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),

                      // Mata Kuliah
                      Wrap(
                        spacing: 6,
                        children: [
                          ...dosen.mataKuliah.take(2).map((mk) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: dosen.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  mk,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: dosen.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )),
                          if (dosen.mataKuliah.length > 2)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '+${dosen.mataKuliah.length - 2}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Button dan Arrow
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.email,
                        color: dosen.color,
                        size: 20,
                      ),
                      onPressed: () {
                        _showContactOptions(context, dosen);
                      },
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off,
          size: 80,
          color: Colors.grey[300],
        ),
        SizedBox(height: 16),
        Text(
          'Tidak ada hasil ditemukan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Coba dengan kata kunci yang berbeda',
          style: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _clearSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4361EE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text('Tampilkan Semua Dosen'),
        ),
      ],
    );
  }

  void _navigateToDetail(BuildContext context, Dosen dosen, int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DosenDetailPage(dosen: dosen),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  void _showQuickActions(BuildContext context, Dosen dosen) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Aksi Cepat - ${dosen.nama.split(',')[0]}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildActionItem(
                context,
                Icons.email,
                'Kirim Email',
                dosen.color,
                () {
                  Navigator.pop(context);
                  // Implement email functionality
                },
              ),
              _buildActionItem(
                context,
                Icons.phone,
                'Hubungi',
                dosen.color,
                () {
                  Navigator.pop(context);
                  // Implement call functionality
                },
              ),
              _buildActionItem(
                context,
                Icons.share,
                'Bagikan Profil',
                dosen.color,
                () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Tutup'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String title,
      Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showContactOptions(BuildContext context, Dosen dosen) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hubungi ${dosen.nama.split(',')[0]}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dosen.email,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(dosen.phone),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Implement contact action
              },
              child: Text('Kirim Email'),
            ),
          ],
        );
      },
    );
  }
}
