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
            onTriggered: cut()
        }
        MenuItem {
            text: "copy"
            visible: selectionStart !== selectionEnd
            onTriggered: copy();
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

    Connections {
        target: mouseArea ? mouseArea : null
        onPressAndHold: {
            selectionConnections.target = null;

            var pos = input.positionAt(mouseArea.mouseX, mouseArea.mouseY);
            input.moveHandles(pos, control.activeFocus ? -1 : pos);
            input.activate()
            positionAndShowMenu();

            selectionConnections.target = control;
        }
    }

    Connections {
        target: cursorHandle ? cursorHandle : null
        ignoreUnknownSignals: true
        onPressedChanged: menuTimer.start()
    }

    Connections {
        target: selectionHandle ? selectionHandle : null
        ignoreUnknownSignals: true
        onPressedChanged: menuTimer.start()
    }

    Connections {
        id: selectionConnections
        target: input
        onSelectionStartChanged: menuTimer.start()
        onSelectionEndChanged: menuTimer.start()
        onActiveFocusChanged: menuTimer.start()
    }

    Timer {
        // Use a timer so that we end up with one
        // update for selectionStart/selectionEnd
        id: menuTimer
        interval: 1
        onTriggered: updateMenuVisibility()
    }

    function positionAndShowMenu()
    {
        var r1 = input.positionToRectangle(input.selectionStart);
        var r2 = input.cursorRectangle;
        var xMin = Math.min(r1.x, r2.x);
        var xMax = Math.max(r1.x, r2.x);
        var centerX = xMin + ((xMax - xMin) / 2);
        var popupPos = input.mapToItem(null, centerX, r1.y);
        control.menu.__popup(popupPos.x, popupPos.y, -1, Menu.EditMenu);
    }

    function updateMenuVisibility()
    {
        selectionConnections.target = null;
        var handlesPressed = cursorHandle.pressed || selectionHandle.pressed;
        var haveSelection = selectionStart !== selectionEnd

        if (!handlesPressed && haveSelection && control.activeFocus){
            positionAndShowMenu();
        } else {
            control.menu.__dismissMenu();
        }
        selectionConnections.target = control;
    }


}
