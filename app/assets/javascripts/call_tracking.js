$(document).ready(function() {
  $.get('/statistics/leads_by_source/', function(data) {
      var ctx = $("#leads-by-source").get(0).getContext("2d");
      var myPieChart = new Chart(ctx).Pie(data.statistics,{
          animateScale: true
      });
  });

  $.get('/statistics/leads_by_city/', function(data) {
    CallTrackingGraph("#leads-by-city", data.statistics).draw();
  });

    $( "#btn-test-me" ).click(function() {
        alert( "Handler for .click() called." );
    });
});

CallTrackingGraph = function(selector, data) {
  function getContext() {
    return $(selector).get(0).getContext("2d");
  }

  return {
    draw: function() {
      var context = getContext(selector);
      new Chart(context).Pie(data);
    }
  }
}
