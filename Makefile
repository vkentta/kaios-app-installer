PORT_DEVICE = localfilesystem:/data/local/debugger-socket
PORT_LOCAL = 6000
SRC_DIR = app-src
TMP_DIR := tmp_dir_$(shell date +%s)

package:
	@echo "ZIPPING current workdir content into application.zip"
	@cd /${SRC_DIR} && zip -Xr ./application.zip ./* -x application.zip

push_packaged: package
	@echo "PUSHING as packaged app"
	@adb push /${SRC_DIR}/application.zip /data/local/tmp/b2g/${TMP_DIR}/application.zip

push_hosted:
	@echo "PUSHING as hosted app"
	@adb push /${SRC_DIR}/manifest.webapp /data/local/tmp/b2g/${TMP_DIR}/manifest.webapp
	@adb push /${SRC_DIR}/metadata.json /data/local/tmp/b2g/${TMP_DIR}/metadata.json

install:
	@echo "FORWARDING device port $(PORT_DEVICE) to $(PORT_LOCAL)"
	@adb forward tcp:$(PORT_LOCAL) $(PORT_DEVICE)
	xpcshell install.js ${TMP_DIR} $(PORT_LOCAL)

remove_package:
	@echo "REMOVING application.zip"
	@rm /${SRC_DIR}/application.zip

install_packaged: push_packaged install remove_package

install_hosted: push_hosted install remove_package