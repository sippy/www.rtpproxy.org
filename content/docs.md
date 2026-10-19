+++
title = "Documentation"
description = "RTPProxy user manual, manual pages, release notes and control protocol reference."
layout = "docs"

[[groups]]
name = "Guides"
  [[groups.items]]
  title = "User Manual"
  url = "/doc/master/user_manual.html"
  icon = "book"
  text = "Installation, configuration, systemd integration, logging and the loadable modules (DTLS gateway, ICE-lite, accounting, DTMF and more)."
  [[groups.items]]
  title = "Control Protocol"
  url = "https://github.com/sippy/rtpproxy/wiki/RTPProxy-Command-Protocol"
  icon = "terminal"
  text = "The command reference that SIP proxies and B2BUAs use to drive the RTPProxy."

[[groups]]
name = "Manual pages"
  [[groups.items]]
  title = "rtpproxy(8)"
  url = "/doc/master/rtpproxy.8.html"
  icon = "list"
  text = "Command-line options of the RTPProxy daemon."
  [[groups.items]]
  title = "extractaudio(1)"
  url = "/doc/master/extractaudio.1.html"
  icon = "list"
  text = "Convert recorded RTP sessions into regular audio files."
  [[groups.items]]
  title = "makeann(1)"
  url = "/doc/master/makeann.1.html"
  icon = "list"
  text = "Pre-encode prompts and announcements for playback into calls."

[[groups]]
name = "Releases"
  [[groups.items]]
  title = "Latest stable release"
  url = "https://github.com/sippy/rtpproxy/releases/latest"
  icon = "download"
  text = "Source tarballs, Debian packages and release notes on GitHub."
  [[groups.items]]
  title = "Development release notes"
  url = "/doc/master/release_info.html"
  icon = "tag"
  text = "Changes on the master branch that are not in a stable release yet."
  [[groups.items]]
  title = "Release history"
  url = "/tags/releases/"
  icon = "list"
  text = "Announcements for every release since v2.0.0."
+++
Everything you need to deploy, configure and integrate the RTPProxy. The manuals are generated from the master branch of the [source repository](https://github.com/sippy/rtpproxy/tree/master/doc).
