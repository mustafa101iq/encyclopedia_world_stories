const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);



// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


  var notificationData;
  var allStoryData
    exports.notificationTrigger = functions.firestore.document('notifications/{notificationId}').onCreate(async (snapshot, context) => {

        if (snapshot.empty) {
            console.log('No Devices');
            return;
        }

        notificationData = snapshot.data();
        const payload = {
            notification: {
                title: notificationData.title,
                body: notificationData.content,
            },
                data: {
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
              message: "notificationData.message",
            }
        };

        try{
            admin.messaging().sendToTopic('notification', payload);
             console.log('send successful');
        }catch(err){
            console.log(err);
        }

   });

   exports.allStoryTrigger = functions.firestore.document('allStory/{storyId}').onCreate(async (snapshot, context) => {

    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }

    allStoryData = snapshot.data();
    const payload = {
        notification: {
            title: allStoryData.storyType ,
            body:"قصة جديدة بعنوان" +" "+ allStoryData.storyTitle  ,
        },
            data: {
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
          message: "allStoryData.message",
        }
    };

    try{
        admin.messaging().sendToTopic('notification', payload);
         console.log('send successful');
    }catch(err){
        console.log(err);
    }

});