Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44908 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933960AbcKNRJz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 12:09:55 -0500
Received: from hch by bombadil.infradead.org with local (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6KlW-0002AP-Rx
        for linux-btrfs@vger.kernel.org; Mon, 14 Nov 2016 17:09:54 +0000
Date: Mon, 14 Nov 2016 09:09:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: linux-btrfs@vger.kernel.org
Subject: another latest mainline crash in xfstests
Message-ID: <20161114170954.GA1997@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And if this isn't enough it seems generic/166 hangs after finishing
the main test (which already takes a very long time):

generic/113 16s ...[ 2498.548221] run fstests generic/113 at 2016-11-14
17:04:56
[ 2498.984322] BTRFS info (device vdb): disk space caching is enabled
[ 2499.983635] BTRFS info (device vdb): disk space caching is enabled
[ 2501.282154] BTRFS info (device vdb): disk space caching is enabled
[ 2528.330899] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
[aio-stress:17961]
[ 2528.333617] Modules linked in:
[ 2528.334685] CPU: 0 PID: 17961 Comm: aio-stress Not tainted 4.9.0-rc5 #828
[ 2528.336999] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[ 2528.337563] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [aio-stress:17960]
[ 2528.337564] Modules linked in:
[ 2528.337566] CPU: 1 PID: 17960 Comm: aio-stress Not tainted 4.9.0-rc5 #828
[ 2528.337567] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[ 2528.337568] task: ffff880137e98240 task.stack: ffffc900001e4000
[ 2528.337573] RIP: 0010:[<ffffffff811dd2fe>]  [<ffffffff811dd2fe>] check_poison_obj+0x4e/0x250
[ 2528.337574] RSP: 0018:ffffc900001e7690  EFLAGS: 00000297
[ 2528.337575] RAX: 000000000000006b RBX: 00000000000000a5 RCX: 0000000000000000
[ 2528.337576] RDX: 00000000000000a5 RSI: ffff88013ba7e300 RDI: ffff88013b800500
[ 2528.337577] RBP: ffffc900001e76d8 R08: 0000000000000001 R09: 0000000000000001
[ 2528.337577] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffa5
[ 2528.337578] R13: ffff88013ba7e300 R14: 0000000000000000 R15: 0000000000000100
[ 2528.337579] FS:  00007fcc22b1e700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
[ 2528.337580] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2528.337581] CR2: 00007fcc296e9000 CR3: 000000012e2e0000 CR4: 00000000000006e0
[ 2528.337584] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2528.337585] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2528.337585] Stack:
[ 2528.337588]  0000000000000046 ffff88013ba7e300 ffff88013b800500 000000ff001e76c0
[ 2528.337590]  ffff88013b800500 ffff88013ba7e300 0000000040002800 ffffffff81618622
[ 2528.337593]  ffff88013b800500 ffffc900001e7708 ffffffff811dd686 0000000000000286
[ 2528.337594] Call Trace:
[ 2528.337598]  [<ffffffff81618622>] ? cache_block_group+0x62/0x3c0
[ 2528.337600]  [<ffffffff811dd686>] cache_alloc_debugcheck_after.isra.71+0x146/0x1c0
[ 2528.337602]  [<ffffffff81618622>] ? cache_block_group+0x62/0x3c0
[ 2528.337603]  [<ffffffff811de6be>] kmem_cache_alloc_trace+0x8e/0x160
[ 2528.337605]  [<ffffffff81618622>] cache_block_group+0x62/0x3c0
[ 2528.337607]  [<ffffffff81616571>] ? get_caching_control+0x31/0x40
[ 2528.337609]  [<ffffffff81107770>] ? wake_up_bit+0x30/0x30
[ 2528.337610]  [<ffffffff8162722c>] find_free_extent+0x79c/0xef0
[ 2528.337612]  [<ffffffff816279fe>] btrfs_reserve_extent+0x7e/0x1f0
[ 2528.337614]  [<ffffffff8164c860>] btrfs_get_blocks_direct+0x360/0x740
[ 2528.337616]  [<ffffffff8121eaf0>] __blockdev_direct_IO+0xbc0/0x4410
[ 2528.337619]  [<ffffffff81df2fd9>] ? _raw_spin_unlock+0x9/0x10
[ 2528.337620]  [<ffffffff81df2fd9>] ? _raw_spin_unlock+0x9/0x10
[ 2528.337622]  [<ffffffff81625a10>] ? reserve_metadata_bytes+0x180/0x950
[ 2528.337624]  [<ffffffff8164c500>] ? btrfs_page_exists_in_range+0x110/0x110
[ 2528.337625]  [<ffffffff8163dc20>] ? btrfs_endio_direct_write_update_ordered+0xc0/0xc0
[ 2528.337627]  [<ffffffff8163fda2>] btrfs_direct_IO+0x1c2/0x350
[ 2528.337628]  [<ffffffff8163dc20>] ? btrfs_endio_direct_write_update_ordered+0xc0/0xc0
[ 2528.337630]  [<ffffffff81192164>] generic_file_direct_write+0xa4/0x160
[ 2528.337632]  [<ffffffff816533b5>] btrfs_file_write_iter+0x175/0x5f0
[ 2528.337634]  [<ffffffff8122c572>] aio_write+0xb2/0x130
[ 2528.337636]  [<ffffffff8122dae4>] ? do_io_submit+0x224/0x530
[ 2528.337638]  [<ffffffff811dd6a4>] ? cache_alloc_debugcheck_after.isra.71+0x164/0x1c0
[ 2528.337639]  [<ffffffff8122dae4>] ? do_io_submit+0x224/0x530
[ 2528.337641]  [<ffffffff811de61f>] ? kmem_cache_alloc+0x14f/0x160
[ 2528.337642]  [<ffffffff8122dcbd>] do_io_submit+0x3fd/0x530
[ 2528.337644]  [<ffffffff8122ddfb>] SyS_io_submit+0xb/0x10
[ 2528.337646]  [<ffffffff81df3337>] entry_SYSCALL_64_fastpath+0x1a/0xa9
[ 2528.337668] Code: 7e 75 41 8d 47 ff 48 89 75 c0 45 31 f6 31 db 48 89 7d c8 41 bc a5 ff ff ff 89 45 d4 3b 5d d4 b8 6b 00 00 00 48 63 d3 41 0f 44 c4 <41> 38 44 15 00 74 38 45 85 f6 0f 84 41 01 00 00 8d 73 0f 85 db 
[ 2528.344233] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [aio-stress:17962]
[ 2528.344234] Modules linked in:
[ 2528.344236] CPU: 2 PID: 17962 Comm: aio-stress Tainted: G L  4.9.0-rc5 #828
[ 2528.344237] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[ 2528.344238] task: ffff88012aec0380 task.stack: ffffc900001f4000
[ 2528.344243] RIP: 0010:[<ffffffff8110e681>]  [<ffffffff8110e681>] do_raw_spin_lock+0x1/0x120
[ 2528.344244] RSP: 0018:ffffc900001f77c0  EFLAGS: 00000246
[ 2528.344245] RAX: 0000000000000000 RBX: ffff880138740c00 RCX: 0000000000000000
[ 2528.344245] RDX: 000000000000000e RSI: 000000000000006b RDI: ffff88012e5979c0
[ 2528.344246] RBP: ffffc900001f77d0 R08: 000000000430a390 R09: ffff88013277e700
[ 2528.344247] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880131c84000
[ 2528.344247] R13: ffffc900001f79b0 R14: 0000000000000000 R15: ffff8801387e6000
[ 2528.344249] FS:  00007fcc21b1c700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
[ 2528.344250] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2528.344250] CR2: 00007fcc296d7000 CR3: 000000012e2e0000 CR4: 00000000000006e0
[ 2528.344254] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2528.344254] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2528.344255] Stack:
[ 2528.344257]  ffffc900001f77d0 ffffffff81df2f59 ffffc900001f78a8 ffffffff81626d6b
[ 2528.344259]  0000000000010000 ffff8801387e6000 01ff880138ee0900 0000000000010000
[ 2528.344261]  ffff880131c84000 0000000000000018 ffff8801387e60f0 ffffc900001f79b0
[ 2528.344261] Call Trace:
[ 2528.344265]  [<ffffffff81df2f59>] ? _raw_spin_lock+0x9/0x10
[ 2528.344267]  [<ffffffff81626d6b>] find_free_extent+0x2db/0xef0
[ 2528.344269]  [<ffffffff816279fe>] btrfs_reserve_extent+0x7e/0x1f0
[ 2528.344271]  [<ffffffff8164c860>] btrfs_get_blocks_direct+0x360/0x740
[ 2528.344273]  [<ffffffff8121eaf0>] __blockdev_direct_IO+0xbc0/0x4410
[ 2528.344275]  [<ffffffff81df2fd9>] ? _raw_spin_unlock+0x9/0x10
[ 2528.344276]  [<ffffffff81df2fd9>] ? _raw_spin_unlock+0x9/0x10
[ 2528.344278]  [<ffffffff81625a10>] ? reserve_metadata_bytes+0x180/0x950
[ 2528.344279]  [<ffffffff8164c500>] ? btrfs_page_exists_in_range+0x110/0x110
[ 2528.344281]  [<ffffffff8163dc20>] ? btrfs_endio_direct_write_update_ordered+0xc0/0xc0
[ 2528.344282]  [<ffffffff8163fda2>] btrfs_direct_IO+0x1c2/0x350
[ 2528.344284]  [<ffffffff8163dc20>] ? btrfs_endio_direct_write_update_ordered+0xc0/0xc0
[ 2528.344286]  [<ffffffff81192164>] generic_file_direct_write+0xa4/0x160
[ 2528.344287]  [<ffffffff816533b5>] btrfs_file_write_iter+0x175/0x5f0
[ 2528.344289]  [<ffffffff8122c572>] aio_write+0xb2/0x130
[ 2528.344291]  [<ffffffff8122dae4>] ? do_io_submit+0x224/0x530
[ 2528.344293]  [<ffffffff811dd6a4>] ? cache_alloc_debugcheck_after.isra.71+0x164/0x1c0
[ 2528.344295]  [<ffffffff8122dae4>] ? do_io_submit+0x224/0x530
[ 2528.344296]  [<ffffffff811de61f>] ? kmem_cache_alloc+0x14f/0x160
[ 2528.344298]  [<ffffffff8122dcbd>] do_io_submit+0x3fd/0x530
[ 2528.344300]  [<ffffffff8122ddfb>] SyS_io_submit+0xb/0x10
[ 2528.344301]  [<ffffffff81df3337>] entry_SYSCALL_64_fastpath+0x1a/0xa9
