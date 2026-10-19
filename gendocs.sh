#!/bin/sh

# Render DocBook documentation from the rtpproxy source tree into
# static/doc/<branch>/, so that it is published along with the site.

set -e

RTPPROXY_DIR="${RTPPROXY_DIR:-../rtpproxy}"
DOC_BRANCH="${DOC_BRANCH:-master}"
XSL="${XSL:-docbook/site.xsl}"
ODIR="static/doc/${DOC_BRANCH}"

render() {
  xsltproc --nonet --xinclude -o "${ODIR}/${2}.html" "${XSL}" \
   "${RTPPROXY_DIR}/doc/${1}.xml"
}

rm -rf "${ODIR}"
mkdir -p "${ODIR}"

render user_manual user_manual
render release_info release_info
render manpage rtpproxy.8

# Manual pages that may not exist in older source trees
for m in extractaudio.1 makeann.1
do
  if [ -e "${RTPPROXY_DIR}/doc/${m%.*}.xml" ]
  then
    render "${m%.*}" "${m}"
  fi
done
