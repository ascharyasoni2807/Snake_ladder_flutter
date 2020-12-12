import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snlgame/profiledata.dart';

class DatabaseMethods {
  String name;
  String email;
  User user;
  //DatabaseMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> getToken() async {
    return await _auth.currentUser.getIdToken();
  }

  Future<String> signInWithGoogle() async {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      assert(user.email != null);
      assert(user.displayName != null);
      name = user.displayName;
      email = user.email;
      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }
      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }

    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    print('User Signed Out');
  }

  createRoomid(String roomnumber, dynamic roomMap) {
    FirebaseFirestore.instance
        .collection("RoomId")
        .doc(roomnumber)
        .set(roomMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
