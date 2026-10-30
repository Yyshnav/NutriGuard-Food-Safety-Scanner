
from django.db import models


class logintable(models.Model):
    username = models.CharField(max_length=100, null=True, blank=True)
    password = models.CharField(max_length=100, null=True, blank=True)
    user_type=models.CharField(max_length=100,null=True,blank=True)


class usertable(models.Model):
    name = models.CharField(max_length=100, null=True, blank=True)
    age = models.IntegerField(null=True, blank=True)
    gender = models.CharField(max_length=100, null=True, blank=True)
    email = models.CharField(max_length=100, null=True, blank=True)
    height = models.CharField(max_length=100, null=True, blank=True)
    weight = models.CharField(max_length=100, null=True, blank=True)
    bmi = models.CharField(max_length=100, null=True, blank=True)
    health_condition=models.CharField(max_length=100,null=True,blank=True)
    food_allergies=models.CharField(max_length=100,null=True,blank=True)
    login_id = models.ForeignKey(logintable,on_delete=models.CASCADE)



class packetfoodtable(models.Model):
    product_name = models.CharField(max_length=100, null=True, blank=True)
    brand = models.CharField(max_length=100, null=True, blank=True)
    category = models.CharField(max_length=100, null=True, blank=True)
    barcode = models.CharField(max_length=100, null=True, blank=True)
    ingredient = models.CharField(max_length=255, null=True, blank=True)
    image_url = models.ImageField(upload_to='products/', null=True, blank=True)


class complaintstable(models.Model):
    user_id = models.ForeignKey(usertable,on_delete=models.CASCADE)
    subject = models.TextField(null=True, blank=True)
    description=models.TextField(null=True, blank=True)
    reply = models.TextField(null=True, blank=True)
    send_date = models.DateTimeField(null=True, blank=True)
    reply_date = models.DateTimeField(null=True, blank=True)


class ratingtable(models.Model):
    user_id = models.ForeignKey(usertable,on_delete=models.CASCADE)
    rating = models.IntegerField(null=True, blank=True)
    send_date = models.DateTimeField(null=True, blank=True)
    review= models.TextField(null=True, blank=True)


class memberstable(models.Model):
    user_id = models.ForeignKey(usertable,on_delete=models.CASCADE,null=True,blank=True)
    relationship=models.CharField(max_length=100, null=True, blank=True)
    name = models.CharField(max_length=100, null=True, blank=True)
    age = models.IntegerField(null=True, blank=True)
    gender = models.CharField(max_length=100, null=True, blank=True)
    height = models.CharField(max_length=100, null=True, blank=True)
    weight = models.CharField(max_length=100, null=True, blank=True)
    bmi = models.CharField(max_length=100, null=True, blank=True)
    health_status = models.CharField(max_length=100, null=True, blank=True, default='Normal')
    conditions = models.TextField(null=True, blank=True)
    pregnancy_month = models.CharField(max_length=50, null=True, blank=True)
    trimester = models.CharField(max_length=50, null=True, blank=True)
    pregnancy_issues = models.TextField(null=True, blank=True)
    food_allergies=models.CharField(max_length=100, null=True, blank=True)


class bmitable(models.Model):
    user_id = models.ForeignKey(usertable,on_delete=models.CASCADE,null=True,blank=True)
    height = models.CharField(max_length=100, null=True, blank=True)
    weight = models.CharField(max_length=100, null=True, blank=True)
    bmi = models.CharField(max_length=100, null=True, blank=True)
    recorded_time = models.DateTimeField(auto_now_add=True)


class historytable(models.Model):
    user_id = models.ForeignKey(usertable,on_delete=models.CASCADE,null=True,blank=True)
    product_id = models.ForeignKey( packetfoodtable,on_delete=models.CASCADE,null=True, blank=True)
    health_score = models.IntegerField(null=True, blank=True)
    scanned_date = models.DateTimeField(auto_now_add=True)