SHELL := /bin/bash

SA_VERSION := $(shell egrep '## Version:' SliceAdmiral.toc | awk '{print $$3}')

pristine:
	@rm -rf tmp-*

clean:
	@rm -rf tmp-$(SA_VERSION)

zip:
	@$(if $(SA_VERSION), ./makezip.sh $(SA_VERSION), echo "Version could not be determined, check'SliceAdmiral.toc'")
