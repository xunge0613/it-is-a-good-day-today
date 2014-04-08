// Generated by CoffeeScript 1.7.1

/*
    Author: Dalston Xu
    Updated: 2014年4月9日1:02:49
 */

(function() {
  var run;

  document.addEventListener('DOMContentLoaded', function() {
    var audioSpan;
    run();
    audioSpan = 7288;
    return soundManager.setup({
      onready: function() {
        var rain1, rain2, t;
        rain1 = soundManager.createSound({
          id: 'rain1',
          url: 'audio/rainfade_1.mp3',
          autoLoad: true,
          multiShotEvents: true,
          onload: function() {
            return this.play({
              position: 0
            });
          },
          onfinish: function() {
            return this.play({
              position: 0
            });
          }
        });
        rain1.play();
        t = false;
        rain2 = soundManager.createSound({
          id: 'rain2',
          url: 'audio/rainfade_1.mp3',
          autoLoad: true,
          multiShotEvents: true,
          onload: function() {
            return this.play({
              volume: 0,
              position: audioSpan
            });
          },
          onfinish: function() {
            return this.play({
              position: 0
            });
          },
          onplay: function() {
            var e, i, n, r;
            if (t) {
              return false;
            }
            e = 3 * 1e3;
            n = 0;
            r = 100;
            return i = setInterval(function() {
              rain2.setVolume((1 + n) * (r / 12));
              n++;
              if (n === 12) {
                clearInterval(i);
                return t = true;
              }
            }, e / 12);
          }
        });
        return rain2.play();
      }
    });
  });

  run = function() {
    var image;
    image = document.getElementById('background');
    image.onload = function() {
      var engine;
      engine = new RainyDay({
        image: this,
        gravityAngle: Math.PI / 9
      });
      engine.trail = engine.TRAIL_SMUDGE;
      return engine.rain([[1, 0, 100], [3, 3, 1], [1, 4, 20]], 100);
    };
    image.crossOrigin = 'anonymous';
    return image.src = './images/shanghai.jpg';
  };

}).call(this);
