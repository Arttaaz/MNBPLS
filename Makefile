
all: clean simu video

simu: simu.sce
	scilab -nw -f $< 

video: 
	ffmpeg -r 12 -i 'ite_%04d.png' -c:v libx264 -vf fps=24 -pix_fmt yuv420p simu.mp4

test: 
	$(MAKE) -C ./poisson poisson
	$(MAKE) -C ./poisson curl
	$(MAKE) simu

clean:
	$(MAKE) -C ./poisson clean
	$(RM) ite_*.png
	$(RM) isocontours_*.png
	$(RM) simu.mp4
	
