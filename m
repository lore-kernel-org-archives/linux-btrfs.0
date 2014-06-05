Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40660 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFEMKG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 08:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WsWUd-0000Se-AH
	for linux-btrfs@vger.kernel.org; Thu, 05 Jun 2014 14:10:03 +0200
Received: from pool-72-92-36-55.phlapa.fios.verizon.net ([72.92.36.55])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 14:10:03 +0200
Received: from bear by pool-72-92-36-55.phlapa.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 14:10:03 +0200
To: linux-btrfs@vger.kernel.org
From: Gary Coulbourne <bear@bears.org>
Subject: Re: 3.15-rc6 - btrfs-transacti:4157 blocked for more than 120 seconds.
Date: Thu, 5 Jun 2014 11:44:36 +0000 (UTC)
Message-ID: <loom.20140605T133806-160@post.gmane.org>
References: <5384D53C.9070509@skagestad.org> <5384E2FA.1070509@fb.com> <5384F0B4.7040309@skagestad.org> <5384F8A4.1050206@skagestad.org> <5384FAB2.6000204@fb.com> <5385007A.4000301@fb.com> <538579F1.10106@skagestad.org> <5385E794.1030002@fb.com> <5385F938.9010009@skagestad.org> <20140601212926.GH22161@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am also getting this...

My system is configured like so:

3.15.0-rc8 
Btrfs v3.12

#btrfs fi show
Label: none  uuid: e421ceeb-6e4e-4c7e-84b4-6f25442745fa
	Total devices 1 FS bytes used 22.51GiB
	devid    1 size 116.75GiB used 28.02GiB path /dev/sda4

Label: tank  uuid: 52044d1c-5308-40f7-9d21-4edca3b63d05
	Total devices 5 FS bytes used 1.87TiB
	devid    2 size 931.51GiB used 367.00GiB path /dev/sdc
	devid    3 size 931.51GiB used 366.00GiB path /dev/sdf
	devid    4 size 2.73TiB used 1.88TiB path /dev/sde
	devid    5 size 1.36TiB used 833.00GiB path /dev/sdd
	devid    6 size 931.51GiB used 364.03GiB path /dev/sdb

/tank is the filesystem giving the trouble.  Here's the df for it:

Data, RAID1: total=1.88TiB, used=1.87TiB
System, RAID1: total=32.00MiB, used=276.00KiB
Metadata, RAID1: total=4.00GiB, used=2.84GiB
unknown, single: total=512.00MiB, used=0.00

It is just a raid 1, zlib-compressed.  No encryption.

If I do any kind of large file transfers (large amounts OR many files, not
sure what aspect causes it) with it, the following happens:

My load average shoots up to HUGE numbers, the filesystem becomes unusable
although directories are still readable that do not have files that are
being accessed in them, and the dmesg begins filling with:

Jun  5 06:55:40 maul kernel: [  361.276631] INFO: task kworker/u8:0:6
blocked for more than 120 seconds.
Jun  5 06:55:40 maul kernel: [  361.276640]       Not tainted 3.15.0-rc8 #1
Jun  5 06:55:40 maul kernel: [  361.276644] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun  5 06:55:40 maul kernel: [  361.276649] kworker/u8:0    D
0000000000000000     0     6      2 0x00000000
Jun  5 06:55:40 maul kernel: [  361.276665] Workqueue: writeback
bdi_writeback_workfn (flush-btrfs-2)
Jun  5 06:55:40 maul kernel: [  361.276671]  ffff8802331c79f8
0000000000000002 ffff8802331c8000 ffff8802331c7fd8
Jun  5 06:55:40 maul kernel: [  361.276679]  00000000000147c0
00000000000147c0 ffff880233226540 ffff8802331c8000
Jun  5 06:55:40 maul kernel: [  361.276686]  ffff88023ed150d8
ffff88023efdeb68 ffff8802331c7a80 0000000000000002
Jun  5 06:55:40 maul kernel: [  361.276693] Call Trace:
Jun  5 06:55:40 maul kernel: [  361.276706]  [<ffffffff8114a1d0>] ?
wait_on_page_read+0x60/0x60
Jun  5 06:55:40 maul kernel: [  361.276714]  [<ffffffff817aeb9f>]
io_schedule+0xaf/0x150
Jun  5 06:55:40 maul kernel: [  361.276721]  [<ffffffff8114a1de>]
sleep_on_page+0xe/0x20
Jun  5 06:55:40 maul kernel: [  361.276727]  [<ffffffff817af213>]
__wait_on_bit_lock+0x53/0xb0
Jun  5 06:55:40 maul kernel: [  361.276734]  [<ffffffff8114a2fa>]
__lock_page+0x6a/0x70
Jun  5 06:55:40 maul kernel: [  361.276741]  [<ffffffff810a4430>] ?
autoremove_wake_function+0x40/0x40
Jun  5 06:55:40 maul kernel: [  361.276749]  [<ffffffff8131579e>] ?
flush_write_bio+0xe/0x10
Jun  5 06:55:40 maul kernel: [  361.276756]  [<ffffffff81319d50>]
extent_write_cache_pages.isra.28.constprop.50+0x230/0x350
Jun  5 06:55:40 maul kernel: [  361.276763]  [<ffffffff8109cb33>] ?
find_busiest_group+0x133/0x830
Jun  5 06:55:40 maul kernel: [  361.276771]  [<ffffffff8131b06c>]
extent_writepages+0x4c/0x60
Jun  5 06:55:40 maul kernel: [  361.276779]  [<ffffffff812fecb0>] ?
btrfs_writepage_end_io_hook+0x190/0x190
Jun  5 06:55:40 maul kernel: [  361.276785]  [<ffffffff817b7134>] ?
preempt_count_add+0x54/0xa0
Jun  5 06:55:40 maul kernel: [  361.276791]  [<ffffffff812fc178>]
btrfs_writepages+0x28/0x30
Jun  5 06:55:40 maul kernel: [  361.276798]  [<ffffffff81157dfe>]
do_writepages+0x1e/0x40
Jun  5 06:55:40 maul kernel: [  361.276805]  [<ffffffff811ea2d0>]
__writeback_single_inode+0x40/0x2a0
Jun  5 06:55:40 maul kernel: [  361.276812]  [<ffffffff811ed4ff>]
writeback_sb_inodes+0x23f/0x3f0
Jun  5 06:55:40 maul kernel: [  361.276821]  [<ffffffff811ed747>]
__writeback_inodes_wb+0x97/0xd0
Jun  5 06:55:40 maul kernel: [  361.276828]  [<ffffffff811ed97b>]
wb_writeback+0x1fb/0x310
Jun  5 06:55:40 maul kernel: [  361.276836]  [<ffffffff811eddd6>]
bdi_writeback_workfn+0x1d6/0x490
Jun  5 06:55:40 maul kernel: [  361.276844]  [<ffffffff810779c8>]
process_one_work+0x178/0x4b0
Jun  5 06:55:40 maul kernel: [  361.276850]  [<ffffffff81078731>]
worker_thread+0x131/0x3d0
Jun  5 06:55:40 maul kernel: [  361.276856]  [<ffffffff81078600>] ?
manage_workers.isra.25+0x2c0/0x2c0
Jun  5 06:55:40 maul kernel: [  361.276863]  [<ffffffff8107eabb>]
kthread+0xdb/0x100
Jun  5 06:55:40 maul kernel: [  361.276871]  [<ffffffff8107e9e0>] ?
kthread_create_on_node+0x190/0x190
Jun  5 06:55:40 maul kernel: [  361.276878]  [<ffffffff817bb7fc>]
ret_from_fork+0x7c/0xb0
Jun  5 06:55:40 maul kernel: [  361.276884]  [<ffffffff8107e9e0>] ?
kthread_create_on_node+0x190/0x190
Jun  5 06:55:40 maul kernel: [  361.276896] INFO: task kworker/u8:1:55
blocked for more than 120 seconds.
Jun  5 06:55:40 maul kernel: [  361.276900]       Not tainted 3.15.0-rc8 #1
Jun  5 06:55:40 maul kernel: [  361.276903] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun  5 06:55:40 maul kernel: [  361.276906] kworker/u8:1    D
ffffffff814231d7     0    55      2 0x00000000
Jun  5 06:55:40 maul kernel: [  361.276916] Workqueue: btrfs-cache
normal_work_helper
Jun  5 06:55:40 maul kernel: [  361.276919]  ffff880232ed3c60
0000000000000002 ffff880232e11950 ffff880232ed3fd8
Jun  5 06:55:40 maul kernel: [  361.276927]  00000000000147c0
00000000000147c0 ffff88022def9950 ffff880232e11950
Jun  5 06:55:40 maul kernel: [  361.276933]  ffff880232e11950
ffff88022f75c680 ffff88022f75c688 0000000000000040
Jun  5 06:55:40 maul kernel: [  361.276940] Call Trace:
Jun  5 06:55:40 maul kernel: [  361.276949]  [<ffffffff817ae839>]
schedule+0x29/0x70
Jun  5 06:55:40 maul kernel: [  361.276955]  [<ffffffff817b19a5>]
rwsem_down_read_failed+0xc5/0x160
Jun  5 06:55:40 maul kernel: [  361.276962]  [<ffffffff812da77c>] ?
btrfs_next_old_leaf+0x1dc/0x4a0
Jun  5 06:55:40 maul kernel: [  361.276971]  [<ffffffff814191f4>]
call_rwsem_down_read_failed+0x14/0x30
Jun  5 06:55:40 maul kernel: [  361.276979]  [<ffffffff817b13b7>] ?
down_read+0x17/0x20
Jun  5 06:55:40 maul kernel: [  361.276985]  [<ffffffff812dfc5b>]
caching_thread+0xeb/0x490
Jun  5 06:55:40 maul kernel: [  361.276993]  [<ffffffff8132960f>]
normal_work_helper+0x12f/0x310
Jun  5 06:55:40 maul kernel: [  361.276999]  [<ffffffff810779c8>]
process_one_work+0x178/0x4b0
Jun  5 06:55:40 maul kernel: [  361.277005]  [<ffffffff81078731>]
worker_thread+0x131/0x3d0
Jun  5 06:55:40 maul kernel: [  361.277011]  [<ffffffff81078600>] ?
manage_workers.isra.25+0x2c0/0x2c0
Jun  5 06:55:40 maul kernel: [  361.277018]  [<ffffffff8107eabb>]
kthread+0xdb/0x100
Jun  5 06:55:40 maul kernel: [  361.277025]  [<ffffffff8107e9e0>] ?
kthread_create_on_node+0x190/0x190
Jun  5 06:55:40 maul kernel: [  361.277032]  [<ffffffff817bb7fc>]
ret_from_fork+0x7c/0xb0
Jun  5 06:55:40 maul kernel: [  361.277039]  [<ffffffff8107e9e0>] ?
kthread_create_on_node+0x190/0x190

This had all seemed to be fine in kernel 3.13.

Peace,
Gary

