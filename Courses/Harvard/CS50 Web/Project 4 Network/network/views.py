import json
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator
from django.db import IntegrityError
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse

from .models import User, Post, Follow, Like


def index(request):
    if request.method == 'POST':
        #save post to db
        post = Post(
            author = request.user,
            content = request.POST['content']
        )
        post.save()

        return HttpResponseRedirect(reverse('index'))
    else:
        posts = Post.objects.all().order_by('-datetime')

        # paginating 10 posts per page
        paginator = Paginator(posts, 10)
        page_number = request.GET.get('page')
        page_obj = paginator.get_page(page_number)

        return render(request, "network/index.html", {
            'posts': page_obj,
            'likes': 0, # TODO
        })
    
def profile(request, profile_user):
    try:
        profile_user = User.objects.filter(username=profile_user)[0]
    except:
        # user not found
        return render(request, "network/404.html", {
            "message": "User not found",
        })
    
    if request.method == 'POST':
        value = request.POST['follow_button']
        if value == 'Follow':
            instance = Follow(
                origin_user=request.user,
                destination_user=profile_user
            )
            instance.save()
        else:
            Follow.objects.filter(origin_user=request.user.id, destination_user=profile_user.id).delete()

        return HttpResponseRedirect(str(profile_user))
    else:
        # queries
        posts = Post.objects.filter(author=profile_user).order_by('-datetime')
        followers = Follow.objects.filter(destination_user=profile_user).count()
        followees = Follow.objects.filter(origin_user=profile_user).count
        follow = Follow.objects.filter(origin_user=request.user.id, destination_user=profile_user.id)
        
        # follow button
        button = "Unfollow" if follow else "Follow"

        # paginating 10 posts per page
        paginator = Paginator(posts, 10)
        page_number = request.GET.get('page')
        page_obj = paginator.get_page(page_number)
        
        # render profile page
        return render(request, "network/profile.html", {
            "profile_user":profile_user,
            "posts": page_obj,
            "followers": followers,
            "followees": followees,
            "button": button,
            'likes': 0, # TODO
        })

@csrf_exempt
def edit(request):
    data = json.loads(request.body)

    # retrieve post
    if data.get("post") is not None:
        post = Post.objects.filter(id=int(data["post"]))[0]
    else:
        HttpResponse(status=404)
        
    # check if request user is the author of the post
    if request.user != post.author:
        return HttpResponse(status=404)
    
    if data.get("content") is not None:
        post.content = data['content']
        post.save()

    return HttpResponse(status=204)

@login_required
@csrf_exempt
def like_button(request, post_id):
    if request.method == "GET":
        # print(post_id)
        like = {}
        post = Post.objects.filter(id=int(post_id))[0]
        # print(post)

        if Like.objects.filter(origin_user=request.user, liked_post=post):
            like['value'] = True
        else:
            like['value'] = False

        # print(like['value'])
        return JsonResponse(like, safe=False)
    elif request.method == "PUT":
        data = json.loads(request.body)

        if data.get("post") is not None:
            post = Post.objects.filter(id=int(data["post"]))[0]
        else:
            print("This")
            HttpResponse(status=404)

        if data.get("value") is not None:
            if data['value'] == 'add':
                like = Like (
                    origin_user = request.user,
                    liked_post = post
                )
                like.save()
            elif data['value'] == 'remove':
                Like.objects.filter(origin_user=request.user, liked_post=post).delete()
            else:
                print("that")
                HttpResponse(status=404)
        
    return HttpResponse(status=204)

@csrf_exempt
def likes_count(request, post_id):
    likes = {}
    post = Post.objects.filter(id=int(post_id))[0]

    likes_count = Like.objects.filter(liked_post=post).count()
    likes['count'] = likes_count

    return JsonResponse(likes, safe=False)

def user(request):
    user = {}
    print(request.user.is_authenticated)
    if request.user.is_authenticated:
        user['is_logged'] = True
    else:
        user['is_logged'] = False

    return JsonResponse(user, safe=False)

@login_required
def following(request):
    posts = Post.objects.filter(author__in=Follow.objects.filter(origin_user=request.user).all().values("destination_user")).order_by("-datetime")
    
    # paginating 10 posts per page
    paginator = Paginator(posts, 10)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    return render(request, 'network/following.html', {
        "posts":page_obj,
        "likes": 0, # TODO
        "like_button": "Like"
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
            return render(request, "network/login.html", {
                "message": "Invalid username and/or password."
            })
    else:
        return render(request, "network/login.html")


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
            return render(request, "network/register.html", {
                "message": "Passwords must match."
            })

        # Attempt to create new user
        try:
            user = User.objects.create_user(username, email, password)
            user.save()
        except IntegrityError:
            return render(request, "network/register.html", {
                "message": "Username already taken."
            })
        login(request, user)
        return HttpResponseRedirect(reverse("index"))
    else:
        return render(request, "network/register.html")

# APIs
def follow_api(request):
    print("TODO")
