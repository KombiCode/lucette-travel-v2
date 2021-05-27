import opening_hours from 'opening_hours';

import { testHighLevelAPI, testSimpleAPI, testIteratorAPI } from './test_openinghours_apis'


const prettifyOpeningHours = (rawOpeningHours) => {
  const oh = new opening_hours(rawOpeningHours);
  const pretty_oh = oh.prettifyValue({ conf: { rule_sep_string: '\n', print_semicolon: false } });
  return pretty_oh;
}

const initOpeningHours = (callbackUpdate) => {
  const osmOpeningHoursRaw = document.querySelector('#activity-osm-oh-raw');
  const osmPrettyOpeningHours = document.querySelector('#activity-osm-pretty-oh');
  if (osmOpeningHoursRaw && osmPrettyOpeningHours) {
    const rawOH = osmOpeningHoursRaw.innerText
    osmPrettyOpeningHours.innerText = prettifyOpeningHours(rawOH);
    // testHighLevelAPI(rawOH);
    // testSimpleAPI(rawOH);
    // testIteratorAPI(rawOH);
  }
};

export { initOpeningHours };