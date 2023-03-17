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
	@echo 'make serve [PORT=8000]       serve site at http://0.0.0.0:${PORT}'
	@echo ' '

clean:
	rm -f *~ .*~
	find . -iname *~ -delete
	find . -iname .*~ -delete

serve: 
	python3 -m http.server ${HTTP_PORT}

