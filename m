Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60076 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbbDTKQh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 06:16:37 -0400
Received: from mfilter41-d.gandi.net (mfilter41-d.gandi.net [217.70.178.173])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 3DDA6A81C6
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 12:16:35 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter41-d.gandi.net (mfilter41-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id oxS4eSR1ZYN9 for <linux-btrfs@vger.kernel.org>;
	Mon, 20 Apr 2015 12:16:33 +0200 (CEST)
Received: from [10.64.203.109] (unknown [217.70.211.10])
	(Authenticated sender: olivier@onsd.eu)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id A4FDEA8154
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 12:16:33 +0200 (CEST)
Message-ID: <5534D201.7080803@onsd.eu>
Date: Mon, 20 Apr 2015 12:16:33 +0200
From: =?UTF-8?B?Ik7DqW1veiBTYWludC1EaXppZXIsIE9saXZpZXIi?=
	<olivier@onsd.eu>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: unable to mount a btrfs file system kernel 3.19.2
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I have an issue with my ssd where a btrfs partition is located. I have a
/dev/sdb1 in ext4 for the /boot, and the rest of the ssd is /dev/sdb2
which is the root of my Archlinux. When I boot, it hangs up after
loading the kernel. So I tried with an Archlinux liveboot, and I have
the same behavior with the following trace in logs when I try to mount
the btrfs partition :

Apr 11 16:25:56 archiso kernel: INFO: task mount:573 blocked for more than 120 seconds.
Apr 11 16:25:56 archiso kernel:       Not tainted 3.19.2-1-ARCH #1
Apr 11 16:25:56 archiso kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 11 16:25:56 archiso kernel: mount           D ffff8807f1c937f8     0   573    524 0x00000004
Apr 11 16:25:56 archiso kernel:  ffff8807f1c937f8 ffff8807f7d6ed50 0000000000013f00 ffff8807f1c93fd8
Apr 11 16:25:56 archiso kernel:  0000000000013f00 ffff8807f98109f0 ffff8807f7d6ed50 ffff8807ecce5ea0
Apr 11 16:25:56 archiso kernel:  0000000000000004 ffff8807f1c93758 ffffffffa048ec91 ffff8807ecce5ea0
Apr 11 16:25:56 archiso kernel: Call Trace:
Apr 11 16:25:56 archiso kernel:  [<ffffffffa048ec91>] ? set_extent_buffer_dirty+0x71/0xc0 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa0464796>] ? btrfs_buffer_uptodate+0x56/0x80 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffff8155e999>] schedule+0x29/0x70
Apr 11 16:25:56 archiso kernel:  [<ffffffffa04a6745>] btrfs_tree_lock+0x65/0x200 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffff810b4380>] ? wait_woken+0x90/0x90
Apr 11 16:25:56 archiso kernel:  [<ffffffffa0444cd9>] btrfs_search_slot+0x799/0xaa0 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffff810b43c0>] ? autoremove_wake_function+0x40/0x40
Apr 11 16:25:56 archiso kernel:  [<ffffffffa04469f5>] btrfs_insert_empty_items+0x75/0xd0 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa04a6a37>] btrfs_insert_orphan_item+0x67/0xa0 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa04a912e>] insert_orphan_item+0x5e/0x90 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa04ab531>] replay_one_buffer+0x361/0x380 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa048e244>] ? alloc_extent_buffer+0x34/0x370 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa04a78f3>] walk_down_log_tree+0x1d3/0x410 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa04a7bfb>] walk_log_tree+0xcb/0x1d0 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa04af7f7>] btrfs_recover_log_trees+0x1e7/0x490 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa04ab1d0>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa0467b3e>] open_ctree+0x17ae/0x2030 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa043c633>] btrfs_mount+0x843/0x920 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffff8117b7aa>] ? pcpu_alloc+0x35a/0x680
Apr 11 16:25:56 archiso kernel:  [<ffffffff811d5d68>] mount_fs+0x38/0x1c0
Apr 11 16:25:56 archiso kernel:  [<ffffffff8117bb05>] ? __alloc_percpu+0x15/0x20
Apr 11 16:25:56 archiso kernel:  [<ffffffff811f116b>] vfs_kern_mount+0x6b/0x120
Apr 11 16:25:56 archiso kernel:  [<ffffffff811f4184>] do_mount+0x224/0xb40
Apr 11 16:25:56 archiso kernel:  [<ffffffff811f4dae>] SyS_mount+0x7e/0xe0
Apr 11 16:25:56 archiso kernel:  [<ffffffff81562809>] system_call_fastpath+0x12/0x17
Apr 11 16:25:56 archiso kernel: INFO: task btrfs-transacti:596 blocked for more than 120 seconds.
Apr 11 16:25:56 archiso kernel:       Not tainted 3.19.2-1-ARCH #1
Apr 11 16:25:56 archiso kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 11 16:25:56 archiso kernel: btrfs-transacti D ffff8807e8937d98     0   596      2 0x00000000
Apr 11 16:25:56 archiso kernel:  ffff8807e8937d98 ffff8807f2e7bba0 0000000000013f00 ffff8807e8937fd8
Apr 11 16:25:56 archiso kernel:  0000000000013f00 ffff8807f9e76d50 ffff8807f2e7bba0 ffff8807eccb90c8
Apr 11 16:25:56 archiso kernel:  ffff8807ecc79000 ffff880000000000 ffff8807ecc79000 ffff880700000033
Apr 11 16:25:56 archiso kernel: Call Trace:
Apr 11 16:25:56 archiso kernel:  [<ffffffff811b5d1a>] ? kmem_cache_alloc+0x16a/0x180
Apr 11 16:25:56 archiso kernel:  [<ffffffffa043f7ca>] ? btrfs_free_path+0x2a/0x40 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa04c3213>] ? __btrfs_run_delayed_items+0xf3/0x1d0 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffff8155e999>] schedule+0x29/0x70
Apr 11 16:25:56 archiso kernel:  [<ffffffffa046a555>] btrfs_commit_transaction+0x2a5/0xbe0 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffff810b4380>] ? wait_woken+0x90/0x90
Apr 11 16:25:56 archiso kernel:  [<ffffffffa0465fc5>] transaction_kthread+0x1d5/0x240 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffffa0465df0>] ? btrfs_cleanup_transaction+0x5a0/0x5a0 [btrfs]
Apr 11 16:25:56 archiso kernel:  [<ffffffff81091748>] kthread+0xd8/0xf0
Apr 11 16:25:56 archiso kernel:  [<ffffffff81091670>] ? kthread_create_on_node+0x1c0/0x1c0
Apr 11 16:25:56 archiso kernel:  [<ffffffff81562758>] ret_from_fork+0x58/0x90
Apr 11 16:25:56 archiso kernel:  [<ffffffff81091670>] ? kthread_create_on_node+0x1c0/0x1c0

Additional information :

Label: none  uuid: aa6b1bae-3c28-482d-a446-c31875f21cf0
	Total devices 1 FS bytes used 64.63GiB
	devid    1 size 111.29GiB used 111.02GiB path /dev/sda2

btrfs-progs v3.19

Linux archiso 3.19.2-1-ARCH #1 SMP PREEMPT Wed Mar 18 16:21:02 CET 2015 x86_64 GNU/Linux

And the full output from journald is available there :
http://sprunge.us/jPMG

Is it a known bug? Or does someone have an idea about how I could fix
this issue?

Thank you in advance.

Olivier.
