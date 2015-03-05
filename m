Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49972 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbbCELsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Mar 2015 06:48:03 -0500
Received: from wirrsal ([78.48.162.105]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0Lpxdr-1XryNS1qaN-00fm1S for
 <linux-btrfs@vger.kernel.org>; Thu, 05 Mar 2015 12:48:01 +0100
Message-ID: <1425556080.32673.11.camel@gmx.de>
Subject: Lock-ups, assertion failure  in btrfsck, scrub reporting super=4
From: Tobias Getzner <tobias.getzner@gmx.de>
To: linux-btrfs@vger.kernel.org
Date: Thu, 05 Mar 2015 12:48:00 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had been running kernel 3.19 for a few days now, when yesterday I
started getting hard lock-ups all the time. These seemed to be
correlated to some program activity, most likely to running Firefox. I
downgraded back to 3.18.6, but the problem persisted, though now I only
got soft lock-ups which I could (after SysRQ+REISUB) inspect in dmesg.
dmesg info pointed me toward btrfs.

For what it’s worth, I uploaded the full kernel logs to:

    http://a.pomf.se/zsywtk.xz

These might seem noteworthy:

> kernel BUG at fs/btrfs/ctree.h:2565!
> kernel BUG at fs/btrfs/ctree.h:2501!
> NMI watchdog: BUG: soft lockup + btrfs-related stack trace
> WARNING: CPU: 2 PID: 7051 at fs/btrfs/scrub.c:2461 scrub_stripe 0xcb8/0x1080 [btrfs]()

Since the lock-ups appeared predictably a few minutes after boot &
launching Firefox, I tried running btrfsck (without --repair) to see
whether something is wrong with the home volume (maybe due to the
unclean shutdowns from earlier lock-ups). However, when running
btrfsck, all I get is:

> checking extents
> cmds-check.c:4943: process_extent_item: Assertion `item_size !=
sizeof(*ei0)` failed.
> btrfs check[0x41a7dc]
> btrfs check[0x41d9af]
> btrfs check[0x423751]
> btrfs check[0x4241e9]
> btrfs check[0x424de1]
> btrfs check(cmd_check+0x14b5)[0x427f0b]
> btrfs check(main+0x15d)[0x40997d]
> /usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f8ce834d800]
> btrfs check(_start+0x29)[0x409539]

Does this indicate any particular problems with the file system?

In addition, I ran a full scrub. This finished with «scrubbed … with 0
errors», but it also reported:

> error details: super=4
> corrected errors: 0, uncorrectable errors: 0, unverified errors: 0

I booted back into the graphical system, and when not running Firefox,
I did not get any immediate lock-ups anymore.

I’d welcome any advice on how to proceed, i.e., in how to resolve the
lock-ups, and, if possible, in fixing potential problems with the
file-system.

Best regards,
Tobias

