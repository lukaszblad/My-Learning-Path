from django.shortcuts import render, redirect
from django import forms
from markdown2 import Markdown
from random import randint

from . import util

# search for existing entries form
class SearchForm(forms.Form):
    q = forms.CharField(label='', widget=forms.TextInput(attrs={
        'class': 'search',
        'type': 'text',
        'placeholder': 'Search Encyclopedia',
        'autocomplete': "off"
    }))

# create and edit entry form
class CreateFormTitle(forms.Form):
    title = forms.CharField(label='', widget=forms.TextInput(attrs={
        "class": "form-control",
        "placeholder": "Title",
        "style": "margin: 10px; width: 70vw"
    }))
class CreateFormText(forms.Form):
    text = forms.CharField(label='', widget=forms.Textarea(attrs={
        "class": "form-control",
        "id": "exampleFormControlTextarea1",
        "rows": "10",
        "placeholder": "Markdown text",
        "style": "margin: 10px; width: 70vw"
    }))

def index(request):
    return render(request, "encyclopedia/index.html", {
        "entries": util.list_entries(),
        "form": SearchForm()
    })

# view existing entries
def page(request, page):
    if page.lower() in util.list_entries():
        return render(request, "encyclopedia/page.html", {
        "title": page,
        "content": Markdown().convert(util.get_entry(page)),
        "form": SearchForm()
        })
    else:
        return render(request, "encyclopedia/message.html", {
            "title": "Not Found",
            "message": "404 not found"
        })
    
# search for existing entries
def search(request):
    if request.method == "POST":
        query = SearchForm(request.POST)

        # query validation
        if query.is_valid():
            query = query.cleaned_data['q']

            # query matches entry
            if query.lower() in util.list_entries():
                return render(request, "encyclopedia/page.html", {
                "title": query,
                "content": Markdown().convert(util.get_entry(query)),
                "form": SearchForm()
                })
            
            # query partially matches entry
            substrings = []
            for entry in util.list_entries():
                if query.lower() in entry:
                    substrings.append(entry)
            return render(request, "encyclopedia/search.html", {
            "list": substrings,
            "form": SearchForm()
            })
        else:
            return render(request, "encyclopedia/message.html", {
            "title": "Not Found",
            "message": "404 not found"
            })
    else:
        return redirect("/")
    
# create new entry
def create(request):
    if request.method == "POST":
        title = CreateFormTitle(request.POST)
        content = CreateFormText(request.POST)
        if title.is_valid() and content.is_valid():
            title = title.cleaned_data['title']
            content = content.cleaned_data['text']

            # return error message if entry already exist
            if title.lower() in util.list_entries():
                return render(request, "encyclopedia/message.html",{
                    "title": "Failure",
                    "message": "Entry already exists"
                })

            # save entry to md file
            util.save_entry(title, content)
            return redirect("../create/")
        else:
            return render(request, "encyclopedia/message.html", {
            "title": "Not Valid",
            "message": "Invalid entry"
            })
    else:    
        return render(request, "encyclopedia/create.html", {
            "form": SearchForm(),
            "title": CreateFormTitle(),
            "text": CreateFormText()
        })
    
# edit entry
def edit(request, entry):
    if request.method == "POST":
        content = CreateFormText(request.POST)
        if content.is_valid():
            content = content.cleaned_data['text']
            util.save_entry(entry, content)
            return redirect(f"../wiki/{entry}")
        else:
            return render(request, "encyclopedia/message.html", {
            "title": "Not Valid",
            "message": "Invalid entry"
            })
    else:
        return render(request, "encyclopedia/edit.html", {
            "entry": entry,
            "text": CreateFormText(initial={"text": util.get_entry(entry)})
        })
    
# random page
def random_page(request):
    entries = util.list_entries()
    random_page = randint(0, len(entries) - 1)
    return redirect(f"../wiki/{entries[random_page]}")