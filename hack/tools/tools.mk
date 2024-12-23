#
#Copyright 2024 NVIDIA
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

TOOLSDIR ?= $(CURDIR)/hack/tools/bin
$(TOOLSDIR):
	@mkdir -p $@

# Detect architecture and platform
TOOL_ARCH := $(shell uname -m)
TOOL_OS := $(shell uname -s | tr A-Z a-z)

## Tool Versions
HELM_VER ?= v3.16.3
HELM_DOCS_VER := v1.14.2

## Tool Binaries
HELM ?= $(TOOLSDIR)/helm-$(HELM_VER)
HELM_DOCS ?= $(TOOLSDIR)/helm-docs-$(HELM_DOCS_VER)

# helm is used to manage helm deployments and artifacts.
.PHONY: helm
helm: $(HELM) ## Download helm locally if necessary.
GET_HELM = $(TOOLSDIR)/get_helm.sh
$(HELM): | $(TOOLSDIR)
	$Q echo "Installing helm-$(HELM_VER) to $(TOOLSDIR)"
	$Q curl -fsSL -o $(GET_HELM) https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
	$Q chmod +x $(GET_HELM)
	$Q env HELM_INSTALL_DIR=$(TOOLSDIR) PATH="$(PATH):$(TOOLSDIR)" $(GET_HELM) --no-sudo -v $(HELM_VER)
	$Q mv $(TOOLSDIR)/helm $(TOOLSDIR)/helm-$(HELM_VER)
	$Q rm -f $(GET_HELM)

# helm-docs is used to generate helm chart documentation
helm-docs: $(HELM_DOCS)
$(HELM_DOCS): | $(TOOLSDIR)
	$(call go-install-tool,$(HELM_DOCS),github.com/norwoodj/helm-docs/cmd/helm-docs,$(HELM_DOCS_VER))

# go-install-tool will 'go install' any package with custom target and name of binary, if it doesn't exist
# $1 - target path with name of binary (ideally with version)
# $2 - package url which can be installed
# $3 - specific version of package
define go-install-tool
@[ -f $(1) ] || { \
set -e; \
package=$(2)@$(3) ;\
echo "Downloading $${package}" ;\
GOBIN=$(TOOLSDIR) go install $${package} ;\
mv "$$(echo "$(1)" | sed "s/-$(3)$$//")" $(1) ;\
}
endef
