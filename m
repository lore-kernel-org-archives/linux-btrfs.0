Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48235 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbeF0MHK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 08:07:10 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 677B6AC0D
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 12:07:09 +0000 (UTC)
Date: Wed, 27 Jun 2018 14:06:58 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: fstests/btrfs/011 lockdep warning in 4.18-rc
Message-ID: <20180627120523.GA2287@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've seen the following lockdep warning after the 4.18 merges, it's
probably a cross-subsystem locking issue so I waited some time if this
will not go away after merge window.

Slab shrinker calls evict inode, in parallel there's an unmount in
progress and at some point locks get taken in the wrong order.

[  635.423621] ======================================================
[  635.429802] WARNING: possible circular locking dependency detected
[  635.432211] 4.18.0-rc1-default+ #164 Not tainted
[  635.434006] ------------------------------------------------------
[  635.436888] kswapd0/77 is trying to acquire lock:
[  635.438777] 00000000f6fa0d1f (&delayed_node->mutex){+.+.}, at: __btrfs_release_delayed_node+0x49/0x2b0 [btrfs]
[  635.440579] 
[  635.440579] but task is already holding lock:
[  635.441636] 0000000025dee6ec (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x30
[  635.442851] 
[  635.442851] which lock already depends on the new lock.
[  635.442851] 
[  635.444221] 
[  635.444221] the existing dependency chain (in reverse order) is:
[  635.445398] 
[  635.445398] -> #3 (fs_reclaim){+.+.}:
[  635.446499]        fs_reclaim_acquire.part.111+0x29/0x30
[  635.447332]        kmem_cache_alloc+0x29/0x2b0
[  635.448066]        btrfs_alloc_inode+0x24/0x260 [btrfs]
[  635.448889]        alloc_inode+0x18/0x80
[  635.449549]        new_inode_pseudo+0xc/0x60
[  635.450304]        new_inode+0x12/0x30
[  635.451601]        iget5_locked+0xb1/0xf0
[  635.452524]        btrfs_iget+0x57/0xf0 [btrfs]
[  635.453276]        __lookup_free_space_inode+0xd8/0x150 [btrfs]
[  635.454205]        lookup_free_space_inode+0x63/0xc0 [btrfs]
[  635.455058]        load_free_space_cache+0x6e/0x190 [btrfs]
[  635.455949]        cache_block_group+0x1c6/0x460 [btrfs]
[  635.456793]        find_free_extent+0x889/0x14e0 [btrfs]
[  635.457640]        btrfs_reserve_extent+0x9b/0x180 [btrfs]
[  635.458463]        btrfs_alloc_tree_block+0x1e8/0x440 [btrfs]
[  635.459204]        __btrfs_cow_block+0x109/0x700 [btrfs]
[  635.460124]        btrfs_cow_block+0x129/0x2f0 [btrfs]
[  635.460938]        btrfs_search_slot+0x22f/0xa70 [btrfs]
[  635.461977]        btrfs_lookup_inode+0x3a/0xc0 [btrfs]
[  635.463158]        __btrfs_update_delayed_inode+0x75/0x270 [btrfs]
[  635.464032]        __btrfs_run_delayed_items+0x147/0x1d0 [btrfs]
[  635.464825]        btrfs_commit_transaction+0x18a/0x9e0 [btrfs]
[  635.465737]        sync_filesystem+0x6b/0x90
[  635.466439]        generic_shutdown_super+0x22/0x100
[  635.467229]        kill_anon_super+0xe/0x20
[  635.467994]        btrfs_kill_super+0x12/0xa0 [btrfs]
[  635.468827]        deactivate_locked_super+0x29/0x60
[  635.469622]        cleanup_mnt+0x3b/0x70
[  635.470363]        task_work_run+0x9b/0xd0
[  635.471479]        exit_to_usermode_loop+0xbb/0xc0
[  635.472519]        do_syscall_64+0x16c/0x170
[  635.473329]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  635.474309] 
[  635.474309] -> #2 (&caching_ctl->mutex){+.+.}:
[  635.475430]        __mutex_lock+0x86/0x9c0
[  635.476206]        cache_block_group+0x1bb/0x460 [btrfs]
[  635.477152]        find_free_extent+0x889/0x14e0 [btrfs]
[  635.478101]        btrfs_reserve_extent+0x9b/0x180 [btrfs]
[  635.479074]        btrfs_alloc_tree_block+0x1e8/0x440 [btrfs]
[  635.480081]        __btrfs_cow_block+0x109/0x700 [btrfs]
[  635.481028]        btrfs_cow_block+0x129/0x2f0 [btrfs]
[  635.482020]        btrfs_search_slot+0x22f/0xa70 [btrfs]
[  635.482733]        btrfs_insert_empty_items+0x67/0xc0 [btrfs]
[  635.483459]        btrfs_uuid_tree_add+0x1d2/0x2e0 [btrfs]
[  635.484158]        btrfs_uuid_scan_kthread+0x159/0x340 [btrfs]
[  635.484880]        kthread+0x11b/0x140
[  635.485443]        ret_from_fork+0x24/0x30
[  635.486075] 
[  635.486075] -> #1 (&space_info->groups_sem){++++}:
[  635.486931]        down_read+0x3b/0x60
[  635.487456]        find_free_extent+0x992/0x14e0 [btrfs]
[  635.488137]        btrfs_reserve_extent+0x9b/0x180 [btrfs]
[  635.488833]        btrfs_alloc_tree_block+0x1e8/0x440 [btrfs]
[  635.489639]        __btrfs_cow_block+0x109/0x700 [btrfs]
[  635.490440]        btrfs_cow_block+0x129/0x2f0 [btrfs]
[  635.491102]        btrfs_search_slot+0x22f/0xa70 [btrfs]
[  635.491782]        btrfs_insert_empty_items+0x67/0xc0 [btrfs]
[  635.492508]        btrfs_insert_delayed_items+0x86/0x490 [btrfs]
[  635.493305]        __btrfs_run_delayed_items+0x96/0x1d0 [btrfs]
[  635.494200]        btrfs_commit_transaction+0x297/0x9e0 [btrfs]
[  635.494989]        btrfs_mksubvol+0x4e8/0x530 [btrfs]
[  635.495651]        btrfs_ioctl_snap_create_transid+0x170/0x180 [btrfs]
[  635.496458]        btrfs_ioctl_snap_create_v2+0x124/0x180 [btrfs]
[  635.497224]        btrfs_ioctl+0xc35/0x31a0 [btrfs]
[  635.498003]        do_vfs_ioctl+0xa2/0x6b0
[  635.498680]        ksys_ioctl+0x3a/0x70
[  635.499331]        __x64_sys_ioctl+0x16/0x20
[  635.500032]        do_syscall_64+0x5a/0x170
[  635.500715]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  635.501574] 
[  635.501574] -> #0 (&delayed_node->mutex){+.+.}:
[  635.502470]        lock_acquire+0x9e/0x1d0
[  635.503018]        __mutex_lock+0x86/0x9c0
[  635.503581]        __btrfs_release_delayed_node+0x49/0x2b0 [btrfs]
[  635.504352]        btrfs_evict_inode+0x24e/0x5f0 [btrfs]
[  635.505022]        evict+0xcd/0x190
[  635.505515]        dispose_list+0x51/0x80
[  635.506056]        prune_icache_sb+0x52/0x70
[  635.506622]        super_cache_scan+0x123/0x1a0
[  635.507213]        shrink_slab.part.50+0x1c0/0x580
[  635.507831]        shrink_node+0x2f2/0x340
[  635.508379]        balance_pgdat+0x1dc/0x310
[  635.508944]        kswapd+0x195/0x540
[  635.509511]        kthread+0x11b/0x140
[  635.510132]        ret_from_fork+0x24/0x30
[  635.510790] 
[  635.510790] other info that might help us debug this:
[  635.510790] 
[  635.512112] Chain exists of:
[  635.512112]   &delayed_node->mutex --> &caching_ctl->mutex --> fs_reclaim
[  635.512112] 
[  635.513826]  Possible unsafe locking scenario:
[  635.513826] 
[  635.514799]        CPU0                    CPU1
[  635.515501]        ----                    ----
[  635.516211]   lock(fs_reclaim);
[  635.516741]                                lock(&caching_ctl->mutex);
[  635.517662]                                lock(fs_reclaim);
[  635.518498]   lock(&delayed_node->mutex);
[  635.519158] 
[  635.519158]  *** DEADLOCK ***
[  635.519158] 
[  635.520211] 3 locks held by kswapd0/77:
[  635.520831]  #0: 0000000025dee6ec (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x30
[  635.522092]  #1: 000000009cc3bd11 (shrinker_rwsem){++++}, at: shrink_slab.part.50+0x40/0x580
[  635.523308]  #2: 00000000e9e0ce72 (&type->s_umount_key#26){++++}, at: trylock_super+0x16/0x50
[  635.524387] 
[  635.524387] stack backtrace:
[  635.525055] CPU: 1 PID: 77 Comm: kswapd0 Not tainted 4.18.0-rc1-default+ #164
[  635.526078] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[  635.527360] Call Trace:
[  635.527753]  dump_stack+0x85/0xc0
[  635.528228]  print_circular_bug.isra.36.cold.52+0x15c/0x195
[  635.528925]  check_prev_add.constprop.43+0x529/0x780
[  635.529564]  ? unwind_next_frame+0x54/0x430
[  635.530126]  __lock_acquire+0x9f4/0xf60
[  635.530652]  lock_acquire+0x9e/0x1d0
[  635.531519]  ? __btrfs_release_delayed_node+0x49/0x2b0 [btrfs]
[  635.532416]  ? __btrfs_release_delayed_node+0x49/0x2b0 [btrfs]
[  635.533292]  __mutex_lock+0x86/0x9c0
[  635.533900]  ? __btrfs_release_delayed_node+0x49/0x2b0 [btrfs]
[  635.534770]  ? __lock_acquire+0x9f4/0xf60
[  635.535428]  ? __btrfs_release_delayed_node+0x49/0x2b0 [btrfs]
[  635.536314]  __btrfs_release_delayed_node+0x49/0x2b0 [btrfs]
[  635.537178]  btrfs_evict_inode+0x24e/0x5f0 [btrfs]
[  635.537921]  evict+0xcd/0x190
[  635.538441]  dispose_list+0x51/0x80
[  635.539009]  prune_icache_sb+0x52/0x70
[  635.539613]  super_cache_scan+0x123/0x1a0
[  635.540251]  shrink_slab.part.50+0x1c0/0x580
[  635.540867]  shrink_node+0x2f2/0x340
[  635.541441]  balance_pgdat+0x1dc/0x310
[  635.542040]  kswapd+0x195/0x540
[  635.542530]  ? __schedule+0x306/0x940
[  635.543039]  ? finish_wait+0x80/0x80
[  635.543539]  ? balance_pgdat+0x310/0x310
[  635.544073]  kthread+0x11b/0x140
[  635.544540]  ? kthread_create_worker_on_cpu+0x70/0x70
[  635.545188]  ret_from_fork+0x24/0x30
