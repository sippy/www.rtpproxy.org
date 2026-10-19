www.rtpproxy.org
================

Public website for the [sippy/rtpproxy](https://github.com/sippy/rtpproxy) project.

The site is generated with [Hugo](https://gohugo.io/) (a recent release, 0.146 or
newer) and published to GitHub Pages by the `Publish Web Site` workflow on every
push to `master`.

Layout
------

- `content/`: pages and news posts (Markdown). Tag posts with `releases` or `talks`
  so they show up on the home page and in the news filters.
- `data/`: feature cards and integrations shown on the home page.
- `layouts/`: site templates; no external theme is used.
- `static/`: stylesheets, scripts, images.
- `docbook/site.xsl`: DocBook customization used by `gendocs.sh` to render the
  manuals from the rtpproxy source tree into `static/doc/<branch>/`.

Building locally
----------------

    git clone https://github.com/sippy/rtpproxy.git ../rtpproxy
    sh gendocs.sh    # needs xsltproc and the DocBook XSL stylesheets
    hugo server
