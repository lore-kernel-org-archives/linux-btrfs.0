Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57409 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaDNBni (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 21:43:38 -0400
Date: Sun, 13 Apr 2014 18:43:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: very slow btrfs filesystem: any data needed before I wipe it?
Message-ID: <20140414014337.GD7322@merlins.org>
References: <20140407160506.GG10789@merlins.org> <5342CE0C.3070707@fb.com> <20140407185121.GI10222@merlins.org> <5342FD3D.3090905@fb.com> <20140407200002.GL1809@merlins.org> <20140409173842.GT10789@merlins.org> <20140325014956.GG11533@merlins.org> <20140412202542.GW7322@merlins.org> <pan$618bb$88ff516$fa62072a$7143669d@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$618bb$88ff516$fa62072a$7143669d@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 13, 2014 at 04:02:36AM +0000, Duncan wrote:
> What happens if you simply mount it ro, without the recovery option?  Is 
> it still normal-speed or is that slow as a rw mount?

I just tried in ro without recovery, and I could copy data out at 52MB/s
for a big file, so that's quite good.

As soon as I mount it r/w, then everything goes to crap, even before I start
using it.
So from what I'm seeing, some structures are messed up, btrfs then goes into
some almost infinite loops to fix them if the filesystem is in writeable
mode.

I just tried to mount it and umount it, but I couldn't even unmount it.

I'll wait until tomorrow night to see if the devs want anything else out of
it, but otherwise I'll wipe it and start over.
 
> Speed hasn't been an issue here, but FWIW I normally keep my rootfs ro 
> mounted as I decided that's lower risk in the event of a system crash or 
> power outage and I don't actually /need/ it rw most of the time (I have a 

I'm all with you here, but that's not very practical on an array that is
only there to _receive_ backups from other systems :)

So, I made the FS read-write, I was still able to copy big files at 50MB/s,
and then did:
gargamel:/mnt/btrfs_pool2/backup/polgara# time cp -al ../legolas/current/ .
(copying a full system with many small files)

Within, minutes I got:
[114821.950649] INFO: task btrfs-cleaner:14442 blocked for more than 120 seconds.
[114821.984252]       Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[114822.007214] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[114822.035962] btrfs-cleaner   D ffff88009ea74640     0 14442      2 0x00000080
[114822.061879]  ffff880046bd7d00 0000000000000046 ffff880046bd7fd8 ffff88009ea74110
[114822.088179]  00000000000141c0 ffff88009ea74110 ffff88019f812350 ffff8801dafaa9e8
[114822.114363]  0000000000000000 ffff8801dafaa800 ffff8801bb957460 ffff880046bd7d10
[114822.140443] Call Trace:
[114822.151120]  [<ffffffff8160d2a1>] schedule+0x73/0x75
[114822.169217]  [<ffffffff8122aa77>] wait_current_trans.isra.15+0x98/0xf4
[114822.192089]  [<ffffffff81085116>] ? finish_wait+0x65/0x65
[114822.211381]  [<ffffffff8122bf1c>] start_transaction+0x48e/0x4f2
[114822.232292]  [<ffffffff8122c2ff>] ? __btrfs_end_transaction+0x2a1/0x2c6
[114822.255258]  [<ffffffff8122bf9b>] btrfs_start_transaction+0x1b/0x1d
[114822.277115]  [<ffffffff8121cc7d>] btrfs_drop_snapshot+0x443/0x610
[114822.298422]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
[114822.323108]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
[114822.343280]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
[114822.363587]  [<ffffffff8106bc62>] kthread+0xae/0xb6
[114822.381042]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[114822.401319]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
[114822.420054]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[114822.440419] INFO: task cp:23902 blocked for more than 120 seconds.
[114822.461583]       Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[114822.482967] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[114822.509029] cp              D ffff88009e782800     0 23902  19922 0x20020080
[114822.532913]  ffff8802081f7d98 0000000000000082 ffff8802081f7fd8 ffff88009e7822d0
[114822.558306]  00000000000141c0 ffff88009e7822d0 ffff88019f812350 ffff8801d08f81e8
[114822.583381]  0000000000000000 ffff8801d08f8000 ffff880160b29640 ffff8802081f7da8
[114822.608434] Call Trace:
[114822.618046]  [<ffffffff8160d2a1>] schedule+0x73/0x75
[114822.635275]  [<ffffffff8122aa77>] wait_current_trans.isra.15+0x98/0xf4
[114822.657098]  [<ffffffff81085116>] ? finish_wait+0x65/0x65
[114822.675586]  [<ffffffff8122bf1c>] start_transaction+0x48e/0x4f2
[114822.695525]  [<ffffffff8122bf9b>] btrfs_start_transaction+0x1b/0x1d
[114822.716469]  [<ffffffff812364cc>] btrfs_link+0x74/0x18e
[114822.734272]  [<ffffffff811607db>] vfs_link+0x101/0x1a5
[114822.751830]  [<ffffffff811627a7>] SYSC_linkat+0x171/0x213
[114822.770100]  [<ffffffff81162ad4>] SyS_linkat+0xe/0x10
[114822.787314]  [<ffffffff8161812c>] sysenter_dispatch+0x7/0x21

After that, it took a long time for the ^C of my cp to work.
Actually, ^C just didn't work at all, and kill -9 didn't work either.

cp is stuck in kernel state:
23902    01:05:47 wait_current_trans.isra.15     cp -i -al ../legolas/current/ .

I was forced to reboot.
And then as soon as I reboot and mount that partition read/write, I get:

[  485.375223] INFO: task btrfs-cleaner:3552 blocked for more than 120 seconds.
[  485.396430]       Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[  485.415282] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  485.438832] btrfs-cleaner   D ffff880211d2eb80     0  3552      2 0x00000000
[  485.460134]  ffff8800c7f0fd00 0000000000000046 ffff8800c7f0ffd8 ffff880211d2e650
[  485.482503]  00000000000141c0 ffff880211d2e650 ffff88020cea6130 ffff880213fda1e8
[  485.504934]  0000000000000000 ffff880213fda000 ffff88020cfb2a60 ffff8800c7f0fd10
[  485.527342] Call Trace:
[  485.534706]  [<ffffffff8160d2a1>] schedule+0x73/0x75
[  485.549628]  [<ffffffff8122aa77>] wait_current_trans.isra.15+0x98/0xf4
[  485.569235]  [<ffffffff81085116>] ? finish_wait+0x65/0x65
[  485.585458]  [<ffffffff8122bf1c>] start_transaction+0x48e/0x4f2
[  485.603237]  [<ffffffff8122c2ff>] ? __btrfs_end_transaction+0x2a1/0x2c6
[  485.623096]  [<ffffffff8122bf9b>] btrfs_start_transaction+0x1b/0x1d
[  485.641932]  [<ffffffff8121cc7d>] btrfs_drop_snapshot+0x443/0x610
[  485.660256]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
[  485.681961]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
[  485.699226]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
[  485.716746]  [<ffffffff8106bc62>] kthread+0xae/0xb6
[  485.731410]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[  485.748927]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
[  485.765147]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61

This is with 0 file IO to it.
Turns out even umount of that filesystem hangs.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
