## Quick orientation

This is a Flutter mobile app (also builds desktop) that uses Firebase (Auth, Firestore, Storage) and Cloudinary for image handling. The UI is Flutter-only (no state-management packages); screens live under `lib/views/screens` and a simple `Bottomnavbar` (IndexedStack) controls primary navigation.

## How the app is structured (big picture)
- Entry: `lib/main.dart` — initializes Firebase (`firebase_options.dart`) and Cloudinary (`Cloudinary.fromCloudName(...)`).
- UI: `lib/views/screens/*` contains individual screens (e.g. `homescreen.dart`, `loginScreen.dart`, `profilescreen.dart`, `addnotescreen.dart`, `editprofilescreen.dart`).
- Navigation: `lib/views/bottom_nav_bar/bottomNavBar.dart` uses an `IndexedStack` for main tabs and `Navigator.push` for modal screens.
- Data: Firestore is used directly with `FirebaseFirestore.instance`. User documents live in `users/{uid}` and notes are stored under `users/{uid}/notes` subcollections.

## Key integrations and where to look
- Firebase core/auth/firestore/storage: configured in `pubspec.yaml` and initialized in `lib/main.dart`.
- Cloudinary: `Cloudinary.fromCloudName(cloudName: 'dabaru8co')` is called in `main.dart` (look here to change cloud name or to centralize config).
- Google Sign-In flow: `lib/views/screens/loginScreen.dart` — after successful sign-in it creates a user doc in `users/{uid}` with fields: `Fullname`, `Email`, `uid`, `Profile Picture`, `createdAt`.
- Notes creation: `lib/views/screens/addnotescreen.dart` — writes to `users/{uid}/notes` with `title`, `description`, `createdAt`.

## Developer workflows / common commands
- Install deps: `flutter pub get`
- Run (mobile): `flutter run` (use device selector or `-d <device>`). On Windows desktop: `flutter run -d windows`.
- Build APK: `flutter build apk`
- If Firebase options are missing or changed, re-run `flutterfire configure` locally to regenerate `firebase_options.dart` (this repo expects `lib/firebase_options.dart`).

## Project conventions and patterns (concrete)
- UI code uses StatefulWidgets + `setState` for local state and loading flags (e.g., `_isLoading` pattern in `addnotescreen.dart`, `loginScreen.dart`).
- Error messages and user feedback use `ScaffoldMessenger.of(context).showSnackBar(...)` across screens.
- Styling: primary brand color hex `0xff6A3EA1` is used repeatedly; many buttons use `RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))`.
- Images and icons are stored under `assets/images/` and SVGs are rendered with `flutter_svg` (look for `SvgPicture.asset(...)`).

## Data model (discoverable details)
- User document path: `users/{uid}`. Typical fields seen in the code:
  - `Fullname` (string)
  - `Email` (string)
  - `uid` (string)
  - `Profile Picture` (string - URL)
  - `createdAt` (server timestamp)
- Notes path: `users/{uid}/notes/{noteId}` with fields: `title`, `description`, `createdAt` (client DateTime or server timestamp in other places).

## Common pitfalls & repo-specific TODOs (found during scan)
- Parameter mismatch: `lib/views/screens/editprofilescreen.dart` constructor requires `userProfileImage`, but `profilescreen.dart` pushes it with only `userName`. Verify and align the two to avoid runtime errors.
- Direct Firestore usage: there is no repository/DAO layer—be conservative when refactoring; update all call sites.
- No centralized theme file: colors and button styles are repeated. If you centralize them, update all `ThemeData` usages and inline styles.

## Where to start for changes
- Small UI change: edit the specific `lib/views/screens/<screen>.dart` file.
- Data model change: update Firestore reads/writes in the screens and search for keys like `'Fullname'`, `'Profile Picture'`, and `'notes'`.
- Auth changes: `lib/views/screens/loginScreen.dart` and `lib/main.dart`.

## Tests & linting
- There is a vanilla Flutter test at `test/widget_test.dart`. Run tests with `flutter test`.
- Lints: `flutter_lints` is enabled via `pubspec.yaml` and `analysis_options.yaml` exists at repo root.

## If something is missing or unclear
- The repo expects `lib/firebase_options.dart` (generated). If CI or a contributor lacks it, instruct them to run `flutterfire configure` and provide platform Firebase config.
- Ask for credentials before touching Cloudinary or Google APIs. Cloud names/keys may be hardcoded; prefer adding secrets to a secure store or environment variables.

---
If you want I can (pick one):
- add a short `CONTRIBUTING.md` with exact dev commands customized for Windows PowerShell; or
- scan for other inconsistencies (unused imports, analyzer issues) and produce a small PR that fixes the `editprofilescreen` constructor mismatch.

Please review and tell me which next step you'd like. I can update or expand any section.
