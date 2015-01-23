//
//  Transition.swift
//  Representor
//
//  Created by Kyle Fuller on 04/11/2014.
//  Copyright (c) 2014 Apiary. All rights reserved.
//

import Foundation

public struct InputProperty<T : AnyObject> : Equatable {
  public let defaultValue:T?
  public let value:T?

  // TODO: Define validators

  public init(value:T?, defaultValue:T?) {
    self.value = value
    self.defaultValue = defaultValue
  }
}

public func ==<T : AnyObject>(lhs:InputProperty<T>, rhs:InputProperty<T>) -> Bool {
  return (
    lhs.defaultValue as? NSObject == rhs.defaultValue as? NSObject &&
    lhs.value as? NSObject == rhs.value as? NSObject
  )
}

public typealias InputProperties = Dictionary<String, InputProperty<AnyObject>>

/** Transition instances encapsulate information about interacting with links and forms. */
public protocol TransitionType : Equatable, Hashable {
  typealias Builder = TransitionBuilder

  init(uri:String, attributes:InputProperties, parameters:InputProperties)
  init(uri:String, _ block:((builder:Builder) -> ()))

  var uri:String { get }

  var attributes:InputProperties { get }
  var parameters:InputProperties { get }
}
