Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:37204 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013AbcCDRba (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 12:31:30 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1abtZV-0000yM-Pf
	for linux-btrfs@vger.kernel.org; Fri, 04 Mar 2016 18:31:25 +0100
Date: Fri, 4 Mar 2016 18:31:25 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: balance hangs and starts again on reboot
Message-ID: <20160304173125.GA1902@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have another btrfs on the same host that has no the no space left on
device balance issue, but on another disk. On this btrfs, it seems
like a balance process is stuck, with a lot of hanging kernel
threads. After a reboot, when I mount the filesystem, the balance
immediately starts again. btrfs balance cancel just hangs around with
no visible reaction for hours.

Log appended. Is there rescue?

Greetings
Marc


-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

Mar  4 17:27:36 fan mh: mount /mnt/snapshots/fanbtr_r
Mar  4 17:27:41 fan kernel: [  453.124792] BTRFS info (device dm-17): disk space caching is enabled
Mar  4 17:27:41 fan kernel: [  453.124797] BTRFS: has skinny extents
Mar  4 17:27:46 fan kernel: [  458.308485] BTRFS: checking UUID tree
Mar  4 17:27:46 fan kernel: [  458.308493] BTRFS info (device dm-17): continuing balance
Mar  4 17:27:50 fan kernel: [  462.297618] BTRFS info (device dm-17): relocating block group 1504341655552 flags 36
Mar  4 17:32:08 fan kernel: [  720.473141] INFO: task btrfs-balance:3753 blocked for more than 120 seconds.
Mar  4 17:32:08 fan kernel: [  720.473154]       Not tainted 4.4.4-zgws1 #2
Mar  4 17:32:08 fan kernel: [  720.473159] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 17:32:08 fan kernel: [  720.473165] btrfs-balance   D ffff88062fc556c0     0  3753      2 0x00000000
Mar  4 17:32:08 fan kernel: [  720.473176]  ffff88060c3f0c00 0000000000000001 ffff880036da4000 ffff880036da3bd0
Mar  4 17:32:08 fan kernel: [  720.473184]  ffff8806113b6c60 0000000000000002 ffffffff8140d24c ffff88060c3f0c00
Mar  4 17:32:08 fan kernel: [  720.473192]  ffffffff8140b759 7fffffffffffffff ffffffff8140d28a ffff88062fc156c0
Mar  4 17:32:08 fan kernel: [  720.473199] Call Trace:
Mar  4 17:32:08 fan kernel: [  720.473214]  [<ffffffff8140d24c>] ? usleep_range+0x35/0x35
Mar  4 17:32:08 fan kernel: [  720.473225]  [<ffffffff8140b759>] ? schedule+0x6f/0x7c
Mar  4 17:32:08 fan kernel: [  720.473231]  [<ffffffff8140d28a>] ? schedule_timeout+0x3e/0x128
Mar  4 17:32:08 fan kernel: [  720.473241]  [<ffffffff8106e837>] ? check_preempt_curr+0x25/0x63
Mar  4 17:32:08 fan kernel: [  720.473248]  [<ffffffff8106e884>] ? ttwu_do_wakeup+0xf/0xd0
Mar  4 17:32:08 fan kernel: [  720.473255]  [<ffffffff8140d9fd>] ? _raw_spin_unlock_irqrestore+0xd/0xe
Mar  4 17:32:08 fan kernel: [  720.473263]  [<ffffffff8106f79a>] ? try_to_wake_up+0x1cb/0x1dc
Mar  4 17:32:08 fan kernel: [  720.473271]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:32:08 fan kernel: [  720.473278]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:32:08 fan kernel: [  720.473286]  [<ffffffff8106f7f2>] ? wake_up_q+0x3b/0x3b
Mar  4 17:32:08 fan kernel: [  720.473339]  [<ffffffffa0468832>] ? btrfs_async_run_delayed_refs+0xbf/0xd5 [btrfs]
Mar  4 17:32:08 fan kernel: [  720.473390]  [<ffffffffa047e775>] ? __btrfs_end_transaction+0x291/0x2d5 [btrfs]
Mar  4 17:32:08 fan kernel: [  720.473438]  [<ffffffffa04bde2f>] ? relocate_block_group+0x2b8/0x4ab [btrfs]
Mar  4 17:32:08 fan kernel: [  720.473488]  [<ffffffffa0493087>] ? btrfs_wait_ordered_roots+0x175/0x191 [btrfs]
Mar  4 17:32:08 fan kernel: [  720.473536]  [<ffffffffa04be154>] ? btrfs_relocate_block_group+0x132/0x25a [btrfs]
Mar  4 17:32:08 fan kernel: [  720.473585]  [<ffffffffa049d107>] ? btrfs_relocate_chunk.isra.35+0x3c/0xad [btrfs]
Mar  4 17:32:08 fan kernel: [  720.473633]  [<ffffffffa049e8f3>] ? btrfs_balance+0xd23/0xd8f [btrfs]
Mar  4 17:32:08 fan kernel: [  720.473684]  [<ffffffffa049e9ae>] ? balance_kthread+0x4f/0x6d [btrfs]
Mar  4 17:32:08 fan kernel: [  720.473732]  [<ffffffffa049e95f>] ? btrfs_balance+0xd8f/0xd8f [btrfs]
Mar  4 17:32:08 fan kernel: [  720.473740]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar  4 17:32:08 fan kernel: [  720.473747]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:32:08 fan kernel: [  720.473754]  [<ffffffff8140e03f>] ? ret_from_fork+0x3f/0x70
Mar  4 17:32:08 fan kernel: [  720.473761]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:34:08 fan kernel: [  840.465597] INFO: task btrfs-balance:3753 blocked for more than 120 seconds.
Mar  4 17:34:08 fan kernel: [  840.465610]       Not tainted 4.4.4-zgws1 #2
Mar  4 17:34:08 fan kernel: [  840.465615] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 17:34:08 fan kernel: [  840.465621] btrfs-balance   D ffff88062fc556c0     0  3753      2 0x00000000
Mar  4 17:34:08 fan kernel: [  840.465632]  ffff88060c3f0c00 0000000000000001 ffff880036da4000 ffff880036da3bd0
Mar  4 17:34:08 fan kernel: [  840.465641]  ffff8806113b6c60 0000000000000002 ffffffff8140d24c ffff88060c3f0c00
Mar  4 17:34:08 fan kernel: [  840.465648]  ffffffff8140b759 7fffffffffffffff ffffffff8140d28a ffff88062fc156c0
Mar  4 17:34:08 fan kernel: [  840.465655] Call Trace:
Mar  4 17:34:08 fan kernel: [  840.465669]  [<ffffffff8140d24c>] ? usleep_range+0x35/0x35
Mar  4 17:34:08 fan kernel: [  840.465680]  [<ffffffff8140b759>] ? schedule+0x6f/0x7c
Mar  4 17:34:08 fan kernel: [  840.465687]  [<ffffffff8140d28a>] ? schedule_timeout+0x3e/0x128
Mar  4 17:34:08 fan kernel: [  840.465697]  [<ffffffff8106e837>] ? check_preempt_curr+0x25/0x63
Mar  4 17:34:08 fan kernel: [  840.465704]  [<ffffffff8106e884>] ? ttwu_do_wakeup+0xf/0xd0
Mar  4 17:34:08 fan kernel: [  840.465711]  [<ffffffff8140d9fd>] ? _raw_spin_unlock_irqrestore+0xd/0xe
Mar  4 17:34:08 fan kernel: [  840.465719]  [<ffffffff8106f79a>] ? try_to_wake_up+0x1cb/0x1dc
Mar  4 17:34:08 fan kernel: [  840.465727]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:34:08 fan kernel: [  840.465735]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:34:08 fan kernel: [  840.465742]  [<ffffffff8106f7f2>] ? wake_up_q+0x3b/0x3b
Mar  4 17:34:08 fan kernel: [  840.465797]  [<ffffffffa0468832>] ? btrfs_async_run_delayed_refs+0xbf/0xd5 [btrfs]
Mar  4 17:34:08 fan kernel: [  840.465846]  [<ffffffffa047e775>] ? __btrfs_end_transaction+0x291/0x2d5 [btrfs]
Mar  4 17:34:08 fan kernel: [  840.465894]  [<ffffffffa04bde2f>] ? relocate_block_group+0x2b8/0x4ab [btrfs]
Mar  4 17:34:08 fan kernel: [  840.465944]  [<ffffffffa0493087>] ? btrfs_wait_ordered_roots+0x175/0x191 [btrfs]
Mar  4 17:34:08 fan kernel: [  840.465992]  [<ffffffffa04be154>] ? btrfs_relocate_block_group+0x132/0x25a [btrfs]
Mar  4 17:34:08 fan kernel: [  840.466041]  [<ffffffffa049d107>] ? btrfs_relocate_chunk.isra.35+0x3c/0xad [btrfs]
Mar  4 17:34:08 fan kernel: [  840.466089]  [<ffffffffa049e8f3>] ? btrfs_balance+0xd23/0xd8f [btrfs]
Mar  4 17:34:08 fan kernel: [  840.466140]  [<ffffffffa049e9ae>] ? balance_kthread+0x4f/0x6d [btrfs]
Mar  4 17:34:08 fan kernel: [  840.466188]  [<ffffffffa049e95f>] ? btrfs_balance+0xd8f/0xd8f [btrfs]
Mar  4 17:34:08 fan kernel: [  840.466196]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar  4 17:34:08 fan kernel: [  840.466204]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:34:08 fan kernel: [  840.466210]  [<ffffffff8140e03f>] ? ret_from_fork+0x3f/0x70
Mar  4 17:34:08 fan kernel: [  840.466217]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:36:08 fan kernel: [  960.458052] INFO: task btrfs-balance:3753 blocked for more than 120 seconds.
Mar  4 17:36:08 fan kernel: [  960.458057]       Not tainted 4.4.4-zgws1 #2
Mar  4 17:36:08 fan kernel: [  960.458058] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 17:36:08 fan kernel: [  960.458060] btrfs-balance   D ffff88062fc556c0     0  3753      2 0x00000000
Mar  4 17:36:08 fan kernel: [  960.458063]  ffff88060c3f0c00 0000000000000001 ffff880036da4000 ffff880036da3bd0
Mar  4 17:36:08 fan kernel: [  960.458065]  ffff8806113b6c60 0000000000000002 ffffffff8140d24c ffff88060c3f0c00
Mar  4 17:36:08 fan kernel: [  960.458067]  ffffffff8140b759 7fffffffffffffff ffffffff8140d28a ffff88062fc156c0
Mar  4 17:36:08 fan kernel: [  960.458069] Call Trace:
Mar  4 17:36:08 fan kernel: [  960.458075]  [<ffffffff8140d24c>] ? usleep_range+0x35/0x35
Mar  4 17:36:08 fan kernel: [  960.458078]  [<ffffffff8140b759>] ? schedule+0x6f/0x7c
Mar  4 17:36:08 fan kernel: [  960.458080]  [<ffffffff8140d28a>] ? schedule_timeout+0x3e/0x128
Mar  4 17:36:08 fan kernel: [  960.458083]  [<ffffffff8106e837>] ? check_preempt_curr+0x25/0x63
Mar  4 17:36:08 fan kernel: [  960.458085]  [<ffffffff8106e884>] ? ttwu_do_wakeup+0xf/0xd0
Mar  4 17:36:08 fan kernel: [  960.458087]  [<ffffffff8140d9fd>] ? _raw_spin_unlock_irqrestore+0xd/0xe
Mar  4 17:36:08 fan kernel: [  960.458089]  [<ffffffff8106f79a>] ? try_to_wake_up+0x1cb/0x1dc
Mar  4 17:36:08 fan kernel: [  960.458091]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:36:08 fan kernel: [  960.458093]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:36:08 fan kernel: [  960.458095]  [<ffffffff8106f7f2>] ? wake_up_q+0x3b/0x3b
Mar  4 17:36:08 fan kernel: [  960.458122]  [<ffffffffa0468832>] ? btrfs_async_run_delayed_refs+0xbf/0xd5 [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458134]  [<ffffffffa047e775>] ? __btrfs_end_transaction+0x291/0x2d5 [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458146]  [<ffffffffa04bde2f>] ? relocate_block_group+0x2b8/0x4ab [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458159]  [<ffffffffa0493087>] ? btrfs_wait_ordered_roots+0x175/0x191 [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458171]  [<ffffffffa04be154>] ? btrfs_relocate_block_group+0x132/0x25a [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458183]  [<ffffffffa049d107>] ? btrfs_relocate_chunk.isra.35+0x3c/0xad [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458195]  [<ffffffffa049e8f3>] ? btrfs_balance+0xd23/0xd8f [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458208]  [<ffffffffa049e9ae>] ? balance_kthread+0x4f/0x6d [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458220]  [<ffffffffa049e95f>] ? btrfs_balance+0xd8f/0xd8f [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458223]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar  4 17:36:08 fan kernel: [  960.458225]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:36:08 fan kernel: [  960.458227]  [<ffffffff8140e03f>] ? ret_from_fork+0x3f/0x70
Mar  4 17:36:08 fan kernel: [  960.458228]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:36:08 fan kernel: [  960.458232] INFO: task btrfs:3852 blocked for more than 120 seconds.
Mar  4 17:36:08 fan kernel: [  960.458233]       Not tainted 4.4.4-zgws1 #2
Mar  4 17:36:08 fan kernel: [  960.458234] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 17:36:08 fan kernel: [  960.458235] btrfs           D ffff88062fc156c0     0  3852   3848 0x00000000
Mar  4 17:36:08 fan kernel: [  960.458238]  ffff880614848d00 0000000000000000 ffff8805edfa4000 ffff8805f6e0ac78
Mar  4 17:36:08 fan kernel: [  960.458239]  ffff8805f6e0acb8 0000000040049421 ffff8800cb7a91b8 ffff880614aa0b00
Mar  4 17:36:08 fan kernel: [  960.458241]  ffffffff8140b759 ffff8805f6e0a000 ffffffffa049d533 00ff880600000000
Mar  4 17:36:08 fan kernel: [  960.458243] Call Trace:
Mar  4 17:36:08 fan kernel: [  960.458245]  [<ffffffff8140b759>] ? schedule+0x6f/0x7c
Mar  4 17:36:08 fan kernel: [  960.458257]  [<ffffffffa049d533>] ? btrfs_cancel_balance+0xab/0x130 [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458260]  [<ffffffff8107d42a>] ? wake_up_atomic_t+0x1f/0x1f
Mar  4 17:36:08 fan kernel: [  960.458272]  [<ffffffffa04aa12f>] ? btrfs_ioctl+0x126d/0x2699 [btrfs]
Mar  4 17:36:08 fan kernel: [  960.458275]  [<ffffffff811329f4>] ? mem_cgroup_charge_statistics.isra.30+0x22/0x4f
Mar  4 17:36:08 fan kernel: [  960.458277]  [<ffffffff81136422>] ? mem_cgroup_commit_charge+0x8a/0xaa
Mar  4 17:36:08 fan kernel: [  960.458280]  [<ffffffff810f56bc>] ? __lru_cache_add+0x19/0x38
Mar  4 17:36:08 fan kernel: [  960.458282]  [<ffffffff8110a233>] ? set_pte_at+0x5/0x8
Mar  4 17:36:08 fan kernel: [  960.458284]  [<ffffffff8110db2a>] ? handle_mm_fault+0x488/0xea5
Mar  4 17:36:08 fan kernel: [  960.458286]  [<ffffffff81149e06>] ? do_vfs_ioctl+0x3ad/0x424
Mar  4 17:36:08 fan kernel: [  960.458288]  [<ffffffff81149e06>] ? do_vfs_ioctl+0x3ad/0x424
Mar  4 17:36:08 fan kernel: [  960.458290]  [<ffffffff81149eca>] ? SyS_ioctl+0x4d/0x6f
Mar  4 17:36:08 fan kernel: [  960.458292]  [<ffffffff8140dcee>] ? entry_SYSCALL_64_fastpath+0x12/0x6d
Mar  4 17:38:08 fan kernel: [ 1080.450472] INFO: task btrfs-balance:3753 blocked for more than 120 seconds.
Mar  4 17:38:08 fan kernel: [ 1080.450476]       Not tainted 4.4.4-zgws1 #2
Mar  4 17:38:08 fan kernel: [ 1080.450478] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 17:38:08 fan kernel: [ 1080.450479] btrfs-balance   D ffff88062fc556c0     0  3753      2 0x00000000
Mar  4 17:38:08 fan kernel: [ 1080.450483]  ffff88060c3f0c00 0000000000000001 ffff880036da4000 ffff880036da3bd0
Mar  4 17:38:08 fan kernel: [ 1080.450485]  ffff8806113b6c60 0000000000000002 ffffffff8140d24c ffff88060c3f0c00
Mar  4 17:38:08 fan kernel: [ 1080.450487]  ffffffff8140b759 7fffffffffffffff ffffffff8140d28a ffff88062fc156c0
Mar  4 17:38:08 fan kernel: [ 1080.450489] Call Trace:
Mar  4 17:38:08 fan kernel: [ 1080.450495]  [<ffffffff8140d24c>] ? usleep_range+0x35/0x35
Mar  4 17:38:08 fan kernel: [ 1080.450498]  [<ffffffff8140b759>] ? schedule+0x6f/0x7c
Mar  4 17:38:08 fan kernel: [ 1080.450500]  [<ffffffff8140d28a>] ? schedule_timeout+0x3e/0x128
Mar  4 17:38:08 fan kernel: [ 1080.450503]  [<ffffffff8106e837>] ? check_preempt_curr+0x25/0x63
Mar  4 17:38:08 fan kernel: [ 1080.450505]  [<ffffffff8106e884>] ? ttwu_do_wakeup+0xf/0xd0
Mar  4 17:38:08 fan kernel: [ 1080.450507]  [<ffffffff8140d9fd>] ? _raw_spin_unlock_irqrestore+0xd/0xe
Mar  4 17:38:08 fan kernel: [ 1080.450509]  [<ffffffff8106f79a>] ? try_to_wake_up+0x1cb/0x1dc
Mar  4 17:38:08 fan kernel: [ 1080.450511]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:38:08 fan kernel: [ 1080.450513]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:38:08 fan kernel: [ 1080.450514]  [<ffffffff8106f7f2>] ? wake_up_q+0x3b/0x3b
Mar  4 17:38:08 fan kernel: [ 1080.450542]  [<ffffffffa0468832>] ? btrfs_async_run_delayed_refs+0xbf/0xd5 [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450555]  [<ffffffffa047e775>] ? __btrfs_end_transaction+0x291/0x2d5 [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450567]  [<ffffffffa04bde2f>] ? relocate_block_group+0x2b8/0x4ab [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450579]  [<ffffffffa0493087>] ? btrfs_wait_ordered_roots+0x175/0x191 [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450591]  [<ffffffffa04be154>] ? btrfs_relocate_block_group+0x132/0x25a [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450604]  [<ffffffffa049d107>] ? btrfs_relocate_chunk.isra.35+0x3c/0xad [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450616]  [<ffffffffa049e8f3>] ? btrfs_balance+0xd23/0xd8f [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450629]  [<ffffffffa049e9ae>] ? balance_kthread+0x4f/0x6d [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450641]  [<ffffffffa049e95f>] ? btrfs_balance+0xd8f/0xd8f [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450643]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar  4 17:38:08 fan kernel: [ 1080.450645]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:38:08 fan kernel: [ 1080.450647]  [<ffffffff8140e03f>] ? ret_from_fork+0x3f/0x70
Mar  4 17:38:08 fan kernel: [ 1080.450649]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:38:08 fan kernel: [ 1080.450652] INFO: task btrfs:3852 blocked for more than 120 seconds.
Mar  4 17:38:08 fan kernel: [ 1080.450653]       Not tainted 4.4.4-zgws1 #2
Mar  4 17:38:08 fan kernel: [ 1080.450655] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 17:38:08 fan kernel: [ 1080.450656] btrfs           D ffff88062fc156c0     0  3852   3848 0x00000000
Mar  4 17:38:08 fan kernel: [ 1080.450658]  ffff880614848d00 0000000000000000 ffff8805edfa4000 ffff8805f6e0ac78
Mar  4 17:38:08 fan kernel: [ 1080.450660]  ffff8805f6e0acb8 0000000040049421 ffff8800cb7a91b8 ffff880614aa0b00
Mar  4 17:38:08 fan kernel: [ 1080.450661]  ffffffff8140b759 ffff8805f6e0a000 ffffffffa049d533 00ff880600000000
Mar  4 17:38:08 fan kernel: [ 1080.450663] Call Trace:
Mar  4 17:38:08 fan kernel: [ 1080.450665]  [<ffffffff8140b759>] ? schedule+0x6f/0x7c
Mar  4 17:38:08 fan kernel: [ 1080.450677]  [<ffffffffa049d533>] ? btrfs_cancel_balance+0xab/0x130 [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450681]  [<ffffffff8107d42a>] ? wake_up_atomic_t+0x1f/0x1f
Mar  4 17:38:08 fan kernel: [ 1080.450693]  [<ffffffffa04aa12f>] ? btrfs_ioctl+0x126d/0x2699 [btrfs]
Mar  4 17:38:08 fan kernel: [ 1080.450697]  [<ffffffff811329f4>] ? mem_cgroup_charge_statistics.isra.30+0x22/0x4f
Mar  4 17:38:08 fan kernel: [ 1080.450699]  [<ffffffff81136422>] ? mem_cgroup_commit_charge+0x8a/0xaa
Mar  4 17:38:08 fan kernel: [ 1080.450701]  [<ffffffff810f56bc>] ? __lru_cache_add+0x19/0x38
Mar  4 17:38:08 fan kernel: [ 1080.450703]  [<ffffffff8110a233>] ? set_pte_at+0x5/0x8
Mar  4 17:38:08 fan kernel: [ 1080.450705]  [<ffffffff8110db2a>] ? handle_mm_fault+0x488/0xea5
Mar  4 17:38:08 fan kernel: [ 1080.450708]  [<ffffffff81149e06>] ? do_vfs_ioctl+0x3ad/0x424
Mar  4 17:38:08 fan kernel: [ 1080.450709]  [<ffffffff81149e06>] ? do_vfs_ioctl+0x3ad/0x424
Mar  4 17:38:08 fan kernel: [ 1080.450711]  [<ffffffff81149eca>] ? SyS_ioctl+0x4d/0x6f
Mar  4 17:38:08 fan kernel: [ 1080.450713]  [<ffffffff8140dcee>] ? entry_SYSCALL_64_fastpath+0x12/0x6d
Mar  4 17:40:08 fan kernel: [ 1200.442969] INFO: task btrfs-balance:3753 blocked for more than 120 seconds.
Mar  4 17:40:08 fan kernel: [ 1200.442981]       Not tainted 4.4.4-zgws1 #2
Mar  4 17:40:08 fan kernel: [ 1200.442987] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 17:40:08 fan kernel: [ 1200.442992] btrfs-balance   D ffff88062fc556c0     0  3753      2 0x00000000
Mar  4 17:40:08 fan kernel: [ 1200.443003]  ffff88060c3f0c00 0000000000000001 ffff880036da4000 ffff880036da3bd0
Mar  4 17:40:08 fan kernel: [ 1200.443011]  ffff8806113b6c60 0000000000000002 ffffffff8140d24c ffff88060c3f0c00
Mar  4 17:40:08 fan kernel: [ 1200.443019]  ffffffff8140b759 7fffffffffffffff ffffffff8140d28a ffff88062fc156c0
Mar  4 17:40:08 fan kernel: [ 1200.443026] Call Trace:
Mar  4 17:40:08 fan kernel: [ 1200.443040]  [<ffffffff8140d24c>] ? usleep_range+0x35/0x35
Mar  4 17:40:08 fan kernel: [ 1200.443051]  [<ffffffff8140b759>] ? schedule+0x6f/0x7c
Mar  4 17:40:08 fan kernel: [ 1200.443058]  [<ffffffff8140d28a>] ? schedule_timeout+0x3e/0x128
Mar  4 17:40:08 fan kernel: [ 1200.443067]  [<ffffffff8106e837>] ? check_preempt_curr+0x25/0x63
Mar  4 17:40:08 fan kernel: [ 1200.443075]  [<ffffffff8106e884>] ? ttwu_do_wakeup+0xf/0xd0
Mar  4 17:40:08 fan kernel: [ 1200.443082]  [<ffffffff8140d9fd>] ? _raw_spin_unlock_irqrestore+0xd/0xe
Mar  4 17:40:08 fan kernel: [ 1200.443090]  [<ffffffff8106f79a>] ? try_to_wake_up+0x1cb/0x1dc
Mar  4 17:40:08 fan kernel: [ 1200.443098]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:40:08 fan kernel: [ 1200.443105]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:40:08 fan kernel: [ 1200.443113]  [<ffffffff8106f7f2>] ? wake_up_q+0x3b/0x3b
Mar  4 17:40:08 fan kernel: [ 1200.443168]  [<ffffffffa0468832>] ? btrfs_async_run_delayed_refs+0xbf/0xd5 [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443217]  [<ffffffffa047e775>] ? __btrfs_end_transaction+0x291/0x2d5 [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443266]  [<ffffffffa04bde2f>] ? relocate_block_group+0x2b8/0x4ab [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443316]  [<ffffffffa0493087>] ? btrfs_wait_ordered_roots+0x175/0x191 [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443364]  [<ffffffffa04be154>] ? btrfs_relocate_block_group+0x132/0x25a [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443414]  [<ffffffffa049d107>] ? btrfs_relocate_chunk.isra.35+0x3c/0xad [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443462]  [<ffffffffa049e8f3>] ? btrfs_balance+0xd23/0xd8f [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443513]  [<ffffffffa049e9ae>] ? balance_kthread+0x4f/0x6d [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443561]  [<ffffffffa049e95f>] ? btrfs_balance+0xd8f/0xd8f [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443569]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar  4 17:40:08 fan kernel: [ 1200.443577]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:40:08 fan kernel: [ 1200.443584]  [<ffffffff8140e03f>] ? ret_from_fork+0x3f/0x70
Mar  4 17:40:08 fan kernel: [ 1200.443591]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:40:08 fan kernel: [ 1200.443600] INFO: task btrfs:3852 blocked for more than 120 seconds.
Mar  4 17:40:08 fan kernel: [ 1200.443605]       Not tainted 4.4.4-zgws1 #2
Mar  4 17:40:08 fan kernel: [ 1200.443609] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 17:40:08 fan kernel: [ 1200.443613] btrfs           D ffff88062fc156c0     0  3852   3848 0x00000000
Mar  4 17:40:08 fan kernel: [ 1200.443621]  ffff880614848d00 0000000000000000 ffff8805edfa4000 ffff8805f6e0ac78
Mar  4 17:40:08 fan kernel: [ 1200.443628]  ffff8805f6e0acb8 0000000040049421 ffff8800cb7a91b8 ffff880614aa0b00
Mar  4 17:40:08 fan kernel: [ 1200.443635]  ffffffff8140b759 ffff8805f6e0a000 ffffffffa049d533 00ff880600000000
Mar  4 17:40:08 fan kernel: [ 1200.443641] Call Trace:
Mar  4 17:40:08 fan kernel: [ 1200.443649]  [<ffffffff8140b759>] ? schedule+0x6f/0x7c
Mar  4 17:40:08 fan kernel: [ 1200.443698]  [<ffffffffa049d533>] ? btrfs_cancel_balance+0xab/0x130 [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443706]  [<ffffffff8107d42a>] ? wake_up_atomic_t+0x1f/0x1f
Mar  4 17:40:08 fan kernel: [ 1200.443755]  [<ffffffffa04aa12f>] ? btrfs_ioctl+0x126d/0x2699 [btrfs]
Mar  4 17:40:08 fan kernel: [ 1200.443766]  [<ffffffff811329f4>] ? mem_cgroup_charge_statistics.isra.30+0x22/0x4f
Mar  4 17:40:08 fan kernel: [ 1200.443773]  [<ffffffff81136422>] ? mem_cgroup_commit_charge+0x8a/0xaa
Mar  4 17:40:08 fan kernel: [ 1200.443780]  [<ffffffff810f56bc>] ? __lru_cache_add+0x19/0x38
Mar  4 17:40:08 fan kernel: [ 1200.443787]  [<ffffffff8110a233>] ? set_pte_at+0x5/0x8
Mar  4 17:40:08 fan kernel: [ 1200.443795]  [<ffffffff8110db2a>] ? handle_mm_fault+0x488/0xea5
Mar  4 17:40:08 fan kernel: [ 1200.443803]  [<ffffffff81149e06>] ? do_vfs_ioctl+0x3ad/0x424
Mar  4 17:40:08 fan kernel: [ 1200.443809]  [<ffffffff81149e06>] ? do_vfs_ioctl+0x3ad/0x424
Mar  4 17:40:08 fan kernel: [ 1200.443816]  [<ffffffff81149eca>] ? SyS_ioctl+0x4d/0x6f
Mar  4 17:40:08 fan kernel: [ 1200.443823]  [<ffffffff8140dcee>] ? entry_SYSCALL_64_fastpath+0x12/0x6d
Mar  4 17:42:08 fan kernel: [ 1320.435274] INFO: task btrfs:3852 blocked for more than 120 seconds.
Mar  4 17:42:08 fan kernel: [ 1320.435286]       Not tainted 4.4.4-zgws1 #2
Mar  4 17:42:08 fan kernel: [ 1320.435291] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 17:42:08 fan kernel: [ 1320.435296] btrfs           D ffff88062fc156c0     0  3852   3848 0x00000000
Mar  4 17:42:08 fan kernel: [ 1320.435307]  ffff880614848d00 0000000000000000 ffff8805edfa4000 ffff8805f6e0ac78
Mar  4 17:42:08 fan kernel: [ 1320.435316]  ffff8805f6e0acb8 0000000040049421 ffff8800cb7a91b8 ffff880614aa0b00
Mar  4 17:42:08 fan kernel: [ 1320.435323]  ffffffff8140b759 ffff8805f6e0a000 ffffffffa049d533 00ff880600000000
Mar  4 17:42:08 fan kernel: [ 1320.435330] Call Trace:
Mar  4 17:42:08 fan kernel: [ 1320.435346]  [<ffffffff8140b759>] ? schedule+0x6f/0x7c
Mar  4 17:42:08 fan kernel: [ 1320.435409]  [<ffffffffa049d533>] ? btrfs_cancel_balance+0xab/0x130 [btrfs]
Mar  4 17:42:08 fan kernel: [ 1320.435420]  [<ffffffff8107d42a>] ? wake_up_atomic_t+0x1f/0x1f
Mar  4 17:42:08 fan kernel: [ 1320.435469]  [<ffffffffa04aa12f>] ? btrfs_ioctl+0x126d/0x2699 [btrfs]
Mar  4 17:42:08 fan kernel: [ 1320.435481]  [<ffffffff811329f4>] ? mem_cgroup_charge_statistics.isra.30+0x22/0x4f
Mar  4 17:42:08 fan kernel: [ 1320.435490]  [<ffffffff81136422>] ? mem_cgroup_commit_charge+0x8a/0xaa
Mar  4 17:42:08 fan kernel: [ 1320.435497]  [<ffffffff810f56bc>] ? __lru_cache_add+0x19/0x38
Mar  4 17:42:08 fan kernel: [ 1320.435504]  [<ffffffff8110a233>] ? set_pte_at+0x5/0x8
Mar  4 17:42:08 fan kernel: [ 1320.435512]  [<ffffffff8110db2a>] ? handle_mm_fault+0x488/0xea5
Mar  4 17:42:08 fan kernel: [ 1320.435520]  [<ffffffff81149e06>] ? do_vfs_ioctl+0x3ad/0x424
Mar  4 17:42:08 fan kernel: [ 1320.435526]  [<ffffffff81149e06>] ? do_vfs_ioctl+0x3ad/0x424
Mar  4 17:42:08 fan kernel: [ 1320.435533]  [<ffffffff81149eca>] ? SyS_ioctl+0x4d/0x6f
Mar  4 17:42:08 fan kernel: [ 1320.435541]  [<ffffffff8140dcee>] ? entry_SYSCALL_64_fastpath+0x12/0x6d
Mar  4 17:44:08 fan kernel: [ 1440.427466] INFO: task btrfs-balance:3753 blocked for more than 120 seconds.
Mar  4 17:44:08 fan kernel: [ 1440.427479]       Not tainted 4.4.4-zgws1 #2
Mar  4 17:44:08 fan kernel: [ 1440.427484] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 17:44:08 fan kernel: [ 1440.427490] btrfs-balance   D ffff88062fd156c0     0  3753      2 0x00000000
Mar  4 17:44:08 fan kernel: [ 1440.427501]  ffff88060c3f0c00 0000000000000004 ffff880036da4000 ffff880036da3bd0
Mar  4 17:44:08 fan kernel: [ 1440.427509]  ffff8805f1b82ea0 0000000000000002 ffffffff8140d24c ffff88060c3f0c00
Mar  4 17:44:08 fan kernel: [ 1440.427517]  ffffffff8140b759 7fffffffffffffff ffffffff8140d28a ffff88017c431100
Mar  4 17:44:08 fan kernel: [ 1440.427524] Call Trace:
Mar  4 17:44:08 fan kernel: [ 1440.427538]  [<ffffffff8140d24c>] ? usleep_range+0x35/0x35
Mar  4 17:44:08 fan kernel: [ 1440.427548]  [<ffffffff8140b759>] ? schedule+0x6f/0x7c
Mar  4 17:44:08 fan kernel: [ 1440.427555]  [<ffffffff8140d28a>] ? schedule_timeout+0x3e/0x128
Mar  4 17:44:08 fan kernel: [ 1440.427565]  [<ffffffff8106e853>] ? check_preempt_curr+0x41/0x63
Mar  4 17:44:08 fan kernel: [ 1440.427572]  [<ffffffff8106e884>] ? ttwu_do_wakeup+0xf/0xd0
Mar  4 17:44:08 fan kernel: [ 1440.427579]  [<ffffffff8140d9fd>] ? _raw_spin_unlock_irqrestore+0xd/0xe
Mar  4 17:44:08 fan kernel: [ 1440.427586]  [<ffffffff8106f79a>] ? try_to_wake_up+0x1cb/0x1dc
Mar  4 17:44:08 fan kernel: [ 1440.427594]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:44:08 fan kernel: [ 1440.427602]  [<ffffffff8140be90>] ? __wait_for_common+0x121/0x16d
Mar  4 17:44:08 fan kernel: [ 1440.427610]  [<ffffffff8106f7f2>] ? wake_up_q+0x3b/0x3b
Mar  4 17:44:08 fan kernel: [ 1440.427664]  [<ffffffffa0468832>] ? btrfs_async_run_delayed_refs+0xbf/0xd5 [btrfs]
Mar  4 17:44:08 fan kernel: [ 1440.427713]  [<ffffffffa047e775>] ? __btrfs_end_transaction+0x291/0x2d5 [btrfs]
Mar  4 17:44:08 fan kernel: [ 1440.427762]  [<ffffffffa04bde2f>] ? relocate_block_group+0x2b8/0x4ab [btrfs]
Mar  4 17:44:08 fan kernel: [ 1440.427811]  [<ffffffffa0493087>] ? btrfs_wait_ordered_roots+0x175/0x191 [btrfs]
Mar  4 17:44:08 fan kernel: [ 1440.427859]  [<ffffffffa04be154>] ? btrfs_relocate_block_group+0x132/0x25a [btrfs]
Mar  4 17:44:08 fan kernel: [ 1440.427909]  [<ffffffffa049d107>] ? btrfs_relocate_chunk.isra.35+0x3c/0xad [btrfs]
Mar  4 17:44:08 fan kernel: [ 1440.427957]  [<ffffffffa049e8f3>] ? btrfs_balance+0xd23/0xd8f [btrfs]
Mar  4 17:44:08 fan kernel: [ 1440.428008]  [<ffffffffa049e9ae>] ? balance_kthread+0x4f/0x6d [btrfs]
Mar  4 17:44:08 fan kernel: [ 1440.428057]  [<ffffffffa049e95f>] ? btrfs_balance+0xd8f/0xd8f [btrfs]
Mar  4 17:44:08 fan kernel: [ 1440.428065]  [<ffffffff81067e59>] ? kthread+0x95/0x9d
Mar  4 17:44:08 fan kernel: [ 1440.428073]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
Mar  4 17:44:08 fan kernel: [ 1440.428080]  [<ffffffff8140e03f>] ? ret_from_fork+0x3f/0x70
Mar  4 17:44:08 fan kernel: [ 1440.428086]  [<ffffffff81067dc4>] ? kthread_parkme+0x16/0x16
