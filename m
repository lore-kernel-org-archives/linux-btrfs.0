Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.yerf-it.com ([149.210.132.52]:32909 "EHLO shiba.yerf-it.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754161AbaBDTMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Feb 2014 14:12:32 -0500
Received: from [2001:980:5211:1:a58a:f5fc:625c:f0f]
	by shiba.yerf-it.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <remco@yerf-it.com>)
	id 1WAlQ6-0004CZ-Os
	for linux-btrfs@vger.kernel.org; Tue, 04 Feb 2014 20:12:30 +0100
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: hitting BUG_ON on troublesome FS
From: "Remco Hosman - Yerf-it.com" <remco@yerf-it.com>
In-Reply-To: <CCAC08D7-4639-40F4-85DD-459E6D795DAD@yerf-it.com>
Date: Tue, 4 Feb 2014 20:12:29 +0100
Message-Id: <EB8C2F58-BAA9-4612-981E-B7C784255604@yerf-it.com>
References: <CCAC08D7-4639-40F4-85DD-459E6D795DAD@yerf-it.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

to reply to my own thread:

i managed to empty the filesystem, but it still segfaults in the same way when i try to balance the last few blocks. a `btrfs bal start -dusage=0 /mountpoint` finishes, but leaves a few blocks allocated. when i skip the usage=0, it segfaults.

What can i do to provide useful information?

Remco


On 03 Feb 2014, at 21:51, Remco Hosman - Yerf-it.com <remco@yerf-it.com> wrote:

> FIrst, a bit of history of the filesystem:
> used to be 6 disks, now 5. partially raid1 / raid10. been migrating back and forth a few times.
> As some point, a balance would not complete and would end with 164 ENOSPC’ses, while there was plenty of unallocated space on each disk.
> 
> i scanned for extends larger then 1gig and found a few, so ran a recursive balance of the entire FS.
> 
> I deceided to empty the filesystem and format it.
> 
> i pulled most files off it some via btrfs send/receive, some via rsync. but 1 subvol wouldn’t send. i don’t remember the exact error, but it was that a extend could not be found on 1 of the disks.
> 
> with only a few 100gig of data left, i decided to balance some remaining empty space before doing a `btrfs dev del`, so have another disk to store more data on.
> but im hitting a snag, i hit a BUG_ON when doing a `btrfs bal start -dusage=2 /mountpoint` :
> 
> [ 3327.678329] btrfs: found 198 extents
> [ 3328.117274] btrfs: relocating block group 84473084968960 flags 17
> [ 3329.278521] btrfs: found 103 extents
> [ 3331.907931] btrfs: found 103 extents
> [ 3332.386172] btrfs: relocating block group 84466642518016 flags 17
> [ 3333.536595] btrfs: found 86 extents
> [ 3335.982967] btrfs: found 86 extents
> [ 3336.599555] btrfs (4746) used greatest stack depth: 2744 bytes left
> [ 3379.073464] btrfs: relocating block group 89878368419840 flags 17
> [ 3381.608948] btrfs: found 499 extents
> [ 3383.884696] ------------[ cut here ]------------
> [ 3383.884720] kernel BUG at fs/btrfs/relocation.c:3405!
> [ 3383.884731] invalid opcode: 0000 [#1] SMP 
> [ 3383.884742] Modules linked in:
> [ 3383.884753] CPU: 0 PID: 5663 Comm: btrfs Not tainted 3.13.0 #1
> [ 3383.884763] Hardware name: System manufacturer System Product Name/E45M1-I DELUXE, BIOS 0405 08/08/2012
> [ 3383.884778] task: ffff8802360eae80 ti: ffff88010dcaa000 task.ti: ffff88010dcaa000
> [ 3383.884790] RIP: 0010:[<ffffffff812f0bd5>]  [<ffffffff812f0bd5>] __add_tree_block+0x1c5/0x1e0
> [ 3383.884811] RSP: 0018:ffff88010dcaba38  EFLAGS: 00010202
> [ 3383.884821] RAX: 0000000000000001 RBX: ffff880039f18000 RCX: 00000000ffffffff
> [ 3383.884832] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [ 3383.884843] RBP: ffff88010dcaba90 R08: ffff88010dcab9f4 R09: ffff88010dcab930
> [ 3383.884854] R10: 0000000000000000 R11: 000000000000047f R12: 0000000000001000
> [ 3383.884865] R13: ffff88023489c630 R14: 0000000000000000 R15: 0000528d112e4000
> [ 3383.884876] FS:  00007f8e27e74880(0000) GS:ffff88023ec00000(0000) knlGS:0000000000000000
> [ 3383.884888] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 3383.884897] CR2: 00007f60d89f35a8 CR3: 00000001b5ada000 CR4: 00000000000007f0
> [ 3383.884907] Stack:
> [ 3383.884941]  ffff88010dcabb28 4000ffff812bde34 00a80000528d112e 0000000000000010
> [ 3383.885012]  0000000000001000 0000000000001000 0000000000000f3a ffff8802348d6990
> [ 3383.885082]  ffff88001cbf5a00 ffff880039f18000 00000000000000b8 ffff88010dcabb00
> [ 3383.885153] Call Trace:
> [ 3383.885192]  [<ffffffff812f1a54>] add_data_references+0x244/0x2e0
> [ 3383.885232]  [<ffffffff812f2a2b>] relocate_block_group+0x56b/0x640
> [ 3383.885272]  [<ffffffff812f2ca2>] btrfs_relocate_block_group+0x1a2/0x2f0
> [ 3383.885313]  [<ffffffff812cbcca>] btrfs_relocate_chunk.isra.27+0x6a/0x740
> [ 3383.885355]  [<ffffffff81281a31>] ? btrfs_set_path_blocking+0x31/0x70
> [ 3383.885432]  [<ffffffff81286816>] ? btrfs_search_slot+0x386/0x960
> [ 3383.885473]  [<ffffffff812c6f07>] ? free_extent_buffer+0x47/0xa0
> [ 3383.885513]  [<ffffffff812ceedb>] btrfs_balance+0x90b/0xea0
> [ 3383.885553]  [<ffffffff812d5ec2>] btrfs_ioctl_balance+0x162/0x520
> [ 3383.885592]  [<ffffffff812d9aed>] btrfs_ioctl+0xcbd/0x25c0
> [ 3383.885632]  [<ffffffff818c094c>] ? __do_page_fault+0x1dc/0x520
> [ 3383.885673]  [<ffffffff81136868>] do_vfs_ioctl+0x2c8/0x490
> [ 3383.885712]  [<ffffffff81136ab1>] SyS_ioctl+0x81/0xa0
> [ 3383.885752]  [<ffffffff818c4f5b>] tracesys+0xdd/0xe2
> [ 3383.885787] Code: ff 48 8b 4d a8 48 8d 75 b6 4c 89 ea 48 89 df e8 42 e7 ff ff 4c 89 ef 89 45 a8 e8 c7 0f f9 ff 8b 45 a8 e9 69 ff ff ff 85 c0 74 d6 <0f> 0b 66 0f 1f 84 00 00 00 00 00 b8 f4 ff ff ff e9 50 ff ff ff 
> [ 3383.886001] RIP  [<ffffffff812f0bd5>] __add_tree_block+0x1c5/0x1e0
> [ 3383.886042]  RSP <ffff88010dcaba38>
> [ 3383.886359] ---[ end trace 075209044ce10da3 ]---
> Anything i can do to resolve / debug the issue?
> 
> Remco--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

