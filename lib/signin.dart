import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamesnl/profiledata.dart';
// import 'package:gamesnl/Helperfunctions';

class DatabaseMethods {
  String name;
  String email;
  String uid;
  User user;

  //DatabaseMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> getToken() async {
    return await _auth.currentUser.getIdToken(true);
  }


signInAnon() async {
  try {
      UserCredential result =    await _auth.signInAnonymously(); 
     User user =  result.user;
     return user;
  }catch (e ){
    print(e);
  }
}

  Future<String> signInWithGoogle() async {
    // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    print('=====================');
    print(IdTokenResult);

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    user = authResult.user;

    if (user != null) {
      bool isSignedIn = await googleSignIn.isSignedIn();
      // HelperFunctions.saveUserLoggedInSharedPreference(true);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      assert(user.email != null);
      assert(user.displayName != null);
      name = user.displayName;
      email = user.email;
      uid = user.uid;
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
}

final DatabaseMethods dbInstance = DatabaseMethods();
