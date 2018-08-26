Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eth2015.qld.adsl.internode.on.net ([150.101.176.226]:59342 "EHLO
        mail.longlandclan.id.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbeHZPmu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Aug 2018 11:42:50 -0400
Received: from [IPv6:2001:44b8:21ac:7053:a64e:31ff:fe53:99cc] (unknown [IPv6:2001:44b8:21ac:7053:a64e:31ff:fe53:99cc])
        by mail.longlandclan.id.au (Postfix) with ESMTPSA id CB6D76C414C
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Aug 2018 21:54:59 +1000 (EST)
To: linux-btrfs@vger.kernel.org
From: Stuart Longland <stuartl@longlandclan.id.au>
Subject: kswapd0 causing deadlocks within btrfs?
Message-ID: <59f22381-20ed-6d53-6431-c6c52b1cd4d3@longlandclan.id.au>
Date: Sun, 26 Aug 2018 21:54:59 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Not sure if anyone's seen this issue before, but I just updated an
embedded system to kernel 4.18.5 and struck this:

[  792.308044]
[  792.309599] ======================================================
[  792.315805] WARNING: possible circular locking dependency detected
[  792.322012] 4.18.5-vrt-ts7670-00032-g00175298ca7b #2 Not tainted
[  792.328033] ------------------------------------------------------
[  792.334228] kswapd0/21 is trying to acquire lock:
[  792.338962] 0792ddef (&delayed_node->mutex){+.+.}, at:
__btrfs_release_delayed_node+0x2c/0x1fc
[  792.347673]
[  792.347673] but task is already holding lock:
[  792.353534] 360a3aad (fs_reclaim){+.+.}, at:
__fs_reclaim_acquire+0x0/0x40
[  792.360508]
[  792.360508] which lock already depends on the new lock.
[  792.360508]
[  792.368709]
[  792.368709] the existing dependency chain (in reverse order) is:
[  792.376205]
[  792.376205] -> #3 (fs_reclaim){+.+.}:
[  792.381416]        kmem_cache_alloc+0x28/0x278
[  792.385892]        btrfs_alloc_inode+0x1c/0x1bc
[  792.390453]        alloc_inode+0x1c/0xa0
[  792.394403]        new_inode_pseudo+0x8/0x40
[  792.398697]        new_inode+0xc/0x20
[  792.402383]        iget5_locked+0x3c/0x74
[  792.406414]        btrfs_iget+0x94/0x808
[  792.410366]        __lookup_free_space_inode+0x1f0/0x234
[  792.415705]        lookup_free_space_inode+0x60/0xe4
[  792.420695]        load_free_space_cache+0x9c/0x1e8
[  792.425606]        cache_block_group+0x258/0x390
[  792.430249]        find_free_extent+0x954/0x1704
[  792.434888]        btrfs_reserve_extent+0xb8/0x288
[  792.439700]        btrfs_alloc_tree_block+0x1e0/0x758
[  792.444775]        __btrfs_cow_block+0x188/0x9b4
[  792.449414]        btrfs_cow_block+0x168/0x318
[  792.453881]        btrfs_search_slot+0x2d4/0xc08
[  792.458523]        btrfs_insert_empty_items+0x70/0xbc
[  792.463597]        btrfs_new_inode+0x350/0x828
[  792.468063]        btrfs_mkdir+0xf4/0x1f8
[  792.472103]        vfs_mkdir+0xd4/0x12c
[  792.475968]        do_mkdirat+0x7c/0xe8
[  792.479829]        ret_fast_syscall+0x0/0x28
[  792.484119]        0xbee7b8b4
[  792.487098]
[  792.487098] -> #2 (&caching_ctl->mutex){+.+.}:
[  792.493099]        mutex_lock_nested+0x1c/0x24
[  792.497571]        cache_block_group+0x24c/0x390
[  792.502212]        find_free_extent+0x954/0x1704
[  792.506852]        btrfs_reserve_extent+0xb8/0x288
[  792.511665]        btrfs_alloc_tree_block+0x1e0/0x758
[  792.516740]        __btrfs_cow_block+0x188/0x9b4
[  792.521378]        btrfs_cow_block+0x168/0x318
[  792.525845]        btrfs_search_slot+0x2d4/0xc08
[  792.530486]        btrfs_insert_empty_items+0x70/0xbc
[  792.535561]        btrfs_new_inode+0x350/0x828
[  792.540025]        btrfs_mkdir+0xf4/0x1f8
[  792.544060]        vfs_mkdir+0xd4/0x12c
[  792.547921]        do_mkdirat+0x7c/0xe8
[  792.551778]        ret_fast_syscall+0x0/0x28
[  792.556065]        0xbee7b8b4
[  792.559044]
[  792.559044] -> #1 (&space_info->groups_sem){++++}:
[  792.565377]        find_free_extent+0xa90/0x1704
[  792.570017]        btrfs_reserve_extent+0xb8/0x288
[  792.574831]        btrfs_alloc_tree_block+0x1e0/0x758
[  792.579904]        __btrfs_cow_block+0x188/0x9b4
[  792.584544]        btrfs_cow_block+0x168/0x318
[  792.589012]        btrfs_search_slot+0x2d4/0xc08
[  792.593658]        btrfs_lookup_inode+0x40/0x198
[  792.598300]        __btrfs_update_delayed_inode+0x90/0x364
[  792.603808]        __btrfs_run_delayed_items+0x178/0x1d8
[  792.609154]        btrfs_commit_transaction+0x200/0xe74
[  792.614406]        transaction_kthread+0x148/0x168
[  792.619229]        kthread+0x120/0x138
[  792.623000]        ret_from_fork+0x14/0x24
[  792.627111]          (null)
[  792.629917]
[  792.629917] -> #0 (&delayed_node->mutex){+.+.}:
[  792.635988]        __mutex_lock+0x58/0x598
[  792.640110]        mutex_lock_nested+0x1c/0x24
[  792.644580]        __btrfs_release_delayed_node+0x2c/0x1fc
[  792.650088]        btrfs_evict_inode+0x2e0/0x65c
[  792.654733]        evict+0xa4/0x174
[  792.658245]        dispose_list+0x34/0x48
[  792.662279]        prune_icache_sb+0x50/0x78
[  792.666585]        super_cache_scan+0x110/0x160
[  792.671152]        shrink_slab.part.11+0x238/0x560
[  792.675972]        shrink_node+0x444/0x4f0
[  792.680092]        kswapd+0x2cc/0x89c
[  792.683780]        kthread+0x120/0x138
[  792.687549]        ret_from_fork+0x14/0x24
[  792.691659]          (null)
[  792.694465]
[  792.694465] other info that might help us debug this:
[  792.694465]
[  792.702489] Chain exists of:
[  792.702489]   &delayed_node->mutex --> &caching_ctl->mutex --> fs_reclaim
[  792.702489]
[  792.713689]  Possible unsafe locking scenario:
[  792.713689]
[  792.719624]        CPU0                    CPU1
[  792.724166]        ----                    ----
[  792.728705]   lock(fs_reclaim);
[  792.731874]                                lock(&caching_ctl->mutex);
[  792.738345]                                lock(fs_reclaim);
[  792.744031]   lock(&delayed_node->mutex);
[  792.748068]
[  792.748068]  *** DEADLOCK ***
[  792.748068]
[  792.754013] 3 locks held by kswapd0/21:
[  792.757859]  #0: 360a3aad (fs_reclaim){+.+.}, at:
__fs_reclaim_acquire+0x0/0x40
[  792.765272]  #1: cb07a2aa (shrinker_rwsem){++++}, at:
shrink_slab.part.11+0x2c/0x560
[  792.773101]  #2: b4e0922c (&type->s_umount_key#21){++++}, at:
trylock_super+0x14/0x58
[  792.781031]
[  792.754013] 3 locks held by kswapd0/21:
[  792.757859]  #0: 360a3aad (fs_reclaim){+.+.}, at:
__fs_reclaim_acquire+0x0/0x40
[  792.765272]  #1: cb07a2aa (shrinker_rwsem){++++}, at:
shrink_slab.part.11+0x2c/0x560
[  792.773101]  #2: b4e0922c (&type->s_umount_key#21){++++}, at:
trylock_super+0x14/0x58
[  792.781031]
[  792.781031] stack backtrace:
[  792.785422] CPU: 0 PID: 21 Comm: kswapd0 Not tainted
4.18.5-vrt-ts7670-00032-g00175298ca7b #2
[  792.793963] Hardware name: Freescale MXS (Device Tree)
[  792.799178] [<c0011190>] (unwind_backtrace) from [<c000f2ec>]
(show_stack+0x10/0x14)
[  792.806984] [<c000f2ec>] (show_stack) from [<c005d294>]
(print_circular_bug.constprop.19+0x260/0x2b8)
[  792.816254] [<c005d294>] (print_circular_bug.constprop.19) from
[<c005b5c0>] (__lock_acquire+0x14dc/0x18c8)
[  792.826035] [<c005b5c0>] (__lock_acquire) from [<c005c2c0>]
(lock_acquire+0xb4/0x1bc)
[  792.833916] [<c005c2c0>] (lock_acquire) from [<c07c2d40>]
(__mutex_lock+0x58/0x598)
[  792.841618] [<c07c2d40>] (__mutex_lock) from [<c07c329c>]
(mutex_lock_nested+0x1c/0x24)
[  792.849667] [<c07c329c>] (mutex_lock_nested) from [<c03e8760>]
(__btrfs_release_delayed_node+0x2c/0x1fc)
[  792.859190] [<c03e8760>] (__btrfs_release_delayed_node) from
[<c03808e0>] (btrfs_evict_inode+0x2e0/0x65c)
[  792.868801] [<c03808e0>] (btrfs_evict_inode) from [<c016d078>]
(evict+0xa4/0x174)
[  792.876325] [<c016d078>] (evict) from [<c016d17c>]
(dispose_list+0x34/0x48)
[  792.883328] [<c016d17c>] (dispose_list) from [<c016e14c>]
(prune_icache_sb+0x50/0x78)
[  792.891206] [<c016e14c>] (prune_icache_sb) from [<c01538c4>]
(super_cache_scan+0x110/0x160)
[  792.899611] [<c01538c4>] (super_cache_scan) from [<c00fe750>]
(shrink_slab.part.11+0x238/0x560)
[  792.908353] [<c00fe750>] (shrink_slab.part.11) from [<c0102dac>]
(shrink_node+0x444/0x4f0)
[  792.916660] [<c0102dac>] (shrink_node) from [<c0103d00>]
(kswapd+0x2cc/0x89c)
[  792.923841] [<c0103d00>] (kswapd) from [<c003b2bc>] (kthread+0x120/0x138)
[  792.930671] [<c003b2bc>] (kthread) from [<c00090b0>]
(ret_from_fork+0x14/0x24)
[  792.937915] Exception stack(0xc76cffb0 to 0xc76cfff8)
[  792.942993] ffa0:                                     00000000
00000000 00000000 00000000
[  792.951202] ffc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  792.959407] ffe0: 00000000 00000000 00000000 00000000 00000013
00000000

Kernel source tree is
https://github.com/vrtsystems/linux/commits/ts7670-4.18.5 in case
someone's wondering where the commit ID came from.  I don't recall
touching anything btrfs or swap related.
-- 
Stuart Longland (aka Redhatter, VK4MSL)

I haven't lost my mind...
  ...it's backed up on a tape somewhere.
