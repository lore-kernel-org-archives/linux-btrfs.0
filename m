Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24159 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756017AbcDLH3N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 03:29:13 -0400
To: btrfs <linux-btrfs@vger.kernel.org>
CC: <jmaggard10@gmail.com>, <fdmanana@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Lockdep warning when running btrfs/114
Message-ID: <570CA24D.4040804@cn.fujitsu.com>
Date: Tue, 12 Apr 2016 15:22:53 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

When debugging the qgroup problem, I found the following lockdep warning 
outputted when running btrfs/114.
It seems to be more easy to trigger if run all qgroup tests in a row.
(-g qgroup)

The source is integration-4.6 branch *WITHOUT* my qgroup fix patch 
v2(not submitted yet).

Just post this out as it seems to be related to a lot of infrastructures 
like delayed_inode, delayed_refs, backref and qgroups.

Maybe some one has better idea of what's going wrong, and can fix it faster.

Thanks,
Qu

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
4.5.0-rc6+ #6 Tainted: G           O
---------------------------------------------------------
kswapd0/546 just changed the state of lock:
  (&delayed_node->mutex){+.+.-.}, at: [<ffffffffa0568d1a>] 
__btrfs_release_delayed_node+0x3a/0x200 [btrfs]
but this lock took another, RECLAIM_FS-unsafe lock in the past:
  (pcpu_alloc_mutex){+.+.+.}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
Chain exists of:
   &delayed_node->mutex --> &found->groups_sem --> pcpu_alloc_mutex

  Possible interrupt unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(pcpu_alloc_mutex);
                                local_irq_disable();
                                lock(&delayed_node->mutex);
                                lock(&found->groups_sem);
   <Interrupt>
     lock(&delayed_node->mutex);

  *** DEADLOCK ***

2 locks held by kswapd0/546:
  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff811c865d>] 
shrink_slab.part.63.constprop.82+0x3d/0x500
  #1:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff812198c6>] 
trylock_super+0x16/0x50

the shortest dependencies between 2nd lock and 1st lock:
    -> (pcpu_alloc_mutex){+.+.+.} ops: 1201 {
       HARDIRQ-ON-W at:
                           [<ffffffff81108c46>] __lock_acquire+0xb46/0x1cf0
                           [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                           [<ffffffff81810901>] mutex_lock_nested+0x71/0x3b0
                           [<ffffffff811d8f9e>] pcpu_alloc+0x42e/0x620
                           [<ffffffff811d91b0>] __alloc_percpu+0x10/0x20
                           [<ffffffff8120e33b>] 
__kmem_cache_create+0x36b/0x4c0
                           [<ffffffff811da87f>] 
kmem_cache_create+0x11f/0x220
                           [<ffffffff8212cad9>] 
debug_objects_mem_init+0x30/0x1ec
                           [<ffffffff820f3f6a>] start_kernel+0x3ca/0x491
                           [<ffffffff820f35ad>] 
x86_64_start_reservations+0x2a/0x2c
                           [<ffffffff820f3699>] 
x86_64_start_kernel+0xea/0xed
       SOFTIRQ-ON-W at:
                           [<ffffffff81108af7>] __lock_acquire+0x9f7/0x1cf0
                           [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                           [<ffffffff81810901>] mutex_lock_nested+0x71/0x3b0
                           [<ffffffff811d8f9e>] pcpu_alloc+0x42e/0x620
                           [<ffffffff811d91b0>] __alloc_percpu+0x10/0x20
                           [<ffffffff8120e33b>] 
__kmem_cache_create+0x36b/0x4c0
                           [<ffffffff811da87f>] 
kmem_cache_create+0x11f/0x220
                           [<ffffffff8212cad9>] 
debug_objects_mem_init+0x30/0x1ec
                           [<ffffffff820f3f6a>] start_kernel+0x3ca/0x491
                           [<ffffffff820f35ad>] 
x86_64_start_reservations+0x2a/0x2c
                           [<ffffffff820f3699>] 
x86_64_start_kernel+0xea/0xed
       RECLAIM_FS-ON-W at:
                              [<ffffffff81106e81>] mark_held_locks+0x71/0x90
                              [<ffffffff811078e1>] 
lockdep_trace_alloc+0xb1/0x100
                              [<ffffffff8120b8be>] __kmalloc+0x4e/0x280
                              [<ffffffff811d8592>] pcpu_mem_zalloc+0x32/0x60
                              [<ffffffff811d86c1>] 
pcpu_create_chunk+0x11/0x120
                              [<ffffffff811d95f5>] 
pcpu_balance_workfn+0x435/0x5a0
                              [<ffffffff810d8b9a>] 
process_one_work+0x1fa/0x650
                              [<ffffffff810d9116>] worker_thread+0x126/0x4a0
                              [<ffffffff810df4dd>] kthread+0xed/0x110
                              [<ffffffff818150bf>] ret_from_fork+0x3f/0x70
       INITIAL USE at:
                          [<ffffffff811084b3>] __lock_acquire+0x3b3/0x1cf0
                          [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                          [<ffffffff81810901>] mutex_lock_nested+0x71/0x3b0
                          [<ffffffff811d8f9e>] pcpu_alloc+0x42e/0x620
                          [<ffffffff811d91b0>] __alloc_percpu+0x10/0x20
                          [<ffffffff8120e33b>] 
__kmem_cache_create+0x36b/0x4c0
                          [<ffffffff8211db72>] create_boot_cache+0x67/0x91
                          [<ffffffff8212062d>] kmem_cache_init+0x4b/0xf3
                          [<ffffffff820f3df1>] start_kernel+0x251/0x491
                          [<ffffffff820f35ad>] 
x86_64_start_reservations+0x2a/0x2c
                          [<ffffffff820f3699>] x86_64_start_kernel+0xea/0xed
     }
     ... key      at: [<ffffffff81e63350>] pcpu_alloc_mutex+0x70/0xa0
     ... acquired at:
    [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
    [<ffffffff81810901>] mutex_lock_nested+0x71/0x3b0
    [<ffffffff811d8f9e>] pcpu_alloc+0x42e/0x620
    [<ffffffff811d919d>] __alloc_percpu_gfp+0xd/0x10
    [<ffffffff813b5ba5>] __percpu_counter_init+0x55/0xe0
    [<ffffffffa0508b5b>] btrfs_init_fs_root+0x9b/0x1d0 [btrfs]
    [<ffffffffa050a392>] btrfs_get_fs_root+0xc2/0x260 [btrfs]
    [<ffffffffa0575b91>] __resolve_indirect_refs+0x121/0x7d0 [btrfs]
    [<ffffffffa0576d6d>] find_parent_nodes+0x39d/0x760 [btrfs]
    [<ffffffffa05771ee>] __btrfs_find_all_roots+0xbe/0x130 [btrfs]
    [<ffffffffa05772d0>] btrfs_find_all_roots+0x50/0x60 [btrfs]
    [<ffffffffa057ab33>] btrfs_qgroup_prepare_account_extents+0x53/0x90 
[btrfs]
    [<ffffffffa0511670>] btrfs_commit_transaction+0x490/0xb50 [btrfs]
    [<ffffffffa04d9bda>] btrfs_sync_fs+0x7a/0x1d0 [btrfs]
    [<ffffffff8124b5cc>] sync_filesystem+0x6c/0xa0
    [<ffffffff81218532>] generic_shutdown_super+0x22/0xf0
    [<ffffffff8121884d>] kill_anon_super+0xd/0x20
    [<ffffffffa04de6b3>] btrfs_kill_super+0x13/0x110 [btrfs]
    [<ffffffff81218aa9>] deactivate_locked_super+0x39/0x70
    [<ffffffff81219071>] deactivate_super+0x41/0x60
    [<ffffffff81237a0a>] cleanup_mnt+0x3a/0x80
    [<ffffffff81237a8d>] __cleanup_mnt+0xd/0x10
    [<ffffffff810ddb42>] task_work_run+0x72/0xa0
    [<ffffffff810b7488>] exit_to_usermode_loop+0x60/0x89
    [<ffffffff81001b35>] syscall_return_slowpath+0x85/0xb0
    [<ffffffff81814eb1>] int_ret_from_sys_call+0x25/0x9f

   -> (&fs_info->commit_root_sem){++++..} ops: 5719 {
      HARDIRQ-ON-W at:
                         [<ffffffff81108c46>] __lock_acquire+0xb46/0x1cf0
                         [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                         [<ffffffff81812b15>] down_write+0x55/0xc0
                         [<ffffffffa04ee832>] 
cache_block_group+0x282/0x450 [btrfs]
                         [<ffffffffa04fdf8a>] 
find_free_extent+0xeda/0x10f0 [btrfs]
                         [<ffffffffa04fe24a>] 
btrfs_reserve_extent+0xaa/0x140 [btrfs]
                         [<ffffffffa04fe44c>] 
btrfs_alloc_tree_block+0x16c/0x490 [btrfs]
                         [<ffffffffa050a69a>] 
btrfs_create_tree+0xba/0x2b0 [btrfs]
                         [<ffffffffa053ba0a>] 
btrfs_create_uuid_tree+0x3a/0x130 [btrfs]
                         [<ffffffffa050e261>] open_ctree+0x24a1/0x2990 
[btrfs]
                         [<ffffffffa04e1690>] btrfs_mount+0xc90/0xea0 
[btrfs]
                         [<ffffffff8121a134>] mount_fs+0x34/0x170
                         [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                         [<ffffffffa04e0b86>] btrfs_mount+0x186/0xea0 
[btrfs]
                         [<ffffffff8121a134>] mount_fs+0x34/0x170
                         [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                         [<ffffffff8123ae00>] do_mount+0x220/0xe90
                         [<ffffffff8123bd5e>] SyS_mount+0x7e/0xd0
                         [<ffffffff81814d57>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
      HARDIRQ-ON-R at:
                         [<ffffffff81108ad1>] __lock_acquire+0x9d1/0x1cf0
                         [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                         [<ffffffff81812a6c>] down_read+0x4c/0xa0
                         [<ffffffffa04f341e>] caching_thread+0x5e/0x650 
[btrfs]
                         [<ffffffffa054440a>] 
normal_work_helper+0x19a/0x5b0 [btrfs]
                         [<ffffffffa054485d>] 
btrfs_cache_helper+0xd/0x10 [btrfs]
                         [<ffffffff810d8b9a>] process_one_work+0x1fa/0x650
                         [<ffffffff810d9116>] worker_thread+0x126/0x4a0
                         [<ffffffff810df4dd>] kthread+0xed/0x110
                         [<ffffffff818150bf>] ret_from_fork+0x3f/0x70
      SOFTIRQ-ON-W at:
                         [<ffffffff81108af7>] __lock_acquire+0x9f7/0x1cf0
                         [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                         [<ffffffff81812b15>] down_write+0x55/0xc0
                         [<ffffffffa04ee832>] 
cache_block_group+0x282/0x450 [btrfs]
                         [<ffffffffa04fdf8a>] 
find_free_extent+0xeda/0x10f0 [btrfs]
                         [<ffffffffa04fe24a>] 
btrfs_reserve_extent+0xaa/0x140 [btrfs]
                         [<ffffffffa04fe44c>] 
btrfs_alloc_tree_block+0x16c/0x490 [btrfs]
                         [<ffffffffa050a69a>] 
btrfs_create_tree+0xba/0x2b0 [btrfs]
                         [<ffffffffa053ba0a>] 
btrfs_create_uuid_tree+0x3a/0x130 [btrfs]
                         [<ffffffffa050e261>] open_ctree+0x24a1/0x2990 
[btrfs]
                         [<ffffffffa04e1690>] btrfs_mount+0xc90/0xea0 
[btrfs]
                         [<ffffffff8121a134>] mount_fs+0x34/0x170
                         [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                         [<ffffffffa04e0b86>] btrfs_mount+0x186/0xea0 
[btrfs]
                         [<ffffffff8121a134>] mount_fs+0x34/0x170
                         [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                         [<ffffffff8123ae00>] do_mount+0x220/0xe90
                         [<ffffffff8123bd5e>] SyS_mount+0x7e/0xd0
                         [<ffffffff81814d57>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
      SOFTIRQ-ON-R at:
                         [<ffffffff81108af7>] __lock_acquire+0x9f7/0x1cf0
                         [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                         [<ffffffff81812a6c>] down_read+0x4c/0xa0
                         [<ffffffffa04f341e>] caching_thread+0x5e/0x650 
[btrfs]
                         [<ffffffffa054440a>] 
normal_work_helper+0x19a/0x5b0 [btrfs]
                         [<ffffffffa054485d>] 
btrfs_cache_helper+0xd/0x10 [btrfs]
                         [<ffffffff810d8b9a>] process_one_work+0x1fa/0x650
                         [<ffffffff810d9116>] worker_thread+0x126/0x4a0
                         [<ffffffff810df4dd>] kthread+0xed/0x110
                         [<ffffffff818150bf>] ret_from_fork+0x3f/0x70
      INITIAL USE at:
                        [<ffffffff811084b3>] __lock_acquire+0x3b3/0x1cf0
                        [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                        [<ffffffff81812b15>] down_write+0x55/0xc0
                        [<ffffffffa04ee832>] 
cache_block_group+0x282/0x450 [btrfs]
                        [<ffffffffa04fdf8a>] 
find_free_extent+0xeda/0x10f0 [btrfs]
                        [<ffffffffa04fe24a>] 
btrfs_reserve_extent+0xaa/0x140 [btrfs]
                        [<ffffffffa04fe44c>] 
btrfs_alloc_tree_block+0x16c/0x490 [btrfs]
                        [<ffffffffa050a69a>] 
btrfs_create_tree+0xba/0x2b0 [btrfs]
                        [<ffffffffa053ba0a>] 
btrfs_create_uuid_tree+0x3a/0x130 [btrfs]
                        [<ffffffffa050e261>] open_ctree+0x24a1/0x2990 
[btrfs]
                        [<ffffffffa04e1690>] btrfs_mount+0xc90/0xea0 [btrfs]
                        [<ffffffff8121a134>] mount_fs+0x34/0x170
                        [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                        [<ffffffffa04e0b86>] btrfs_mount+0x186/0xea0 [btrfs]
                        [<ffffffff8121a134>] mount_fs+0x34/0x170
                        [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                        [<ffffffff8123ae00>] do_mount+0x220/0xe90
                        [<ffffffff8123bd5e>] SyS_mount+0x7e/0xd0
                        [<ffffffff81814d57>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
    }
    ... key      at: [<ffffffffa05ab368>] 
__key.50190+0x0/0xfffffffffffe6159 [btrfs]
    ... acquired at:
    [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
    [<ffffffff81812b15>] down_write+0x55/0xc0
    [<ffffffffa04ee832>] cache_block_group+0x282/0x450 [btrfs]
    [<ffffffffa04fdf8a>] find_free_extent+0xeda/0x10f0 [btrfs]
    [<ffffffffa04fe24a>] btrfs_reserve_extent+0xaa/0x140 [btrfs]
    [<ffffffffa04fe44c>] btrfs_alloc_tree_block+0x16c/0x490 [btrfs]
    [<ffffffffa050a69a>] btrfs_create_tree+0xba/0x2b0 [btrfs]
    [<ffffffffa053ba0a>] btrfs_create_uuid_tree+0x3a/0x130 [btrfs]
    [<ffffffffa050e261>] open_ctree+0x24a1/0x2990 [btrfs]
    [<ffffffffa04e1690>] btrfs_mount+0xc90/0xea0 [btrfs]
    [<ffffffff8121a134>] mount_fs+0x34/0x170
    [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
    [<ffffffffa04e0b86>] btrfs_mount+0x186/0xea0 [btrfs]
    [<ffffffff8121a134>] mount_fs+0x34/0x170
    [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
    [<ffffffff8123ae00>] do_mount+0x220/0xe90
    [<ffffffff8123bd5e>] SyS_mount+0x7e/0xd0
    [<ffffffff81814d57>] entry_SYSCALL_64_fastpath+0x12/0x6f

  -> (&found->groups_sem){++++..} ops: 9002 {
     HARDIRQ-ON-W at:
                       [<ffffffff81108c46>] __lock_acquire+0xb46/0x1cf0
                       [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                       [<ffffffff81812b15>] down_write+0x55/0xc0
                       [<ffffffffa04f8a35>] 
__link_block_group+0x35/0x140 [btrfs]
                       [<ffffffffa04fa1c3>] 
btrfs_read_block_groups+0x2c3/0x620 [btrfs]
                       [<ffffffffa050d8fd>] open_ctree+0x1b3d/0x2990 [btrfs]
                       [<ffffffffa04e1690>] btrfs_mount+0xc90/0xea0 [btrfs]
                       [<ffffffff8121a134>] mount_fs+0x34/0x170
                       [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                       [<ffffffffa04e0b86>] btrfs_mount+0x186/0xea0 [btrfs]
                       [<ffffffff8121a134>] mount_fs+0x34/0x170
                       [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                       [<ffffffff8123ae00>] do_mount+0x220/0xe90
                       [<ffffffff8123bd5e>] SyS_mount+0x7e/0xd0
                       [<ffffffff81814d57>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
     HARDIRQ-ON-R at:
                       [<ffffffff81108ad1>] __lock_acquire+0x9d1/0x1cf0
                       [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                       [<ffffffff81812a6c>] down_read+0x4c/0xa0
                       [<ffffffffa0508f70>] 
btrfs_calc_num_tolerated_disk_barrier_failures+0x120/0x200 [btrfs]
                       [<ffffffffa050d915>] open_ctree+0x1b55/0x2990 [btrfs]
                       [<ffffffffa04e1690>] btrfs_mount+0xc90/0xea0 [btrfs]
                       [<ffffffff8121a134>] mount_fs+0x34/0x170
                       [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                       [<ffffffffa04e0b86>] btrfs_mount+0x186/0xea0 [btrfs]
                       [<ffffffff8121a134>] mount_fs+0x34/0x170
                       [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                       [<ffffffff8123ae00>] do_mount+0x220/0xe90
                       [<ffffffff8123bd5e>] SyS_mount+0x7e/0xd0
                       [<ffffffff81814d57>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
     SOFTIRQ-ON-W at:
                       [<ffffffff81108af7>] __lock_acquire+0x9f7/0x1cf0
                       [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                       [<ffffffff81812b15>] down_write+0x55/0xc0
                       [<ffffffffa04f8a35>] 
__link_block_group+0x35/0x140 [btrfs]
                       [<ffffffffa04fa1c3>] 
btrfs_read_block_groups+0x2c3/0x620 [btrfs]
                       [<ffffffffa050d8fd>] open_ctree+0x1b3d/0x2990 [btrfs]
                       [<ffffffffa04e1690>] btrfs_mount+0xc90/0xea0 [btrfs]
                       [<ffffffff8121a134>] mount_fs+0x34/0x170
                       [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                       [<ffffffffa04e0b86>] btrfs_mount+0x186/0xea0 [btrfs]
                       [<ffffffff8121a134>] mount_fs+0x34/0x170
                       [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                       [<ffffffff8123ae00>] do_mount+0x220/0xe90
                       [<ffffffff8123bd5e>] SyS_mount+0x7e/0xd0
                       [<ffffffff81814d57>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
     SOFTIRQ-ON-R at:
                       [<ffffffff81108af7>] __lock_acquire+0x9f7/0x1cf0
                       [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                       [<ffffffff81812a6c>] down_read+0x4c/0xa0
                       [<ffffffffa0508f70>] 
btrfs_calc_num_tolerated_disk_barrier_failures+0x120/0x200 [btrfs]
                       [<ffffffffa050d915>] open_ctree+0x1b55/0x2990 [btrfs]
                       [<ffffffffa04e1690>] btrfs_mount+0xc90/0xea0 [btrfs]
                       [<ffffffff8121a134>] mount_fs+0x34/0x170
                       [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                       [<ffffffffa04e0b86>] btrfs_mount+0x186/0xea0 [btrfs]
                       [<ffffffff8121a134>] mount_fs+0x34/0x170
                       [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                       [<ffffffff8123ae00>] do_mount+0x220/0xe90
                       [<ffffffff8123bd5e>] SyS_mount+0x7e/0xd0
                       [<ffffffff81814d57>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
     INITIAL USE at:
                      [<ffffffff811084b3>] __lock_acquire+0x3b3/0x1cf0
                      [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                      [<ffffffff81812b15>] down_write+0x55/0xc0
                      [<ffffffffa04f8a35>] __link_block_group+0x35/0x140 
[btrfs]
                      [<ffffffffa04fa1c3>] 
btrfs_read_block_groups+0x2c3/0x620 [btrfs]
                      [<ffffffffa050d8fd>] open_ctree+0x1b3d/0x2990 [btrfs]
                      [<ffffffffa04e1690>] btrfs_mount+0xc90/0xea0 [btrfs]
                      [<ffffffff8121a134>] mount_fs+0x34/0x170
                      [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                      [<ffffffffa04e0b86>] btrfs_mount+0x186/0xea0 [btrfs]
                      [<ffffffff8121a134>] mount_fs+0x34/0x170
                      [<ffffffff81238296>] vfs_kern_mount+0x66/0x150
                      [<ffffffff8123ae00>] do_mount+0x220/0xe90
                      [<ffffffff8123bd5e>] SyS_mount+0x7e/0xd0
                      [<ffffffff81814d57>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
   }
   ... key      at: [<ffffffffa05ab278>] 
__key.48892+0x0/0xfffffffffffe6249 [btrfs]
   ... acquired at:
    [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
    [<ffffffff81812a6c>] down_read+0x4c/0xa0
    [<ffffffffa04fdc6c>] find_free_extent+0xbbc/0x10f0 [btrfs]
    [<ffffffffa04fe24a>] btrfs_reserve_extent+0xaa/0x140 [btrfs]
    [<ffffffffa04fe44c>] btrfs_alloc_tree_block+0x16c/0x490 [btrfs]
    [<ffffffffa04e5027>] __btrfs_cow_block+0x117/0x5a0 [btrfs]
    [<ffffffffa04e5649>] btrfs_cow_block+0x119/0x270 [btrfs]
    [<ffffffffa04e90c6>] btrfs_search_slot+0x1c6/0x9b0 [btrfs]
    [<ffffffffa0569582>] btrfs_delete_delayed_items+0xb2/0x310 [btrfs]
    [<ffffffffa0569f47>] __btrfs_run_delayed_items+0x137/0x200 [btrfs]
    [<ffffffffa056a03e>] btrfs_run_delayed_items+0xe/0x10 [btrfs]
    [<ffffffffa051148b>] btrfs_commit_transaction+0x2ab/0xb50 [btrfs]
    [<ffffffffa04d9bda>] btrfs_sync_fs+0x7a/0x1d0 [btrfs]
    [<ffffffff8124b55b>] sync_fs_one_sb+0x1b/0x20
    [<ffffffff81219b39>] iterate_supers+0xa9/0x100
    [<ffffffff8124b650>] sys_sync+0x50/0x90
    [<ffffffff81814d57>] entry_SYSCALL_64_fastpath+0x12/0x6f

-> (&delayed_node->mutex){+.+.-.} ops: 1373744 {
    HARDIRQ-ON-W at:
                     [<ffffffff81108c46>] __lock_acquire+0xb46/0x1cf0
                     [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                     [<ffffffff81810901>] mutex_lock_nested+0x71/0x3b0
                     [<ffffffffa056b063>] 
btrfs_delayed_update_inode+0x43/0x850 [btrfs]
                     [<ffffffffa0517d1a>] btrfs_update_inode+0x8a/0x100 
[btrfs]
                     [<ffffffffa0521060>] btrfs_create+0x130/0x1e0 [btrfs]
                     [<ffffffff81221e4d>] vfs_create+0xbd/0x120
                     [<ffffffff812250d5>] path_openat+0x915/0x1400
                     [<ffffffff81226bc9>] do_filp_open+0x79/0xd0
                     [<ffffffff81214e20>] do_sys_open+0x110/0x1f0
                     [<ffffffff81214f19>] SyS_open+0x19/0x20
                     [<ffffffff81814d57>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
    SOFTIRQ-ON-W at:
                     [<ffffffff81108af7>] __lock_acquire+0x9f7/0x1cf0
                     [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                     [<ffffffff81810901>] mutex_lock_nested+0x71/0x3b0
                     [<ffffffffa056b063>] 
btrfs_delayed_update_inode+0x43/0x850 [btrfs]
                     [<ffffffffa0517d1a>] btrfs_update_inode+0x8a/0x100 
[btrfs]
                     [<ffffffffa0521060>] btrfs_create+0x130/0x1e0 [btrfs]
                     [<ffffffff81221e4d>] vfs_create+0xbd/0x120
                     [<ffffffff812250d5>] path_openat+0x915/0x1400
                     [<ffffffff81226bc9>] do_filp_open+0x79/0xd0
                     [<ffffffff81214e20>] do_sys_open+0x110/0x1f0
                     [<ffffffff81214f19>] SyS_open+0x19/0x20
                     [<ffffffff81814d57>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
    IN-RECLAIM_FS-W at:
                        [<ffffffff81108a7f>] __lock_acquire+0x97f/0x1cf0
                        [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                        [<ffffffff81810901>] mutex_lock_nested+0x71/0x3b0
                        [<ffffffffa0568d1a>] 
__btrfs_release_delayed_node+0x3a/0x200 [btrfs]
                        [<ffffffffa056a2ef>] 
btrfs_remove_delayed_node+0x1f/0x30 [btrfs]
                        [<ffffffffa051dcb7>] 
btrfs_evict_inode+0x1f7/0x680 [btrfs]
                        [<ffffffff81233130>] evict+0xc0/0x1a0
                        [<ffffffff81233244>] dispose_list+0x34/0x60
                        [<ffffffff81234346>] prune_icache_sb+0x46/0x60
                        [<ffffffff81219a3c>] super_cache_scan+0x13c/0x190
                        [<ffffffff811c8826>] 
shrink_slab.part.63.constprop.82+0x206/0x500
                        [<ffffffff811ccd97>] shrink_zone+0x147/0x160
                        [<ffffffff811cdb5b>] kswapd+0x49b/0xa80
                        [<ffffffff810df4dd>] kthread+0xed/0x110
                        [<ffffffff818150bf>] ret_from_fork+0x3f/0x70
    INITIAL USE at:
                    [<ffffffff811084b3>] __lock_acquire+0x3b3/0x1cf0
                    [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
                    [<ffffffff81810901>] mutex_lock_nested+0x71/0x3b0
                    [<ffffffffa056b063>] 
btrfs_delayed_update_inode+0x43/0x850 [btrfs]
                    [<ffffffffa0517d1a>] btrfs_update_inode+0x8a/0x100 
[btrfs]
                    [<ffffffffa0521060>] btrfs_create+0x130/0x1e0 [btrfs]
                    [<ffffffff81221e4d>] vfs_create+0xbd/0x120
                    [<ffffffff812250d5>] path_openat+0x915/0x1400
                    [<ffffffff81226bc9>] do_filp_open+0x79/0xd0
                    [<ffffffff81214e20>] do_sys_open+0x110/0x1f0
                    [<ffffffff81214f19>] SyS_open+0x19/0x20
                    [<ffffffff81814d57>] entry_SYSCALL_64_fastpath+0x12/0x6f
  }
  ... key      at: [<ffffffffa05af268>] 
__key.46828+0x0/0xfffffffffffe2259 [btrfs]
  ... acquired at:
    [<ffffffff811064d5>] check_usage_forwards+0x115/0x120
    [<ffffffff81106d0b>] mark_lock+0x1db/0x2e0
    [<ffffffff81108a7f>] __lock_acquire+0x97f/0x1cf0
    [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
    [<ffffffff81810901>] mutex_lock_nested+0x71/0x3b0
    [<ffffffffa0568d1a>] __btrfs_release_delayed_node+0x3a/0x200 [btrfs]
    [<ffffffffa056a2ef>] btrfs_remove_delayed_node+0x1f/0x30 [btrfs]
    [<ffffffffa051dcb7>] btrfs_evict_inode+0x1f7/0x680 [btrfs]
    [<ffffffff81233130>] evict+0xc0/0x1a0
    [<ffffffff81233244>] dispose_list+0x34/0x60
    [<ffffffff81234346>] prune_icache_sb+0x46/0x60
    [<ffffffff81219a3c>] super_cache_scan+0x13c/0x190
    [<ffffffff811c8826>] shrink_slab.part.63.constprop.82+0x206/0x500
    [<ffffffff811ccd97>] shrink_zone+0x147/0x160
    [<ffffffff811cdb5b>] kswapd+0x49b/0xa80
    [<ffffffff810df4dd>] kthread+0xed/0x110
    [<ffffffff818150bf>] ret_from_fork+0x3f/0x70


stack backtrace:
CPU: 0 PID: 546 Comm: kswapd0 Tainted: G           O    4.5.0-rc6+ #6
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 
12/01/2006
  0000000000000000 ffff88003dacb808 ffffffff8138090f ffffffff82d9cf80
  ffff88003de01b00 ffff88003dacb848 ffffffff811b271f ffffffff81c85849
  0000000000000000 ffff88003de023a8 ffff88003de01b00 ffffffff81c85849
Call Trace:
  [<ffffffff8138090f>] dump_stack+0x67/0x98
  [<ffffffff811b271f>] print_irq_inversion_bug.part.34+0x1ac/0x1b8
  [<ffffffff811064d5>] check_usage_forwards+0x115/0x120
  [<ffffffff811063c0>] ? check_usage_backwards+0x120/0x120
  [<ffffffff81106d0b>] mark_lock+0x1db/0x2e0
  [<ffffffff81108a7f>] __lock_acquire+0x97f/0x1cf0
  [<ffffffff818144d7>] ? _raw_spin_unlock_irq+0x27/0x40
  [<ffffffff811070ad>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff818144d7>] ? _raw_spin_unlock_irq+0x27/0x40
  [<ffffffff810e78b6>] ? finish_task_switch+0xa6/0x2c0
  [<ffffffff810e7877>] ? finish_task_switch+0x67/0x2c0
  [<ffffffff81109ebd>] lock_acquire+0xcd/0x200
  [<ffffffffa0568d1a>] ? __btrfs_release_delayed_node+0x3a/0x200 [btrfs]
  [<ffffffff81810901>] mutex_lock_nested+0x71/0x3b0
  [<ffffffffa0568d1a>] ? __btrfs_release_delayed_node+0x3a/0x200 [btrfs]
  [<ffffffffa0568d1a>] ? __btrfs_release_delayed_node+0x3a/0x200 [btrfs]
  [<ffffffffa0568d1a>] __btrfs_release_delayed_node+0x3a/0x200 [btrfs]
  [<ffffffffa056a2ef>] btrfs_remove_delayed_node+0x1f/0x30 [btrfs]
  [<ffffffffa051dcb7>] btrfs_evict_inode+0x1f7/0x680 [btrfs]
  [<ffffffff81814412>] ? _raw_spin_unlock+0x22/0x30
  [<ffffffff81233130>] evict+0xc0/0x1a0
  [<ffffffff81233244>] dispose_list+0x34/0x60
  [<ffffffff81234346>] prune_icache_sb+0x46/0x60
  [<ffffffff81219a3c>] super_cache_scan+0x13c/0x190
  [<ffffffff811c8826>] shrink_slab.part.63.constprop.82+0x206/0x500
  [<ffffffff811ccd97>] shrink_zone+0x147/0x160
  [<ffffffff811cdb5b>] kswapd+0x49b/0xa80
  [<ffffffff811cd6c0>] ? shrink_all_memory+0xb0/0xb0
  [<ffffffff810df4dd>] kthread+0xed/0x110
  [<ffffffff810df3f0>] ? kthread_create_on_node+0x220/0x220
  [<ffffffff818150bf>] ret_from_fork+0x3f/0x70
  [<ffffffff810df3f0>] ? kthread_create_on_node+0x220/0x220

------


