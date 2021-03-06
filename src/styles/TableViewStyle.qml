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

ScrollViewStyle {
    id: root

    property color textColor: __syspal.text
    property color highlightedTextColor: "white"

    property SystemPalette __syspal: SystemPalette {
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    property Component headerDelegate: Rectangle {
        gradient: Gradient {
            GradientStop {position: 0 ; color: "#eee"}
            GradientStop {position: 1 ; color: "#ddd"}
        }

        implicitHeight: 16
        implicitWidth: 80
        Text {
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            anchors.leftMargin: 4
            text: itemValue
            color: textColor
            renderType: Text.NativeRendering
        }
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: "#aaa"
        }
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            width: 1
            color: "#ccc"
        }
    }

    property Component rowDelegate: Rectangle {
        implicitHeight: 20
        implicitWidth: 80
        property color selectedColor: hasActiveFocus ? "#49e" : "#999"
        gradient: Gradient {
            GradientStop { color: rowSelected ? Qt.lighter(selectedColor, 1.1)  : alternateBackground ? "#eee" : "white" ; position: 1 }
            GradientStop { color: rowSelected ? Qt.lighter(selectedColor, 1.2)  : alternateBackground ? "#eee" : "white" ; position: 0 }
        }
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: rowSelected ? Qt.darker(selectedColor, 1.1) : "transparent"
        }
        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: rowSelected ? Qt.darker(selectedColor, 1.1) : Qt.darker(parent.color, 1.15)
        }
    }

    property Component standardDelegate: Item {
        height: Math.max(16, label.implicitHeight)
        property int implicitWidth: sizehint.paintedWidth + 4

        Text {
            id: label
            objectName: "label"
            width: parent.width
            anchors.margins: 6
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: itemTextAlignment
            anchors.verticalCenter: parent.verticalCenter
            elide: itemElideMode
            text: itemValue != undefined ? itemValue : ""
            color: itemTextColor
            renderType: Text.NativeRendering
        }
        Text {
            id: sizehint
            font: label.font
            text: itemValue ? itemValue : ""
            visible: false
        }
    }
}

