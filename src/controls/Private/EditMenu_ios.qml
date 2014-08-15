/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick controls module of the Qt Toolkit.
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
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Item {

    property Menu defaultMenu: Menu {
        MenuItem {
            text: "cut"
            visible: selectionStart !== selectionEnd
            onTriggered: {
                cut();
                clearSelection();
            }
        }
        MenuItem {
            text: "copy"
            visible: selectionStart !== selectionEnd
            onTriggered: {
                copy();
                clearSelection();
            }
        }
        MenuItem {
            text: "paste"
            onTriggered: paste();
        }
        MenuItem {
            text: "delete"
            visible: selectionStart !== selectionEnd
            onTriggered: remove(selectionStart, selectionEnd)
        }
        MenuItem {
            text: "select"
            visible: selectionStart === selectionEnd
            onTriggered: selectWord();
        }
        MenuItem {
            text: "select all"
            visible: !(selectionStart === 0 && selectionEnd === length)
            onTriggered: selectAll();
        }
    }

    property bool showMenuFromTouchAndHold: false

    Connections {
        target: mouseArea ? mouseArea : null

        onPressAndHold: {
            if (!control.menu)
                return;

            var pos = input.positionAt(mouseArea.mouseX, mouseArea.mouseY);
            input.select(pos, pos);
            if (!input.activeFocus || (selectionStart != selectionEnd)) {
                selectWord();
            } else {
                showMenuFromTouchAndHold = true;
                menuTimer.start();
            }
        }

        onClicked: {
            if (control.menu.__popupVisible)
                clearSelection();
            else
                input.activate();

            if (input.activeFocus) {
                var pos = input.positionAt(mouse.x, mouse.y)
                input.moveHandles(pos, pos)
            }
        }

//        onCanceled: {
//            clearSelection();
//        }
    }

//    Connections {
//        target: control.menu ? control.menu : null
//        ignoreUnknownSignals: true
//        onPopupVisibleChanged:{
//            if (control.menu.__popupVisible)
//                return;

//            // The menu was closed for some reason. But this might just be because the user is
//            // dragging on handles, or triggered 'select' item etc. But if we're not told to
//            // open it again within a small time frame, we clear the selection.
//            showMenuFromTouchAndHold = false;
//            clearSelectionTimer.start();
//        }
//    }

    Timer {
        id: clearSelectionTimer
        interval: 10
        onTriggered: {
            if (!control.menu.__popupVisible && !(cursorHandle.pressed || selectionHandle.pressed))
                clearSelection();
        }
    }

    Connections {
        target: cursorHandle ? cursorHandle : null
        ignoreUnknownSignals: true
        property bool handleDragged: false
        onPositionChanged: handleDragged = true
        onPressedChanged: {
            // Whenever the user do a touch any of the handles (or anywhere else on
            // the screen, if we could track it), we temporarily close the menu.
            // If the handle is not dragged, we assume that the user intended to close the menu.
            if (cursorHandle.pressed)
                handleDragged = false;
            else if (!handleDragged)
                clearSelection();
            menuTimer.start()
        }
    }

    Connections {
        target: selectionHandle ? selectionHandle : null
        ignoreUnknownSignals: true
        property bool handleDragged: false
        onPositionChanged: handleDragged = true
        onPressedChanged: {
            if (selectionHandle.pressed)
                handleDragged = false;
            else if (!handleDragged)
                clearSelection();
            menuTimer.start()
        }
    }

    Connections {
        target: flickable
        ignoreUnknownSignals: true
        onMovingChanged: menuTimer.start()
    }

    Connections {
        id: selectionConnections
        target: input
        ignoreUnknownSignals: true
        onSelectionStartChanged: menuTimer.start()
        onSelectionEndChanged: menuTimer.start()
        onActiveFocusChanged: menuTimer.start()
    }

    Timer {
        // We use a timer so that we end up with one update when multiple connections fire at the same time.
        // Basically we wan't the menu to be open if the user does a press and hold, or if we have a selection.
        // The exceptions are if the user is moving selection handles or otherwise touching the screen (e.g flicking).
        // What is currently missing are showing a magnifyer to place the cursor, and to reshow the edit menu when
        // flicking stops.
        id: menuTimer
        interval: 1
        onTriggered: {
            if (!control.menu || !cursorHandle.delegate)
                return;

            if ((showMenuFromTouchAndHold || selectionStart !== selectionEnd)
                    && (!cursorHandle.pressed && !selectionHandle.pressed)
                    && (!flickable || !flickable.moving))
                openMenu()
            else
                control.menu.__dismissMenu();
        }
    }

    function openMenu()
    {
        // center menu on top of selection:
        var r1 = input.positionToRectangle(input.selectionStart);
        var r2 = input.cursorRectangle;
        var xMin = Math.min(r1.x, r2.x);
        var xMax = Math.max(r1.x, r2.x);
        var centerX = xMin + ((xMax - xMin) / 2);
        var popupPos = input.mapToItem(null, centerX, r1.y);
        control.menu.__dismissMenu();
        control.menu.__popup(popupPos.x, popupPos.y, -1, Menu.EditMenu);
    }

    function clearSelection()
    {
        showMenuFromTouchAndHold = false;
        select(selectionEnd, selectionEnd);
        menuTimer.start();
    }
}
