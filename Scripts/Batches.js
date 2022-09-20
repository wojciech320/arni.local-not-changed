function getActiveBatches() {
    $.ajax({
        url: "Batches.asmx/GetActiveBatches",
        data: { id: id },
        method: "post",
        dataType: "xml",
        error: function (request, status, error) {
            alert(request.responseText);
        },
        success: function (xml) {
            if (id == 1000) {
                $('#selectionS').html(composeSensorsForSelect(xml));
            } else {
                composeSensorEdit(xml);
            }
        },
    });
}