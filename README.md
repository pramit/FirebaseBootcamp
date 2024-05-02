# FirebaseBootcamp
This repository is an exploration of Firebase features for iOS apps including authentication, database, storage, security and analytics based on [Swiftful-Thinking]([url](https://github.com/SwiftfulThinking))'s tutorial.

Below are all the user authentication buttons, including ones for anonymous sign-in (it does not save unless you enter an email & password), email & password sign-in, Google sign-in and Apple sign-in.
![all sign in buttons](https://github.com/pramit/FirebaseBootcamp/assets/831278/7ed22fa5-6a89-49e0-bc90-76e0517f6f4f)

Once you log in, you can access the products list that are currently in the "Firestore" cloud storage. The product data is sourced from https://dummyjson.com/ and uploaded to the cloud. However the images are pulled from URLs, many of which no longer work (hence the "file not found" images).
![list of products](https://github.com/pramit/FirebaseBootcamp/assets/831278/1c7a7dbe-4d81-44ca-9c65-228124e43bc5)

You can sort this list of products based on price, or filter them based on product type.
![sort on price](https://github.com/pramit/FirebaseBootcamp/assets/831278/b6f9c383-d7fa-4da7-b1c0-6cf6cad33291) ![filter on product type](https://github.com/pramit/FirebaseBootcamp/assets/831278/227bff05-9534-4932-a140-04c361607641)

You can also update your user profile such as premium status (basic Boolean which gets updated in the database), preferences (array kept in database), and picture (uploaded to storage). Anonymous becomes "false" if and when you create an account (email, Google or Apple).
![user profile](https://github.com/pramit/FirebaseBootcamp/assets/831278/f809564d-0ae4-4b62-be29-227c9f70ac23)

Finally there's the log out, delete account and update / password section. 
![basic user functionality](https://github.com/pramit/FirebaseBootcamp/assets/831278/2dc1bff7-fe42-41b5-9222-69ee28cfad28)

Is this the prettiest app you've ever seen? Probably not, but what's important is that it functions. 

Credit goes to [Swiftful-Thinking]([url](https://github.com/SwiftfulThinking)) for his fantastic tutorial. 
