console.log("main.js, reporting in")

function sortTopics(a,b){
  return parseInt($('p', a).text()) < parseInt($('p', b).text()) ? 1 : -1;
}



$('li').sort(sortTopics).prependTo($('ul.topic_list'));

