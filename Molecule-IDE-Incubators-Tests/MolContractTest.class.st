Class {
	#name : #MolContractTest,
	#superclass : #TestCase,
	#instVars : [
		'molContract'
	],
	#category : #'Molecule-IDE-Incubators-Tests-Deprecated'
}

{ #category : #testing }
MolContractTest class >> isDeprecated [
	^ true
]

{ #category : #running }
MolContractTest >> setUp [
	super setUp.
	
	molContract := MolContract new.
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
MolContractTest >> testConsumedEvents [
	self assert: (molContract consumedEvents: MolAbstractComponentImpl) equals:nil.
	
	self assert: (molContract consumedEvents: MolGPSDataImpl) 
	equals: MolGPSDataImpl consumedComponentEvents .
]

{ #category : #tests }
MolContractTest >> testProducedEvents [
	self assert: (molContract producedEvents: MolAbstractComponentImpl) equals:nil.
	
	self assert: (molContract producedEvents: MolGPSDataImpl) 
	equals: MolGPSDataImpl producedComponentEvents .
]

{ #category : #tests }
MolContractTest >> testProvidedParameters [
	self assert: (molContract providedParameters: MolAbstractComponentImpl) equals:nil.
	
	self assert: (molContract providedParameters: MolGPSDataImpl) 
	equals: MolGPSDataImpl providedComponentParameters .
]

{ #category : #tests }
MolContractTest >> testProvidedServices [
	self assert: (molContract providedServices: MolAbstractComponentImpl) equals:nil.
	self assert: (molContract providedServices: MolGPSDataImpl) 
	equals: MolGPSDataImpl providedComponentServices.
]

{ #category : #tests }
MolContractTest >> testUsedParameters [
	self assert: (molContract usedParameters: MolAbstractComponentImpl) equals:nil.
	
	self assert: (molContract usedParameters: MolGPSDataImpl) 
	equals: MolGPSDataImpl usedComponentParameters .
]

{ #category : #tests }
MolContractTest >> testUsedServices [
	self assert: (molContract usedServices: MolAbstractComponentImpl) equals:nil.
	
	self assert: (molContract usedServices: MolGPSDataImpl) 
	equals: MolGPSDataImpl usedComponentServices .
]
