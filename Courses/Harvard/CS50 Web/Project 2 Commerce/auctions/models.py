from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    id = models.BigAutoField(primary_key=True)
    pass

class Listing(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=128) # title
    description = models.TextField(max_length=1000) # description
    current_bid = models.DecimalField(max_digits=10, decimal_places=2) # current bid
    image_url = models.TextField(max_length=1000, null=True, blank=True) # image url (can be null)
    category = models.CharField(max_length=64, null=True, blank=True) # image category (can be null)
    active = models.BooleanField(default=True)

class Watchlist(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    listing = models.ForeignKey(Listing, on_delete=models.CASCADE)

class Bid((models.Model)):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    listing = models.ForeignKey(Listing, on_delete=models.CASCADE)
    bid = models.DecimalField(max_digits=10, decimal_places=2)

class Comment(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    listing = models.ForeignKey(Listing, on_delete=models.CASCADE)
    comment = models.TextField(max_length=1000)