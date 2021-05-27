import opening_hours from 'opening_hours';

import { testHighLevelAPI, testSimpleAPI, testIteratorAPI } from './test_openinghours_apis'


const prettifyOpeningHours = (rawOpeningHours) => {
  const oh = new opening_hours(rawOpeningHours);
  console.log(oh.prettifyValue({ conf: { rule_sep_string: '\n', print_semicolon: false } }));
}

const initOpeningHours = (callbackUpdate) => {
  const osmOpeningHours = document.querySelector('#activity-osm-oh-raw');
  if (osmOpeningHours) {
    const rawOH = osmOpeningHours.innerText
    prettifyOpeningHours(rawOH);
    // testHighLevelAPI(rawOH);
    // testSimpleAPI(rawOH);
    // testIteratorAPI(rawOH);
  }
};

export { initOpeningHours };