ARG base_tag="edge"
FROM pandoc/ubuntu-latex:${base_tag}

RUN apt-get update \
        && apt-get -y install --no-install-recommends \
        python2 \
        fonts-noto fonts-noto-extra fonts-noto-cjk fonts-noto-cjk-extra \
        && rm -rf /var/lib/apt/lists/*

RUN tlmgr install \
        tex-gyre tex-gyre-math \
        palatino mathpazo \
        ctex \
        unicode-math \
        texliveonfly \
        collection-fontsrecommended \
        latexmk

RUN ln -s `kpsewhich -var-value TEXMFSYSVAR`/fonts/conf/texlive-fontconfig.conf /etc/fonts/conf.d/09-texlive.conf \
        && fc-cache -fsv

ENTRYPOINT ["/bin/sh"]

WORKDIR /data
