package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	import org.osflash.signals.events.GenericEvent;

	public class SignalWithCustomEventTest
	{
	    [Inject]
	    public var async:IAsync;
	
		public var messaged:Signal;

		[Before]
		public function setUp():void
		{
			messaged = new Signal(MessageEvent);
		}

		[After]
		public function tearDown():void
		{
			messaged.removeAll();
			messaged = null;
		}
		//////
		[Test]
		public function valueClasses_roundtrip_through_constructor():void
		{
			assertSame(MessageEvent, messaged.valueClasses[0]);
		}
		
		[Test]
		public function add_one_listener_and_dispatch():void
		{
			messaged.add(async.add(onMessage, 50));
			messaged.dispatch(new MessageEvent('ok'));
		}
		
		protected function onMessage(e:MessageEvent):void
		{
			assertEquals('message value in the event', 'ok', e.message);
		}
		//////
		[Test(expects="ArgumentError")]
		public function dispatch_wrong_event_type_should_throw_ArgumentError():void
		{
			messaged.dispatch(new GenericEvent());
		}

		[Test(expects="ArgumentError")]
		public function signal_with_eventClass_adding_listener_without_args_should_throw_ArgumentError():void
		{
			messaged.add(function():void {});
		}

		[Test(expects="ArgumentError")]
		public function constructing_signal_with_non_class_should_throw_ArgumentError():void
		{
			new Signal(new Date());
		}
		
		[Test(expects="ArgumentError")]
		public function constructing_signal_with_two_nulls_should_throw_ArgumentError():void
		{
			new Signal(null, null);
		}
		
		[Test(expects="ArgumentError")]
		public function constructing_signal_with_class_and_non_class_should_throw_ArgumentError():void
		{
			new Signal(Date, 42);
		}

		[Test(expects="ArgumentError")]
		public function add_listener_with_fewer_args_than_valueClasses_should_throw_ArgumentError():void
		{
			var signal:Signal = new Signal(Date, Array);
			signal.add( function(date:Date):void { } );
		}
	}
}

import org.osflash.signals.events.GenericEvent;
import org.osflash.signals.events.IEvent;

////// PRIVATE CLASSES //////


class MessageEvent extends GenericEvent implements IEvent
{
	public var message:String;
	
	public function MessageEvent(message:String)
	{
		super();
		this.message = message;
	}
	
	override public function clone():IEvent
	{
		return new MessageEvent(message);
	}
	
}

