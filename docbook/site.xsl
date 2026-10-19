<?xml version="1.0" encoding="UTF-8"?>
<!--
  DocBook customization layer used by gendocs.sh: renders the manuals from
  the rtpproxy source tree with the site's header, footer and stylesheets.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml/docbook.xsl"/>

  <xsl:param name="html.stylesheet">/css/site.css /css/docs.css</xsl:param>
  <xsl:param name="css.decoration" select="0"/>
  <xsl:param name="admon.style"/>
  <xsl:param name="table.borders.with.css" select="1"/>
  <xsl:param name="generate.id.attributes" select="1"/>
  <xsl:param name="toc.section.depth" select="2"/>
  <!-- One table of contents per book; no per-chapter ones. -->
  <xsl:param name="generate.toc">book toc,title</xsl:param>
  <!-- No "Chapter N." prefixes on headings or in the TOC. -->
  <xsl:param name="chapter.autolabel" select="0"/>

  <xsl:template name="user.head.content">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="theme-color" content="#0b1220"/>
    <link rel="icon" href="/favicon.svg" type="image/svg+xml"/>
  </xsl:template>

  <xsl:template name="body.attributes">
    <xsl:attribute name="class">is-inner is-doc</xsl:attribute>
  </xsl:template>

  <xsl:template name="user.header.content">
    <header class="site-header">
      <div class="wrap nav">
        <a class="brand" href="/" aria-label="RTPProxy home">
          <img class="logo" src="/favicon.svg" alt=""/>
          <span>RTP<b>Proxy</b></span>
        </a>
        <nav class="nav-links doc-nav" aria-label="Main">
          <a href="/docs/" aria-current="page">Docs</a>
          <a href="/post/">News</a>
          <a href="/about/">About</a>
          <a class="btn btn-ghost btn-sm" href="https://github.com/sippy/rtpproxy">GitHub</a>
        </nav>
      </div>
    </header>
    <div class="wrap doc-crumbs">
      <a href="/docs/">&#8592; Documentation</a>
    </div>
  </xsl:template>

  <xsl:template name="user.footer.content">
    <footer class="site-footer doc-footer">
      <div class="wrap footer-base">
        <span>Generated from the <a href="https://github.com/sippy/rtpproxy/tree/master/doc">rtpproxy source tree</a>.</span>
        <a href="https://github.com/sippy/rtpproxy/blob/master/LICENSE">BSD 2-Clause License</a>
      </div>
    </footer>
    <script src="/js/docs.js" defer="defer"><xsl:text> </xsl:text></script>
  </xsl:template>

</xsl:stylesheet>
