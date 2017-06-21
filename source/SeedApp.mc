using Toybox.Application as App;

class SeedWatch extends App.AppBase
{
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [new SeedView()];
    }

}
