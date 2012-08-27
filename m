Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:50143 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab2H0WFi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 18:05:38 -0400
Date: Mon, 27 Aug 2012 15:05:37 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: Josef Bacik <jbacik@fusionio.com>
cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: pass lockdep rwsem metadata to async commit
 transaction
In-Reply-To: <20120826211349.GA2305@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1208271446580.26910@cobra.newdream.net>
References: <alpine.DEB.2.00.1208241439490.26910@cobra.newdream.net> <alpine.DEB.2.00.1208241545040.26910@cobra.newdream.net> <20120826211349.GA2305@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 26 Aug 2012, Josef Bacik wrote:
> On Fri, Aug 24, 2012 at 04:47:56PM -0600, Sage Weil wrote:
> > Sadly, now I hit another one:
> >
> 
> Oh haha you need to set current->journal_info to the trans you have before you
> call commit_transaction in do_async_commit.  Thanks,

Ah, makes sense.  But now...

[  604.090449] ======================================================
[  604.114819] [ INFO: possible circular locking dependency detected ]
[  604.139262] 3.6.0-rc2-ceph-00144-g463b030 #1 Not tainted
[  604.162193] -------------------------------------------------------
[  604.186139] btrfs-cleaner/6669 is trying to acquire lock:
[  604.209555]  (sb_internal#2){.+.+..}, at: [<ffffffffa0042b84>] start_transaction+0x124/0x430 [btrfs]
[  604.257100] 
[  604.257100] but task is already holding lock:
[  604.300366]  (&fs_info->cleanup_work_sem){.+.+..}, at: [<ffffffffa0048002>] btrfs_run_delayed_iputs+0x72/0x130 [btrfs]
[  604.352989] 
[  604.352989] which lock already depends on the new lock.
[  604.352989] 
[  604.427104] 
[  604.427104] the existing dependency chain (in reverse order) is:
[  604.478493] 
[  604.478493] -> #1 (&fs_info->cleanup_work_sem){.+.+..}:
[  604.529313]        [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
[  604.559621]        [<ffffffff81632b69>] down_read+0x39/0x4e
[  604.589382]        [<ffffffffa004db98>] btrfs_lookup_dentry+0x218/0x550 [btrfs]
[  604.596161] btrfs: unlinked 1 orphans
[  604.675002]        [<ffffffffa006aadd>] create_subvol+0x62d/0x690 [btrfs]
[  604.708859]        [<ffffffffa006d666>] btrfs_mksubvol.isra.52+0x346/0x3a0 [btrfs]
[  604.772466]        [<ffffffffa006d7f2>] btrfs_ioctl_snap_create_transid+0x132/0x190 [btrfs]
[  604.842245]        [<ffffffffa006d8ae>] btrfs_ioctl_snap_create+0x5e/0x80 [btrfs]
[  604.912852]        [<ffffffffa00708ae>] btrfs_ioctl+0x138e/0x1990 [btrfs]
[  604.951888]        [<ffffffff8118e9b8>] do_vfs_ioctl+0x98/0x560
[  604.989961]        [<ffffffff8118ef11>] sys_ioctl+0x91/0xa0
[  605.026628]        [<ffffffff8163d569>] system_call_fastpath+0x16/0x1b
[  605.064404] 
[  605.064404] -> #0 (sb_internal#2){.+.+..}:
[  605.126832]        [<ffffffff810b25e8>] __lock_acquire+0x1ac8/0x1b90
[  605.163671]        [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
[  605.200228]        [<ffffffff8117dac6>] __sb_start_write+0xc6/0x1b0
[  605.236818]        [<ffffffffa0042b84>] start_transaction+0x124/0x430 [btrfs]
[  605.274029]        [<ffffffffa00431a3>] btrfs_start_transaction+0x13/0x20 [btrfs]
[  605.340520]        [<ffffffffa004ccfa>] btrfs_evict_inode+0x19a/0x330 [btrfs]
[  605.378720]        [<ffffffff811972c8>] evict+0xb8/0x1c0
[  605.416057]        [<ffffffff811974d5>] iput+0x105/0x210
[  605.452373]        [<ffffffffa0048082>] btrfs_run_delayed_iputs+0xf2/0x130 [btrfs]
[  605.521627]        [<ffffffffa003b5e1>] cleaner_kthread+0xa1/0x120 [btrfs]
[  605.560520]        [<ffffffff810791ee>] kthread+0xae/0xc0
[  605.598094]        [<ffffffff8163e744>] kernel_thread_helper+0x4/0x10

This dependency chain makes no sense to me.. one is a kernel thread and 
one is a syscall.  

[  605.636499] 
[  605.636499] other info that might help us debug this:
[  605.636499] 
[  605.736504]  Possible unsafe locking scenario:
[  605.736504] 
[  605.801931]        CPU0                    CPU1
[  605.835126]        ----                    ----
[  605.867093]   lock(&fs_info->cleanup_work_sem);
[  605.898594]                                lock(sb_internal#2);
[  605.931954]                                lock(&fs_info->cleanup_work_sem);
[  605.965359]   lock(sb_internal#2);
[  605.994758] 
[  605.994758]  *** DEADLOCK ***
[  605.994758] 
[  606.075281] 2 locks held by btrfs-cleaner/6669:
[  606.104528]  #0:  (&fs_info->cleaner_mutex){+.+...}, at: [<ffffffffa003b5d5>] cleaner_kthread+0x95/0x120 [btrfs]
[  606.165626]  #1:  (&fs_info->cleanup_work_sem){.+.+..}, at: [<ffffffffa0048002>] btrfs_run_delayed_iputs+0x72/0x130 [btrfs]
[  606.231297] 
[  606.231297] stack backtrace:
[  606.287723] Pid: 6669, comm: btrfs-cleaner Not tainted 3.6.0-rc2-ceph-00144-g463b030 #1
[  606.347823] Call Trace:
[  606.376184]  [<ffffffff8162a77c>] print_circular_bug+0x1fb/0x20c
[  606.409243]  [<ffffffff810b25e8>] __lock_acquire+0x1ac8/0x1b90
[  606.441343]  [<ffffffffa0042b84>] ? start_transaction+0x124/0x430 [btrfs]
[  606.474583]  [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
[  606.505934]  [<ffffffffa0042b84>] ? start_transaction+0x124/0x430 [btrfs]
[  606.539429]  [<ffffffff8132babd>] ? do_raw_spin_unlock+0x5d/0xb0
[  606.571719]  [<ffffffff8117dac6>] __sb_start_write+0xc6/0x1b0
[  606.603498]  [<ffffffffa0042b84>] ? start_transaction+0x124/0x430 [btrfs]
[  606.637405]  [<ffffffffa0042b84>] ? start_transaction+0x124/0x430 [btrfs]
[  606.670165]  [<ffffffff81172e75>] ? kmem_cache_alloc+0xb5/0x160
[  606.702144]  [<ffffffffa0042b84>] start_transaction+0x124/0x430 [btrfs]
[  606.735562]  [<ffffffffa00256a6>] ? block_rsv_add_bytes+0x56/0x80 [btrfs]
[  606.769861]  [<ffffffffa00431a3>] btrfs_start_transaction+0x13/0x20 [btrfs]
[  606.804575]  [<ffffffffa004ccfa>] btrfs_evict_inode+0x19a/0x330 [btrfs]
[  606.838756]  [<ffffffff81634c6b>] ? _raw_spin_unlock+0x2b/0x40
[  606.872010]  [<ffffffff811972c8>] evict+0xb8/0x1c0
[  606.903800]  [<ffffffff811974d5>] iput+0x105/0x210
[  606.935416]  [<ffffffffa0048082>] btrfs_run_delayed_iputs+0xf2/0x130 [btrfs]
[  606.970510]  [<ffffffffa003b5d5>] ? cleaner_kthread+0x95/0x120 [btrfs]
[  607.005648]  [<ffffffffa003b5e1>] cleaner_kthread+0xa1/0x120 [btrfs]
[  607.040724]  [<ffffffffa003b540>] ? btrfs_destroy_delayed_refs.isra.102+0x220/0x220 [btrfs]
[  607.104740]  [<ffffffff810791ee>] kthread+0xae/0xc0
[  607.137119]  [<ffffffff810b379d>] ? trace_hardirqs_on+0xd/0x10
[  607.169797]  [<ffffffff8163e744>] kernel_thread_helper+0x4/0x10
[  607.202472]  [<ffffffff81635430>] ? retint_restore_args+0x13/0x13
[  607.235884]  [<ffffffff81079140>] ? flush_kthread_work+0x1a0/0x1a0
[  607.268731]  [<ffffffff8163e740>] ? gs_change+0x13/0x13
[ 1080.982408] INFO: task kworker/3:1:158 blocked for more than 120 seconds.
[ 1081.016622] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1081.079081] kworker/3:1     D 0000000000000001     0   158      2 0x00000000
[ 1081.114673]  ffff88020ccc1b60 0000000000000046 0000000000000282 ffff880210480e50
[ 1081.114676]  ffff88020c825e20 ffff88020ccc1fd8 ffff88020ccc1fd8 ffff88020ccc1fd8
[ 1081.114679]  ffff880225d1bec0 ffff88020c825e20 ffff88020ccc1b70 ffff880210480e00
[ 1081.114680] Call Trace:
[ 1081.114687]  [<ffffffff81633979>] schedule+0x29/0x70
[ 1081.114715]  [<ffffffffa0056c35>] btrfs_start_ordered_extent+0x95/0x140 [btrfs]
[ 1081.114720]  [<ffffffff81079850>] ? __init_waitqueue_head+0x60/0x60
[ 1081.114743]  [<ffffffffa0056e09>] btrfs_wait_ordered_extents+0x129/0x1f0 [btrfs]
[ 1081.114760]  [<ffffffffa0041ecc>] btrfs_commit_transaction+0x45c/0xb20 [btrfs]
[ 1081.114765]  [<ffffffff81079850>] ? __init_waitqueue_head+0x60/0x60
[ 1081.114770]  [<ffffffff810717d6>] ? process_one_work+0x136/0x5f0
[ 1081.114786]  [<ffffffffa0042606>] do_async_commit+0x76/0x90 [btrfs]
[ 1081.114802]  [<ffffffffa0042590>] ? btrfs_commit_transaction+0xb20/0xb20 [btrfs]
[ 1081.114805]  [<ffffffff81071840>] process_one_work+0x1a0/0x5f0
[ 1081.114808]  [<ffffffff810717d6>] ? process_one_work+0x136/0x5f0
[ 1081.114815]  [<ffffffff810653c8>] ? mod_timer+0x118/0x240
[ 1081.114832]  [<ffffffffa0042590>] ? btrfs_commit_transaction+0xb20/0xb20 [btrfs]
[ 1081.114838]  [<ffffffff8107360d>] worker_thread+0x18d/0x4c0
[ 1081.114843]  [<ffffffff81073480>] ? manage_workers.isra.22+0x2c0/0x2c0
[ 1081.114845]  [<ffffffff810791ee>] kthread+0xae/0xc0
[ 1081.114849]  [<ffffffff810b379d>] ? trace_hardirqs_on+0xd/0x10
[ 1081.114853]  [<ffffffff8163e744>] kernel_thread_helper+0x4/0x10
[ 1081.114857]  [<ffffffff81635430>] ? retint_restore_args+0x13/0x13
[ 1081.114859]  [<ffffffff81079140>] ? flush_kthread_work+0x1a0/0x1a0
[ 1081.114862]  [<ffffffff8163e740>] ? gs_change+0x13/0x13
