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
    \qmltype SpinBoxStyle
    \internal
    \inqmlmodule QtQuick.Controls.Styles 1.0
    \brief provides custom styling for SpinBox
*/

Style {
    id: spinboxStyle

    property int topMargin: 0
    property int leftMargin: 4
    property int rightMargin: 12
    property int bottomMargin: 0

    property color foregroundColor: __syspal.text
    property color backgroundColor: __syspal.base
    property color selectionColor: __syspal.highlight
    property color selectedTextColor: __syspal.highlightedText

    property var __syspal: SystemPalette {
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    property Component upControl: Item {
        implicitWidth: 18
        Image {
            source: "images/arrow-up.png"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 1
            opacity: 0.7
            anchors.horizontalCenterOffset:  -1
        }
    }

    property Component downControl: Item {
        implicitWidth: 18
        Image {
            source: "images/arrow-down.png"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -1
            anchors.horizontalCenterOffset:  -1
            opacity: 0.7
        }
    }

    property Component background: Item {
        BorderImage {
            anchors.fill: parent
            source: "images/editbox.png"
            border.left: 4
            border.right: 4
            border.top: 4
            border.bottom: 4
            anchors.bottomMargin: -2
        }
    }

    property Component panel:  Item {
        id: styleitem
        implicitWidth: control.__contentWidth + 26
        implicitHeight: 23

        property color foregroundColor: spinboxStyle.foregroundColor
        property color backgroundColor: spinboxStyle.backgroundColor
        property color selectionColor: spinboxStyle.selectionColor
        property color selectedTextColor: spinboxStyle.selectedTextColor

        property int leftMargin: spinboxStyle.leftMargin
        property int rightMargin: spinboxStyle.rightMargin
        property int topMargin: spinboxStyle.topMargin
        property int bottomMargin: spinboxStyle.bottomMargin

        property rect upRect: Qt.rect(width - upControlLoader.implicitWidth, 0, upControlLoader.implicitWidth, height / 2 + 1)
        property rect downRect: Qt.rect(width - downControlLoader.implicitWidth, height / 2, downControlLoader.implicitWidth, height / 2)

        property int horizontalTextAlignment: Qt.AlignLeft
        property int verticalTextAlignment: Qt.AlignVCenter

        property SpinBox cref: control

        Loader {
            id: backgroundLoader
            anchors.fill: parent
            sourceComponent: background
            property SpinBox control: cref
        }

        Loader {
            id: upControlLoader
            x: upRect.x
            y: upRect.y
            width: upRect.width
            height: upRect.height
            sourceComponent: upControl
            property SpinBox control: cref
        }

        Loader {
            id: downControlLoader
            x: downRect.x
            y: downRect.y
            width: downRect.width
            height: downRect.height
            sourceComponent: downControl
            property SpinBox control: cref
        }

        BorderImage {
            anchors.fill: parent
            anchors.margins: -1
            anchors.topMargin: -2
            anchors.rightMargin: 0
            source: "images/focusframe.png"
            visible: control.activeFocus
            border.left: 4
            border.right: 4
            border.top: 4
            border.bottom: 4
        }

    }
}
