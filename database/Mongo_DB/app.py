import pymongo
# connect to MongoDB

client=pymongo.MongoClient()



#create a collection 
student=client["test_database"]





#reate a collection
tcoll=student["persons"]

#create documents

tdict={"Name":"Shrinath","Age":18,"Clg Name":"DYP"}



#add the documents
x=tcoll.insert_one(tdict)



#add the collection


