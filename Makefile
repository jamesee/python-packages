include	Makefile.var
include	Makefile.col

# ---------------------------------------------------------------------------- #
#               TARGETS                                                        #
# ---------------------------------------------------------------------------- #

.PHONY:	run install-mypackages
run:	install-mypackages
	@printf "$(ERASE)$(YELLOW)++++++++++++++++++++++++++++++++++++++++ [$@]\n$(END)"
	@$(ACTIVATE_ENV) python run.py
	@printf "$(ERASE)$(YELLOW)++++++++++++++++++++++++++++++++++++++++ End\n"
	@echo OK!
	@echo
	@printf "$(END)"

.PHONY:	run-cli	install-mypackages
run-cli:	install-mypackages
	@printf "$(ERASE)$(YELLOW)++++++++++++++++++++++++++++++++++++++++ [$@]\n$(END)"
	@$(ACTIVATE_ENV) run-cli
	@printf "$(ERASE)$(YELLOW)++++++++++++++++++++++++++++++++++++++++ End\n"
	@echo OK!
	@echo
	@printf "$(END)"

.PHONY:	init
init:	create-env install-deps install-mypackages

.PHONY: create-env 
create-env:
	@if conda info --envs | grep -q $(ENV_NAME) ; then \
		printf "\n" ; \
	else \
		printf "$(ERASE)$(GREEN)Creating $(ENV_NAME) environment ... \n$(END)" ; \
		conda create --quiet --name $(ENV_NAME) python=$(PYTHON_VERSION) -y; \
	fi

.PHONY: build-wheel
build-wheel:	pyproject.toml 
	$(ACTIVATE_ENV) python -m build
	$(ACTIVATE_ENV) pip install dist/$(MY_PACKAGES)*.whl --force-reinstall 

.PHONY: install-mypackages
install-mypackages:	pyproject.toml 
		@if $(ACTIVATE_ENV) pip list | grep -q $(MY_PACKAGES) ; then \
			printf "\n" ; \
		else \
			printf "$(ERASE)$(GREEN)Installing $(MY_PACKAGES)...\n$(END)" ; \
			$(ACTIVATE_ENV) pip install -q -e . ; \
		fi

.PHONY: install-deps
install-deps:	requirements.txt
	@printf "$(ERASE)$(GREEN)Installing dependencies ... \n$(END)"
	$(ACTIVATE_ENV) pip install -q -r requirements.txt

.PHONY: uninstall-mypackages
uninstall-mypackages:
	@if $(ACTIVATE_ENV) pip list | grep -q $(MY_PACKAGES) ; then \
		printf "$(ERASE)$(RED)Uninstalling $(MY_PACKAGES) ... \n$(END)" ; \
		$(ACTIVATE_ENV) pip uninstall -q -y $(MY_PACKAGES) ; \
	else \
		printf "$(ERASE)$(GREEN)$(MY_PACKAGES) uninstalled... \n$(END)" ; \
	fi

install-conda:
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O /tmp/miniconda.sh
	bash /tmp/miniconda.sh -b -p /tmp/miniconda

.PHONY:	clean
clean:	uninstall-mypackages

.PHONY: fclean 
fclean:	
	@printf "$(ERASE)$(YELLOW)++++++++++++++++++++++++++++++++++++++++ [$@]\n$(END)"
	@printf "$(ERASE)$(CYAN)"
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf dist
	@printf "$(END)"
	@printf "$(ERASE)$(YELLOW)++++++++++++++++++++++++++++++++++++++++ End\n$(END)"

.PHONY: rm-env
rm-env:
	conda remove -n $(ENV_NAME) --all -y

.PHONY: fclean run
re:	fclean run

debug:
	@echo "ENV = $(ENV)"
