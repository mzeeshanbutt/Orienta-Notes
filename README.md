# Orienta Notes 📝

A clean, full-stack note-taking application built with **Flutter** and **Firebase**.

This project was built to demonstrate proficiency in CRUD operations, user authentication, and real-time database management.

## 🚀 Key Features

* **🔐 Secure Authentication:** Users can Sign Up and Log In using email & password (powered by Firebase Auth).
* **☁️ Cloud Sync:** All notes are stored in Cloud Firestore, ensuring data is never lost.
* **⚡ Real-time Updates:** Notes update instantly across devices without refreshing.
* **✍️ Full CRUD:** * **C**reate new notes with titles and descriptions.
    * **R**ead notes in a clean list view.
    * **U**pdate/Edit existing notes.
    * **D**elete unwanted notes.

## 🛠️ Tech Stack

* **Frontend:** Flutter (Dart)
* **Backend:** Firebase Console
* **Database:** Cloud Firestore
* **Authentication:** Firebase Auth
* **State Management:** StatefulWidget / SetState (Planned migration to Provider/Riverpod)

## 📱 How to Run This App

Since this project relies on Firebase, you need to connect it to your own project first.

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/your-username/firenotes.git](https://github.com/your-username/firenotes.git)
    cd firenotes
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Firebase Configuration**
    * Ensure you have the FlutterFire CLI installed.
    * Run the configuration command to link your Firebase project:
    ```bash
    flutterfire configure
    ```

4.  **Run the App**
    * Connect your device (or use Emulator).
    * Run:
    ```bash
    flutter run
    ```

## 🗺️ Roadmap (Future Improvements)

* [ ] **Dark Mode:** Implement theme switching for better night-time usage.
* [ ] **Search:** Ability to search through notes.
* [ ] **Categories:** Filter notes by tags (Work, Personal, Ideas).
* [ ] **Google Sign-In:** Add social authentication.

## 🤝 Contributing

This is a personal practice project, but suggestions are welcome!
1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📧 Contact

**Zeeshan** - [Your LinkedIn Profile Link Here]

Project Link: [https://github.com/your-username/firenotes](https://github.com/your-username/firenotes)