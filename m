Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933103AbaCQNFs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 09:05:48 -0400
Date: Mon, 17 Mar 2014 14:05:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: btrfs: lock inversion between delayed_node->mutex and
 found->groups_sem
Message-ID: <20140317130546.GE29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53239AE0.8030306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53239AE0.8030306@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 14, 2014 at 08:12:16PM -0400, Sasha Levin wrote:
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following:
> 
> [  788.458756]        CPU0                    CPU1
> [  788.459188]        ----                    ----
> [  788.459625]   lock(&found->groups_sem);
> [  788.460041]                                local_irq_disable();
> [  788.460041]                                lock(&delayed_node->mutex);
> [  788.460041]                                lock(&found->groups_sem);
> [  788.460041]   <Interrupt>
> [  788.460041]     lock(&delayed_node->mutex);
> [  788.460041]
> [  788.460041]  *** DEADLOCK ***
> [  788.460041]
> [  788.460041] 2 locks held by kswapd3/4199:

I've once (3.14-rc5) seen the same warning also caused by xfstests/generic/224

2 locks held by 224/31203:
 #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8113be6d>] shrink_slab+0x3d/0x110
 #1:  (&type->s_umount_key#32){++++++}, at: [<ffffffff8117cd84>] grab_super_passive+0x44/0x90

the shortest dependencies between 2nd lock and 1st lock:
 -> (&found->groups_sem){+++++.} ops: 405561 {
    HARDIRQ-ON-W at:
                      [<ffffffff810af476>] __lock_acquire+0x7f6/0x1fb0
                      [<ffffffff810b12e2>] lock_acquire+0x92/0x120
                      [<ffffffff81a01d3c>] down_write+0x5c/0xc0
                      [<ffffffffa001f6a6>] __link_block_group+0x46/0x130 [btrfs]
                      [<ffffffffa0023411>] btrfs_read_block_groups+0x341/0x690 [btrfs]
                      [<ffffffffa0031c50>] open_ctree+0x1880/0x2310 [btrfs]
                      [<ffffffffa00065db>] btrfs_mount+0x55b/0x860 [btrfs]
                      [<ffffffff8117d6f0>] mount_fs+0x20/0xe0
                      [<ffffffff81199ab6>] vfs_kern_mount+0x76/0x160
                      [<ffffffff8119c25d>] do_mount+0x31d/0x970
                      [<ffffffff8119cc30>] SyS_mount+0x90/0xe0
                      [<ffffffff81a0ca92>] system_call_fastpath+0x16/0x1b
    HARDIRQ-ON-R at:
                      [<ffffffff810af265>] __lock_acquire+0x5e5/0x1fb0
                      [<ffffffff810b12e2>] lock_acquire+0x92/0x120
                      [<ffffffff81a01c8c>] down_read+0x4c/0xa0
                      [<ffffffffa002da32>] btrfs_calc_num_tolerated_disk_barrier_failures+0x142/0x240 [btrfs]
                      [<ffffffffa0031c6e>] open_ctree+0x189e/0x2310 [btrfs]
                      [<ffffffffa00065db>] btrfs_mount+0x55b/0x860 [btrfs]
                      [<ffffffff8117d6f0>] mount_fs+0x20/0xe0
                      [<ffffffff81199ab6>] vfs_kern_mount+0x76/0x160
                      [<ffffffff8119c25d>] do_mount+0x31d/0x970
                      [<ffffffff8119cc30>] SyS_mount+0x90/0xe0
                      [<ffffffff81a0ca92>] system_call_fastpath+0x16/0x1b
    SOFTIRQ-ON-W at:
                      [<ffffffff810af4aa>] __lock_acquire+0x82a/0x1fb0
                      [<ffffffff810b12e2>] lock_acquire+0x92/0x120
                      [<ffffffff81a01d3c>] down_write+0x5c/0xc0
                      [<ffffffffa001f6a6>] __link_block_group+0x46/0x130 [btrfs]
                      [<ffffffffa0023411>] btrfs_read_block_groups+0x341/0x690 [btrfs]
                      [<ffffffffa0031c50>] open_ctree+0x1880/0x2310 [btrfs]
                      [<ffffffffa00065db>] btrfs_mount+0x55b/0x860 [btrfs]
                      [<ffffffff8117d6f0>] mount_fs+0x20/0xe0
                      [<ffffffff81199ab6>] vfs_kern_mount+0x76/0x160
                      [<ffffffff8119c25d>] do_mount+0x31d/0x970
                      [<ffffffff8119cc30>] SyS_mount+0x90/0xe0
                      [<ffffffff81a0ca92>] system_call_fastpath+0x16/0x1b
    SOFTIRQ-ON-R at:
                      [<ffffffff810af4aa>] __lock_acquire+0x82a/0x1fb0
                      [<ffffffff810b12e2>] lock_acquire+0x92/0x120
                      [<ffffffff81a01c8c>] down_read+0x4c/0xa0
                      [<ffffffffa002da32>] btrfs_calc_num_tolerated_disk_barrier_failures+0x142/0x240 [btrfs]
                      [<ffffffffa0031c6e>] open_ctree+0x189e/0x2310 [btrfs]
                      [<ffffffffa00065db>] btrfs_mount+0x55b/0x860 [btrfs]
                      [<ffffffff8117d6f0>] mount_fs+0x20/0xe0
                      [<ffffffff81199ab6>] vfs_kern_mount+0x76/0x160
                      [<ffffffff8119c25d>] do_mount+0x31d/0x970
                      [<ffffffff8119cc30>] SyS_mount+0x90/0xe0
                      [<ffffffff81a0ca92>] system_call_fastpath+0x16/0x1b
    RECLAIM_FS-ON-W at:
                         [<ffffffff810b1c6c>] mark_held_locks+0x8c/0x170
                         [<ffffffff810b249a>] lockdep_trace_alloc+0x8a/0xd0
                         [<ffffffff8116f807>] __kmalloc_track_caller+0x47/0x210
                         [<ffffffff813cdefb>] kvasprintf+0x5b/0x90
                         [<ffffffff813c166a>] kobject_set_name_vargs+0x2a/0x70
                         [<ffffffff813c1ffa>] kobject_add+0x5a/0xb0
                         [<ffffffffa001f75d>] __link_block_group+0xfd/0x130 [btrfs]
                         [<ffffffffa0023411>] btrfs_read_block_groups+0x341/0x690 [btrfs]
                         [<ffffffffa0031c50>] open_ctree+0x1880/0x2310 [btrfs]
                         [<ffffffffa00065db>] btrfs_mount+0x55b/0x860 [btrfs]
                         [<ffffffff8117d6f0>] mount_fs+0x20/0xe0
                         [<ffffffff81199ab6>] vfs_kern_mount+0x76/0x160
                         [<ffffffff8119c25d>] do_mount+0x31d/0x970
                         [<ffffffff8119cc30>] SyS_mount+0x90/0xe0
                         [<ffffffff81a0ca92>] system_call_fastpath+0x16/0x1b
    INITIAL USE at:
                     [<ffffffff810aefd4>] __lock_acquire+0x354/0x1fb0
                     [<ffffffff810b12e2>] lock_acquire+0x92/0x120
                     [<ffffffff81a01d3c>] down_write+0x5c/0xc0
                     [<ffffffffa001f6a6>] __link_block_group+0x46/0x130 [btrfs]
                     [<ffffffffa0023411>] btrfs_read_block_groups+0x341/0x690 [btrfs]
                     [<ffffffffa0031c50>] open_ctree+0x1880/0x2310 [btrfs]
                     [<ffffffffa00065db>] btrfs_mount+0x55b/0x860 [btrfs]
                     [<ffffffff8117d6f0>] mount_fs+0x20/0xe0
                     [<ffffffff81199ab6>] vfs_kern_mount+0x76/0x160
                     [<ffffffff8119c25d>] do_mount+0x31d/0x970
                     [<ffffffff8119cc30>] SyS_mount+0x90/0xe0
                     [<ffffffff81a0ca92>] system_call_fastpath+0x16/0x1b
  }
  ... key      at: [<ffffffffa00d06e0>] __key.40139+0x0/0xfffffffffffe2920 [btrfs]
  ... acquired at:
   [<ffffffff810b12e2>] lock_acquire+0x92/0x120
   [<ffffffff81a01c8c>] down_read+0x4c/0xa0
   [<ffffffffa001ff78>] find_free_extent+0x7e8/0xbe0 [btrfs]
   [<ffffffffa0020434>] btrfs_reserve_extent+0xa4/0x130 [btrfs]
   [<ffffffffa0021903>] btrfs_alloc_free_block+0x103/0x4c0 [btrfs]
   [<ffffffffa000beb4>] __btrfs_cow_block+0x124/0x550 [btrfs]
   [<ffffffffa000c4ab>] btrfs_cow_block+0x12b/0x1e0 [btrfs]
   [<ffffffffa0010429>] btrfs_search_slot+0x1d9/0xa00 [btrfs]
   [<ffffffffa00123de>] btrfs_insert_empty_items+0x7e/0xe0 [btrfs]
   [<ffffffffa008a7a4>] btrfs_insert_delayed_items+0x84/0x460 [btrfs]
   [<ffffffffa008b299>] __btrfs_run_delayed_items+0xd9/0x1f0 [btrfs]
   [<ffffffffa008b7a3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
   [<ffffffffa0034e6e>] btrfs_commit_transaction+0x3ae/0xa30 [btrfs]
   [<ffffffffa006ae72>] btrfs_mksubvol+0x3a2/0x3b0 [btrfs]
   [<ffffffffa006b036>] btrfs_ioctl_snap_create_transid+0x1b6/0x1c0 [btrfs]
   [<ffffffffa006b1be>] btrfs_ioctl_snap_create_v2+0xfe/0x140 [btrfs]
   [<ffffffffa006d1d2>] btrfs_ioctl+0x652/0x1940 [btrfs]
   [<ffffffff8118c0a1>] do_vfs_ioctl+0x91/0x560
   [<ffffffff8118c5c7>] SyS_ioctl+0x57/0x90
   [<ffffffff81a0ca92>] system_call_fastpath+0x16/0x1b

-> (&delayed_node->mutex){+.+.-.} ops: 8191147 {
   HARDIRQ-ON-W at:
                    [<ffffffff810af476>] __lock_acquire+0x7f6/0x1fb0
                    [<ffffffff810b12e2>] lock_acquire+0x92/0x120
                    [<ffffffff81a00c4e>] mutex_lock_nested+0x6e/0x3a0
                    [<ffffffffa008c5c9>] btrfs_delayed_update_inode+0x49/0x670 [btrfs]
                    [<ffffffffa003b76a>] btrfs_update_inode+0x6a/0x100 [btrfs]
                    [<ffffffffa0043e8e>] btrfs_create+0x16e/0x220 [btrfs]
                    [<ffffffff81188979>] vfs_create+0x89/0xc0
                    [<ffffffff81189144>] do_last+0x794/0xd50
                    [<ffffffff811897c7>] path_openat+0xc7/0x620
                    [<ffffffff8118a1da>] do_filp_open+0x4a/0xa0
                    [<ffffffff8117883e>] do_sys_open+0x11e/0x230
                    [<ffffffff8117896e>] SyS_open+0x1e/0x20
                    [<ffffffff81a0ca92>] system_call_fastpath+0x16/0x1b
   SOFTIRQ-ON-W at:
                    [<ffffffff810af4aa>] __lock_acquire+0x82a/0x1fb0
                    [<ffffffff810b12e2>] lock_acquire+0x92/0x120
                    [<ffffffff81a00c4e>] mutex_lock_nested+0x6e/0x3a0
                    [<ffffffffa008c5c9>] btrfs_delayed_update_inode+0x49/0x670 [btrfs]
                    [<ffffffffa003b76a>] btrfs_update_inode+0x6a/0x100 [btrfs]
                    [<ffffffffa0043e8e>] btrfs_create+0x16e/0x220 [btrfs]
                    [<ffffffff81188979>] vfs_create+0x89/0xc0
                    [<ffffffff81189144>] do_last+0x794/0xd50
                    [<ffffffff811897c7>] path_openat+0xc7/0x620
                    [<ffffffff8118a1da>] do_filp_open+0x4a/0xa0
                    [<ffffffff8117883e>] do_sys_open+0x11e/0x230
                    [<ffffffff8117896e>] SyS_open+0x1e/0x20
                    [<ffffffff81a0ca92>] system_call_fastpath+0x16/0x1b
   IN-RECLAIM_FS-W at:
                       [<ffffffff810af2ec>] __lock_acquire+0x66c/0x1fb0
                       [<ffffffff810b12e2>] lock_acquire+0x92/0x120
                       [<ffffffff81a00c4e>] mutex_lock_nested+0x6e/0x3a0
                       [<ffffffffa0089dff>] __btrfs_release_delayed_node+0x4f/0x220 [btrfs]
                       [<ffffffffa008bac4>] btrfs_remove_delayed_node+0x24/0x30 [btrfs]
                       [<ffffffffa0040c97>] btrfs_evict_inode+0x2a7/0x550 [btrfs]
                       [<ffffffff81195188>] evict+0xb8/0x1c0
                       [<ffffffff811952df>] dispose_list+0x4f/0x60
                       [<ffffffff811963dc>] prune_icache_sb+0x4c/0x60
                       [<ffffffff8117d006>] super_cache_scan+0x126/0x190
                       [<ffffffff8113a1fe>] shrink_slab_node+0x14e/0x2c0
                       [<ffffffff8113bea8>] shrink_slab+0x78/0x110
                       [<ffffffff8113f1bd>] do_try_to_free_pages+0x24d/0x410
                       [<ffffffff8113f554>] try_to_free_pages+0xe4/0x190
                       [<ffffffff8113235b>] __alloc_pages_nodemask+0x68b/0xa60
                       [<ffffffff8116edac>] cache_alloc_refill+0x40c/0x7b0
                       [<ffffffff8116e98f>] kmem_cache_alloc+0x1ef/0x200
                       [<ffffffff8105efae>] copy_process+0x13e/0x1910
                       [<ffffffff810608a5>] do_fork+0x65/0x300
                       [<ffffffff81060bc6>] SyS_clone+0x16/0x20
                       [<ffffffff81a0cdb9>] stub_clone+0x69/0x90
   INITIAL USE at:
                   [<ffffffff810aefd4>] __lock_acquire+0x354/0x1fb0
                   [<ffffffff810b12e2>] lock_acquire+0x92/0x120
                   [<ffffffff81a00c4e>] mutex_lock_nested+0x6e/0x3a0
                   [<ffffffffa008c5c9>] btrfs_delayed_update_inode+0x49/0x670 [btrfs]
                   [<ffffffffa003b76a>] btrfs_update_inode+0x6a/0x100 [btrfs]
                   [<ffffffffa0043e8e>] btrfs_create+0x16e/0x220 [btrfs]
                   [<ffffffff81188979>] vfs_create+0x89/0xc0
                   [<ffffffff81189144>] do_last+0x794/0xd50
                   [<ffffffff811897c7>] path_openat+0xc7/0x620
                   [<ffffffff8118a1da>] do_filp_open+0x4a/0xa0
                   [<ffffffff8117883e>] do_sys_open+0x11e/0x230
                   [<ffffffff8117896e>] SyS_open+0x1e/0x20
                   [<ffffffff81a0ca92>] system_call_fastpath+0x16/0x1b
 }
 ... key      at: [<ffffffffa00d4648>] __key.35416+0x0/0xfffffffffffde9b8 [btrfs]
 ... acquired at:
   [<ffffffff810add8a>] check_usage_forwards+0xaa/0x120
   [<ffffffff810ae9f9>] mark_lock+0x1a9/0x430
   [<ffffffff810af2ec>] __lock_acquire+0x66c/0x1fb0
   [<ffffffff810b12e2>] lock_acquire+0x92/0x120
   [<ffffffff81a00c4e>] mutex_lock_nested+0x6e/0x3a0
   [<ffffffffa0089dff>] __btrfs_release_delayed_node+0x4f/0x220 [btrfs]
   [<ffffffffa008bac4>] btrfs_remove_delayed_node+0x24/0x30 [btrfs]
   [<ffffffffa0040c97>] btrfs_evict_inode+0x2a7/0x550 [btrfs]
   [<ffffffff81195188>] evict+0xb8/0x1c0
   [<ffffffff811952df>] dispose_list+0x4f/0x60
   [<ffffffff811963dc>] prune_icache_sb+0x4c/0x60
   [<ffffffff8117d006>] super_cache_scan+0x126/0x190
   [<ffffffff8113a1fe>] shrink_slab_node+0x14e/0x2c0
   [<ffffffff8113bea8>] shrink_slab+0x78/0x110
   [<ffffffff8113f1bd>] do_try_to_free_pages+0x24d/0x410
   [<ffffffff8113f554>] try_to_free_pages+0xe4/0x190
   [<ffffffff8113235b>] __alloc_pages_nodemask+0x68b/0xa60
   [<ffffffff8116edac>] cache_alloc_refill+0x40c/0x7b0
   [<ffffffff8116e98f>] kmem_cache_alloc+0x1ef/0x200
   [<ffffffff8105efae>] copy_process+0x13e/0x1910
   [<ffffffff810608a5>] do_fork+0x65/0x300
   [<ffffffff81060bc6>] SyS_clone+0x16/0x20
   [<ffffffff81a0cdb9>] stub_clone+0x69/0x90


stack backtrace:
CPU: 1 PID: 31203 Comm: 224 Tainted: G        W    3.14.0-rc5-default #121
Hardware name: Intel Corporation Santa Rosa platform/Matanzas, BIOS TSRSCRB1.86C.0047.B00.0610170821 10/17/06
 ffffffff82c37220 ffff88003faa9460 ffffffff819fd463 0000000000000002
 ffffffff82c37220 ffff88003faa94b0 ffffffff810adc97 ffff88003faa9500
 ffffffff81f16ba4 ffff88003faa94cc ffff88003faa5730 ffff88003faa94c0
Call Trace:
 [<ffffffff819fd463>] dump_stack+0x51/0x6e
 [<ffffffff810adc97>] print_irq_inversion_bug+0x1c7/0x210
 [<ffffffff810add8a>] check_usage_forwards+0xaa/0x120
 [<ffffffff810adce0>] ? print_irq_inversion_bug+0x210/0x210
 [<ffffffff810ae9f9>] mark_lock+0x1a9/0x430
 [<ffffffff810af2ec>] __lock_acquire+0x66c/0x1fb0
 [<ffffffff810adce0>] ? print_irq_inversion_bug+0x210/0x210
 [<ffffffff810ae4cf>] ? check_irq_usage+0x9f/0xf0
 [<ffffffff810b002b>] ? __lock_acquire+0x13ab/0x1fb0
 [<ffffffff810ab11d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffffa0089dff>] ? __btrfs_release_delayed_node+0x4f/0x220 [btrfs]
 [<ffffffff810b12e2>] lock_acquire+0x92/0x120
 [<ffffffffa0089dff>] ? __btrfs_release_delayed_node+0x4f/0x220 [btrfs]
 [<ffffffff81a00c4e>] mutex_lock_nested+0x6e/0x3a0
 [<ffffffffa0089dff>] ? __btrfs_release_delayed_node+0x4f/0x220 [btrfs]
 [<ffffffff8109a138>] ? sched_clock_cpu+0xa8/0xd0
 [<ffffffffa0089dff>] ? __btrfs_release_delayed_node+0x4f/0x220 [btrfs]
 [<ffffffff810ab62d>] ? lock_release_holdtime+0x3d/0x1c0
 [<ffffffffa0089dff>] __btrfs_release_delayed_node+0x4f/0x220 [btrfs]
 [<ffffffffa008bac4>] btrfs_remove_delayed_node+0x24/0x30 [btrfs]
 [<ffffffffa0040c97>] btrfs_evict_inode+0x2a7/0x550 [btrfs]
 [<ffffffff81a03c6b>] ? _raw_spin_unlock+0x2b/0x40
 [<ffffffff81195188>] evict+0xb8/0x1c0
 [<ffffffff81195ed0>] ? insert_inode_locked+0x1a0/0x1a0
 [<ffffffff811952df>] dispose_list+0x4f/0x60
 [<ffffffff811963dc>] prune_icache_sb+0x4c/0x60
 [<ffffffff8117d006>] super_cache_scan+0x126/0x190
 [<ffffffff8113a1fe>] shrink_slab_node+0x14e/0x2c0
 [<ffffffff8109a176>] ? local_clock+0x16/0x30
 [<ffffffff8113bea8>] shrink_slab+0x78/0x110
 [<ffffffff8113f1bd>] do_try_to_free_pages+0x24d/0x410
 [<ffffffff8113f554>] try_to_free_pages+0xe4/0x190
 [<ffffffff8113235b>] __alloc_pages_nodemask+0x68b/0xa60
 [<ffffffff8116ed6e>] ? cache_alloc_refill+0x3ce/0x7b0
 [<ffffffff8116edac>] cache_alloc_refill+0x40c/0x7b0
 [<ffffffff8105efae>] ? copy_process+0x13e/0x1910
 [<ffffffff8116e98f>] kmem_cache_alloc+0x1ef/0x200
 [<ffffffff8105efae>] copy_process+0x13e/0x1910
 [<ffffffff8109a138>] ? sched_clock_cpu+0xa8/0xd0
 [<ffffffff8109a176>] ? local_clock+0x16/0x30
 [<ffffffff810ab62d>] ? lock_release_holdtime+0x3d/0x1c0
 [<ffffffff810b0fc5>] ? lock_release_non_nested+0x395/0x3e0
 [<ffffffff8114fd86>] ? might_fault+0x66/0xc0
 [<ffffffff810608a5>] do_fork+0x65/0x300
 [<ffffffff8114fd86>] ? might_fault+0x66/0xc0
 [<ffffffff81a0cab7>] ? sysret_check+0x1b/0x56
 [<ffffffff81060bc6>] SyS_clone+0x16/0x20
 [<ffffffff81a0cdb9>] stub_clone+0x69/0x90
 [<ffffffff81a0ca92>] ? system_call_fastpath+0x16/0x1b
