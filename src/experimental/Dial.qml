/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0

/*!
    \qmltype Dial
    \inqmlmodule QtQuick.Controls 1.0
    \brief Dial provides a dial control.
*/

Item {
    id: dial

    width: 100
    height: 100

    property alias maximumValue: range.maximumValue
    property alias minimumValue: range.minimumValue
    property alias value: range.value
    property alias stepSize: range.stepSize

    property bool wrapping: false
    property bool tickmarksEnabled: false
    property bool activeFocusOnPress: false

    /* \internal */
    property alias __containsMouse: mouseArea.containsMouse

    Accessible.role: Accessible.Dial
    Accessible.name: value

    RangeModel {
        id: range
        minimumValue: 0.0
        maximumValue: 1.0
        stepSize: 0.0
        value: 0
    }

    MouseArea {
        id: mouseArea
        anchors.fill:parent
        property bool inDrag
        hoverEnabled:true

        onPositionChanged: {
            if (pressed) {
                value = valueFromPoint(mouseX, mouseY)
                inDrag = true
            }
        }
        onPressed: {
            value = valueFromPoint(mouseX, mouseY)
             if (activeFocusOnPress) dial.focus = true
        }

        onReleased:inDrag = false;
        function bound(val) { return Math.max(minimumValue, Math.min(maximumValue, val)); }

        function valueFromPoint(x, y)
        {
            var yy = height/2.0 - y;
            var xx = x - width/2.0;
            var a = (xx || yy) ? Math.atan2(yy, xx) : 0;

            if (a < Math.PI/ -2)
                a = a + Math.PI * 2;

            var dist = 0;
            var minv = minimumValue*100, maxv = maximumValue*100;

            if (minimumValue < 0) {
                dist = -minimumValue;
                minv = 0;
                maxv = maximumValue + dist;
            }

            var r = maxv - minv;
            var v;
            if (wrapping)
                v =  (0.5 + minv + r * (Math.PI * 3 / 2 - a) / (2 * Math.PI));
            else
                v =  (0.5 + minv + r* (Math.PI * 4 / 3 - a) / (Math.PI * 10 / 6));

            if (dist > 0)
                v -= dist;
            return maximumValue - bound(v/100)
        }
    }
    StyleItem {
        anchors.fill: parent
        elementType: "dial"
        hasFocus: dial.focus
        sunken: mouseArea.pressed
        maximum: range.maximumValue * 100
        minimum: range.minimumValue * 100
        value: visualPos * 100
        enabled: dial.enabled
        step: range.stepSize * 100
        activeControl: tickmarksEnabled ? "tick" : ""
        property real visualPos : range.value

        Behavior on visualPos {
            enabled: !mouseArea.inDrag
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutSine
            }
        }
    }
//    WheelArea { // move this to MouseArea::onWheel
//        id: wheelarea
//        anchors.fill: parent
//        horizontalMinimumValue: dial.minimumValue
//        horizontalMaximumValue: dial.maximumValue
//        verticalMinimumValue: dial.minimumValue
//        verticalMaximumValue: dial.maximumValue
//        property real step: (dial.maximumValue - dial.minimumValue)/100

//        onVerticalWheelMoved: {
//            value += verticalDelta/4*step
//        }

//        onHorizontalWheelMoved: {
//            value += horizontalDelta/4*step
//        }
//    }
}
