Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45069 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbaDLUZo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Apr 2014 16:25:44 -0400
Date: Sat, 12 Apr 2014 13:25:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Subject: Re: very slow btrfs filesystem: any data needed before I wipe it?
Message-ID: <20140412202542.GW7322@merlins.org>
References: <20140407160506.GG10789@merlins.org> <5342CE0C.3070707@fb.com> <20140407185121.GI10222@merlins.org> <5342FD3D.3090905@fb.com> <20140407200002.GL1809@merlins.org> <20140409173842.GT10789@merlins.org> <20140325014956.GG11533@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140409173842.GT10789@merlins.org> <20140325014956.GG11533@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've posted about this before, and I'm about to delete and recreate the
filesystem.
I took an image, but the image is 18GB, so not very convenient to give
around, although I can if needed.

As a reminder, the problems are that everything is super slow, including
btrfs's own background processes that hang and create tracebacks.
(initially I complained about rm, but it's just everything that is slow).

If I mount with ro,recovery, then it's actually normal speed to copy data
off it, quite weird. It seems like btrfs' background processes are grinding
the FS down to a halt, and I didn't turn on autodefrag.

I haven't gotten confirmation that this a known problem that has been
root-caused, so I'm a bit hesitant about wiping the filesystem before 
getting potentially useful debug data off it, but honestly I'm not sure what
to take.

(I have a btrfsck running, looks like it may take over an hour, so I'll post
that after it's finished)

Other suggestions welcome.

Thanks,
Marc

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
> At boot time, I've been getting multiple of these after boot:
> gargamel login: [ 1328.241302] INFO: task btrfs-cleaner:3571 blocked for more than 120 seconds.
> [ 1328.264046]       Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
> [ 1328.284413] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1328.309394] btrfs-cleaner   D ffff88020d5ea800     0  3571      2 0x00000000
> [ 1328.331996]  ffff8800c8985d00 0000000000000046 ffff8800c8985fd8 ffff88020d5ea2d0
> [ 1328.355774]  00000000000141c0 ffff88020d5ea2d0 ffff8801d9a7ee50 ffff880213bfc9e8
> [ 1328.379408]  0000000000000000 ffff880213bfc800 ffff88020c5b7ce0 ffff8800c8985d10
> [ 1328.403654] Call Trace:
> [ 1328.412617]  [<ffffffff8160d2a1>] schedule+0x73/0x75
> [ 1328.429189]  [<ffffffff8122aa77>] wait_current_trans.isra.15+0x98/0xf4
> [ 1328.450402]  [<ffffffff81085116>] ? finish_wait+0x65/0x65
> [ 1328.467957]  [<ffffffff8122bf1c>] start_transaction+0x48e/0x4f2
> [ 1328.487315]  [<ffffffff8122c2ff>] ? __btrfs_end_transaction+0x2a1/0x2c6
> [ 1328.508614]  [<ffffffff8122bf9b>] btrfs_start_transaction+0x1b/0x1d
> [ 1328.528842]  [<ffffffff8121cc7d>] btrfs_drop_snapshot+0x443/0x610
> [ 1328.548481]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
> [ 1328.571518]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
> [ 1328.590436]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
> [ 1328.609348]  [<ffffffff8106bc62>] kthread+0xae/0xb6
> [ 1328.625275]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
> [ 1328.644406]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
> [ 1328.662075]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
