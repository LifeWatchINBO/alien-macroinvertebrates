(function() {
    var species,
        selectedSpecies,
        vizlayers;

    var fetchSpecies = function () {
      var sql = "SELECT distinct scientificname from occurrence_1";
      return $.get("https://lifewatch.carto.com/api/v1/sql?q=" + sql);
    };

    var createSpeciesSelection = function () {
        $("#select-species").append('<option value="0">All species</option>');
        $("#select-species").append('<option disabled>──────────</option>');
        for (var i=0; i<species.length; i++) {
            var spec_name = species[i];
            var option = '<option value="' + (i+1) + '">' + spec_name.scientificname + '</option>';
            $("#select-species").append(option);
        }
    };

    var selectSpecies = function() {
        var speciesID = $("option:selected", this).val();
        if (speciesID === 0) {
            clearSelection();
        } else {
            selectedSpecies = species[speciesID-1].scientificname;
            //console.log("selected: " + selectedSpecies);
            loadSpecies();
        }
    };

    var clearSelection = function() {
        vizlayers[1].getSubLayer(0).set({"sql": "SELECT * FROM occurrence_1"});
    };

    var loadSpecies = function() {
        vizlayers[1].getSubLayer(0).set({"sql": "SELECT * FROM occurrence_1 WHERE scientificname = '" + selectedSpecies + "'"});
    };

    window.onload = function() {
        fetchSpecies()
            .done(function (data) {
                species = _.sortBy(data.rows, function(x) {return x.scientificname;});
                createSpeciesSelection();
                $("#select-species").on("change", selectSpecies);
            });
        var map = cartodb.createVis(
                "map-canvas",
                "https://lifewatch.carto.com/api/v2/viz/33404524-6071-11e6-81a5-0e3ebc282e83/viz.json",
                {
                    "shareable": false,
                    "zoom": 8,
                    "cartodb_logo": false,
                    "center_lat": 51.1,
                    "center_lon": 4.2
                }
            )
            .done(function(vis, layers) {
                vizlayers = layers;
            })
            .error(function(err) {
                console.log(err);
            });
    };
})();
