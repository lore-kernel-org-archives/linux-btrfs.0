From: Dan Merillat <dan.merillat@gmail.com>
Subject: subvolume create hangs when using nonstandard sector sizes
Date: Tue, 20 Mar 2012 02:10:42 -0400
Message-ID: <CAPL5yKeRUCVQr1XEHDmeAzXqRQ7h8SfaxVMGaZo5hnuS4+ApFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: BTRFS Mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kernel 3.3.0, 64bit.
Reproduce:
mkfs.btrfs /dev/foo -s 16k -l 16k -n16k
mount /dev/foo /mnt/foo
cd /mnt/foo
btrfs su create test
hangs hard here, any attempt to access that fs also hangs hard.

Workaround: Don't do it. :)

If it makes a difference, it was a logical volume on top of MD, not a
raw partition.  It also may be more than
just subvolume create that locks up

ran across this entirely by accident, I was creating a test partition
to see if raising my sector size had a performance impact.

[  236.386751] btrfs: disk space caching is enabled
[  480.936040] INFO: task btrfs-transacti:3325 blocked for more than
120 seconds.
[  480.936082] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.936121] btrfs-transacti D ffff88022fc12380 0  3325      2 0x00000000
[  480.936126]  ffff880213ddbd80 0000000000000046 ffff880218410780
0000000000012380
[  480.936131]  ffff880213ddbfd8 ffff880213dda000 0000000000012380
0000000000004000
[  480.936135]  ffff880213ddbfd8 0000000000012380 ffffffff81945020
ffff880218410780
[  480.936139] Call Trace:
[  480.936147]  [<ffffffff8168d33a>] schedule+0x3a/0x50
[  480.936151]  [<ffffffff8134d7dd>] wait_current_trans.clone.22+0x8d/0xf0
[  480.936155]  [<ffffffff81055390>] ? wake_up_bit+0x40/0x40
[  480.936158]  [<ffffffff8134d862>] ? join_transaction.clone.24+0x22/0x270
[  480.936162]  [<ffffffff8134edc8>] start_transaction+0x1f8/0x300
[  480.936165]  [<ffffffff8134ef20>] btrfs_join_transaction+0x10/0x20
[  480.936168]  [<ffffffff81346f7a>] transaction_kthread+0x14a/0x2a0
[  480.936171]  [<ffffffff81346e30>] ? btrfs_alloc_root+0x40/0x40
[  480.936173]  [<ffffffff81346e30>] ? btrfs_alloc_root+0x40/0x40
[  480.936176]  [<ffffffff81346e30>] ? btrfs_alloc_root+0x40/0x40
[  480.936179]  [<ffffffff81054e46>] kthread+0x96/0xa0
[  480.936183]  [<ffffffff816970c4>] kernel_thread_helper+0x4/0x10
[  480.936186]  [<ffffffff8168e6ca>] ? retint_restore_args+0xe/0xe
[  480.936189]  [<ffffffff81054db0>] ? kthread_freezable_should_stop+0x60/0x60
[  480.936192]  [<ffffffff816970c0>] ? gs_change+0xb/0xb

[  480.936410] INFO: task flush-btrfs-5:3329 blocked for more than 120 seconds.
[  480.936446] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.936484] flush-btrfs-5   D ffff88022fc12380     0  3329      2 0x00000000
[  480.936488]  ffff880215105980 0000000000000046 ffff880213de27c0
0000000000012380
[  480.936492]  ffff880215105fd8 ffff880215104000 0000000000012380
0000000000004000
[  480.936496]  ffff880215105fd8 0000000000012380 ffffffff81945020
ffff880213de27c0
[  480.936499] Call Trace:
[  480.936503]  [<ffffffff810ce096>] ? get_page_from_freelist+0x336/0x790
[  480.936506]  [<ffffffff810c6630>] ? __lock_page+0x70/0x70
[  480.936509]  [<ffffffff81071488>] ? ktime_get_ts+0xa8/0xe0
[  480.936512]  [<ffffffff810c6630>] ? __lock_page+0x70/0x70
[  480.936515]  [<ffffffff8168d33a>] schedule+0x3a/0x50
[  480.936518]  [<ffffffff8168d3d7>] io_schedule+0x87/0xd0
[  480.936521]  [<ffffffff810c6639>] sleep_on_page+0x9/0x10
[  480.936523]  [<ffffffff8168b772>] __wait_on_bit_lock+0x52/0xb0
[  480.936526]  [<ffffffff810c6622>] __lock_page+0x62/0x70
[  480.936529]  [<ffffffff810553d0>] ? autoremove_wake_function+0x40/0x40
[  480.936532]  [<ffffffff8136cdfe>]
extent_write_cache_pages.clone.18.clone.29+0x1fe/0x3d0
[  480.936536]  [<ffffffff8136d233>] extent_writepages+0x43/0x60
[  480.936539]  [<ffffffff813525f0>] ? uncompress_inline.clone.36+0x1c0/0x1c0
[  480.936542]  [<ffffffff81055264>] ? bit_waitqueue+0x14/0xd0
[  480.936546]  [<ffffffff81351e22>] btrfs_writepages+0x22/0x30
[  480.936548]  [<ffffffff810d133c>] do_writepages+0x1c/0x30
[  480.936552]  [<ffffffff8113d4f2>] writeback_single_inode+0x102/0x320
[  480.936555]  [<ffffffff8113db80>] writeback_sb_inodes+0x1f0/0x2b0
[  480.936558]  [<ffffffff8113e0d6>] __writeback_inodes_wb+0x96/0xc0
[  480.936560]  [<ffffffff8113e573>] wb_writeback+0x233/0x2c0
[  480.936563]  [<ffffffff8113ee5e>] wb_do_writeback+0x14e/0x200
[  480.936566]  [<ffffffff8113ef10>] ? wb_do_writeback+0x200/0x200
[  480.936569]  [<ffffffff8113efaa>] bdi_writeback_thread+0x9a/0x250
[  480.936572]  [<ffffffff8113ef10>] ? wb_do_writeback+0x200/0x200
[  480.936574]  [<ffffffff8113ef10>] ? wb_do_writeback+0x200/0x200
[  480.936577]  [<ffffffff81054e46>] kthread+0x96/0xa0
[  480.936580]  [<ffffffff816970c4>] kernel_thread_helper+0x4/0x10
[  480.936583]  [<ffffffff8168e6ca>] ? retint_restore_args+0xe/0xe
[  480.936587]  [<ffffffff81054db0>] ? kthread_freezable_should_stop+0x60/0x60
[  480.936590]  [<ffffffff816970c0>] ? gs_change+0xb/0xb

[  600.936181] INFO: task btrfs:3327 blocked for more than 120 seconds.
[  600.936214] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  600.936250] btrfs           D ffff88022fd12380     0  3327      1 0x00000004
[  600.936254]  ffff880213e334d8 0000000000000082 ffff880213e24200
0000000000012380
[  600.936257]  ffff880213e33fd8 ffff880213e32000 0000000000012380
0000000000004000
[  600.936261]  ffff880213e33fd8 0000000000012380 ffff8802270f0300
ffff880213e24200
[  600.936264] Call Trace:
[  600.936267]  [<ffffffff813c4f44>] ? submit_bio+0x84/0x110
[  600.936271]  [<ffffffff81375bcb>] ? btrfs_map_bio+0x15b/0x230
[  600.936275]  [<ffffffff81071488>] ? ktime_get_ts+0xa8/0xe0
[  600.936279]  [<ffffffff810c6630>] ? __lock_page+0x70/0x70
[  600.936281]  [<ffffffff8168d33a>] schedule+0x3a/0x50
[  600.936284]  [<ffffffff8168d3d7>] io_schedule+0x87/0xd0
[  600.936287]  [<ffffffff810c6639>] sleep_on_page+0x9/0x10
[  600.936289]  [<ffffffff8168b8a7>] __wait_on_bit+0x57/0x80
[  600.936292]  [<ffffffff810c685e>] wait_on_page_bit+0x6e/0x80
[  600.936294]  [<ffffffff810553d0>] ? autoremove_wake_function+0x40/0x40
[  600.936298]  [<ffffffff8136ce85>]
extent_write_cache_pages.clone.18.clone.29+0x285/0x3d0
[  600.936302]  [<ffffffff8136d233>] extent_writepages+0x43/0x60
[  600.936306]  [<ffffffff813525f0>] ? uncompress_inline.clone.36+0x1c0/0x1c0
[  600.936309]  [<ffffffff81351e22>] btrfs_writepages+0x22/0x30
[  600.936311]  [<ffffffff810d133c>] do_writepages+0x1c/0x30
[  600.936314]  [<ffffffff810c7318>] __filemap_fdatawrite_range+0x88/0x90
[  600.936317]  [<ffffffff810c81ba>] filemap_fdatawrite+0x1a/0x20
[  600.936320]  [<ffffffff810c81f5>] filemap_write_and_wait+0x35/0x60
[  600.936323]  [<ffffffff813874a7>] __btrfs_write_out_cache+0x8c7/0xb10
[  600.936326]  [<ffffffff8137e9c3>] ? btrfs_tree_unlock+0x23/0xb0
[  600.936331]  [<ffffffff8133d66c>] ? btrfs_run_delayed_refs+0x27c/0x490
[  600.936334]  [<ffffffff81387799>] btrfs_write_out_cache+0xa9/0xe0
[  600.936337]  [<ffffffff8133dccf>] btrfs_write_dirty_block_groups+0x44f/0x520
[  600.936340]  [<ffffffff8134cebd>] commit_cowonly_roots+0x10d/0x1d0
[  600.936343]  [<ffffffff8134e47b>] btrfs_commit_transaction+0x3eb/0x860
[  600.936346]  [<ffffffff81055390>] ? wake_up_bit+0x40/0x40
[  600.936349]  [<ffffffff81378f43>] create_subvol+0x493/0x4d0
[  600.936353]  [<ffffffff8137a6ff>] btrfs_mksubvol+0x16f/0x390
[  600.936356]  [<ffffffff8137aa55>] btrfs_ioctl_snap_create_transid+0x135/0x190
[  600.936359]  [<ffffffff8137ab01>] btrfs_ioctl_snap_create+0x51/0x70
[  600.936362]  [<ffffffff8137d510>] btrfs_ioctl+0x320/0x1220
[  600.936366]  [<ffffffff810ea769>] ? handle_mm_fault+0x159/0x2b0
[  600.936369]  [<ffffffff81691b94>] ? do_page_fault+0x1e4/0x490
[  600.936373]  [<ffffffff81128546>] do_vfs_ioctl+0x96/0x4f0
[  600.936377]  [<ffffffff813ea41a>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[  600.936380]  [<ffffffff81128a29>] sys_ioctl+0x89/0x90
[  600.936383]  [<ffffffff81695ee2>] system_call_fastpath+0x16/0x1b
