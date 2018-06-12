'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**"Ripples" by Bruce Luo
http://www.openprocessing.org/sketch/446986
Licensed under Creative Commons Attribution ShareAlike
https://creativecommons.org/licenses/by-sa/3.0
https://creativecommons.org/licenses/GPL/2.0/
editing by Meaghan Dee
**/

var block_size = 25;
var block_core = 1;
var block_move_distance = 10;
var block_move_range = 70;
var block_scale = 0.02;
var ripple_speed = 0.14;

var show_ripples = false;
var show_info = false;

var mouse_speed = void 0;
var fps = void 0,
    avgFps = 0;
var prevFrame = 0;
var prevTime = 0;
var fpsInterval = 1000;

/**
 * @type {Block[][]}
 */
var blocks = void 0;

/**
 * @type {Ripple[]}
 */
var ripples = [];

$(window).resize(function(){
  setup();
});

function setup() {
  if($('.homepage').length) {
    createCanvas(innerWidth, innerHeight);
    //	background(255);
    noStroke();
    fill(233, 230);
    rectMode(CENTER);
    noSmooth();

    var left_padding = Math.round(width % block_size) / 2;
    var top_padding = Math.round(height % block_size) / 2;

    blocks = Array.from({ length: Math.floor(height / block_size) }, function (v, y) {
        return Array.from({ length: Math.floor(width / block_size) }, function (v, x) {
            return new Block(left_padding + block_size * (x + 0.5), top_padding + block_size * (y + 0.5), y * Math.floor(width / block_size) + x);
        });
    });
  }
}

function draw() {
  if($('.homepage').length) {
    if (keyIsDown(32)) {
        if (random() < pow(fps / 60, 3)) {
            ripples.push(new Ripple(random(width), random(height), 0.4));
        }
    } else {
        if (random() < pow(fps / 60, 3) / 16) {
            ripples.push(new Ripple(random(width), random(height), 0.1));
        }
    }

    fps = frameRate();

    if (millis() - prevTime > fpsInterval) {
        avgFps = (frameCount - prevFrame) / fpsInterval * 1000;
        prevFrame = frameCount;
        prevTime = millis();
    }

    mouse_speed = dist(mouseX, mouseY, pmouseX, pmouseY);

    //    background(100, 140);

    background(255);

    rectMode(CENTER);

    ripples.forEach(function (ripple, i) {
        ripple.updateRadius();
        ripple.checkKill();
    });

    if (show_ripples) {
        strokeWeight(2);
        //		stroke(0);
        ripples.forEach(function (ripple, i) {
            ripple.draw();
        });
    }

    noStroke();
    blocks.forEach(function (line, i) {
        return line.forEach(function (block, j) {
            block.calcDiff(ripples);
            block.render();
        });
    });
    if (show_info) {
        rectMode(CORNER);
        fill(20, 200);
        rect(0, 0, 120, 64);
        fill(220);
        textFont('monospace', 16);
        text('Ripples: ' + ripples.length, 10, 24);
        text('FPS: ' + avgFps, 10, 48);
    }
  }
}

//function mousePressed() {
//    ripples.push(new Ripple(mouseX, mouseY, 1));
//}

function mouseMoved() {
    if (random() < pow(fps / 60, 3) * mouse_speed / 30) {
        ripples.push(new Ripple(mouseX, mouseY, 0.15 * mouse_speed / 40));
    }
}

function mouseDragged() {
    if (random() < pow(fps / 60, 3) * mouse_speed / 20) {
        ripples.push(new Ripple(mouseX, mouseY, 0.6 * mouse_speed / 40));
    }
}

function keyPressed() {
    if (keyCode === 73) {
        show_info = !show_info;
    } else if (keyCode === 82) {
        show_ripples = !show_ripples;
    }
}

var Block = function () {
    function Block(x, y, id) {
        _classCallCheck(this, Block);

        this.pos = createVector(x, y);
        this.id = id;
    }

    _createClass(Block, [{
        key: 'render',
        value: function render() {
            fill(0, cubicInOut(this.amp, 60, 240, 15));
            rect(this.pos.x + this.diff.x, this.pos.y + this.diff.y, (block_core + this.amp * block_scale) * 5, block_core + this.amp * block_scale * 0.5);
            rect(this.pos.x + this.diff.x, this.pos.y + this.diff.y, block_core + this.amp * block_scale * 0.5, (block_core + this.amp * block_scale) * 5);
        }

        /**
         * @param {Ripple[]} ripples
         */

    }, {
        key: 'calcDiff',
        value: function calcDiff(ripples) {
            var _this = this;

            this.diff = createVector(0, 0);
            this.amp = 0;

            ripples.forEach(function (ripple, i) {
                if (!ripple.dists[_this.id]) {
                    ripple.dists[_this.id] = dist(_this.pos.x, _this.pos.y, ripple.pos.x, ripple.pos.y);
                };
                var distance = ripple.dists[_this.id] - ripple.currRadius;
                if (distance < 0 && distance > -block_move_range * 2) {
                    if (!ripple.angles[_this.id]) {
                        ripple.angles[_this.id] = p5.Vector.sub(_this.pos, ripple.pos).heading();
                    };
                    var angle = ripple.angles[_this.id];
                    var localAmp = cubicInOut(-abs(block_move_range + distance) + block_move_range, 0, block_move_distance, block_move_range) * ripple.scale;
                    _this.amp += localAmp;
                    var movement = p5.Vector.fromAngle(angle).mult(localAmp);
                    _this.diff.add(movement);
                }
            });
        }
    }]);

    return Block;
}();

var Ripple = function () {
    function Ripple(x, y, scale) {
        _classCallCheck(this, Ripple);

        this.pos = createVector(x, y);
        this.initTime = millis();
        this.currRadius = 0;
        this.endRadius = max(dist(this.pos.x, this.pos.y, 0, 0), dist(this.pos.x, this.pos.y, 0, height), dist(this.pos.x, this.pos.y, width, 0), dist(this.pos.x, this.pos.y, height, width)) + block_move_range;
        this.scale = scale;

        this.dists = [];
        this.angles = [];
    }

    _createClass(Ripple, [{
        key: 'checkKill',
        value: function checkKill() {
            if (this.currRadius > this.endRadius) {
                ripples.splice(ripples.indexOf(this), 1);
            }
        }
    }, {
        key: 'updateRadius',
        value: function updateRadius() {
            this.currRadius = (millis() - this.initTime) * ripple_speed;
            //this.currRadius = 200;
        }
    }, {
        key: 'draw',
        value: function draw() {
            stroke(255, cubicInOut(this.scale, 30, 120, 1));
            noFill();
            ellipse(this.pos.x, this.pos.y, this.currRadius * 2, this.currRadius * 2);
        }
    }]);

    return Ripple;
}();

function cubicInOut(t, b, c, d) {
    if (t <= 0) return b;else if (t >= d) return b + c;else {
        t /= d / 2;
        if (t < 1) return c / 2 * t * t * t + b;
        t -= 2;
        return c / 2 * (t * t * t + 2) + b;
    }
}
