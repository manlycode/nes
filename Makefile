setup: nesasm tools/nintaco/Nintaco.jar

.PHONY: clean
clean:
	rm -rf tools
	
tools:
	mkdir tools

tools/nintaco: tools
	curl https://nintaco.com/Nintaco_bin_2019-02-10.zip -o tools/nintaco.zip
	cd tools && unzip -a nintaco.zip -d nintaco
	rm tools/nintaco.zip

tools/nintaco/Nintaco.jar: tools/nintaco

.PHONY: nesasm
nesasm: tools
	git clone https://github.com/toastynerd/nesasm.git tools/nesasm
	cd tools/nesasm && make && PREFIX=~/bin make install