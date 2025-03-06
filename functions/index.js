/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//const {onRequest} = require("firebase-functions/v2/https");
//const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();
const db = admin.firestore();

const API_BASE_URL = "https://www.alphavantage.co/query?function=NEWS_SENTIMENT";
const API_KEY = "DGJ51E154Y91CZ1K";

//FETCH DATA FROM NEWS API
async function fetchNews(topic) {
  try {
    const response = await axios.get(`${API_BASE_URL}&topics=${topic}&sort=LATEST&limit=50&apikey=${API_KEY}`);
    if (response.status === 200) {
      return response.data.feed || [];
    } else {
      console.error(`Error fetching ${topic} news:`, response.statusText);
      return [];
    }
  } catch (error) {
    console.error(`Error fetching ${topic} news:`, error.message);
    return [];
  }
}

// UPDATE FIRESTORE DATABASE
async function updateNewsCollection(collectionName, topic) {
  const news = await fetchNews(topic);

  // DELETE OLD DATA
  const collectionRef = db.collection(collectionName);
  const snapshot = await collectionRef.get();
  const batch = db.batch();
  snapshot.forEach((doc) => batch.delete(doc.ref));
  await batch.commit();

  // ADD NEW DATA
  const newsBatch = db.batch();
  news.forEach((newsItem) => {
    const docRef = collectionRef.doc();
    newsBatch.set(docRef, newsItem);
  });

  await newsBatch.commit();
  console.log(`Updated ${collectionName} collection with ${news.length} items.`);
}

// EVERY 4 HOURS
exports.updateNews = functions.pubsub.schedule("every 4 hours").onRun(async (context) => {
  console.log("Updating news collections...");
  await updateNewsCollection("blockchainNews", "blockchain");
  await updateNewsCollection("economyNews", "economy_monetary");
  await updateNewsCollection("financeNews", "finance");
  await updateNewsCollection("technologyNews", "technology");
  console.log("News collections updated successfully.");
});