from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    id = models.BigAutoField(primary_key=True)
    pass

class Post(models.Model):
    id = models.BigAutoField(primary_key=True)
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField(max_length=512)
    datetime = models.DateTimeField(auto_now_add=True)

class Follow(models.Model):
    id = models.BigAutoField(primary_key=True)
    origin_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="follower")
    destination_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="followee")

class Like(models.Model):
    id = models.BigAutoField(primary_key=True)
    origin_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="liker")
    liked_post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name="post")
