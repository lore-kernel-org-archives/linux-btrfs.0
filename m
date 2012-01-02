From: Daniel Pocock <daniel@pocock.com.au>
Subject: btrfs-tools in Debian squeeze-backports?
Date: Mon, 02 Jan 2012 15:29:49 +0100
Message-ID: <4F01BF5D.2070801@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>



These are the btrfs-tools versions on Debian:

squeeze:
kernel: 2.6.32
tools: 0.19+20100601-3

squeeze-backports:
kernel: 2.6.39
tools: nothing (so user ends up with 0.19+20100601-3)

wheezy/testing/sid:
kernel: 3.1.6-1
tools: 0.19+20111105-2

Using the 2.6.39 kernel from squeeze-backports, do I need a newer
btrfs-tools and is there a particular reason it is not in
squeeze-backports too?

Or should I not be trying to use the versions in squeeze at all - should
I be on testing/wheezy or unstable?

The Debian btrfs wiki and the regular btrfs wiki don't really suggest a
good starting point (other than suggesting the btrfs has been in Debian
since squeeze)
http://wiki.debian.org/Btrfs

If I try to use the version from testing or unstable, I get this error
on a squeeze setup:

 btrfs-tools depends on e2fslibs (>= 1.41.99); however:
  Version of e2fslibs on system is 1.41.12-4stable1.


http://packages.debian.org/search?keywords=btrfs-tools


