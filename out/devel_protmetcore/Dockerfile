# DO NOT EDIT FILES CALLED 'Dockerfile'; they are automatically
# generated. Edit 'Dockerfile.in' and generate the 'Dockerfile'
# with the 'rake' command.

# The suggested name for this image is: bioconductor/devel_protmetcore.

FROM bioconductor/devel_mscore2

MAINTAINER sneumann@ipb-halle.de

RUN apt-get update && apt-get -y install librsvg2-dev

ADD install.R /tmp/

# invalidates cache every 24 hours
ADD http://master.bioconductor.org/todays-date /tmp/

RUN R -f /tmp/install.R
