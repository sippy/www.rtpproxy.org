+++
date = 2014-06-19T14:50:26Z
draft = false
title = "Backstory"
slug = "about"

+++
RTPProxy was originally developed by Maxim Sobolyev in 2003 for the purpose of enabling VoIP calls to/from SIP User Agents located behind NAT firewalls. Several case existed where direct end-to-end communication between NATed SIP User Agents was not possible. RTPProxy, in conjunction with a SIP proxy overcomes these impediments by acting as a go between for the RTP streams.

Subsequently, the RTPProxy became widely used by VoIP service providers that needed to optimize traffic flow in their networks.

Later on it became apparent that there are many other possible uses for this software. It can be used in combination with a signalling element (SIP Proxy or SIP B2BUA) to build complex VoIP networks, optimize traffic flow, collect voice quality information and so on. It can perform number of additional functions on RTP streams, including call recording, playing pre-encoded announcements, real-time stream copying and RTP payload re-framing.

The RTPproxy supports some advanced features, such as remote control mode, allowing building scalable distributed SIP VoIP networks. The nathelper module included into the SIP Express Router (SER), OpenSIPS or Kamailio as well Sippy B2BUA allow using multiple RTPproxy instances running on remote machines for fault-tolerance and load-balancing purposes.

RTPproxy is actively maintained by the [Sippy Software, Inc.](http://www.sippysoft.com) and is available on [GitHub](http://github.com/sippy/rtpproxy)



