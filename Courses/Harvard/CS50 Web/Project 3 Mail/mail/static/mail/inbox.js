document.addEventListener('DOMContentLoaded', function() {

  // Use buttons to toggle between views
  document.querySelector('#inbox').addEventListener('click', () => load_mailbox('inbox'));
  document.querySelector('#sent').addEventListener('click', () => load_mailbox('sent'));
  document.querySelector('#archived').addEventListener('click', () => load_mailbox('archive'));
  document.querySelector('#compose').addEventListener('click', () => compose_email(false));
  document.querySelector('#compose-form').onsubmit = send_email;

  // By default, load the inbox
  load_mailbox('inbox');
});

function compose_email(email) {

  // Show compose view and hide other views
  document.querySelector('#emails-view').style.display = 'none';
  document.querySelector('#mail-view').style.display = 'none';
  document.querySelector('#compose-view').style.display = 'block';
  document.querySelector('#mailbox-view').innerHTML = '';

  if (!email) {
    // Clear out composition fields
    document.querySelector('#compose-recipients').value = '';
    document.querySelector('#compose-subject').value = '';
    document.querySelector('#compose-body').value = '';
  }
  else {
    // checking if mail is a reply
    if (email.subject.slice(0,3) === 'Re:') {
      document.querySelector('#compose-subject').value = `${email.subject}`;
    }
    else {
      document.querySelector('#compose-subject').value = `Re: ${email.subject}`;
    }
    document.querySelector('#compose-recipients').value = email.sender;
    document.querySelector('#compose-body').innerHTML = `On ${email.timestamp} ${email.sender} wrote: ${email.body}`;
  }
}

function load_mailbox(mailbox) {
  document.querySelector('#mailbox-view').innerHTML = '';

  // Show the mailbox and hide other views
  document.querySelector('#emails-view').style.display = 'block';
  document.querySelector('#compose-view').style.display = 'none';
  document.querySelector('#mail-view').style.display = 'none';

  // Show the mailbox name
  document.querySelector('#emails-view').innerHTML = `<h3>${mailbox.charAt(0).toUpperCase() + mailbox.slice(1)}</h3>`;

  // load content of current page
  load_content(mailbox);
}

function send_email() {
  const recipients = document.querySelector('#compose-recipients').value;
  const subject = document.querySelector('#compose-subject').value;
  const body = document.querySelector('#compose-body').value;

  // post request
  fetch('/emails', {
    method: 'POST',
    body: JSON.stringify({
        recipients: recipients,
        subject: subject,
        body: body
    })
  })
  .then(response => response.json())
  .then(result => {
      // Print result
      console.log(result);
  })
  .then(() => {
    load_mailbox('sent');
  })

  // stop form from submitting
  return false;
}

function load_content(mailbox) {
  // retrieve content
  fetch(`/emails/${mailbox}`)
  .then(response => response.json())
  .then(emails => {
      // clear the content when page changed
      document.querySelector('#mailbox-view').innerHTML = '';
      // display content
      document.querySelector('#mailbox-view').style.display = 'block';
      for (let i = 0; i < emails.length; i++) {
        let elements = [];
        if (mailbox === 'sent') {
          elements = [emails[i].recipients, emails[i].subject, emails[i].timestamp];
        }
        else {
          elements = [emails[i].sender, emails[i].subject, emails[i].timestamp];
        }

        // create row container
        let row = document.createElement('div');
        let row_id = `row${i}`;
        row.id = row_id;
        row.className = `row_${emails[i].read}`;
        
        document.querySelector('#mailbox-view').append(row);

        // append each element to row
        for (let j = 0; j < 3; j++) {
          let col = document.createElement('span');
          col.className = `col${j}`;
          col.innerHTML = elements[j];
          document.querySelector(`#${row_id}`).append(col);
        }

        row.addEventListener('click', () => load_message(emails[i].id));
      }
  });
}

function load_message(mail_id) {
  fetch(`/emails/${mail_id}`)
  .then(response => response.json())
  .then(email => {
    // remove mailbox content
    document.querySelector('#compose-view').style.display = 'none';
    document.querySelector('#emails-view').style.display = 'none';
    document.querySelector('#mailbox-view').style.display = 'none';

    // display content
    document.querySelector('#mail-view').style.display = 'block';
    document.querySelector('#sender').innerHTML = email.sender;
    document.querySelector('#receivers').innerHTML = email.recipients;
    document.querySelector('#subject').innerHTML = email.subject;
    document.querySelector('#timestamp').innerHTML = email.timestamp;
    document.querySelector('#body').innerHTML = email.body;
    document.querySelector('#archive').innerHTML = email.archived ? "Unarchive" : "Archive";

    //change email to read
    fetch(`/emails/${mail_id}`, {
      method: 'PUT',
      body: JSON.stringify({
          read: true
      })
    });

    // archive button
    document.querySelector('#archive').onclick = () => {
      // change archived state
      fetch(`/emails/${mail_id}`, {
        method: 'PUT',
        body: JSON.stringify({
          archived: !email.archived
        })
      })
      .then(() => {
        load_mailbox('inbox');
      });
    };

    // reply button
    document.querySelector('#reply').onclick = () => {
      compose_email(email);
    };
  });
}
