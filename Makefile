setup: nesasm
.PHONY: clean
clean:
	rm -rf tools
	
tools:
	mkdir tools

.PHONY: nesasm
nesasm: tools
	git clone https://github.com/toastynerd/nesasm.git tools/nesasm
	cd tools/nesasm && make && PREFIX=~/bin make install

