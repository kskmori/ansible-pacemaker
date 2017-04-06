preview:
	grip README.md

clean:
	@rm -f *.retry
	@find . -name '*~' -exec rm {} \;
