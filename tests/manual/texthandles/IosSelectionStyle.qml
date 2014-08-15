/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick _controls module of the Qt Toolkit.
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

QtObject {

    property Component selectionDelegateComponent: Component {
        Rectangle {
            id: selectionDelegate
            x: -width + 10
            y: -20
            width: 80
            height: knob.height + knobLine.height + 60
            border.width: outlineBox.checked ? 1 : 0
            color: "transparent"

            Rectangle {
                id: knob
                x: knobLine.x + (knobLine.width / 2) - (width / 2)
                y: knobLine.y - height + 1
                width: 10
                height: width
                radius: width / 2
                visible: knobLine.visible
                color: knobLine.color
            }
            Rectangle {
                id: knobLine
                x: -parent.x - width
                y: -parent.y - 1
                width: 2
                height: editor.positionToRectangle(editor.selectionStart).height + 1
                color: "#ff146fe1"
            }
        }
    }

    property Component cursorDelegateComponent: Component {
        Rectangle {
            id: cursorDelegate
            x: -10
            y: -20
            width: 80
            height: knob.height + knobLine.height + 60
            border.width: outlineBox.checked ? 1 : 0
            color: "transparent"

            Rectangle {
                id: knob
                x: knobLine.x + (knobLine.width / 2) - (width / 2)
                y: knobLine.y + knobLine.height - 1
                width: 10
                height: width
                radius: width / 2
                visible: knobLine.visible
                color: knobLine.color
            }
            Rectangle {
                id: knobLine
                x: -parent.x
                y: -parent.y
                width: 2
                height: editor.positionToRectangle(editor.selectionEnd).height + 1
                color: "#ff146fe1"
            }
        }
    }
}
