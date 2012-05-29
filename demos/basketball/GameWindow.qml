/**
 * Copyright (C) 2012 by INdT
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 * @author
 */

QuasiGame {
    id: game

    property int score: 0
    property int scale: 200
    property real freethrow: 5.80 * game.scale

    width: 7.60 * game.scale
    height: 900

    currentScene: scene

    QuasiPhysicsScene {
        id: scene

        width: parent.width
        height: parent.height

        gravity: Qt.point(0, -30.0)

        Rectangle {
            id: backgound
            anchors.fill: parent
            color: "darkCyan"
        }

        Image {
            id: backboardhandler
            anchors.bottom: parent.bottom
            source: ":/images/backboardhandler.png"
        }

        QuasiBody {
            id: backboard

            bodyType: Quasi.StaticBodyType

            x: 1.2 * game.scale
            y: parent.height - (3.95 * game.scale)

            width: 4
            height: 1.05 * game.scale

            friction: 1.0
            density: 0.1
            restitution: 0.0

            Rectangle {
                color: "white"
                anchors.fill: parent
            }
        }

        QuasiBody {
            id: baskethandler

            bodyType: Quasi.StaticBodyType

            x: backboard.x + backboard.width
            y: parent.height - (3.05 * game.scale)

            width: (1.575 * game.scale) - x - (ball.width / 1.9)
            height: 8

            friction: 1.0
            density: 0.1
            restitution: 0.0

            Rectangle {
                color: "white"
                anchors.fill: parent
            }
        }

        QuasiBody {
            id: basketring

            bodyType: Quasi.StaticBodyType

            x: baskethandler.x + baskethandler.width + (ball.width * 1.2)
            y: baskethandler.y

            width: 8
            height: 8

            friction: 1.0
            density: 0.1
            restitution: 0.0

            Rectangle {
                color: "white"
                anchors.fill: parent
            }
        }

        Image {
            id: basket
            anchors.left: baskethandler.right
            anchors.right: basketring.left

            y: baskethandler.y
            z: 100

            source: ":/images/basket.png"
        }

        QuasiBody {
            id: ground

            bodyType: Quasi.StaticBodyType

            x: 0
            y: parent.height - height

            width: parent.width
            height: 10

            friction: 0.3
            density: 5
            restitution: 0.6

            Rectangle {
                color: "darkGreen"
                anchors.fill: parent
            }
        }

        QuasiBody {
            id: ball
            property int centerX: x + (width / 2)
            property int centerY: y + (height / 2)
            property bool threw: false

            width: 0.25 * game.scale
            height: 0.25 * game.scale

            friction: 0.3
            density: 50
            restitution: 0.6
            sleepingAllowed: false

            shapeGeometry: Quasi.CircleBodyShape

            x: game.freethrow
            y: game.height - height

            Image {
                id: ballimg
                anchors.fill: parent
                source: ":/images/ball.png"
            }

            onYChanged: {
                if (!threw)
                    return;
                if (centerX > baskethandler.x + baskethandler.width
                        && centerX < basketring.x
                        && centerY < basketring.y + (ball.height / 2)
                        && centerY > basketring.y) {
                    score++;
                    threw = false;
                    console.log("score = " + score);
                }
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {

                if (ball.centerX > game.freethrow
                        && ball.centerX < game.freethrow + ball.width
                        && ball.centerY > parent.height - ball.height) {
                    var xLaunch = 2 * game.scale * (game.mouse.x - ball.centerX);
                    var yLaunch = 2 * game.scale * (game.mouse.y - ball.centerY);

                    ball.applyLinearImpulse(Qt.point(xLaunch, yLaunch), Qt.point(ball.centerX, ball.centerY));
                    ball.threw = true;
                } else {
                    ball.setLinearVelocity(Qt.point(0, 0));
                    ball.x = game.freethrow
                    ball.y = parent.height - ball.height;
                    ball.threw = false;
                }
            }
        }
    }
}
