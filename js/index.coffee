###
    Author: Dalston Xu
    Updated: 2014年4月12日13:07:58
###



document.addEventListener(
    'DOMContentLoaded',
    -> 
        # Geo location and do many stuff 
        getLocation()

);

# background image - type0 - SunnyDay

bg_img_0 = ->
    $('#background').attr({"src":"./images/china_0.jpg"})

# background image - type1 - RainyDay
### 
    Rainy Day 
    http://maroslaw.github.io/rainyday.js/
###

bg_img_1 = ->
    image = document.getElementById('background')
    image.onload = ->
        engine = new RainyDay({
            image: this
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

# SoundManager

# background music - type 0 - SunnyDay

bg_music_0 = ->
    soundManager.setup({
        onready: ->
            music = soundManager.createSound(
                id: 'music',
                url: 'audio/qing_long_guo.mp3',
                multiShotEvents: true,
                onload: -> 
                    this.play({position: 0})
                onfinish: ->
                    this.play({position: 0})
            )
            music.play()
    })

### 
    SoundManager 
    http://www.schillmania.com/projects/soundmanager2/
###

### background music - type 1 - RainyDay ###

bg_music_rain = ->
    # params
    audio_rain      = 'audio/rainfade_1.mp3'
    audio_thunder_s = 'audio/thunderfade_1.mp3'
    audio_thunder_l = 'audio/loudthunderfade_1.mp3'
    audioSpan       = 7288    # 第二首曲子的播放时间点
    music_player = ->
        rain1 = soundManager.createSound({
            id: 'rain1',
            url: audio_rain,
            autoLoad: true,
            multiShotEvents: true,
            onload: -> 
                this.play({position: 0, loops: 3})
            #onfinish: ->
            #    this.play({position: 0})
        })
        pause = false
        rain2 = soundManager.createSound({
            id: 'rain2',
            url: audio_rain,
            autoLoad: true,
            multiShotEvents: true,
            onload: -> 
                this.play({
                    volume: 0,  # 初始音量为0，渐强
                    position: audioSpan,
                    loops: 3
                })
            #onfinish: ->
            #    this.play({position: 0})
            onplay: ->
                return false if pause                
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
        })

    soundManager.setup({
        url: "lib/soundmanager/swf/soundmanager2_flash9.swf",
        preferFlash: false,
        flashVersion: 9,
        flashLoadTimeout: 1500,
        noSWFCache: true,
        debugFlash: false,
        onready: music_player
    })
    soundManager.ontimeout = (e) -> 
        soundManager.flashLoadTimeout = 0
        soundManager.onerror = alert()
        soundManager.reboot() 

### 
    background music for mobile 

###

bg_music_rain_mobile = ->
    audioSpan = 7288
    soundManager.setup({
        onready: ->
            rain1 = soundManager.createSound(
                id: 'rain1',
                url: 'audio/rainfade_1.mp3',
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
                url: 'audio/rainfade_1.mp3',
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
                coords = response.loc.split(",")               
                if response.city isnt null
                    $("#geo_info").text(response.city)
                    getWeatherByCityName(response.city)
                else
                    $("#geo_info").text(response.loc)
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
            updateWeatherInfo(response)
        ,"jsonp"
    );

getWeatherByGeoCoords = (lat,lon) ->
    $.get(
        "http://api.openweathermap.org/data/2.5/weather?lat="+lat+"&lon="+lon+"&APPID=cb44c4f3d297066b575ecf0bf5dd0751 ", 
        (response) ->
            updateWeatherInfo(response)
        ,"jsonp"
    );

## update weather info 

updateWeatherInfo = (weatherInfo) -> 
    weather_main = weatherInfo.weather[0].main
    weather_icon = weatherInfo.weather[0].icon
    weather_id   = weatherInfo.weather[0].id;
    weather_temp = weatherInfo.main.temp

    # set weather icon 
    $("#weather_icon").attr({"src": "http://openweathermap.org/img/w/"+weather_icon+".png" , "title":weather_main,"alt":weather_main})

    # change aside background color 
    $("#aside").addClass(weather_main);

    # render weather text info  
    $("#weather_text").text(weather_main);
    $("#weather_temp").text(weather_temp+" °F");

    # render Background UI
    renderUI(weather_id)


## present diffent UI according to different weather

renderUI = (weatherConditionCode) -> 
    uiType = utils.condition2ui(weatherConditionCode)
    switch uiType
        when 0                  #sunny
            bg_music_0()
            bg_img_0()
        when 1                  #rain
            bg_img_1()
            ### 
                Detect Whether is a mobile browser, if true , simply play looped music
                http://detectmobilebrowsers.com/
            ###
            if jQuery.browser.mobile is true
                bg_music_rain_mobile()
            else
                bg_music_rain()
            

## Utils - convert condition code to UI type

utils = {}

utils.condition2ui = (weatherConditionCode) ->
    uiType = switch
        when weatherConditionCode // 100 is 8 then 0
        else 1 
