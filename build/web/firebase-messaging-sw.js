importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDuIjO-HDxSmeqGfHqNavlIjanPEZ2sCpw",
  authDomain: "radwan-shop.firebaseapp.com",
  projectId: "radwan-shop",
  storageBucket: "radwan-shop.appspot.com",
  messagingSenderId: "401338416234",
  appId: "1:401338416234:web:7bbf31f45940c4b3c0de13",
  measurementId: "G-K4HL5FZGEQ"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});