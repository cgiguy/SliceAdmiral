SHELL := /bin/bash

SA_VERSION := $(shell egrep '## Version:' SliceAdmiral.toc | awk '{print $$3}')

all:	zip

zip:
	@echo "Building from current libraries in lib"
	@$(if $(SA_VERSION), ./makezip.sh $(SA_VERSION), echo "Version could not be determined, check'SliceAdmiral.toc'")

freshzip:
	@echo "Downloading fresh dependent libraries"
	@$(if $(SA_VERSION), ./makezip.sh $(SA_VERSION) --cleanlibs, echo "Version could not be determined, check'SliceAdmiral.toc'")

newlibs:
	@rm -rf lib.BAK
	@mv lib lib.BAK
	@./grablibs.sh

clean:
	@rm -rf tmp-$(SA_VERSION)

pristine:
	@rm -rf tmp-* lib.BAK

