import Qt 4.7
import "./behaviors"
import "./styles/default" as DefaultStyles

Button {
    id: button

    background: defaultStyle.background
    content: defaultStyle.content
    checkable: true

    DefaultStyles.RadioButtonStyle { id: defaultStyle }
}