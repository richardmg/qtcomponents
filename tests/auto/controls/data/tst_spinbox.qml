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
import QtTest 1.0

Item {
    id: container
    width: 300; height: 300

    TestCase {
        id: testcase
        name: "Tests_SpinBox"
        when: windowShown

        property int arrowMargin: 4 // the mouse areas for the up/down arrows have margins
        property point mainCoord: "0,0"
        property point upCoord: "0,0"
        property point downCoord: "0,0"

        function test_increment_key() {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {maximumValue: 50}', container, '')
            spinbox.forceActiveFocus()

            compare(spinbox.maximumValue, 50)
            spinbox.value = spinbox.maximumValue - 3
            keyPress(Qt.Key_Up)
            compare(spinbox.value, spinbox.maximumValue - 2)
            keyPress(Qt.Key_Up)
            keyPress(Qt.Key_Up)
            compare(spinbox.value, spinbox.maximumValue)
            keyPress(Qt.Key_Up)
            compare(spinbox.value, spinbox.maximumValue)
            spinbox.destroy()
        }

        function test_decrement_key() {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {minimumValue: 10}', container, '')
            spinbox.forceActiveFocus()

            compare(spinbox.minimumValue, 10)
            spinbox.value = spinbox.minimumValue + 3
            keyPress(Qt.Key_Down)
            compare(spinbox.value, spinbox.minimumValue + 2)
            keyPress(Qt.Key_Down)
            keyPress(Qt.Key_Down)
            compare(spinbox.value, spinbox.minimumValue)
            keyPress(Qt.Key_Down)
            compare(spinbox.value, spinbox.minimumValue)
            spinbox.destroy()
        }

        function test_keyboard_input_data() {
            return [
                {tag: "1", input: [Qt.Key_1], value: 1},
                {tag: "10", input: [Qt.Key_1, Qt.Key_0], value: 10},
                // max 99 -> last '0' ignored
                {tag: "100", input: [Qt.Key_1, Qt.Key_0, Qt.Key_0], value: 10},

                {tag: "1.1", input: [Qt.Key_1, Qt.locale().decimalPoint, Qt.Key_1], value: 1.1, decimals: 1},
                {tag: "10.10", input: [Qt.Key_1, Qt.Key_0, Qt.locale().decimalPoint, Qt.Key_1, Qt.Key_0], value: 10.10, decimals: 2},
                // max 99 -> '3' ignored, decimals 2 -> '6' ignored
                {tag: "123.456", input: [Qt.Key_1, Qt.Key_2, Qt.Key_3, Qt.locale().decimalPoint, Qt.Key_4, Qt.Key_5, Qt.Key_6], value: 12.45, decimals: 2},

                {tag: "-1", input: [Qt.Key_Minus, Qt.Key_1], value: -1, minimumValue: -99},
                {tag: "-10", input: [Qt.Key_Minus, Qt.Key_1, Qt.Key_0], value: -10, minimumValue: -99},
                // min -99 -> last 0 ignored
                {tag: "-100", input: [Qt.Key_Minus, Qt.Key_1, Qt.Key_0, Qt.Key_0], value: -10, minimumValue: -99},

                {tag: "-1.1", input: [Qt.Key_Minus, Qt.Key_1, Qt.locale().decimalPoint, Qt.Key_1], value: -1.1, decimals: 1, minimumValue: -99},
                {tag: "-10.10", input: [Qt.Key_Minus, Qt.Key_1, Qt.Key_0, Qt.locale().decimalPoint, Qt.Key_1, Qt.Key_0], value: -10.10, decimals: 2, minimumValue: -99},
                // min -99 -> '3' ignored, decimals 2 -> '6' ignored
                {tag: "-123.456", input: [Qt.Key_Minus, Qt.Key_1, Qt.Key_2, Qt.Key_3, Qt.locale().decimalPoint, Qt.Key_4, Qt.Key_5, Qt.Key_6], value: -12.45, decimals: 2, minimumValue: -99},

                {tag: "2.54cm", input: [Qt.Key_2, Qt.locale().decimalPoint, Qt.Key_5, Qt.Key_4, Qt.Key_C, Qt.Key_M], value: 2.54, suffix: "cm", decimals: 2},
                {tag: "$100", input: [Qt.Key_Dollar, Qt.Key_1, Qt.Key_0, Qt.Key_0], value: 100, maximumValue: 100},

                {tag: "asdf foo", input: [Qt.Key_A, Qt.Key_S, Qt.Key_D, Qt.Key_F, Qt.Key_Space, Qt.Key_F, Qt.Key_O, Qt.Key_O], value: 0},
                {tag: "a1b2c3d4e5", input: [Qt.Key_A, Qt.Key_1, Qt.Key_B, Qt.Key_2, Qt.Key_C, Qt.Key_3, Qt.Key_D, Qt.Key_4, Qt.Key_E, Qt.Key_5], value: 1234, maximumValue: 2000},
            ]
        }

        function test_keyboard_input(data) {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {}', container, '')
            spinbox.forceActiveFocus()

            if (data.decimals !== undefined)
                spinbox.decimals = data.decimals
            if (data.minimumValue !== undefined)
                spinbox.minimumValue = data.minimumValue
            if (data.maximumValue !== undefined)
                spinbox.maximumValue = data.maximumValue
            if (data.prefix !== undefined)
                spinbox.prefix = data.prefix
            if (data.suffix !== undefined)
                spinbox.suffix = data.suffix

            // select all & input
            keyClick(Qt.Key_A, Qt.ControlModifier)
            for (var i = 0; i < data.input.length; ++i)
                keyClick(data.input[i])

            compare(spinbox.value, data.value)
        }

        function test_increment_mouse() {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {maximumValue: 50}', container, '')
            spinbox.forceActiveFocus()
            setCoordinates(spinbox)

            spinbox.value = spinbox.maximumValue - 3
            mouseClick(spinbox, upCoord.x, upCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.maximumValue - 2)
            mouseClick(spinbox, upCoord.x, upCoord.y, Qt.LeftButton)
            mouseClick(spinbox, upCoord.x, upCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.maximumValue)
            mouseClick(spinbox, upCoord.x, upCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.maximumValue)
            spinbox.destroy()
        }

        function test_decrement_mouse() {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {minimumValue: 10}', container, '')
            spinbox.forceActiveFocus()
            setCoordinates(spinbox)

            spinbox.value = spinbox.minimumValue + 3
            mouseClick(spinbox, downCoord.x, downCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.minimumValue + 2)
            mouseClick(spinbox, downCoord.x, downCoord.y, Qt.LeftButton)
            mouseClick(spinbox, downCoord.x, downCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.minimumValue)
            mouseClick(spinbox, downCoord.x, downCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.minimumValue)
            spinbox.destroy()
        }

        function test_move_mouse() {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {}', container, '')
            spinbox.forceActiveFocus()
            setCoordinates(spinbox)

            mouseMove(spinbox, mainCoord.x, mainCoord.y)
            compare(spinbox.__containsMouse, true)
            compare(spinbox.__upHovered, false)
            compare(spinbox.__downHovered, false)

            mouseMove(spinbox.parent, upCoord.x, upCoord.y)
            compare(spinbox.__upHovered, true)
            compare(spinbox.__downHovered, false)

            mouseMove(spinbox, downCoord.x, downCoord.y)
            compare(spinbox.__upHovered, false)
            compare(spinbox.__downHovered, true)

            mouseMove(spinbox, mainCoord.x - 2, mainCoord.y - 2)
            compare(spinbox.__containsMouse, false)
            compare(spinbox.__upHovered, false)
            compare(spinbox.__downHovered, false)
            spinbox.destroy()
        }

        function test_maxvalue() {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {}', container, '')
            spinbox.value = spinbox.maximumValue + 1
            compare(spinbox.value, spinbox.maximumValue)

            spinbox.maximumValue = 0;
            spinbox.minimumValue = 0;
            spinbox.value = 10;
            compare(spinbox.value, 0)

            spinbox.maximumValue = 5;
            spinbox.minimumValue = 0;
            spinbox.value = 10;
            compare(spinbox.value, 5)
            spinbox.destroy()
        }

        function test_minvalue() {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {}', container, '')
            spinbox.value = spinbox.minimumValue - 1
            compare(spinbox.value, spinbox.minimumValue)

            spinbox.maximumValue = 0;
            spinbox.minimumValue = 6;
            spinbox.value = 3;
            compare(spinbox.value, 6)

            spinbox.maximumValue = 10;
            spinbox.minimumValue = 6;
            spinbox.value = 0;
            compare(spinbox.value, 6)
            spinbox.destroy()
        }

        function test_decimals() {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {}', container, '')

            spinbox.decimals = 0
            spinbox.value = 1.00001
            compare(spinbox.value, 1)
            compare(spinbox.__text, "1")

            spinbox.decimals = 1
            spinbox.value = 1.00001
            compare(spinbox.value, 1)
            compare(spinbox.__text, "1" + Qt.locale().decimalPoint + "0")
            spinbox.value = 1.1
            compare(spinbox.value, 1.1)
            compare(spinbox.__text, "1" + Qt.locale().decimalPoint + "1")

            spinbox.decimals = 5
            spinbox.value = 1.00001
            compare(spinbox.value, 1.00001)
            compare(spinbox.__text, "1" + Qt.locale().decimalPoint + "00001")

            spinbox.decimals = 6
            compare(spinbox.value, 1.00001)
            compare(spinbox.__text, "1" + Qt.locale().decimalPoint + "000010")
            spinbox.destroy()
        }

        function test_stepsize()
        {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {}', container, '')
            spinbox.forceActiveFocus()

            spinbox.stepSize = 2
            spinbox.value = 10

            compare(spinbox.value, 10)

            keyPress(Qt.Key_Up)
            compare(spinbox.value, 10 + spinbox.stepSize)

            var previousValue = spinbox.value
            keyPress(Qt.Key_Down)
            compare(spinbox.value, previousValue - spinbox.stepSize)
            spinbox.destroy()
        }

        function test_negativeStepSize()
        {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {}', container, '')
            spinbox.forceActiveFocus()

            spinbox.minimumValue = -50
            spinbox.maximumValue = 50

            spinbox.stepSize = -2
            spinbox.value = 5

            compare(spinbox.value, 5)

            keyPress(Qt.Key_Up)
            compare(spinbox.value, 5 + spinbox.stepSize)

            var previousValue = spinbox.value
            keyPress(Qt.Key_Down)
            compare(spinbox.value, previousValue - spinbox.stepSize)

            // test on the edges

            spinbox.value = -49
            keyPress(Qt.Key_Up)
            compare(spinbox.value, spinbox.minimumValue)

            spinbox.value = 49
            keyPress(Qt.Key_Down)
            compare(spinbox.value, spinbox.maximumValue)
            spinbox.destroy()
        }

        function test_initialization_order()
        {
            var spinbox = Qt.createQmlObject("import QtQuick.Controls 1.0; SpinBox { id: spinbox;"  +
                                             "maximumValue: 2000; value: 1000; implicitWidth:80}",
                                             container, '')
            compare(spinbox.value, 1000);

            var spinbox2 = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox { minimumValue: -1000 ; value:-1000}',
                                             container, '')
            compare(spinbox2.value, -1000);
            spinbox.destroy()
            spinbox2.destroy()
        }

        function test_activeFocusOnPress(){
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {x: 20; y: 20; width: 100; height: 50}', container, '')
            spinbox.activeFocusOnPress = false
            verify(!spinbox.activeFocus)
            mouseClick(spinbox, 30, 30)
            verify(!spinbox.activeFocus)
            spinbox.activeFocusOnPress = true
            verify(!spinbox.activeFocus)
            mouseClick(spinbox, 30, 30)
            verify(spinbox.activeFocus)
            spinbox.destroy()
        }

        function test_activeFocusOnTab() {
            var test_control = 'import QtQuick 2.1; \
            import QtQuick.Controls 1.0;            \
            Item {                                  \
                width: 200;                         \
                height: 200;                        \
                property alias control1: _control1; \
                property alias control2: _control2; \
                property alias control3: _control3; \
                SpinBox  {                          \
                    y: 20;                          \
                    id: _control1;                  \
                    activeFocusOnTab: true;         \
                }                                   \
                SpinBox  {                          \
                    y: 70;                          \
                    id: _control2;                  \
                    activeFocusOnTab: false;        \
                }                                   \
                SpinBox  {                          \
                    y: 120;                         \
                    id: _control3;                  \
                    activeFocusOnTab: true;         \
                }                                   \
            }                                       '

            var control = Qt.createQmlObject(test_control, container, '')
            control.control1.forceActiveFocus()
            verify(control.control1.activeFocus)
            verify(!control.control2.activeFocus)
            verify(!control.control3.activeFocus)
            keyPress(Qt.Key_Tab)
            verify(!control.control1.activeFocus)
            verify(!control.control2.activeFocus)
            verify(control.control3.activeFocus)
            keyPress(Qt.Key_Tab)
            sleep(4000)
            verify(control.control1.activeFocus)
            verify(!control.control2.activeFocus)
            verify(!control.control3.activeFocus)
            keyPress(Qt.Key_Tab, Qt.ShiftModifier)
            verify(!control.control1.activeFocus)
            verify(!control.control2.activeFocus)
            verify(control.control3.activeFocus)
            keyPress(Qt.Key_Tab, Qt.ShiftModifier)
            verify(control.control1.activeFocus)
            verify(!control.control2.activeFocus)
            verify(!control.control3.activeFocus)

            control.control2.activeFocusOnTab = true
            control.control3.activeFocusOnTab = false
            keyPress(Qt.Key_Tab)
            verify(!control.control1.activeFocus)
            verify(control.control2.activeFocus)
            verify(!control.control3.activeFocus)
            keyPress(Qt.Key_Tab)
            verify(control.control1.activeFocus)
            verify(!control.control2.activeFocus)
            verify(!control.control3.activeFocus)
            keyPress(Qt.Key_Tab, Qt.ShiftModifier)
            verify(!control.control1.activeFocus)
            verify(control.control2.activeFocus)
            verify(!control.control3.activeFocus)
            keyPress(Qt.Key_Tab, Qt.ShiftModifier)
            verify(control.control1.activeFocus)
            verify(!control.control2.activeFocus)
            verify(!control.control3.activeFocus)
            control.destroy()
        }

        function test_ImplicitSize() // Verify if we correctly grow and shrink depending on contents
        {
            var spinbox = Qt.createQmlObject('import QtQuick.Controls 1.0; SpinBox {}', container, '')
            spinbox.forceActiveFocus()
            spinbox.minimumValue = -50
            spinbox.maximumValue = 50

            var oldSize = spinbox.implicitWidth
            spinbox.maximumValue = 5000
            verify(oldSize < spinbox.implicitWidth)
            oldSize = spinbox.implicitWidth
            spinbox.maximumValue = 50
            verify(oldSize > spinbox.implicitWidth)

            oldSize = spinbox.implicitWidth
            spinbox.minimumValue = -5000
            verify(oldSize < spinbox.implicitWidth)

            spinbox.minimumValue = -50
            oldSize = spinbox.implicitWidth
            spinbox.minimumValue = -5000
            verify(oldSize < spinbox.implicitWidth)

            spinbox.minimumValue = -50
            oldSize = spinbox.implicitWidth
            spinbox.minimumValue = -5000
            verify(oldSize < spinbox.implicitWidth)

            spinbox.minimumValue = -50
            spinbox.decimals = 0
            oldSize = spinbox.implicitWidth
            spinbox.decimals = 4
            verify(oldSize < spinbox.implicitWidth)
            spinbox.destroy()
        }

        function setCoordinates(item)
        {
            mainCoord.x = item.x + 1
            mainCoord.y = item.y + 1
            upCoord.x = item.x + item.width - arrowMargin
            upCoord.y = item.y + arrowMargin
            downCoord.x = upCoord.x
            downCoord.y = item.y + item.height - arrowMargin
        }


    }
}

