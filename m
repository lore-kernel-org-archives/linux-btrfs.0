From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Blocked for more than 120 seconds
Date: Sun, 25 Dec 2011 03:06:56 +0200
Message-ID: <4EF67730.5050108@gmail.com>
References: <4ED5FAEF.8070400@robotech.de> <20111130141006.GY24338@shiny> <4ED738E5.3080200@robotech.de> <20111201184158.GB10535@shiny> <4ED8D6C8.4020609@robotech.de> <4ED8ED36.3080105@gmail.com> <4ED8F34F.8090609@robotech.de> <4ED92CA6.3030302@gmail.com> <4ED96EE6.2010308@gmail.com> <4EDA33FC.5020206@gmail.com> <20111205131252.GB26622@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Tobias <tracer@robotech.de>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111205131252.GB26622@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

I got the same message on a new btrfs filesystem on a raid5 volume=20
(without loop this time). kernel is 3.2rc6
this happened after a day of rsyncing at about 10mbyte/sec, only way to=
=20
reboot is with echo b > /proc/sysrq-trigger

[181201.285259] INFO: task btrfs-submit-1:768 blocked for more than 120=
=20
seconds.
[181201.285297] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[181201.285332] btrfs-submit-1  D 0000000021102920     0   768      2=20
0x00000000
[181201.285368]  ffff88006d1b7aa0 0000000000000046 0000000100000000=20
0000000300000001
[181201.285406]  ffff880072c64020 ffff88006d1b7fd8 ffff88006d1b7fd8=20
ffff88006d1b7fd8
[181201.285443]  ffff88006d900000 ffff880072c64020 ffff88006d1b7a00=20
ffffffff8104e053
[181201.285481] Call Trace:
[181201.285498]  [<ffffffff8104e053>] ? __wake_up+0x53/0x70
[181201.285524]  [<ffffffff8114e95b>] ? kfree+0x3b/0x170
[181201.285552]  [<ffffffffa053535b>] ? plugger_unplug+0x3b/0x50=20
[md_mod]
[181201.285583]  [<ffffffff8121ca57>] ? blk_flush_plug_list+0xa7/0x250
[181201.285612]  [<ffffffff814158bf>] schedule+0x3f/0x60
[181201.285637]  [<ffffffffa058b209>] get_active_stripe+0x2e9/0x600=20
[raid456]
[181201.285669]  [<ffffffffa0534400>] ? max_sync_store+0xc0/0xe0=20
[md_mod]
[181201.285700]  [<ffffffff8105cf10>] ? try_to_wake_up+0x290/0x290
[181201.285727]  [<ffffffffa058ee22>] make_request+0x192/0x430 [raid456=
]
[181201.285758]  [<ffffffff81086850>] ? abort_exclusive_wait+0xb0/0xb0
[181201.285787]  [<ffffffffa053752a>] md_make_request+0xfa/0x240=20
[md_mod]
[181201.285816]  [<ffffffff8114e95b>] ? kfree+0x3b/0x170
[181201.285840]  [<ffffffff8121af47>] generic_make_request+0xc7/0x100
[181201.285868]  [<ffffffff8121b007>] submit_bio+0x87/0x110
[181201.285900]  [<ffffffffa074dcfb>] run_scheduled_bios+0x26b/0x590=20
[btrfs]
[181201.285936]  [<ffffffffa074e035>] pending_bios_fn+0x15/0x20 [btrfs]
[181201.285969]  [<ffffffffa0754870>] worker_loop+0x150/0x520 [btrfs]
[181201.285997]  [<ffffffff8104c568>] ? __wake_up_common+0x58/0x90
[181201.286029]  [<ffffffffa0754720>] ? btrfs_queue_worker+0x300/0x300=20
[btrfs]
[181201.286060]  [<ffffffff81085f0c>] kthread+0x8c/0xa0
[181201.286084]  [<ffffffff8141b234>] kernel_thread_helper+0x4/0x10
[181201.286111]  [<ffffffff81085e80>] ? kthread_worker_fn+0x190/0x190
[181201.286139]  [<ffffffff8141b230>] ? gs_change+0x13/0x13
[181201.286164] INFO: task btrfs-transacti:780 blocked for more than=20
120 seconds.
[181201.286195] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[181201.286230] btrfs-transacti D 00000001033b48f7     0   780      2=20
0x00000000
[181201.286264]  ffff88006d1e9430 0000000000000046 ffff880000000000=20
ffffffff810146ef
[181201.286301]  ffff88006d905ca0 ffff88006d1e9fd8 ffff88006d1e9fd8=20
ffff88006d1e9fd8
[181201.286338]  ffff880073e97200 ffff88006d905ca0 ffff88006d1e9380=20
ffffffff8108cb65
[181201.287224] Call Trace:
[181201.288093]  [<ffffffff810146ef>] ? __switch_to+0xbf/0x2f0
[181201.288986]  [<ffffffff8108cb65>] ? sched_clock_local+0x25/0x90
[181201.289867]  [<ffffffffa0726640>] ? btrfs_buffer_uptodate+0x50/0x70=
=20
[btrfs]
[181201.290744]  [<ffffffffa070c48c>] ? comp_keys+0x2c/0x30 [btrfs]
[181201.291613]  [<ffffffff814158bf>] schedule+0x3f/0x60
[181201.292470]  [<ffffffffa058b209>] get_active_stripe+0x2e9/0x600=20
[raid456]
[181201.293317]  [<ffffffff8105cf10>] ? try_to_wake_up+0x290/0x290
[181201.294170]  [<ffffffffa058ee22>] make_request+0x192/0x430 [raid456=
]
[181201.295030]  [<ffffffff81086850>] ? abort_exclusive_wait+0xb0/0xb0
[181201.295897]  [<ffffffffa053752a>] md_make_request+0xfa/0x240=20
[md_mod]
[181201.296764]  [<ffffffffa074e14e>] ? __btrfs_map_block+0x10e/0x840=20
[btrfs]
[181201.297620]  [<ffffffff8121af47>] generic_make_request+0xc7/0x100
[181201.298463]  [<ffffffff8121b007>] submit_bio+0x87/0x110
[181201.299303]  [<ffffffffa0751ebe>] btrfs_map_bio+0x13e/0x1d0 [btrfs]
[181201.300137]  [<ffffffffa072d799>] btrfs_submit_bio_hook+0xa9/0x170=20
[btrfs]
[181201.300966]  [<ffffffff81199eb1>] ?=20
__bio_add_page.part.14+0x101/0x240
[181201.301803]  [<ffffffffa0745c9a>] submit_one_bio+0x6a/0xa0 [btrfs]
[181201.302644]  [<ffffffffa07492fd>]=20
submit_extent_page.isra.28+0xdd/0x200 [btrfs]
[181201.302651]  [<ffffffffa074a0ac>] __extent_writepage+0x52c/0x740=20
[btrfs]
[181201.302658]  [<ffffffffa0746e80>] ? clear_extent_bit+0x3d0/0x3d0=20
[btrfs]
[181201.302666]  [<ffffffffa074a58a>]=20
extent_write_cache_pages.isra.22.constprop.30+0x2ca/0x3f0 [btrfs]
[181201.302674]  [<ffffffffa074a8f5>] extent_writepages+0x45/0x60=20
[btrfs]
[181201.302681]  [<ffffffffa072f780>] ?=20
uncompress_inline.isra.47+0x1d0/0x1d0 [btrfs]
[181201.302687]  [<ffffffffa0746c7a>] ? clear_extent_bit+0x1ca/0x3d0=20
[btrfs]
[181201.302694]  [<ffffffffa072ea68>] btrfs_writepages+0x28/0x30 [btrfs=
]
[181201.302697]  [<ffffffff8110eb64>] do_writepages+0x24/0x40
[181201.302700]  [<ffffffff811043cb>]=20
__filemap_fdatawrite_range+0x5b/0x60
[181201.302702]  [<ffffffff811043ef>] filemap_fdatawrite+0x1f/0x30
[181201.302704]  [<ffffffff81104435>] filemap_write_and_wait+0x35/0x60
[181201.302711]  [<ffffffffa07616c7>]=20
__btrfs_write_out_cache+0x807/0xa80 [btrfs]
[181201.302717]  [<ffffffffa0767008>] ?=20
btrfs_find_ref_cluster+0x68/0x190 [btrfs]
[181201.302723]  [<ffffffffa07619d5>] btrfs_write_out_cache+0x95/0xf0=20
[btrfs]
[181201.302729]  [<ffffffffa071abe1>]=20
btrfs_write_dirty_block_groups+0x481/0x580 [btrfs]
[181201.302736]  [<ffffffffa0729c05>] commit_cowonly_roots+0x115/0x1e0=20
[btrfs]
[181201.302742]  [<ffffffffa072b3ec>]=20
btrfs_commit_transaction+0x3fc/0x880 [btrfs]
[181201.302745]  [<ffffffff81086850>] ? abort_exclusive_wait+0xb0/0xb0
[181201.302751]  [<ffffffffa072bcc4>] ? start_transaction+0x94/0x2b0=20
[btrfs]
[181201.302758]  [<ffffffffa0723e6d>] transaction_kthread+0x26d/0x290=20
[btrfs]
[181201.302764]  [<ffffffffa0723c00>] ? btrfs_congested_fn+0xd0/0xd0=20
[btrfs]
[181201.302766]  [<ffffffff81085f0c>] kthread+0x8c/0xa0
[181201.302768]  [<ffffffff8141b234>] kernel_thread_helper+0x4/0x10
[181201.302770]  [<ffffffff81085e80>] ? kthread_worker_fn+0x190/0x190
[181201.302772]  [<ffffffff8141b230>] ? gs_change+0x13/0x13
[181201.302775] INFO: task rsync:30933 blocked for more than 120=20
seconds.
[181201.302776] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[181201.302777] rsync           D 00000001033b48f2     0 30933  30932=20
0x00000000
[181201.302779]  ffff880072ce5b98 0000000000000082 0000000000000000=20
0000000000000001
[181201.302781]  ffff88006d9023a0 ffff880072ce5fd8 ffff880072ce5fd8=20
ffff880072ce5fd8
[181201.302783]  ffffffff8180d020 ffff88006d9023a0 ffffffff81177b50=20
00000000000000db
[181201.302785] Call Trace:
[181201.302788]  [<ffffffff81177b50>] ? poll_freewait+0xe0/0xe0
[181201.302790]  [<ffffffff81177c40>] ? __pollwait+0xf0/0xf0
[181201.302792]  [<ffffffff81051970>] ? select_task_rq_fair+0x540/0xa60
[181201.302794]  [<ffffffff814158bf>] schedule+0x3f/0x60
[181201.302800]  [<ffffffffa072a705>]=20
wait_current_trans.isra.22+0xa5/0xf0 [btrfs]
[181201.302803]  [<ffffffff81086850>] ? abort_exclusive_wait+0xb0/0xb0
[181201.302809]  [<ffffffffa072be20>] start_transaction+0x1f0/0x2b0=20
[btrfs]
[181201.302816]  [<ffffffffa072bf35>] btrfs_join_transaction+0x15/0x20=20
[btrfs]
[181201.302823]  [<ffffffffa0736980>] btrfs_dirty_inode+0x50/0xd0=20
[btrfs]
[181201.302830]  [<ffffffffa0736c86>] btrfs_update_time+0xd6/0x170=20
[btrfs]
[181201.302837]  [<ffffffffa073aee8>] btrfs_file_aio_write+0x1c8/0x520=20
[btrfs]
[181201.302840]  [<ffffffff8116e8f2>] ? pipe_read+0x2d2/0x4e0
[181201.302842]  [<ffffffff81164302>] do_sync_write+0xd2/0x110
[181201.302844]  [<ffffffff81051019>] ? finish_task_switch+0x49/0xd0
[181201.302848]  [<ffffffff811f266c>] ?=20
security_file_permission+0x2c/0xb0
[181201.302849]  [<ffffffff811648b1>] ? rw_verify_area+0x61/0xf0
[181201.302851]  [<ffffffff81164c0f>] vfs_write+0xaf/0x180
[181201.302853]  [<ffffffff81164f3a>] sys_write+0x4a/0x90
[181201.302856]  [<ffffffff814190c2>] system_call_fastpath+0x16/0x1b
[181201.302858] INFO: task flush-btrfs-1:30940 blocked for more than=20
120 seconds.
[181201.302859] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[181201.302860] flush-btrfs-1   D 00000001033b5a85     0 30940      2=20
0x00000000
[181201.302862]  ffff8800236218d0 0000000000000046 ffff880000000000=20
ffffffffa075460e
[181201.302864]  ffff88007222b1e0 ffff880023621fd8 ffff880023621fd8=20
ffff880023621fd8
[181201.302866]  ffff880073e97200 ffff88007222b1e0 ffff88000dad1550=20
ffff880023621870
[181201.302868] Call Trace:
[181201.302874]  [<ffffffffa075460e>] ? btrfs_queue_worker+0x1ee/0x300=20
[btrfs]
[181201.302881]  [<ffffffffa07330b5>] ? run_delalloc_range+0x185/0x360=20
[btrfs]
[181201.302883]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[181201.302885]  [<ffffffff81103140>] ? __lock_page+0x70/0x70
[181201.302887]  [<ffffffff814158bf>] schedule+0x3f/0x60
[181201.302889]  [<ffffffff8141596f>] io_schedule+0x8f/0xd0
[181201.302891]  [<ffffffff8110314e>] sleep_on_page+0xe/0x20
[181201.302892]  [<ffffffff8141623a>] __wait_on_bit_lock+0x5a/0xc0
[181201.302894]  [<ffffffff81103137>] __lock_page+0x67/0x70
[181201.302897]  [<ffffffff81086890>] ?=20
autoremove_wake_function+0x40/0x40
[181201.302903]  [<ffffffffa074a4d5>]=20
extent_write_cache_pages.isra.22.constprop.30+0x215/0x3f0 [btrfs]
[181201.302911]  [<ffffffffa074a8f5>] extent_writepages+0x45/0x60=20
[btrfs]
[181201.302917]  [<ffffffffa072f780>] ?=20
uncompress_inline.isra.47+0x1d0/0x1d0 [btrfs]
[181201.302924]  [<ffffffffa072ea68>] btrfs_writepages+0x28/0x30 [btrfs=
]
[181201.302926]  [<ffffffff8110eb64>] do_writepages+0x24/0x40
[181201.302928]  [<ffffffff8118ce0f>] writeback_single_inode+0x10f/0x3f=
0
[181201.302930]  [<ffffffff8118d4ea>] writeback_sb_inodes+0x1aa/0x270
[181201.302932]  [<ffffffff8118d64e>] __writeback_inodes_wb+0x9e/0xd0
[181201.302934]  [<ffffffff8118dc6b>] wb_writeback+0x37b/0x3b0
[181201.302937]  [<ffffffff8117ebd2>] ? get_nr_inodes+0x52/0x70
[181201.302939]  [<ffffffff8117f8d2>] ? get_nr_dirty_inodes+0x52/0x80
[181201.302941]  [<ffffffff8118dd3f>] wb_check_old_data_flush+0x9f/0xb0
[181201.302943]  [<ffffffff8118f21c>] wb_do_writeback+0x19c/0x230
[181201.302944]  [<ffffffff81415e43>] ? schedule_timeout+0x173/0x390
[181201.302947]  [<ffffffff81072c10>] ?=20
init_timer_deferrable_key+0x30/0x30
[181201.302949]  [<ffffffff8118f33c>] bdi_writeback_thread+0x8c/0x340
[181201.302951]  [<ffffffff8118f2b0>] ? wb_do_writeback+0x230/0x230
[181201.302953]  [<ffffffff81085f0c>] kthread+0x8c/0xa0
[181201.302955]  [<ffffffff8141b234>] kernel_thread_helper+0x4/0x10
[181201.302957]  [<ffffffff81085e80>] ? kthread_worker_fn+0x190/0x190
[181201.302959]  [<ffffffff8141b230>] ? gs_change+0x13/0x13
[181201.302960] INFO: task btrfs-delalloc-:30957 blocked for more than=20
120 seconds.
[181201.302962] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[181201.302963] btrfs-delalloc- D 00000001033b5a86     0 30957      2=20
0x00000000
[181201.302965]  ffff88005147fc50 0000000000000046 0080004000000000=20
0800040002000100
[181201.302967]  ffff880072ab8e40 ffff88005147ffd8 ffff88005147ffd8=20
ffff88005147ffd8
[181201.302969]  ffff880073f09c80 ffff880072ab8e40 0000000000000001=20
0000000000000000
[181201.302970] Call Trace:
[181201.302973]  [<ffffffffa06fea84>] ? zlib_tr_flush_block+0x5f4/0x6f0=
=20
[zlib_deflate]
[181201.302975]  [<ffffffffa06fb6cc>] ? flush_pending+0x4c/0x90=20
[zlib_deflate]
[181201.302978]  [<ffffffffa06fb6cc>] ? flush_pending+0x4c/0x90=20
[zlib_deflate]
[181201.302980]  [<ffffffffa06fc506>] ? zlib_deflate+0x1b6/0x410=20
[zlib_deflate]
[181201.302982]  [<ffffffff814158bf>] schedule+0x3f/0x60
[181201.302988]  [<ffffffffa072a705>]=20
wait_current_trans.isra.22+0xa5/0xf0 [btrfs]
[181201.302990]  [<ffffffff81086850>] ? abort_exclusive_wait+0xb0/0xb0
[181201.302997]  [<ffffffffa072be20>] start_transaction+0x1f0/0x2b0=20
[btrfs]
[181201.303003]  [<ffffffffa072bf35>] btrfs_join_transaction+0x15/0x20=20
[btrfs]
[181201.303010]  [<ffffffffa0733a55>] compress_file_range+0x2c5/0x660=20
[btrfs]
[181201.303017]  [<ffffffffa0733e25>] async_cow_start+0x35/0x50 [btrfs]
[181201.303023]  [<ffffffffa0754870>] worker_loop+0x150/0x520 [btrfs]
[181201.303029]  [<ffffffffa0754720>] ? btrfs_queue_worker+0x300/0x300=20
[btrfs]
[181201.303032]  [<ffffffff81085f0c>] kthread+0x8c/0xa0
[181201.303033]  [<ffffffff8141b234>] kernel_thread_helper+0x4/0x10
[181201.303036]  [<ffffffff81085e80>] ? kthread_worker_fn+0x190/0x190
[181201.303037]  [<ffffffff8141b230>] ? gs_change+0x13/0x13
[181321.301930] INFO: task btrfs-submit-1:768 blocked for more than 120=
=20
seconds.
[181321.302761] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[181321.303594] btrfs-submit-1  D 0000000021102920     0   768      2=20
0x00000000
[181321.304428]  ffff88006d1b7aa0 0000000000000046 0000000100000000=20
0000000300000001
[181321.305272]  ffff880072c64020 ffff88006d1b7fd8 ffff88006d1b7fd8=20
ffff88006d1b7fd8
[181321.306110]  ffff88006d900000 ffff880072c64020 ffff88006d1b7a00=20
ffffffff8104e053
[181321.306940] Call Trace:
[181321.307759]  [<ffffffff8104e053>] ? __wake_up+0x53/0x70
[181321.308595]  [<ffffffff8114e95b>] ? kfree+0x3b/0x170
[181321.309428]  [<ffffffffa053535b>] ? plugger_unplug+0x3b/0x50=20
[md_mod]
[181321.310266]  [<ffffffff8121ca57>] ? blk_flush_plug_list+0xa7/0x250
[181321.311107]  [<ffffffff814158bf>] schedule+0x3f/0x60
[181321.311951]  [<ffffffffa058b209>] get_active_stripe+0x2e9/0x600=20
[raid456]
[181321.312805]  [<ffffffffa0534400>] ? max_sync_store+0xc0/0xe0=20
[md_mod]
[181321.313657]  [<ffffffff8105cf10>] ? try_to_wake_up+0x290/0x290
[181321.314510]  [<ffffffffa058ee22>] make_request+0x192/0x430 [raid456=
]
[181321.315376]  [<ffffffff81086850>] ? abort_exclusive_wait+0xb0/0xb0
[181321.316234]  [<ffffffffa053752a>] md_make_request+0xfa/0x240=20
[md_mod]
[181321.317094]  [<ffffffff8114e95b>] ? kfree+0x3b/0x170
[181321.317952]  [<ffffffff8121af47>] generic_make_request+0xc7/0x100
[181321.318821]  [<ffffffff8121b007>] submit_bio+0x87/0x110
[181321.319690]  [<ffffffffa074dcfb>] run_scheduled_bios+0x26b/0x590=20
[btrfs]
[181321.320564]  [<ffffffffa074e035>] pending_bios_fn+0x15/0x20 [btrfs]
[181321.321441]  [<ffffffffa0754870>] worker_loop+0x150/0x520 [btrfs]
[181321.322311]  [<ffffffff8104c568>] ? __wake_up_common+0x58/0x90
[181321.323167]  [<ffffffffa0754720>] ? btrfs_queue_worker+0x300/0x300=20
[btrfs]
[181321.324015]  [<ffffffff81085f0c>] kthread+0x8c/0xa0
[181321.324856]  [<ffffffff8141b234>] kernel_thread_helper+0x4/0x10
[181321.325700]  [<ffffffff81085e80>] ? kthread_worker_fn+0x190/0x190
[181321.326537]  [<ffffffff8141b230>] ? gs_change+0x13/0x13
[181321.327360] INFO: task btrfs-transacti:780 blocked for more than=20
120 seconds.
[181321.328189] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[181321.329035] btrfs-transacti D 00000001033b48f7     0   780      2=20
0x00000000
[181321.329900]  ffff88006d1e9430 0000000000000046 ffff880000000000=20
ffffffff810146ef
[181321.330774]  ffff88006d905ca0 ffff88006d1e9fd8 ffff88006d1e9fd8=20
ffff88006d1e9fd8
[181321.331646]  ffff880073e97200 ffff88006d905ca0 ffff88006d1e9380=20
ffffffff8108cb65
[181321.332527] Call Trace:
[181321.333375]  [<ffffffff810146ef>] ? __switch_to+0xbf/0x2f0
[181321.334238]  [<ffffffff8108cb65>] ? sched_clock_local+0x25/0x90
[181321.335104]  [<ffffffffa0726640>] ? btrfs_buffer_uptodate+0x50/0x70=
=20
[btrfs]
[181321.335980]  [<ffffffffa070c48c>] ? comp_keys+0x2c/0x30 [btrfs]
[181321.336843]  [<ffffffff814158bf>] schedule+0x3f/0x60
[181321.337704]  [<ffffffffa058b209>] get_active_stripe+0x2e9/0x600=20
[raid456]
[181321.338581]  [<ffffffff8105cf10>] ? try_to_wake_up+0x290/0x290
[181321.339447]  [<ffffffffa058ee22>] make_request+0x192/0x430 [raid456=
]
[181321.340320]  [<ffffffff81086850>] ? abort_exclusive_wait+0xb0/0xb0
[181321.341194]  [<ffffffffa053752a>] md_make_request+0xfa/0x240=20
[md_mod]
[181321.342084]  [<ffffffffa074e14e>] ? __btrfs_map_block+0x10e/0x840=20
[btrfs]
[181321.342958]  [<ffffffff8121af47>] generic_make_request+0xc7/0x100
[181321.343818]  [<ffffffff8121b007>] submit_bio+0x87/0x110
[181321.344668]  [<ffffffffa0751ebe>] btrfs_map_bio+0x13e/0x1d0 [btrfs]
[181321.345524]  [<ffffffffa072d799>] btrfs_submit_bio_hook+0xa9/0x170=20
[btrfs]
[181321.346365]  [<ffffffff81199eb1>] ?=20
__bio_add_page.part.14+0x101/0x240
[181321.347216]  [<ffffffffa0745c9a>] submit_one_bio+0x6a/0xa0 [btrfs]
[181321.348059]  [<ffffffffa07492fd>]=20
submit_extent_page.isra.28+0xdd/0x200 [btrfs]
[181321.348912]  [<ffffffffa074a0ac>] __extent_writepage+0x52c/0x740=20
[btrfs]
[181321.349763]  [<ffffffffa0746e80>] ? clear_extent_bit+0x3d0/0x3d0=20
[btrfs]
[181321.350613]  [<ffffffffa074a58a>]=20
extent_write_cache_pages.isra.22.constprop.30+0x2ca/0x3f0 [btrfs]
[181321.351480]  [<ffffffffa074a8f5>] extent_writepages+0x45/0x60=20
[btrfs]
[181321.352351]  [<ffffffffa072f780>] ?=20
uncompress_inline.isra.47+0x1d0/0x1d0 [btrfs]
[181321.353220]  [<ffffffffa0746c7a>] ? clear_extent_bit+0x1ca/0x3d0=20
[btrfs]
[181321.354089]  [<ffffffffa072ea68>] btrfs_writepages+0x28/0x30 [btrfs=
]
[181321.354955]  [<ffffffff8110eb64>] do_writepages+0x24/0x40
[181321.355823]  [<ffffffff811043cb>]=20
__filemap_fdatawrite_range+0x5b/0x60
[181321.356688]  [<ffffffff811043ef>] filemap_fdatawrite+0x1f/0x30
[181321.357546]  [<ffffffff81104435>] filemap_write_and_wait+0x35/0x60
[181321.358408]  [<ffffffffa07616c7>]=20
__btrfs_write_out_cache+0x807/0xa80 [btrfs]
[181321.359281]  [<ffffffffa0767008>] ?=20
btrfs_find_ref_cluster+0x68/0x190 [btrfs]
[181321.360147]  [<ffffffffa07619d5>] btrfs_write_out_cache+0x95/0xf0=20
[btrfs]
[181321.361012]  [<ffffffffa071abe1>]=20
btrfs_write_dirty_block_groups+0x481/0x580 [btrfs]
[181321.361888]  [<ffffffffa0729c05>] commit_cowonly_roots+0x115/0x1e0=20
[btrfs]
[181321.362759]  [<ffffffffa072b3ec>]=20
btrfs_commit_transaction+0x3fc/0x880 [btrfs]
[181321.363632]  [<ffffffff81086850>] ? abort_exclusive_wait+0xb0/0xb0
[181321.364508]  [<ffffffffa072bcc4>] ? start_transaction+0x94/0x2b0=20
[btrfs]
[181321.365388]  [<ffffffffa0723e6d>] transaction_kthread+0x26d/0x290=20
[btrfs]
[181321.366265]  [<ffffffffa0723c00>] ? btrfs_congested_fn+0xd0/0xd0=20
[btrfs]
[181321.367138]  [<ffffffff81085f0c>] kthread+0x8c/0xa0
[181321.368005]  [<ffffffff8141b234>] kernel_thread_helper+0x4/0x10
[181321.368875]  [<ffffffff81085e80>] ? kthread_worker_fn+0x190/0x190
[181321.369726]  [<ffffffff8141b230>] ? gs_change+0x13/0x13
[181321.370560] INFO: task rsync:30933 blocked for more than 120=20
seconds.
[181321.371399] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[181321.372258] rsync           D 00000001033b48f2     0 30933  30932=20
0x00000000
[181321.373125]  ffff880072ce5b98 0000000000000082 0000000000000000=20
0000000000000001
[181321.373990]  ffff88006d9023a0 ffff880072ce5fd8 ffff880072ce5fd8=20
ffff880072ce5fd8
[181321.374857]  ffffffff8180d020 ffff88006d9023a0 ffffffff81177b50=20
00000000000000db
[181321.375735] Call Trace:
[181321.376591]  [<ffffffff81177b50>] ? poll_freewait+0xe0/0xe0
[181321.377461]  [<ffffffff81177c40>] ? __pollwait+0xf0/0xf0
[181321.378325]  [<ffffffff81051970>] ? select_task_rq_fair+0x540/0xa60
[181321.379197]  [<ffffffff814158bf>] schedule+0x3f/0x60
[181321.380058]  [<ffffffffa072a705>]=20
wait_current_trans.isra.22+0xa5/0xf0 [btrfs]
[181321.380929]  [<ffffffff81086850>] ? abort_exclusive_wait+0xb0/0xb0
[181321.381802]  [<ffffffffa072be20>] start_transaction+0x1f0/0x2b0=20
[btrfs]
[181321.382684]  [<ffffffffa072bf35>] btrfs_join_transaction+0x15/0x20=20
[btrfs]
[181321.383561]  [<ffffffffa0736980>] btrfs_dirty_inode+0x50/0xd0=20
[btrfs]
[181321.384434]  [<ffffffffa0736c86>] btrfs_update_time+0xd6/0x170=20
[btrfs]
[181321.385311]  [<ffffffffa073aee8>] btrfs_file_aio_write+0x1c8/0x520=20
[btrfs]
[181321.386179]  [<ffffffff8116e8f2>] ? pipe_read+0x2d2/0x4e0
[181321.387043]  [<ffffffff81164302>] do_sync_write+0xd2/0x110
[181321.387899]  [<ffffffff81051019>] ? finish_task_switch+0x49/0xd0
[181321.388763]  [<ffffffff811f266c>] ?=20
security_file_permission+0x2c/0xb0
[181321.389623]  [<ffffffff811648b1>] ? rw_verify_area+0x61/0xf0
[181321.390475]  [<ffffffff81164c0f>] vfs_write+0xaf/0x180
[181321.391324]  [<ffffffff81164f3a>] sys_write+0x4a/0x90
[181321.392163]  [<ffffffff814190c2>] system_call_fastpath+0x16/0x1b
[181321.392993] INFO: task flush-btrfs-1:30940 blocked for more than=20
120 seconds.
[181321.393826] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[181321.394670] flush-btrfs-1   D 00000001033b5a85     0 30940      2=20
0x00000000
[181321.395531]  ffff8800236218d0 0000000000000046 ffff880000000000=20
ffffffffa075460e
[181321.396394]  ffff88007222b1e0 ffff880023621fd8 ffff880023621fd8=20
ffff880023621fd8
[181321.397258]  ffff880073e97200 ffff88007222b1e0 ffff88000dad1550=20
ffff880023621870
[181321.398118] Call Trace:
[181321.398977]  [<ffffffffa075460e>] ? btrfs_queue_worker+0x1ee/0x300=20
[btrfs]
[181321.399856]  [<ffffffffa07330b5>] ? run_delalloc_range+0x185/0x360=20
[btrfs]
[181321.400728]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[181321.401593]  [<ffffffff81103140>] ? __lock_page+0x70/0x70
[181321.402460]  [<ffffffff814158bf>] schedule+0x3f/0x60
[181321.403310]  [<ffffffff8141596f>] io_schedule+0x8f/0xd0
[181321.404153]  [<ffffffff8110314e>] sleep_on_page+0xe/0x20
[181321.404988]  [<ffffffff8141623a>] __wait_on_bit_lock+0x5a/0xc0
[181321.405829]  [<ffffffff81103137>] __lock_page+0x67/0x70
[181321.406660]  [<ffffffff81086890>] ?=20
autoremove_wake_function+0x40/0x40
[181321.407500]  [<ffffffffa074a4d5>]=20
extent_write_cache_pages.isra.22.constprop.30+0x215/0x3f0 [btrfs]
[181321.408359]  [<ffffffffa074a8f5>] extent_writepages+0x45/0x60=20
[btrfs]
[181321.409220]  [<ffffffffa072f780>] ?=20
uncompress_inline.isra.47+0x1d0/0x1d0 [btrfs]
[181321.410085]  [<ffffffffa072ea68>] btrfs_writepages+0x28/0x30 [btrfs=
]
[181321.410946]  [<ffffffff8110eb64>] do_writepages+0x24/0x40
[181321.411799]  [<ffffffff8118ce0f>] writeback_single_inode+0x10f/0x3f=
0
[181321.412651]  [<ffffffff8118d4ea>] writeback_sb_inodes+0x1aa/0x270
[181321.413480]  [<ffffffff8118d64e>] __writeback_inodes_wb+0x9e/0xd0
[181321.414304]  [<ffffffff8118dc6b>] wb_writeback+0x37b/0x3b0
[181321.415118]  [<ffffffff8117ebd2>] ? get_nr_inodes+0x52/0x70
[181321.415934]  [<ffffffff8117f8d2>] ? get_nr_dirty_inodes+0x52/0x80
[181321.416731]  [<ffffffff8118dd3f>] wb_check_old_data_flush+0x9f/0xb0
[181321.417525]  [<ffffffff8118f21c>] wb_do_writeback+0x19c/0x230
[181321.418322]  [<ffffffff81415e43>] ? schedule_timeout+0x173/0x390
[181321.419127]  [<ffffffff81072c10>] ?=20
init_timer_deferrable_key+0x30/0x30
[181321.419928]  [<ffffffff8118f33c>] bdi_writeback_thread+0x8c/0x340
[181321.420724]  [<ffffffff8118f2b0>] ? wb_do_writeback+0x230/0x230
[181321.421513]  [<ffffffff81085f0c>] kthread+0x8c/0xa0
[181321.422300]  [<ffffffff8141b234>] kernel_thread_helper+0x4/0x10
[181321.423086]  [<ffffffff81085e80>] ? kthread_worker_fn+0x190/0x190
[181321.423868]  [<ffffffff8141b230>] ? gs_change+0x13/0x13
[181321.424650] INFO: task btrfs-delalloc-:30957 blocked for more than=20
120 seconds.
[181321.425455] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[181321.426264] btrfs-delalloc- D 00000001033b5a86     0 30957      2=20
0x00000000
[181321.427088]  ffff88005147fc50 0000000000000046 0080004000000000=20
0800040002000100
[181321.427922]  ffff880072ab8e40 ffff88005147ffd8 ffff88005147ffd8=20
ffff88005147ffd8
[181321.428764]  ffff880073f09c80 ffff880072ab8e40 0000000000000001=20
0000000000000000
[181321.429604] Call Trace:
[181321.430433]  [<ffffffffa06fea84>] ? zlib_tr_flush_block+0x5f4/0x6f0=
=20
[zlib_deflate]
[181321.431299]  [<ffffffffa06fb6cc>] ? flush_pending+0x4c/0x90=20
[zlib_deflate]
[181321.432176]  [<ffffffffa06fb6cc>] ? flush_pending+0x4c/0x90=20
[zlib_deflate]
[181321.433026]  [<ffffffffa06fc506>] ? zlib_deflate+0x1b6/0x410=20
[zlib_deflate]
[181321.433865]  [<ffffffff814158bf>] schedule+0x3f/0x60
[181321.434692]  [<ffffffffa072a705>]=20
wait_current_trans.isra.22+0xa5/0xf0 [btrfs]
[181321.435529]  [<ffffffff81086850>] ? abort_exclusive_wait+0xb0/0xb0
[181321.436362]  [<ffffffffa072be20>] start_transaction+0x1f0/0x2b0=20
[btrfs]
[181321.437204]  [<ffffffffa072bf35>] btrfs_join_transaction+0x15/0x20=20
[btrfs]
[181321.438039]  [<ffffffffa0733a55>] compress_file_range+0x2c5/0x660=20
[btrfs]
[181321.438876]  [<ffffffffa0733e25>] async_cow_start+0x35/0x50 [btrfs]
[181321.439707]  [<ffffffffa0754870>] worker_loop+0x150/0x520 [btrfs]
[181321.440535]  [<ffffffffa0754720>] ? btrfs_queue_worker+0x300/0x300=20
[btrfs]
[181321.441366]  [<ffffffff81085f0c>] kthread+0x8c/0xa0
[181321.442202]  [<ffffffff8141b234>] kernel_thread_helper+0x4/0x10
[181321.443039]  [<ffffffff81085e80>] ? kthread_worker_fn+0x190/0x190
[181321.443880]  [<ffffffff8141b230>] ? gs_change+0x13/0x13


On =CE=94=CE=B5=CF=85=CF=84=CE=AD=CF=81=CE=B1, 5 =CE=94=CE=B5=CE=BA=CE=AD=
=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 3:12:52 =CE=BC=CE=BC, Chris M=
ason wrote:
> On Sat, Dec 03, 2011 at 04:36:44PM +0200, Konstantinos Skarlatos wrot=
e:
>> unfortunately i was wrong. rc4 does not fix this issue for me when
>> rsyncing large amounts of data...
>>
>> my mount options:
>> mount -o loop,compress=3Dzlib,compress-force btrfs_test /storage/btr=
fs
>> the filesystem is a file on a raid5 xfs volume.
>
> Oh, the loop + raid5 + xfs is going to cause problems.  The loop driv=
er
> is fine for testing but I wouldn't be using it in a production
> environment.
>
> -chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
