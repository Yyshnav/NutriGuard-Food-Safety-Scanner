from rest_framework import serializers
from.models import *




   

class Loginserializers(serializers.ModelSerializer):
   class Meta:
       model=logintable
       fields=['username','password','user_type']

class Userseralizers(serializers.ModelSerializer):
    class Meta:
        model=usertable
        fields=['name','age','gender','email','height','weight','bmi','health_condition','food_allergies']


class Packetfoodseializers(serializers.ModelSerializer):
    class Meta:
        model=packetfoodtable
        fields=['product_name','brand','category','barcode','ingredient','image_url']


class Complaintserializers(serializers.ModelSerializer):
    class Meta:
        model = complaintstable
        fields = ['id', 'user_id', 'subject', 'description', 'reply', 'send_date', 'reply_date']


class Ratingserializers(serializers.ModelSerializer):
    class Meta:
        model = ratingtable
        fields = ['id', 'user_id', 'rating', 'send_date', 'review']

class Memberserializers(serializers.ModelSerializer):
    class Meta:
        model=memberstable
        fields=['id','name','age','gender','height','weight','bmi','health_status','food_allergies','pregnancy_issues','relationship','trimester','conditions','pregnancy_month'   ]



class Bmiserializers(serializers.ModelSerializer):
    class Meta:
        model=bmitable
        fields=['user_id','height','weight','bmi','recorded_time']

class Histroyserializers(serializers.ModelSerializer):
    class Meta:
        model=historytable
        fields=['user_id','product_id','health_score','scanned_date']

