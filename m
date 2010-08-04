From: Simon Kirby <sim@hostway.ca>
Subject: Re: Intermittent no space errors
Date: Tue, 3 Aug 2010 17:24:15 -0700
Message-ID: <20100804002415.GA23720@hostway.ca>
References: <AANLkTik_Dbk7cyS6FR0G9r-MFYq1bCCmbJ-HyHKgpUBr@mail.gmail.com> <AANLkTimVKtyPHi3zadx66i0dbPKzF4CbGJT=OEukLM6R@mail.gmail.com> <AANLkTimir3SMbevD_PCXOUQgda-3BkiAE01cYcAMz_BR@mail.gmail.com> <AANLkTikP_q7zhA2J69Rai964StGtMqCrhf2hGKPA9+J7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikP_q7zhA2J69Rai964StGtMqCrhf2hGKPA9+J7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 28, 2010 at 08:31:10AM +0800, Yan, Zheng  wrote:

> On Wed, Jul 28, 2010 at 4:30 AM, Dave Cundiff <syshackmin@gmail.com> wrote:
> > Hello,
> >
> > I installed the git repo kernel and added some debug to the ENOSPC
> > returns. Unfortunately its still failing. If it helps any its bombing
> > out in btrfs_check_data_free_space() in extent-tree.c. Returning on
> > the ENOSPC at line 2959.
> >
> > Unfortunately that is the extent of my ability to debug a filesystem. :P
> 
> This is really helpful, thank you very much.

We're seeing this too, since upgrading from 2.6.33.2 + merged old git btrfs
unstable HEAD to plain 2.6.35.

[sroot@backup01:.../.rmagic]# rm *
rm: cannot remove `WEEKLY_bar3d.png': No space left on device
rm: cannot remove `WEEKLY.html': No space left on device
rm: cannot remove `YEARLY_bar3d.png': No space left on device
rm: cannot remove `YEARLY.html': No space left on device
[sroot@backup01:.../.rmagic]# l
total 25
drwxr-xr-x 1 1037300 1037300   108 2010-08-03 18:19 ./
drwxr-xr-x 1 1037300 1037300    28 2009-11-07 05:57 ../
-rw-r--r-- 1 1037300 1037300  5720 2010-04-23 13:39 WEEKLY_bar3d.png
-rw-r--r-- 1 1037300 1037300 11882 2010-04-23 13:39 WEEKLY.html
-rw-r--r-- 1 1037300 1037300  2998 2010-04-23 13:39 YEARLY_bar3d.png
-rw-r--r-- 1 1037300 1037300  3016 2010-04-23 13:39 YEARLY.html
[sroot@backup01:.../.rmagic]# rm *
rm: cannot remove `WEEKLY_bar3d.png': No space left on device
rm: cannot remove `YEARLY.html': No space left on device
[sroot@backup01:.../.rmagic]# rm *
rm: cannot remove `WEEKLY_bar3d.png': No space left on device
rm: cannot remove `YEARLY.html': No space left on device
[sroot@backup01:.../.rmagic]# rm *
[sroot@backup01:.../.rmagic]#

[sroot@backup01:/root]# btrfs filesystem df /backup/bu001/vol04
Data: total=2.55TB, used=2.20TB
Metadata: total=230.13GB, used=183.83GB
System: total=12.00MB, used=548.00KB
[sroot@backup01:/root]# df -P /backup/bu001/vol04
Filesystem         1024-blocks      Used Available Capacity Mounted on
/dev/mapper/bu001-vol04 3221225472 2742785400 478440072      86% /backup/bu001/vol04
[sroot@backup01:/root]# l /dev/mapper/bu001-vol04
brw-rw---- 1 root disk 252, 10 2010-08-03 16:02 /dev/mapper/bu001-vol04
[sroot@backup01:/root]# btrfs filesystem show /dev/dm-10
failed to read /dev/sr0
Label: none  uuid: 0c55f5f4-b618-4ec2-9dbc-e3e70a901e1a
        Total devices 1 FS bytes used 2.37TB
        devid    1 size 3.00TB used 3.00TB path /dev/dm-10

Btrfs Btrfs v0.19

We're also seeing things like this in dmesg, which appear to be coming
from btrfs-cleaner cleaning some old snapshot:

Aug  3 18:40:45 backup01 kernel: ------------[ cut here ]------------
Aug  3 18:40:45 backup01 kernel: WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x151/0x180()
Aug  3 18:40:45 backup01 kernel: Hardware name: PowerEdge 1950
Aug  3 18:40:45 backup01 kernel: Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2
Aug  3 18:40:45 backup01 kernel: Pid: 7525, comm: btrfs-cleaner Tainted: G        W   2.6.35-hw #1
Aug  3 18:40:45 backup01 kernel: Call Trace:
Aug  3 18:40:45 backup01 kernel: [<ffffffff812c56a1>] ? btrfs_block_rsv_check+0x151/0x180
Aug  3 18:40:45 backup01 kernel: [<ffffffff8104b270>] warn_slowpath_common+0x80/0xd0
Aug  3 18:40:45 backup01 kernel: [<ffffffff8104b2d5>] warn_slowpath_null+0x15/0x20
Aug  3 18:40:45 backup01 kernel: [<ffffffff812c56a1>] btrfs_block_rsv_check+0x151/0x180
Aug  3 18:40:45 backup01 kernel: [<ffffffff812d5ea1>] btrfs_should_end_transaction+0x61/0x90
Aug  3 18:40:45 backup01 kernel: [<ffffffff812c842d>] btrfs_drop_snapshot+0x21d/0x5f0
Aug  3 18:40:45 backup01 kernel: [<ffffffff81662d72>] ? schedule+0x3f2/0x750
Aug  3 18:40:45 backup01 kernel: [<ffffffff812d463a>] btrfs_clean_old_snapshots+0x12a/0x160
Aug  3 18:40:45 backup01 kernel: [<ffffffff812d0f00>] cleaner_kthread+0x160/0x190
Aug  3 18:40:45 backup01 kernel: [<ffffffff812d0da0>] ? cleaner_kthread+0x0/0x190
Aug  3 18:40:45 backup01 kernel: [<ffffffff81067ea6>] kthread+0x96/0xb0
Aug  3 18:40:45 backup01 kernel: [<ffffffff8100aca4>] kernel_thread_helper+0x4/0x10
Aug  3 18:40:45 backup01 kernel: [<ffffffff81067e10>] ? kthread+0x0/0xb0
Aug  3 18:40:45 backup01 kernel: [<ffffffff8100aca0>] ? kernel_thread_helper+0x0/0x10
Aug  3 18:40:45 backup01 kernel: ---[ end trace cffc4418e2c1f45d ]---
Aug  3 18:40:45 backup01 kernel: block_rsv size 16194207744 reserved 4497289216 freed 0 78598144
Aug  3 18:40:45 backup01 kernel: ------------[ cut here ]------------
Aug  3 18:40:45 backup01 kernel: WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x151/0x180()
Aug  3 18:40:45 backup01 kernel: Hardware name: PowerEdge 1950
Aug  3 18:40:45 backup01 kernel: Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2
Aug  3 18:40:45 backup01 kernel: Pid: 7525, comm: btrfs-cleaner Tainted: G        W   2.6.35-hw #1
Aug  3 18:40:45 backup01 kernel: Call Trace:
Aug  3 18:40:45 backup01 kernel: [<ffffffff812f2eb0>] ? map_extent_buffer+0xb0/0xc0
Aug  3 18:40:45 backup01 kernel: [<ffffffff812c56a1>] ? btrfs_block_rsv_check+0x151/0x180
Aug  3 18:40:45 backup01 kernel: [<ffffffff8104b270>] warn_slowpath_common+0x80/0xd0
Aug  3 18:40:45 backup01 kernel: [<ffffffff8104b2d5>] warn_slowpath_null+0x15/0x20
Aug  3 18:40:45 backup01 kernel: [<ffffffff812c56a1>] btrfs_block_rsv_check+0x151/0x180
Aug  3 18:40:45 backup01 kernel: [<ffffffff812d56fa>] __btrfs_end_transaction+0x19a/0x220
Aug  3 18:40:45 backup01 kernel: [<ffffffff812d578e>] btrfs_end_transaction_throttle+0xe/0x10
Aug  3 18:40:45 backup01 kernel: [<ffffffff812c84f1>] btrfs_drop_snapshot+0x2e1/0x5f0
Aug  3 18:40:45 backup01 kernel: [<ffffffff81662d72>] ? schedule+0x3f2/0x750
Aug  3 18:40:45 backup01 kernel: [<ffffffff812d463a>] btrfs_clean_old_snapshots+0x12a/0x160
Aug  3 18:40:45 backup01 kernel: [<ffffffff812d0f00>] cleaner_kthread+0x160/0x190
Aug  3 18:40:45 backup01 kernel: [<ffffffff812d0da0>] ? cleaner_kthread+0x0/0x190
Aug  3 18:40:45 backup01 kernel: [<ffffffff81067ea6>] kthread+0x96/0xb0
Aug  3 18:40:45 backup01 kernel: [<ffffffff8100aca4>] kernel_thread_helper+0x4/0x10
Aug  3 18:40:45 backup01 kernel: [<ffffffff81067e10>] ? kthread+0x0/0xb0
Aug  3 18:40:45 backup01 kernel: [<ffffffff8100aca0>] ? kernel_thread_helper+0x0/0x10
Aug  3 18:40:45 backup01 kernel: ---[ end trace cffc4418e2c1f45e ]---
Aug  3 18:40:45 backup01 kernel: block_rsv size 16194207744 reserved 4497281024 freed 8192 78598144
Aug  3 18:44:44 backup01 kernel: ------------[ cut here ]------------
Aug  3 18:44:44 backup01 kernel: WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x151/0x180()
Aug  3 18:44:44 backup01 kernel: Hardware name: PowerEdge 1950
Aug  3 18:44:44 backup01 kernel: Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2
Aug  3 18:44:44 backup01 kernel: Pid: 7526, comm: btrfs-transacti Tainted: G        W   2.6.35-hw #1
Aug  3 18:44:44 backup01 kernel: Call Trace:
Aug  3 18:44:44 backup01 kernel: [<ffffffff812c56a1>] ? btrfs_block_rsv_check+0x151/0x180
Aug  3 18:44:44 backup01 kernel: [<ffffffff8104b270>] warn_slowpath_common+0x80/0xd0
Aug  3 18:44:44 backup01 kernel: [<ffffffff8104b2d5>] warn_slowpath_null+0x15/0x20
Aug  3 18:44:44 backup01 kernel: [<ffffffff812c56a1>] btrfs_block_rsv_check+0x151/0x180
Aug  3 18:44:44 backup01 kernel: [<ffffffff812d56fa>] __btrfs_end_transaction+0x19a/0x220
Aug  3 18:44:44 backup01 kernel: [<ffffffff812d579b>] btrfs_end_transaction+0xb/0x10
Aug  3 18:44:44 backup01 kernel: [<ffffffff812d5d63>] btrfs_commit_transaction+0x5c3/0x6a0
Aug  3 18:44:44 backup01 kernel: [<ffffffff810683e0>] ? autoremove_wake_function+0x0/0x40
Aug  3 18:44:44 backup01 kernel: [<ffffffff812d0d90>] transaction_kthread+0x250/0x260
Aug  3 18:44:44 backup01 kernel: [<ffffffff812d0b40>] ? transaction_kthread+0x0/0x260
Aug  3 18:44:44 backup01 kernel: [<ffffffff81067ea6>] kthread+0x96/0xb0
Aug  3 18:44:44 backup01 kernel: [<ffffffff8100aca4>] kernel_thread_helper+0x4/0x10
Aug  3 18:44:44 backup01 kernel: [<ffffffff81067e10>] ? kthread+0x0/0xb0
Aug  3 18:44:44 backup01 kernel: [<ffffffff8100aca0>] ? kernel_thread_helper+0x0/0x10
Aug  3 18:44:44 backup01 kernel: ---[ end trace cffc4418e2c1f45f ]---
Aug  3 18:44:44 backup01 kernel: block_rsv size 16194207744 reserved 4522696704 freed 53190656 0

I rebuilt with the #if 0 changed to #if 1 on extent-tree.c:2947:

#if 1 /* I hope we never need this code again, just in case */

ha! :)  "rm" is succeeding everywhere so far, and so this path hasn't
been hit yet.  Perhaps it has to fight with the btrfs-cleaner, or
something.  Will post a follow-up later.

Simon-
