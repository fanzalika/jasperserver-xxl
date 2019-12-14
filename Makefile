
IMAGE = fanzalika/jasperserver:7.2

all: | zip image dangling

image:
	#unzip TIB_js-jrs-cp_7.2.0_bin.zip
	docker rmi $(IMAGE)
	docker build . -t $(IMAGE) | tee log.txt

zip:
	if [ ! -f TIB_js-jrs-cp_7.2.0_bin.zip  ] ; then \
		curl -SL http://sourceforge.net/projects/jasperserver/files/JasperServer/JasperReports%20Server%20Community%20Edition%207.2.0/TIB_js-jrs-cp_7.2.0_bin.zip; \
	fi ;

dangling:	
	docker image ls -q -f 'dangling=true' | xargs docker rmi -f
	