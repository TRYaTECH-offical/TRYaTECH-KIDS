import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatelessWidget {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TRYaTECH KIDS"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMotivationSection(),
            Divider(),
            _buildShirtSection(),
            Divider(),
            _buildSoundSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationSection() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('motivations').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final docs = snapshot.data!.docs;
        return Column(
          children: docs.map((doc) {
            return ListTile(
              title: Text(doc['quote']),
              subtitle: Text(doc['author']),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildShirtSection() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('shirts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final docs = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Shirts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...docs.map((doc) {
              return Card(
                child: Column(
                  children: [
                    Image.network(doc['image'], height: 120),
                    Text(doc['name']),
                    Text('\$${doc['price']}'),
                    Text("Sizes: ${(doc['sizes'] as List).join(", ")}"),
                    ElevatedButton(
                      onPressed: () {
                        // You can connect this to a preorder form later
                      },
                      child: Text("Preorder"),
                    )
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildSoundSection() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('sounds').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final docs = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sounds", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...docs.map((doc) {
              return ListTile(
                title: Text(doc['title']),
                trailing: IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {
                    player.play(UrlSource(doc['url']));
                  },
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
