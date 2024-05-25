
ENV_NAME		:=	myenv
MY_PACKAGES		:=	mypackages
PYTHON_VERSION	:=	3.12
# ---------------------------------------------------------------------------- #
#               COLORS                                                         #
# ---------------------------------------------------------------------------- #
ERASE		:=	\033[2K\r
BLUE		:=	\033[34m
MAGENTA		:=	\033[35m
CYAN		:=	\033[36m
RED			:=	\033[31m
YELLOW		:=	\033[33m
GREEN		:=	\033[32m
BOLD		:=  \033[1m
END			:=	\033[0m
# ---------------------------------------------------------------------------- #
#               TARGETS                                                        #
# ---------------------------------------------------------------------------- #

.PHONY:	run install-mypackages
run:	install-mypackages
	@printf "$(ERASE)$(YELLOW)++++++++++++++++++++++++++++++++++++++++ [$@]\n$(END)"
	@conda run -n $(ENV_NAME) python run.py
	@printf "$(ERASE)$(YELLOW)++++++++++++++++++++++++++++++++++++++++ End\n"
	@echo OK!
	@echo
	@printf "$(END)"

.PHONY:	run-cli	install-mypackages
run-cli:	install-mypackages
	@printf "$(ERASE)$(YELLOW)++++++++++++++++++++++++++++++++++++++++ [$@]\n$(END)"
	@conda run -n $(ENV_NAME) run-cli
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
	conda run -n $(ENV_NAME) python -m build 

.PHONY: install-mypackages
install-mypackages:	pyproject.toml 
	@if conda run -n $(ENV_NAME) pip list | grep -q $(MY_PACKAGES) ; then \
		printf "\n" ; \
	else \
		printf "$(ERASE)$(GREEN)Installing $(MY_PACKAGES)...\n$(END)" ; \
		conda run -n $(ENV_NAME) pip install -q -e . ; \
	fi

.PHONY: install-deps
install-deps:	requirements.txt
	@printf "$(ERASE)$(GREEN)Installing dependencies ... \n$(END)"
	conda run -n $(ENV_NAME) pip install -q -r requirements.txt

.PHONY: uninstall-mypackages
uninstall-mypackages:
	@if conda run -n $(ENV_NAME) pip list | grep -q $(MY_PACKAGES) ; then \
		printf "$(ERASE)$(RED)Uninstalling $(MY_PACKAGES) ... \n$(END)" ; \
		conda run -n $(ENV_NAME) pip uninstall -q -y $(MY_PACKAGES) ; \
	else \
		printf "$(ERASW)$(GREEN)$(MY_PACKAGES) uninstalled... \n$(END)" ; \
	fi

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

