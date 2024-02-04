from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.db import IntegrityError
from django.db.models import Max
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
from django.urls import reverse


from .models import User, Listing, Watchlist, Bid, Comment

# ALL LISTINGS
def index(request):
    return render(request, "auctions/index.html", {
        "listings": Listing.objects.filter(active=True)
    })

def login_view(request):
    if request.method == "POST":

        # Attempt to sign user in
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(request, username=username, password=password)

        # Check if authentication successful
        if user is not None:
            login(request, user)
            return HttpResponseRedirect(reverse("index"))
        else:
            return render(request, "auctions/login.html", {
                "message": "Invalid username and/or password."
            })
    else:
        return render(request, "auctions/login.html")

@login_required
def logout_view(request):
    logout(request)
    return HttpResponseRedirect(reverse("index"))


def register(request):
    if request.method == "POST":
        username = request.POST["username"]
        email = request.POST["email"]

        # Ensure password matches confirmation
        password = request.POST["password"]
        confirmation = request.POST["confirmation"]
        if password != confirmation:
            return render(request, "auctions/register.html", {
                "message": "Passwords must match."
            })

        # Attempt to create new user
        try:
            user = User.objects.create_user(username, email, password)
            user.save()
        except IntegrityError:
            return render(request, "auctions/register.html", {
                "message": "Username already taken."
            })
        login(request, user)
        return HttpResponseRedirect(reverse("index"))
    else:
        return render(request, "auctions/register.html")

# CREATE A NEW LISTING
@login_required
def create(request):
    if request.method == "POST":
        # getting data from the form
        title = request.POST['title']
        description = request.POST['description']
        bid_value = request.POST['bid']
        image = request.POST['image']
        category = request.POST['category']

        # validating the data
        if len(title) == 0 or len(description) == 0 or len(bid_value) == 0:
            return render(request, "auctions/create.html", {
                "warning": "Fill all the required fields"
            })
        if len(image) == 0:
            image = None
        if len(category) == 0:
            category = None

        # saving listing to db
        listing = Listing(
            user=request.user,
            title=title,
            description=description,
            current_bid=bid_value,
            image_url=image,
            category=category
        )
        listing.save()
        return HttpResponseRedirect(reverse("index"))
    else:
        return render(request, "auctions/create.html")
        
def listing(request, id):
    watchlist = None
    listing = Listing.objects.get(pk=id)
    current_bid = listing.current_bid
    try:
        bidding_user = User.objects.filter(id=Bid.objects.filter(listing=listing).values().latest('bid')["user_id"])[0]
    except:
        bidding_user = None
    if request.user.is_authenticated:
        check_watchlist = Watchlist.objects.all().filter(user=request.user).filter(listing=listing)
        if len(check_watchlist) > 0:
            watchlist = True
        else:
            watchlist = False
    if request.method == "POST":
        form = request.POST['form']
        # watchlist feature
        if form == "Add to watchlist":
            Watchlist(user=request.user, listing=listing).save()
        elif form == "Remove from watchlist":
            check_watchlist.delete()
        # close bid feature
        elif form == "Close auction" and request.user == listing.user:
            listing.active = False
            listing.save()
        # place bid feature
        elif form == "Place bid":
            bid_value = int(request.POST["new_bid"])
            if bid_value > current_bid:
                listing.current_bid = bid_value
                listing.save()
                bid = Bid(
                    user=request.user,
                    listing=listing,
                    bid=bid_value
                )
                bid.save()
        # add comment feature
        elif form == "Add comment":
            comment = Comment(
                user=request.user,
                listing=listing,
                comment=request.POST["new_comment"]
            )
            comment.save()
        return HttpResponseRedirect(reverse("listing", kwargs={"id":id}))
    else:
        return render(request, "auctions/listing.html", {
            "listing":listing,
            "watchlist":watchlist,
            "bidding_user": bidding_user,
            "category": listing.category if listing.category else "No category selected",
            "comments": Comment.objects.filter(listing=listing),
        })

@login_required   
def watchlist(request):
    watchlist = Listing.objects.filter(id__in=Watchlist.objects.filter(user=request.user).all().values("listing"))
    return render(request, "auctions/list.html", {
        "title": "Watchlist",
        "listings": watchlist
    })

def categories(request):
    categories = Listing.objects.values('category').distinct()
    return render(request, "auctions/categories.html", {
        "categories": categories
    })

def category(request, category):
    listings = Listing.objects.filter(category=category).filter(active=True)
    return render(request, "auctions/list.html", {
        "listings": listings
    })