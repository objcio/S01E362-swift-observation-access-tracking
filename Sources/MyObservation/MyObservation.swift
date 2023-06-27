struct Entry: Equatable {
    var keyPaths: Set<AnyKeyPath> = []
}

final class Registrar {
    typealias Observer = () -> ()
    var observers: [AnyKeyPath: [Observer]] = [:]

    func access<Source: AnyObject, Target>(_ obj: Source, _ keyPath: KeyPath<Source, Target>) {
        accessList[ObjectIdentifier(obj), default: Entry()].keyPaths.insert(keyPath)
    }

    func willSet<Source: AnyObject, Target>(_ obj: Source, _ keyPath: KeyPath<Source, Target>) {
        guard let obs = observers[keyPath] else { return }
        for ob in obs {
            ob()
        }
    }
}

var accessList: [ObjectIdentifier: Entry] = [:]

func withObservationTracking<T>(_ apply: () -> T, onChange: @escaping () -> ()) -> T {
    let result = apply()
    return result
}
