(function() {
    var species,
        selectedSpecies,
        vizlayers;

    var fetchSpecies = function () {
      var sql = "SELECT distinct scientificname from alien_macroinvertebrates";
      return $.get("https://lifewatch.cartodb.com/api/v2/sql?q=" + sql);
    };

    var createSpeciesSelection = function () {
        for (var i=0; i<species.length; i++) {
            var spec_name = species[i];
            var option = '<option value="' + i + '">' + spec_name.scientificname + '</option>';
            $("#select-species").append(option);
        };
    };

    var selectSpecies = function() {
        var speciesID = $("option:selected", this).val();
        selectedSpecies = species[speciesID].scientificname;
        //console.log("selected: " + selectedSpecies);
        loadSpecies();
    };

    var clearSelection = function() {
        vizlayers[1].getSubLayer(0).set({"sql": "SELECT * FROM alien_macroinvertebrates"});
    };

    var loadSpecies = function() {
        vizlayers[1].getSubLayer(0).set({"sql": "SELECT * FROM alien_macroinvertebrates WHERE scientificname='" + selectedSpecies + "'"});
    };


    window.onload = function() {
        fetchSpecies()
            .done(function (data) {
                species = _.sortBy(data.rows, function(x) {return x.scientificname;});
                createSpeciesSelection();
                $("#select-species").on("change", selectSpecies);
                $("#clear-select").on("click", clearSelection);
            });
        var map = cartodb.createVis('map-canvas', 'https://inbo.cartodb.com/u/lifewatch/api/v2/viz/b95fcc5e-2ad7-11e5-928a-0e6e1df11cbf/viz.json')
            .done(function(vis, layers) {
                vizlayers = layers;
            })
            .error(function(err) {
                console.log(err);
            });
    }
})();
