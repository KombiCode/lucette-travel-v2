const toggleDisplay = (element) => {
  if (element.style.display === "none") {
    element.style.display = "block";
  } else {
    element.style.display = "none";
  }
}

const doLastClick = (e) => {
  e.preventDefault();
  const carousel = document.getElementById('carousel-explanation');
  const form = document.getElementById('form-notrip');
  toggleDisplay(carousel);
  toggleDisplay(form);
}

const initCarousel = () => {
  const carousel = document.querySelector('#carousel-explanation');
  const form = document.getElementById('form-notrip');
  const lastExplanation = document.querySelector('#last-explanation');
  if (carousel && form) {
    carousel.style.display = "block";
    form.style.display = "none";
  }
  if (lastExplanation) {
    lastExplanation.addEventListener('click', doLastClick);
  }
};

export { initCarousel };