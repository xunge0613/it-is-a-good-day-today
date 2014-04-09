###
    Author: Dalston Xu
    Updated: 2014年4月9日1:02:49
###



document.addEventListener(
    'DOMContentLoaded',
    -> 
        # RainDrop Effect
        run()         

        # SoundManager
        audioSpan = 7288
        soundManager.setup({
            onready: ->
                rain1 = soundManager.createSound(
                    id: 'rain1',
                    url: 'audio/rainfade_1.mp3'
                    autoLoad: true,
                    multiShotEvents: true,
                    onload: -> 
                        this.play({position: 0})
                    onfinish: ->
                        this.play({position: 0})
                )
                rain1.play();

                t = false;

                rain2 = soundManager.createSound(
                    id: 'rain2',
                    url: 'audio/rainfade_1.mp3'
                    autoLoad: true,
                    multiShotEvents: true,
                    onload: -> 
                        this.play({
                            volume: 0,
                            position: audioSpan
                        })
                    onfinish: ->
                        this.play({position: 0})
                    onplay: ->
                        return false if t
                        
                        e = 3* 1e3
                        n = 0
                        r = 100
                        i = setInterval( -> 
                            rain2.setVolume((1 + n) * (r / 12));
                            n++;
                            if n is 12 
                                clearInterval(i);
                                t = true                            
                        , e / 12)
                )
                rain2.play()
        })    

        # Geo location
        getLocation()

);

# rain drop
run = ->
    image = document.getElementById('background')
    image.onload = ->
        engine = new RainyDay({
            image: this,
            gravityAngle: Math.PI / 9
        });
        engine.trail = engine.TRAIL_SMUDGE
        engine.rain(
            [ 
                [1, 0, 100],
                [3, 3, 1],
                [1, 4, 20]
            ],
            100
        )
    image.crossOrigin = 'anonymous'
    image.src = './images/shanghai.jpg'

# geo location

getLocation = ->

    # variables , used to post request to open weather,  city id, city name preferred 
    
    # get location success
    success = (position) ->
        $("#aside").addClass("show")         
        $("#geo_info").text(position)  
        getWeatherByGeoCoords([position.coords.latitude,position.coords.longtitude])

    # get location failed , try ipinfo.ip to get position
    error = (error) -> 
        switch error.code
            when error.PERMISSION_DENIED    then console.info("PERMISSION_DENIED")
            when error.POSITION_UNAVAILABLE then console.info("POSITION_UNAVAILABLE")            
            when error.TIMEOUT              then console.info("TIMEOUT")
            when error.UNKNOWN_ERROR        then console.info("UNKNOWN_ERROR")
        $.get(
            "http://ipinfo.io", 
            (response) ->
                $("#aside").addClass("show")
                $("#geo_info").text(response.loc)
                coords = response.loc.split(",")               
                if response.city isnt null
                    getWeatherByCityName(response.city)
                else
                    getWeatherByGeoCoords(coords[0],coords[1])
            ,"jsonp"
        );

    # call HTML5 get geo location
    navigator.geolocation.getCurrentPosition(success,error)       

# get weather info
getWeatherByCityName = (cityName) ->
    $.get(
        "http://api.openweathermap.org/data/2.5/weather?q="+cityName+"&APPID=cb44c4f3d297066b575ecf0bf5dd0751 ", 
        (response) ->
            console.log(response)
        ,"jsonp"
    );

getWeatherByGeoCoords = (lat,lon) ->
    $.get(
        "http://api.openweathermap.org/data/2.5/weather?lat="+lat+"&lon="+lon+"&APPID=cb44c4f3d297066b575ecf0bf5dd0751 ", 
        (response) ->
            console.log(response)
        ,"jsonp"
    );
