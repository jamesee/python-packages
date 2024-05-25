
ENV_NAME = myenv

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

.PHONY:	run install-deps
run:
	@printf "$(ERASE)$(YELLOW)"
	@echo "++++++++++++++++++++++++++++++++++++++++ [$@]"
	@printf "$(END)"
	conda run -n $(ENV_NAME) python run.py
	@printf "$(ERASE)$(YELLOW)"
	@echo "++++++++++++++++++++++++++++++++++++++++ End"
	@echo OK!
	@echo
	@printf "$(END)"

.PHONY:	init
init:	create-env install-deps build

.PHONY: create-env 
create-env:
	@if conda info --envs | grep -q $(ENV_NAME) ; then \
		echo "$(ENV_NAME) exist ..." ; \
	else \
		echo "$(ENV_NAME) not exist. Creating $(ENV_NAME) environment ..." ; \
		conda create --name $(ENV_NAME) python=3.12 -y ; \
	fi

.PHONY: build
build:	pyproject.toml 
	conda run -n $(ENV_NAME) pip install -e . 

.PHONY: install-deps
install-deps:	requirements.txt
	conda run -n $(ENV_NAME) pip install -q -r requirements.txt

.PHONY: clean
clean:
	@echo "++++++++++++++++++++++++++++++++++++++++ [$@]"
	@printf "$(ERASE)$(CYAN)" ; \
 	[ -f dist/*.whl ] && conda run -n $(ENV_NAME) pip uninstall -y dist/*.whl || true
	@printf "$(END)"
	@echo "++++++++++++++++++++++++++++++++++++++++ End"

.PHONY: fclean
fclean:	clean
	@echo "++++++++++++++++++++++++++++++++++++++++ [$@]"
	@printf "$(ERASE)$(CYAN)"
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf dist
	@printf "$(END)"
	@echo "++++++++++++++++++++++++++++++++++++++++ End"

.PHONY: rm-env
rm-env:
	conda remove -n $(ENV_NAME) --all -y

.PHONY: fclean run
re:	fclean run

