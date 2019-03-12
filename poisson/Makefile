
all: poisson

poisson: test_poisson.sce poisson.sce
	scilab -nw -f $< 

curl: test_poisson_curl.sce poisson.sce
	scilab -nw -f $< 

clean:
	$(RM) poisson_error.png
	$(RM) poisson_curl_error.png
