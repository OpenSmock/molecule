"
I provide basic tests for events.
Also, I can be used as example to use events. My classes are in package Molecule-Examples.
"
Class {
	#name : #MolEventsTest,
	#superclass : #TestCase,
	#category : #'Molecule-Tests-Cases'
}

{ #category : #'setUp - tearDown' }
MolEventsTest >> setUp [

	super setUp.
	MolComponentManager cleanUp.
]

{ #category : #'setUp - tearDown' }
MolEventsTest >> tearDown [

	MolComponentManager cleanUp.
	super tearDown.
]

{ #category : #tests }
MolEventsTest >> testSeveralListeners [
	| warner listener1 listener2 |
	"Deployment"
	MolMyWarnerComponentImpl deploy.
	MolMyListenerComponentImpl deploy.
	
	"Instanciation"
	warner := MolMyWarnerComponentImpl instanciate: #warner.
	listener1 := MolMyListenerComponentImpl instanciate: #listener1.
	listener2 := MolMyListenerComponentImpl instanciate: #listener2.
	
	"Subscriptions"
	listener1 forEvents: MolMyStateChangeEvents useProducer: #warner.
	listener2 forEvents: MolMyStateChangeEvents useProducer: #warner.
	
	"Activation"
	MolMyWarnerComponentImpl activate: #warner.
	MolMyListenerComponentImpl activate: #listener1.
	
	"Tests"
	warner operationalEvent.
	self assert: listener1 currentState equals: #operational.
	self assert: listener2 currentState equals: nil.
	
	MolMyListenerComponentImpl activate: #listener2.
	warner maintenanceEvent.
	self assert: listener1 currentState equals: #maintenance.
	self assert: listener2 currentState equals: #maintenance.
	
	MolMyListenerComponentImpl passivate: #listener1.
	warner failureEvent.
	self assert: listener1 currentState equals: #maintenance.
	self assert: listener2 currentState equals: #failure.	
]

{ #category : #tests }
MolEventsTest >> testSeveralWarners [
	| warner1 warner2 listener subscriptions subscribers |
	"Deployment"
	MolMyWarnerComponentImpl deploy.
	MolMyListenerComponentImpl deploy.
	
	"Instanciation"
	warner1 := MolMyWarnerComponentImpl instanciate: #warner1.
	warner2 := MolMyWarnerComponentImpl instanciate: #warner2.
	listener := MolMyListenerComponentImpl instanciate: #listener.
	
	"Subscriptions"
	subscriptions := (Array with: #warner1 with: #warner2).
	listener forEvents: MolMyStateChangeEvents useAllProducers: subscriptions.

	subscribers := listener eventsSubscribers.	
	self assert: subscribers size equals: 1.
	self assert: (subscribers at: MolMyStateChangeEvents) size equals: 2.
	self assert: ((subscribers at: MolMyStateChangeEvents) at: 1) equals: #warner1.
	self assert: ((subscribers at: MolMyStateChangeEvents) at: 2) equals: #warner2.
	
	"Activation"
	MolMyWarnerComponentImpl activate: #warner1.
	MolMyListenerComponentImpl activate: #listener.
	
	"Tests"
	warner1 operationalEvent.
	self assert: listener currentState equals: #operational.
	warner2 failureEvent. "warner 2 is not active, so he can't send an event"
	self assert: listener currentState equals: #operational.
	
	MolMyWarnerComponentImpl activate: #warner2.
	warner1 maintenanceEvent.
	self assert: listener currentState equals: #maintenance.
	warner2 failureEvent.
	self assert: listener currentState equals: #failure.
	
	MolMyWarnerComponentImpl passivate: #warner1.
	warner1 operationalEvent. "warner 1 is not active, so he can't send an event"
	self assert: listener currentState equals: #failure.
]

{ #category : #tests }
MolEventsTest >> testSimpleListenerNotActivated [
	| warner listener |
	"Deployment"
	MolMyWarnerComponentImpl deploy.
	MolMyListenerComponentImpl deploy.
	
	"Instanciation"
	warner := MolMyWarnerComponentImpl instanciate.
	listener := MolMyListenerComponentImpl instanciate.
	
	"Activation / Passivation"
	MolMyWarnerComponentImpl activate.
	
	warner operationalEvent.
	self assert: listener currentState equals: nil.
		
	MolMyListenerComponentImpl activate.
	warner failureEvent.
	self assert: listener currentState equals: #failure.
	
	MolMyListenerComponentImpl passivate.
	warner maintenanceEvent.
	self assert: listener currentState equals: #failure.
	
	MolMyListenerComponentImpl activate.
	warner operationalEvent.
	self assert: listener currentState equals: #operational.
	
]

{ #category : #tests }
MolEventsTest >> testSimpleListenerNotActivatedNamed [
	| warner listener |
	"Deployment"
	MolMyWarnerComponentImpl deploy.
	MolMyListenerComponentImpl deploy.
	
	"Instanciation"
	warner := MolMyWarnerComponentImpl instanciate: #myWarner.
	listener := MolMyListenerComponentImpl instanciate: #myListener.
	
	"Subscription"
	listener forEvents: MolMyStateChangeEvents useProducer: #myWarner.
	
	"Activation"
	MolMyWarnerComponentImpl activate: #myWarner.
	
	warner operationalEvent.
	self assert: listener currentState equals: nil.
		
	MolMyListenerComponentImpl activate: #myListener.
	warner failureEvent.
	self assert: listener currentState equals: #failure.
	
	MolMyListenerComponentImpl passivate: #myListener.
	warner maintenanceEvent.
	self assert: listener currentState equals: #failure.
	
	MolMyListenerComponentImpl activate: #myListener.
	warner operationalEvent.
	self assert: listener currentState equals: #operational.
]

{ #category : #tests }
MolEventsTest >> testSimpleWarnerNotActivated [
	"A component not activated send events."
	| warner listener |
	"Deployment"
	MolMyWarnerComponentImpl deploy.
	MolMyListenerComponentImpl deploy.
	
	"Instanciation"
	warner := MolMyWarnerComponentImpl instanciate.
	listener := MolMyListenerComponentImpl instanciate.
	
	"Activation"
	MolMyListenerComponentImpl activate.
	
	"Tests"
	warner operationalEvent.
	self assert: listener currentState isNil.
	
	MolMyWarnerComponentImpl activate.
	warner failureEvent.
	self assert: listener currentState equals: #failure.
	
	MolMyWarnerComponentImpl passivate.
	warner maintenanceEvent.
	self assert: listener currentState equals: #failure.
	
	MolMyWarnerComponentImpl activate.
	warner operationalEvent.
	self assert: listener currentState equals: #operational.
	
]

{ #category : #tests }
MolEventsTest >> testSimpleWarnerNotActivatedNamed [
	"A component not activated send events."
	| warner listener |
	"Deployment"
	MolMyWarnerComponentImpl deploy.
	MolMyListenerComponentImpl deploy.
	
	"Instanciation"
	warner := MolMyWarnerComponentImpl instanciate: #myWarner.
	listener := MolMyListenerComponentImpl instanciate: #myListener.
	
	"Subscription"
	listener forEvents: MolMyStateChangeEvents useProducer: #myWarner.
	
	"Activation"
	MolMyListenerComponentImpl activate: #myListener.
	
	"Tests"
	warner maintenanceEvent.
	self assert: listener currentState isNil.
	
	MolMyWarnerComponentImpl activate: #myWarner.
	warner failureEvent.
	self assert: listener currentState equals: #failure.
	
	MolMyWarnerComponentImpl passivate: #myWarner.
	warner maintenanceEvent.
	self assert: listener currentState equals: #failure.
	
	MolMyWarnerComponentImpl activate: #myWarner.
	warner operationalEvent.
	self assert: listener currentState equals: #operational.
	
]

{ #category : #tests }
MolEventsTest >> testSimpleWarningSystem [
	| warner listener |
	"Deployment"
	MolMyWarnerComponentImpl deploy.
	MolMyListenerComponentImpl deploy.
	
	"Instanciation : by default, components name is #default"
	warner := MolMyWarnerComponentImpl instanciate.
	listener := MolMyListenerComponentImpl instanciate.
	
	"Subscription : by default, a component is subscribed to events from component #default."
	"It will be effective after activation"
	
	"Activation : by default, components are activated with name default"
	MolMyWarnerComponentImpl activate.
	MolMyListenerComponentImpl activate.
	
	"Tests"
	self assert: listener currentState equals: nil.
	
	warner operationalEvent.
	self assert: listener currentState equals: #operational.
	
	warner failureEvent.
	self assert: listener currentState equals: #failure.
	self assert: listener failureLevel notNil.
	
]

{ #category : #tests }
MolEventsTest >> testSimpleWarningSystemNamed [
	| warner listener |
	"Deployment"
	MolMyWarnerComponentImpl deploy.
	MolMyListenerComponentImpl deploy.
	
	"Instanciation"
	warner := MolMyWarnerComponentImpl instanciate: #myWarner.
	listener := MolMyListenerComponentImpl instanciate: #myListener.
	
	"Subscription : it should be done in SCMMyListenerComponentImpl > componentInitialize"
	listener forEvents: MolMyStateChangeEvents useProducer: #myWarner.
	
	"Activation"
	MolMyWarnerComponentImpl activate: #myWarner.
	MolMyListenerComponentImpl activate: #myListener.
	
	"Tests"
	self assert: listener currentState equals: nil.
	
	warner operationalEvent.
	self assert: listener currentState equals: #operational.
	
	warner failureEvent.
	self assert: listener currentState equals: #failure.
	self assert: listener failureLevel notNil.
	
]

{ #category : #tests }
MolEventsTest >> testSimpleWarningSystemNamedDelayed [
"Test subscription after activation"
	| warner listener |
	"Deployment"
	MolMyWarnerComponentImpl deploy.
	MolMyListenerComponentImpl deploy.
	
	"Initialization and activation of listener"
	listener := MolMyListenerComponentImpl instanciate: #myListener.
	listener forEvents: MolMyStateChangeEvents useProducer: #myWarner. "Warner does not exist."
	MolMyListenerComponentImpl activate: #myListener.
	
	"Initialization and activation of warner"
	warner := MolMyWarnerComponentImpl instanciate: #myWarner.
	MolMyWarnerComponentImpl activate: #myWarner.
	
	"Tests"
	warner operationalEvent.
	self assert: listener currentState equals: #operational.
	
]

{ #category : #tests }
MolEventsTest >> testSubscriptionBeforeInstanciation [
	"A component not activated send events."
	| warner listener |
	"Deployment"
	MolMyWarnerComponentImpl deploy.
	MolMyListenerComponentImpl deploy.
	
	"Creation and subscription of listener"
	listener := MolMyListenerComponentImpl instanciate: #myListener.
	listener forEvents: MolMyStateChangeEvents useProducer: #myWarner.
	MolMyListenerComponentImpl activate: #myListener.
	
	"Creation of warner"
	warner := MolMyWarnerComponentImpl instanciate: #myWarner.
	MolMyWarnerComponentImpl activate: #myWarner.
	
	"Test"
	warner maintenanceEvent.
	self assert: listener currentState equals: #maintenance.
	
]
