FROM nanoporetech/dorado:sha58b978562389bd0f1842601fb83cdf1eb2920218
#FROM nanoporetech/dorado
ADD ./deepsignal-plant /home/deepsignal-plant
ADD ./DeepS2bam_converter /home/DeepS2bam_converter
SHELL ["/bin/bash", "-c"]
WORKDIR /usr/src/app
# COPY requirements.txt requirements.txt


# RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8888
CMD /bin/bash
