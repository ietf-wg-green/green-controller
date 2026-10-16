LIBDIR := lib
-include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update --init
else
ifneq (,$(wildcard $(ID_TEMPLATE_HOME)))
	ln -s "$(ID_TEMPLATE_HOME)" $(LIBDIR)
else
	git clone -q --depth 10 -b main \
	    https://github.com/martinthomson/i-d-template $(LIBDIR)
endif
endif

TREE_DIR := yang/trees
PYANG := pyang
tree trees: \
	$(TREE_DIR)/ietf-power-energy-base.tree \
	$(TREE_DIR)/ietf-power-energy-network.tree

$(TREE_DIR)/%.tree: yang/%.yang | $(TREE_DIR)/
	$(PYANG) -p yang -f tree --tree-print-groupings $< > $@

$(TREE_DIR)/:
	mkdir -p $(TREE_DIR)