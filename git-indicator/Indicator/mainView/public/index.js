$(function () {
    $.ajax({
        method: 'get',
        dataType: 'jsonp',
        url: 'https://api.github.com/users/Hungrated',
        success: 'handleData'
    })

    function handleData(data) {
        console.log(data)
    }
})
