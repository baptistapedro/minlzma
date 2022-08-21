FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev libpng-dev
RUN git clone  https://github.com/ionescu007/minlzma.git
WORKDIR /minlzma
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ .
RUN make
RUN mkdir /lzmaCorpus
RUN xz --format=lzma minlzma.png
RUN wget https://github.com/strongcourage/fuzzing-corpus/blob/master/xz/default.xz
RUN xz --format=lzma default.xz
RUN xz --format=lzma CMakeLists.txt
RUN xz --format=lzma Makefile
RUN mv *.lzma /lzmaCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/lzmaCorpus", "-o", "/lzmaOut"]
CMD  ["/minlzma/minlzdec/minlzdec", "@@", "outf"]
