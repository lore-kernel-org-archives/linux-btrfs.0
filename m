From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
Date: Fri, 16 Jul 2010 16:59:46 +0200
Message-ID: <201007161659.48663.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <20100715001104.GF30737@dastard> <201007152014.52924.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, zheng.yan@oracle.com,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201007152014.52924.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 15 Juli 2010, 20:14:51 schrieb Johannes Hirte:
> Am Donnerstag 15 Juli 2010, 02:11:04 schrieb Dave Chinner:
> > On Wed, Jul 14, 2010 at 05:25:23PM +0200, Johannes Hirte wrote:
> > > Am Donnerstag 08 Juli 2010, 16:31:09 schrieb Chris Mason:
> > > I'm not sure if btrfs is to blame for this error. After the errors I
> > > switched to XFS on this system and got now this error:
> > > 
> > > ls -l .kde4/share/apps/akregator/data/
> > > ls: cannot access .kde4/share/apps/akregator/data/feeds.opml: Structure
> > > needs cleaning
> > > total 4
> > > ?????????? ? ?    ?        ?            ? feeds.opml
> > 
> > What is the error reported in dmesg when the XFS filesytem shuts down?
> 
> Nothing. I double checked the logs. There are only the messages when
> mounting the filesystem. No other errors are reported than the
> inaccessible file and the output from xfs_check.

I'm running now a kernel with more debug options enabled and got this:

[ 6794.810935] 
[ 6794.810941] =================================
[ 6794.810955] [ INFO: inconsistent lock state ]
[ 6794.810966] 2.6.35-rc4-btrfs-debug #7
[ 6794.810975] ---------------------------------
[ 6794.810984] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 6794.810996] kswapd0/361 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 6794.811006]  (&(&ip->i_iolock)->mr_lock#2){++++?+}, at: [<c10fa82d>] 
xfs_ilock+0x22/0x67
[ 6794.811039] {RECLAIM_FS-ON-W} state was registered at:
[ 6794.811046]   [<c104ebc1>] mark_held_locks+0x42/0x5e
[ 6794.811046]   [<c104f1f7>] lockdep_trace_alloc+0x99/0xb0
[ 6794.811046]   [<c10740b8>] __alloc_pages_nodemask+0x6a/0x4a1
[ 6794.811046]   [<c106edc2>] __page_cache_alloc+0x11/0x13
[ 6794.811046]   [<c106fb43>] grab_cache_page_write_begin+0x47/0x81
[ 6794.811046]   [<c10b2050>] block_write_begin_newtrunc+0x2e/0x9c
[ 6794.811046]   [<c10b233a>] block_write_begin+0x23/0x5d
[ 6794.811046]   [<c1114a9d>] xfs_vm_write_begin+0x26/0x28
[ 6794.811046]   [<c106f15d>] generic_file_buffered_write+0xb5/0x1bd
[ 6794.811046]   [<c1117e31>] xfs_file_aio_write+0x40e/0x66d
[ 6794.811046]   [<c10950b4>] do_sync_write+0x8b/0xc6
[ 6794.811046]   [<c109568b>] vfs_write+0x77/0xa4
[ 6794.811046]   [<c10957f3>] sys_write+0x3c/0x5e
[ 6794.811046]   [<c1002690>] sysenter_do_call+0x12/0x36
[ 6794.811046] irq event stamp: 141369
[ 6794.811046] hardirqs last  enabled at (141369): [<c13639d2>] 
_raw_spin_unlock_irqrestore+0x36/0x5b
[ 6794.811046] hardirqs last disabled at (141368): [<c13634c5>] 
_raw_spin_lock_irqsave+0x14/0x68
[ 6794.811046] softirqs last  enabled at (141300): [<c1032d69>] 
__do_softirq+0xfe/0x10d
[ 6794.811046] softirqs last disabled at (141295): [<c1032da7>] 
do_softirq+0x2f/0x47
[ 6794.811046] 
[ 6794.811046] other info that might help us debug this:
[ 6794.811046] 2 locks held by kswapd0/361:
[ 6794.811046]  #0:  (shrinker_rwsem){++++..}, at: [<c10774db>] 
shrink_slab+0x25/0x13f
[ 6794.811046]  #1:  (&xfs_mount_list_lock){++++.-}, at: [<c111cc78>] 
xfs_reclaim_inode_shrink+0x2a/0xe8
[ 6794.811046] 
[ 6794.811046] stack backtrace:
[ 6794.811046] Pid: 361, comm: kswapd0 Not tainted 2.6.35-rc4-btrfs-debug #7
[ 6794.811046] Call Trace:
[ 6794.811046]  [<c13616c0>] ? printk+0xf/0x17
[ 6794.811046]  [<c104e988>] valid_state+0x134/0x142
[ 6794.811046]  [<c104ea66>] mark_lock+0xd0/0x1e9
[ 6794.811046]  [<c104e2a7>] ? check_usage_forwards+0x0/0x5f
[ 6794.811046]  [<c105003d>] __lock_acquire+0x374/0xc80
[ 6794.811046]  [<c1044942>] ? sched_clock_local+0x12/0x121
[ 6794.811046]  [<c1044c0b>] ? sched_clock_cpu+0x122/0x133
[ 6794.811046]  [<c1050d4d>] lock_acquire+0x5f/0x76
[ 6794.811046]  [<c10fa82d>] ? xfs_ilock+0x22/0x67
[ 6794.811046]  [<c1043974>] down_write_nested+0x32/0x63
[ 6794.811046]  [<c10fa82d>] ? xfs_ilock+0x22/0x67
[ 6794.811046]  [<c10fa82d>] xfs_ilock+0x22/0x67
[ 6794.811046]  [<c10faa48>] xfs_ireclaim+0x98/0xbb
[ 6794.811046]  [<c1043a1e>] ? up_write+0x16/0x2b
[ 6794.811046]  [<c111c78c>] xfs_reclaim_inode+0x1a7/0x1b1
[ 6794.811046]  [<c111cafe>] xfs_inode_ag_walk+0x77/0xbc
[ 6794.811046]  [<c111c5e5>] ? xfs_reclaim_inode+0x0/0x1b1
[ 6794.811046]  [<c111cc07>] xfs_inode_ag_iterator+0x52/0x99
[ 6794.811046]  [<c111cc78>] ? xfs_reclaim_inode_shrink+0x2a/0xe8
[ 6794.811046]  [<c111c5e5>] ? xfs_reclaim_inode+0x0/0x1b1
[ 6794.811046]  [<c111cc99>] xfs_reclaim_inode_shrink+0x4b/0xe8
[ 6794.811046]  [<c1077588>] shrink_slab+0xd2/0x13f
[ 6794.811046]  [<c1078cef>] kswapd+0x37d/0x4e9
[ 6794.811046]  [<c104028f>] ? autoremove_wake_function+0x0/0x2f
[ 6794.811046]  [<c1078972>] ? kswapd+0x0/0x4e9
[ 6794.811046]  [<c103ffbc>] kthread+0x60/0x65
[ 6794.811046]  [<c103ff5c>] ? kthread+0x0/0x65
[ 6794.811046]  [<c1002bba>] kernel_thread_helper+0x6/0x10

Don't know if this is related to the problem.


regards,
  Johannes
