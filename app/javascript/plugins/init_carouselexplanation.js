
const doLastClick = (e) => {
  e.preventDefault();
  const carousel = document.getElementById('carousel-explanation');
  const formIntro = document.getElementById('trip-form-intro');
  const form = document.getElementById('trip-form');
  carousel.hidden = !carousel.hidden;
  formIntro.hidden = !formIntro.hidden;
  form.hidden = !form.hidden;
}

const initCarousel = () => {
  const carousel = document.querySelector('#carousel-explanation');
  const lastExplanation = document.querySelector('#last-explanation');

  if (lastExplanation) {
    lastExplanation.addEventListener('click', doLastClick);
  }

};

export { initCarousel };