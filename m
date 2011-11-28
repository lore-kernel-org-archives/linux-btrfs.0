From: Tobias <tracer@robotech.de>
Subject: Blcoked for more than 120 seconds
Date: Mon, 28 Nov 2011 09:16:25 +0100
Message-ID: <4ED34359.6010305@robotech.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I have two Hardware-Raid Arrays. Each encrypted with dmcrypt and on each 
one btrfs on it (without snapshots). They are half-filled

I do rsyncs on these fs over night and i get these errors:

INFO: task flush-btrfs-2:1472 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-btrfs-2   D ffff8802313fb1a0     0  1472      2 0x00000000
  ffff880227c318d0 0000000000000046 ffff88006320b798 ffff88006320b768
  ffff8802313fade0 ffff880227c31fd8 ffff880227c31fd8 ffff880227c31fd8
  ffff880211da5bc0 ffff8802313fade0 ffff880227c318d0 ffffffff8108f1fd
Call Trace:
  [<ffffffff8108f1fd>] ? ktime_get_ts+0xad/0xe0
  [<ffffffff81109a30>] ? __lock_page+0x70/0x70
  [<ffffffff815ffb9f>] schedule+0x3f/0x60
  [<ffffffff815ffc4f>] io_schedule+0x8f/0xd0
  [<ffffffff81109a3e>] sleep_on_page+0xe/0x20
  [<ffffffff8160031a>] __wait_on_bit_lock+0x5a/0xc0
  [<ffffffff81109a27>] __lock_page+0x67/0x70
  [<ffffffff81085440>] ? autoremove_wake_function+0x40/0x40
  [<ffffffffa02430e1>] 
extent_write_cache_pages.isra.23.constprop.32+0x1e1/0x3b0 [btrfs]
  [<ffffffffa02434f5>] extent_writepages+0x45/0x60 [btrfs]
  [<ffffffffa0228710>] ? acls_after_inode_item+0xc0/0xc0 [btrfs]
  [<ffffffff81084fd4>] ? bit_waitqueue+0x14/0xc0
  [<ffffffffa0227958>] btrfs_writepages+0x28/0x30 [btrfs]
  [<ffffffff81114e81>] do_writepages+0x21/0x40
  [<ffffffff8118f0b0>] writeback_single_inode+0x180/0x430
  [<ffffffff8118f776>] writeback_sb_inodes+0x1b6/0x270
  [<ffffffff8118f8ce>] __writeback_inodes_wb+0x9e/0xd0
  [<ffffffff8118fb6b>] wb_writeback+0x26b/0x350
  [<ffffffff8118fce8>] wb_check_old_data_flush+0x98/0xa0
  [<ffffffff8119006c>] wb_do_writeback+0x15c/0x200
  [<ffffffff816000b5>] ? schedule_timeout+0x175/0x320
  [<ffffffff81071840>] ? usleep_range+0x50/0x50
  [<ffffffff81190193>] bdi_writeback_thread+0x83/0x2a0
  [<ffffffff81190110>] ? wb_do_writeback+0x200/0x200
  [<ffffffff8108496c>] kthread+0x8c/0xa0
  [<ffffffff8160bb74>] kernel_thread_helper+0x4/0x10
  [<ffffffff810848e0>] ? flush_kthread_worker+0xa0/0xa0
  [<ffffffff8160bb70>] ? gs_change+0x13/0x13
INFO: task rsync:1887 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rsync           D ffff880227d49ab0     0  1887   1884 0x00000000
  ffff8801a2bd7b68 0000000000000086 ffff880200000000 ffff8801a2bd7b08
  ffff880227d496f0 ffff8801a2bd7fd8 ffff8801a2bd7fd8 ffff8801a2bd7fd8
  ffffffff81c0d020 ffff880227d496f0 0000000000000286 000000012fd942f0
Call Trace:
  [<ffffffff815ffb9f>] schedule+0x3f/0x60
  [<ffffffffa022422d>] wait_current_trans.isra.22+0x9d/0x100 [btrfs]
  [<ffffffff81085400>] ? add_wait_queue+0x60/0x60
  [<ffffffffa0225a50>] start_transaction+0x1f0/0x2b0 [btrfs]
  [<ffffffffa0225b65>] btrfs_join_transaction+0x15/0x20 [btrfs]
  [<ffffffffa0230788>] btrfs_dirty_inode+0x48/0x160 [btrfs]
  [<ffffffff8118dfb0>] __mark_inode_dirty+0x40/0x230
  [<ffffffff8117fed7>] file_update_time+0xe7/0x150
  [<ffffffffa02348a0>] btrfs_file_aio_write+0x1c0/0x510 [btrfs]
  [<ffffffff8112f11b>] ? handle_pte_fault+0x61b/0xac0
  [<ffffffff81166c62>] do_sync_write+0xd2/0x110
  [<ffffffff8128dacc>] ? security_file_permission+0x2c/0xb0
  [<ffffffff81167101>] ? rw_verify_area+0x61/0xf0
  [<ffffffff81167463>] vfs_write+0xb3/0x180
  [<ffffffff8116778a>] sys_write+0x4a/0x90
  [<ffffffff81609a02>] system_call_fastpath+0x16/0x1b
INFO: task btrfs-delalloc-:2148 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-delalloc- D ffff880089b8c890     0  2148      2 0x00000000
  ffff880039dbbb40 0000000000000046 0000000000000000 0000000000001000
  ffff880089b8c4d0 ffff880039dbbfd8 ffff880039dbbfd8 ffff880039dbbfd8
  ffff8802321444d0 ffff880089b8c4d0 0000000000000286 000000012fd942f0
Call Trace:
  [<ffffffff815ffb9f>] schedule+0x3f/0x60
  [<ffffffffa022422d>] wait_current_trans.isra.22+0x9d/0x100 [btrfs]
  [<ffffffff81085400>] ? add_wait_queue+0x60/0x60
  [<ffffffffa0225a50>] start_transaction+0x1f0/0x2b0 [btrfs]
  [<ffffffffa0225b65>] btrfs_join_transaction+0x15/0x20 [btrfs]
  [<ffffffffa022c07c>] cow_file_range+0x7c/0x3a0 [btrfs]
  [<ffffffffa022d0f2>] submit_compressed_extents+0x242/0x470 [btrfs]
  [<ffffffffa022d7cc>] ? compress_file_range+0x41c/0x610 [btrfs]
  [<ffffffffa022d3a4>] async_cow_submit+0x84/0x90 [btrfs]
  [<ffffffffa024c490>] run_ordered_completions+0x80/0xe0 [btrfs]
  [<ffffffffa024ce80>] worker_loop+0x180/0x560 [btrfs]
  [<ffffffffa024cd00>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
  [<ffffffff8108496c>] kthread+0x8c/0xa0
  [<ffffffff8160bb74>] kernel_thread_helper+0x4/0x10
  [<ffffffff810848e0>] ? flush_kthread_worker+0xa0/0xa0
  [<ffffffff8160bb70>] ? gs_change+0x13/0x13
INFO: task rsync:2217 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rsync           D ffff880212624890     0  2217   2212 0x00000000
  ffff8801acaabd98 0000000000000082 0000000000000000 0000000000000000
  ffff8802126244d0 ffff8801acaabfd8 ffff8801acaabfd8 ffff8801acaabfd8
  ffff88023212dbc0 ffff8802126244d0 0000000000000282 000000012fd942f0
Call Trace:
  [<ffffffff815ffb9f>] schedule+0x3f/0x60
  [<ffffffffa022422d>] wait_current_trans.isra.22+0x9d/0x100 [btrfs]
  [<ffffffff81085400>] ? add_wait_queue+0x60/0x60
  [<ffffffffa0225995>] start_transaction+0x135/0x2b0 [btrfs]
  [<ffffffff8117651a>] ? kern_path_create+0x8a/0x120
  [<ffffffffa0225de3>] btrfs_start_transaction+0x13/0x20 [btrfs]
  [<ffffffffa0231cb5>] btrfs_link+0xa5/0x1a0 [btrfs]
  [<ffffffff81173211>] vfs_link+0x101/0x190
  [<ffffffff81177648>] sys_linkat+0x168/0x180
  [<ffffffff8117767e>] sys_link+0x1e/0x20
  [<ffffffff81609a02>] system_call_fastpath+0x16/0x1b
INFO: task flush-btrfs-2:1472 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-btrfs-2   D ffff8802313fb1a0     0  1472      2 0x00000000
  ffff880227c318d0 0000000000000046 ffff88006320b798 ffff88006320b768
  ffff8802313fade0 ffff880227c31fd8 ffff880227c31fd8 ffff880227c31fd8
  ffff880211da5bc0 ffff8802313fade0 ffff880227c318d0 ffffffff8108f1fd
Call Trace:
  [<ffffffff8108f1fd>] ? ktime_get_ts+0xad/0xe0
  [<ffffffff81109a30>] ? __lock_page+0x70/0x70
  [<ffffffff815ffb9f>] schedule+0x3f/0x60
  [<ffffffff815ffc4f>] io_schedule+0x8f/0xd0
  [<ffffffff81109a3e>] sleep_on_page+0xe/0x20
  [<ffffffff8160031a>] __wait_on_bit_lock+0x5a/0xc0
  [<ffffffff81109a27>] __lock_page+0x67/0x70
  [<ffffffff81085440>] ? autoremove_wake_function+0x40/0x40
  [<ffffffffa02430e1>] 
extent_write_cache_pages.isra.23.constprop.32+0x1e1/0x3b0 [btrfs]
  [<ffffffffa02434f5>] extent_writepages+0x45/0x60 [btrfs]
  [<ffffffffa0228710>] ? acls_after_inode_item+0xc0/0xc0 [btrfs]
  [<ffffffff81084fd4>] ? bit_waitqueue+0x14/0xc0
  [<ffffffffa0227958>] btrfs_writepages+0x28/0x30 [btrfs]
  [<ffffffff81114e81>] do_writepages+0x21/0x40
  [<ffffffff8118f0b0>] writeback_single_inode+0x180/0x430
  [<ffffffff8118f776>] writeback_sb_inodes+0x1b6/0x270
  [<ffffffff8118f8ce>] __writeback_inodes_wb+0x9e/0xd0
  [<ffffffff8118fb6b>] wb_writeback+0x26b/0x350
  [<ffffffff8118fce8>] wb_check_old_data_flush+0x98/0xa0
  [<ffffffff8119006c>] wb_do_writeback+0x15c/0x200
  [<ffffffff816000b5>] ? schedule_timeout+0x175/0x320
  [<ffffffff81071840>] ? usleep_range+0x50/0x50
  [<ffffffff81190193>] bdi_writeback_thread+0x83/0x2a0
  [<ffffffff81190110>] ? wb_do_writeback+0x200/0x200
  [<ffffffff8108496c>] kthread+0x8c/0xa0
  [<ffffffff8160bb74>] kernel_thread_helper+0x4/0x10
  [<ffffffff810848e0>] ? flush_kthread_worker+0xa0/0xa0
  [<ffffffff8160bb70>] ? gs_change+0x13/0x13
INFO: task rsync:1887 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rsync           D ffff880227d49ab0     0  1887   1884 0x00000000
  ffff8801a2bd7b68 0000000000000086 ffff880200000000 ffff8801a2bd7b08
  ffff880227d496f0 ffff8801a2bd7fd8 ffff8801a2bd7fd8 ffff8801a2bd7fd8
  ffffffff81c0d020 ffff880227d496f0 0000000000000286 000000012fd942f0
Call Trace:
  [<ffffffff815ffb9f>] schedule+0x3f/0x60
  [<ffffffffa022422d>] wait_current_trans.isra.22+0x9d/0x100 [btrfs]
  [<ffffffff81085400>] ? add_wait_queue+0x60/0x60
  [<ffffffffa0225a50>] start_transaction+0x1f0/0x2b0 [btrfs]
  [<ffffffffa0225b65>] btrfs_join_transaction+0x15/0x20 [btrfs]
  [<ffffffffa0230788>] btrfs_dirty_inode+0x48/0x160 [btrfs]
  [<ffffffff8118dfb0>] __mark_inode_dirty+0x40/0x230
  [<ffffffff8117fed7>] file_update_time+0xe7/0x150
  [<ffffffffa02348a0>] btrfs_file_aio_write+0x1c0/0x510 [btrfs]
  [<ffffffff8112f11b>] ? handle_pte_fault+0x61b/0xac0
  [<ffffffff81166c62>] do_sync_write+0xd2/0x110
  [<ffffffff8128dacc>] ? security_file_permission+0x2c/0xb0
  [<ffffffff81167101>] ? rw_verify_area+0x61/0xf0
  [<ffffffff81167463>] vfs_write+0xb3/0x180
  [<ffffffff8116778a>] sys_write+0x4a/0x90
  [<ffffffff81609a02>] system_call_fastpath+0x16/0x1b
INFO: task btrfs-delalloc-:2148 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-delalloc- D ffff880089b8c890     0  2148      2 0x00000000
  ffff880039dbbb40 0000000000000046 0000000000000000 0000000000001000
  ffff880089b8c4d0 ffff880039dbbfd8 ffff880039dbbfd8 ffff880039dbbfd8
  ffff8802321444d0 ffff880089b8c4d0 0000000000000286 000000012fd942f0
Call Trace:
  [<ffffffff815ffb9f>] schedule+0x3f/0x60
  [<ffffffffa022422d>] wait_current_trans.isra.22+0x9d/0x100 [btrfs]
  [<ffffffff81085400>] ? add_wait_queue+0x60/0x60
  [<ffffffffa0225a50>] start_transaction+0x1f0/0x2b0 [btrfs]
  [<ffffffffa0225b65>] btrfs_join_transaction+0x15/0x20 [btrfs]
  [<ffffffffa022c07c>] cow_file_range+0x7c/0x3a0 [btrfs]
  [<ffffffffa022d0f2>] submit_compressed_extents+0x242/0x470 [btrfs]
  [<ffffffffa022d7cc>] ? compress_file_range+0x41c/0x610 [btrfs]
  [<ffffffffa022d3a4>] async_cow_submit+0x84/0x90 [btrfs]
  [<ffffffffa024c490>] run_ordered_completions+0x80/0xe0 [btrfs]
  [<ffffffffa024ce80>] worker_loop+0x180/0x560 [btrfs]
  [<ffffffffa024cd00>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
  [<ffffffff8108496c>] kthread+0x8c/0xa0
  [<ffffffff8160bb74>] kernel_thread_helper+0x4/0x10
  [<ffffffff810848e0>] ? flush_kthread_worker+0xa0/0xa0
  [<ffffffff8160bb70>] ? gs_change+0x13/0x13
INFO: task rsync:2217 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rsync           D ffff880212624890     0  2217   2212 0x00000000
  ffff8801acaabd98 0000000000000082 0000000000000000 0000000000000000
  ffff8802126244d0 ffff8801acaabfd8 ffff8801acaabfd8 ffff8801acaabfd8
  ffff88023212dbc0 ffff8802126244d0 0000000000000282 000000012fd942f0
Call Trace:
  [<ffffffff815ffb9f>] schedule+0x3f/0x60
  [<ffffffffa022422d>] wait_current_trans.isra.22+0x9d/0x100 [btrfs]
  [<ffffffff81085400>] ? add_wait_queue+0x60/0x60
  [<ffffffffa0225995>] start_transaction+0x135/0x2b0 [btrfs]
  [<ffffffff8117651a>] ? kern_path_create+0x8a/0x120
  [<ffffffffa0225de3>] btrfs_start_transaction+0x13/0x20 [btrfs]
  [<ffffffffa0231cb5>] btrfs_link+0xa5/0x1a0 [btrfs]
  [<ffffffff81173211>] vfs_link+0x101/0x190
  [<ffffffff81177648>] sys_linkat+0x168/0x180
  [<ffffffff8117767e>] sys_link+0x1e/0x20
  [<ffffffff81609a02>] system_call_fastpath+0x16/0x1b
INFO: task flush-btrfs-2:1472 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-btrfs-2   D ffff8802313fb1a0     0  1472      2 0x00000000
  ffff880227c318d0 0000000000000046 ffff88006320b798 ffff88006320b768
  ffff8802313fade0 ffff880227c31fd8 ffff880227c31fd8 ffff880227c31fd8
  ffff880211da5bc0 ffff8802313fade0 ffff880227c318d0 ffffffff8108f1fd
Call Trace:
  [<ffffffff8108f1fd>] ? ktime_get_ts+0xad/0xe0
  [<ffffffff81109a30>] ? __lock_page+0x70/0x70
  [<ffffffff815ffb9f>] schedule+0x3f/0x60
  [<ffffffff815ffc4f>] io_schedule+0x8f/0xd0
  [<ffffffff81109a3e>] sleep_on_page+0xe/0x20
  [<ffffffff8160031a>] __wait_on_bit_lock+0x5a/0xc0
  [<ffffffff81109a27>] __lock_page+0x67/0x70
  [<ffffffff81085440>] ? autoremove_wake_function+0x40/0x40
  [<ffffffffa02430e1>] 
extent_write_cache_pages.isra.23.constprop.32+0x1e1/0x3b0 [btrfs]
  [<ffffffffa02434f5>] extent_writepages+0x45/0x60 [btrfs]
  [<ffffffffa0228710>] ? acls_after_inode_item+0xc0/0xc0 [btrfs]
  [<ffffffff81084fd4>] ? bit_waitqueue+0x14/0xc0
  [<ffffffffa0227958>] btrfs_writepages+0x28/0x30 [btrfs]
  [<ffffffff81114e81>] do_writepages+0x21/0x40
  [<ffffffff8118f0b0>] writeback_single_inode+0x180/0x430
  [<ffffffff8118f776>] writeback_sb_inodes+0x1b6/0x270
  [<ffffffff8118f8ce>] __writeback_inodes_wb+0x9e/0xd0
  [<ffffffff8118fb6b>] wb_writeback+0x26b/0x350
  [<ffffffff8118fce8>] wb_check_old_data_flush+0x98/0xa0
  [<ffffffff8119006c>] wb_do_writeback+0x15c/0x200
  [<ffffffff816000b5>] ? schedule_timeout+0x175/0x320
  [<ffffffff81071840>] ? usleep_range+0x50/0x50
  [<ffffffff81190193>] bdi_writeback_thread+0x83/0x2a0
  [<ffffffff81190110>] ? wb_do_writeback+0x200/0x200
  [<ffffffff8108496c>] kthread+0x8c/0xa0
  [<ffffffff8160bb74>] kernel_thread_helper+0x4/0x10
  [<ffffffff810848e0>] ? flush_kthread_worker+0xa0/0xa0
  [<ffffffff8160bb70>] ? gs_change+0x13/0x13
INFO: task rsync:1887 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rsync           D ffff880227d49ab0     0  1887   1884 0x00000004
  ffff8801a2bd7b68 0000000000000086 ffff880200000000 ffff8801a2bd7b08
  ffff880227d496f0 ffff8801a2bd7fd8 ffff8801a2bd7fd8 ffff8801a2bd7fd8
  ffffffff81c0d020 ffff880227d496f0 0000000000000286 000000012fd942f0
Call Trace:
  [<ffffffff815ffb9f>] schedule+0x3f/0x60
  [<ffffffffa022422d>] wait_current_trans.isra.22+0x9d/0x100 [btrfs]
  [<ffffffff81085400>] ? add_wait_queue+0x60/0x60
  [<ffffffffa0225a50>] start_transaction+0x1f0/0x2b0 [btrfs]
  [<ffffffffa0225b65>] btrfs_join_transaction+0x15/0x20 [btrfs]
  [<ffffffffa0230788>] btrfs_dirty_inode+0x48/0x160 [btrfs]
  [<ffffffff8118dfb0>] __mark_inode_dirty+0x40/0x230
  [<ffffffff8117fed7>] file_update_time+0xe7/0x150
  [<ffffffffa02348a0>] btrfs_file_aio_write+0x1c0/0x510 [btrfs]
  [<ffffffff8112f11b>] ? handle_pte_fault+0x61b/0xac0
  [<ffffffff81166c62>] do_sync_write+0xd2/0x110
  [<ffffffff8128dacc>] ? security_file_permission+0x2c/0xb0
  [<ffffffff81167101>] ? rw_verify_area+0x61/0xf0
  [<ffffffff81167463>] vfs_write+0xb3/0x180
  [<ffffffff8116778a>] sys_write+0x4a/0x90
  [<ffffffff81609a02>] system_call_fastpath+0x16/0x1b

I seems that the problem got worse the more data i put on the fs...

Sometime the system is still usable; sometimes i cant access the fs 
anymore (no even sync or umount) and have to hard-reset.

The problem occurs on the stock ubuntu kernel 2.6.38-8, 3.0.0-12, 
3.0.0-13 and on my self-compiled 3.1.2.

Can anyone help?

Tobias
