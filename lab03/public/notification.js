Notification.requestPermission();

console.log(Notification.permission);
if (Notification.permission === "granted") {
  showNotification();
} else {
  Notification.requestPermission().then((permission) => {
    console.log(permission);
  });
}

function showNotification() {
  const notification = new Notification("Title", {
    body: "Message body",
    icon: "https://gamebook123.web.app//zdj1.jpg",
  });

  notification.onclick = (e) => {
    window.location.href = "https://gamebook123.web.app";
  };
}



function displayNotification() {
  try {
    if (Notification.permission === "granted") {
      try {
        navigator.serviceWorker.getRegistration().then(function (reg) {
          reg.showNotification("Hello world!");
        });
      } catch (x) {
        alert(x);
      }
    } else {
      Notification.requestPermission(function (status) {
        console.log("Notification permission status:", status);
      });
    }
  } catch (e) {
    alert(e);
  }
}

function customNotification(){
    var title = document.getElementById("title").value;
    var content = document.getElementById("content").value;
    var image = document.getElementById("image").value;
    try {
        if (Notification.permission === "granted") {
          try {
            navigator.serviceWorker.getRegistration().then(function (reg) {
              reg.showNotification(title, {
                body: content,
                icon: "https://gamebook123.web.app//"+image,
              });
            });
          } catch (x) {
            alert(x);
          }
        } else {
          Notification.requestPermission(function (status) {
            console.log("Notification permission status:", status);
          });
        }
      } catch (e) {
        alert(e);
      }

}


function showNotificationNew() {
    var title = document.getElementById("title").value;
    var content = document.getElementById("content").value;
    var image = document.getElementById("image").value;
    const notification = new Notification(title, {
        body: content,
        icon: "https://gamebook123.web.app//"+image,
      });

    notification.onclick = (e) => {
      window.location.href = "https://gamebook123.web.app";
    };
  }