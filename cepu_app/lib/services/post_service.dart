import 'package:cepu_app/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _firstCollection = _database.collection(
    'first-app'
  );

  // Tambah data
  static Future<void> addPost(Post post) async {
    Map<String, dynamic> newPost = {
      'image': post.image,
      'description': post.description,
      'category': post.category,
      'latitude': post.latitude,
      'longitude': post.longitude,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'user_id': post.userId,
      'userFullName': post.userFullName,
    };
    await _firstCollection.add(newPost);
  }

  // Method ubah data
  static Future<void> updatePost(Post post) async {
    Map<String, dynamic> updatePost = {
      'image': post.image,
      'description': post.description,
      'category': post.category,
      'latitude': post.latitude,
      'longitude': post.longitude,
      'created_at': post.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
      'user_id': post.userId,
      'userFullName': post.userFullName,
    };
    await _firstCollection.doc(post.id).update(updatePost);
  }

  static Future<void> deletePost(Post post) async {
    await _firstCollection.doc(post.id).delete();
  }

  static Future<QuerySnapshot> retrievePost() {
    return _firstCollection.get();
  } 

  static Stream<List<Post>> getPostList() {
    return _firstCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Post(
          id: doc.id,
          image: data['image'],
          description: data['description'],
          category: data['category'],
          createdAt: data['created_at']!= null
            ? data['created_at'] as Timestamp
            : null,
          updatedAt: data['update_at']!= null
            ? data['update_at'] as Timestamp
            : null,
          latitude: data['latitude'],
          longitude: data['longitude'],
          userId: data['user_id'],
          userFullName: data['user_full_name'],
        );
      }).toList();
    });
  }

  //1. Create function getPostListByCategory dengan parameter category
  static Stream<List<Post>> getPostListByCategory(String? category) {
    Query query = _firstCollection;
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Post(
          id: doc.id,
          image: data['image'],
          description: data['description'],
          category: data['category'],
          createdAt: data['created_at'] != null
            ? data['created_at'] as Timestamp
            : null,
          updatedAt: data['update_at'] != null
            ? data['update_at'] as Timestamp
            : null,
          latitude: data['latitude'],
          longitude: data['longitude'],
          userId: data['user_id'],
          userFullName: data['user_full_name'],
        );
      }).toList();
    });
  } 

}