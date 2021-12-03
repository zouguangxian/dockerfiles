ARG base_tag="edge"
FROM pandoc/ubuntu-latex:${base_tag}

RUN apt-get update \
        && apt-get -y install --no-install-recommends ca-certificates zsh wget git \
        && rm -rf /var/lib/apt/lists/*

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
