Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv1.host37.de ([176.28.54.59]:48570 "EHLO srv1.host37.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965179AbbBDXL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 18:11:59 -0500
Received: from [10.172.14.149] (unknown [130.75.172.171])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by srv1.host37.de (Postfix) with ESMTPSA id 07AD91121
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2015 23:42:37 +0100 (CET)
From: Juergen Fitschen <me@jue.yt>
Content-Type: text/plain; charset=us-ascii
Subject: Deadlock on 3.18.5
Message-Id: <2BFED81A-1A34-4A4B-800A-A4B6286B74C7@jue.yt>
Date: Thu, 5 Feb 2015 00:05:33 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

I just got a deadlock on Linux 3.18.5. It occurred while processing a some data: All in all reading from the btrfs volume, decompressing it (the bottleneck in this process), doing some calculations and finally writing the results back to a new file on the volume.

I am using a freshly installed Ubuntu 14.04 in a virtual machine. The block device used for btrfs is a LVM volume offered by the KVM hypervisor.
Unfortunately I was using an old version of my user space tools (Version 3.12-1), so it might be related to that?
The volume was mounted with the following mount options:
> default,compress-force=lzo,subvol=data

Related kernel stack trace:
> Feb  4 22:00:41 qdock03 kernel: [22560.284120] INFO: task btrfs-transacti:508 blocked for more than 120 seconds.
> Feb  4 22:00:41 qdock03 kernel: [22560.284200]       Tainted: G        W      3.18.5-031805-generic #201501292218
> Feb  4 22:00:41 qdock03 kernel: [22560.284267] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Feb  4 22:00:41 qdock03 kernel: [22560.284339] btrfs-transacti D 0000000000000001     0   508      2 0x00000000
> Feb  4 22:00:41 qdock03 kernel: [22560.284345]  ffff881ece617b28 0000000000000046 ffffffffc0136e90 00000000008bee9a
> Feb  4 22:00:41 qdock03 kernel: [22560.284349]  ffff881ece617fd8 0000000000013640 ffff881ece095b00 0000000000013640
> Feb  4 22:00:41 qdock03 kernel: [22560.284352]  ffff881ed0638000 ffff881ecfdf5000 ffff881ece617b98 ffff881f79c33f40
> Feb  4 22:00:41 qdock03 kernel: [22560.284356] Call Trace:
> Feb  4 22:00:41 qdock03 kernel: [22560.284397]  [<ffffffffc0136e90>] ? btree_io_failed_hook+0x60/0x60 [btrfs]
> Feb  4 22:00:41 qdock03 kernel: [22560.284406]  [<ffffffff817b0750>] ? bit_wait_timeout+0x80/0x80
> Feb  4 22:00:41 qdock03 kernel: [22560.284411]  [<ffffffff817afd29>] schedule+0x29/0x70
> Feb  4 22:00:41 qdock03 kernel: [22560.284415]  [<ffffffff817afdff>] io_schedule+0x8f/0xd0
> Feb  4 22:00:41 qdock03 kernel: [22560.284419]  [<ffffffff817b077c>] bit_wait_io+0x2c/0x50
> Feb  4 22:00:41 qdock03 kernel: [22560.284423]  [<ffffffff817b04e5>] __wait_on_bit+0x65/0x90
> Feb  4 22:00:41 qdock03 kernel: [22560.284428]  [<ffffffff8117888b>] ? find_get_pages_tag+0xcb/0x170
> Feb  4 22:00:41 qdock03 kernel: [22560.284449]  [<ffffffffc015ce8e>] ? clear_state_bit+0xae/0x170 [btrfs]
> Feb  4 22:00:41 qdock03 kernel: [22560.284455]  [<ffffffff81177e37>] wait_on_page_bit+0xc7/0xd0
> Feb  4 22:00:41 qdock03 kernel: [22560.284460]  [<ffffffff810b4cf0>] ? wake_atomic_t_function+0x40/0x40
> Feb  4 22:00:41 qdock03 kernel: [22560.284465]  [<ffffffff81178004>] filemap_fdatawait_range+0xf4/0x180
> Feb  4 22:00:41 qdock03 kernel: [22560.284483]  [<ffffffffc013f41f>] btrfs_wait_marked_extents+0x8f/0x140 [btrfs]
> Feb  4 22:00:41 qdock03 kernel: [22560.284498]  [<ffffffffc013f532>] btrfs_write_and_wait_transaction+0x62/0xb0 [btrfs]
> Feb  4 22:00:41 qdock03 kernel: [22560.284514]  [<ffffffffc013fe04>] btrfs_commit_transaction+0x734/0xae0 [btrfs]
> Feb  4 22:00:41 qdock03 kernel: [22560.284528]  [<ffffffffc013d4d5>] transaction_kthread+0x1d5/0x250 [btrfs]
> Feb  4 22:00:41 qdock03 kernel: [22560.284543]  [<ffffffffc013d300>] ? open_ctree+0x1f50/0x1f50 [btrfs]
> Feb  4 22:00:41 qdock03 kernel: [22560.284548]  [<ffffffff81093a79>] kthread+0xc9/0xe0
> Feb  4 22:00:41 qdock03 kernel: [22560.284552]  [<ffffffff810939b0>] ? flush_kthread_worker+0x90/0x90
> Feb  4 22:00:41 qdock03 kernel: [22560.284556]  [<ffffffff817b3ebc>] ret_from_fork+0x7c/0xb0
> Feb  4 22:00:41 qdock03 kernel: [22560.284559]  [<ffffffff810939b0>] ? flush_kthread_worker+0x90/0x90



Regards,
  Juergen