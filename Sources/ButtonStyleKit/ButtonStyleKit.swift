import SwiftUI
import Functional

@available(macOS 11.0, *)
public struct ExposePressedButtonStyle: ButtonStyle {
    @Binding var pressed: Bool

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label.onChange(of: configuration.isPressed, perform: { value in
            self.pressed = value
        })
    }
}

// MARK: - Composable Button Framework

public typealias ButtonStyleClosure<A: View, B: View> = (ButtonStyleConfiguration, A) -> B

public func >>> <A: View, B: View, C: View>(
    _ f: @escaping ButtonStyleClosure<A, B>,
    _ g: @escaping ButtonStyleClosure<B, C>
) -> ButtonStyleClosure<A, C> {
    return { configuration, a in
        g(configuration, f(configuration, a))
    }
}

struct ComposableButtonStyle<B: View>: ButtonStyle {
    let buttonStyleClosure: ButtonStyleClosure<ButtonStyleConfiguration.Label, B>

    init(_ buttonStyleClosure: @escaping ButtonStyleClosure<ButtonStyleConfiguration.Label, B>) {
        self.buttonStyleClosure = buttonStyleClosure
    }

    func makeBody(configuration: Configuration) -> some View {
        return buttonStyleClosure(configuration, configuration.label)
    }
}

extension Button {
    public func composableStyle<B: View>(_ buttonStyleClosure: @escaping ButtonStyleClosure<ButtonStyleConfiguration.Label, B>) -> some View {
        return self.buttonStyle(ComposableButtonStyle(buttonStyleClosure))
    }
}

extension ButtonStyle {
    public func buttonStyleClosure<A: View>() -> ButtonStyleClosure<A, Self.Body> {
        return { config, a in
            return self.makeBody(configuration: config)
        }
    }
}
