$(function () {
    $.ajax({
        method: 'get',
        dataType: 'jsonp',
        url: 'https://github.com/Hungrated',
        jsonpCallback: 'handleData'
    })

    function handleData(data) {
        console.log(data)
    }
})
