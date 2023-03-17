PORT ?= 0
ifneq ($(PORT), 0)
	HTTP_PORT += $(PORT)
else
	HTTP_PORT += 8000
endif

help:
	@echo 'Makefile for bootstrap-workstation'
	@echo ' '
	@echo 'Usage:'
	@echo 'make clean                   remove stale files'
	@echo 'make devdeps                 install development tools'
	@echo 'make lint                    check role for errors'
	@echo 'make serve [PORT=8000]       serve site at http://0.0.0.0:${PORT}'
	@echo ' '

clean:
	rm -f *~ .*~
	find . -iname *~ -delete
	find . -iname .*~ -delete

devdeps:
	sudo dnf --assumeyes install ansible-core \
		ansible-collection-community-general \
		ansible-collection-ansible-posix \
		python3-ansible-lint

lint:
	ansible-lint ./ansible/bootstrap_workstation.yml

serve: 
	python3 -m http.server ${HTTP_PORT}

