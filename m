Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:48320 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147Ab3DJOeH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 10:34:07 -0400
Received: from [IPv6:2a01:238:e100:320:b86b:8e44:b46a:87d8]
	([2a01:238:e100:320:b86b:8e44:b46a:87d8])
	by smtp.strato.de (jored mo48) (RZmta 31.26 AUTH)
	with ESMTPA id R008c0p3AECTmo for <linux-btrfs@vger.kernel.org>;
	Wed, 10 Apr 2013 16:34:03 +0200 (CEST)
Message-ID: <5165785B.7030407@jan-o-sch.net>
Date: Wed, 10 Apr 2013 16:34:03 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Lockdep warning on for-linus branch (umount vs. evict_inode)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was running fsstress to trigger a tree mod log problem on a current kernel
with some custom debug patches applied, so if anyone looking at this needs any
line numbers let me know:

<4>[ 1221.749586] [ INFO: possible circular locking dependency detected ]
<4>[ 1221.749589] 3.8.0+ #9 Not tainted
<4>[ 1221.749590] -------------------------------------------------------
<4>[ 1221.749591] fsstress/3108 is trying to acquire lock:
<4>[ 1221.749592]  (sb_internal){.+.+..}, at: [<ffffffffa0183cde>] start_transaction+0x2de/0x4f0 [btrfs]
<4>[ 1221.749614] 
<4>[ 1221.749614] but task is already holding lock:
<4>[ 1221.749616]  (&fs_info->ordered_operations_mutex){+.+...}, at: [<ffffffffa019c089>] btrfs_wait_ordered_extents+0x49/0x270 [btrfs]
<4>[ 1221.749632] 
<4>[ 1221.749632] which lock already depends on the new lock.
<4>[ 1221.749632] 
<4>[ 1221.749634] 
<4>[ 1221.749634] the existing dependency chain (in reverse order) is:
<4>[ 1221.749635] 
<4>[ 1221.749635] -> #1 (&fs_info->ordered_operations_mutex){+.+...}:
<4>[ 1221.749638]        [<ffffffff810f1f73>] lock_acquire+0x93/0x130
<4>[ 1221.749643]        [<ffffffff819b5fff>] __mutex_lock_common+0x5f/0x4a0
<4>[ 1221.749647]        [<ffffffff819b6575>] mutex_lock_nested+0x45/0x50
<4>[ 1221.749650]        [<ffffffffa019b935>] btrfs_run_ordered_operations+0x55/0x2e0 [btrfs]
<4>[ 1221.749663]        [<ffffffffa0182866>] btrfs_commit_transaction+0x76/0xd40 [btrfs]
<4>[ 1221.749675]        [<ffffffffa017c3a7>] btrfs_commit_super+0x67/0x130 [btrfs]
<4>[ 1221.749687]        [<ffffffffa017daea>] close_ctree+0x34a/0x3a0 [btrfs]
<4>[ 1221.749699]        [<ffffffffa014fe49>] btrfs_put_super+0x19/0x20 [btrfs]
<4>[ 1221.749707]        [<ffffffff811bed62>] generic_shutdown_super+0x62/0xf0
<4>[ 1221.749710]        [<ffffffff811bee86>] kill_anon_super+0x16/0x30
<4>[ 1221.749712]        [<ffffffffa015396a>] btrfs_kill_super+0x1a/0x90 [btrfs]
<4>[ 1221.749720]        [<ffffffff811bf3a5>] deactivate_locked_super+0x45/0x70
<4>[ 1221.749722]        [<ffffffff811c02aa>] deactivate_super+0x4a/0x70
<4>[ 1221.749725]        [<ffffffff811dbe72>] mntput_no_expire+0xd2/0x130
<4>[ 1221.749728]        [<ffffffff811dcb6e>] sys_umount+0x7e/0x3b0
<4>[ 1221.749730]        [<ffffffff819c0c82>] system_call_fastpath+0x16/0x1b
<4>[ 1221.749734] 
<4>[ 1221.749734] -> #0 (sb_internal){.+.+..}:
<4>[ 1221.749736]        [<ffffffff810f1e03>] __lock_acquire+0x1713/0x17f0
<4>[ 1221.749739]        [<ffffffff810f1f73>] lock_acquire+0x93/0x130
<4>[ 1221.749741]        [<ffffffff811be82f>] __sb_start_write+0x13f/0x230
<4>[ 1221.749745]        [<ffffffffa0183cde>] start_transaction+0x2de/0x4f0 [btrfs]
<4>[ 1221.749757]        [<ffffffffa0183fc7>] btrfs_join_transaction+0x17/0x20 [btrfs]
<4>[ 1221.749770]        [<ffffffffa01d6bf0>] btrfs_commit_inode_delayed_inode+0x60/0x150 [btrfs]
<4>[ 1221.749784]        [<ffffffffa018a240>] btrfs_evict_inode+0x140/0x350 [btrfs]
<4>[ 1221.749798]        [<ffffffff811d6df7>] evict+0xa7/0x1a0
<4>[ 1221.749801]        [<ffffffff811d7008>] iput+0x118/0x1a0
<4>[ 1221.749803]        [<ffffffffa019c286>] btrfs_wait_ordered_extents+0x246/0x270 [btrfs]
<4>[ 1221.749817]        [<ffffffffa0151897>] btrfs_sync_fs+0x47/0x110 [btrfs]
<4>[ 1221.749825]        [<ffffffff811ecaa0>] sync_fs_one_sb+0x20/0x30
<4>[ 1221.749828]        [<ffffffff811c07f6>] iterate_supers+0xb6/0xf0
<4>[ 1221.749831]        [<ffffffff811ecf85>] sys_sync+0x55/0x90
<4>[ 1221.749833]        [<ffffffff819c0c82>] system_call_fastpath+0x16/0x1b
<4>[ 1221.749836] 
<4>[ 1221.749836] other info that might help us debug this:
<4>[ 1221.749836] 
<4>[ 1221.749837]  Possible unsafe locking scenario:
<4>[ 1221.749837] 
<4>[ 1221.749839]        CPU0                    CPU1
<4>[ 1221.749840]        ----                    ----
<4>[ 1221.749841]   lock(&fs_info->ordered_operations_mutex);
<4>[ 1221.749843]                                lock(sb_internal);
<4>[ 1221.749845]                                lock(&fs_info->ordered_operations_mutex);
<4>[ 1221.749846]   lock(sb_internal);
<4>[ 1221.749848] 
<4>[ 1221.749848]  *** DEADLOCK ***
<4>[ 1221.749848] 
<4>[ 1221.749851] 2 locks held by fsstress/3108:
<4>[ 1221.749852]  #0:  (&type->s_umount_key#22){+++++.}, at: [<ffffffff811c07e0>] iterate_supers+0xa0/0xf0
<4>[ 1221.749857]  #1:  (&fs_info->ordered_operations_mutex){+.+...}, at: [<ffffffffa019c089>] btrfs_wait_ordered_extents+0x49/0x270 [btrfs]
<4>[ 1221.749873] 
<4>[ 1221.749873] stack backtrace:
<4>[ 1221.749875] Pid: 3108, comm: fsstress Not tainted 3.8.0+ #9
<4>[ 1221.749876] Call Trace:
<4>[ 1221.749880]  [<ffffffff810ef2be>] print_circular_bug+0x20e/0x2f0
<4>[ 1221.749883]  [<ffffffff810f1e03>] __lock_acquire+0x1713/0x17f0
<4>[ 1221.749896]  [<ffffffffa0183cde>] ? start_transaction+0x2de/0x4f0 [btrfs]
<4>[ 1221.749898]  [<ffffffff810f1f73>] lock_acquire+0x93/0x130
<4>[ 1221.749911]  [<ffffffffa0183cde>] ? start_transaction+0x2de/0x4f0 [btrfs]
<4>[ 1221.749914]  [<ffffffff8116b60d>] ? find_get_pages_tag+0x2d/0x1d0
<4>[ 1221.749918]  [<ffffffff811be82f>] __sb_start_write+0x13f/0x230
<4>[ 1221.749930]  [<ffffffffa0183cde>] ? start_transaction+0x2de/0x4f0 [btrfs]
<4>[ 1221.749943]  [<ffffffffa0183cde>] ? start_transaction+0x2de/0x4f0 [btrfs]
<4>[ 1221.749946]  [<ffffffff811b55b6>] ? kmem_cache_alloc+0x116/0x1d0
<4>[ 1221.749958]  [<ffffffffa0183cde>] start_transaction+0x2de/0x4f0 [btrfs]
<4>[ 1221.749961]  [<ffffffff810f045d>] ? trace_hardirqs_on+0xd/0x10
<4>[ 1221.749974]  [<ffffffffa0183fc7>] btrfs_join_transaction+0x17/0x20 [btrfs]
<4>[ 1221.749988]  [<ffffffffa01d6bf0>] btrfs_commit_inode_delayed_inode+0x60/0x150 [btrfs]
<4>[ 1221.750002]  [<ffffffffa019cb3a>] ? btrfs_wait_ordered_range+0xaa/0x110 [btrfs]
<4>[ 1221.750015]  [<ffffffffa018a240>] btrfs_evict_inode+0x140/0x350 [btrfs]
<4>[ 1221.750019]  [<ffffffff819b934b>] ? _raw_spin_unlock+0x2b/0x60
<4>[ 1221.750021]  [<ffffffff811d6df7>] evict+0xa7/0x1a0
<4>[ 1221.750024]  [<ffffffff811d7008>] iput+0x118/0x1a0
<4>[ 1221.750038]  [<ffffffffa019c286>] btrfs_wait_ordered_extents+0x246/0x270 [btrfs]
<4>[ 1221.750047]  [<ffffffffa0151897>] btrfs_sync_fs+0x47/0x110 [btrfs]
<4>[ 1221.750049]  [<ffffffff811eca80>] ? sys_vmsplice+0x250/0x250
<4>[ 1221.750052]  [<ffffffff811ecaa0>] sync_fs_one_sb+0x20/0x30
<4>[ 1221.750054]  [<ffffffff811c07f6>] iterate_supers+0xb6/0xf0
<4>[ 1221.750056]  [<ffffffff811ecf85>] sys_sync+0x55/0x90
<4>[ 1221.750059]  [<ffffffff819c0c82>] system_call_fastpath+0x16/0x1b
