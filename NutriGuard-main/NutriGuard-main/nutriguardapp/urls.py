"""
URL configuration for nutriguard project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

from nutriguardapp.views import *

urlpatterns = [
    path('',loginview.as_view(),name="login"),
    path('home',homepageview.as_view(),name="home"),
    path('complaints',complaintview.as_view(),name="complaints"),
    path('members',membersview.as_view(),name="members"),
    path('rating',ratingview.as_view(),name='rating'),
    path('users',usersview.as_view(),name='users'),
    path('register',RegisterView.as_view(),name="Register"),
    path('login',LoginView.as_view(),name="login"),
    path('healthprofile/<int:user_id>',ProfileView.as_view(),name="profile"),
    path('family-members/<int:user_id>',FamilyMembersView.as_view(),name="family-members"),
    path('add-member/<int:user_id>',FamilyMembersView.as_view(),name="add-member"),
    path('member/<int:member_id>',MemberDetailsView.as_view(),name="member-detail"),
    path('scan-food/<int:user_id>',ScanFoodView.as_view(),name="scan-food"),
    path('recent-scans/<int:user_id>',RecentScansView.as_view(),name="recent-scans"),
    path('complaint/<int:user_id>', ComplaintApiView.as_view(), name="complaint-api"),
    path('rating-feedback/<int:user_id>', RatingApiView.as_view(), name="rating-feedback-api"),
    path('chatbot/<int:user_id>', ChatBotView.as_view(), name="chatbot-api"),
]
 