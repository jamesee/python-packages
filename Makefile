
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
run:	build
	@printf "$(ERASE)$(YELLOW)"
	@echo "++++++++++++++++++++++++++++++++++++++++ [$@]"
	@printf "$(END)"
	conda run -n $(ENV_NAME) python run.py
	@printf "$(ERASE)$(YELLOW)"
	@echo "++++++++++++++++++++++++++++++++++++++++ End"
	@echo OK!
	@echo
	@printf "$(END)"

create_env:
	conda create --name $(ENV_NAME) python=3.12 -y

build:	pyproject.toml install_deps
	conda run -n $(ENV_NAME) python -m build
	conda run -n $(ENV_NAME) pip install dist/*.whl --force-reinstall

install_deps:	requirements.txt create_env
	conda run -n $(ENV_NAME) pip install -r requirements.txt

clean:
	@echo "++++++++++++++++++++++++++++++++++++++++ [$@]"
	@printf "$(ERASE)$(CYAN)" ; \
 	[ -f dist/*.whl ] && conda run -n $(ENV_NAME) pip uninstall -y dist/*.whl || true
	@printf "$(END)"
	@echo "++++++++++++++++++++++++++++++++++++++++ End"

fclean:	clean
	@echo "++++++++++++++++++++++++++++++++++++++++ [$@]"
	@printf "$(ERASE)$(CYAN)"
	rm -rf dist
	@printf "$(END)"
	@echo "++++++++++++++++++++++++++++++++++++++++ End"

rm_env:
	conda remove -n $(ENV_NAME) --all -y

re:	fclean run

