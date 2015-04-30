Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17.italiaonline.it ([212.48.25.145]:52815 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751152AbbD3RZp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 13:25:45 -0400
Message-ID: <554263A2.9060003@libero.it>
Date: Thu, 30 Apr 2015 19:17:22 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Bug report: filesystem needed btrf-zero-log
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

after a crash for reason not related to btrfs [*], I was not able to
mount the root filesystem anymore. To investigate a bit I started from
another filesystem and I tried to mount manually the FS.

I run "mount /dev/sdd3 /mnt", but the command never returned.
The system was responsive: I was able to start a kernel compilation, to
launch a new shell... But the mount process stuck in 'D' state.

After 120sec in the log appeared:

Apr 30 18:47:14 venice kernel: INFO: task mount:2043 blocked for more than 120 seconds.
Apr 30 18:47:14 venice kernel:      Tainted: G          I    3.19.1 #193
Apr 30 18:47:14 venice kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 30 18:47:14 venice kernel: mount           D ffff880215082b20     0  2043   2038 0x00000000
Apr 30 18:47:14 venice kernel: ffff880215082b20 ffff88021519b950 ffff880226239330 0000000000014140
Apr 30 18:47:14 venice kernel: ffff88021519bfd8 0000000000014140 ffff880215082b20 0000000000000246
Apr 30 18:47:14 venice kernel: ffff88021356b910 ffff88021356b978 ffff88021356b990 ffff88021519b8b8
Apr 30 18:47:14 venice kernel: Call Trace:
Apr 30 18:47:14 venice kernel: [<ffffffffa02414e5>] ? btrfs_tree_lock+0x55/0x1f0 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffff810a8b60>] ? wait_woken+0x90/0x90
Apr 30 18:47:14 venice kernel: [<ffffffffa01e567a>] ? btrfs_search_slot+0x71a/0xa90 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa01e5404>] ? btrfs_search_slot+0x4a4/0xa90 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa01e72e2>] ? btrfs_insert_empty_items+0x72/0xc0 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa02417a9>] ? btrfs_insert_orphan_item+0x59/0x80 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa0242d15>] ? insert_orphan_item+0x55/0x80 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa02478b1>] ? replay_one_buffer+0x391/0x3b0 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa0242672>] ? walk_up_log_tree+0xd2/0x240 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa024287c>] ? walk_log_tree+0x9c/0x1b0 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa0203d45>] ? btrfs_get_fs_root.part.45+0x45/0x190 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa0249ce7>] ? btrfs_recover_log_trees+0x1b7/0x440 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa0200580>] ? free_root_pointers+0x70/0x70 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa0247520>] ? replay_one_extent+0x650/0x650 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa0206f04>] ? open_ctree+0x1834/0x20d0 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffffa01dd5b5>] ? btrfs_mount+0x805/0x8d0 [btrfs]
Apr 30 18:47:14 venice kernel: [<ffffffff8116e28f>] ? pcpu_next_unpop+0x3f/0x50
Apr 30 18:47:14 venice kernel: [<ffffffff8116f28b>] ? pcpu_alloc+0x35b/0x690
Apr 30 18:47:14 venice kernel: [<ffffffff811c2356>] ? mount_fs+0x36/0x1b0
Apr 30 18:47:14 venice kernel: [<ffffffff811dd842>] ? vfs_kern_mount+0x62/0x110
Apr 30 18:47:14 venice kernel: [<ffffffff811e05ba>] ? do_mount+0x1fa/0xaf0
Apr 30 18:47:14 venice kernel: [<ffffffff811e11c8>] ? SyS_mount+0x88/0xd0
Apr 30 18:47:14 venice kernel: [<ffffffff815502ed>] ? system_call_fastpath+0x16/0x1b
Apr 30 18:49:14 venice kernel: INFO: task mount:2043 blocked for more than 120 seconds.
Apr 30 18:49:14 venice kernel:      Tainted: G          I    3.19.1 #193
Apr 30 18:49:14 venice kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 30 18:49:14 venice kernel: mount           D ffff880215082b20     0  2043   2038 0x00000000
Apr 30 18:49:14 venice kernel: ffff880215082b20 ffff88021519b950 ffff880226239330 0000000000014140
Apr 30 18:49:14 venice kernel: ffff88021519bfd8 0000000000014140 ffff880215082b20 0000000000000246
Apr 30 18:49:14 venice kernel: ffff88021356b910 ffff88021356b978 ffff88021356b990 ffff88021519b8b8
Apr 30 18:49:14 venice kernel: Call Trace:
Apr 30 18:49:14 venice kernel: [<ffffffffa02414e5>] ? btrfs_tree_lock+0x55/0x1f0 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffff810a8b60>] ? wait_woken+0x90/0x90
Apr 30 18:49:14 venice kernel: [<ffffffffa01e567a>] ? btrfs_search_slot+0x71a/0xa90 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa01e5404>] ? btrfs_search_slot+0x4a4/0xa90 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa01e72e2>] ? btrfs_insert_empty_items+0x72/0xc0 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa02417a9>] ? btrfs_insert_orphan_item+0x59/0x80 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa0242d15>] ? insert_orphan_item+0x55/0x80 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa02478b1>] ? replay_one_buffer+0x391/0x3b0 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa0242672>] ? walk_up_log_tree+0xd2/0x240 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa024287c>] ? walk_log_tree+0x9c/0x1b0 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa0203d45>] ? btrfs_get_fs_root.part.45+0x45/0x190 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa0249ce7>] ? btrfs_recover_log_trees+0x1b7/0x440 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa0200580>] ? free_root_pointers+0x70/0x70 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa0247520>] ? replay_one_extent+0x650/0x650 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa0206f04>] ? open_ctree+0x1834/0x20d0 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa01dd5b5>] ? btrfs_mount+0x805/0x8d0 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffff8116e28f>] ? pcpu_next_unpop+0x3f/0x50
Apr 30 18:49:14 venice kernel: [<ffffffff8116f28b>] ? pcpu_alloc+0x35b/0x690
Apr 30 18:49:14 venice kernel: [<ffffffff811c2356>] ? mount_fs+0x36/0x1b0
Apr 30 18:49:14 venice kernel: [<ffffffff811dd842>] ? vfs_kern_mount+0x62/0x110
Apr 30 18:49:14 venice kernel: [<ffffffff811e05ba>] ? do_mount+0x1fa/0xaf0
Apr 30 18:49:14 venice kernel: [<ffffffff811e11c8>] ? SyS_mount+0x88/0xd0
Apr 30 18:49:14 venice kernel: [<ffffffff815502ed>] ? system_call_fastpath+0x16/0x1b
Apr 30 18:49:14 venice kernel: INFO: task btrfs-transacti:2065 blocked for more than 120 seconds.
Apr 30 18:49:14 venice kernel:      Tainted: G          I    3.19.1 #193
Apr 30 18:49:14 venice kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 30 18:49:14 venice kernel: btrfs-transacti D ffff8800bcfac0d0     0  2065      2 0x00000000
Apr 30 18:49:14 venice kernel: ffff8800bcfac0d0 0000000000000000 ffff8802262289e0 0000000000014140
Apr 30 18:49:14 venice kernel: ffff88020c023fd8 0000000000014140 ffff8800bcfac0d0 0000000000000246
Apr 30 18:49:14 venice kernel: ffff8800b88779b8 ffff8800bcc9a800 ffff88020c023e20 ffff880223a69300
Apr 30 18:49:14 venice kernel: Call Trace:
Apr 30 18:49:14 venice kernel: [<ffffffffa0209735>] ? btrfs_commit_transaction+0x365/0x9d0 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffff810a8b60>] ? wait_woken+0x90/0x90
Apr 30 18:49:14 venice kernel: [<ffffffffa0205365>] ? transaction_kthread+0x245/0x260 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffffa0205120>] ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
Apr 30 18:49:14 venice kernel: [<ffffffff8108a033>] ? kthread+0xd3/0xf0
Apr 30 18:49:14 venice kernel: [<ffffffff81089f60>] ? kthread_create_on_node+0x180/0x180
Apr 30 18:49:14 venice kernel: [<ffffffff8155023c>] ? ret_from_fork+0x7c/0xb0
Apr 30 18:49:14 venice kernel: [<ffffffff81089f60>] ? kthread_create_on_node+0x180/0x180
Apr 30 18:51:09 venice kernel: usb 1-1.1: reset high-speed USB device number 3 using ehci-pci
Apr 30 18:51:14 venice kernel: INFO: task mount:2043 blocked for more than 120 seconds.
Apr 30 18:51:14 venice kernel:      Tainted: G          I    3.19.1 #193
Apr 30 18:51:14 venice kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 30 18:51:14 venice kernel: mount           D ffff880215082b20     0  2043   2038 0x00000000
Apr 30 18:51:14 venice kernel: ffff880215082b20 ffff88021519b950 ffff880226239330 0000000000014140
Apr 30 18:51:14 venice kernel: ffff88021519bfd8 0000000000014140 ffff880215082b20 0000000000000246
Apr 30 18:51:14 venice kernel: ffff88021356b910 ffff88021356b978 ffff88021356b990 ffff88021519b8b8
Apr 30 18:51:14 venice kernel: Call Trace:
Apr 30 18:51:14 venice kernel: [<ffffffffa02414e5>] ? btrfs_tree_lock+0x55/0x1f0 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffff810a8b60>] ? wait_woken+0x90/0x90
Apr 30 18:51:14 venice kernel: [<ffffffffa01e567a>] ? btrfs_search_slot+0x71a/0xa90 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa01e5404>] ? btrfs_search_slot+0x4a4/0xa90 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa01e72e2>] ? btrfs_insert_empty_items+0x72/0xc0 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa02417a9>] ? btrfs_insert_orphan_item+0x59/0x80 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa0242d15>] ? insert_orphan_item+0x55/0x80 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa02478b1>] ? replay_one_buffer+0x391/0x3b0 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa0242672>] ? walk_up_log_tree+0xd2/0x240 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa024287c>] ? walk_log_tree+0x9c/0x1b0 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa0203d45>] ? btrfs_get_fs_root.part.45+0x45/0x190 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa0249ce7>] ? btrfs_recover_log_trees+0x1b7/0x440 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa0200580>] ? free_root_pointers+0x70/0x70 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa0247520>] ? replay_one_extent+0x650/0x650 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa0206f04>] ? open_ctree+0x1834/0x20d0 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa01dd5b5>] ? btrfs_mount+0x805/0x8d0 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffff8116e28f>] ? pcpu_next_unpop+0x3f/0x50
Apr 30 18:51:14 venice kernel: [<ffffffff8116f28b>] ? pcpu_alloc+0x35b/0x690
Apr 30 18:51:14 venice kernel: [<ffffffff811c2356>] ? mount_fs+0x36/0x1b0
Apr 30 18:51:14 venice kernel: [<ffffffff811dd842>] ? vfs_kern_mount+0x62/0x110
Apr 30 18:51:14 venice kernel: [<ffffffff811e05ba>] ? do_mount+0x1fa/0xaf0
Apr 30 18:51:14 venice kernel: [<ffffffff811e11c8>] ? SyS_mount+0x88/0xd0
Apr 30 18:51:14 venice kernel: [<ffffffff815502ed>] ? system_call_fastpath+0x16/0x1b
Apr 30 18:51:14 venice kernel: INFO: task btrfs-transacti:2065 blocked for more than 120 seconds.
Apr 30 18:51:14 venice kernel:      Tainted: G          I    3.19.1 #193
Apr 30 18:51:14 venice kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 30 18:51:14 venice kernel: btrfs-transacti D ffff8800bcfac0d0     0  2065      2 0x00000000
Apr 30 18:51:14 venice kernel: ffff8800bcfac0d0 0000000000000000 ffff8802262289e0 0000000000014140
Apr 30 18:51:14 venice kernel: ffff88020c023fd8 0000000000014140 ffff8800bcfac0d0 0000000000000246
Apr 30 18:51:14 venice kernel: ffff8800b88779b8 ffff8800bcc9a800 ffff88020c023e20 ffff880223a69300
Apr 30 18:51:14 venice kernel: Call Trace:
Apr 30 18:51:14 venice kernel: [<ffffffffa0209735>] ? btrfs_commit_transaction+0x365/0x9d0 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffff810a8b60>] ? wait_woken+0x90/0x90
Apr 30 18:51:14 venice kernel: [<ffffffffa0205365>] ? transaction_kthread+0x245/0x260 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffffa0205120>] ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
Apr 30 18:51:14 venice kernel: [<ffffffff8108a033>] ? kthread+0xd3/0xf0
Apr 30 18:51:14 venice kernel: [<ffffffff81089f60>] ? kthread_create_on_node+0x180/0x180
Apr 30 18:51:14 venice kernel: [<ffffffff8155023c>] ? ret_from_fork+0x7c/0xb0
Apr 30 18:51:14 venice kernel: [<ffffffff81089f60>] ? kthread_create_on_node+0x180/0x180
Apr 30 18:52:08 venice kernel: perf interrupt took too long (2501 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
ffffffffa0205120>] ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
Apr 30 18:53:14 venice kernel: [<ffffffff8108a033>] ? kthread+0xd3/0xf0
Apr 30 18:53:14 venice kernel: [<ffffffff81089f60>] ? kthread_create_on_node+0x180/0x180
Apr 30 18:53:14 venice kernel: [<ffffffff8155023c>] ? ret_from_fork+0x7c/0xb0
Apr 30 18:53:14 venice kernel: [<ffffffff81089f60>] ? kthread_create_on_node+0x180/0x180


"btrfs check" (btrfs-progs v4.0) didn't report anything.

Doing a btrfs-zero-log /dev/sdd3, solved this problem and now the 
filesystem works properly.
Before the btrfs-zero-log I made a btrfs-image (~44MB). If someone want to investigate
this issue more I can provide him the image.



The problem appeared both in the kernel 3.19.1 and 3.19.3.

Let me know.

BR
G.Baroncelli

[*] I am developing a driver for a mouse. This driver caused the crash.


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
