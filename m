Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:60359 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536Ab3CODy1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 23:54:27 -0400
Received: from [192.168.1.23] (unknown [192.168.1.23])
	by decaymodealpha.mooo.com (Postfix) with ESMTPSA id DAA5E19F2B
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 23:47:17 -0400 (EDT)
Message-ID: <514299C7.4060200@lolwut.org>
Date: Thu, 14 Mar 2013 23:47:19 -0400
From: Kyle <kyle@lolwut.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs bug reports?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Is the linux-btrfs list interested in receiving bug reports relating to 
btrfs?

If so, the following error occurred on a server of mine when copying a 
large amount of data to a linear md-RAID formatted as btrfs. The data 
transfer hung, and any attempt to kill or strace the copy process hung 
as well until the system was rebooted.

Mar 14 12:26:26 Galois kernel: [63516.728545] ------------[ cut here 
]------------
Mar 14 12:26:26 Galois kernel: [63516.728901] kernel BUG at 
/build/buildd/linux-3.0.0/fs/bio.c:1499!
Mar 14 12:26:26 Galois kernel: [63516.729259] invalid opcode: 0000 [#1] SMP
Mar 14 12:26:26 Galois kernel: [63516.729598] CPU 5
Mar 14 12:26:26 Galois kernel: [63516.729725] Modules linked in: btrfs 
libcrc32c vesafb lp parport ghes i7core_edac edac_core joydev hed zfs(P) 
zcommon(P) znvpair(P) zavl(P) zunicode(P) spl zlib_deflate raid10 
raid456 async_pq async_xor xor async_memcpy async_raid6_recov usbhid hid 
r8169 ahci libahci e1000e sata_sil24 sata_mv raid6_pq async_tx raid1 
raid0 multipath linear
Mar 14 12:26:26 Galois kernel: [63516.732121]
Mar 14 12:26:26 Galois kernel: [63516.732219] Pid: 19432, comm: 
btrfs-submit-0 Tainted: P            3.0.0-12-server #20-Ubuntu Intel 
Corporation S3420GP/S3420GP
Mar 14 12:26:26 Galois kernel: [63516.732964] RIP: 
0010:[<ffffffff811999df>]  [<ffffffff811999df>] bio_split+0x2bf/0x2d0
Mar 14 12:26:26 Galois kernel: [63516.733602] RSP: 
0018:ffff880166a07ae0  EFLAGS: 00010206
Mar 14 12:26:26 Galois kernel: [63516.733948] RAX: ffff8801d18d06c0 RBX: 
ffff88015c518840 RCX: 000000000001b008
Mar 14 12:26:26 Galois kernel: [63516.734377] RDX: ffff88001964ae00 RSI: 
0000000000015840 RDI: ffffffff8110bc75
Mar 14 12:26:26 Galois kernel: [63516.734807] RBP: ffff880166a07b30 R08: 
ffff8801dfd55840 R09: 0000000000000000
Mar 14 12:26:26 Galois kernel: [63516.735233] R10: 6db6db6db6db6db7 R11: 
0000000000000001 R12: 00000000000000cf
Mar 14 12:26:26 Galois kernel: [63516.735674] R13: ffff88001964ae00 R14: 
0000000000000001 R15: ffff8801d18d07f8
Mar 14 12:26:26 Galois kernel: [63516.736106] FS: 0000000000000000(0000) 
GS:ffff8801dfd40000(0000) knlGS:0000000000000000
Mar 14 12:26:26 Galois kernel: [63516.736611] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Mar 14 12:26:26 Galois kernel: [63516.736940] CR2: 00007faacbc44c10 CR3: 
0000000001c03000 CR4: 00000000000006e0
Mar 14 12:26:26 Galois kernel: [63516.737371] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Mar 14 12:26:26 Galois kernel: [63516.754008] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Mar 14 12:26:26 Galois kernel: [63516.770222] Process btrfs-submit-0 
(pid: 19432, threadinfo ffff880166a06000, task ffff8801d58f4560)
Mar 14 12:26:26 Galois kernel: [63516.786935] Stack:
Mar 14 12:26:26 Galois kernel: [63516.804304]  ffff8801377ab600 
ffff8801377ab300 ffff8801d18d06c0 5d50938fd1bb0000
Mar 14 12:26:26 Galois kernel: [63516.821891]  ffff8801377ab300 
ffff88015c518840 ffff88003ae62400 000000000001f000
Mar 14 12:26:26 Galois kernel: [63516.839238]  0000000000000001 
ffff8801d18d07f8 ffff880166a07ba0 ffffffffa0000631
Mar 14 12:26:26 Galois kernel: [63516.861232] Call Trace:
Mar 14 12:26:26 Galois kernel: [63516.879502] [<ffffffffa0000631>] 
linear_make_request+0x101/0x1a0 [linear]
Mar 14 12:26:26 Galois kernel: [63516.897760] [<ffffffff812dcbd6>] ? 
throtl_find_tg+0x46/0x60
Mar 14 12:26:26 Galois kernel: [63516.916713] [<ffffffff8149c266>] 
md_make_request+0xc6/0x200
Mar 14 12:26:26 Galois kernel: [63516.934542] [<ffffffff812cf972>] ? 
__make_request+0x242/0x350
Mar 14 12:26:26 Galois kernel: [63516.952345] [<ffffffff812ccb7a>] 
generic_make_request.part.51+0x24a/0x510
Mar 14 12:26:26 Galois kernel: [63516.971119] [<ffffffff8104e759>] ? 
finish_task_switch+0x49/0xf0
Mar 14 12:26:26 Galois kernel: [63516.989118] [<ffffffff812cce85>] 
generic_make_request+0x45/0x60
Mar 14 12:26:26 Galois kernel: [63517.007202] [<ffffffff812ccf27>] 
submit_bio+0x87/0x110
Mar 14 12:26:26 Galois kernel: [63517.025307] [<ffffffffa0360339>] 
run_scheduled_bios+0x249/0x4f0 [btrfs]
Mar 14 12:26:26 Galois kernel: [63517.043341] [<ffffffffa03605f5>] 
pending_bios_fn+0x15/0x20 [btrfs]
Mar 14 12:26:26 Galois kernel: [63517.060899] [<ffffffffa0367470>] 
worker_loop+0xa0/0x2b0 [btrfs]
Mar 14 12:26:26 Galois kernel: [63517.078911] [<ffffffffa03673d0>] ? 
check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
Mar 14 12:26:26 Galois kernel: [63517.096767] [<ffffffff81080c5c>] 
kthread+0x8c/0xa0
Mar 14 12:26:26 Galois kernel: [63517.115240] [<ffffffff81607d24>] 
kernel_thread_helper+0x4/0x10
Mar 14 12:26:26 Galois kernel: [63517.133290] [<ffffffff81080bd0>] ? 
flush_kthread_worker+0xa0/0xa0
Mar 14 12:26:26 Galois kernel: [63517.151008] [<ffffffff81607d20>] ? 
gs_change+0x13/0x13
Mar 14 12:26:26 Galois kernel: [63517.168925] Code: 48 89 da 49 83 c6 10 
8b 4d cc 48 8b 75 c0 ff d0 48 8b 55 b8 4c 89 f0 4c 29 f8 48 8b 44 02 f0 
48 85 c0 75 d8 e9 9f fd ff ff 0f 0b <0f> 0b 66 66 66 66 66 66 2e 0f 1f 
84 00 00 00 00 00 55 48 89 e5
Mar 14 12:26:26 Galois kernel: [63517.206492] RIP [<ffffffff811999df>] 
bio_split+0x2bf/0x2d0
Mar 14 12:26:26 Galois kernel: [63517.228056]  RSP <ffff880166a07ae0>
Mar 14 12:26:26 Galois kernel: [63517.291591] ---[ end trace 
eaefef2d5cf0d587 ]---


Mar 14 12:26:26 Galois kernel: [63517.313940] ------------[ cut here 
]------------
Mar 14 12:26:26 Galois kernel: [63517.335433] WARNING: at 
/build/buildd/linux-3.0.0/kernel/exit.c:910 do_exit+0x63/0x440()
Mar 14 12:26:26 Galois kernel: [63517.357450] Hardware name: S3420GP
Mar 14 12:26:26 Galois kernel: [63517.379124] Modules linked in: btrfs 
libcrc32c vesafb lp parport ghes i7core_edac edac_core joydev hed zfs(P) 
zcommon(P) znvpair(P) zavl(P) zunicode(P) spl zlib_deflate raid10 
raid456 async_pq async_xor xor async_memcpy async_raid6_recov usbhid hid 
r8169 ahci libahci e1000e sata_sil24 sata_mv raid6_pq async_tx raid1 
raid0 multipath linear
Mar 14 12:26:26 Galois kernel: [63517.440590] Pid: 19432, comm: 
btrfs-submit-0 Tainted: P      D     3.0.0-12-server #20-Ubuntu
Mar 14 12:26:27 Galois kernel: [63517.459238] Call Trace:
Mar 14 12:26:27 Galois kernel: [63517.478106] [<ffffffff8105e81f>] 
warn_slowpath_common+0x7f/0xc0
Mar 14 12:26:27 Galois kernel: [63517.496532] [<ffffffff8105e87a>] 
warn_slowpath_null+0x1a/0x20
Mar 14 12:26:27 Galois kernel: [63517.515281] [<ffffffff81062e53>] 
do_exit+0x63/0x440
Mar 14 12:26:27 Galois kernel: [63517.533439] [<ffffffff815ffcd0>] 
oops_end+0xb0/0xf0
Mar 14 12:26:27 Galois kernel: [63517.551267] [<ffffffff8100d8c8>] 
die+0x58/0x90
Mar 14 12:26:27 Galois kernel: [63517.569467] [<ffffffff815ff3b4>] 
do_trap+0xc4/0x170
Mar 14 12:26:27 Galois kernel: [63517.587237] [<ffffffff8100aee5>] 
do_invalid_op+0x95/0xb0
Mar 14 12:26:27 Galois kernel: [63517.605061] [<ffffffff811999df>] ? 
bio_split+0x2bf/0x2d0
Mar 14 12:26:27 Galois kernel: [63517.623081] [<ffffffff81152912>] ? 
kmem_cache_alloc+0x112/0x120
Mar 14 12:26:27 Galois kernel: [63517.640124] [<ffffffff81153301>] ? 
__kmalloc+0x31/0x160
Mar 14 12:26:27 Galois kernel: [63517.657129] [<ffffffff8110bc75>] ? 
mempool_kmalloc+0x15/0x20
Mar 14 12:26:27 Galois kernel: [63517.674837] [<ffffffff81607b9b>] 
invalid_op+0x1b/0x20
Mar 14 12:26:27 Galois kernel: [63517.692116] [<ffffffff8110bc75>] ? 
mempool_kmalloc+0x15/0x20
Mar 14 12:26:27 Galois kernel: [63517.709034] [<ffffffff811999df>] ? 
bio_split+0x2bf/0x2d0
Mar 14 12:26:27 Galois kernel: [63517.726306] [<ffffffffa0000631>] 
linear_make_request+0x101/0x1a0 [linear]
Mar 14 12:26:27 Galois kernel: [63517.743170] [<ffffffff812dcbd6>] ? 
throtl_find_tg+0x46/0x60
Mar 14 12:26:27 Galois kernel: [63517.759553] [<ffffffff8149c266>] 
md_make_request+0xc6/0x200
Mar 14 12:26:27 Galois kernel: [63517.776740] [<ffffffff812cf972>] ? 
__make_request+0x242/0x350
Mar 14 12:26:27 Galois kernel: [63517.793374] [<ffffffff812ccb7a>] 
generic_make_request.part.51+0x24a/0x510
Mar 14 12:26:27 Galois kernel: [63517.809645] [<ffffffff8104e759>] ? 
finish_task_switch+0x49/0xf0
Mar 14 12:26:27 Galois kernel: [63517.826530] [<ffffffff812cce85>] 
generic_make_request+0x45/0x60
Mar 14 12:26:27 Galois kernel: [63517.842933] [<ffffffff812ccf27>] 
submit_bio+0x87/0x110
Mar 14 12:26:27 Galois kernel: [63517.861244] [<ffffffffa0360339>] 
run_scheduled_bios+0x249/0x4f0 [btrfs]
Mar 14 12:26:27 Galois kernel: [63517.880055] [<ffffffffa03605f5>] 
pending_bios_fn+0x15/0x20 [btrfs]
Mar 14 12:26:27 Galois kernel: [63517.896625] [<ffffffffa0367470>] 
worker_loop+0xa0/0x2b0 [btrfs]
Mar 14 12:26:27 Galois kernel: [63517.913258] [<ffffffffa03673d0>] ? 
check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
Mar 14 12:26:27 Galois kernel: [63517.930543] [<ffffffff81080c5c>] 
kthread+0x8c/0xa0
Mar 14 12:26:27 Galois kernel: [63517.947081] [<ffffffff81607d24>] 
kernel_thread_helper+0x4/0x10
Mar 14 12:26:27 Galois kernel: [63517.963545] [<ffffffff81080bd0>] ? 
flush_kthread_worker+0xa0/0xa0
Mar 14 12:26:27 Galois kernel: [63517.981046] [<ffffffff81607d20>] ? 
gs_change+0x13/0x13
Mar 14 12:26:27 Galois kernel: [63517.997067] ---[ end trace 
eaefef2d5cf0d588 ]---


Regards,

Kyle
