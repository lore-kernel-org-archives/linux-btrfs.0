Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58534 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965567AbaKNTF6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 14:05:58 -0500
Date: Fri, 14 Nov 2014 11:05:28 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Cc: llowrey@nuclearwinter.com
Message-ID: <20141114190528.GS3056@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Suggestion on reducing short kernel hangs from my btrfs filesystems:
 bcache?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a server which runs zoneminder (video recording which is CPU and
disk IO intensive) while also doing a bunch of I/O over serial ports.

I have a a dual core
Intel(R) Core(TM) i3-2100T CPU @ 2.50GHz
(4 virtual CPUs in /proc/cpuinfo)

It's pretty clear that when zoneminder is doing more work, my programs
that talk to serial ports start failing due to delays on the kernel side
and desynchronization, causing serial port protocol errors (I'm using
USB serial adapters, and use 12 of them).
I'm pretty sure it's because of delays in the kernel more than user
space, but can't prove that easily.

I have a preempt kernel, kernel 3.16.3:
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_DEBUG_PREEMPT=y

>From what I can tell, things did get worse after I upgraded from ext4 to
btrfs (not counting times where I resync the software raid5 underneath
or run a btrfs scrub).

I may try to see if VOLPREMPT might work better, but I'm thinking
putting an SSD in front of that mdadm RAID5 array will help by relieving
the IO load and hopefully giving more time for the CPU to handle serial
port requests.
I'm actually not sure if my issue is btrfs interrupting serial port
connections due to PREEMPT, or if serial port connections aren't being
serviced quickly enough because the kernel is busy with btrfs and PREMPT
hasn't kicked in yet.

>From reading the list, bcache may work with btrfs, but before I try
that, I was curious if there are other or better ways to use an SSD to
make btrfs less impacting on my server?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
