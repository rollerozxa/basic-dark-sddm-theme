/***************************************************************************
* Copyright (c) 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
	id: container
	width: 1024
	height: 768

	LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
	LayoutMirroring.childrenInherit: true

	property int sessionIndex: session.index

	TextConstants { id: textConstants }

	Connections {
		target: sddm
		onLoginSucceeded: {
		}

		onLoginFailed: {
			txtMessage.text = textConstants.loginFailed
			listView.currentItem.password = ""
		}

		onInformationMessage: {
			txtMessage.text = message
		}
	}

	Background {
		anchors.fill: parent
		source: "background.png"
		fillMode: Image.PreserveAspectCrop
		onStatusChanged: {
			if (status == Image.Error && source != config.defaultBackground) {
				source = config.defaultBackground
			}
		}

		MouseArea {
			anchors.fill: parent
			onClicked: {
				listView.focus = true;
			}
		}
	}

	Rectangle {
		anchors.fill: parent
		color: "transparent"
		//visible: primaryScreen

		Component {
			id: userDelegate

			PictureBox {
				anchors.verticalCenter: parent.verticalCenter
				name: (model.realName === "") ? model.name : model.realName
				icon: model.icon
				showPassword: model.needsPassword
				width: 164

				focus: (listView.currentIndex === index) ? true : false
				state: (listView.currentIndex === index) ? "active" : ""

				onLogin: sddm.login(model.name, password, sessionIndex);

				MouseArea {
					anchors.fill: parent
					onClicked: {
						listView.currentIndex = index;
						listView.focus = true;
					}
				}
			}
		}

		Row {
			anchors.fill: parent

			Rectangle {
				width: parent.width; height: parent.height / 3
				color: "#00000000"

				Clock {
					id: clock
					anchors.centerIn: parent
					color: "white"
					timeFont.family: "Fira Code"
					dateFont.family: "Fira Code"
				}
			}

			Rectangle {
				anchors.bottom: parent.bottom
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width / 3; height: parent.height
				color: "transparent"

				Item {
					id: usersContainer
					width: parent.width; height: 300
					anchors.verticalCenter: parent.verticalCenter

					ListView {
						id: listView
						height: parent.height
						anchors.left: parent.left; anchors.right: parent.right
						anchors.verticalCenter: parent.verticalCenter
						anchors.margins: 10

						clip: true
						focus: true

						spacing: 5

						model: userModel
						delegate: userDelegate
						orientation: ListView.Horizontal
						currentIndex: userModel.lastIndex

						KeyNavigation.backtab: prevUser; KeyNavigation.tab: nextUser
					}
				}
			}
		}

		Row {
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.margins: 5
			height: 40
			spacing: 5

			ComboBox {
				id: session
				width: 245
				anchors.verticalCenter: parent.verticalCenter

				arrowIcon: "angle-down.png"

				model: sessionModel
				index: sessionModel.lastIndex

				font.pixelSize: 14

				KeyNavigation.backtab: nextUser; KeyNavigation.tab: layoutBox
			}

			LayoutBox {
				id: layoutBox
				width: 90
				anchors.verticalCenter: parent.verticalCenter
				font.pixelSize: 14

				arrowIcon: "angle-down.png"

				KeyNavigation.backtab: session; KeyNavigation.tab: btnShutdown
			}
		}

		Row {
			height: 64
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.margins: 5
			spacing: 5

			ImageButton {
				id: btnReboot
				height: parent.height
				width: parent.height
				sourceSize.height: parent.height
				sourceSize.width: parent.width

				source: "reboot.svg"

				onClicked: sddm.reboot()

				KeyNavigation.backtab: layoutBox; KeyNavigation.tab: btnShutdown
			}

			ImageButton {
				id: btnShutdown
				height: parent.height
				width: parent.height
				sourceSize.height: parent.height
				sourceSize.width: parent.width

				source: "shutdown.svg"

				onClicked: sddm.powerOff()

				KeyNavigation.backtab: btnReboot; KeyNavigation.tab: prevUser
			}
		}
	}
}
