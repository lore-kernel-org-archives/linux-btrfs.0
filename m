Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:34234 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3FXMWc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 08:22:32 -0400
Received: from [172.24.1.68] (yian-ho01.nir.cronon.net [192.166.201.94] (may be forged))
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.13.6/8.13.6/Debian-1) with ESMTP id r5OCMURG001221
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 14:22:30 +0200
Message-ID: <51C83A06.2090309@tuxadero.com>
Date: Mon, 24 Jun 2013 14:22:30 +0200
From: Martin Mailand <martin@tuxadero.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: WARNING: at fs/btrfs/backref.c:903
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I tried 3.10.0-rc7 with the btrfs option skinny extents (btrfstune -x),
I get this warning after a few seconds of ceph workload.

-martin


[ 1153.897960] ------------[ cut here ]------------
[ 1153.897977] WARNING: at fs/btrfs/backref.c:903
find_parent_nodes+0x107f/0x1090 [btrfs]()
[ 1153.897978] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler
btrfs zlib_deflate libcrc32c coretemp kvm_intel kvm ghash_clmulni_intel
aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64
bonding microcode psmouse serio_raw lpc_ich joydev ioatdma wmi mac_hid
lp parport raid10 raid456 async_pq async_xor xor async_memcpy
async_raid6_recov hid_generic ses usbhid raid6_pq enclosure ixgbe hid
async_tx dca e1000e raid1 mpt2sas ptp raid0 scsi_transport_sas pps_core
multipath mdio raid_class megaraid_sas linear
[ 1153.898004] CPU: 0 PID: 32374 Comm: btrfs-endio-wri Not tainted
3.10.0-rc7+ #8
[ 1153.898005] Hardware name: Supermicro X9SRL-F/X9SRL-F, BIOS 1.0b
09/19/2012
[ 1153.898006]  ffffffffa04552ad ffff8807d2d1f9d8 ffffffff81636f29
ffff8807d2d1fa18
[ 1153.898008]  ffffffff810404b0 0000000000000000 ffff8804602c04e0
0000000000000000
[ 1153.898010]  ffff8808532a4028 dead000000100100 dead000000200200
ffff8807d2d1fa28
[ 1153.898013] Call Trace:
[ 1153.898018]  [<ffffffff81636f29>] dump_stack+0x19/0x1b
[ 1153.898021]  [<ffffffff810404b0>] warn_slowpath_common+0x70/0xa0
[ 1153.898023]  [<ffffffff810404fa>] warn_slowpath_null+0x1a/0x20
[ 1153.898031]  [<ffffffffa043b91f>] find_parent_nodes+0x107f/0x1090 [btrfs]
[ 1153.898039]  [<ffffffffa03f9184>] ? btrfs_get_token_64+0x64/0xf0 [btrfs]
[ 1153.898047]  [<ffffffffa043b9c9>] btrfs_find_all_roots+0x99/0x100 [btrfs]
[ 1153.898054]  [<ffffffffa03e77b0>] ? btrfs_submit_direct+0x6b0/0x6b0
[btrfs]
[ 1153.898060]  [<ffffffffa03e77b0>] ? btrfs_submit_direct+0x6b0/0x6b0
[btrfs]
[ 1153.898067]  [<ffffffffa043c2c5>] iterate_extent_inodes+0x135/0x250
[btrfs]
[ 1153.898074]  [<ffffffffa043c472>]
iterate_inodes_from_logical+0x92/0xb0 [btrfs]
[ 1153.898080]  [<ffffffffa03e77b0>] ? btrfs_submit_direct+0x6b0/0x6b0
[btrfs]
[ 1153.898086]  [<ffffffffa03e4a98>] record_extent_backrefs+0x78/0xf0
[btrfs]
[ 1153.898093]  [<ffffffffa03ef706>] btrfs_finish_ordered_io+0x156/0x9c0
[btrfs]
[ 1153.898097]  [<ffffffff810512ca>] ? del_timer_sync+0x5a/0x70
[ 1153.898103]  [<ffffffffa03eff85>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1153.898110]  [<ffffffffa040f5fa>] worker_loop+0x14a/0x520 [btrfs]
[ 1153.898117]  [<ffffffffa040f4b0>] ? btrfs_queue_worker+0x300/0x300
[btrfs]
[ 1153.898121]  [<ffffffff81066560>] kthread+0xc0/0xd0
[ 1153.898123]  [<ffffffff810664a0>] ? flush_kthread_worker+0xb0/0xb0
[ 1153.898126]  [<ffffffff816453dc>] ret_from_fork+0x7c/0xb0
[ 1153.898128]  [<ffffffff810664a0>] ? flush_kthread_worker+0xb0/0xb0
[ 1153.898130] ---[ end trace 9ea90caaae31fcaa ]---
[ 1153.898148] ------------[ cut here ]------------
