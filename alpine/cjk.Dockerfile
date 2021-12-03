ARG base_tag="edge"
FROM pandoc/alpine-latex:${base_tag}

RUN apk --update-cache --no-cache add ca-certificates zsh wget git

RUN tlmgr install \
        texliveonfly \
        latexmk \
        ctex

RUN ln -s `kpsewhich -var-value TEXMFSYSVAR`/fonts/conf/texlive-fontconfig.conf /etc/fonts/conf.d/09-texlive.conf \
        && fc-cache -fsv

COPY ./common/setup-for-zsh.sh \
  /opt/bin/setup-for-zsh.sh

ENTRYPOINT ["/bin/sh"]

WORKDIR /data
