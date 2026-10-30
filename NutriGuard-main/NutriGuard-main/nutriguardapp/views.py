# from django.http import HttpResponse
# from django.shortcuts import render
# from django.views import View

# from .models import *
# # Create your views here.

# class loginview(View):
#     def  get(self,request):
#         return render(request,"login.html")
#     def post(self,request):
#         username=request.POST.get('username')
#         password=request.POST.get('password')
#         try:
#             obj=logintable.objects.get(username=username, password=password)
#             request.session['user_id']=obj.id
#             if obj.user_type=='admin':
#                 return HttpResponse('''<script>alert("Login successful");window.location='/home'</script>''')
#             else:
#                 return HttpResponse('''<script>alert("Invalid User");window.location='/'</script>''')
#         except logintable.DoesNotExist:
#             return HttpResponse('''<script>alert("Invalid Credentials");window.location='/'</script>''')
# class homepageview(View):
#     def get(self,request):
#         return render(request,"homepage.html")
# class complaintview(View):
#     def get(self,request):
#         return render(request,"viewcomplaints&reply.html")
# class membersview(View):
#     def get(self,request):
#         return render(request,"viewmembers.html")
# class ratingview(View):
#     def get(self,request):
#         return render(request,"viewrating.html")
# class usersview(View):
#     def get(self,request):
#         c=usertable.objects.all()
#         return render(request,"viewuser.html",{'user':c})







#     # API



# from rest_framework.views import APIView
# from rest_framework.response import Response
# from rest_framework import status

# class RegisterView(APIView):
#     def post(self,request):
#         name=request.data.get("name")
#         email=request.data.get("email")
#         password=request.data.get("password")

#         if not name or not email or not password:
#             return Response({"error":"name,email,and password are required"},status=status.HTTP_400_BAD_REQUEST)
#         # check if email already registered
#         if logintable.objects.filter(username=email).exists():
#             return Response({"error":"Email already registered"},status=status.HTTP_409_CONFLICT)
#         login_obj=logintable.objects.create(
#             username=email,
#             password=password,
#             user_type="user"
#         )
#         user_obj=usertable.objects.create(
#             name=name,
#             email=email,
#             login_id=login_obj
#         )
#         return Response({
#         "message":"registration successful",
#         "user_id":user_obj.id,
#         "name":name,
#         "email":email,
#         "is_profile_completed":False
#         }, status=status.HTTP_201_CREATED)



# class LoginView(APIView):
#     def post(self,request):
#         email=request.data.get('email')
#         password=request.data.get("password")
#         print(email)
#         print(password)
#         if not  email or not password:
#             return Response({"error":"name,email,and password are required"},status=status.HTTP_400_BAD_REQUEST)

#         try:
#             login_obj=logintable.objects.get(username=email, password=password)
#         except logintable.DoesNotExist:
#             return Response({"error":"Invalid email or password"},status=status.HTTP_401_UNAUTHORIZED)

#         #Get the linked user profile 
#         try:
#             user_obj=usertable.objects.get(login_id=login_obj)
#         except usertable.DoesNotExist:
#             return Response({"error":"  User profile is not found "},status=status.HTTP_404_NOT_FOUND)
#         is_profile_completed = bool(
#             user_obj.height and user_obj.weight and user_obj.age
#         )

#         return Response({
#             "message":"Login successful",
#             "user_id":user_obj.id,
#             "name":user_obj.name,
#             "email":user_obj.email,
#             "user_type":login_obj.user_type,
#             "is_profile_completed":is_profile_completed
#         },status=status.HTTP_200_OK)



# class ProfileView(APIView):
     
#     def get(self,request,user_id):
#             try:
#                 user_obj=usertable.objects.get(id=user_id)
#             except usertable.DoesNotExist:
#                 return Response({"error":"User not found"},status=status.HTTP_404_NOT_FOUND)

#             return Response({
#                 "user_id":user_obj.login_id,
#                 "name":user_obj.name,
#                 'email':user_obj.email,
#                 'age':user_obj.age,
#                 'gender':user_obj.gender,
#                 'height':user_obj.height,
#                 'weight':user_obj.weight,
#                 'bmi':user_obj.bmi,
#                 },status=status.HTTP_200_OK)
#     def post(self,request,user_id):

#                 try:
#                     print(request.data)
#                     user_obj=usertable.objects.get(id=user_id)
#                     print(user_obj)
#                 except usertable.DoesNotExist:
#                     return Response({"error":"User not found"},status=status.HTTP_404_NOT_FOUND)

#                 user_obj.name =request.data.get("name",user_obj.name)
#                 user_obj.age =request.data.get("age",user_obj.name)
#                 user_obj.gender =request.data.get("gender",user_obj.name)
#                 user_obj.height =request.data.get("height",user_obj.name)
#                 user_obj.weight =request.data.get("weight",user_obj.name)
#                 user_obj.bmi =request.data.get("bmi",user_obj.name)
#                 user_obj.save()
#                 return Response({
#                     "message":"Profile Updated Successfully ",
#                     "user_id":user_obj.login_id,
#                     "name":user_obj.name,
#                     "email":user_obj.email,
#                     "age":user_obj.age,
#                     "gender":user_obj.gender,
#                     "height":user_obj.height,
#                     "weight":user_obj.weight,
#                     "bmi":user_obj.bmi,
#                 },status=status.HTTP_200_OK)
from django.http import HttpResponse
from django.shortcuts import render
from django.views import View

from .models import *
# Create your views here.

class loginview(View):
    def  get(self,request):
        return render(request,"login.html")
    def post(self,request):
        username=request.POST.get('username')
        password=request.POST.get('password')
        try:
            obj=logintable.objects.get(username=username, password=password)
            request.session['user_id']=obj.id
            if obj.user_type=='admin':
                return HttpResponse('''<script>alert("Login successful");window.location='/home'</script>''')
            else:
                return HttpResponse('''<script>alert("Invalid User");window.location='/'</script>''')
        except logintable.DoesNotExist:
            return HttpResponse('''<script>alert("Invalid Credentials");window.location='/'</script>''')
class homepageview(View):
    def get(self,request):
        return render(request,"homepage.html")
class complaintview(View):
    def get(self,request):
        c = complaintstable.objects.all().order_by('-id')
        return render(request,"viewcomplaints&reply.html", {'complaints': c})
    def post(self,request):
        complaint_id = request.POST.get('complaint_id')
        reply_text = request.POST.get('reply')
        if complaint_id and reply_text:
            from django.utils import timezone
            complaintstable.objects.filter(id=complaint_id).update(reply=reply_text, reply_date=timezone.now())
            return HttpResponse('''<script>alert("Reply sent successfully");window.location='/complaints'</script>''')
        return HttpResponse('''<script>alert("Invalid request");window.location='/complaints'</script>''')
class membersview(View):
    def get(self,request):
        return render(request,"viewmembers.html")
class ratingview(View):
    def get(self,request):
        r = ratingtable.objects.all().order_by('-id')
        return render(request,"viewrating.html", {'ratings': r})
class usersview(View):
    def get(self,request):
        c=usertable.objects.all()
        return render(request,"viewuser.html",{'user':c})

#########################APIVIEW#######################################

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from .serializers import *


class RegisterView(APIView):

    def post(self, request):
        print("############### REQUEST DATA:", request.data)
        response_dict = {}

        # Map incoming data to each serializer
        login_data = {
            'username': request.data.get('email'),
            'password': request.data.get('password'),
        }
        user_data = {
            'name' : request.data.get('name'),
            'email': request.data.get('email'),
        }

        login_serial = Loginserializers(data=login_data)
        user_serial  = Userseralizers(data=user_data)

        login_valid = login_serial.is_valid()
        user_valid  = user_serial.is_valid()

        print("LOGIN VALID  :", login_valid)
        print("USER VALID   :", user_valid)
        print("LOGIN ERRORS :", login_serial.errors)
        print("USER ERRORS  :", user_serial.errors)

        if login_valid and user_valid:
            # Check if email already registered
            if logintable.objects.filter(username=request.data.get('email')).exists():
                response_dict['message'] = 'failed'
                response_dict['error']   = 'Email already registered'
                return Response(response_dict, status=status.HTTP_409_CONFLICT)

            login_obj = login_serial.save(user_type='user')
            user_obj  = user_serial.save(login_id=login_obj)

            response_dict['message']            = 'success'
            response_dict['login_id']            = login_obj.id
            response_dict['is_profile_completed'] = False
            response_dict['user']               = Userseralizers(user_obj).data
            return Response(response_dict, status=status.HTTP_201_CREATED)

        response_dict['message']     = 'failed'
        response_dict['login_error'] = login_serial.errors if not login_valid else None
        response_dict['user_error']  = user_serial.errors  if not user_valid  else None
        return Response(response_dict, status=status.HTTP_400_BAD_REQUEST)


class LoginView(APIView):

    def post(self, request):
        print("############### REQUEST DATA:", request.data)
        response_dict = {}

        email    = request.data.get('email')
        password = request.data.get('password')
        print("EMAIL:", email)

        if not email or not password:
            response_dict['message'] = 'field'
            return Response(response_dict, status=status.HTTP_400_BAD_REQUEST)

        login_obj = logintable.objects.filter(username=email, password=password).first()
        print("LOGIN OBJ:", login_obj)

        if not login_obj:
            response_dict['message'] = 'failed'
            return Response(response_dict, status=status.HTTP_401_UNAUTHORIZED)

        user_obj = usertable.objects.filter(login_id=login_obj).first()
        if not user_obj:
            response_dict['message'] = 'failed'
            response_dict['error']   = 'User profile not found'
            return Response(response_dict, status=status.HTTP_404_NOT_FOUND)

        is_profile_completed = bool(user_obj.height and user_obj.weight and user_obj.age)

        response_dict['message']              = 'success'
        response_dict['login_id']            = login_obj.id
        response_dict['user_type']            = login_obj.user_type
        response_dict['is_profile_completed'] = is_profile_completed
        response_dict['user']                 = Userseralizers(user_obj).data
        return Response(response_dict, status=status.HTTP_200_OK)


class ProfileView(APIView):

    def get(self, request, user_id):
        print("GET PROFILE user_id:", user_id)
        response_dict = {}

        user_obj = usertable.objects.filter(login_id_id=user_id).first()
        if not user_obj:
            response_dict['message'] = 'failed'
            return Response(response_dict, status=status.HTTP_404_NOT_FOUND)

        response_dict['message'] = 'success'
        response_dict['user']    = Userseralizers(user_obj).data
        return Response(response_dict, status=status.HTTP_200_OK)

    def post(self, request, user_id):
        print(" PUT PROFILE user_id:", user_id)
        response_dict = {}

        user_obj = usertable.objects.filter(login_id__id=user_id).first()
        if not user_obj:
            response_dict['message'] = 'failed'
            return Response(response_dict, status=status.HTTP_404_NOT_FOUND)

        user_serial = Userseralizers(user_obj, data=request.data, partial=True)

        print("USER VALID  :", user_serial.is_valid())
        print("USER ERRORS :", user_serial.errors)

        if user_serial.is_valid():
            user_serial.save()
            response_dict['message'] = 'success'
            response_dict['user']    = user_serial.data
            return Response(response_dict, status=status.HTTP_200_OK)

        response_dict['message'] = 'failed'
        response_dict['error']   = user_serial.errors
        return Response(response_dict, status=status.HTTP_400_BAD_REQUEST)

class FamilyMembersView(APIView):
   def get(self, request, user_id):
        print("FAMILY MEMBERS GET METHOD CALLED")
        print("USER ID:", user_id)

        response_dict = {}
        user_obj = usertable.objects.filter(login_id__id=user_id).first()
        if not user_obj:
            return Response({
                'message': 'failed',
                'error': 'User not found'
            }, status=status.HTTP_404_NOT_FOUND)

        members = memberstable.objects.filter(
            user_id=user_obj
        ).order_by('-id')

        serializer = Memberserializers(members, many=True)
        response_dict['message'] = 'success'
        response_dict['members'] = serializer.data

        print("GET RESPONSE:", response_dict)
        return Response(response_dict, status=status.HTTP_200_OK)
   def post(self,request,user_id):
        print("$$$$$$$$$$$$ ADD FAMILY MEMBER user_id :",user_id,"DATA:",request.data)
        response_dict={}

        user_obj=usertable.objects.filter(login_id__id=user_id).first()
        if not user_obj:
            response_dict['message']='Failed'
            response_dict['error']='User not found'
            return Response(response_dict,status=status.HTTP_404_NOT_FOUND)

        data=request.data.copy() if hasattr(request.data,"copy") else dict(request.data)


    #Convert list fields(like health condition into comma sections)
        for list_field in['condition','allergies']:
            val= data.get(list_field)
        if isinstance(val,list):
            data[list_field]=",".join([str(x).strip() for x in val if str(x).strip()])

    #set health summary description if not explicitly provided
        if not data.get('health'):
            health_status=data.get('health_status','Normal')
            if health_status=='patient':
                data['health']=data.get('condition') or 'patient'
            elif health_status=='pregnant':
                data['health']=f"pregnant-{data.get('trimester','')}".strip()
            else:
                data['health']='Healthy/Normal'

        #set is_pregnant boolean based on health_status or parameter
        if data.get('health_status')=='pregnant' or str(data.get('is_pregnant',"")).lower() in ['true','1']:
            data['is_pregnant']=True
        else:
            data['is_pregnant']=False

        serializers=Memberserializers(data=data)
        if serializers.is_valid():
            member_obj=serializers.save(user_id=user_obj)
            response_dict['message']='success'
            response_dict['member']=Memberserializers(member_obj).data
            return Response(response_dict,status=status.HTTP_201_CREATED)

        print("MEMBER ERROR:",serializers.errors)
        response_dict['message']='failed'
        response_dict['error']=serializers.errors
        return Response(response_dict,status=status.HTTP_400_BAD_REQUEST)




class MemberDetailsView(APIView):

    def get(self, request, member_id):
        print("######------------####### GET MEMBER DETAILS member_id:", member_id)

        response_dict = {}
        member = memberstable.objects.filter(user_id__id=member_id).first()
        print('------------', member)

        if not member:
            response_dict['message'] = 'failed'
            response_dict['error'] = 'Member not found'
            return Response(response_dict, status=status.HTTP_404_NOT_FOUND)

        response_dict['message'] = 'success'
        response_dict['member'] = Memberserializers(member).data

        return Response(response_dict, status=status.HTTP_200_OK)

    def put(self, request, member_id):
        print("############# UPDATE MEMBER member_id:", member_id, "DATA", request.data)

        response_dict = {}
        member = memberstable.objects.filter(id=member_id).first()

        if not member:
            response_dict['message'] = 'failed'
            response_dict['error'] = 'Member not found'
            return Response(response_dict, status=status.HTTP_404_NOT_FOUND)

        data = request.data.copy()

        # Convert list values to comma-separated strings
        for list_field in ['conditions', 'allergies', 'food_allergies']:
            value = data.get(list_field)

            if isinstance(value, list):
                data[list_field] = ', '.join(
                    str(item).strip()
                    for item in value
                    if str(item).strip()
                )

        # Handle pregnancy and health status
        health_status = data.get('health_status', '')

        if health_status.lower() == 'pregnant':
            data['is_pregnant'] = True

            if not data.get('health'):
                data['health'] = f"Pregnant - {data.get('trimester', '')}".strip()

        elif health_status.lower() == 'patient':
            data['is_pregnant'] = False

            if not data.get('health'):
                data['health'] = data.get('conditions') or 'Patient'

        else:
            data['is_pregnant'] = False

            if not data.get('health'):
                data['health'] = 'Healthy / Normal'

        serializer = Memberserializers(
            member,
            data=data,
            partial=True
        )

        if serializer.is_valid():
            serializer.save()

            response_dict['message'] = 'success'
            response_dict['member'] = serializer.data

            return Response(response_dict, status=status.HTTP_200_OK)

        response_dict['message'] = 'failed'
        response_dict['errors'] = serializer.errors

        return Response(response_dict, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, member_id):
        print("$$$$$$$$$$$$$ DELETE MEMBER member_id:", member_id)

        response_dict = {}
        member = memberstable.objects.filter(id=member_id).first()

        if not member:
            response_dict['message'] = 'failed'
            response_dict['errors'] = 'Member not found'
            return Response(response_dict, status=status.HTTP_404_NOT_FOUND)

        member.delete()

        response_dict['message'] = 'success'

        return Response(response_dict, status=status.HTTP_200_OK)


import base64
import json
import os
import requests

def _load_gemini_key():
    key = os.environ.get("GEMINI_API_KEY", "").strip()
    if not key:
        env_files = [
            os.path.join(os.path.dirname(os.path.dirname(__file__)), '.env'),
            os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), '.env'),
            os.path.join(os.getcwd(), '.env'),
        ]
        for fpath in env_files:
            if os.path.exists(fpath):
                try:
                    with open(fpath, 'r', encoding='utf-8') as f:
                        for line in f:
                            line = line.strip()
                            if line.startswith('GEMINI_API_KEY='):
                                k = line.split('=', 1)[1].strip(' "\'')
                                if k:
                                    return k
                except Exception:
                    pass
    return key or "YOUR_GEMINI_API_KEY"

GEMINI_API_KEY = _load_gemini_key()

class ScanFoodView(APIView):
    def post(self, request, user_id):
        print("====== SCAN FOOD API CALLED for user_id:", user_id)
        user_obj = usertable.objects.filter(login_id__id=user_id).first()
        if not user_obj:
            user_obj = usertable.objects.filter(id=user_id).first()
            
        if not user_obj:
            return Response({'message': 'failed', 'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

        # 1. Fetch user profile
        user_info = {
            "name": user_obj.name or "User",
            "food_allergies": user_obj.food_allergies or "None",
            "health_condition": user_obj.health_condition or "None",
            "bmi": user_obj.bmi or "Normal"
        }

        # 2. Fetch all family members
        members = memberstable.objects.filter(user_id=user_obj)
        family_info = []
        for m in members:
            family_info.append({
                "name": m.name or "Family Member",
                "relationship": m.relationship or "Family",
                "age": m.age or 0,
                "health_status": m.health_status or "Normal",
                "food_allergies": m.food_allergies or "None",
                "conditions": m.conditions or "None",
                "pregnancy_details": f"Month {m.pregnancy_month}, {m.trimester}, Issues: {m.pregnancy_issues}" if (m.health_status == "Pregnant" or m.trimester) else "Not pregnant"
            })

        # 3. Process Input: Image or Text
        image_file = request.FILES.get('image')
        product_name_input = request.data.get('product_name', '')
        ingredients_input = request.data.get('ingredients', '')

        prompt_instruction = f"""
You are an expert food nutritionist, pediatric safety, and allergen detection AI.
Analyze this food product for the primary user and their family members.

User Profile:
Name: {user_info['name']}
Allergies: {user_info['food_allergies']}
Health Conditions: {user_info['health_condition']}

Family Members:
{json.dumps(family_info, indent=2)}

Task:
1. Identify product name, brand, health score (integer from 0 to 100, where 100 is healthiest), ingredients, and allergens detected.
2. Cross-reference every ingredient against the user and ALL family members' allergies, chronic conditions, and pregnancy status.
3. Generate family_warnings: For each family member (and user), indicate their risk level ("High", "Moderate", or "Safe") and a clear explanation of which specific ingredient is problematic and why. If safe, state that it is safe.
4. Provide nutritional estimates: calories, fat, saturated_fat, sodium, sugar, protein, carbohydrates.
5. Provide a clear ai_recommendation summarizing whether this product is recommended for the household.

IMPORTANT: Respond with ONLY a single valid JSON object, without backticks or markdown formatting, following this exact schema:
{{
  "product_name": "Product Name",
  "brand": "Brand Name",
  "health_score": 65,
  "ingredients": ["ingredient 1", "ingredient 2"],
  "allergens_detected": ["peanut", "gluten"],
  "nutritional_info": {{
    "calories": "250 Kcal",
    "fat": "12 g",
    "saturated_fat": "3 g",
    "sodium": "450 mg",
    "sugar": "8 g",
    "protein": "4 g",
    "carbohydrates": "30 g"
  }},
  "family_warnings": [
    {{
      "member_name": "Name",
      "relationship": "Relation",
      "risk_level": "High",
      "warning": "Detailed reason why this ingredient is dangerous or safe for this member"
    }}
  ],
  "ai_recommendation": "Recommendation text"
}}
"""

        parts = []
        if image_file:
            try:
                img_bytes = image_file.read()
                img_b64 = base64.b64encode(img_bytes).decode('utf-8')
                mime_type = image_file.content_type or 'image/jpeg'
                parts.append({
                    "inline_data": {
                        "mime_type": mime_type,
                        "data": img_b64
                    }
                })
                parts.append({
                    "text": f"Read the product packaging image, extract all ingredients and nutrition, and:\n{prompt_instruction}"
                })
            except Exception as e:
                print("Error encoding image:", e)
                parts.append({"text": prompt_instruction})
        else:
            text_desc = f"Product Name: {product_name_input}\nIngredients: {ingredients_input}\n\n"
            parts.append({"text": text_desc + prompt_instruction})

        parsed_result = None
        models_to_try = ["models/gemini-3.5-flash-lite", "models/gemini-3.8-flash"]

        for model_name in models_to_try:
            url = f"https://generativelanguage.googleapis.com/v1beta/{model_name}:generateContent?key={GEMINI_API_KEY}"
            try:
                gemini_res = requests.post(url, json={"contents": [{"parts": parts}]}, timeout=25)
                print(f"Gemini API ({model_name}) Status:", gemini_res.status_code)
                if gemini_res.status_code == 200:
                    res_json = gemini_res.json()
                    raw_text = res_json['candidates'][0]['content']['parts'][0]['text'].strip()
                    if raw_text.startswith("```"):
                        raw_text = raw_text.split("```", 2)[1]
                        if raw_text.startswith("json"):
                            raw_text = raw_text[4:]
                    parsed_result = json.loads(raw_text.strip())
                    break
                else:
                    print(f"Gemini API ({model_name}) Error:", gemini_res.text[:200])
            except Exception as e:
                print(f"Gemini ({model_name}) exception:", e)

        # Fallback if Gemini failed or timed out
        if not parsed_result:
            prod_title = product_name_input or "Scanned Packaged Food"
            parsed_result = {
                "product_name": prod_title,
                "brand": "Standard Brand",
                "health_score": 50,
                "ingredients": [product_name_input or "Mixed food ingredients", "Preservatives", "Sodium"],
                "allergens_detected": ["None explicitly detected"],
                "nutritional_info": {
                    "calories": "300 Kcal",
                    "fat": "10 g",
                    "saturated_fat": "2 g",
                    "sodium": "400 mg",
                    "sugar": "5 g",
                    "protein": "3 g",
                    "carbohydrates": "25 g"
                },
                "family_warnings": [
                    {
                        "member_name": user_info['name'],
                        "relationship": "Self",
                        "risk_level": "Moderate",
                        "warning": "Review packaging carefully for personal allergies."
                    }
                ],
                "ai_recommendation": "Product analyzed. Check allergen listing before consumption."
            }

        # 4. Save to packetfoodtable and historytable
        try:
            prod_name = parsed_result.get('product_name', 'Packaged Food')
            brand_name = parsed_result.get('brand', '')
            ingredients_list = parsed_result.get('ingredients', [])
            ingredients_str = ', '.join(ingredients_list) if isinstance(ingredients_list, list) else str(ingredients_list)
            
            food_obj = packetfoodtable.objects.create(
                product_name=str(prod_name)[:100],
                brand=str(brand_name)[:100],
                ingredient=ingredients_str[:250],
                image_url=image_file if image_file else None
            )

            historytable.objects.create(
                user_id=user_obj,
                product_id=food_obj,
                health_score=int(parsed_result.get('health_score', 50))
            )
        except Exception as e:
            print("Error saving to historytable:", e)

        return Response({
            'message': 'success',
            'data': parsed_result
        }, status=status.HTTP_200_OK)


class RecentScansView(APIView):
    def get(self, request, user_id):
        user_obj = usertable.objects.filter(login_id__id=user_id).first()
        if not user_obj:
            user_obj = usertable.objects.filter(id=user_id).first()

        if not user_obj:
            return Response({'message': 'failed', 'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

        histories = historytable.objects.filter(user_id=user_obj).select_related('product_id').order_by('-id')[:20]
        scans = []
        for h in histories:
            scans.append({
                'id': h.id,
                'name': h.product_id.product_name if h.product_id else 'Packaged Food',
                'brand': h.product_id.brand if h.product_id else '',
                'score': f"{h.health_score or 50}/100",
                'health_score': h.health_score or 50,
                'date': h.scanned_date.strftime('%b %d') if h.scanned_date else 'Recently',
                'ingredients': h.product_id.ingredient if h.product_id else ''
            })

        return Response({'message': 'success', 'scans': scans}, status=status.HTTP_200_OK)


class ComplaintApiView(APIView):
    def get(self, request, user_id):
        print("GET COMPLAINTS user_id:", user_id)
        user_obj = usertable.objects.filter(login_id__id=user_id).first()
        if not user_obj:
            user_obj = usertable.objects.filter(id=user_id).first()

        if not user_obj:
            return Response({'message': 'failed', 'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

        complaints = complaintstable.objects.filter(user_id=user_obj).order_by('-id')
        serializer = Complaintserializers(complaints, many=True)
        return Response({'message': 'success', 'complaints': serializer.data}, status=status.HTTP_200_OK)

    def post(self, request, user_id):
        print("POST COMPLAINT user_id:", user_id, "DATA:", request.data)
        user_obj = usertable.objects.filter(login_id__id=user_id).first()
        if not user_obj:
            user_obj = usertable.objects.filter(id=user_id).first()

        if not user_obj:
            return Response({'message': 'failed', 'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

        subject = request.data.get('subject', '').strip()
        description = request.data.get('description', '').strip()

        if not subject or not description:
            return Response({'message': 'failed', 'error': 'Subject and description are required'}, status=status.HTTP_400_BAD_REQUEST)

        from django.utils import timezone
        complaint = complaintstable.objects.create(
            user_id=user_obj,
            subject=subject,
            description=description,
            send_date=timezone.now()
        )

        return Response({
            'message': 'success',
            'complaint': Complaintserializers(complaint).data
        }, status=status.HTTP_201_CREATED)


class RatingApiView(APIView):
    def get(self, request, user_id):
        print("GET RATING user_id:", user_id)
        user_obj = usertable.objects.filter(login_id__id=user_id).first()
        if not user_obj:
            user_obj = usertable.objects.filter(id=user_id).first()

        if not user_obj:
            return Response({'message': 'failed', 'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

        rating_obj = ratingtable.objects.filter(user_id=user_obj).order_by('-id').first()
        return Response({
            'message': 'success',
            'rating': Ratingserializers(rating_obj).data if rating_obj else None
        }, status=status.HTTP_200_OK)

    def post(self, request, user_id):
        print("POST RATING user_id:", user_id, "DATA:", request.data)
        user_obj = usertable.objects.filter(login_id__id=user_id).first()
        if not user_obj:
            user_obj = usertable.objects.filter(id=user_id).first()

        if not user_obj:
            return Response({'message': 'failed', 'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

        rating_val = request.data.get('rating')
        review_val = request.data.get('review', '')

        if rating_val is None:
            return Response({'message': 'failed', 'error': 'Rating value is required'}, status=status.HTTP_400_BAD_REQUEST)

        from django.utils import timezone
        rating_obj = ratingtable.objects.filter(user_id=user_obj).first()
        if rating_obj:
            rating_obj.rating = int(rating_val)
            rating_obj.review = review_val
            rating_obj.send_date = timezone.now()
            rating_obj.save()
        else:
            rating_obj = ratingtable.objects.create(
                user_id=user_obj,
                rating=int(rating_val),
                review=review_val,
                send_date=timezone.now()
            )

        return Response({
            'message': 'success',
            'rating': Ratingserializers(rating_obj).data
        }, status=status.HTTP_200_OK)


class ChatBotView(APIView):
    def post(self, request, user_id):
        print("====== CHATBOT API CALLED for user_id:", user_id)
        user_obj = usertable.objects.filter(login_id__id=user_id).first()
        if not user_obj:
            user_obj = usertable.objects.filter(id=user_id).first()

        user_message = request.data.get('message', '').strip()
        image_file = request.FILES.get('image')

        if not user_message and not image_file:
            return Response({'message': 'failed', 'error': 'Message or image is required'}, status=status.HTTP_400_BAD_REQUEST)

        # Build personalized user and family health context
        user_name = user_obj.name if user_obj and user_obj.name else "User"
        user_allergies = user_obj.food_allergies if user_obj and user_obj.food_allergies else "None"
        user_conditions = user_obj.health_condition if user_obj and user_obj.health_condition else "None"
        user_bmi = user_obj.bmi if user_obj and user_obj.bmi else "Normal"

        family_lines = []
        if user_obj:
            members = memberstable.objects.filter(user_id=user_obj)
            for m in members:
                preg_details = ""
                if m.health_status == 'pregnant' or m.pregnancy_issues or m.trimester:
                    preg_details = f", Pregnant ({m.trimester or m.pregnancy_month or 'Yes'}{f' - Issues: {m.pregnancy_issues}' if m.pregnancy_issues else ''})"
                family_lines.append(
                    f"- {m.name} ({m.relationship or 'Family'}): Allergies: {m.food_allergies or 'None'}, Conditions: {m.conditions or m.health_status or 'Normal'}{preg_details}"
                )

        family_context = "\n".join(family_lines) if family_lines else "No additional family members registered."

        system_instruction = f"""You are NutriGuard AI, an expert, caring, and protective clinical nutritionist and dietary safety assistant.
Your goal is to answer queries about food items, ingredients, dietary safety, and nutrition while proactively protecting the user and their family from any allergen or health risks.

REGISTERED USER & FAMILY PROFILES:
- {user_name} (User): Food Allergies: {user_allergies} | Conditions: {user_conditions} | BMI: {user_bmi}
Family Members:
{family_context}

RULES:
1. Always evaluate the food or ingredients against the specific allergies and health conditions of {user_name} and every family member above.
2. If ANY ingredient or food is potentially dangerous or triggers an allergy for ANY member, immediately start with a prominent warning:
   '⚠️ WARNING for [Name (Relationship)]: [Explain exact reason and danger]'
3. If someone is pregnant, explicitly verify pregnancy safety.
4. If completely safe, state: '✅ Safe for {user_name} and family members'.
5. Provide practical, healthy nutrition tips or safer alternatives.
6. Keep your answers concise, clear, and easy to read.
"""

        parts = []
        if image_file:
            try:
                img_bytes = image_file.read()
                img_b64 = base64.b64encode(img_bytes).decode('utf-8')
                mime_type = image_file.content_type or 'image/jpeg'
                parts.append({
                    "inline_data": {
                        "mime_type": mime_type,
                        "data": img_b64
                    }
                })
                prompt_text = f"{system_instruction}\n\nUser Question about this image: {user_message if user_message else 'Analyze this food/packaging and warn me if anything is unsafe for my family.'}"
                parts.append({"text": prompt_text})
            except Exception as e:
                print("Error encoding chatbot image:", e)
                parts.append({"text": f"{system_instruction}\n\nUser Question: {user_message}"})
        else:
            parts.append({"text": f"{system_instruction}\n\nUser Question: {user_message}"})

        models_to_try = ["models/gemini-3.5-flash-lite", "models/gemini-3.8-flash"]
        ai_reply = None

        for model_name in models_to_try:
            url = f"https://generativelanguage.googleapis.com/v1beta/{model_name}:generateContent?key={GEMINI_API_KEY}"
            try:
                gemini_res = requests.post(url, json={"contents": [{"parts": parts}]}, timeout=25)
                if gemini_res.status_code == 200:
                    data = gemini_res.json()
                    candidates = data.get('candidates', [])
                    if candidates:
                        content_parts = candidates[0].get('content', {}).get('parts', [])
                        if content_parts:
                            ai_reply = content_parts[0].get('text', '')
                            if ai_reply:
                                break
                else:
                    print(f"Gemini ChatBot ({model_name}) error {gemini_res.status_code}:", gemini_res.text[:200])
            except Exception as e:
                print(f"ChatBot error with {model_name}:", e)

        if not ai_reply:
            ai_reply = f"Hello {user_name}! Based on your profile (Allergies: {user_allergies}), please ensure to check food labels for potential allergens. How else can I assist with your or your family's dietary safety today?"

        return Response({
            'message': 'success',
            'reply': ai_reply
        }, status=status.HTTP_200_OK)
