+++
date = 2014-06-19T14:50:26Z
draft = false
title = "About RTPProxy"
slug = "about"
description = "The history of the RTPProxy, who maintains it, and how to get involved."
+++

## Backstory

Maksym Sobolyev wrote RTPProxy in 2003 so that VoIP calls could reach SIP user agents behind NAT and firewalls. In many of those cases the two endpoints could not exchange media directly. RTPProxy, working with a SIP proxy, solves this by relaying the RTP streams between them.

VoIP service providers soon adopted it to control how media flows through their networks. Over time it gained many other uses. Together with a signalling element (a SIP proxy or a SIP B2BUA), it can build complex VoIP networks, optimize traffic flow and collect voice quality information. It can also record calls, play pre-encoded announcements, copy streams in real time and re-frame RTP payloads.

## Today

RTPProxy still does what it was built for, and it does much more. Recent releases added:

- **WebRTC interop.** The `dtls_gw` and `ice_lite` modules bridge DTLS-SRTP and plain RTP, answer ICE connectivity checks and multiplex RTCP.
- **SIPREC-style recording.** Sessions can be forked and recorded in a single control transaction.
- **Embedding.** `librtpproxy` can host multiple independent instances inside another process. [RTP.io](/post/2026-opensips-summit-demo/) uses it to run the RTPProxy directly inside OpenSIPS, and Python applications such as Sippy B2BUA can embed it as well.
- **Packaging.** Debian packages and Docker images are published with every release.

The `rtpproxy` modules of OpenSIPS and Kamailio, as well as the Sippy B2BUA, can drive many RTPProxy instances on remote machines for fault tolerance and load balancing. [RTP Cluster](https://github.com/sippy/rtp_cluster) adds high-capacity clustering on top of that.

## Who maintains it

[Sippy Software, Inc.](https://www.sippysoft.com) actively develops and maintains RTPProxy, and it is available on [GitHub](https://github.com/sippy/rtpproxy). Many individuals and organizations have contributed features and fixes over the years, including Vonage, SipPulse, Voicenter and RateTel, either directly or by sponsoring development (often both).

The original idea also inspired several independent implementations, including [MediaProxy](https://github.com/AGProjects/mediaproxy), [erlrtpproxy](https://github.com/lemenkov/erlrtpproxy) and [RTPEngine](https://github.com/sipwise/rtpengine).

## Get involved

- Report bugs and send pull requests on [GitHub](https://github.com/sippy/rtpproxy).
- Ask questions on the [mailing list](https://groups.google.com/forum/#!forum/rtpproxy).
- Follow [@sippylabs](https://twitter.com/sippylabs) for release announcements.

RTPProxy is distributed under the two-clause [BSD license](https://github.com/sippy/rtpproxy/blob/master/LICENSE).
