Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46451 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaDNCP1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 22:15:27 -0400
Date: Mon, 14 Apr 2014 10:15:07 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to debug very very slow file delete?
Message-ID: <20140414021506.GA2159@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20140325014956.GG11533@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140325014956.GG11533@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 24, 2014 at 06:49:56PM -0700, Marc MERLIN wrote:
> I had a tree with some amount of thousand files (less than 1 million)
> on top of md raid5.
> 
> It took 18H to rm it in 3 tries:
> gargamel:/mnt/dshelf2/backup/polgara# time rm -rf current.todel/
> real    1087m26.491s
> user    0m2.448s
> sys     4m42.012s
> 
> gargamel:/mnt/dshelf2/backup/polgara# btrfs fi show /mnt/btrfs_pool2
> Label: btrfs_pool2  uuid: cb9df6d3-a528-4afc-9a45-4fed5ec358d6
>         Total devices 1 FS bytes used 2.76TiB
>         devid    1 size 7.28TiB used 3.43TiB path /dev/mapper/dshelf2
> 
> gargamel:/mnt/dshelf2/backup/polgara# btrfs fi df /mnt/btrfs_pool2
> Data, single: total=3.28TiB, used=2.70TiB
> System, DUP: total=8.00MiB, used=384.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=73.50GiB, used=62.46GiB
> Metadata, single: total=8.00MiB, used=0.00
> 
> This is running from
> md8 : active raid5 sdf1[6] sdb1[5] sda1[3] sde1[2] sdd1[1]
>       7814045696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
>       bitmap: 0/15 pages [0KB], 65536KB chunk
> 
> The filesystem is pretty new, it shouldn't be fragmented much.
> 
> dmesg shows a bit of this:
> INFO: task rm:31885 blocked for more than 120 seconds.
>       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message
> rm              D ffff880117e5a940     0 31885  31280 0x20020080
>  ffff8800169f3d10 0000000000000086 ffff8800169f3fd8 ffff880117e5a410
>  00000000000141c0 ffff880117e5a410 ffff88011d4f9e90 ffff88020c0109e8
>  0000000000000000 ffff88020c010800 ffff8801b6df55a0 ffff8800169f3d20
> Call Trace:
>  [<ffffffff8160c331>] schedule+0x73/0x75
>  [<ffffffff8122a5f9>] wait_current_trans.isra.15+0x98/0xf4
>  [<ffffffff810850c9>] ? finish_wait+0x65/0x65
>  [<ffffffff8122ba9e>] start_transaction+0x48e/0x4f2
>  [<ffffffff8122bb1d>] btrfs_start_transaction+0x1b/0x1d
>  [<ffffffff8122cab4>] __unlink_start_trans+0x24/0xaf
>  [<ffffffff812327ab>] btrfs_unlink+0x28/0xa0
>  [<ffffffff8116176d>] vfs_unlink+0x90/0xdb
>  [<ffffffff811618c0>] do_unlinkat+0x108/0x1da
>  [<ffffffff810734c8>] ? mmdrop+0x11/0x20
>  [<ffffffff8115d2db>] ? path_put+0x1e/0x21
>  [<ffffffff811625c7>] SyS_unlinkat+0x22/0x2e
>  [<ffffffff816171ac>] sysenter_dispatch+0x7/0x21
> 
> That said, it didn't happen much:
> [38077.054841] INFO: task btrfs-cleaner:3536 blocked for more than 120 seconds.
> [38077.521463] INFO: task rm:31885 blocked for more than 120 seconds.
> [38077.926399] INFO: task cp:26645 blocked for more than 120 seconds.
> [38078.346885] INFO: task btrfs:7430 blocked for more than 120 seconds.
> [38198.921768] INFO: task btrfs-cleaner:3536 blocked for more than 120 seconds.
> [38199.357367] INFO: task rm:31885 blocked for more than 120 seconds.
> [38199.753897] INFO: task cp:26645 blocked for more than 120 seconds.
> [38200.172729] INFO: task btrfs:7430 blocked for more than 120 seconds.
> [56696.271850] INFO: task btrfs-transacti:3537 blocked for more than 120 seconds.
> [56937.063142] INFO: task btrfs-cleaner:3536 blocked for more than 120 seconds.
> 
> Of course, all of those are bad, but I'm unfortunately used to seeing them
> It wasn't hanging forever every few minutes, so it looks like it was just working 
> very slowly.
> 
> The problem does not seem to be just rm though, du is taking way way too
> long too. I started one, it's been running for 30mn now.
> Interestingly, sending ^C to that du takes 15 seconds to respond, so it
> seems that each system call is just slow.
> 
> I checked that btrfs scrub is not running.
> What else can I check from here?

Maybe 'sysrq+w' can give an answer?  We need to find what blocks new transaction.

-liubo
