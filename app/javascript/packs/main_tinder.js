let profiles = document.querySelectorAll('.profile');

const maxAngle = 42;
const smooth = 0.3;
const threshold = 30;
const thresholdMatch = 90;
profiles.forEach(setupDragAndDrop);

function setupDragAndDrop(profile) {
  const hammertime = new Hammer(profile);

  hammertime.on('pan', function (e) {
    profile.classList.remove('profile--back');
    let posX = e.deltaX;
    let posY = Math.max(0, Math.abs(posX * smooth) - threshold);
    let angle = Math.min(Math.abs(e.deltaX * smooth / 100), 1) * maxAngle;
    if (e.deltaX < 0) {
      angle *= -1;
    }

    profile.style.transform = `translateX(${posX}px) translateY(${posY}px) rotate(${angle}deg)`;
    profile.classList.remove('profile--matching');
    profile.classList.remove('profile--nexting');
    if (posX > thresholdMatch) {
      profile.classList.add('profile--matching');
    } else if (posX < -thresholdMatch) {
      profile.classList.add('profile--nexting');
    }

    if (e.isFinal) {
      profile.style.transform = ``;
      if (posX > thresholdMatch) {
        profile.classList.add('profile--match');
        // console.log("coucou");
        // windows.open(new_trip_booking_path);
      } else if (posX < -thresholdMatch) {
        profile.classList.add('profile--next');
      } else {
        profile.classList.add('profile--back');
      }
    }
  });
}