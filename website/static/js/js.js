let selectedDate = null;

  document.getElementById("datePicker").addEventListener("change", function() {
    selectedDate = this.value;
    document.getElementById("outputDate").innerText = "Selected Date: " + selectedDate;
  });

  function useSelectedDate() {
    if (selectedDate) {
      alert("Using date: " + selectedDate);
    } else {
      alert("Please select a date first.");
    }
  }

//   document.getElementById("eventForm").addEventListener("submit", function (e) {
//   e.preventDefault();

//   const eventText = document.getElementById("eventText").value;
//   const date = document.getElementById("datePicker").value;
//   const time = document.getElementById("timePicker").value;
//   const duration = document.getElementById("duration").value;

//   if (eventText && date && time && duration) {
//     const summary = `
//       📝 <strong>${eventText}</strong><br>
//       📅 Date: ${date}<br>
//       🕒 Time: ${time}<br>
//       ⏱️ Duration: ${duration} minutes
//     `;
//     document.getElementById("outputSummary").innerHTML = summary;
//   } else {
//     document.getElementById("outputSummary").innerText = "Please fill in all fields.";
//   }
// });

function showOverlay() {
  const overlay = document.getElementById("overlay");
  overlay.style.display = "flex";

  setTimeout(() => {
    overlay.style.display = "none";
    window.location.href = "/event_form"; 
  }, 2000);

  return false;
}
function showOverlay_edit(date) {
  const overlay = document.getElementById("overlay");
  overlay.style.display = "flex";
  setTimeout(() => {
    overlay.style.display = "none";
    window.location.href = "/date_selected_events?date=" + date; 
  }, 2000);

  return false;
}

function go_to_add_event(){
     window.location.href = "/event_form"; 
}




function show_option(id,e){
  const box = document.getElementById("optionsBox-"+id);
  const btn = document.getElementById("optionsBtn-"+id);

  e.stopPropagation();
  box.classList.toggle("hidden");
  const rect = btn.getBoundingClientRect();
  box.style.left = rect.left + "px";
  box.style.top = rect.bottom + "px";
}



function rm_option(e){
  const boxes = document.querySelectorAll('[id^="optionsBox-"]');
  boxes.forEach(box => {
    if (!box.contains(e.target)) {
      box.classList.add("hidden");
    }
});
}


function edit_event(id){
     window.location.href = "/edit_event?id=" + id; 
}

function remove_event(id){
     window.location.href = "/remove_event?id=" + id; 
}
