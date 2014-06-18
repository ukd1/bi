$(document).ready(function(){
  if(typeof graph_description !== 'undefined'){
    if (graph_description.name == "kpi_graph"){
      var createKpiGraph = function(attribute) {
        var kpiName = window.kpi_graph_name;
        var kpiAttribute = typeof attribute !== 'undefined' ? attribute : 'today';
        var kpiData = _.map(graph_data, function(kpi){
                        return {
                          x: Date.parse(kpi.date)/1000,
                          y: eval('kpi.' + kpiAttribute),
                          date: kpi.date
                        };
                      });
        var kpiData = _.sortBy(kpiData, function(s){ return s.x; });
        var kpiGraph = new Rickshaw.Graph({
          element: document.querySelector('#kpi_graph'),
          width: 940,
          height: 350,
          stroke: true,
          renderer: 'bar',
          min: 'auto',
          series: [{
            color: '#cae2f7',
            name: kpiName,
            data: kpiData
          }]
        });

        var hoverDetail = new Rickshaw.Graph.HoverDetail({
          graph: kpiGraph
        });

        var xAxis = new Rickshaw.Graph.Axis.Time({
            graph: kpiGraph
        });


        var yAxis = new Rickshaw.Graph.Axis.Y({
            graph: kpiGraph
        });
        yAxis.render();
        kpiGraph.render();
        xAxis.render();
      };
      createKpiGraph();

      var redrawNewField = function(fieldName) {
        $('#kpi_graph').html('');
        createKpiGraph(fieldName);
      };

      $('.graph_redraw').click(function() {
        var $this = $(this);
        if($this.attr('data-field')) {
          redrawNewField($this.attr('data-field'));
        }
      });
    }
  }
});
