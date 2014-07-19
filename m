Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:49984 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaGSHTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 03:19:25 -0400
Received: from mfilter6-d.gandi.net (mfilter6-d.gandi.net [217.70.178.135])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 8281C41C06B
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 09:19:22 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter6-d.gandi.net (mfilter6-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id BlapyxDRyjpZ for <linux-btrfs@vger.kernel.org>;
	Sat, 19 Jul 2014 09:19:21 +0200 (CEST)
Received: from zafu.localnet (AMontpellier-256-1-92-201.w90-28.abo.wanadoo.fr [90.28.147.201])
	(Authenticated sender: michel@bouissou.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 0270041C067
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 09:19:20 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: BTRFS kernel errors in 3.15.5
Date: Sat, 19 Jul 2014 09:19:13 +0200
Message-ID: <1874170.zy97UOFIcr@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This happens systematically these days, while trying to backup using rsync two 
of my laptops on an external HD - BTRFS formatted.


First at mount :

juil. 19 09:08:32 zafu kernel: BTRFS info (device dm-3): disk space caching is 
enabled
juil. 19 09:08:38 zafu kernel: pool[7215]: segfault at 58252fd0 ip 
00007fd06e466ac7 sp 00007fd062ffbf90 error 4 in 
libc-2.19.so[7fd06e41e000+1a4000]


Happening on 2 different machines (both Arch Linux with latest kernel), I 
suspected the external HD, but it spent the night passing all long SMART tests 
plus a "btrfs scrub", all with flying colors...

After the following error, all accesses to the external HD lock until a forced 
power off of the whole system...

juil. 19 09:12:57 zafu kernel: INFO: task kworker/u4:7:6677 blocked for more 
than 120 seconds.
juil. 19 09:12:57 zafu kernel:       Tainted: G           O  3.15.5-2-ARCH #1
juil. 19 09:12:57 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juil. 19 09:12:57 zafu kernel: kworker/u4:7    D 0000000000000000     0  6677      
2 0x00000000
juil. 19 09:12:57 zafu kernel: Workqueue: btrfs-flush_delalloc 
normal_work_helper [btrfs]
juil. 19 09:12:57 zafu kernel:  ffff88001e9dfb48 0000000000000046 ffff8800879f1460 
0000000000014700
juil. 19 09:12:57 zafu kernel:  ffff88001e9dffd8 0000000000014700 ffff8800879f1460 
ffffffffa0262692
juil. 19 09:12:57 zafu kernel:  0000000000000000 ffffffff00000050 ffff88001e9dfbc4 
ffff88001e9dfac8
juil. 19 09:12:57 zafu kernel: Call Trace:
juil. 19 09:12:57 zafu kernel:  [<ffffffffa0262692>] ? 
run_delalloc_range+0x192/0x350 [btrfs]
juil. 19 09:12:57 zafu kernel:  [<ffffffff8113f880>] ? filemap_fdatawait+0x30/0x30
juil. 19 09:12:57 zafu kernel:  [<ffffffff81509fa9>] schedule+0x29/0x70
juil. 19 09:12:57 zafu kernel:  [<ffffffff8150a294>] io_schedule+0x94/0xf0
juil. 19 09:12:57 zafu kernel:  [<ffffffff8113f88e>] sleep_on_page+0xe/0x20
juil. 19 09:12:57 zafu kernel:  [<ffffffff8150a788>] __wait_on_bit_lock+0x48/0xb0
juil. 19 09:12:57 zafu kernel:  [<ffffffff8113f9e8>] __lock_page+0x78/0x90
juil. 19 09:12:57 zafu kernel:  [<ffffffff810b1c80>] ? 
autoremove_wake_function+0x40/0x40
juil. 19 09:12:57 zafu kernel:  [<ffffffffa027ac98>] 
extent_write_cache_pages.isra.28.constprop.45+0x258/0x3a0 [btrfs]
juil. 19 09:12:57 zafu kernel:  [<ffffffff810a714c>] ? update_curr+0xec/0x1b0
juil. 19 09:12:57 zafu kernel:  [<ffffffff810a3068>] ? __enqueue_entity+0x78/0x80
juil. 19 09:12:57 zafu kernel:  [<ffffffff810a902e>] ? enqueue_entity+0x24e/0xaa0
juil. 19 09:12:57 zafu kernel:  [<ffffffffa027c20c>] extent_writepages+0x5c/0x90 
[btrfs]
juil. 19 09:12:57 zafu kernel:  [<ffffffffa025e9d0>] ? 
__btrfs_submit_bio_start_direct_io+0x40/0x40 [btrfs]
juil. 19 09:12:57 zafu kernel:  [<ffffffffa025d6e8>] btrfs_writepages+0x28/0x30 
[btrfs]
juil. 19 09:12:57 zafu kernel:  [<ffffffff8114d1de>] do_writepages+0x1e/0x30
juil. 19 09:12:57 zafu kernel:  [<ffffffff8114139d>] 
__filemap_fdatawrite_range+0x5d/0x80
juil. 19 09:12:57 zafu kernel:  [<ffffffff8114140c>] filemap_flush+0x1c/0x20
juil. 19 09:12:57 zafu kernel:  [<ffffffffa026046a>] 
btrfs_run_delalloc_work+0x5a/0xa0 [btrfs]
juil. 19 09:12:57 zafu kernel:  [<ffffffffa028aa77>] normal_work_helper+0x77/0x350 
[btrfs]
juil. 19 09:12:57 zafu kernel:  [<ffffffff810861d8>] process_one_work+0x168/0x450
juil. 19 09:12:57 zafu kernel:  [<ffffffff81086c32>] worker_thread+0x132/0x3e0
juil. 19 09:12:57 zafu kernel:  [<ffffffff81086b00>] ? 
manage_workers.isra.23+0x2d0/0x2d0
juil. 19 09:12:57 zafu kernel:  [<ffffffff8108d43a>] kthread+0xea/0x100
juil. 19 09:12:57 zafu kernel:  [<ffffffff8108d350>] ? 
kthread_create_on_node+0x1b0/0x1b0
juil. 19 09:12:57 zafu kernel:  [<ffffffff81515efc>] ret_from_fork+0x7c/0xb0
juil. 19 09:12:57 zafu kernel:  [<ffffffff8108d350>] ? 
kthread_create_on_node+0x1b0/0x1b0

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E


