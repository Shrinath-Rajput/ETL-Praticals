from pymongo import MongoClient

uri = "mongodb+srv://rajputshrinath349_db_user:shrinathrajput123@cluster0.g4gxwbw.mongodb.net/?appName=Cluster0"

client = MongoClient(uri)

try:
    # connection test
    client.admin.command('ping')
    print("✅ Connected to MongoDB Atlas 🚀")

    # database + collection
    db = client["mydb"]
    collection = db["users"]

    # insert data
    collection.insert_one({"name": "Shrinath", "age": 22})

    print("✅ Data Inserted")

except Exception as e:
    print("❌ Error:", e)


# from pymongo.mongo_client import MongoClient
# uri = "mongodb+srv://rajputshrinath349_db_user:shrinathrajput123@cluster0.g4gxwbw.mongodb.net/?appName=Cluster0"
# # Create a new client and connect to the server
# client = MongoClient(uri)
# # Send a ping to confirm a successful connection
# try:
#     client.admin.command('ping')
#     print("Pinged your deployment. You successfully connected to MongoDB!")
# except Exception as e:
#     print(e)