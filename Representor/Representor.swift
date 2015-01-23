//
//  Representor.swift
//  Representor
//
//  Created by Zdenek Nemec on 8/17/14.
//
//

import Foundation

public struct Representor<Transition : TransitionType> : Equatable, Hashable {
  /// The transitions available for the representor
  public let transitions:Dictionary<String, Transition>

  /// The separate representors embedded in the current representor.
  public let representors:Dictionary<String, [Representor]>

  public let links:Dictionary<String, String>

  public let metadata:Dictionary<String, String>

  /// The attributes of the representor
  public let attributes:Dictionary<String, AnyObject>

  public init(transitions:Dictionary<String, Transition>, representors:Dictionary<String, [Representor]>, attributes:Dictionary<String, AnyObject>, links:Dictionary<String, String>, metadata:Dictionary<String, String>) {
    self.transitions = transitions
    self.representors = representors
    self.attributes = attributes
    self.links = links
    self.metadata = metadata
  }

  public var hashValue:Int {
    return transitions.count + representors.count + links.count + metadata.count + attributes.count
  }

  /// An extension to Representor to provide a builder interface for creating a Representor.
  public init(_ block:((builder:RepresentorBuilder<Transition>) -> ())) {
    // This should belong in an extension, but due to a bug in the symbol
    // mangler in the Swift compiler it results in the symbol being incorrectly
    // mangled when being used from an extension.
    //
    // Swift ¯\_(ツ)_/¯
    let builder = RepresentorBuilder<Transition>()

    block(builder:builder)

    self.transitions = builder.transitions
    self.representors = builder.representors
    self.attributes = builder.attributes
    self.links = builder.links
    self.metadata = builder.metadata
  }
}

public func ==<Transition : TransitionType>(lhs:Dictionary<String, [Representor<Transition>]>, rhs:Dictionary<String, [Representor<Transition>]>) -> Bool {
  // There is a strange Swift bug where you cannot compare a
  // dictionary which has an array of objects which conform to Equatable.
  // So to be clear, that's comparing the following:
  //
  //     Dictionary<Equatable, [Equatable]>
  //
  // If one day this problem is solved in a newer version of Swift,
  // this method can be removed and the default == implementation can be used.
  //
  // Swift ¯\_(ツ)_/¯

  if lhs.count != rhs.count {
    return false
  }

  for (key, value) in lhs {
    if let rhsValue = rhs[key] {
      if (value != rhsValue) {
        return false
      }
    } else {
      return false
    }
  }

  return true
}

public func ==<Transition : TransitionType>(lhs:Representor<Transition>, rhs:Representor<Transition>) -> Bool {
  return (
    lhs.transitions == rhs.transitions &&
    lhs.representors == rhs.representors &&
    lhs.links == rhs.links &&
    lhs.metadata == rhs.metadata &&
    (lhs.attributes as NSObject) == (rhs.attributes as NSObject)
  )
}
