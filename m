Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:56363 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807AbcC2Tkr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 15:40:47 -0400
Date: Tue, 29 Mar 2016 22:40:40 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Global hotspare functionality
Message-ID: <20160329194040.GB27148@jeknote.loshitsa1.net>
References: <20160318193937.GA21352@jek-Latitude-E7440>
 <56FA9420.8020503@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56FA9420.8020503@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I am testing hotspare v2 on kernel v4.4.5 (I will try latest Chris' tree later)
now with lockdep debugging enabled. At starting of replacement, lockdep warning is displayed,
because kstrdup() is called with GFP_NOFS inside of rcu_read_lock/unlock()
block (GFP_NOFS can sleep).

[ 1463.470875] BTRFS critical (device sdc): Fatal error on device /dev/sdf
[ 1463.499091] BTRFS warning (device sdc): device /dev/sdf failed, chunks degraded
[ 1463.501394] BTRFS info (device sdc): num_devices 4 rw_devices 3 degraded-option: unset
[ 1463.506221] 
[ 1463.508572] ===============================
[ 1463.512989] [ INFO: suspicious RCU usage. ]
[ 1463.514194] 4.4.5-scst31x+ #20 Not tainted
[ 1463.515191] -------------------------------
[ 1463.516162] include/linux/rcupdate.h:560 Illegal context switch in RCU read-side critical section!
[ 1463.519943] 
[ 1463.519943] other info that might help us debug this:
[ 1463.519943] 
[ 1463.531515] 
[ 1463.531515] rcu_scheduler_active = 1, debug_locks = 0
[ 1463.541056] 3 locks held by btrfs-casualty/4702:
[ 1463.542151]  #0:  (&fs_info->casualty_mutex){+.+...}, at: [<ffffffffa018325a>] casualty_kthread+0x6a/0x340 [btrfs]
[ 1463.563978]  #1:  (uuid_mutex){+.+.+.}, at: [<ffffffffa01bfc65>] btrfs_get_spare_device+0x25/0x1c0 [btrfs]
[ 1463.587380]  #2:  (rcu_read_lock){......}, at: [<ffffffffa01bfcac>] btrfs_get_spare_device+0x6c/0x1c0 [btrfs]
[ 1463.606124] 
[ 1463.606124] stack backtrace:
[ 1463.612596] CPU: 0 PID: 4702 Comm: btrfs-casualty Not tainted 4.4.5-scst31x+ #20
[ 1463.630796] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[ 1463.649423]  0000000000000000 ffff88005e65fc60 ffffffff813529e3 ffff88005e658580
[ 1463.685195]  0000000000000001 ffff88005e65fc90 ffffffff810d6407 0000000000000000
[ 1463.719570]  ffffffff81a270d7 0000000000000b2d 0000000002400040 ffff88005e65fcb8
[ 1463.735510] Call Trace:
[ 1463.741172]  [<ffffffff813529e3>] dump_stack+0x85/0xc2
[ 1463.751346]  [<ffffffff810d6407>] lockdep_rcu_suspicious+0xd7/0x110
[ 1463.776423]  [<ffffffff810add27>] ___might_sleep+0xa7/0x230
[ 1463.792409]  [<ffffffff810adef9>] __might_sleep+0x49/0x80
[ 1463.798818]  [<ffffffffa01bfd0a>] ? btrfs_get_spare_device+0xca/0x1c0 [btrfs]
[ 1463.814369]  [<ffffffff81200ec7>] __kmalloc_track_caller+0x227/0x5e0
[ 1463.828477]  [<ffffffff811c0f81>] kstrdup+0x31/0x60
[ 1463.836761]  [<ffffffffa01bfd0a>] btrfs_get_spare_device+0xca/0x1c0 [btrfs]
[ 1463.851841]  [<ffffffffa01bfcac>] ? btrfs_get_spare_device+0x6c/0x1c0 [btrfs]
[ 1463.867022]  [<ffffffffa02038a3>] btrfs_auto_replace_start+0x23/0xd0 [btrfs]
[ 1463.874201]  [<ffffffffa01834ad>] casualty_kthread+0x2bd/0x340 [btrfs]
[ 1463.891812]  [<ffffffffa01833d1>] ? casualty_kthread+0x1e1/0x340 [btrfs]
[ 1463.908948]  [<ffffffffa01831f0>] ? btrfs_check_devices+0x1f0/0x1f0 [btrfs]
[ 1463.920370]  [<ffffffff810a70df>] kthread+0xef/0x110
[ 1463.936421]  [<ffffffff810dc081>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[ 1463.949868]  [<ffffffff810a6ff0>] ? kthread_create_on_node+0x200/0x200
[ 1463.963096]  [<ffffffff81637c2f>] ret_from_fork+0x3f/0x70
[ 1463.973053]  [<ffffffff810a6ff0>] ? kthread_create_on_node+0x200/0x200
[ 1463.976256] BUG: sleeping function called from invalid context at mm/slab.c:2861
[ 1463.979936] in_atomic(): 1, irqs_disabled(): 0, pid: 4702, name: btrfs-casualty
[ 1463.981868] INFO: lockdep is turned off.
[ 1463.987513] CPU: 0 PID: 4702 Comm: btrfs-casualty Not tainted 4.4.5-scst31x+ #20
[ 1463.999678] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[ 1464.002555]  0000000000000000 ffff88005e65fc90 ffffffff813529e3 ffff88005e658580
[ 1464.022926]  ffffffff81a270d7 ffff88005e65fcb8 ffffffff810addf9 ffffffff81a270d7
[ 1464.055231]  0000000000000b2d 0000000000000000 ffff88005e65fce0 ffffffff810adef9
[ 1464.066771] Call Trace:
[ 1464.069301]  [<ffffffff813529e3>] dump_stack+0x85/0xc2
[ 1464.074030]  [<ffffffff810addf9>] ___might_sleep+0x179/0x230
[ 1464.076525]  [<ffffffff810adef9>] __might_sleep+0x49/0x80
[ 1464.078372]  [<ffffffffa01bfd0a>] ? btrfs_get_spare_device+0xca/0x1c0 [btrfs]
[ 1464.080315]  [<ffffffff81200ec7>] __kmalloc_track_caller+0x227/0x5e0
[ 1464.083712]  [<ffffffff811c0f81>] kstrdup+0x31/0x60
[ 1464.099224]  [<ffffffffa01bfd0a>] btrfs_get_spare_device+0xca/0x1c0 [btrfs]
[ 1464.102570]  [<ffffffffa01bfcac>] ? btrfs_get_spare_device+0x6c/0x1c0 [btrfs]
[ 1464.106557]  [<ffffffffa02038a3>] btrfs_auto_replace_start+0x23/0xd0 [btrfs]
[ 1464.113009]  [<ffffffffa01834ad>] casualty_kthread+0x2bd/0x340 [btrfs]
[ 1464.115574]  [<ffffffffa01833d1>] ? casualty_kthread+0x1e1/0x340 [btrfs]
[ 1464.131337]  [<ffffffffa01831f0>] ? btrfs_check_devices+0x1f0/0x1f0 [btrfs]
[ 1464.139141]  [<ffffffff810a70df>] kthread+0xef/0x110
[ 1464.151499]  [<ffffffff810dc081>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[ 1464.175156]  [<ffffffff810a6ff0>] ? kthread_create_on_node+0x200/0x200
[ 1464.194352]  [<ffffffff81637c2f>] ret_from_fork+0x3f/0x70
[ 1464.207239]  [<ffffffff810a6ff0>] ? kthread_create_on_node+0x200/0x200
[ 1464.232552] BTRFS info (device sdc): dev_replace from <missing disk> (devid 4) to /dev/sdg started


-- 
Yauhen Kharuzhy
