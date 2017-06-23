DEVICE = fenix3_hr
SDK_HOME = /data/sports/garmin/connect-iq-sdk
DEPLOY = /media/mash/GARMIN/GARMIN/APPS/
SUPPORTED_DEVICES_LIST = d2bravo d2bravo_titanium fenix3 fenix3_hr fenix5 fenix5s fenix5x fenixchronos fr230 fr235 fr630 fr735xt fr920xt vivoactive vivoactive_hr
PRIVATE_KEY = /data/sports/garmin/connect-iq-sdk/developer_key.der 

sources = `find source -name '*.mc'`
resources = `find resources* -name '*.xml' | tr '\n' ':' | sed 's/.$$//'`
appName = `grep entry manifest.xml | sed 's/.*entry="\([^"]*\).*/\1/'`

build:
	$(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName).prg -m manifest.xml \
	-z $(resources) \
	-y $(PRIVATE_KEY) \
	-d $(DEVICE) $(sources)

buildall:
	@for device in $(SUPPORTED_DEVICES_LIST); do \
		echo "-----"; \
		echo "Building for" $$device; \
    $(SDK_HOME)/bin/monkeyc --warn --output bin/$(appName)-$$device.prg -m manifest.xml \
    -z $(resources) \
    -y $(PRIVATE_KEY) \
    -d $$device $(sources); \
	done

run: build
	$(SDK_HOME)/bin/monkeydo bin/$(appName).prg $(DEVICE)

runall: build
	@for device in $(SUPPORTED_DEVICES_LIST); do \
		echo "running on $$device"; \
		$(SDK_HOME)/bin/monkeydo bin/$(appName).prg $$device; \
	done

deploy: build
	@cp bin/$(appName).prg $(DEPLOY)

package:
	@$(SDK_HOME)/bin/monkeyc --warn -e --output bin/$(appName).iq -m manifest.xml \
	-z $(resources) \
	-y $(PRIVATE_KEY) \
	$(sources) -r

sim:
	@$(SDK_HOME)/bin/connectiq &

