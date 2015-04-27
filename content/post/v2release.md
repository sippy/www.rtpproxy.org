+++
date = 2015-03-09T02:00:51Z
draft = false
slug = "v2release"
title = "rtpproxy v2.0.0 release"
tags = ["releases"]
author = "@sobomax"

+++

# rtpproxy v2.0.0 Release Notes

This is the first official release since version 1.2 in March 2009. v2.0 release brings 5-years worth of extensive improvements in performance, quality, and test coverage. This release has been heavily tested in production environments, and has had significant contributions from the open-source community.

This is the first release since we moved the project to github, and travis-ci for automated test coverage.

rtpproxy is a [Sippy Software, Inc](http://www.sippysoft.com/) open source project. The rtpproxy is part of Sippy's commercial soft switch product, and Sippy's clustered media gateway project. rtpproxy is also widely used in other VoIP service provider networks.
rptproxy supports [Opensips](http://www.opensips.org/), [Kamailio](http://www.kamailio.org), and Sippy's own open source [b2bua](https://github.com/sippy/b2bua)

## Notable Changes

### Performance / Quality

Reduction in CPU usage by 40% to 60% has been observed on production deployments.
Jitter (measured using wire shark) characteristics have improved significantly.

These quality and performance improvements come mostly from improvements in the following areas:

- send receive threads are now asynchronous
- poll() is called more intelligently thanks to a PLL timing loop, resulting in much better jitter characteristics
- poll() is called less frequently for `RTCP` than for `RTP`
- command processing I/O happens on separate background thread
- Overall reduction in poll() overhead

## New stats counters 

The rtp command protocol (rtpp) has a new command `G` that gives access to the following counters:

- `nsess_created` Number of RTP sessions created
- `nsess_destroyed` Number of RTP sessions destroyed
- `nsess_timeout` Number of RTP sessions ended due to media timeout
- `nsess_complete` Number of RTP sessions fully setup
- `nsess_timeout` Number of sessions ended due to media timeout
- `nsess_nortp` Number of sessions that had no RTP neither in nor out
- `nsess_owrtp` Number of sessions that had one-way RTP only
- `nsess_nortcp` Number of sessions that had no RTCP neither in nor out
- `nsess_owrtcp` Number of sessions that had one-way RTCP only
- `nplrs_created` Number of RTP players created
- `nplrs_destroyed` Number of RTP players destroyed
- `npkts_rcvd` Total number of RTP/RTPC packets received
- `npkts_played` Total number of RTP packets locally generated (played out)
- `npkts_relayed` Total number of RTP/RTPC packets relayed
- `npkts_resizer_in` Total number of RTP packets going into re-sizer (re-packetizer)
- `npkts_resizer_out` Total number of RTP packets coming out of re-sizer (re-packetizer)
- `npkts_resizer_discard` Number of RTP packets discarded by the re-sizer (re-packetizer)
- `npkts_discard` Total number of RTP/RTPC packets discarded
- `total_duration` Cumulative duration of all sessions
- `ncmds_rcvd` Total number of control commands received
- `ncmds_succd` Total number of control commands successfully processed
- `ncmds_errs` Total number of control commands ended up with an error
- `ncmds_repld` Total number of control commands that had a reply generated

## Re-packetization support to resize rtp packet sizes.

Re-packetization allows providers to resize the rtp frame size between a caller and a callee. This is useful for saving bandwidth between pops, or for interoperability with vendors who require a non-standard ptime. For example, the standard ptime for g.729 is 20 msec, but a vendor may require that ptime be 60msec. Re-packetization allows this resizing to happen on the fly. See also the monitoring counters `npkts_resizer_in`, `npkts_resizer_out` and `npkts_resizer_discard` that relates to this feature.

## SIGHUP for graceful shutdown

The SIGHUP signal will initiate a slow shut down. In this mode any new rtpp requests for a new session will be rejected with a E99 code. The rtpproxy will exit only after all active sessions have ended. This feature simplifies planned maintenance.

## Updated `makeann` utility

The `makeann` utility takes 16-bit signed linear encoded audio and produces a file for each supported codec.

`makeann` codecs are supported:
  - G.711u
  - G.711a
  - G.722 (new in 2.0)
  - G.729 (new in 2.0)
  - GSM (new in 2.0)

## New `extractaudio` Utility

The `extractaudio` utility extracts audio streams and writes the recording to disk in wav format.  The utility existed before 2.0, but it was not connected to the autoconf/automake build and as such required manual intervention to compile. The test suite uses this utility to verify that audio is transmitted correctly. The utility can be used for recording purposes also.

`extractaudio` supported codecs:
  - G.711u
  - G.711a
  - G.722 (new in 2.0)
  - G.729 (new in 2.0)
  - GSM (new in 2.0)

The new flag `-n` has been added in 2.0 to avoid inserting blank audio periods to keep streams synchronized to real time. Mostly intended for CI use to provide predictable output.

## Logging

- Call-ID is now recorded in log files

## RTPP Command Channel Improvements

- Improved stream-based communication support to accept more than one command in the batch, don't expect sender to pause and wait for the reply after issuing a command.
- the rtpprroxy improved performance by using a hash table for look ups 
- new `G` command to retrieve stat counters;
- new `s` modifier for the `R` command to record both streams into a single file (requires PCAP recording mode to be enabled via `-P` command-line option).
- simple commands are now executed without holding global lock, which should increase total throughput in terms of maximum numbers of commands that can be processed per unit of time and reduce interference between command and rtp processing threads. Those commands are `V', `VF' and `G'.

## New Types of Control Channels

In 2.0, we've added the following 3 new control channels `cunix`, `stdio` and `systemd`, in addition to `unix` and `udp` as supported since v1.2:

- `cunix`, similar to `unix` except the server (e.g. rtpproxy) is not closing session after processing a command, so more commands can be posted and processed in sequence, thereby reducing overhead and complexity of the client code. Intended to become the default channel for local IPC;
- `stdio`, commands are read from stdin, replies are posted to stdout. Primarily designed to be used for CI. Example: `rtpproxy -s stdio: -f < some.commands`;
- `systemd`, get command from / post replies to the file descriptor provided by the `systemd` daemon. Only supported on Linux;

The control channel system has been overhauled to enable more than one channel to be used simultaneously.

## New and updated command line flags

`-s` now accepts `stdio`, `cunix:` and `systemd:` as an argument. rtpproxy can accept -s multiple times, which will cause it to listen on multiple control sockets. More than one control channels can be used independently. 
`-V` Show command protocol version.
`-L` Adjust the number of simultaneous open connections. Note that each RTP media stream requires four open connections. A SIP call can open more than one RTP media stream depending on the client's setup.
`-A address` Sets the advertised IP address.  `-A addr1/addr2` can also be used for bridging mode
`-W setup_ttl` Implements "Call Establishment Phase Timeout" as originally implemented in [this](https://github.com/OpenSIPS/opensips/blob/master/modules/rtpproxy/patches/rtpproxy_timeout_notification.fix_patch) opensips patch
`-w` Set access mode for the controlling UNIX-socket (if used). Only applies if rtpproxy runs under a different GID using `-u` option.
`-b` Don't randomize allocated ports, primarily aimed for debugging to provide more predictable behaviour

## New Continuous Integration (CI) / Testing suite

Automated tests are now run using [travis-ci](http://www.travis-ci.com)
There are two groups of tests, tests bundled with the rtpproxy distribution, that can be run using the `make check` target, and a suit of integration tests (opensips, kamailio, sippy b2bua).
### See [github.com/sippy/voiptests](https://github.com/sippy/voiptests) for the integration test suite.

### Summary of tests that run from the `make check` target
- `makeann` tests for all supported codecs
- Forwarding tests that verifies media from sender to receiver & the reverse
- Recording tests that verifies recording capability of the rtpproxy in both AdHoc and PCAP formats
- Simple command parser tests
- Playback tests that streams sample payload, captures packets from network, decodes and verifies the captured payload against the source payload.
- memdeb is an opt-in memory allocation tracker useful for detecting memory leaks
- session_timeout tests both types of session timeouts for both call establishment phase and session timeouts
- Re-packetization tests to verify proper functionality of the lossless re-packetization feature

See [rtpproxy/test/](https://github.com/sippy/rtpproxy/tree/master/tests) for more details.

## Lossless RTP Payload Resize

The Lossless RTP Payload Resize feature has been promoted from experimental to fully supported feature and has been extensively tested with all supported codecs, which currently include the following codecs:

  - G.711u
  - G.711a
  - G.729
  - G.722 (new in 2.0)
  - GSM (new in 2.0)

## Miscellaneous 

- make will build a `rtpproxy` binary and a `rtpproxy_debug` binary. The latter includes memdebug
- systemd support on Linux
- udp_storm - a utility to stress-test rtpproxy with the RTP-like traffic.

## Sponsors & Contributors


Thank you to our contributors!
- @sobomax 
- @bogdan-iancu
- @jevonearth
- @lemenkov 
- @miconda
- @oej
- @taisph 

