using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.WatchUi as Ui;
using Toybox.ActivityMonitor as Act;

class SeedView extends Ui.WatchFace
{
    var font;
    var isAwake;
    var screenShape;
    var showTime = true;
    var showDate = false;
    var showBatteryBar = true;
    var showStepsBar = true;

    function initialize() {
        WatchFace.initialize();
        screenShape = Sys.getDeviceSettings().screenShape;
        showTime = Application.getApp().getProperty("showTime");
        showDate = Application.getApp().getProperty("showDate");
        showBatteryBar = Application.getApp().getProperty("showBatteryBar");
        showStepsBar = Application.getApp().getProperty("showStepsBar");
    }

    function onLayout(dc) {
        
    }

    function onUpdate(dc) {
		var clockTime = Sys.getClockTime();
        var width = dc.getWidth();
        var height = dc.getHeight();      
		var min_dim = min(width,height);
		
        // Clear the screen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());        
        
        if (showBatteryBar) {
			var battery = Sys.getSystemStats().battery / 100;
			drawBatteryBar(dc, battery);
		}
		
		if (showStepsBar) {
			var steps = min(Act.getInfo().steps * 1.0 / Act.getInfo().stepGoal, 1.0);
			drawStepsBar(dc, steps);
		}

		if (showTime) {
			dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(2);        
			var h = ((clockTime.hour % 12) * 30 - 90) * Math.PI / 180;
			var m = ((clockTime.min * 6) - 90) * Math.PI / 180;
			var w = (min_dim/2) * 0.66;
			
			dc.setPenWidth(2);   		
			dc.drawLine( 
				(width / 2) + 10 * Math.cos(m), (height / 2) + 10 * Math.sin(m),
				(width / 2) + w * Math.cos(m), (height / 2) + w * Math.sin(m)
			);
			
			dc.setPenWidth(3);
			dc.drawLine( 
				(width / 2) + 10 * Math.cos(h), (height / 2) + 10* Math.sin(h),
				(width / 2) + w* 0.66 * Math.cos(h), (height / 2) + w * 0.66 * Math.sin(h)
			);  			

        }		
        
        if (showDate) {
			var now = Time.now();
			var info = Calendar.info(now, Time.FORMAT_LONG);        
			var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);
			dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
			if (screenShape == Sys.SCREEN_SHAPE_RECTANGLE) {
				dc.drawText(width / 2, height - dc.getFontHeight(Gfx.FONT_TINY) - 4, Gfx.FONT_TINY,	dateStr, Gfx.TEXT_JUSTIFY_CENTER);
			} else {
				dc.drawText(width / 2, height - dc.getFontHeight(Gfx.FONT_TINY) - 13, Gfx.FONT_TINY,	dateStr, Gfx.TEXT_JUSTIFY_CENTER);
			}
		}        
    }

    function onEnterSleep() {
        isAwake = false;
        Ui.requestUpdate();
    }

    function onExitSleep() {
        isAwake = true;
    }
}
