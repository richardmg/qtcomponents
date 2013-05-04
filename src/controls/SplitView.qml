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
import QtQuick.Layouts 1.0
import QtQuick.Controls.Private 1.0 as Private

/*!
    \qmltype SplitView
    \inqmlmodule QtQuick.Controls 1.0
    \ingroup views
    \brief Lays out items with a draggable splitter between each item.

    SplitView is a control that lays out items horizontally or
    vertically with a draggable splitter between each item.

    There will always be one (and only one) item in the SplitView that has Layout.fillWidth
    set to \c true (or Layout.fillHeight, if orientation is Qt.Vertical). This means that the
    item will get all the remaining space when other items have been laid out.
    By default, the last visible child of the SplitView will have this property set, but
    this can be changed by explititly setting Layout.fillWidth on another item.
    As this item will automatically be resized to fit the extra space, it
    will ignore explicit assignments to width and height.

    A handle can belong to the item either on the left or top side, or on the right or bottom side:
    \list
    \li If the fillWidth item is to the right: the handle belongs to the left item.
    \li if the fillWidth item is on the left: the handle belongs to the right item.
    \endlist

    This will again control which item gets resized when the user drags a handle,
    and which handle gets hidden when an item is told to hide.
    SplitView supports setting attached Layout properties on child items, which means that you
    can control minimumWidth, minimumHeight, maximumWidth and maximumHeight (in addition
    to fillWidth/fillHeight) for each child.

    Example:

    To create a SplitView with three items, and let the center item get superfluous space, one
    could do the following:

    \qml
       SplitView {
           anchors.fill: parent
           orientation: Qt.Horizontal

           Rectangle {
               width: 200
               Layout.maximumWidth: 400
               color: "gray"
           }
           Rectangle {
               id: centerItem
               Layout.minimumWidth: 50
               Layout.fillWidth: true
               color: "darkgray"
           }
           Rectangle {
               width: 200
               color: "gray"
           }
       }
   \endqml
*/

Item {
    id: root

    /*!
        \qmlproperty enumeration SplitView::orientation

        This property holds the orientation of the SplitView.
        The value can be either \c Qt.Horizontal or \c Qt.Vertical.
        The default value is \c Qt.Horizontal.
    */
    property int orientation: Qt.Horizontal

    /*!
        This property holds the delegate that will be instantiated between each
        child item. Inside the delegate the following properties are available:
        \list
        \li int \c handleIndex - specifies the index of the splitter handle. The handle
                                 between the first and the second item will get index 0,
                                 the next handle index 1 etc.
        \li bool \c pressed: the handle is being pressed.
        \li bool \c resizing: the handle is being dragged.
        \endlist
    */
    property Component handleDelegate: Rectangle {
        width: 1
        height: 1
        color: Qt.darker(pal.window, 1.5)
    }

    /*!
        This propery is \c true when the user is resizing any of the items by
        dragging on the splitter handles.
    */
    property bool resizing: false

    /*! \internal */
    default property alias __contents: contents.data
    /*! \internal */
    property alias __items: splitterItems.children
    /*! \internal */
    property alias __handles: splitterHandles.children

    clip: true
    Component.onCompleted: d.init()
    onWidthChanged: d.updateLayout()
    onHeightChanged: d.updateLayout()

    SystemPalette { id: pal }

    QtObject {
        id: d
        readonly property bool horizontal: orientation == Qt.Horizontal
        readonly property string minimum: horizontal ? "minimumWidth" : "minimumHeight"
        readonly property string maximum: horizontal ? "maximumWidth" : "maximumHeight"
        readonly property string otherMinimum: horizontal ? "minimumHeight" : "minimumWidth"
        readonly property string otherMaximum: horizontal ? "maximumHeight" : "maximumWidth"
        readonly property string offset: horizontal ? "x" : "y"
        readonly property string otherOffset: horizontal ? "y" : "x"
        readonly property string size: horizontal ? "width" : "height"
        readonly property string otherSize: horizontal ? "height" : "width"
        readonly property string implicitSize: horizontal ? "implicitWidth" : "implicitHeight"
        readonly property string implicitOtherSize: horizontal ? "implicitHeight" : "implicitWidth"

        property int fillIndex: -1
        property bool updateLayoutGuard: true

        function init()
        {
            for (var i=0; i<__contents.length; ++i) {
                var item = __contents[i];
                if (!item.hasOwnProperty("x"))
                    continue

                if (splitterItems.children.length > 0)
                    handleLoader.createObject(splitterHandles, {"handleIndex":splitterItems.children.length - 1})
                item.parent = splitterItems
                i-- // item was removed from list
                item.widthChanged.connect(d.updateLayout)
                item.heightChanged.connect(d.updateLayout)
                item.Layout.maximumWidthChanged.connect(d.updateLayout)
                item.Layout.minimumWidthChanged.connect(d.updateLayout)
                item.Layout.maximumHeightChanged.connect(d.updateLayout)
                item.Layout.minimumHeightChanged.connect(d.updateLayout)
                item.visibleChanged.connect(d.updateFillIndex)
                item.Layout.fillWidthChanged.connect(d.updateFillIndex)
                item.Layout.fillHeightChanged.connect(d.updateFillIndex)
            }

            d.calculateImplicitSize()
            d.updateLayoutGuard = false
            d.updateFillIndex()
        }

        function updateFillIndex()
        {
            if (!lastItem.visible)
                return
            var policy = (root.orientation === Qt.Horizontal) ? "fillWidth" : "fillHeight"
            for (var i=0; i<__items.length-1; ++i) {
                if (__items[i].Layout[policy] === true)
                    break;
            }

            d.fillIndex = i
            d.updateLayout()
        }

        function calculateImplicitSize()
        {
            var implicitSize = 0
            var implicitOtherSize = 0

            for (var i=0; i<__items.length; ++i) {
                var item = __items[i];
                implicitSize += clampedMinMax(item, item[d.size], d.minimum, d.maximum)
                var os = clampedMinMax(item, item[d.otherSize], d.otherMinimum, d.otherMaximum)
                implicitOtherSize = Math.max(implicitOtherSize, os)

                var handle = __handles[i]
                if (handle)
                    implicitSize += handle[d.size]
            }

            root[d.implicitSize] = implicitSize
            root[d.implicitOtherSize] = implicitOtherSize
        }

        function clampedMinMax(item, value, minimum, maximum)
        {
            if (item.Layout[maximum] !== -1 && value > item.Layout[maximum])
                value = item.Layout[maximum]
            if (item.Layout[minimum] !== -1 && value < item.Layout[minimum])
                value = item.Layout[minimum]
            return value
        }

        function accumulatedSize(firstIndex, lastIndex, includeFillItemMinimum)
        {
            // Go through items and handles, and
            // calculate their acummulated width.
            var w = 0
            for (var i=firstIndex; i<lastIndex; ++i) {
                var item = __items[i]
                if (item.visible) {
                    if (i !== d.fillIndex)
                        w += item[d.size];
                    else if (includeFillItemMinimum && item.Layout[minimum] !== undefined)
                        w += item.Layout[minimum]

                    var handle = __handles[i]
                    if (handle)
                        w += handle[d.size]
                }
            }
            return w
        }

        function updateLayout()
        {
            // This function will reposition both handles and
            // items according to the their width/height:
            if (__items.length === 0)
                return;
            if (!lastItem.visible)
                return;
            if (d.updateLayoutGuard === true)
                return
            d.updateLayoutGuard = true

            // Ensure all items within their min/max:
            for (var i=0; i<__items.length; ++i) {
                if (i !== d.fillIndex) {
                    var item = __items[i];
                    item[d.size] = clampedMinMax(item, item[d.size], d.minimum, d.maximum)
                }
            }

            // Set size of fillItem to remaining available space.
            // Special case: If SplitView size is zero, we leave fillItem with the size
            // it already got, and assume that SplitView ends up with implicit size as size:
            if (root[d.size] != 0) {
                var fillItem = __items[fillIndex]
                var superfluous = root[d.size] - d.accumulatedSize(0, __items.length, false)
                var s = Math.max(superfluous, fillItem.Layout[minimum])
                if (fillItem.Layout[maximum] !== -1)
                    s = Math.min(s, fillItem.Layout[maximum])
                fillItem[d.size] = s
            }

            // Position items and handles according to their width:
            var lastVisibleItem, lastVisibleHandle, handle
            for (i=0; i<__items.length; ++i) {
                // Position item to the right of the previous visible handle:
                item = __items[i];
                if (item.visible) {
                    item[d.offset] = lastVisibleHandle ? lastVisibleHandle[d.offset] + lastVisibleHandle[d.size] : 0
                    item[d.otherOffset] = 0
                    item[d.otherSize] = clampedMinMax(item, root[d.otherSize], d.otherMinimum, d.otherMaximum)
                    lastVisibleItem = item

                    handle = __handles[i]
                    if (handle) {
                        handle[d.offset] = lastVisibleItem[d.offset] + Math.max(0, lastVisibleItem[d.size])
                        handle[d.otherOffset] = 0
                        handle[d.otherSize] = item[d.otherSize]
                        lastVisibleHandle = handle
                    }
                }
            }

            d.updateLayoutGuard = false
        }
    }

    Component {
        id: handleLoader
        Loader {
            id: itemHandle
            property int handleIndex: -1
            property alias containsMouse: mouseArea.containsMouse
            property alias pressed: mouseArea.pressed
            property bool resizing: mouseArea.drag.active

            visible: __items[handleIndex + ((d.fillIndex >= handleIndex) ? 0 : 1)].visible
            sourceComponent: handleDelegate
            onWidthChanged: d.updateLayout()
            onHeightChanged: d.updateLayout()
            onXChanged: moveHandle()
            onYChanged: moveHandle()
            onResizingChanged: root.resizing = resizing

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.leftMargin: (parent.width <= 1) ? -2 : 0
                anchors.rightMargin: (parent.width <= 1) ? -2 : 0
                anchors.topMargin: (parent.height <= 1) ? -2 : 0
                anchors.bottomMargin: (parent.height <= 1) ? -2 : 0
                hoverEnabled: true
                drag.target: parent
                drag.axis: root.orientation === Qt.Horizontal ? Drag.XAxis : Drag.YAxis
                cursorShape: root.orientation === Qt.Horizontal ? Qt.SplitHCursor : Qt.SplitVCursor
            }

            function moveHandle() {
                // Moving the handle means resizing an item. Which one,
                // left or right, depends on where the fillItem is.
                // 'updateLayout' will be overridden in case new width violates max/min.
                // 'updateLayout' will be triggered when an item changes width.
                if (d.updateLayoutGuard)
                    return

                var leftHandle, leftItem, rightItem, rightHandle
                var leftEdge, rightEdge, newWidth, leftStopX, rightStopX
                var i

                if (d.fillIndex > handleIndex) {
                    // Resize item to the left.
                    // Ensure that the handle is not crossing other handles. So
                    // find the first visible handle to the left to determine the left edge:
                    leftEdge = 0
                    for (i=handleIndex-1; i>=0; --i) {
                        leftHandle = __handles[i]
                        if (leftHandle.visible) {
                            leftEdge = leftHandle[d.offset] + leftHandle[d.size]
                            break;
                        }
                    }

                    // Ensure: leftStopX >= itemHandle[d.offset] >= rightStopX
                    var min = d.accumulatedSize(handleIndex+1, __items.length, true)
                    rightStopX = root[d.size] - min - itemHandle[d.size]
                    leftStopX = Math.max(leftEdge, itemHandle[d.offset])
                    itemHandle[d.offset] = Math.min(rightStopX, Math.max(leftStopX, itemHandle[d.offset]))

                    newWidth = itemHandle[d.offset] - leftEdge
                    leftItem = __items[handleIndex]
                    // The next line will trigger 'updateLayout':
                    leftItem[d.size] = newWidth
                } else {
                    // Resize item to the right.
                    // Ensure that the handle is not crossing other handles. So
                    // find the first visible handle to the right to determine the right edge:
                    rightEdge = root[d.size]
                    for (i=handleIndex+1; i<__handles.length; ++i) {
                        rightHandle = __handles[i]
                        if (rightHandle.visible) {
                            rightEdge = rightHandle[d.offset]
                            break;
                        }
                    }

                    // Ensure: leftStopX <= itemHandle[d.offset] <= rightStopX
                    min = d.accumulatedSize(0, handleIndex+1, true)
                    leftStopX = min - itemHandle[d.size]
                    rightStopX = Math.min((rightEdge - itemHandle[d.size]), itemHandle[d.offset])
                    itemHandle[d.offset] = Math.max(leftStopX, Math.min(itemHandle[d.offset], rightStopX))

                    newWidth = rightEdge - (itemHandle[d.offset] + itemHandle[d.size])
                    rightItem = __items[handleIndex+1]
                    // The next line will trigger 'updateLayout':
                    rightItem[d.size] = newWidth
                }
            }
        }
    }

    Item {
        id: contents
        visible: false
        anchors.fill: parent
    }
    Item {
        id: splitterItems
        anchors.fill: parent
    }
    Item {
        id: splitterHandles
        anchors.fill: parent
    }

    Item {
        id: lastItem
        onVisibleChanged: d.updateFillIndex()
    }

    Component.onDestruction: {
        for (var i=0; i<splitterItems.children.length; ++i) {
            var item = splitterItems.children[i];
            item.visibleChanged.disconnect(d.updateFillIndex)
            item.Layout.fillWidthChanged.disconnect(d.updateFillIndex)
            item.Layout.fillHeightChanged.disconnect(d.updateFillIndex)
        }
    }
}
