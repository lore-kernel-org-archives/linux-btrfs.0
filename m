Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60692 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbcHIR2B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 13:28:01 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1bXAoo-0000kH-4W
	for linux-btrfs@vger.kernel.org; Tue, 09 Aug 2016 17:27:58 +0000
Date: Tue, 9 Aug 2016 17:27:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: btrfs dev del hangs on 4.7
Message-ID: <20160809172758.GB9644@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Over the weekend, I started doing some maintenance on my server: I
upgraded to 4.7.0, and I started deleting a device from my array,
preparatory to putting in a larger one. About halfway through the
operation, several kernel threads hung up for a while (resulting in
"blocked for 120s" messages), and then the delete process seems to
have stopped entirely, although several kernel threads are at maximum
usage.

   After a few hours, I rebooted the machine, and left it for a day or
so. I tried the delete again this afternoon, and it's done the same
thing again. The full log is included below. I have a kworker and a
btrfs-transaction pegged at close to 100% of a core each, and a
btrfs-cleaner (and the btrfs dev del process) in D state.

   The FS was not under load at the time of the failure, and it passes
scrub. I haven't tried a btrfs check yet.

   Hugo.

Aug  9 15:36:17 s_src@amelia kernel: BTRFS info (device sda2): found 6 extents
Aug  9 15:36:20 s_src@amelia kernel: BTRFS info (device sda2): relocating block group 33406415011840 flags 17
Aug  9 15:36:36 s_src@amelia kernel: BTRFS info (device sda2): found 6 extents
Aug  9 15:36:54 s_src@amelia kernel: BTRFS info (device sda2): found 6 extents
Aug  9 15:36:57 s_src@amelia kernel: BTRFS info (device sda2): relocating block group 31066731577344 flags 17
Aug  9 15:37:18 s_src@amelia kernel: BTRFS info (device sda2): found 1188 extents
Aug  9 15:43:56 s_src@amelia kernel: INFO: task btrfs-cleaner:2102 blocked for more than 120 seconds.
Aug  9 15:43:56 s_src@amelia kernel:       Not tainted 4.7.0-dirty #153
Aug  9 15:43:56 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  9 15:43:56 s_src@amelia kernel: btrfs-cleaner   D ffff88021fc95f40     0  2102      2 0x00000000
Aug  9 15:43:56 s_src@amelia kernel:  ffff8800d9223700 0000000000000005 ffff88021fc0c850 ffff880210954000
Aug  9 15:43:56 s_src@amelia kernel:  ffff880210953e10 ffff8800d9223700 ffff88021691d018 ffff88021691d014
Aug  9 15:43:56 s_src@amelia kernel:  00000000ffffffff ffffffff8141d06a ffff88021691d010 ffffffff8141d209
Aug  9 15:43:56 s_src@amelia kernel: Call Trace:
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141d06a>] ? schedule+0x78/0x85
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141d209>] ? schedule_preempt_disabled+0x5/0x6
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141e041>] ? __mutex_lock_slowpath+0xa9/0x116
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff81178ecf>] ? btrfs_delete_unused_bgs+0xb5/0x346
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8117f6a5>] ? cleaner_kthread+0xf2/0x1a8
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8117f5b3>] ? btree_invalidatepage+0x85/0x85
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff81057ba0>] ? kthread+0x95/0x9d
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141f2ff>] ? ret_from_fork+0x1f/0x40
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff81057b0b>] ? init_completion+0x1d/0x1d
Aug  9 15:43:56 s_src@amelia kernel: INFO: task btrfs:27655 blocked for more than 120 seconds.
Aug  9 15:43:56 s_src@amelia kernel:       Not tainted 4.7.0-dirty #153
Aug  9 15:43:56 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  9 15:43:56 s_src@amelia kernel: btrfs           D ffff88021fc15f40     0 27655  27647 0x00000000
Aug  9 15:43:56 s_src@amelia kernel:  ffff8800d9988b00 ffff88016e7a7ae0 ffff88021fc95fa8 ffff88016e7a8000
Aug  9 15:43:56 s_src@amelia kernel:  ffff88016e7a7b10 ffff8800d9988b00 0000000000000002 ffffffff8141e80a
Aug  9 15:43:56 s_src@amelia kernel:  ffff8800d9988b00 ffffffff8141d06a 7fffffffffffffff ffffffff8141e839
Aug  9 15:43:56 s_src@amelia kernel: Call Trace:
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141e80a>] ? usleep_range+0x35/0x35
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141d06a>] ? schedule+0x78/0x85
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141e839>] ? schedule_timeout+0x2f/0x105
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8102cd97>] ? __default_send_IPI_dest_field+0x34/0x4f
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8105d85d>] ? check_preempt_curr+0x41/0x63
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141d73b>] ? do_wait_for_common+0xea/0x11b
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8105e62c>] ? try_to_wake_up+0x1c6/0x1d7
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141d73b>] ? do_wait_for_common+0xea/0x11b
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8105e684>] ? wake_up_q+0x3b/0x3b
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141d797>] ? wait_for_common+0x2b/0x35
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff811710a8>] ? btrfs_async_run_delayed_refs+0xc6/0xdc
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff811876e1>] ? __btrfs_end_transaction+0x294/0x2d8
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff811c7c79>] ? relocate_block_group+0x46b/0x4ca
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff811c7e0f>] ? btrfs_relocate_block_group+0x137/0x25f
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff811a6cbf>] ? btrfs_relocate_chunk.isra.36+0x3c/0xad
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff811a74dd>] ? btrfs_shrink_device+0x20b/0x497
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff811ad18a>] ? btrfs_rm_device+0x1f2/0x4f9
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff811b3e58>] ? btrfs_ioctl+0x846/0x1e93
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff810a3e46>] ? from_kgid_munged+0x9/0x14
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8110a71a>] ? cp_new_stat+0x139/0x150
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff81113cd5>] ? vfs_ioctl+0x16/0x23
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff81113cd5>] ? vfs_ioctl+0x16/0x23
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff811141ed>] ? do_vfs_ioctl+0x498/0x508
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8110a750>] ? SYSC_newstat+0x1f/0x27
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff81114296>] ? SyS_ioctl+0x39/0x55
Aug  9 15:43:56 s_src@amelia kernel:  [<ffffffff8141f0df>] ? entry_SYSCALL_64_fastpath+0x17/0x93
Aug  9 15:45:56 s_src@amelia kernel: INFO: task btrfs-cleaner:2102 blocked for more than 120 seconds.
Aug  9 15:45:56 s_src@amelia kernel:       Not tainted 4.7.0-dirty #153
Aug  9 15:45:56 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  9 15:45:56 s_src@amelia kernel: btrfs-cleaner   D ffff88021fc95f40     0  2102      2 0x00000000
Aug  9 15:45:56 s_src@amelia kernel:  ffff8800d9223700 0000000000000005 ffff88021fc0c850 ffff880210954000
Aug  9 15:45:56 s_src@amelia kernel:  ffff880210953e10 ffff8800d9223700 ffff88021691d018 ffff88021691d014
Aug  9 15:45:56 s_src@amelia kernel:  00000000ffffffff ffffffff8141d06a ffff88021691d010 ffffffff8141d209
Aug  9 15:45:56 s_src@amelia kernel: Call Trace:
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141d06a>] ? schedule+0x78/0x85
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141d209>] ? schedule_preempt_disabled+0x5/0x6
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141e041>] ? __mutex_lock_slowpath+0xa9/0x116
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff81178ecf>] ? btrfs_delete_unused_bgs+0xb5/0x346
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8117f6a5>] ? cleaner_kthread+0xf2/0x1a8
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8117f5b3>] ? btree_invalidatepage+0x85/0x85
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff81057ba0>] ? kthread+0x95/0x9d
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141f2ff>] ? ret_from_fork+0x1f/0x40
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff81057b0b>] ? init_completion+0x1d/0x1d
Aug  9 15:45:56 s_src@amelia kernel: INFO: task btrfs:27655 blocked for more than 120 seconds.
Aug  9 15:45:56 s_src@amelia kernel:       Not tainted 4.7.0-dirty #153
Aug  9 15:45:56 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  9 15:45:56 s_src@amelia kernel: btrfs           D ffff88021fc15f40     0 27655  27647 0x00000000
Aug  9 15:45:56 s_src@amelia kernel:  ffff8800d9988b00 ffff88016e7a7ae0 ffff88021fc95fa8 ffff88016e7a8000
Aug  9 15:45:56 s_src@amelia kernel:  ffff88016e7a7b10 ffff8800d9988b00 0000000000000002 ffffffff8141e80a
Aug  9 15:45:56 s_src@amelia kernel:  ffff8800d9988b00 ffffffff8141d06a 7fffffffffffffff ffffffff8141e839
Aug  9 15:45:56 s_src@amelia kernel: Call Trace:
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141e80a>] ? usleep_range+0x35/0x35
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141d06a>] ? schedule+0x78/0x85
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141e839>] ? schedule_timeout+0x2f/0x105
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8102cd97>] ? __default_send_IPI_dest_field+0x34/0x4f
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8105d85d>] ? check_preempt_curr+0x41/0x63
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141d73b>] ? do_wait_for_common+0xea/0x11b
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8105e62c>] ? try_to_wake_up+0x1c6/0x1d7
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141d73b>] ? do_wait_for_common+0xea/0x11b
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8105e684>] ? wake_up_q+0x3b/0x3b
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141d797>] ? wait_for_common+0x2b/0x35
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff811710a8>] ? btrfs_async_run_delayed_refs+0xc6/0xdc
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff811876e1>] ? __btrfs_end_transaction+0x294/0x2d8
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff811c7c79>] ? relocate_block_group+0x46b/0x4ca
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff811c7e0f>] ? btrfs_relocate_block_group+0x137/0x25f
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff811a6cbf>] ? btrfs_relocate_chunk.isra.36+0x3c/0xad
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff811a74dd>] ? btrfs_shrink_device+0x20b/0x497
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff811ad18a>] ? btrfs_rm_device+0x1f2/0x4f9
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff811b3e58>] ? btrfs_ioctl+0x846/0x1e93
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff810a3e46>] ? from_kgid_munged+0x9/0x14
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8110a71a>] ? cp_new_stat+0x139/0x150
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff81113cd5>] ? vfs_ioctl+0x16/0x23
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff81113cd5>] ? vfs_ioctl+0x16/0x23
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff811141ed>] ? do_vfs_ioctl+0x498/0x508
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8110a750>] ? SYSC_newstat+0x1f/0x27
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff81114296>] ? SyS_ioctl+0x39/0x55
Aug  9 15:45:56 s_src@amelia kernel:  [<ffffffff8141f0df>] ? entry_SYSCALL_64_fastpath+0x17/0x93
Aug  9 15:47:56 s_src@amelia kernel: INFO: task btrfs-cleaner:2102 blocked for more than 120 seconds.
Aug  9 15:47:56 s_src@amelia kernel:       Not tainted 4.7.0-dirty #153
Aug  9 15:47:56 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  9 15:47:56 s_src@amelia kernel: btrfs-cleaner   D ffff88021fc95f40     0  2102      2 0x00000000
Aug  9 15:47:56 s_src@amelia kernel:  ffff8800d9223700 0000000000000005 ffff88021fc0c850 ffff880210954000
Aug  9 15:47:56 s_src@amelia kernel:  ffff880210953e10 ffff8800d9223700 ffff88021691d018 ffff88021691d014
Aug  9 15:47:56 s_src@amelia kernel:  00000000ffffffff ffffffff8141d06a ffff88021691d010 ffffffff8141d209
Aug  9 15:47:56 s_src@amelia kernel: Call Trace:
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff8141d06a>] ? schedule+0x78/0x85
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff8141d209>] ? schedule_preempt_disabled+0x5/0x6
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff8141e041>] ? __mutex_lock_slowpath+0xa9/0x116
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff81178ecf>] ? btrfs_delete_unused_bgs+0xb5/0x346
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff8117f6a5>] ? cleaner_kthread+0xf2/0x1a8
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff8117f5b3>] ? btree_invalidatepage+0x85/0x85
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff81057ba0>] ? kthread+0x95/0x9d
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff8141f2ff>] ? ret_from_fork+0x1f/0x40
Aug  9 15:47:56 s_src@amelia kernel:  [<ffffffff81057b0b>] ? init_completion+0x1d/0x1d
Aug  9 15:53:56 s_src@amelia kernel: INFO: task btrfs-cleaner:2102 blocked for more than 120 seconds.
Aug  9 15:53:56 s_src@amelia kernel:       Not tainted 4.7.0-dirty #153
Aug  9 15:53:56 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  9 15:53:56 s_src@amelia kernel: btrfs-cleaner   D ffff88021fc15f40     0  2102      2 0x00000000
Aug  9 15:53:56 s_src@amelia kernel:  ffff8800d9223700 0000000000000005 ffff88021fc0c850 ffff880210954000
Aug  9 15:53:56 s_src@amelia kernel:  ffff880210953e10 ffff8800d9223700 ffff88021691d018 ffff88021691d014
Aug  9 15:53:56 s_src@amelia kernel:  00000000ffffffff ffffffff8141d06a ffff88021691d010 ffffffff8141d209
Aug  9 15:53:56 s_src@amelia kernel: Call Trace:
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141d06a>] ? schedule+0x78/0x85
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141d209>] ? schedule_preempt_disabled+0x5/0x6
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141e041>] ? __mutex_lock_slowpath+0xa9/0x116
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff81178ecf>] ? btrfs_delete_unused_bgs+0xb5/0x346
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8117f6a5>] ? cleaner_kthread+0xf2/0x1a8
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8117f5b3>] ? btree_invalidatepage+0x85/0x85
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff81057ba0>] ? kthread+0x95/0x9d
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141f2ff>] ? ret_from_fork+0x1f/0x40
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff81057b0b>] ? init_completion+0x1d/0x1d
Aug  9 15:53:56 s_src@amelia kernel: INFO: task btrfs:27655 blocked for more than 120 seconds.
Aug  9 15:53:56 s_src@amelia kernel:       Not tainted 4.7.0-dirty #153
Aug  9 15:53:56 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  9 15:53:56 s_src@amelia kernel: btrfs           D ffff88021fc95f40     0 27655  27647 0x00000000
Aug  9 15:53:56 s_src@amelia kernel:  ffff8800d9988b00 ffff88016e7a7ae0 ffff88021fc15fa8 ffff88016e7a8000
Aug  9 15:53:56 s_src@amelia kernel:  ffff88016e7a7b10 ffff8800d9988b00 0000000000000002 ffffffff8141e80a
Aug  9 15:53:56 s_src@amelia kernel:  ffff8800d9988b00 ffffffff8141d06a 7fffffffffffffff ffffffff8141e839
Aug  9 15:53:56 s_src@amelia kernel: Call Trace:
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141e80a>] ? usleep_range+0x35/0x35
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141d06a>] ? schedule+0x78/0x85
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141e839>] ? schedule_timeout+0x2f/0x105
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8102cd97>] ? __default_send_IPI_dest_field+0x34/0x4f
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8105d85d>] ? check_preempt_curr+0x41/0x63
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141d73b>] ? do_wait_for_common+0xea/0x11b
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8105e62c>] ? try_to_wake_up+0x1c6/0x1d7
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141d73b>] ? do_wait_for_common+0xea/0x11b
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8105e684>] ? wake_up_q+0x3b/0x3b
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141d797>] ? wait_for_common+0x2b/0x35
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff811710a8>] ? btrfs_async_run_delayed_refs+0xc6/0xdc
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff811876e1>] ? __btrfs_end_transaction+0x294/0x2d8
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff811c7c79>] ? relocate_block_group+0x46b/0x4ca
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff811c7e0f>] ? btrfs_relocate_block_group+0x137/0x25f
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff811a6cbf>] ? btrfs_relocate_chunk.isra.36+0x3c/0xad
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff811a74dd>] ? btrfs_shrink_device+0x20b/0x497
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff811ad18a>] ? btrfs_rm_device+0x1f2/0x4f9
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff811b3e58>] ? btrfs_ioctl+0x846/0x1e93
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff810a3e46>] ? from_kgid_munged+0x9/0x14
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8110a71a>] ? cp_new_stat+0x139/0x150
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff81113cd5>] ? vfs_ioctl+0x16/0x23
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff81113cd5>] ? vfs_ioctl+0x16/0x23
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff811141ed>] ? do_vfs_ioctl+0x498/0x508
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8110a750>] ? SYSC_newstat+0x1f/0x27
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff81114296>] ? SyS_ioctl+0x39/0x55
Aug  9 15:53:56 s_src@amelia kernel:  [<ffffffff8141f0df>] ? entry_SYSCALL_64_fastpath+0x17/0x93
Aug  9 15:55:56 s_src@amelia kernel: INFO: task btrfs-cleaner:2102 blocked for more than 120 seconds.
Aug  9 15:55:56 s_src@amelia kernel:       Not tainted 4.7.0-dirty #153
Aug  9 15:55:56 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  9 15:55:56 s_src@amelia kernel: btrfs-cleaner   D ffff88021fc15f40     0  2102      2 0x00000000
Aug  9 15:55:56 s_src@amelia kernel:  ffff8800d9223700 0000000000000005 ffff88021fc0c850 ffff880210954000
Aug  9 15:55:56 s_src@amelia kernel:  ffff880210953e10 ffff8800d9223700 ffff88021691d018 ffff88021691d014
Aug  9 15:55:56 s_src@amelia kernel:  00000000ffffffff ffffffff8141d06a ffff88021691d010 ffffffff8141d209
Aug  9 15:55:56 s_src@amelia kernel: Call Trace:
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141d06a>] ? schedule+0x78/0x85
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141d209>] ? schedule_preempt_disabled+0x5/0x6
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141e041>] ? __mutex_lock_slowpath+0xa9/0x116
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff81178ecf>] ? btrfs_delete_unused_bgs+0xb5/0x346
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8117f6a5>] ? cleaner_kthread+0xf2/0x1a8
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8117f5b3>] ? btree_invalidatepage+0x85/0x85
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff81057ba0>] ? kthread+0x95/0x9d
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141f2ff>] ? ret_from_fork+0x1f/0x40
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff81057b0b>] ? init_completion+0x1d/0x1d
Aug  9 15:55:56 s_src@amelia kernel: INFO: task btrfs:27655 blocked for more than 120 seconds.
Aug  9 15:55:56 s_src@amelia kernel:       Not tainted 4.7.0-dirty #153
Aug  9 15:55:56 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  9 15:55:56 s_src@amelia kernel: btrfs           D ffff88021fc95f40     0 27655  27647 0x00000000
Aug  9 15:55:56 s_src@amelia kernel:  ffff8800d9988b00 ffff88016e7a7ae0 ffff88021fc15fa8 ffff88016e7a8000
Aug  9 15:55:56 s_src@amelia kernel:  ffff88016e7a7b10 ffff8800d9988b00 0000000000000002 ffffffff8141e80a
Aug  9 15:55:56 s_src@amelia kernel:  ffff8800d9988b00 ffffffff8141d06a 7fffffffffffffff ffffffff8141e839
Aug  9 15:55:56 s_src@amelia kernel: Call Trace:
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141e80a>] ? usleep_range+0x35/0x35
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141d06a>] ? schedule+0x78/0x85
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141e839>] ? schedule_timeout+0x2f/0x105
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8102cd97>] ? __default_send_IPI_dest_field+0x34/0x4f
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8105d85d>] ? check_preempt_curr+0x41/0x63
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141d73b>] ? do_wait_for_common+0xea/0x11b
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8105e62c>] ? try_to_wake_up+0x1c6/0x1d7
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141d73b>] ? do_wait_for_common+0xea/0x11b
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8105e684>] ? wake_up_q+0x3b/0x3b
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141d797>] ? wait_for_common+0x2b/0x35
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff811710a8>] ? btrfs_async_run_delayed_refs+0xc6/0xdc
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff811876e1>] ? __btrfs_end_transaction+0x294/0x2d8
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff811c7c79>] ? relocate_block_group+0x46b/0x4ca
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff811c7e0f>] ? btrfs_relocate_block_group+0x137/0x25f
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff811a6cbf>] ? btrfs_relocate_chunk.isra.36+0x3c/0xad
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff811a74dd>] ? btrfs_shrink_device+0x20b/0x497
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff811ad18a>] ? btrfs_rm_device+0x1f2/0x4f9
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff811b3e58>] ? btrfs_ioctl+0x846/0x1e93
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff810a3e46>] ? from_kgid_munged+0x9/0x14
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8110a71a>] ? cp_new_stat+0x139/0x150
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff81113cd5>] ? vfs_ioctl+0x16/0x23
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff81113cd5>] ? vfs_ioctl+0x16/0x23
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff811141ed>] ? do_vfs_ioctl+0x498/0x508
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8110a750>] ? SYSC_newstat+0x1f/0x27
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff81114296>] ? SyS_ioctl+0x39/0x55
Aug  9 15:55:56 s_src@amelia kernel:  [<ffffffff8141f0df>] ? entry_SYSCALL_64_fastpath+0x17/0x93
Aug  9 15:57:01 nikola -- MARK --
Aug  9 15:58:13 s_src@amelia rpc.mountd[3777]: auth_unix_ip: inbuf 'nfsd 2001:08b0:11fe:8d1d:0000:0000:0000:0011'
Aug  9 15:58:13 s_src@amelia rpc.mountd[3777]: auth_unix_ip: client 0x6c6690 '*,2001:8b0:11fe:8d1d::/64,2001:8b0:11fe:8d1d::11'
Aug  9 15:59:56 s_src@amelia kernel: INFO: task btrfs-cleaner:2102 blocked for more than 120 seconds.
Aug  9 15:59:56 s_src@amelia kernel:       Not tainted 4.7.0-dirty #153
Aug  9 15:59:56 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  9 15:59:56 s_src@amelia kernel: btrfs-cleaner   D ffff88021fc95f40     0  2102      2 0x00000000
Aug  9 15:59:56 s_src@amelia kernel:  ffff8800d9223700 0000000000000005 ffff88021fc0c850 ffff880210954000
Aug  9 15:59:56 s_src@amelia kernel:  ffff880210953e10 ffff8800d9223700 ffff88021691d018 ffff88021691d014
Aug  9 15:59:56 s_src@amelia kernel:  00000000ffffffff ffffffff8141d06a ffff88021691d010 ffffffff8141d209
Aug  9 15:59:56 s_src@amelia kernel: Call Trace:
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff8141d06a>] ? schedule+0x78/0x85
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff8141d209>] ? schedule_preempt_disabled+0x5/0x6
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff8141e041>] ? __mutex_lock_slowpath+0xa9/0x116
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff8141e0bc>] ? mutex_lock+0xe/0x1d
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff81178ecf>] ? btrfs_delete_unused_bgs+0xb5/0x346
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff8117f6a5>] ? cleaner_kthread+0xf2/0x1a8
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff8117f5b3>] ? btree_invalidatepage+0x85/0x85
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff81057ba0>] ? kthread+0x95/0x9d
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff8141f2ff>] ? ret_from_fork+0x1f/0x40
Aug  9 15:59:56 s_src@amelia kernel:  [<ffffffff81057b0b>] ? init_completion+0x1d/0x1d


-- 
Hugo Mills             | Great films about cricket: Monster's No-Ball
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXqhKdAAoJEFheFHXiqx3kCUEP/Rl18NpQruZueLKW7xD4Cg0M
hajtaykD2GJF+teAtXTZAauHprLWXctK52GGUqcNpV4S2j4qMPN3Oo4PblQsLlqg
/N0gfhvqKhpBBQd4hWqsju6u3nxaref01vJ+5WNz270esxzS/829Y4DfBT2HdW/g
uhkJXl0NdOArxj8bZT7DkSU6Wv6TI9BkbZZKhrTEjcXtc5+DEEqoznfdY6jq6BUX
+WnnHOvlvTFA0Bu3cw81VL/TkUIW9A1XhZRF+oMYsh2CBGKsbv+9rtf0CdNZ8Fkh
h7/LEaZQAu6fOCDx8xa887jX7kVECObBjr49gAubrWw+3R4OB1Oa/37pcnREifRn
V1Wc0eILJDo8cL7rI8oeyb1++bkV2HAbiD75sjrNQXYWYCEYFoqwg5thV/B/BSZ3
i5LJB+LsQ101AwVFgop2IQ7LNctG3xCKCFv2Q0KPqZXyZSrngL67fBDHTZUDvQ98
AqAsK+DEC9hSXqnmvDrzj8DltWa/McvNbvLXZ07U8JcjRnRlFHnnDd2wC3t46lm6
euLv1DocHgdYR0CoGSB8QGa1Zs9Ojfvq6cU3dShUgO/IDyGa/UhgHo7NFl3LN4g/
6s4KXvE9sj5ZdpJo2J6GfHOCVx0a1Z8G8kQmnc12FAJT0ALWWVM3deZNqNmNH7VC
E3SM3f+akw6EDsSOBsYw
=A28O
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
