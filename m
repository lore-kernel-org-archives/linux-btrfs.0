Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-206-126-220-193.bertramwireless.com ([206.126.220.193]:51554
	"EHLO static-206-126-220-193.bertramwireless.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab2HOP1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 11:27:38 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by static-206-126-220-193.bertramwireless.com (Postfix) with ESMTP id 8E1DD5401AC
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2012 10:20:58 -0500 (CDT)
Received: from static-206-126-220-193.bertramwireless.com ([127.0.0.1])
	by localhost (static-206-126-220-193.bertramwireless.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KBtz99DmPaEB for <linux-btrfs@vger.kernel.org>;
	Wed, 15 Aug 2012 10:20:54 -0500 (CDT)
Received: from [192.168.168.57] (unknown [192.168.168.57])
	by static-206-126-220-193.bertramwireless.com (Postfix) with ESMTPSA id 1EAD25401AA
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2012 10:20:54 -0500 (CDT)
From: Anthony Plack <anthony@oddllc.com>
Content-Type: text/plain; charset=us-ascii
Subject: kernel BUG at fs/btrfs/extent_io.c:1884 - BTRFS
Date: Wed, 15 Aug 2012 10:21:48 -0500
Message-Id: <1C74CEFB-327D-44F9-8311-E0C1148C6F0B@oddllc.com>
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1278)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay, this is the second occurrence of this bug.  I have searched Google, and while there are two posting for exten_io, I am not sure if they match.

Running Gentoo with kernel 3.5 on a dual core AMD.  The machine has 19 drives of varied types.  I am running rsync from an xfs volume (on two md arrays) to the btrfs volume and moving 8.2T.  This is the first time some of these drives have been exercised.  Four of the drives are in an external cage with a SATA multiplexer running across an eSATA cable.

On the btrfs volume, the metadata is RAID1, but the data is RAID0.

To me the most troubling issue is that the bug causes the system to become unresponsive whenever accessing the btrfs volume.  Any btrfs command will hang at the prompt.  umount would similarly hang.   On Aug 10th, I let the prompts sit for 48 hours with no progress because I did not desire to take the box down for other processes.  All attempts to kill the processes come back with no impact on the process, they are just zombies in the system.  The system does not seem to have excessive CPU or memory consumption.

After the first event, I have learned what is forcing the situation.  There are two used "ST3000DM001-9YN1 CC9D" Seagate drives which are posting some errors in the console.  The multiplexer is responding to these errors by shutting down the drive.  If I reboot the box, the multiplexer will show one drive as off-line.  I was successful in removing and reseating the drive.  The bad block count is up, but not that high for a 3T drive (200s).  "shutdown" command would also hang on this first event.  I unmounted all the other volumes, and had to hard reboot the server.

The second event, suspecting the multiplexer did it again, I hot unplugged the second drive (/dev/sdi) which was missing from lsscsi.  The drive is back online (as /dev/sdt) but btrfs is not detecting the shift and is still hung.  I have the original rsync stuck.  This time, I was able to get btrfs command to operate without hanging.  In addition, the drive is accessible, but the rsync commands are hung.

When I attempted to scrub the volume, I posted another trace in the log.



Okay details....


Trace Failure 1:
Aug 10 06:22:48 fatdrive kernel: [131136.506053] kernel BUG at fs/btrfs/extent_io.c:1884!
Aug 10 06:22:48 fatdrive kernel: [131136.506070] invalid opcode: 0000 [#1] SMP 
Aug 10 06:22:48 fatdrive kernel: [131136.506087] CPU 1 
Aug 10 06:22:48 fatdrive kernel: [131136.506090] Modules linked in: btrfs lzo_compress lzo_decompress zlib_deflate crc32c libcrc32c r8168(O) nfsd xfs exportfs shpchp pci_hotplug r8169 k10temp mii kvm_amd kvm
Aug 10 06:22:48 fatdrive kernel: [131136.506168] 
Aug 10 06:22:48 fatdrive kernel: [131136.506184] Pid: 8458, comm: btrfs-endio-wri Tainted: G        W  O 3.5.0-gentoo #2 BIOSTAR Group TA880G HD/TA880G HD
Aug 10 06:22:48 fatdrive kernel: [131136.506219] RIP: 0010:[<ffffffffa02b9231>]  [<ffffffffa02b9231>] repair_io_failure+0x1a1/0x1e0 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.506270] RSP: 0018:ffff8800889dd970  EFLAGS: 00010246
Aug 10 06:22:48 fatdrive kernel: [131136.506288] RAX: ffff8800889dd9a0 RBX: 0000000000000000 RCX: 0000007879ea8000
Aug 10 06:22:48 fatdrive kernel: [131136.506318] RDX: 0000000000001000 RSI: 0000007879ea8000 RDI: ffff880215754108
Aug 10 06:22:48 fatdrive kernel: [131136.506347] RBP: ffff8800889dd9f0 R08: ffffea0000ef8a80 R09: 0000000000000000
Aug 10 06:22:48 fatdrive kernel: [131136.506378] R10: 57ffe641d6ef8a80 R11: 0000000000000001 R12: 0000000000000000
Aug 10 06:22:48 fatdrive kernel: [131136.506407] R13: ffff8800889dd990 R14: 0000007879ea8000 R15: 0000000000001000
Aug 10 06:22:48 fatdrive kernel: [131136.506439] FS:  00007f7f6959e700(0000) GS:ffff88021fc40000(0000) knlGS:0000000000000000
Aug 10 06:22:48 fatdrive kernel: [131136.506469] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 10 06:22:48 fatdrive kernel: [131136.506490] CR2: 00007f12b121f624 CR3: 0000000198bac000 CR4: 00000000000007e0
Aug 10 06:22:48 fatdrive kernel: [131136.506521] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 10 06:22:48 fatdrive kernel: [131136.506556] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 10 06:22:48 fatdrive kernel: [131136.506584] Process btrfs-endio-wri (pid: 8458, threadinfo ffff8800889dc000, task ffff88018a3c0770)
Aug 10 06:22:48 fatdrive kernel: [131136.506614] Stack:
Aug 10 06:22:48 fatdrive kernel: [131136.506628]  ffffea0000ef8a80 0000007879ea8000 ffff880215754108 ffffea0000ef8a80
Aug 10 06:22:48 fatdrive kernel: [131136.506659]  0000000000000000 0000000000000000 ffff8800889dd9a0 ffff8800889dd9a0
Aug 10 06:22:48 fatdrive kernel: [131136.506690]  0000000000000000 0000000000000000 ffff880200000001 0000000000000000
Aug 10 06:22:48 fatdrive kernel: [131136.506721] Call Trace:
Aug 10 06:22:48 fatdrive kernel: [131136.506746]  [<ffffffffa02b9b91>] repair_eb_io_failure+0x81/0xa0 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.506770]  [<ffffffffa029119a>] btree_read_extent_buffer_pages.constprop.115+0x11a/0x120 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.506808]  [<ffffffffa02921b5>] read_tree_block+0x35/0x50 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.506832]  [<ffffffffa0277372>] read_block_for_search.isra.44+0x122/0x3a0 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.506869]  [<ffffffffa0276bcf>] ? generic_bin_search.constprop.48+0xdf/0x160 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.506906]  [<ffffffffa02cd7e2>] ? btrfs_tree_unlock+0x22/0xb0 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.506929]  [<ffffffffa0279969>] btrfs_search_slot+0x369/0x8f0 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.506953]  [<ffffffffa028c81f>] btrfs_lookup_csum+0x6f/0x190 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.506970]  [<ffffffff8110eac0>] ? kmem_cache_alloc+0xb0/0x120
Aug 10 06:22:48 fatdrive kernel: [131136.506994]  [<ffffffffa028d9cc>] btrfs_csum_file_blocks+0xac/0x710 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.507020]  [<ffffffffa02a9389>] ? try_merge_map+0x29/0x130 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.507044]  [<ffffffffa029a6cd>] add_pending_csums.isra.35+0x3d/0x60 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.507081]  [<ffffffffa029dfdf>] btrfs_finish_ordered_io+0x25f/0x3b0 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.507121]  [<ffffffffa029e140>] finish_ordered_fn+0x10/0x20 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.507146]  [<ffffffffa02c73b1>] worker_loop+0x141/0x530 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.507163]  [<ffffffff8105bd10>] ? __wake_up_common+0x50/0x80
Aug 10 06:22:48 fatdrive kernel: [131136.507188]  [<ffffffffa02c7270>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.507205]  [<ffffffff810536ee>] kthread+0x8e/0xa0
Aug 10 06:22:48 fatdrive kernel: [131136.507222]  [<ffffffff815eb3b4>] kernel_thread_helper+0x4/0x10
Aug 10 06:22:48 fatdrive kernel: [131136.507238]  [<ffffffff81053660>] ? kthread_freezable_should_stop+0x60/0x60
Aug 10 06:22:48 fatdrive kernel: [131136.507256]  [<ffffffff815eb3b0>] ? gs_change+0xb/0xb
Aug 10 06:22:48 fatdrive kernel: [131136.507629] Code: 1f 00 48 89 df e8 70 d0 e8 e0 48 83 c4 58 b8 fb ff ff ff 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 40 00 b8 fb ff ff ff eb c7 0f 0b <0f> 0b 48 8b 55 98 49 8b 8c 24 88 00 00 00 4d 89 f0 48 c7 c7 88 
Aug 10 06:22:48 fatdrive kernel: [131136.507725] RIP  [<ffffffffa02b9231>] repair_io_failure+0x1a1/0x1e0 [btrfs]
Aug 10 06:22:48 fatdrive kernel: [131136.507751]  RSP <ffff8800889dd970>



Trace Failure 2:
Aug 14 22:55:27 fatdrive kernel: [212746.878300] kernel BUG at fs/btrfs/extent_io.c:1884!
Aug 14 22:55:27 fatdrive kernel: [212746.878316] invalid opcode: 0000 [#1] SMP 
Aug 14 22:55:27 fatdrive kernel: [212746.878333] CPU 1 
Aug 14 22:55:27 fatdrive kernel: [212746.878335] Modules linked in: btrfs lzo_compress lzo_decompress zlib_deflate crc32c libcrc32c nfsd xfs exportfs shpchp pci_hotplug r8168(O) k10temp kvm_amd kvm
Aug 14 22:55:27 fatdrive kernel: [212746.878408] 
Aug 14 22:55:27 fatdrive kernel: [212746.878423] Pid: 5145, comm: rsync Tainted: G           O 3.5.0-gentoo #2 BIOSTAR Group TA880G HD/TA880G HD
Aug 14 22:55:27 fatdrive kernel: [212746.878458] RIP: 0010:[<ffffffffa02a5231>]  [<ffffffffa02a5231>] repair_io_failure+0x1a1/0x1e0 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.878508] RSP: 0018:ffff88016a18f748  EFLAGS: 00010246
Aug 14 22:55:27 fatdrive kernel: [212746.878524] RAX: ffff88016a18f778 RBX: 0000000000000000 RCX: 00000077ebb17000
Aug 14 22:55:27 fatdrive kernel: [212746.878553] RDX: 0000000000001000 RSI: 00000077ebb17000 RDI: ffff8801eb1c2108
Aug 14 22:55:27 fatdrive kernel: [212746.878584] RBP: ffff88016a18f7c8 R08: ffffea0003200540 R09: 0000000000000000
Aug 14 22:55:27 fatdrive kernel: [212746.878613] R10: 57ffdd7fee200540 R11: 0000000000000000 R12: 0000000000000000
Aug 14 22:55:27 fatdrive kernel: [212746.878644] R13: ffff88016a18f768 R14: 00000077ebb17000 R15: 0000000000001000
Aug 14 22:55:27 fatdrive kernel: [212746.878674] FS:  00007f56985a2700(0000) GS:ffff88021fc40000(0000) knlGS:0000000000000000
Aug 14 22:55:27 fatdrive kernel: [212746.878702] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 14 22:55:27 fatdrive kernel: [212746.878718] CR2: 0000000002c53480 CR3: 00000001e18ee000 CR4: 00000000000007e0
Aug 14 22:55:27 fatdrive kernel: [212746.878747] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 14 22:55:27 fatdrive kernel: [212746.878778] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 14 22:55:27 fatdrive kernel: [212746.878809] Process rsync (pid: 5145, threadinfo ffff88016a18e000, task ffff880216523b80)
Aug 14 22:55:27 fatdrive kernel: [212746.878840] Stack:
Aug 14 22:55:27 fatdrive kernel: [212746.878855]  ffffea0003200540 00000077ebb17000 ffff8801eb1c2108 ffffea0003200540
Aug 14 22:55:27 fatdrive kernel: [212746.878889]  0000000000000000 0000000000000000 ffff88016a18f778 ffff88016a18f778
Aug 14 22:55:27 fatdrive kernel: [212746.878922]  0000000000000000 0000000000000000 ffff880100000001 0000000000000000
Aug 14 22:55:27 fatdrive kernel: [212746.878955] Call Trace:
Aug 14 22:55:27 fatdrive kernel: [212746.878981]  [<ffffffffa02a5b91>] repair_eb_io_failure+0x81/0xa0 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879006]  [<ffffffffa027d19a>] btree_read_extent_buffer_pages.constprop.115+0x11a/0x120 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879045]  [<ffffffffa027e1b5>] read_tree_block+0x35/0x50 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879069]  [<ffffffffa0263372>] read_block_for_search.isra.44+0x122/0x3a0 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879108]  [<ffffffffa0265969>] btrfs_search_slot+0x369/0x8f0 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879133]  [<ffffffffa026b641>] lookup_inline_extent_backref+0x81/0x490 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879166]  [<ffffffff8110eb5a>] ? kmem_cache_free+0x2a/0x110
Aug 14 22:55:27 fatdrive kernel: [212746.879189]  [<ffffffffa026d658>] __btrfs_free_extent+0xb8/0x6f0 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879213]  [<ffffffffa026eb58>] ? btrfs_reduce_alloc_profile+0x58/0x110 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879252]  [<ffffffffa0271fc8>] run_clustered_refs+0x488/0xa50 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879279]  [<ffffffffa02c5ced>] ? find_ref_head+0x3d/0xc0 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879303]  [<ffffffffa0272722>] btrfs_run_delayed_refs+0x192/0x450 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879324]  [<ffffffff8105cdd6>] ? __wake_up+0x46/0x60
Aug 14 22:55:27 fatdrive kernel: [212746.879349]  [<ffffffffa0284022>] __btrfs_end_transaction+0xd2/0x350 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879373]  [<ffffffffa0284300>] btrfs_end_transaction+0x10/0x20 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879401]  [<ffffffffa028ddc4>] btrfs_evict_inode+0x244/0x2d0 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879419]  [<ffffffff8112d51a>] evict+0xaa/0x1b0
Aug 14 22:55:27 fatdrive kernel: [212746.879439]  [<ffffffff8112d723>] iput+0x103/0x200
Aug 14 22:55:27 fatdrive kernel: [212746.879458]  [<ffffffff8112363b>] do_unlinkat+0x14b/0x1b0
Aug 14 22:55:27 fatdrive kernel: [212746.879475]  [<ffffffff810675d3>] ? pick_next_task_fair+0x63/0x150
Aug 14 22:55:27 fatdrive kernel: [212746.879494]  [<ffffffff815e1b6e>] ? __schedule+0x39e/0x740
Aug 14 22:55:27 fatdrive kernel: [212746.879512]  [<ffffffff811241d1>] sys_unlink+0x11/0x20
Aug 14 22:55:27 fatdrive kernel: [212746.879531]  [<ffffffff815ea2a2>] system_call_fastpath+0x16/0x1b
Aug 14 22:55:27 fatdrive kernel: [212746.879546] Code: 1f 00 48 89 df e8 70 10 ea e0 48 83 c4 58 b8 fb ff ff ff 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 40 00 b8 fb ff ff ff eb c7 0f 0b <0f> 0b 48 8b 55 98 49 8b 8c 24 88 00 00 00 4d 89 f0 48 c7 c7 88 
Aug 14 22:55:27 fatdrive kernel: [212746.879649] RIP  [<ffffffffa02a5231>] repair_io_failure+0x1a1/0x1e0 [btrfs]
Aug 14 22:55:27 fatdrive kernel: [212746.879676]  RSP <ffff88016a18f748>

Trace after Scrub:
Aug 15 10:03:40 fatdrive kernel: [252763.388594] kernel BUG at fs/btrfs/scrub.c:638!
Aug 15 10:03:40 fatdrive kernel: [252763.388610] invalid opcode: 0000 [#2] SMP 
Aug 15 10:03:40 fatdrive kernel: [252763.388628] CPU 0 
Aug 15 10:03:40 fatdrive kernel: [252763.388630] Modules linked in: btrfs lzo_compress lzo_decompress zlib_deflate crc32c libcrc32c nfsd xfs exportfs shpchp pci_hotplug r8168(O) k10temp kvm_amd kvm
Aug 15 10:03:40 fatdrive kernel: [252763.388702] 
Aug 15 10:03:40 fatdrive kernel: [252763.388716] Pid: 18567, comm: btrfs-scrub-1 Tainted: G      D    O 3.5.0-gentoo #2 BIOSTAR Group TA880G HD/TA880G HD
Aug 15 10:03:40 fatdrive kernel: [252763.388748] RIP: 0010:[<ffffffffa02d4c75>]  [<ffffffffa02d4c75>] scrub_handle_errored_block+0x945/0x950 [btrfs]
Aug 15 10:03:40 fatdrive kernel: [252763.388797] RSP: 0018:ffff88003b917c80  EFLAGS: 00010246
Aug 15 10:03:40 fatdrive kernel: [252763.388813] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff88020eee0338
Aug 15 10:03:40 fatdrive kernel: [252763.388842] RDX: 0000000000002893 RSI: ffff88020eee03b8 RDI: ffff88004b13d800
Aug 15 10:03:40 fatdrive kernel: [252763.388872] RBP: ffff88003b917d40 R08: dead000000100100 R09: dead000000200200
Aug 15 10:03:40 fatdrive kernel: [252763.388902] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88020eee03b8
Aug 15 10:03:40 fatdrive kernel: [252763.388930] R13: ffff8801564df600 R14: ffff8801d46b3b58 R15: ffff88003b917e98
Aug 15 10:03:40 fatdrive kernel: [252763.388959] FS:  00007f8888bc3700(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
Aug 15 10:03:40 fatdrive kernel: [252763.388987] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 15 10:03:40 fatdrive kernel: [252763.389002] CR2: 00007f8888ca4dd0 CR3: 000000020efc5000 CR4: 00000000000007f0
Aug 15 10:03:40 fatdrive kernel: [252763.389030] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 15 10:03:40 fatdrive kernel: [252763.389058] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 15 10:03:40 fatdrive kernel: [252763.389087] Process btrfs-scrub-1 (pid: 18567, threadinfo ffff88003b916000, task ffff8802165b51d0)
Aug 15 10:03:40 fatdrive kernel: [252763.389115] Stack:
Aug 15 10:03:40 fatdrive kernel: [252763.389129]  0000000000000000 ffff88021fc12030 ffff880216624aa8 ffff880216624aa8
Aug 15 10:03:40 fatdrive kernel: [252763.389160]  ffff88003b917cf0 ffffffff810675d3 0000000000002893 0000000000010000
Aug 15 10:03:40 fatdrive kernel: [252763.389191]  ffff8801eb1c2000 ff0088013e2ed380 0000000000011fc0 0000000000000282
Aug 15 10:03:40 fatdrive kernel: [252763.389222] Call Trace:
Aug 15 10:03:40 fatdrive kernel: [252763.389239]  [<ffffffff810675d3>] ? pick_next_task_fair+0x63/0x150
Aug 15 10:03:40 fatdrive kernel: [252763.389257]  [<ffffffff81041663>] ? lock_timer_base.isra.35+0x33/0x70
Aug 15 10:03:40 fatdrive kernel: [252763.389283]  [<ffffffffa02d4ee2>] scrub_bio_end_io_worker+0x262/0x750 [btrfs]
Aug 15 10:03:40 fatdrive kernel: [252763.389312]  [<ffffffff81040fc0>] ? usleep_range+0x40/0x40
Aug 15 10:03:40 fatdrive kernel: [252763.389337]  [<ffffffffa02b33b1>] worker_loop+0x141/0x530 [btrfs]
Aug 15 10:03:40 fatdrive kernel: [252763.389354]  [<ffffffff8105bd10>] ? __wake_up_common+0x50/0x80
Aug 15 10:03:40 fatdrive kernel: [252763.389378]  [<ffffffffa02b3270>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
Aug 15 10:03:40 fatdrive kernel: [252763.389396]  [<ffffffff810536ee>] kthread+0x8e/0xa0
Aug 15 10:03:40 fatdrive kernel: [252763.389412]  [<ffffffff815eb3b4>] kernel_thread_helper+0x4/0x10
Aug 15 10:03:40 fatdrive kernel: [252763.389428]  [<ffffffff81053660>] ? kthread_freezable_should_stop+0x60/0x60
Aug 15 10:03:40 fatdrive kernel: [252763.389445]  [<ffffffff815eb3b0>] ? gs_change+0xb/0xb
Aug 15 10:03:40 fatdrive kernel: [252763.389461] Code: ff ff 48 8b 75 b0 48 c7 c7 8b 3f 2e a0 e8 d4 cd ff ff e9 3d fd ff ff bb 10 00 00 00 e9 ce fd ff ff 45 31 ff 66 90 e9 a6 fa ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 1f 00 55 48 89 e5 41 57 41 56 41 55 
Aug 15 10:03:40 fatdrive kernel: [252763.389557] RIP  [<ffffffffa02d4c75>] scrub_handle_errored_block+0x945/0x950 [btrfs]
Aug 15 10:03:40 fatdrive kernel: [252763.389595]  RSP <ffff88003b917c80>



Bad drive coming online:
Aug 15 09:06:07 fatdrive kernel: [249317.107068] ata7.02: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xf
Aug 15 09:06:07 fatdrive kernel: [249317.107122] ata7.02: SError: { PHYRdyChg DevExch }
Aug 15 09:06:08 fatdrive kernel: [249317.411705] ata7.02: hard resetting link
Aug 15 09:06:08 fatdrive kernel: [249318.133462] ata7.02: SATA link down (SStatus 0 SControl 320)
Aug 15 09:06:08 fatdrive kernel: [249318.133598] ata7: EH complete
Aug 15 09:06:28 fatdrive kernel: [249337.172790] ata7.02: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 0xf
Aug 15 09:06:28 fatdrive kernel: [249337.172845] ata7.02: SError: { PHYRdyChg CommWake DevExch }
Aug 15 09:06:28 fatdrive kernel: [249337.172929] ata7.02: hard resetting link
Aug 15 09:06:28 fatdrive kernel: [249338.014727] ata7.02: softreset failed (SRST command error)
Aug 15 09:06:28 fatdrive kernel: [249338.014843] ata7.02: failed to read SCR 0 (Emask=0x40)
Aug 15 09:06:28 fatdrive kernel: [249338.014880] ata7.02: reset failed (errno=-85), retrying in 10 secs
Aug 15 09:06:29 fatdrive afpd[28079]: afp_alarm: sleep time ended
Aug 15 09:06:38 fatdrive kernel: [249347.153086] ata7.02: reset failed, giving up
Aug 15 09:06:38 fatdrive kernel: [249347.153163] ata7.15: hard resetting link
Aug 15 09:06:38 fatdrive kernel: [249347.153200] ata7: controller in dubious state, performing PORT_RST
Aug 15 09:06:40 fatdrive kernel: [249349.302955] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
Aug 15 09:06:40 fatdrive kernel: [249349.303263] ata7.00: hard resetting link
Aug 15 09:06:40 fatdrive kernel: [249349.618520] ata7.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
Aug 15 09:06:40 fatdrive kernel: [249349.618585] ata7.01: hard resetting link
Aug 15 09:06:40 fatdrive kernel: [249350.010768] ata7.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 15 09:06:40 fatdrive kernel: [249350.010832] ata7.02: hard resetting link
Aug 15 09:06:41 fatdrive kernel: [249350.337187] ata7.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 15 09:06:41 fatdrive kernel: [249350.337251] ata7.03: hard resetting link
Aug 15 09:06:41 fatdrive kernel: [249350.663565] ata7.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 15 09:06:41 fatdrive kernel: [249350.663631] ata7.04: hard resetting link
Aug 15 09:06:41 fatdrive kernel: [249350.968069] ata7.04: SATA link down (SStatus 0 SControl 320)
Aug 15 09:06:41 fatdrive kernel: [249350.968156] ata7.05: hard resetting link
Aug 15 09:06:42 fatdrive kernel: [249351.272449] ata7.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
Aug 15 09:06:42 fatdrive kernel: [249351.284972] ata7.00: configured for UDMA/100
Aug 15 09:06:42 fatdrive kernel: [249351.307051] ata7.01: configured for UDMA/100
Aug 15 09:06:42 fatdrive kernel: [249351.307742] ata7.02: ATA-8: ST3000DM001-9YN166, CC9D, max UDMA/133
Aug 15 09:06:42 fatdrive kernel: [249351.307784] ata7.02: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Aug 15 09:06:42 fatdrive kernel: [249351.308445] ata7.02: configured for UDMA/100
Aug 15 09:06:42 fatdrive kernel: [249351.551624] ata7.03: configured for UDMA/66
Aug 15 09:06:42 fatdrive kernel: [249351.551717] ata7: EH complete
Aug 15 09:06:42 fatdrive kernel: [249351.552078] scsi 6:2:0:0: Direct-Access     ATA      ST3000DM001-9YN1 CC9D PQ: 0 ANSI: 5
Aug 15 09:06:42 fatdrive kernel: [249351.552194] device: '6:2:0:0': device_add
Aug 15 09:06:42 fatdrive kernel: [249351.552243] bus: 'scsi': add device 6:2:0:0
Aug 15 09:06:42 fatdrive kernel: [249351.552282] PM: Adding info for scsi:6:2:0:0
Aug 15 09:06:42 fatdrive kernel: [249351.552335] bus: 'scsi': driver_probe_device: matched device 6:2:0:0 with driver sd
Aug 15 09:06:42 fatdrive kernel: [249351.552384] bus: 'scsi': really_probe: probing driver sd with device 6:2:0:0
Aug 15 09:06:42 fatdrive kernel: [249351.552431] device: '6:2:0:0': device_add
Aug 15 09:06:42 fatdrive kernel: [249351.552476] PM: Adding info for No Bus:6:2:0:0
Aug 15 09:06:42 fatdrive kernel: [249351.552519] driver: '6:2:0:0': driver_bound: bound to device 'sd'
Aug 15 09:06:42 fatdrive kernel: [249351.552566] bus: 'scsi': really_probe: bound device 6:2:0:0 to driver sd
Aug 15 09:06:42 fatdrive kernel: [249351.552603] device: '6:2:0:0': device_add
Aug 15 09:06:42 fatdrive kernel: [249351.552644] PM: Adding info for No Bus:6:2:0:0
Aug 15 09:06:42 fatdrive kernel: [249351.552687] device: '6:2:0:0': device_add
Aug 15 09:06:42 fatdrive kernel: [249351.552770] PM: Adding info for No Bus:6:2:0:0
Aug 15 09:06:42 fatdrive kernel: [249351.552964] sd 6:2:0:0: [sdt] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Aug 15 09:06:42 fatdrive kernel: [249351.553048] sd 6:2:0:0: [sdt] 4096-byte physical blocks
Aug 15 09:06:42 fatdrive kernel: [249351.553106] sd 6:2:0:0: [sdt] Write Protect is off
Aug 15 09:06:42 fatdrive kernel: [249351.553142] sd 6:2:0:0: [sdt] Mode Sense: 00 3a 00 00
Aug 15 09:06:42 fatdrive kernel: [249351.553189] sd 6:2:0:0: [sdt] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 15 09:06:42 fatdrive kernel: [249351.553240] device: '65:48': device_add
Aug 15 09:06:42 fatdrive kernel: [249351.553281] PM: Adding info for No Bus:65:48
Aug 15 09:06:42 fatdrive kernel: [249351.553326] device: 'sdt': device_add
Aug 15 09:06:42 fatdrive kernel: [249351.553616] PM: Adding info for No Bus:sdt
Aug 15 09:06:42 fatdrive kernel: [249351.604494]  sdt: sdt1
Aug 15 09:06:42 fatdrive kernel: [249351.604570] device: 'sdt1': device_add
Aug 15 09:06:42 fatdrive kernel: [249351.604669] PM: Adding info for No Bus:sdt1
Aug 15 09:06:42 fatdrive kernel: [249351.604850] sd 6:2:0:0: [sdt] Attached SCSI disk

Errors just before Trace 2:
Aug 14 22:53:10 fatdrive kernel: [212610.847218] btrfs: bdev /dev/sdi1 errs: wr 47951, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:12 fatdrive kernel: [212612.792278] btrfs: bdev /dev/sdi1 errs: wr 47952, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:13 fatdrive kernel: [212613.971971] btrfs: bdev /dev/sdi1 errs: wr 47953, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:15 fatdrive kernel: [212616.034807] btrfs: bdev /dev/sdi1 errs: wr 47954, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:17 fatdrive kernel: [212617.394792] btrfs: bdev /dev/sdi1 errs: wr 47955, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:17 fatdrive kernel: [212617.750894] btrfs: bdev /dev/sdi1 errs: wr 47956, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:20 fatdrive kernel: [212620.097584] btrfs: bdev /dev/sdi1 errs: wr 47957, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:20 fatdrive kernel: [212620.207879] btrfs: bdev /dev/sdi1 errs: wr 47958, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:20 fatdrive kernel: [212620.319427] btrfs: bdev /dev/sdi1 errs: wr 47959, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:20 fatdrive kernel: [212620.434302] btrfs: bdev /dev/sdi1 errs: wr 47960, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:20 fatdrive kernel: [212620.552811] btrfs: bdev /dev/sdi1 errs: wr 47961, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:20 fatdrive kernel: [212620.671318] btrfs: bdev /dev/sdi1 errs: wr 47962, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:20 fatdrive kernel: [212620.789093] btrfs: bdev /dev/sdi1 errs: wr 47963, rd 2, flush 746, corrupt 0, gen 0
Aug 14 22:53:22 fatdrive kernel: [212622.739422] btrfs_dev_stat_print_on_error: 1 callbacks suppressed
Aug 14 22:53:22 fatdrive kernel: [212622.739426] btrfs: bdev /dev/sdi1 errs: wr 47964, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:22 fatdrive kernel: [212622.739553] lost page write due to I/O error on /dev/sdi1
Aug 14 22:53:22 fatdrive kernel: [212622.739554] btrfs: bdev /dev/sdi1 errs: wr 47965, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:22 fatdrive kernel: [212622.739560] lost page write due to I/O error on /dev/sdi1
Aug 14 22:53:22 fatdrive kernel: [212622.739561] btrfs: bdev /dev/sdi1 errs: wr 47966, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:22 fatdrive kernel: [212622.739566] lost page write due to I/O error on /dev/sdi1
Aug 14 22:53:22 fatdrive kernel: [212622.739567] btrfs: bdev /dev/sdi1 errs: wr 47967, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:22 fatdrive kernel: [212622.747046] btrfs: bdev /dev/sdi1 errs: wr 47968, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:22 fatdrive kernel: [212622.805999] btrfs: bdev /dev/sdi1 errs: wr 47969, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:22 fatdrive kernel: [212622.806433] btrfs: bdev /dev/sdi1 errs: wr 47970, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:22 fatdrive kernel: [212622.806858] btrfs: bdev /dev/sdi1 errs: wr 47971, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:22 fatdrive kernel: [212622.807203] btrfs: bdev /dev/sdi1 errs: wr 47972, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:22 fatdrive kernel: [212622.807731] btrfs: bdev /dev/sdi1 errs: wr 47973, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:27 fatdrive kernel: [212627.730730] btrfs_dev_stat_print_on_error: 5377 callbacks suppressed
Aug 14 22:53:27 fatdrive kernel: [212627.730734] btrfs: bdev /dev/sdi1 errs: wr 53351, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:27 fatdrive kernel: [212627.731044] btrfs: bdev /dev/sdi1 errs: wr 53352, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:27 fatdrive kernel: [212627.731596] btrfs: bdev /dev/sdi1 errs: wr 53353, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:27 fatdrive kernel: [212627.732116] btrfs: bdev /dev/sdi1 errs: wr 53354, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:27 fatdrive kernel: [212627.732427] btrfs: bdev /dev/sdi1 errs: wr 53355, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:27 fatdrive kernel: [212627.732887] btrfs: bdev /dev/sdi1 errs: wr 53356, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:27 fatdrive kernel: [212627.733431] btrfs: bdev /dev/sdi1 errs: wr 53357, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:27 fatdrive kernel: [212627.733899] btrfs: bdev /dev/sdi1 errs: wr 53358, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:27 fatdrive kernel: [212627.734196] btrfs: bdev /dev/sdi1 errs: wr 53359, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:27 fatdrive kernel: [212627.734682] btrfs: bdev /dev/sdi1 errs: wr 53360, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:32 fatdrive kernel: [212632.722288] btrfs_dev_stat_print_on_error: 10895 callbacks suppressed
Aug 14 22:53:32 fatdrive kernel: [212632.722292] btrfs: bdev /dev/sdi1 errs: wr 64256, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:32 fatdrive kernel: [212632.722620] btrfs: bdev /dev/sdi1 errs: wr 64257, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:32 fatdrive kernel: [212632.723100] btrfs: bdev /dev/sdi1 errs: wr 64258, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:32 fatdrive kernel: [212632.723533] btrfs: bdev /dev/sdi1 errs: wr 64259, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:32 fatdrive kernel: [212632.723874] btrfs: bdev /dev/sdi1 errs: wr 64260, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:32 fatdrive kernel: [212632.724273] btrfs: bdev /dev/sdi1 errs: wr 64261, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:32 fatdrive kernel: [212632.724738] btrfs: bdev /dev/sdi1 errs: wr 64262, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:32 fatdrive kernel: [212632.725175] btrfs: bdev /dev/sdi1 errs: wr 64263, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:32 fatdrive kernel: [212632.725435] btrfs: bdev /dev/sdi1 errs: wr 64264, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:32 fatdrive kernel: [212632.725840] btrfs: bdev /dev/sdi1 errs: wr 64265, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:37 fatdrive kernel: [212637.713567] btrfs_dev_stat_print_on_error: 11164 callbacks suppressed
Aug 14 22:53:37 fatdrive kernel: [212637.713571] btrfs: bdev /dev/sdi1 errs: wr 75430, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:37 fatdrive kernel: [212637.713889] btrfs: bdev /dev/sdi1 errs: wr 75431, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:37 fatdrive kernel: [212637.714218] btrfs: bdev /dev/sdi1 errs: wr 75432, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:37 fatdrive kernel: [212637.714732] btrfs: bdev /dev/sdi1 errs: wr 75433, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:37 fatdrive kernel: [212637.715002] btrfs: bdev /dev/sdi1 errs: wr 75434, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:37 fatdrive kernel: [212637.715333] btrfs: bdev /dev/sdi1 errs: wr 75435, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:37 fatdrive kernel: [212637.715970] btrfs: bdev /dev/sdi1 errs: wr 75436, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:37 fatdrive kernel: [212637.716262] btrfs: bdev /dev/sdi1 errs: wr 75437, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:37 fatdrive kernel: [212637.716814] btrfs: bdev /dev/sdi1 errs: wr 75438, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:37 fatdrive kernel: [212637.717074] btrfs: bdev /dev/sdi1 errs: wr 75439, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:42 fatdrive kernel: [212642.712483] btrfs_dev_stat_print_on_error: 8032 callbacks suppressed
Aug 14 22:53:42 fatdrive kernel: [212642.712487] btrfs: bdev /dev/sdi1 errs: wr 83472, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:42 fatdrive kernel: [212642.715477] btrfs: bdev /dev/sdi1 errs: wr 83473, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:42 fatdrive kernel: [212642.716265] btrfs: bdev /dev/sdi1 errs: wr 83474, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:42 fatdrive kernel: [212642.719209] btrfs: bdev /dev/sdi1 errs: wr 83475, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:42 fatdrive kernel: [212642.729932] btrfs: bdev /dev/sdi1 errs: wr 83476, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:42 fatdrive kernel: [212642.732999] btrfs: bdev /dev/sdi1 errs: wr 83477, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:42 fatdrive kernel: [212642.741279] btrfs: bdev /dev/sdi1 errs: wr 83478, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:42 fatdrive kernel: [212642.742089] btrfs: bdev /dev/sdi1 errs: wr 83479, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:42 fatdrive kernel: [212642.746861] btrfs: bdev /dev/sdi1 errs: wr 83480, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:42 fatdrive kernel: [212642.755929] btrfs: bdev /dev/sdi1 errs: wr 83481, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:47 fatdrive kernel: [212647.706164] btrfs_dev_stat_print_on_error: 10874 callbacks suppressed
Aug 14 22:53:47 fatdrive kernel: [212647.706168] btrfs: bdev /dev/sdi1 errs: wr 94356, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:47 fatdrive kernel: [212647.706469] btrfs: bdev /dev/sdi1 errs: wr 94357, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:47 fatdrive kernel: [212647.706777] btrfs: bdev /dev/sdi1 errs: wr 94358, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:47 fatdrive kernel: [212647.707071] btrfs: bdev /dev/sdi1 errs: wr 94359, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:47 fatdrive kernel: [212647.707364] btrfs: bdev /dev/sdi1 errs: wr 94360, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:47 fatdrive kernel: [212647.707512] btrfs: bdev /dev/sdi1 errs: wr 94361, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:47 fatdrive kernel: [212647.707735] btrfs: bdev /dev/sdi1 errs: wr 94362, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:47 fatdrive kernel: [212647.708001] btrfs: bdev /dev/sdi1 errs: wr 94363, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:47 fatdrive kernel: [212647.708208] btrfs: bdev /dev/sdi1 errs: wr 94364, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:47 fatdrive kernel: [212647.708450] btrfs: bdev /dev/sdi1 errs: wr 94365, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:52 fatdrive kernel: [212652.697780] btrfs_dev_stat_print_on_error: 11434 callbacks suppressed
Aug 14 22:53:52 fatdrive kernel: [212652.697785] btrfs: bdev /dev/sdi1 errs: wr 105800, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:52 fatdrive kernel: [212652.698099] btrfs: bdev /dev/sdi1 errs: wr 105801, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:52 fatdrive kernel: [212652.698417] btrfs: bdev /dev/sdi1 errs: wr 105802, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:52 fatdrive kernel: [212652.698914] btrfs: bdev /dev/sdi1 errs: wr 105803, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:52 fatdrive kernel: [212652.699219] btrfs: bdev /dev/sdi1 errs: wr 105804, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:52 fatdrive kernel: [212652.699624] btrfs: bdev /dev/sdi1 errs: wr 105805, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:52 fatdrive kernel: [212652.699864] btrfs: bdev /dev/sdi1 errs: wr 105806, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:52 fatdrive kernel: [212652.700237] btrfs: bdev /dev/sdi1 errs: wr 105807, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:52 fatdrive kernel: [212652.700709] btrfs: bdev /dev/sdi1 errs: wr 105808, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:52 fatdrive kernel: [212652.701164] btrfs: bdev /dev/sdi1 errs: wr 105809, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:57 fatdrive kernel: [212657.689078] btrfs_dev_stat_print_on_error: 6089 callbacks suppressed
Aug 14 22:53:57 fatdrive kernel: [212657.689082] btrfs: bdev /dev/sdi1 errs: wr 111899, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:57 fatdrive kernel: [212657.689392] btrfs: bdev /dev/sdi1 errs: wr 111900, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:57 fatdrive kernel: [212657.689707] btrfs: bdev /dev/sdi1 errs: wr 111901, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:57 fatdrive kernel: [212657.690047] btrfs: bdev /dev/sdi1 errs: wr 111902, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:57 fatdrive kernel: [212657.690310] btrfs: bdev /dev/sdi1 errs: wr 111903, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:57 fatdrive kernel: [212657.690643] btrfs: bdev /dev/sdi1 errs: wr 111904, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:57 fatdrive kernel: [212657.690923] btrfs: bdev /dev/sdi1 errs: wr 111905, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:57 fatdrive kernel: [212657.691213] btrfs: bdev /dev/sdi1 errs: wr 111906, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:57 fatdrive kernel: [212657.691531] btrfs: bdev /dev/sdi1 errs: wr 111907, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:53:57 fatdrive kernel: [212657.691858] btrfs: bdev /dev/sdi1 errs: wr 111908, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:02 fatdrive kernel: [212662.680378] btrfs_dev_stat_print_on_error: 5318 callbacks suppressed
Aug 14 22:54:02 fatdrive kernel: [212662.680382] btrfs: bdev /dev/sdi1 errs: wr 117227, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:02 fatdrive kernel: [212662.680694] btrfs: bdev /dev/sdi1 errs: wr 117228, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:02 fatdrive kernel: [212662.681013] btrfs: bdev /dev/sdi1 errs: wr 117229, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:02 fatdrive kernel: [212662.686549] btrfs: bdev /dev/sdi1 errs: wr 117230, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:02 fatdrive kernel: [212662.687039] btrfs: bdev /dev/sdi1 errs: wr 117231, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:02 fatdrive kernel: [212662.687317] btrfs: bdev /dev/sdi1 errs: wr 117232, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:02 fatdrive kernel: [212662.687657] btrfs: bdev /dev/sdi1 errs: wr 117233, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:02 fatdrive kernel: [212662.687961] btrfs: bdev /dev/sdi1 errs: wr 117234, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:02 fatdrive kernel: [212662.688252] btrfs: bdev /dev/sdi1 errs: wr 117235, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:02 fatdrive kernel: [212662.688595] btrfs: bdev /dev/sdi1 errs: wr 117236, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:07 fatdrive kernel: [212667.735552] btrfs_dev_stat_print_on_error: 5708 callbacks suppressed
Aug 14 22:54:07 fatdrive kernel: [212667.735556] btrfs: bdev /dev/sdi1 errs: wr 122945, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:07 fatdrive kernel: [212667.736134] btrfs: bdev /dev/sdi1 errs: wr 122946, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:07 fatdrive kernel: [212667.736666] btrfs: bdev /dev/sdi1 errs: wr 122947, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:07 fatdrive kernel: [212667.737161] btrfs: bdev /dev/sdi1 errs: wr 122948, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:07 fatdrive kernel: [212667.737501] btrfs: bdev /dev/sdi1 errs: wr 122949, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:07 fatdrive kernel: [212667.737863] btrfs: bdev /dev/sdi1 errs: wr 122950, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:07 fatdrive kernel: [212667.738381] btrfs: bdev /dev/sdi1 errs: wr 122951, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:07 fatdrive kernel: [212667.738855] btrfs: bdev /dev/sdi1 errs: wr 122952, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:07 fatdrive kernel: [212667.739400] btrfs: bdev /dev/sdi1 errs: wr 122953, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:07 fatdrive kernel: [212667.739827] btrfs: bdev /dev/sdi1 errs: wr 122954, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:12 fatdrive kernel: [212672.782651] btrfs_dev_stat_print_on_error: 5869 callbacks suppressed
Aug 14 22:54:12 fatdrive kernel: [212672.782655] btrfs: bdev /dev/sdi1 errs: wr 128824, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:12 fatdrive kernel: [212672.783032] btrfs: bdev /dev/sdi1 errs: wr 128825, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:12 fatdrive kernel: [212672.783414] btrfs: bdev /dev/sdi1 errs: wr 128826, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:12 fatdrive kernel: [212672.783811] btrfs: bdev /dev/sdi1 errs: wr 128827, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:12 fatdrive kernel: [212672.784312] btrfs: bdev /dev/sdi1 errs: wr 128828, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:12 fatdrive kernel: [212672.784810] btrfs: bdev /dev/sdi1 errs: wr 128829, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:12 fatdrive kernel: [212672.785360] btrfs: bdev /dev/sdi1 errs: wr 128830, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:12 fatdrive kernel: [212672.785941] btrfs: bdev /dev/sdi1 errs: wr 128831, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:12 fatdrive kernel: [212672.786413] btrfs: bdev /dev/sdi1 errs: wr 128832, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:12 fatdrive kernel: [212672.786851] btrfs: bdev /dev/sdi1 errs: wr 128833, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:15 fatdrive kernel: [212675.697218] btrfs bad tree block start 5983547812986772286 517474525184
Aug 14 22:54:15 fatdrive kernel: [212675.707212] btrfs read error corrected: ino 1 off 517474525184 (dev /dev/sds1 sector 517822800)
Aug 14 22:54:17 fatdrive kernel: [212677.774188] btrfs_dev_stat_print_on_error: 2273 callbacks suppressed
Aug 14 22:54:17 fatdrive kernel: [212677.774192] btrfs: bdev /dev/sdi1 errs: wr 131106, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:17 fatdrive kernel: [212677.774508] btrfs: bdev /dev/sdi1 errs: wr 131107, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:17 fatdrive kernel: [212677.775028] btrfs: bdev /dev/sdi1 errs: wr 131108, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:17 fatdrive kernel: [212677.775365] btrfs: bdev /dev/sdi1 errs: wr 131109, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:17 fatdrive kernel: [212677.775732] btrfs: bdev /dev/sdi1 errs: wr 131110, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:17 fatdrive kernel: [212677.776007] btrfs: bdev /dev/sdi1 errs: wr 131111, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:17 fatdrive kernel: [212677.776667] btrfs: bdev /dev/sdi1 errs: wr 131112, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:17 fatdrive kernel: [212677.776968] btrfs: bdev /dev/sdi1 errs: wr 131113, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:17 fatdrive kernel: [212677.777443] btrfs: bdev /dev/sdi1 errs: wr 131114, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:17 fatdrive kernel: [212677.777953] btrfs: bdev /dev/sdi1 errs: wr 131115, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:22 fatdrive kernel: [212682.765719] btrfs_dev_stat_print_on_error: 5422 callbacks suppressed
Aug 14 22:54:22 fatdrive kernel: [212682.765723] btrfs: bdev /dev/sdi1 errs: wr 136538, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:22 fatdrive kernel: [212682.766036] btrfs: bdev /dev/sdi1 errs: wr 136539, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:22 fatdrive kernel: [212682.766352] btrfs: bdev /dev/sdi1 errs: wr 136540, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:22 fatdrive kernel: [212682.767023] btrfs: bdev /dev/sdi1 errs: wr 136541, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:22 fatdrive kernel: [212682.767328] btrfs: bdev /dev/sdi1 errs: wr 136542, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:22 fatdrive kernel: [212682.767656] btrfs: bdev /dev/sdi1 errs: wr 136543, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:22 fatdrive kernel: [212682.768240] btrfs: bdev /dev/sdi1 errs: wr 136544, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:22 fatdrive kernel: [212682.768526] btrfs: bdev /dev/sdi1 errs: wr 136545, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:22 fatdrive kernel: [212682.768774] btrfs: bdev /dev/sdi1 errs: wr 136546, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:22 fatdrive kernel: [212682.769002] btrfs: bdev /dev/sdi1 errs: wr 136547, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:27 fatdrive kernel: [212687.756842] btrfs_dev_stat_print_on_error: 5086 callbacks suppressed
Aug 14 22:54:27 fatdrive kernel: [212687.756846] btrfs: bdev /dev/sdi1 errs: wr 141634, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:27 fatdrive kernel: [212687.757274] btrfs: bdev /dev/sdi1 errs: wr 141635, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:27 fatdrive kernel: [212687.757688] btrfs: bdev /dev/sdi1 errs: wr 141636, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:27 fatdrive kernel: [212687.758077] btrfs: bdev /dev/sdi1 errs: wr 141637, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:27 fatdrive kernel: [212687.758400] btrfs: bdev /dev/sdi1 errs: wr 141638, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:27 fatdrive kernel: [212687.758711] btrfs: bdev /dev/sdi1 errs: wr 141639, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:27 fatdrive kernel: [212687.759068] btrfs: bdev /dev/sdi1 errs: wr 141640, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:27 fatdrive kernel: [212687.759373] btrfs: bdev /dev/sdi1 errs: wr 141641, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:27 fatdrive kernel: [212687.759776] btrfs: bdev /dev/sdi1 errs: wr 141642, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:27 fatdrive kernel: [212687.760038] btrfs: bdev /dev/sdi1 errs: wr 141643, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:32 fatdrive kernel: [212692.836535] btrfs_dev_stat_print_on_error: 5455 callbacks suppressed
Aug 14 22:54:32 fatdrive kernel: [212692.836539] btrfs: bdev /dev/sdi1 errs: wr 147099, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:32 fatdrive kernel: [212692.837041] btrfs: bdev /dev/sdi1 errs: wr 147100, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:32 fatdrive kernel: [212692.837333] btrfs: bdev /dev/sdi1 errs: wr 147101, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:32 fatdrive kernel: [212692.837738] btrfs: bdev /dev/sdi1 errs: wr 147102, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:32 fatdrive kernel: [212692.838142] btrfs: bdev /dev/sdi1 errs: wr 147103, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:32 fatdrive kernel: [212692.838415] btrfs: bdev /dev/sdi1 errs: wr 147104, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:32 fatdrive kernel: [212692.838791] btrfs: bdev /dev/sdi1 errs: wr 147105, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:32 fatdrive kernel: [212692.839068] btrfs: bdev /dev/sdi1 errs: wr 147106, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:32 fatdrive kernel: [212692.839466] btrfs: bdev /dev/sdi1 errs: wr 147107, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:32 fatdrive kernel: [212692.839775] btrfs: bdev /dev/sdi1 errs: wr 147108, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:37 fatdrive kernel: [212697.829283] btrfs_dev_stat_print_on_error: 5811 callbacks suppressed
Aug 14 22:54:37 fatdrive kernel: [212697.829287] btrfs: bdev /dev/sdi1 errs: wr 152920, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:37 fatdrive kernel: [212697.831778] btrfs: bdev /dev/sdi1 errs: wr 152921, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:37 fatdrive kernel: [212697.832550] btrfs: bdev /dev/sdi1 errs: wr 152922, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:37 fatdrive kernel: [212697.832943] btrfs: bdev /dev/sdi1 errs: wr 152923, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:37 fatdrive kernel: [212697.833248] btrfs: bdev /dev/sdi1 errs: wr 152924, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:37 fatdrive kernel: [212697.846024] btrfs: bdev /dev/sdi1 errs: wr 152925, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:38 fatdrive kernel: [212697.943556] btrfs: bdev /dev/sdi1 errs: wr 152926, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:38 fatdrive kernel: [212697.943920] btrfs: bdev /dev/sdi1 errs: wr 152927, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:38 fatdrive kernel: [212697.944224] btrfs: bdev /dev/sdi1 errs: wr 152928, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:38 fatdrive kernel: [212697.944579] btrfs: bdev /dev/sdi1 errs: wr 152929, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:43 fatdrive kernel: [212702.906595] btrfs_dev_stat_print_on_error: 5668 callbacks suppressed
Aug 14 22:54:43 fatdrive kernel: [212702.906599] btrfs: bdev /dev/sdi1 errs: wr 158598, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:43 fatdrive kernel: [212702.907036] btrfs: bdev /dev/sdi1 errs: wr 158599, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:43 fatdrive kernel: [212702.907356] btrfs: bdev /dev/sdi1 errs: wr 158600, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:43 fatdrive kernel: [212702.907839] btrfs: bdev /dev/sdi1 errs: wr 158601, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:43 fatdrive kernel: [212702.908197] btrfs: bdev /dev/sdi1 errs: wr 158602, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:43 fatdrive kernel: [212702.908521] btrfs: bdev /dev/sdi1 errs: wr 158603, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:43 fatdrive kernel: [212702.909051] btrfs: bdev /dev/sdi1 errs: wr 158604, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:43 fatdrive kernel: [212702.909444] btrfs: bdev /dev/sdi1 errs: wr 158605, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:43 fatdrive kernel: [212702.909766] btrfs: bdev /dev/sdi1 errs: wr 158606, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:43 fatdrive kernel: [212702.910112] btrfs: bdev /dev/sdi1 errs: wr 158607, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:49 fatdrive kernel: [212709.077118] btrfs_dev_stat_print_on_error: 3072 callbacks suppressed
Aug 14 22:54:49 fatdrive kernel: [212709.077122] btrfs: bdev /dev/sdi1 errs: wr 161680, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:50 fatdrive kernel: [212710.756254] btrfs: bdev /dev/sdi1 errs: wr 161681, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:50 fatdrive kernel: [212710.757993] btrfs: bdev /dev/sdi1 errs: wr 161682, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:50 fatdrive kernel: [212710.761338] btrfs: bdev /dev/sdi1 errs: wr 161683, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:50 fatdrive kernel: [212710.770254] btrfs: bdev /dev/sdi1 errs: wr 161684, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:50 fatdrive kernel: [212710.771254] btrfs: bdev /dev/sdi1 errs: wr 161685, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:50 fatdrive kernel: [212710.771550] btrfs: bdev /dev/sdi1 errs: wr 161686, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:50 fatdrive kernel: [212710.771810] btrfs: bdev /dev/sdi1 errs: wr 161687, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:50 fatdrive kernel: [212710.772112] btrfs: bdev /dev/sdi1 errs: wr 161688, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:50 fatdrive kernel: [212710.772476] btrfs: bdev /dev/sdi1 errs: wr 161689, rd 2, flush 747, corrupt 0, gen 0
Aug 14 22:54:53 fatdrive kernel: [212713.573300] lost page write due to I/O error on /dev/sdi1
Aug 14 22:54:53 fatdrive kernel: [212713.573309] lost page write due to I/O error on /dev/sdi1
Aug 14 22:54:53 fatdrive kernel: [212713.573314] lost page write due to I/O error on /dev/sdi1
Aug 14 22:54:55 fatdrive kernel: [212715.746873] btrfs_dev_stat_print_on_error: 7930 callbacks suppressed
Aug 14 22:54:55 fatdrive kernel: [212715.746877] btrfs: bdev /dev/sdi1 errs: wr 169619, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:54:55 fatdrive kernel: [212715.747180] btrfs: bdev /dev/sdi1 errs: wr 169620, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:54:55 fatdrive kernel: [212715.747456] btrfs: bdev /dev/sdi1 errs: wr 169621, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:54:55 fatdrive kernel: [212715.747826] btrfs: bdev /dev/sdi1 errs: wr 169622, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:54:55 fatdrive kernel: [212715.748069] btrfs: bdev /dev/sdi1 errs: wr 169623, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:54:55 fatdrive kernel: [212715.748316] btrfs: bdev /dev/sdi1 errs: wr 169624, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:54:55 fatdrive kernel: [212715.748610] btrfs: bdev /dev/sdi1 errs: wr 169625, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:54:55 fatdrive kernel: [212715.748876] btrfs: bdev /dev/sdi1 errs: wr 169626, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:54:55 fatdrive kernel: [212715.749142] btrfs: bdev /dev/sdi1 errs: wr 169627, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:54:55 fatdrive kernel: [212715.749297] btrfs: bdev /dev/sdi1 errs: wr 169628, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:00 fatdrive kernel: [212720.738342] btrfs_dev_stat_print_on_error: 9085 callbacks suppressed
Aug 14 22:55:00 fatdrive kernel: [212720.738346] btrfs: bdev /dev/sdi1 errs: wr 178714, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:00 fatdrive kernel: [212720.738652] btrfs: bdev /dev/sdi1 errs: wr 178715, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:00 fatdrive kernel: [212720.738985] btrfs: bdev /dev/sdi1 errs: wr 178716, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:00 fatdrive kernel: [212720.739318] btrfs: bdev /dev/sdi1 errs: wr 178717, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:00 fatdrive kernel: [212720.739798] btrfs: bdev /dev/sdi1 errs: wr 178718, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:00 fatdrive kernel: [212720.740124] btrfs: bdev /dev/sdi1 errs: wr 178719, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:00 fatdrive kernel: [212720.740698] btrfs: bdev /dev/sdi1 errs: wr 178720, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:00 fatdrive kernel: [212720.741021] btrfs: bdev /dev/sdi1 errs: wr 178721, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:00 fatdrive kernel: [212720.741301] btrfs: bdev /dev/sdi1 errs: wr 178722, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:00 fatdrive kernel: [212720.741563] btrfs: bdev /dev/sdi1 errs: wr 178723, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:05 fatdrive kernel: [212725.730389] btrfs_dev_stat_print_on_error: 6137 callbacks suppressed
Aug 14 22:55:05 fatdrive kernel: [212725.730394] btrfs: bdev /dev/sdi1 errs: wr 184861, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:05 fatdrive kernel: [212725.735705] btrfs: bdev /dev/sdi1 errs: wr 184862, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:05 fatdrive kernel: [212725.741750] btrfs: bdev /dev/sdi1 errs: wr 184863, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:05 fatdrive kernel: [212725.751057] btrfs: bdev /dev/sdi1 errs: wr 184864, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:05 fatdrive kernel: [212725.754723] btrfs: bdev /dev/sdi1 errs: wr 184865, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:05 fatdrive kernel: [212725.762294] btrfs: bdev /dev/sdi1 errs: wr 184866, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:05 fatdrive kernel: [212725.770900] btrfs: bdev /dev/sdi1 errs: wr 184867, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:05 fatdrive kernel: [212725.778115] btrfs: bdev /dev/sdi1 errs: wr 184868, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:05 fatdrive kernel: [212725.789370] btrfs: bdev /dev/sdi1 errs: wr 184869, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:05 fatdrive kernel: [212725.795840] btrfs: bdev /dev/sdi1 errs: wr 184870, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:10 fatdrive kernel: [212730.726957] btrfs_dev_stat_print_on_error: 7389 callbacks suppressed
Aug 14 22:55:10 fatdrive kernel: [212730.726961] btrfs: bdev /dev/sdi1 errs: wr 192260, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:10 fatdrive kernel: [212730.727572] btrfs: bdev /dev/sdi1 errs: wr 192261, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:10 fatdrive kernel: [212730.728138] btrfs: bdev /dev/sdi1 errs: wr 192262, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:10 fatdrive kernel: [212730.728384] btrfs: bdev /dev/sdi1 errs: wr 192263, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:10 fatdrive kernel: [212730.728968] btrfs: bdev /dev/sdi1 errs: wr 192264, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:10 fatdrive kernel: [212730.729293] btrfs: bdev /dev/sdi1 errs: wr 192265, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:10 fatdrive kernel: [212730.729885] btrfs: bdev /dev/sdi1 errs: wr 192266, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:10 fatdrive kernel: [212730.730475] btrfs: bdev /dev/sdi1 errs: wr 192267, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:10 fatdrive kernel: [212730.731074] btrfs: bdev /dev/sdi1 errs: wr 192268, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:10 fatdrive kernel: [212730.731664] btrfs: bdev /dev/sdi1 errs: wr 192269, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:15 fatdrive kernel: [212735.718328] btrfs_dev_stat_print_on_error: 8562 callbacks suppressed
Aug 14 22:55:15 fatdrive kernel: [212735.718332] btrfs: bdev /dev/sdi1 errs: wr 200832, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:15 fatdrive kernel: [212735.718689] btrfs: bdev /dev/sdi1 errs: wr 200833, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:15 fatdrive kernel: [212735.719004] btrfs: bdev /dev/sdi1 errs: wr 200834, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:15 fatdrive kernel: [212735.719298] btrfs: bdev /dev/sdi1 errs: wr 200835, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:15 fatdrive kernel: [212735.719651] btrfs: bdev /dev/sdi1 errs: wr 200836, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:15 fatdrive kernel: [212735.720005] btrfs: bdev /dev/sdi1 errs: wr 200837, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:15 fatdrive kernel: [212735.720338] btrfs: bdev /dev/sdi1 errs: wr 200838, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:15 fatdrive kernel: [212735.720727] btrfs: bdev /dev/sdi1 errs: wr 200839, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:15 fatdrive kernel: [212735.721086] btrfs: bdev /dev/sdi1 errs: wr 200840, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:15 fatdrive kernel: [212735.721363] btrfs: bdev /dev/sdi1 errs: wr 200841, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:20 fatdrive kernel: [212740.709729] btrfs_dev_stat_print_on_error: 8114 callbacks suppressed
Aug 14 22:55:20 fatdrive kernel: [212740.709733] btrfs: bdev /dev/sdi1 errs: wr 208956, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:20 fatdrive kernel: [212740.709989] btrfs: bdev /dev/sdi1 errs: wr 208957, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:20 fatdrive kernel: [212740.710259] btrfs: bdev /dev/sdi1 errs: wr 208958, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:20 fatdrive kernel: [212740.710875] btrfs: bdev /dev/sdi1 errs: wr 208959, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:20 fatdrive kernel: [212740.711286] btrfs: bdev /dev/sdi1 errs: wr 208960, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:20 fatdrive kernel: [212740.711725] btrfs: bdev /dev/sdi1 errs: wr 208961, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:20 fatdrive kernel: [212740.712137] btrfs: bdev /dev/sdi1 errs: wr 208962, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:20 fatdrive kernel: [212740.712691] btrfs: bdev /dev/sdi1 errs: wr 208963, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:20 fatdrive kernel: [212740.713200] btrfs: bdev /dev/sdi1 errs: wr 208964, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:20 fatdrive kernel: [212740.713670] btrfs: bdev /dev/sdi1 errs: wr 208965, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:25 fatdrive kernel: [212745.702768] btrfs_dev_stat_print_on_error: 6395 callbacks suppressed
Aug 14 22:55:25 fatdrive kernel: [212745.702772] btrfs: bdev /dev/sdi1 errs: wr 215361, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:25 fatdrive kernel: [212745.703192] btrfs: bdev /dev/sdi1 errs: wr 215362, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:25 fatdrive kernel: [212745.718490] btrfs: bdev /dev/sdi1 errs: wr 215363, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:25 fatdrive kernel: [212745.726657] btrfs: bdev /dev/sdi1 errs: wr 215364, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:25 fatdrive kernel: [212745.730508] btrfs: bdev /dev/sdi1 errs: wr 215365, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:25 fatdrive kernel: [212745.741708] btrfs: bdev /dev/sdi1 errs: wr 215366, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:25 fatdrive kernel: [212745.742061] btrfs: bdev /dev/sdi1 errs: wr 215367, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:25 fatdrive kernel: [212745.758688] btrfs: bdev /dev/sdi1 errs: wr 215368, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:25 fatdrive kernel: [212745.759611] btrfs: bdev /dev/sdi1 errs: wr 215369, rd 2, flush 748, corrupt 0, gen 0
Aug 14 22:55:25 fatdrive kernel: [212745.759980] btrfs: bdev /dev/sdi1 errs: wr 215370, rd 2, flush 748, corrupt 0, gen 0



Drives after reseating (Note that /dev/sdi has been replaced with /dev/sdt):
fatdrive ~ # lsscsi
[0:0:0:0]    disk    ATA      WDC WD5000AAKS-0 12.0  /dev/sda 
[1:0:0:0]    disk    ATA      WDC WD20EADS-00R 01.0  /dev/sdb 
[2:0:0:0]    disk    ATA      Hitachi HDS72202 JKAO  /dev/sdc 
[3:0:0:0]    disk    ATA      Hitachi HDS72202 JKAO  /dev/sdd 
[4:0:0:0]    disk    ATA      Hitachi HDS72202 JKAO  /dev/sde 
[5:0:0:0]    disk    ATA      Hitachi HDS72202 JKAO  /dev/sdf 
[6:0:0:0]    disk    ATA      SAMSUNG HD204UI  1AQ1  /dev/sdg 
[6:1:0:0]    disk    ATA      WDC WD10EACS-00C 01.0  /dev/sdh 
[6:2:0:0]    disk    ATA      ST3000DM001-9YN1 CC9D  /dev/sdt 
[6:3:0:0]    disk    ATA      ST3000DM001-9YN1 CC9D  /dev/sds 
[7:0:0:0]    disk    ATA      SAMSUNG HD204UI  1AQ1  /dev/sdj 
[8:0:0:0]    disk    ATA      WDC WD20EADS-00R 01.0  /dev/sdk 
[9:0:0:0]    disk    ATA      Hitachi HDS5C302 ML6O  /dev/sdl 
[10:0:0:0]   disk    ATA      ST3000DM001-9YN1 CC9D  /dev/sdm 
[11:0:0:0]   disk    ATA      SAMSUNG HD204UI  1AQ1  /dev/sdn 
[12:0:0:0]   disk    ATA      Hitachi HDS72101 GKAO  /dev/sdo 
[13:0:0:0]   disk    ATA      ST2000DL003-9VT1 CC3C  /dev/sdp 
[14:0:0:0]   disk    ATA      WL2000GSA3272    01.0  /dev/sdq 
[15:0:0:0]   disk    ATA      WDC WD20EADS-00R 01.0  /dev/sdr 

Hung rsync:
fatdrive ~ # lsof | grep mnt/data
rsync      5425            root  cwd       DIR               0,28        672        256 /mnt/data
fatdrive ~ # kill 5425
fatdrive ~ # lsof | grep mnt/data
rsync      5425            root  cwd       DIR               0,28        672        256 /mnt/data

BTRFS output prior to failure:
fatdrive ~ # btrfs fi show
Label: 'data'  uuid: 8ff3cd3b-e771-4a3d-bc80-6aa88bbf3d53
	Total devices 7 FS bytes used 6.41TB
	devid    2 size 2.73TB used 1.38TB path /dev/sds1
	devid    6 size 1.82TB used 1.18TB path /dev/sdn1
	devid    3 size 2.73TB used 1.38TB path /dev/sdm1
	devid    4 size 1.82TB used 1.18TB path /dev/sdj1
	devid    1 size 2.73TB used 1.38TB path /dev/sdi1
	devid    5 size 931.51GB used 931.51GB path /dev/sdh1
	devid    7 size 1.82TB used 1.18TB path /dev/sdg1

Btrfs Btrfs v0.19

BTRFS output after failure:
fatdrive ~ # btrfs fi show
Label: 'data'  uuid: 8ff3cd3b-e771-4a3d-bc80-6aa88bbf3d53
	Total devices 7 FS bytes used 10.92TB
	devid    2 size 2.73TB used 2.73TB path /dev/sds1
	devid    6 size 1.82TB used 1.82TB path /dev/sdn1
	devid    3 size 2.73TB used 2.73TB path /dev/sdm1
	devid    4 size 1.82TB used 1.82TB path /dev/sdj1
	devid    5 size 931.51GB used 931.51GB path /dev/sdh1
	devid    7 size 1.82TB used 1.82TB path /dev/sdg1
	*** Some devices missing

BTRFS output after drive reset (server still running):
atdrive ~ # btrfs fi show
Label: 'data'  uuid: 8ff3cd3b-e771-4a3d-bc80-6aa88bbf3d53
        Total devices 7 FS bytes used 11.95TB
        devid    1 size 2.73TB used 2.73TB path /dev/sdt1
        devid    2 size 2.73TB used 2.73TB path /dev/sds1
        devid    6 size 1.82TB used 1.82TB path /dev/sdn1
        devid    3 size 2.73TB used 2.73TB path /dev/sdm1
        devid    4 size 1.82TB used 1.82TB path /dev/sdj1
        devid    5 size 931.51GB used 931.51GB path /dev/sdh1
        devid    7 size 1.82TB used 1.82TB path /dev/sdg1

Scrub status after trace 3:
fatdrive ~ # btrfs scrub status /mnt/data
scrub status for 8ff3cd3b-e771-4a3d-bc80-6aa88bbf3d53
        scrub started at Wed Aug 15 10:03:40 2012, running for 381 seconds
        total bytes scrubbed: 0.00 with 0 errors

Mount output:
fatdrive ~ # mount
rootfs on / type rootfs (rw)
/dev/root on / type ext3 (rw,noatime,errors=continue,acl,barrier=1,data=writeback)
devtmpfs on /dev type devtmpfs (rw,relatime,size=3926964k,nr_inodes=981741,mode=755)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
tmpfs on /run type tmpfs (rw,nosuid,nodev,relatime,mode=755)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)
cgroup_root on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,relatime,size=10240k,mode=755)
openrc on /sys/fs/cgroup/openrc type cgroup (rw,nosuid,nodev,noexec,relatime,release_agent=/lib64/rc/sh/cgroup-release-agent.sh,name=openrc)
cpuset on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cpu on /sys/fs/cgroup/cpu type cgroup (rw,nosuid,nodev,noexec,relatime,cpu)
cpuacct on /sys/fs/cgroup/cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct)
freezer on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620)
shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime)
/dev/sda1 on /boot type ext2 (rw,noatime)
/dev/mapper/c-mylv on /home/data type xfs (rw)
/dev/sdk1 on /mnt/backup2 type ext3 (rw,acl)
/dev/sdb1 on /mnt/timemachine type ext3 (rw,acl)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,noexec,nosuid,nodev)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
nfsd on /proc/fs/nfsd type nfsd (rw,noexec,nosuid,nodev)
/dev/sdi1 on /mnt/tmp5 type btrfs (rw,recovery)
/dev/sdi1 on /mnt/data type btrfs (rw,data)

Uname:
fatdrive ~ # uname -a
Linux fatdrive 3.5.0-gentoo #2 SMP Wed Aug 8 17:51:10 CDT 2012 x86_64 AMD Athlon(tm) II X2 240 Processor AuthenticAMD GNU/Linux


lsmod Output:
fatdrive ~ # lsmod
Module                  Size  Used by
btrfs                 720493  1 
lzo_compress            2162  1 btrfs
lzo_decompress          2287  1 btrfs
zlib_deflate           21006  1 btrfs
crc32c                  1682  1 
libcrc32c               1091  1 btrfs
nfsd                  234892  13 
xfs                   801413  1 
exportfs                3736  2 xfs,nfsd
shpchp                 26860  0 
pci_hotplug            12483  1 shpchp
r8168                 233787  0 
k10temp                 3278  0 
kvm_amd                49947  0 
kvm                   377071  1 kvm_amd


I know I am missing something, not sure what it is.

Thank you in advance for letting me participate in this.  I am eager for btrfs to be stable.

I am going to leave the machine in this state for a bit (because the data is just a third backup).  So if you have some additional questions, I can try it.

Anthony Plack

