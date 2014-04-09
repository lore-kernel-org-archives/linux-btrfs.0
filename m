Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40710 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbaDIRin (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 13:38:43 -0400
Date: Wed, 9 Apr 2014 10:38:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs on 3.14rc5 stuck on "btrfs_tree_read_lock           sync"
Message-ID: <20140409173842.GT10789@merlins.org>
References: <20140407160506.GG10789@merlins.org> <5342CE0C.3070707@fb.com> <20140407185121.GI10222@merlins.org> <5342FD3D.3090905@fb.com> <20140407200002.GL1809@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140407200002.GL1809@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 07, 2014 at 01:00:02PM -0700, Marc MERLIN wrote:
> On Mon, Apr 07, 2014 at 03:32:13PM -0400, Chris Mason wrote:
> > >You're recommending that I try btrfs-next on a 3.15 pre kernel, correct?
> > >If so would it be likely to fix my filesystem and let me go back to a
> > >stable 3.14? (I'm a bit warry about running some unstable 3.15 on it :).
> > 
> > Right now the fixes for this are in the integration branch on my git 
> > tree.  I think we've shaken  out all the problems, but if you want to 
> > wait until tomorrow I'll have it in my next branch (for linux-next).
> 
> I can wait, even a few more days if needed.
> But just to be clear: will this new kernel be something that will be
> required for me to run from there on to avoid all those deadlocks and very
> poor performance I'm seeing, or the new kernel will fix things up, and then
> if other stuff isn't quite stable, I can downgrade back to 3.14 stable?
> 
> By the way, I think I know which filesystem is causing this, and one unusual
> thing is that it uses a lot of hardlinks.
> 
> In case that helps, there are only 40 snapshots on it, but many inodes, of
> which many are hardlinked together:
> 
> gargamel:/mnt/btrfs_pool2# btrfs filesystem df `pwd`
> Data, single: total=3.28TiB, used=2.30TiB
> System, DUP: total=8.00MiB, used=384.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=74.50GiB, used=70.11GiB
> Metadata, single: total=8.00MiB, used=0.00
> gargamel:/mnt/btrfs_pool2# btrfs filesystem show `pwd`
> Label: btrfs_pool2  uuid: cb9df6d3-a528-4afc-9a45-4fed5ec358d6
> 	Total devices 1 FS bytes used 2.37TiB
> 	devid    1 size 7.28TiB used 3.43TiB path /dev/mapper/dshelf2

Back on that front, while debugging the other problem I sent you, I've been
having more issues with this device too.

At boot time, I've been getting multiple of these after boot:
gargamel login: [ 1328.241302] INFO: task btrfs-cleaner:3571 blocked for more than 120 seconds.
[ 1328.264046]       Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[ 1328.284413] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1328.309394] btrfs-cleaner   D ffff88020d5ea800     0  3571      2 0x00000000
[ 1328.331996]  ffff8800c8985d00 0000000000000046 ffff8800c8985fd8 ffff88020d5ea2d0
[ 1328.355774]  00000000000141c0 ffff88020d5ea2d0 ffff8801d9a7ee50 ffff880213bfc9e8
[ 1328.379408]  0000000000000000 ffff880213bfc800 ffff88020c5b7ce0 ffff8800c8985d10
[ 1328.403654] Call Trace:
[ 1328.412617]  [<ffffffff8160d2a1>] schedule+0x73/0x75
[ 1328.429189]  [<ffffffff8122aa77>] wait_current_trans.isra.15+0x98/0xf4
[ 1328.450402]  [<ffffffff81085116>] ? finish_wait+0x65/0x65
[ 1328.467957]  [<ffffffff8122bf1c>] start_transaction+0x48e/0x4f2
[ 1328.487315]  [<ffffffff8122c2ff>] ? __btrfs_end_transaction+0x2a1/0x2c6
[ 1328.508614]  [<ffffffff8122bf9b>] btrfs_start_transaction+0x1b/0x1d
[ 1328.528842]  [<ffffffff8121cc7d>] btrfs_drop_snapshot+0x443/0x610
[ 1328.548481]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
[ 1328.571518]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
[ 1328.590436]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
[ 1328.609348]  [<ffffffff8106bc62>] kthread+0xae/0xb6
[ 1328.625275]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[ 1328.644406]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
[ 1328.662075]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61

But more annoyingly, accessing the mountpoint was hanging, so I've now mounted
it with recovery,ro, and backing up all the data to another device so that I
can destroy/recreate this device that clearly has severe performance issues.

Do you want btrfsck output and an image of that one too?
(this one is not raid0, it's on top of an dm encrypted md raid5 array)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
