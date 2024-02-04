document.addEventListener("DOMContentLoaded", () => {

    // retrieve user info
    fetch("/user")
    .then(response => response.json())
    .then(user => {
        if (user.is_logged) {
            // LIKE BUTTON VALUE
            const posts = document.querySelectorAll(".post");
            // console.log(posts);
            posts.forEach((post) => {
                // console.log('RUNS');
                const button = document.querySelector(`#like-button${post.id}`)
                // console.log(post.id);
                // fetch information on likes for the post and the current user
                fetch(`/like-button/${post.id}`)
                .then(response => response.json())
                .then(like => {
                    // console.log(like.value);
                    // console.log(button)
                    if (like.value) {
                        button.innerHTML = "Unlike";
                    }
                    else {
                        button.innerHTML = "Like";
                    }
                })
            });
        }
    });

    // LIKES COUNT
    const posts = document.querySelectorAll(".post");
    posts.forEach((post) => {
        const currentElement = document.querySelector(`#likes-count${post.id}`)
        fetch(`/like-count/${post.id}`)
        .then(response => response.json())
        .then(likes => {
            currentElement.innerHTML = likes.count
        })
    })

    // BUTTONS
    const buttonsContainer = document.querySelector(".body");
    buttonsContainer.onclick = (event) => {
        const clickedButton = event.target;
        const id = clickedButton.parentNode.id;
        const div = document.querySelector(`#content${id}`);
        const input = document.createElement("textarea");

        if (clickedButton.innerHTML === "Edit") {
            const text = div.innerHTML;
            div.innerHTML = "";
            input.innerHTML = text;
            input.id = `edit${id}`;
            div.append(input);
            clickedButton.innerHTML = "Save";
        }
        else if (clickedButton.innerHTML === "Save") {
            const newText = document.querySelector(`#edit${id}`).value;

            // put value to db
            fetch("/edit", {
                method: "PUT",
                body: JSON.stringify({
                    post: id,
                    content: newText,
                })
            })
            .then(() => {
                clickedButton.innerHTML = "Edit";
                div.innerHTML = newText;
            })
        }
        else if (clickedButton.innerHTML === "Like") {
            // fetch PUT to create entry in Like model
            fetch(`/like-button/${id}`, {
                method: "PUT",
                body: JSON.stringify({
                    post: id,
                    value: "add"
                })
            })
            .then(() => {
                document.querySelector(`#likes-count${id}`).innerHTML++
                clickedButton.innerHTML = "Unlike";
            })
        }
        else if (clickedButton.innerHTML === "Unlike") {
             // fetch PUT to remove entry in Like model
             fetch(`/like-button/${id}`, {
                method: "PUT",
                body: JSON.stringify({
                    post: id,
                    value: "remove"
                })
            })
            .then(() => {
                document.querySelector(`#likes-count${id}`).innerHTML--
                clickedButton.innerHTML = "Like";
            })
        }
    }
});