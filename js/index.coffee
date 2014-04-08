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
                rain2.play();
        })
);

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

