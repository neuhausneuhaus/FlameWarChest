console.log("main.js, reporting in")

// sort topics by karma


// var sortTopics = function sort() {
//     $($('ul.topic_list>li').get().reverse()).each(function(outer) {
//         var sorting = this;
//         $($('ul.topic_list>li').get().reverse()).each(function(inner) {
//             if($('p.topic_karma_score', this).text().localeCompare($('p.topic_karma_score', sorting).text()) > 0) {
//                 this.parentNode.insertBefore(sorting.parentNode.removeChild(sorting), this);
//             }
//         });
//     });
// }


// $(document).ready(sortTopics())



function sortTopics(a,b){
  return parseInt($('p', a).text()) < parseInt($('p', b).text()) ? 1 : -1;
}



$('li').sort(sortTopics).prependTo($('ul.topic_list'));