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
    \qmltype TabView
    \inqmlmodule QtQuick.Controls 1.0
    \ingroup views
    \brief A control that allows the user to select one of multiple stacked items.

*/

FocusScope {
    id: root
    implicitWidth: 150
    implicitHeight: 150

    /*! The current tab index */
    property int currentIndex: 0

    /*! The current tab count */
    property int count: 0

    /*! The visibility of the tab frame around contents */
    property bool frameVisible: true

    /*! The visibility of the tab bar */
    property bool tabsVisible: true

    /*!
        \qmlproperty enumeration TabView::tabPosition

        \list
        \li Qt.TopEdge (default)
        \li Qt.BottomEdge
        \endlist
    */
    property int tabPosition: Qt.TopEdge

    /*! \internal */
    default property alias data: stack.data

    /*! Adds a new tab page with title with and optional Component.
        Returns the newly added tab.
    */
    function addTab(title, component) {
        var tab = tabcomp.createObject(stack)
        tab.sourceComponent = component
        __tabs.append({tab: tab})
        tab.parent = stack
        tab.title = title
        __setOpacities()
        return tab
    }

    /*! Inserts a new tab with title at index, with an optional Component.
        Returns the newly added tab.
    */
    function insertTab(index, title, component) {
        var tab = tabcomp.createObject(stack)
        tab.sourceComponent = component
        tab.parent = stack
        tab.title = title
        __tabs.insert(index, {tab: tab})
        __setOpacities()
        return tab
    }

    /*! Removes and destroys a tab at the given \a index. */
    function removeTab(index) {
        var tab = __tabs.get(index).tab
        __tabs.remove(index, 1)
        tab.destroy()
        if (currentIndex > 0)
            currentIndex--
        __setOpacities()
    }

    /*! Moves a tab \a from index \a to another. */
    function moveTab(from, to) {
        __tabs.move(from, to, 1)

        if (currentIndex == from) {
            currentIndex = to
        } else {
            var start = Math.min(from, to)
            var end = Math.max(from, to)
            if (currentIndex >= start && currentIndex <= end) {
                if (from < to)
                    --currentIndex
                else
                    ++currentIndex
            }
        }
    }

    /*! Returns the \l Tab item at \a index. */
    function tabAt(index) {
        return __tabs.get(index).tab
    }

    /*! \internal */
    property ListModel __tabs: ListModel { }

    /*! \internal */
    property Component style: Qt.createComponent(Settings.theme() + "/TabViewStyle.qml", root)

    /*! \internal */
    property var __styleItem: loader.item

    onCurrentIndexChanged: __setOpacities()

    /*! \internal */
    function __setOpacities() {
        for (var i = 0; i < __tabs.count; ++i) {
            var child = __tabs.get(i).tab
            child.visible = (i == currentIndex ? true : false)
        }
        count = __tabs.count
    }

    activeFocusOnTab: false

    Component {
        id: tabcomp
        Tab {}
    }

    TabBar {
        id: tabbarItem
        objectName: "tabbar"
        tabView: root
        style: loader.item
        anchors.top: parent.top
        anchors.left: root.left
        anchors.right: root.right
    }

    Loader {
        id: loader
        z: tabbarItem.z - 1
        sourceComponent: style
        property var control: root
    }

    Loader {
        id: frameLoader
        z: tabbarItem.z - 1

        anchors.fill: parent
        anchors.topMargin: tabbarItem && tabsVisible && tabPosition == Qt.TopEdge ? Math.max(0, tabbarItem.height - stack.baseOverlap) : 0
        anchors.bottomMargin: tabbarItem && tabsVisible && tabPosition == Qt.BottomEdge ? Math.max(0, tabbarItem.height - stack.baseOverlap) : 0
        sourceComponent: frameVisible && loader.item ? loader.item.frame : null
        property var control: root

        Item {
            id: stack

            anchors.fill: parent
            anchors.margins: (frameVisible ? frameWidth : 0)
            anchors.topMargin: anchors.margins + (style =="mac" ? 6 : 0)
            anchors.bottomMargin: anchors.margins + (style =="mac" ? 6 : 0)

            property int frameWidth
            property string style
            property int baseOverlap

            Component.onCompleted: {
                for (var i = 0 ; i < stack.children.length ; ++i) {
                    if (stack.children[i].Accessible.role === Accessible.LayeredPane)
                        __tabs.append({tab: stack.children[i]})
                }
                __setOpacities()
            }

            function onDynamicTabDestroyed() {
                for (var i = 0; i < stack.children.length; ++i) {
                    if (this === stack.children[i]) {
                        root.removeTab(i)
                        break
                    }
                }
            }
        }
        onLoaded: { item.z = -1 }
    }

    onChildrenChanged: {
        var tabAdded = false
        for (var i = 0; i < children.length; ++i) {
            var child = children[i]
            if (child.Accessible.role === Accessible.LayeredPane) {
                __tabs.append({tab: child})
                child.parent = stack
                child.Component.onDestruction.connect(stack.onDynamicTabDestroyed.bind(child))
                tabAdded = true
            }
        }
        if (tabAdded)
            __setOpacities()
    }

    states: [
        State {
            name: "Bottom"
            when: tabPosition == Qt.BottomEdge && tabbarItem != undefined
            PropertyChanges {
                target: tabbarItem
                anchors.topMargin: tabbarItem.height
            }
            AnchorChanges {
                target: tabbarItem
                anchors.top: undefined
                anchors.bottom: root.bottom
            }
        }
    ]
}
