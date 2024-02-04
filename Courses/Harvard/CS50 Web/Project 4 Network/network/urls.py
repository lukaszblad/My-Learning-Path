
from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("login", views.login_view, name="login"),
    path("logout", views.logout_view, name="logout"),
    path("register", views.register, name="register"),
    path('user/<str:profile_user>', views.profile, name="profile"),
    path('following', views.following, name="following"),
    path('edit', views.edit, name="edit"), 
    path('like-button/<int:post_id>', views.like_button, name="like_button"),
    path('like-count/<int:post_id>', views.likes_count, name="like_count"),
    path('user', views.user, name="user")
]
