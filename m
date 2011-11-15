From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Reliability questions / "me too" for bugs
Date: Mon, 14 Nov 2011 23:06:40 -0500
Message-ID: <20111114230640.19ff8822@Bidule>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: lkml <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a couple of questions concerning btrfs reliability.

I'm currently using btrfs in my internal drives (strong advantages) and have used it on external drives, but I've recently migrated the external ones to ext4, for reliability reasons.
The kernel seems to be able to handle ext4 partition disconnections (drive error, cable gets eaten by rodent, or most commonly, unplugged too early on removable drives...) quite gracefully.
This is not yet the case for btrfs partitions (deadlocks, various oopses, need to reboot).
Any idea when this will be available ?

How to handle bad blocks (sometimes, they are very localized on HDDs, and they will happen on old SSDs) ?

Imagine the following use case:
 - get untrusted drive from dumpster
 - check that it runs, and has an acceptable amount of bad block clusters
 - add the drive to a btrfs pool, which guarantees that its data will be duplicated somewhere else
 - enjoy the drive while it lasts
 - ability to retrieve bad blocks map later on
 - ability to cleanly remove the drive from the pool if it becomes useless (found a better one) or dies (see first question)
   when that happens, data gets replicated to other locations...
   data replication could be done automatically by background scrubbing with some mount flag or ioctl
How far are we from that ? Will we get there some day ?


Since I'm here, a few random and useless notes, as I'm currently testing v3.2-rc1-284-g52e4c2a and I see a few bugs, deadlocks and weirdnesses.
I don't know if it's normal for -rc1, maybe.
My current workload is "rsync 1.5TB from SATA to USB2+3 (500+1000GB in raid0) and vice versa".
The load average can grow to 15.
I've ran into BUG at fs/btrfs/inode.c:1795 (http://comments.gmane.org/gmane.comp.file-systems.btrfs/14128).
I've ran into WARNING: at fs/btrfs/free-space-cache.c:1847 btrfs_remove_free_space+0x1a3/0x287() [1]
I've also ran into INFO: task btrfs-transacti:1465 blocked for more than 120 seconds. [2]
Sometimes linux is writing I don't know what for a looooooong time on drives, and there's nothing in cache.
Sometimes rsync stops, doing nothing. It will somehow restart after I do a "echo 3 > /proc/sys/vm/drop_caches"...
I see that a lot of features will be added for 3.2 but I hope they will be well tested !

-- 
cJ

[1]

2011-11-13_18:34:29 [2.906392] md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
2011-11-13_18:34:29 [2.987133] device fsid 539bca9b-2e64-4997-9335-ffc648c2ebe5 devid 1 transid 71489 /dev/root
2011-11-13_18:34:29 [3.049089] Btrfs detected SSD devices, enabling SSD mode
2011-11-13_18:34:29 [3.049346] ------------[ cut here ]------------
2011-11-13_18:34:29 [3.049450] WARNING: at fs/btrfs/free-space-cache.c:1847 btrfs_remove_free_space+0x1a3/0x287()
2011-11-13_18:34:29 [3.049622] Hardware name: To be filled by O.E.M.
2011-11-13_18:34:29 [3.049720] Modules linked in:
2011-11-13_18:34:29 [3.049843] Pid: 1, comm: swapper Not tainted 3.2.0-rc1-Bidule-00284-g52e4c2a #60
2011-11-13_18:34:29 [3.050017] Call Trace:
2011-11-13_18:34:29 [3.050117]  [<ffffffff8104dff7>] warn_slowpath_common+0x83/0x9b
2011-11-13_18:34:29 [3.050217]  [<ffffffff8104e029>] warn_slowpath_null+0x1a/0x1c
2011-11-13_18:34:29 [3.050317]  [<ffffffff8125dae8>] btrfs_remove_free_space+0x1a3/0x287
2011-11-13_18:34:29 [3.050420]  [<ffffffff81224a40>] btrfs_pin_extent_for_log_replay+0x72/0x89
2011-11-13_18:34:29 [3.050522]  [<ffffffff8125a4c5>] process_one_buffer+0x3a/0x74
2011-11-13_18:34:29 [3.050622]  [<ffffffff812592fd>] walk_up_log_tree+0xed/0x1c2
2011-11-13_18:34:29 [3.050722]  [<ffffffff81259d46>] walk_log_tree+0x9e/0x1a6
2011-11-13_18:34:29 [3.050822]  [<ffffffff8125b464>] btrfs_recover_log_trees+0x94/0x298
2011-11-13_18:34:29 [3.050922]  [<ffffffff8125a48b>] ? replay_one_buffer+0x223/0x223
2011-11-13_18:34:29 [3.051026]  [<ffffffff812306b1>] open_ctree+0x1189/0x14c4
2011-11-13_18:34:29 [3.051128]  [<ffffffff81216697>] btrfs_mount+0x41e/0x58d
2011-11-13_18:34:29 [3.051228]  [<ffffffff810e2b38>] ? pcpu_next_pop+0x3d/0x4a
2011-11-13_18:34:29 [3.051329]  [<ffffffff8110fe38>] mount_fs+0x69/0x155
2011-11-13_18:34:29 [3.051428]  [<ffffffff810e3c2c>] ? __alloc_percpu+0x10/0x12
2011-11-13_18:34:29 [3.051528]  [<ffffffff81124c8f>] vfs_kern_mount+0x63/0x9d
2011-11-13_18:34:29 [3.051628]  [<ffffffff81124fed>] do_kern_mount+0x4d/0xdf
2011-11-13_18:34:29 [3.051727]  [<ffffffff81126726>] do_mount+0x656/0x6b9
2011-11-13_18:34:29 [3.051827]  [<ffffffff810df983>] ? memdup_user+0x3d/0x65
2011-11-13_18:34:29 [3.051927]  [<ffffffff810df9e6>] ? strndup_user+0x3b/0x51
2011-11-13_18:34:29 [3.052029]  [<ffffffff81126a5c>] sys_mount+0x88/0xc2
2011-11-13_18:34:29 [3.052130]  [<ffffffff81a9bc2a>] mount_block_root+0xdd/0x1ee
2011-11-13_18:34:29 [3.052230]  [<ffffffff81a9befe>] mount_root+0xb9/0xc0
2011-11-13_18:34:29 [3.052328]  [<ffffffff81a9ca3a>] ? initrd_load+0x2e0/0x2e7
2011-11-13_18:34:29 [3.052428]  [<ffffffff81a9c072>] prepare_namespace+0x16d/0x1a6
2011-11-13_18:34:29 [3.052527]  [<ffffffff81a9ba1a>] kernel_init+0x13e/0x143
2011-11-13_18:34:29 [3.052628]  [<ffffffff814fe2f4>] kernel_thread_helper+0x4/0x10
2011-11-13_18:34:29 [3.052728]  [<ffffffff81a9b8dc>] ? start_kernel+0x352/0x352
2011-11-13_18:34:29 [3.052828]  [<ffffffff814fe2f0>] ? gs_change+0xb/0xb
2011-11-13_18:34:29 [3.052926] ---[ end trace 9be62b889bbbefed ]---
2011-11-13_18:34:29 [3.053370] ------------[ cut here ]------------
2011-11-13_18:34:29 [3.053471] WARNING: at fs/btrfs/free-space-cache.c:1847 btrfs_remove_free_space+0x1a3/0x287()
2011-11-13_18:34:29 [3.053641] Hardware name: To be filled by O.E.M.
2011-11-13_18:34:29 [3.053738] Modules linked in:
2011-11-13_18:34:29 [3.053862] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc1-Bidule-00284-g52e4c2a #60
2011-11-13_18:34:29 [3.054035] Call Trace:
2011-11-13_18:34:29 [3.054133]  [<ffffffff8104dff7>] warn_slowpath_common+0x83/0x9b
2011-11-13_18:34:29 [3.054234]  [<ffffffff8104e029>] warn_slowpath_null+0x1a/0x1c
2011-11-13_18:34:29 [3.054333]  [<ffffffff8125dae8>] btrfs_remove_free_space+0x1a3/0x287
2011-11-13_18:34:29 [3.054435]  [<ffffffff81224a40>] btrfs_pin_extent_for_log_replay+0x72/0x89
2011-11-13_18:34:29 [3.054535]  [<ffffffff8125a4c5>] process_one_buffer+0x3a/0x74
2011-11-13_18:34:29 [3.054635]  [<ffffffff812592fd>] walk_up_log_tree+0xed/0x1c2
2011-11-13_18:34:29 [3.054736]  [<ffffffff81259d46>] walk_log_tree+0x9e/0x1a6
2011-11-13_18:34:29 [3.054835]  [<ffffffff8125b65b>] btrfs_recover_log_trees+0x28b/0x298
2011-11-13_18:34:29 [3.054936]  [<ffffffff8125a48b>] ? replay_one_buffer+0x223/0x223
2011-11-13_18:34:29 [3.055039]  [<ffffffff812306b1>] open_ctree+0x1189/0x14c4
2011-11-13_18:34:29 [3.055141]  [<ffffffff81216697>] btrfs_mount+0x41e/0x58d
2011-11-13_18:34:29 [3.055240]  [<ffffffff810e2b38>] ? pcpu_next_pop+0x3d/0x4a
2011-11-13_18:34:29 [3.055341]  [<ffffffff8110fe38>] mount_fs+0x69/0x155
2011-11-13_18:34:29 [3.055440]  [<ffffffff810e3c2c>] ? __alloc_percpu+0x10/0x12
2011-11-13_18:34:29 [3.055539]  [<ffffffff81124c8f>] vfs_kern_mount+0x63/0x9d
2011-11-13_18:34:29 [3.055639]  [<ffffffff81124fed>] do_kern_mount+0x4d/0xdf
2011-11-13_18:34:29 [3.055739]  [<ffffffff81126726>] do_mount+0x656/0x6b9
2011-11-13_18:34:29 [3.055838]  [<ffffffff810df983>] ? memdup_user+0x3d/0x65
2011-11-13_18:34:29 [3.055938]  [<ffffffff810df9e6>] ? strndup_user+0x3b/0x51
2011-11-13_18:34:29 [3.056040]  [<ffffffff81126a5c>] sys_mount+0x88/0xc2
2011-11-13_18:34:29 [3.056141]  [<ffffffff81a9bc2a>] mount_block_root+0xdd/0x1ee
2011-11-13_18:34:29 [3.056240]  [<ffffffff81a9befe>] mount_root+0xb9/0xc0
2011-11-13_18:34:29 [3.056339]  [<ffffffff81a9ca3a>] ? initrd_load+0x2e0/0x2e7
2011-11-13_18:34:29 [3.056438]  [<ffffffff81a9c072>] prepare_namespace+0x16d/0x1a6
2011-11-13_18:34:29 [3.056538]  [<ffffffff81a9ba1a>] kernel_init+0x13e/0x143
2011-11-13_18:34:29 [3.056638]  [<ffffffff814fe2f4>] kernel_thread_helper+0x4/0x10
2011-11-13_18:34:29 [3.056738]  [<ffffffff81a9b8dc>] ? start_kernel+0x352/0x352
2011-11-13_18:34:29 [3.056838]  [<ffffffff814fe2f0>] ? gs_change+0xb/0xb
2011-11-13_18:34:29 [3.056936] ---[ end trace 9be62b889bbbefee ]---
2011-11-13_18:34:29 [3.166577] VFS: Mounted root (btrfs filesystem) readonly on device 0:15.

[2]

2011-11-09_18:13:06 [70321.613136] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2011-11-09_18:13:06 [70321.613140] btrfs-delayed-m D ffff8801231333c0     0 16467      2 0x00000000
2011-11-09_18:13:06 [70321.613149]  ffff880243bab8b0 0000000000000046 ffff880243bab850 ffffffff81a0d020
2011-11-09_18:13:06 [70321.613157]  ffffffff81b58770 ffff8802f912c530 ffff880243babfd8 ffff880243babfd8
2011-11-09_18:13:06 [70321.613164]  0000000000011b40 ffff8802f912c530 ffff880243bab880 ffffffff814ca9b0
2011-11-09_18:13:06 [70321.613172] Call Trace:
2011-11-09_18:13:06 [70321.613183]  [<ffffffff814ca9b0>] ? _raw_spin_unlock_irqrestore+0x27/0x32
2011-11-09_18:13:06 [70321.613192]  [<ffffffff814c9436>] schedule+0x55/0x57
2011-11-09_18:13:06 [70321.613199]  [<ffffffff81208849>] wait_block_group_cache_progress+0xd4/0xfb
2011-11-09_18:13:06 [70321.613206]  [<ffffffff81063111>] ? add_wait_queue+0x44/0x44
2011-11-09_18:13:06 [70321.613212]  [<ffffffff81063111>] ? add_wait_queue+0x44/0x44
2011-11-09_18:13:06 [70321.613219]  [<ffffffff8120c562>] find_free_extent.constprop.72+0x5c6/0x921
2011-11-09_18:13:06 [70321.613225]  [<ffffffff810f440b>] ? kmem_cache_free+0x18/0xb3
2011-11-09_18:13:06 [70321.613232]  [<ffffffff814cd247>] ? sub_preempt_count+0x8f/0xa3
2011-11-09_18:13:06 [70321.613240]  [<ffffffff8120f001>] btrfs_reserve_extent+0xab/0x19e
2011-11-09_18:13:06 [70321.613247]  [<ffffffff8120f522>] btrfs_alloc_free_block+0x152/0x26f
2011-11-09_18:13:06 [70321.613254]  [<ffffffff81202947>] __btrfs_cow_block+0xf8/0x319
2011-11-09_18:13:06 [70321.613260]  [<ffffffff81217b6f>] ? btrfs_buffer_uptodate+0x42/0x52
2011-11-09_18:13:06 [70321.613266]  [<ffffffff81202c69>] btrfs_cow_block+0x101/0x179
2011-11-09_18:13:06 [70321.613272]  [<ffffffff812056aa>] btrfs_search_slot+0x212/0x626
2011-11-09_18:13:06 [70321.613279]  [<ffffffff8103ee7f>] ? get_parent_ip+0xf/0x40
2011-11-09_18:13:06 [70321.613285]  [<ffffffff8121450e>] btrfs_lookup_inode+0x2a/0x8c
2011-11-09_18:13:06 [70321.613291]  [<ffffffff81251ea4>] ? btrfs_delete_delayed_items+0x277/0x28c
2011-11-09_18:13:06 [70321.613298]  [<ffffffff81251406>] btrfs_update_delayed_inode+0x6d/0x132
2011-11-09_18:13:06 [70321.613304]  [<ffffffff8121c0ff>] ? start_transaction+0x1f9/0x251
2011-11-09_18:13:06 [70321.613310]  [<ffffffff81251f5b>] btrfs_async_run_delayed_node_done+0xa2/0x153
2011-11-09_18:13:06 [70321.613317]  [<ffffffff8123b942>] worker_loop+0x165/0x45f
2011-11-09_18:13:06 [70321.613324]  [<ffffffff8123b7dd>] ? btrfs_queue_worker+0x279/0x279
2011-11-09_18:13:06 [70321.613329]  [<ffffffff810629e7>] kthread+0x7f/0x87
2011-11-09_18:13:06 [70321.613335]  [<ffffffff814d1db4>] kernel_thread_helper+0x4/0x10
2011-11-09_18:13:06 [70321.613342]  [<ffffffff81062968>] ? kthread_worker_fn+0x141/0x141
2011-11-09_18:13:06 [70321.613347]  [<ffffffff814d1db0>] ? gs_change+0xb/0xb
2011-11-09_18:15:06 [70441.613059] INFO: task btrfs-cache-0:23182 blocked for more than 120 seconds.
2011-11-09_18:15:06 [70441.613064] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2011-11-09_18:15:06 [70441.613069] btrfs-cache-0   D 0000000000000000     0 23182      2 0x00000000
2011-11-09_18:15:06 [70441.613078]  ffff8802359dfa90 0000000000000046 ffff8802359dfa70 ffffffff81a0d020
2011-11-09_18:15:06 [70441.613086]  ffff880200000000 ffff88042a299710 ffff8802359dffd8 ffff8802359dffd8
2011-11-09_18:15:06 [70441.613093]  0000000000011b40 ffff88042a299710 ffff8802359dfa80 0000000181069db4
2011-11-09_18:15:06 [70441.613100] Call Trace:
2011-11-09_18:15:06 [70441.613112]  [<ffffffff810bb744>] ? __lock_page+0x63/0x63
2011-11-09_18:15:06 [70441.613121]  [<ffffffff814c9436>] schedule+0x55/0x57
2011-11-09_18:15:06 [70441.613126]  [<ffffffff814c9496>] io_schedule+0x5e/0x79
2011-11-09_18:15:06 [70441.613132]  [<ffffffff810bb74d>] sleep_on_page+0x9/0xd
2011-11-09_18:15:06 [70441.613138]  [<ffffffff814c98ee>] __wait_on_bit+0x43/0x76
2011-11-09_18:15:06 [70441.613143]  [<ffffffff810bb8c4>] wait_on_page_bit+0x6d/0x6f
2011-11-09_18:15:06 [70441.613150]  [<ffffffff81063143>] ? autoremove_wake_function+0x32/0x32
2011-11-09_18:15:06 [70441.613157]  [<ffffffff81234dbb>] read_extent_buffer_pages+0x240/0x296
2011-11-09_18:15:06 [70441.613163]  [<ffffffff81215100>] ? lock_page+0x23/0x23
2011-11-09_18:15:06 [70441.613169]  [<ffffffff812164c5>] btree_read_extent_buffer_pages.isra.101+0x57/0xaf
2011-11-09_18:15:06 [70441.613175]  [<ffffffff812172be>] read_tree_block+0x35/0x4a
2011-11-09_18:15:06 [70441.613182]  [<ffffffff81204084>] read_block_for_search.isra.33+0x298/0x2d2
2011-11-09_18:15:06 [70441.613189]  [<ffffffff812071f9>] btrfs_next_leaf+0x13d/0x2df
2011-11-09_18:15:06 [70441.613196]  [<ffffffff8120a4a4>] caching_thread+0x174/0x2d9
2011-11-09_18:15:06 [70441.613203]  [<ffffffff8123b942>] worker_loop+0x165/0x45f
2011-11-09_18:15:06 [70441.613210]  [<ffffffff8123b7dd>] ? btrfs_queue_worker+0x279/0x279
2011-11-09_18:15:06 [70441.613216]  [<ffffffff810629e7>] kthread+0x7f/0x87
2011-11-09_18:15:06 [70441.613222]  [<ffffffff814d1db4>] kernel_thread_helper+0x4/0x10
2011-11-09_18:15:06 [70441.613229]  [<ffffffff81062968>] ? kthread_worker_fn+0x141/0x141
2011-11-09_18:15:06 [70441.613234]  [<ffffffff814d1db0>] ? gs_change+0xb/0xb
2011-11-09_18:15:06 [70441.613239] INFO: task btrfs-transacti:23714 blocked for more than 120 seconds.
2011-11-09_18:15:06 [70441.613242] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2011-11-09_18:15:06 [70441.613246] btrfs-transacti D 0000000000000000     0 23714      2 0x00000000
2011-11-09_18:15:06 [70441.613253]  ffff880210a55bf0 0000000000000046 ffff880210a55c50 ffff88042c4a4ce0
2011-11-09_18:15:06 [70441.613261]  ffff880300000000 ffff8802f912b5d0 ffff880210a55fd8 ffff880210a55fd8
2011-11-09_18:15:06 [70441.613268]  0000000000011b40 ffff8802f912b5d0 ffff880210a55c20 0000000100000033
2011-11-09_18:15:06 [70441.613275] Call Trace:
2011-11-09_18:15:06 [70441.613283]  [<ffffffff814c9436>] schedule+0x55/0x57
2011-11-09_18:15:06 [70441.613290]  [<ffffffff814c9b95>] __mutex_lock_common.isra.7+0x13e/0x216
2011-11-09_18:15:06 [70441.613298]  [<ffffffff814c9cdd>] __mutex_lock_slowpath+0xe/0x10
2011-11-09_18:15:06 [70441.613303]  [<ffffffff814c99ac>] mutex_lock+0x13/0x24
2011-11-09_18:15:06 [70441.613311]  [<ffffffff812518e8>] btrfs_insert_delayed_items+0x3e/0x383
2011-11-09_18:15:06 [70441.613318]  [<ffffffff8103ee7f>] ? get_parent_ip+0xf/0x40
2011-11-09_18:15:06 [70441.613324]  [<ffffffff814cd247>] ? sub_preempt_count+0x8f/0xa3
2011-11-09_18:15:06 [70441.613330]  [<ffffffff81252084>] btrfs_run_delayed_items+0x78/0xf4
2011-11-09_18:15:06 [70441.613336]  [<ffffffff8121b78b>] btrfs_commit_transaction+0x252/0x76c
2011-11-09_18:15:06 [70441.613342]  [<ffffffff81063111>] ? add_wait_queue+0x44/0x44
2011-11-09_18:15:06 [70441.613348]  [<ffffffff8121c0ff>] ? start_transaction+0x1f9/0x251
2011-11-09_18:15:06 [70441.613354]  [<ffffffff8103ee7f>] ? get_parent_ip+0xf/0x40
2011-11-09_18:15:06 [70441.613359]  [<ffffffff81215a9c>] transaction_kthread+0x174/0x22b
2011-11-09_18:15:06 [70441.613365]  [<ffffffff81215928>] ? btrfs_congested_fn+0x8e/0x8e
2011-11-09_18:15:06 [70441.613371]  [<ffffffff810629e7>] kthread+0x7f/0x87
2011-11-09_18:15:06 [70441.613376]  [<ffffffff814d1db4>] kernel_thread_helper+0x4/0x10
2011-11-09_18:15:06 [70441.613383]  [<ffffffff81062968>] ? kthread_worker_fn+0x141/0x141
2011-11-09_18:15:06 [70441.613388]  [<ffffffff814d1db0>] ? gs_change+0xb/0xb
2011-11-09_18:15:06 [70441.613394] INFO: task btrfs-delayed-m:16467 blocked for more than 120 seconds.
2011-11-09_18:15:06 [70441.613398] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2011-11-09_18:15:06 [70441.613401] btrfs-delayed-m D ffff8801231333c0     0 16467      2 0x00000000
2011-11-09_18:15:06 [70441.613408]  ffff880243bab8b0 0000000000000046 ffff880243bab850 ffffffff81a0d020
2011-11-09_18:15:06 [70441.613415]  ffffffff81b58770 ffff8802f912c530 ffff880243babfd8 ffff880243babfd8
2011-11-09_18:15:06 [70441.613422]  0000000000011b40 ffff8802f912c530 ffff880243bab880 ffffffff814ca9b0
2011-11-09_18:15:06 [70441.613429] Call Trace:
2011-11-09_18:15:06 [70441.613436]  [<ffffffff814ca9b0>] ? _raw_spin_unlock_irqrestore+0x27/0x32
2011-11-09_18:15:06 [70441.613443]  [<ffffffff814c9436>] schedule+0x55/0x57
2011-11-09_18:15:06 [70441.613449]  [<ffffffff81208849>] wait_block_group_cache_progress+0xd4/0xfb
2011-11-09_18:15:06 [70441.613455]  [<ffffffff81063111>] ? add_wait_queue+0x44/0x44
2011-11-09_18:15:06 [70441.613460]  [<ffffffff81063111>] ? add_wait_queue+0x44/0x44
2011-11-09_18:15:06 [70441.613467]  [<ffffffff8120c562>] find_free_extent.constprop.72+0x5c6/0x921
2011-11-09_18:15:06 [70441.613473]  [<ffffffff810f440b>] ? kmem_cache_free+0x18/0xb3
2011-11-09_18:15:06 [70441.613479]  [<ffffffff814cd247>] ? sub_preempt_count+0x8f/0xa3
2011-11-09_18:15:06 [70441.613487]  [<ffffffff8120f001>] btrfs_reserve_extent+0xab/0x19e
2011-11-09_18:15:06 [70441.613494]  [<ffffffff8120f522>] btrfs_alloc_free_block+0x152/0x26f
2011-11-09_18:15:06 [70441.613501]  [<ffffffff81202947>] __btrfs_cow_block+0xf8/0x319
2011-11-09_18:15:06 [70441.613507]  [<ffffffff81217b6f>] ? btrfs_buffer_uptodate+0x42/0x52
2011-11-09_18:15:06 [70441.613513]  [<ffffffff81202c69>] btrfs_cow_block+0x101/0x179
2011-11-09_18:15:06 [70441.613519]  [<ffffffff812056aa>] btrfs_search_slot+0x212/0x626
2011-11-09_18:15:06 [70441.613525]  [<ffffffff8103ee7f>] ? get_parent_ip+0xf/0x40
2011-11-09_18:15:06 [70441.613531]  [<ffffffff8121450e>] btrfs_lookup_inode+0x2a/0x8c
2011-11-09_18:15:06 [70441.613536]  [<ffffffff81251ea4>] ? btrfs_delete_delayed_items+0x277/0x28c
2011-11-09_18:15:06 [70441.613543]  [<ffffffff81251406>] btrfs_update_delayed_inode+0x6d/0x132
2011-11-09_18:15:06 [70441.613548]  [<ffffffff8121c0ff>] ? start_transaction+0x1f9/0x251
2011-11-09_18:15:06 [70441.613555]  [<ffffffff81251f5b>] btrfs_async_run_delayed_node_done+0xa2/0x153
2011-11-09_18:15:06 [70441.613561]  [<ffffffff8123b942>] worker_loop+0x165/0x45f
2011-11-09_18:15:06 [70441.613568]  [<ffffffff8123b7dd>] ? btrfs_queue_worker+0x279/0x279
2011-11-09_18:15:06 [70441.613574]  [<ffffffff810629e7>] kthread+0x7f/0x87
2011-11-09_18:15:06 [70441.613579]  [<ffffffff814d1db4>] kernel_thread_helper+0x4/0x10
2011-11-09_18:15:06 [70441.613586]  [<ffffffff81062968>] ? kthread_worker_fn+0x141/0x141
2011-11-09_18:15:06 [70441.613591]  [<ffffffff814d1db0>] ? gs_change+0xb/0xb


2011-11-10_21:50:54 [6001.565179] INFO: task btrfs-transacti:3370 blocked for more than 120 seconds.
2011-11-10_21:50:54 [6001.565181] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2011-11-10_21:50:54 [6001.565182] btrfs-transacti D 0000000000000000     0  3370      2 0x00000000
2011-11-10_21:50:54 [6001.565185]  ffff8802fb6957a0 0000000000000046 ffff8802fb695780 ffff88042c508f60
2011-11-10_21:50:54 [6001.565188]  ffff880200000000 ffff88042b0a87b0 ffff8802fb695fd8 ffff8802fb695fd8
2011-11-10_21:50:54 [6001.565190]  0000000000011b40 ffff88042b0a87b0 ffff8802fb695790 0000000181069db4
2011-11-10_21:50:54 [6001.565193] Call Trace:
2011-11-10_21:50:54 [6001.565195]  [<ffffffff810bb744>] ? __lock_page+0x63/0x63
2011-11-10_21:50:54 [6001.565198]  [<ffffffff814c9436>] schedule+0x55/0x57
2011-11-10_21:50:54 [6001.565200]  [<ffffffff814c9496>] io_schedule+0x5e/0x79
2011-11-10_21:50:54 [6001.565202]  [<ffffffff810bb74d>] sleep_on_page+0x9/0xd
2011-11-10_21:50:54 [6001.565204]  [<ffffffff814c98ee>] __wait_on_bit+0x43/0x76
2011-11-10_21:50:54 [6001.565206]  [<ffffffff810bb8c4>] wait_on_page_bit+0x6d/0x6f
2011-11-10_21:50:54 [6001.565208]  [<ffffffff81063143>] ? autoremove_wake_function+0x32/0x32
2011-11-10_21:50:54 [6001.565211]  [<ffffffff81234dbb>] read_extent_buffer_pages+0x240/0x296
2011-11-10_21:50:54 [6001.565213]  [<ffffffff81215100>] ? lock_page+0x23/0x23
2011-11-10_21:50:54 [6001.565216]  [<ffffffff812164c5>] btree_read_extent_buffer_pages.isra.101+0x57/0xaf
2011-11-10_21:50:54 [6001.565218]  [<ffffffff812172be>] read_tree_block+0x35/0x4a
2011-11-10_21:50:54 [6001.565221]  [<ffffffff81204084>] read_block_for_search.isra.33+0x298/0x2d2
2011-11-10_21:50:54 [6001.565223]  [<ffffffff81205902>] btrfs_search_slot+0x46a/0x626
2011-11-10_21:50:54 [6001.565226]  [<ffffffff81209122>] lookup_inline_extent_backref+0x94/0x319
2011-11-10_21:50:54 [6001.565228]  [<ffffffff812013d5>] ? leaf_space_used+0x55/0x7d
2011-11-10_21:50:54 [6001.565230]  [<ffffffff81204254>] ? btrfs_leaf_free_space+0x30/0x6f
2011-11-10_21:50:54 [6001.565233]  [<ffffffff8120ac65>] __btrfs_free_extent+0xbe/0x55a
2011-11-10_21:50:54 [6001.565235]  [<ffffffff8103ee7f>] ? get_parent_ip+0xf/0x40
2011-11-10_21:50:54 [6001.565238]  [<ffffffff8103ee7f>] ? get_parent_ip+0xf/0x40
2011-11-10_21:50:54 [6001.565240]  [<ffffffff8103ee7f>] ? get_parent_ip+0xf/0x40
2011-11-10_21:50:54 [6001.565242]  [<ffffffff8120e21e>] run_clustered_refs+0x62e/0x678
2011-11-10_21:50:54 [6001.565245]  [<ffffffff8124a6c5>] ? btrfs_find_ref_cluster+0xf6/0x137
2011-11-10_21:50:54 [6001.565248]  [<ffffffff8120e334>] btrfs_run_delayed_refs+0xcc/0x17c
2011-11-10_21:50:54 [6001.565251]  [<ffffffff8121b5e9>] btrfs_commit_transaction+0xb0/0x76c
2011-11-10_21:50:54 [6001.565253]  [<ffffffff814ca97e>] ? _raw_spin_unlock+0x25/0x30
2011-11-10_21:50:54 [6001.565255]  [<ffffffff8121b04d>] ? join_transaction.isra.24+0x1f9/0x20a
2011-11-10_21:50:54 [6001.565257]  [<ffffffff81063111>] ? add_wait_queue+0x44/0x44
2011-11-10_21:50:54 [6001.565259]  [<ffffffff8121c0ff>] ? start_transaction+0x1f9/0x251
2011-11-10_21:50:54 [6001.565261]  [<ffffffff8103ee7f>] ? get_parent_ip+0xf/0x40
2011-11-10_21:50:54 [6001.565263]  [<ffffffff81215a9c>] transaction_kthread+0x174/0x22b
2011-11-10_21:50:54 [6001.565265]  [<ffffffff81215928>] ? btrfs_congested_fn+0x8e/0x8e
2011-11-10_21:50:54 [6001.565267]  [<ffffffff810629e7>] kthread+0x7f/0x87
2011-11-10_21:50:54 [6001.565269]  [<ffffffff814d1db4>] kernel_thread_helper+0x4/0x10
2011-11-10_21:50:54 [6001.565272]  [<ffffffff81062968>] ? kthread_worker_fn+0x141/0x141
2011-11-10_21:50:54 [6001.565273]  [<ffffffff814d1db0>] ? gs_change+0xb/0xb

2011-11-13_16:21:14 [6601.596057] INFO: task btrfs-transacti:4544 blocked for more than 120 seconds.
2011-11-13_16:21:14 [6601.596060] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2011-11-13_16:21:14 [6601.596063] btrfs-transacti D 0000000000000002     0  4544      2 0x00000000
2011-11-13_16:21:14 [6601.596068]  ffff8802c7e4fbb0 0000000000000046 ffff8802c7e4fb50 ffff880297445b80
2011-11-13_16:21:14 [6601.596072]  ffff8802c7e4fb70 ffff8802c7e4ffd8 0000000000011b80 ffff8802c7e4ffd8
2011-11-13_16:21:14 [6601.596077]  0000000000011b80 ffff88042b3f96e0 ffff88043ec92440 ffff88043ec92440
2011-11-13_16:21:14 [6601.596082] Call Trace:
2011-11-13_16:21:14 [6601.596089]  [<ffffffff81134593>] ? wait_on_buffer+0x17/0x17
2011-11-13_16:21:14 [6601.596093]  [<ffffffff815053eb>] schedule+0x5a/0x5c
2011-11-13_16:21:14 [6601.596096]  [<ffffffff81505450>] io_schedule+0x63/0x7e
2011-11-13_16:21:14 [6601.596100]  [<ffffffff811345a1>] sleep_on_buffer+0xe/0x12
2011-11-13_16:21:14 [6601.596103]  [<ffffffff815058df>] __wait_on_bit+0x48/0x7b
2011-11-13_16:21:14 [6601.596107]  [<ffffffff81505984>] out_of_line_wait_on_bit+0x72/0x7d
2011-11-13_16:21:14 [6601.596110]  [<ffffffff81134593>] ? wait_on_buffer+0x17/0x17
2011-11-13_16:21:14 [6601.596114]  [<ffffffff81069ea6>] ? autoremove_wake_function+0x37/0x37
2011-11-13_16:21:14 [6601.596118]  [<ffffffff8113457a>] __wait_on_buffer+0x26/0x28
2011-11-13_16:21:14 [6601.596122]  [<ffffffff8122dcbc>] write_dev_supers+0xed/0x1ce
2011-11-13_16:21:14 [6601.596125]  [<ffffffff8122e33d>] ? backup_super_roots+0x1f3/0x25e
2011-11-13_16:21:14 [6601.596130]  [<ffffffff8122fdfb>] write_all_supers+0x1ea/0x243
2011-11-13_16:21:14 [6601.596134]  [<ffffffff8122fe67>] write_ctree_super+0x13/0x15
2011-11-13_16:21:14 [6601.596137]  [<ffffffff81233a7f>] btrfs_commit_transaction+0x607/0x771
2011-11-13_16:21:14 [6601.596141]  [<ffffffff81069e6f>] ? add_wait_queue+0x49/0x49
2011-11-13_16:21:14 [6601.596145]  [<ffffffff810453ed>] ? get_parent_ip+0x26/0x40
2011-11-13_16:21:14 [6601.596149]  [<ffffffff8122d826>] transaction_kthread+0x179/0x230
2011-11-13_16:21:14 [6601.596153]  [<ffffffff8122d6ad>] ? btrfs_congested_fn+0x93/0x93
2011-11-13_16:21:14 [6601.596156]  [<ffffffff810696f7>] kthread+0x84/0x8c
2011-11-13_16:21:14 [6601.596161]  [<ffffffff8150e634>] kernel_thread_helper+0x4/0x10
2011-11-13_16:21:14 [6601.596165]  [<ffffffff81069673>] ? kthread_worker_fn+0x146/0x146
2011-11-13_16:21:14 [6601.596168]  [<ffffffff8150e630>] ? gs_change+0xb/0xb
<- crash ? don't remember
2011-11-13_16:42:44 [0.000000] Initializing cgroup subsys cpuset

2011-11-13_19:16:24 [2521.580104] INFO: task btrfs-transacti:1465 blocked for more than 120 seconds.
2011-11-13_19:16:24 [2521.580106] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2011-11-13_19:16:24 [2521.580108] btrfs-transacti D ffff88043ed51b80     0  1465      2 0x00000000
2011-11-13_19:16:24 [2521.580112]  ffff88032ba23bb0 0000000000000046 ffff88032ba23b50 ffff880429335b80
2011-11-13_19:16:24 [2521.580116]  ffff88032ba23b50 ffff880408758000 ffff88032ba23fd8 ffff88032ba23fd8
2011-11-13_19:16:24 [2521.580119]  0000000000011b80 ffff880408758000 ffff88032ba23ba0 ffffffff8107097d
2011-11-13_19:16:24 [2521.580123] Call Trace:
2011-11-13_19:16:24 [2521.580130]  [<ffffffff8107097d>] ? ktime_get_ts+0x85/0x8e
2011-11-13_19:16:24 [2521.580134]  [<ffffffff81132b4f>] ? wait_on_buffer+0x17/0x17
2011-11-13_19:16:24 [2521.580138]  [<ffffffff814f5392>] schedule+0x5a/0x5c
2011-11-13_19:16:24 [2521.580142]  [<ffffffff814f53f7>] io_schedule+0x63/0x7e
2011-11-13_19:16:24 [2521.580145]  [<ffffffff81132b5d>] sleep_on_buffer+0xe/0x12
2011-11-13_19:16:24 [2521.580147]  [<ffffffff814f5886>] __wait_on_bit+0x48/0x7b
2011-11-13_19:16:24 [2521.580150]  [<ffffffff814f592b>] out_of_line_wait_on_bit+0x72/0x7d
2011-11-13_19:16:24 [2521.580153]  [<ffffffff81132b4f>] ? wait_on_buffer+0x17/0x17
2011-11-13_19:16:24 [2521.580156]  [<ffffffff810697f6>] ? autoremove_wake_function+0x37/0x37
2011-11-13_19:16:24 [2521.580160]  [<ffffffff81132b36>] __wait_on_buffer+0x26/0x28
2011-11-13_19:16:24 [2521.580163]  [<ffffffff8122c310>] write_dev_supers+0xed/0x1ce
2011-11-13_19:16:24 [2521.580166]  [<ffffffff8122dce7>] write_all_supers+0x426/0x47f
2011-11-13_19:16:24 [2521.580169]  [<ffffffff8122dd53>] write_ctree_super+0x13/0x15
2011-11-13_19:16:24 [2521.580172]  [<ffffffff81232092>] btrfs_commit_transaction+0x607/0x771
2011-11-13_19:16:24 [2521.580176]  [<ffffffff810697bf>] ? add_wait_queue+0x49/0x49
2011-11-13_19:16:24 [2521.580178]  [<ffffffff81232679>] ? start_transaction+0x1fe/0x256
2011-11-13_19:16:24 [2521.580181]  [<ffffffff81044136>] ? get_parent_ip+0xf/0x40
2011-11-13_19:16:24 [2521.580184]  [<ffffffff8122be89>] transaction_kthread+0x179/0x230
2011-11-13_19:16:24 [2521.580187]  [<ffffffff8122bd10>] ? btrfs_congested_fn+0x93/0x93
2011-11-13_19:16:24 [2521.580190]  [<ffffffff81069047>] kthread+0x84/0x8c
2011-11-13_19:16:24 [2521.580194]  [<ffffffff814fe2f4>] kernel_thread_helper+0x4/0x10
2011-11-13_19:16:24 [2521.580197]  [<ffffffff81068fc3>] ? kthread_worker_fn+0x146/0x146
2011-11-13_19:16:24 [2521.580200]  [<ffffffff814fe2f0>] ? gs_change+0xb/0xb


