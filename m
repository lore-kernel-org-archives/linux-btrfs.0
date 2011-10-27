From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: lseek hanging
Date: Thu, 27 Oct 2011 09:36:38 +0000 (UTC)
Message-ID: <slrnjai9h6.4hg.stephane.chazelas@spam.is.invalid>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This morning, I have a strange behavior when doing a "tail -f"
on a log file.

"cat log" runs successfully, but
"tail -f log" hangs.

Running a strace shows it hanging on lseek(3, 0, SEEK_CUR...
3 being the fd for that log file.

In dmesg:

[59881.520030] INFO: task btrfs-delalloc-:763 blocked for more than 120 seconds.
[59881.527205] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[59881.535068] btrfs-delalloc- D 0000000100e2892b     0   763      2 0x00000000
[59881.542161]  ffff88014738bc20 0000000000000046 0000000000004000 0000000000000000
[59881.549673]  0000000000012840 0000000000012840 0000000000012840 ffff8801478c2580
[59881.557147]  0000000000012840 ffff88014738bfd8 0000000000012840 0000000000012840
[59881.568736] Call Trace:
[59881.571219]  [<ffffffffa02ff90c>] wait_current_trans.clone.22+0xab/0xdc [btrfs]
[59881.578589]  [<ffffffff81068ffb>] ? wake_up_bit+0x2a/0x2a
[59881.584012]  [<ffffffff8136f6e6>] ? _raw_spin_lock+0xe/0x10
[59881.589613]  [<ffffffffa0300b3f>] start_transaction+0xe3/0x231 [btrfs]
[59881.596176]  [<ffffffffa0300cd0>] btrfs_join_transaction+0x15/0x17 [btrfs]
[59881.603103]  [<ffffffffa03074bb>] compress_file_range+0x297/0x515 [btrfs]
[59881.609926]  [<ffffffffa030776e>] async_cow_start+0x35/0x4a [btrfs]
[59881.616237]  [<ffffffff8136f736>] ? _raw_spin_lock_irq+0x1f/0x21
[59881.622277]  [<ffffffffa0324f0a>] worker_loop+0x19d/0x4cb [btrfs]
[59881.628433]  [<ffffffffa0324d6d>] ? btrfs_queue_worker+0x27a/0x27a [btrfs]
[59881.635330]  [<ffffffff81068b2c>] kthread+0x82/0x8a
[59881.640227]  [<ffffffff81376124>] kernel_thread_helper+0x4/0x10
[59881.646160]  [<ffffffff81068aaa>] ? kthread_worker_fn+0x14c/0x14c
[59881.652293]  [<ffffffff81376120>] ? gs_change+0x13/0x13
[59881.657555] INFO: task flush-btrfs-1:2675 blocked for more than 120 seconds.
[59881.664617] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[59881.672477] flush-btrfs-1   D 0000000100e28931     0  2675      2 0x00000000
[59881.679628]  ffff88013c559990 0000000000000046 0000000000000000 ffff880100000000
[59881.687118]  0000000000012840 0000000000012840 0000000000012840 ffff88013cf76140
[59881.694591]  0000000000012840 ffff88013c559fd8 0000000000012840 0000000000012840
[59881.702064] Call Trace:
[59881.704536]  [<ffffffff810c9843>] ? lock_page+0x2f/0x2f
[59881.709800]  [<ffffffff8136e084>] io_schedule+0x63/0x7e
[59881.715042]  [<ffffffff810c9851>] sleep_on_page+0xe/0x12
[59881.720376]  [<ffffffff8136e663>] __wait_on_bit_lock+0x46/0x8f
[59881.726241]  [<ffffffff810d3463>] ? pagevec_lru_move_fn+0xaa/0xc0
[59881.732372]  [<ffffffff810c980d>] __lock_page+0x66/0x6d
[59881.737628]  [<ffffffff81069034>] ? autoremove_wake_function+0x39/0x39
[59881.744173]  [<ffffffff8103cea6>] ? should_resched+0xe/0x2e
[59881.749779]  [<ffffffffa0319fa7>] lock_page+0x2a/0x2e [btrfs]
[59881.755631]  [<ffffffffa031cf63>] extent_write_cache_pages.clone.10.clone.17+0xba/0x28e [btrfs]
[59881.764382]  [<ffffffffa031d3a7>] extent_writepages+0x47/0x5c [btrfs]
[59881.770877]  [<ffffffffa0303e3e>] ? uncompress_inline.clone.32+0x119/0x119 [btrfs]
[59881.778494]  [<ffffffffa0302f0e>] btrfs_writepages+0x27/0x29 [btrfs]
[59881.784867]  [<ffffffff810d22d9>] do_writepages+0x21/0x2a
[59881.790302]  [<ffffffff81131aba>] writeback_single_inode+0xb5/0x1c6
[59881.796588]  [<ffffffff81131ddd>] writeback_sb_inodes+0xbc/0x138
[59881.802683]  [<ffffffff8113279e>] writeback_inodes_wb+0x172/0x184
[59881.808795]  [<ffffffff81132a1c>] wb_writeback+0x26c/0x3aa
[59881.814297]  [<ffffffff81132ca1>] wb_do_writeback+0x147/0x1a0
[59881.820081]  [<ffffffff8136e58d>] ? schedule_timeout+0xb3/0xe3
[59881.825947]  [<ffffffff81132d86>] bdi_writeback_thread+0x8c/0x20f
[59881.832056]  [<ffffffff81132cfa>] ? wb_do_writeback+0x1a0/0x1a0
[59881.838062]  [<ffffffff81068b2c>] kthread+0x82/0x8a
[59881.842959]  [<ffffffff81376124>] kernel_thread_helper+0x4/0x10
[59881.848896]  [<ffffffff81068aaa>] ? kthread_worker_fn+0x14c/0x14c
[59881.855005]  [<ffffffff81376120>] ? gs_change+0x13/0x13
[59881.860267] INFO: task ntfsclone:2787 blocked for more than 120 seconds.
[59881.866981] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[59881.874842] ntfsclone       D 0000000100e28625     0  2787   2767 0x00000000
[59881.881929]  ffff88013b421b88 0000000000000082 ffffffff814044e0 0000000000000000
[59881.889399]  0000000000012840 0000000000012840 0000000000012840 ffff88013bcba5c0
[59881.896895]  0000000000012840 ffff88013b421fd8 0000000000012840 0000000000012840
[59881.904388] Call Trace:
[59881.906848]  [<ffffffff81069259>] ? prepare_to_wait+0x76/0x81
[59881.912630]  [<ffffffffa02ff90c>] wait_current_trans.clone.22+0xab/0xdc [btrfs]
[59881.919970]  [<ffffffff81068ffb>] ? wake_up_bit+0x2a/0x2a
[59881.925410]  [<ffffffff8136f6e6>] ? _raw_spin_lock+0xe/0x10
[59881.931014]  [<ffffffffa0300b3f>] start_transaction+0xe3/0x231 [btrfs]
[59881.937572]  [<ffffffffa0300cd0>] btrfs_join_transaction+0x15/0x17 [btrfs]
[59881.944479]  [<ffffffffa0309bc4>] btrfs_dirty_inode+0x2c/0x117 [btrfs]
[59881.951051]  [<ffffffff81131f6a>] __mark_inode_dirty+0x31/0x19e
[59881.957069]  [<ffffffff81129e2b>] ? mnt_clone_write+0x12/0x2a
[59881.962867]  [<ffffffff8112710b>] file_update_time+0xed/0x111
[59881.968725]  [<ffffffffa030d0ed>] btrfs_file_aio_write+0x1a6/0x495 [btrfs]
[59881.975657]  [<ffffffff8111327b>] do_sync_write+0xcb/0x108
[59881.981172]  [<ffffffff811838dc>] ? security_file_permission+0x2e/0x33
[59881.987743]  [<ffffffff811138fa>] vfs_write+0xac/0xff
[59881.992814]  [<ffffffff81113b01>] sys_write+0x4a/0x6e
[59881.997955]  [<ffffffff81375002>] system_call_fastpath+0x16/0x1b
[59882.003978] INFO: task tail:2789 blocked for more than 120 seconds.
[59882.010257] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[59882.018137] tail            D 0000000100e2ca63     0  2789   2604 0x00000004
[59882.025225]  ffff8801337c5e48 0000000000000082 ffff8801337c5e28 ffff880100000000
[59882.032698]  0000000000012840 0000000000012840 0000000000012840 ffff8801337c2700
[59882.040166]  0000000000012840 ffff8801337c5fd8 0000000000012840 0000000000012840
[59882.047648] Call Trace:
[59882.050124]  [<ffffffff8136ea6c>] __mutex_lock_common.clone.5+0x122/0x183
[59882.056928]  [<ffffffff8136eae0>] __mutex_lock_slowpath+0x13/0x15
[59882.063052]  [<ffffffff8136e936>] mutex_lock+0x23/0x37
[59882.068212]  [<ffffffff81113487>] generic_file_llseek+0x29/0x58
[59882.074144]  [<ffffffff81112ffd>] vfs_llseek+0x33/0x35
[59882.079296]  [<ffffffff811134f9>] sys_lseek+0x43/0x5f
[59882.084367]  [<ffffffff81375002>] system_call_fastpath+0x16/0x1b

(ntfsclone writes to that log file).

That's on 3.0 amd64. That FS suffers from a number of other
issues like occasionaly, very slow write (as in a few bytes per
minute), and need a reboot.

In all the other instances where an action "hangs" on that
FS, there's a btrfs kernel task or two that use all the CPU
time. But not in this case.

Note that it managed to unlock itself after a few minutes.

-- 
Stephane

