# How to use this file:
#
# 0. docker system prune -a
# 1. docker build -t fecks-core:2.9.2.1 --target core -f hack-2.9.2.1.dockerfile .
# 2. docker build -t fecks-latex:2.9.2.1 --target latex -f hack-2.9.2.1.dockerfile .
#
# Why do have to use `fecks-core`?  Because we need to be able to download
# original pandoc/core:2.9.2.1 and pandoc/latex:2.9.2.1 first.  Then we can
#
# 3. docker image rm pandoc/core:2.9.2.1
# 4. docker image rm pandoc/latex:2.9.2.1
#
# and now we can
#
# 5. docker tag fecks-core:2.9.2.1 pandoc/core:2.9.2.1
#    docker tag fecks-core:2.9.2.1 pandoc/alpine:2.9.2.1
# 6. docker tag fecks-latex:2.9.2.1 pandoc/latex:2.9.2.1
#    docker tag fecks-latex:2.9.2.1 pandoc/alpine-latex:2.9.2.1
#
# Before pushing, lets make sure that we got things right and make sure entrypoint
# is still in tact.
#
# 7. docker run --rm -it --entrypoint /bin/sh pandoc/core:2.9.2.1
#    /data # which pandoc   <<< check for pandoc-citeproc, docker-entrypoint.sh
# 8. docker run --rm -it --entrypoint /bin/sh pandoc/latex:2.9.2.1
#    Same checks for core, _AND_ `which pandoc-crossref`
#
# If everything looks good then
#
# 9. docker push pandoc/core:2.9.2.1
#    docker push pandoc/alpine:2.9.2.1
# 10. docker push pandoc/latex:2.9.2.1
#     docker push pandoc/alpine-latex:2.9.2.1
#
# NOTE: pretty sure we can only do this once so don't screw up.
FROM pandoc/core:2.9.2.1 as core
COPY --from=pandoc/alpine-crossref:2.9.2.1 \
  /usr/local/bin/pandoc \
  /usr/local/bin/pandoc-citeproc \
  /usr/bin/

FROM pandoc/latex:2.9.2.1 as latex
COPY --from=pandoc/alpine-crossref:2.9.2.1 \
  /usr/local/bin/pandoc \
  /usr/local/bin/pandoc-citeproc \
  /usr/local/bin/pandoc-crossref \
  /usr/bin/
