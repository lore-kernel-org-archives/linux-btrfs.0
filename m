Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43613 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbaIGRtF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Sep 2014 13:49:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XQgaF-0001gX-A7
	for linux-btrfs@vger.kernel.org; Sun, 07 Sep 2014 19:49:03 +0200
Received: from pd953e97b.dip0.t-ipconnect.de ([217.83.233.123])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Sep 2014 19:49:03 +0200
Received: from holger.hoffstaette by pd953e97b.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Sep 2014 19:49:03 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Linux 3.14.18 : kernel BUG at fs/btrfs/file.c:890!
Date: Sun, 7 Sep 2014 17:48:53 +0000 (UTC)
Message-ID: <pan.2014.09.07.17.48.53@googlemail.com>
References: <1410107980.2832.41.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 07 Sep 2014 18:39:40 +0200, Olivier Bonvalet wrote:

> I still have kernel BUG with recent btrfs fixes :
> 
> Sep  6 20:29:12 cm kernel: [ 6987.378592] ------------[ cut here ]------------
> Sep  6 20:29:12 cm kernel: [ 6987.378613] kernel BUG at fs/btrfs/file.c:890!
> (..snip..)
> Sep  6 20:29:12 cm kernel: [ 6987.379245] Call Trace:
> Sep  6 20:29:12 cm kernel: [ 6987.379262]  [<ffffffff810cee61>] ? ____cache_alloc+0x38/0x271
> Sep  6 20:29:12 cm kernel: [ 6987.379289]  [<ffffffffa016acd0>] ? insert_reserved_file_extent.constprop.60+0x85/0x269 [btrfs]
> Sep  6 20:29:12 cm kernel: [ 6987.379329]  [<ffffffffa016f1a7>] ? btrfs_finish_ordered_io+0x21d/0x3af [btrfs]
> Sep  6 20:29:12 cm kernel: [ 6987.379367]  [<ffffffffa018b40b>] ? worker_loop+0x175/0x4ba [btrfs]
> Sep  6 20:29:12 cm kernel: [ 6987.379389]  [<ffffffff81368197>] ? __schedule+0x310/0x47a
> Sep  6 20:29:12 cm kernel: [ 6987.379415]  [<ffffffffa018b296>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
> Sep  6 20:29:12 cm kernel: [ 6987.379438]  [<ffffffff81046ad3>] ? kthread+0xa7/0xaf
> Sep  6 20:29:12 cm kernel: [ 6987.379458]  [<ffffffff81040000>] ? flush_workqueue_prep_pwqs+0xff/0x14f
> Sep  6 20:29:12 cm kernel: [ 6987.379480]  [<ffffffff81046a2c>] ? __kthread_parkme+0x5b/0x5b
> Sep  6 20:29:12 cm kernel: [ 6987.379500]  [<ffffffff8136eebc>] ? ret_from_fork+0x7c/0xb0
> Sep  6 20:29:12 cm kernel: [ 6987.379521]  [<ffffffff81046a2c>] ? __kthread_parkme+0x5b/0x5b
> Sep  6 20:29:12 cm kernel: [ 6987.379539] Code: 0f 82 85 01 00 00 83 7c 24 14 00 75 11 8b 7d 40 c7 44 24 14 01 00 00 00 89 7c 24 44 eb 13 8b 54 24 44 03 54 24 14 3b 55 40 74 02 <0f> 0b ff 44 24 14 83 7c 24 48 00 75 2b 80 7c 24 63 00 74 24 48 
> Sep  6 20:29:12 cm kernel: [ 6987.379628] RIP  [<ffffffffa017716f>] __btrfs_drop_extents+0x685/0x953 [btrfs]
> Sep  6 20:29:12 cm kernel: [ 6987.379666]  RSP <ffff8801f5c39c40>
> Sep  6 20:29:12 cm kernel: [ 6987.379824] ---[ end trace 88011934e4908482 ]---

I cannot really offer much assistance, but that particular area of code
looks suspiciously like something fixed later and *not* yet backported
to 3.14.8:

"Btrfs: fix leaf corruption caused by ENOSPC while hole punching"
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/btrfs?id=fc19c5e73645f95d3eca12b4e91e7b56faf1e4a4

The symptoms described in the patch sound like they might be your OOPS.
Unfortunately (I think) that would mean that just installing different
kernels will not fix the problem, since the problem is on disk. :/

So to me it seems your best course of action is to backup/mkfs/restore
the affected partition and stick with 3.17-rc3, since that has tons
more fixes.

If you really need/want 3.14.x and are not afraid of building your
own kernel, you can try applying my btrfs-* patches from:
https://github.com/hhoffstaette/kernel-patches/tree/master/3.14
which apply cleanly to the latest 3.14.18-stable.

However even that will not fix a bungled tree on disk.

-h

