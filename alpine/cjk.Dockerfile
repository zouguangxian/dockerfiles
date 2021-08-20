ARG base_tag="edge"
FROM pandoc/latex:${base_tag}

RUN apk --no-cache add \
        python2 \
        font-noto font-noto-extra font-noto-cjk font-noto-cjk-extra \
        ttf-dejavu

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
