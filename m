Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52165 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754847AbeFTTgD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 15:36:03 -0400
Date: Wed, 20 Jun 2018 21:33:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] Btrfs: fix file data corruptions due to lost
 dirty bits
Message-ID: <20180620193310.GG24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180620145612.1644763-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180620145612.1644763-1-clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 07:56:10AM -0700, Chris Mason wrote:
> We've been hunting the root cause of data crc errors here at FB for a while.
> We'd find one or two corrupted files, usually displaying crc errors without any
> corresponding IO errors from the storage.  The bug was rare enough that we'd
> need to watch a large number of machines for a few days just to catch it
> happening.
> 
> We're still running these patches through testing, but the fixup worker bug
> seems to account for the vast majority of crc errors we're seeing in the fleet.
> It's cleaning pages that were dirty, and creating a window where they can be
> reclaimed before we finish processing the page.

I'm having flashbacks when I see 'fixup worker', and the test generic/208 does
not make it better:

generic/095		[18:07:03][ 3769.317862] run fstests generic/095 at 2018-06-20 18:07:03
[ 3774.849685] BTRFS: device fsid 3acffad9-28e5-43ce-80e1-f5032e334cba devid 1 transid 5 /dev/vdb
[ 3774.875409] BTRFS info (device vdb): disk space caching is enabled
[ 3774.877723] BTRFS info (device vdb): has skinny extents
[ 3774.879371] BTRFS info (device vdb): flagging fs with big metadata feature
[ 3774.885020] BTRFS info (device vdb): checking UUID tree
[ 3775.593329] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
[ 3775.596979] File: /tmp/scratch/file2 PID: 12031 Comm: kworker/1:1
[ 3776.642812] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
[ 3776.645041] File: /tmp/scratch/file2 PID: 12033 Comm: kworker/3:0
[ 3776.920634] WARNING: CPU: 0 PID: 12036 at fs/btrfs/inode.c:9319 btrfs_destroy_inode+0x1d5/0x290 [btrfs]
[ 3776.924182] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop [last unloaded: libcrc32c]
[ 3776.927703] CPU: 0 PID: 12036 Comm: umount Not tainted 4.17.0-rc7-default+ #153
[ 3776.929164] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 3776.931006] RIP: 0010:btrfs_destroy_inode+0x1d5/0x290 [btrfs]
[ 3776.932052] RSP: 0018:ffffb2dac5943dc8 EFLAGS: 00010206
[ 3776.933066] RAX: ffff9ab763fe1000 RBX: ffff9ab7796bf4d8 RCX: 0000000000000000
[ 3776.934366] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ab7796bf4d8
[ 3776.935708] RBP: ffffb2dac5943e38 R08: 0000000000000000 R09: 0000000000000002
[ 3776.936666] R10: ffffb2dac5943d28 R11: f9929087e0f2246e R12: ffff9ab7796bf4d8
[ 3776.937511] R13: ffffffffa1dfb4b1 R14: ffff9ab775c657a0 R15: ffff9ab7796bd4b8
[ 3776.938346] FS:  00007f0c97635fc0(0000) GS:ffff9ab77fc00000(0000) knlGS:0000000000000000
[ 3776.939502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3776.940701] CR2: 00007f0c96f7f793 CR3: 0000000063819000 CR4: 00000000000006f0
[ 3776.942396] Call Trace:
[ 3776.942994]  dispose_list+0x51/0x80
[ 3776.943758]  evict_inodes+0x15b/0x1b0
[ 3776.944558]  generic_shutdown_super+0x3a/0x110
[ 3776.945501]  kill_anon_super+0xe/0x20
[ 3776.946272]  btrfs_kill_super+0x12/0xa0 [btrfs]
[ 3776.947313]  deactivate_locked_super+0x34/0x60
[ 3776.948421]  cleanup_mnt+0x3b/0x70
[ 3776.949201]  task_work_run+0x8d/0xc0
[ 3776.949971]  exit_to_usermode_loop+0x99/0xa0
[ 3776.950872]  do_syscall_64+0x17d/0x190
[ 3776.951783]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3776.952724] RIP: 0033:0x7f0c96efea57
[ 3776.953320] RSP: 002b:00007ffc3ae13b98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 3776.954294] RAX: 0000000000000000 RBX: 000055cf12f21970 RCX: 00007f0c96efea57
[ 3776.955196] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055cf12f21b50
[ 3776.956648] RBP: 0000000000000000 R08: 0000000000000005 R09: 00000000ffffffff
[ 3776.957964] R10: 000055cf12f21b70 R11: 0000000000000246 R12: 000055cf12f21b50
[ 3776.959657] R13: 00007f0c974191c4 R14: 0000000000000000 R15: 0000000000000000
[ 3776.961345] Code: ef e8 90 a7 fe ff e9 5f ff ff ff 0f 0b 48 83 bb d8 02 00 00 00 0f 84 76 fe ff ff 0f 0b 48 83 bb f0 fe ff ff 00 0f 84 74 fe ff ff <0f> 0b 48 83 bb e8 fe ff ff 00 0f 84 72 fe ff ff 0f 0b 8b 93 e4 
[ 3776.965122] irq event stamp: 12936
[ 3776.965598] hardirqs last  enabled at (12935): [<ffffffffa1673c69>] _raw_spin_unlock_irq+0x29/0x50
[ 3776.966691] hardirqs last disabled at (12936): [<ffffffffa1800f9c>] error_entry+0x6c/0xc0
[ 3776.968171] softirqs last  enabled at (5088): [<ffffffffa1a003a8>] __do_softirq+0x3a8/0x518
[ 3776.969521] softirqs last disabled at (5065): [<ffffffffa10667d1>] irq_exit+0xc1/0xd0
[ 3776.971686] ---[ end trace e11771ebe2e788d0 ]---
[ 3776.972746] WARNING: CPU: 0 PID: 12036 at fs/btrfs/inode.c:9320 btrfs_destroy_inode+0x1e5/0x290 [btrfs]
[ 3776.974875] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop [last unloaded: libcrc32c]
[ 3776.977451] CPU: 0 PID: 12036 Comm: umount Tainted: G        W         4.17.0-rc7-default+ #153
[ 3776.978663] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 3776.980291] RIP: 0010:btrfs_destroy_inode+0x1e5/0x290 [btrfs]
[ 3776.981037] RSP: 0018:ffffb2dac5943dc8 EFLAGS: 00010206
[ 3776.981686] RAX: ffff9ab763fe1000 RBX: ffff9ab7796bf4d8 RCX: 0000000000000000
[ 3776.982513] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ab7796bf4d8
[ 3776.983541] RBP: ffffb2dac5943e38 R08: 0000000000000000 R09: 0000000000000002
[ 3776.984821] R10: ffffb2dac5943d28 R11: f9929087e0f2246e R12: ffff9ab7796bf4d8
[ 3776.986108] R13: ffffffffa1dfb4b1 R14: ffff9ab775c657a0 R15: ffff9ab7796bd4b8
[ 3776.987417] FS:  00007f0c97635fc0(0000) GS:ffff9ab77fc00000(0000) knlGS:0000000000000000
[ 3776.988925] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3776.989768] CR2: 00007f0c96f7f793 CR3: 0000000063819000 CR4: 00000000000006f0
[ 3776.990600] Call Trace:
[ 3776.990999]  dispose_list+0x51/0x80
[ 3776.991723]  evict_inodes+0x15b/0x1b0
[ 3776.992353]  generic_shutdown_super+0x3a/0x110
[ 3776.993018]  kill_anon_super+0xe/0x20
[ 3776.993528]  btrfs_kill_super+0x12/0xa0 [btrfs]
[ 3776.994155]  deactivate_locked_super+0x34/0x60
[ 3776.994731]  cleanup_mnt+0x3b/0x70
[ 3776.995219]  task_work_run+0x8d/0xc0
[ 3776.995711]  exit_to_usermode_loop+0x99/0xa0
[ 3776.996338]  do_syscall_64+0x17d/0x190
[ 3776.997158]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3776.997922] RIP: 0033:0x7f0c96efea57
[ 3776.998468] RSP: 002b:00007ffc3ae13b98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 3776.999669] RAX: 0000000000000000 RBX: 000055cf12f21970 RCX: 00007f0c96efea57
[ 3777.000902] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055cf12f21b50
[ 3777.002390] RBP: 0000000000000000 R08: 0000000000000005 R09: 00000000ffffffff
[ 3777.003770] R10: 000055cf12f21b70 R11: 0000000000000246 R12: 000055cf12f21b50
[ 3777.005392] R13: 00007f0c974191c4 R14: 0000000000000000 R15: 0000000000000000
[ 3777.006770] Code: d8 02 00 00 00 0f 84 76 fe ff ff 0f 0b 48 83 bb f0 fe ff ff 00 0f 84 74 fe ff ff 0f 0b 48 83 bb e8 fe ff ff 00 0f 84 72 fe ff ff <0f> 0b 8b 93 e4 fe ff ff 85 d2 0f 84 70 fe ff ff 0f 0b 48 83 bb 
[ 3777.011464] irq event stamp: 12966
[ 3777.012248] hardirqs last  enabled at (12965): [<ffffffffa1800972>] restore_regs_and_return_to_kernel+0x0/0x2e
[ 3777.014144] hardirqs last disabled at (12966): [<ffffffffa1800f9c>] error_entry+0x6c/0xc0
[ 3777.016064] softirqs last  enabled at (12964): [<ffffffffa1a003a8>] __do_softirq+0x3a8/0x518
[ 3777.018340] softirqs last disabled at (12939): [<ffffffffa10667d1>] irq_exit+0xc1/0xd0
[ 3777.020123] ---[ end trace e11771ebe2e788d1 ]---
[ 3777.020878] WARNING: CPU: 0 PID: 12036 at fs/btrfs/inode.c:9324 btrfs_destroy_inode+0x225/0x290 [btrfs]
[ 3777.022033] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop [last unloaded: libcrc32c]
[ 3777.024062] CPU: 0 PID: 12036 Comm: umount Tainted: G        W         4.17.0-rc7-default+ #153
[ 3777.026069] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 3777.027752] RIP: 0010:btrfs_destroy_inode+0x225/0x290 [btrfs]
[ 3777.028674] RSP: 0018:ffffb2dac5943dc8 EFLAGS: 00010206
[ 3777.029399] RAX: ffff9ab763fe1000 RBX: ffff9ab7796bf4d8 RCX: 0000000000000000
[ 3777.030498] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ab7796bf4d8
[ 3777.031766] RBP: ffffb2dac5943e38 R08: 0000000000000000 R09: 0000000000000002
[ 3777.033381] R10: ffffb2dac5943d28 R11: f9929087e0f2246e R12: ffff9ab7796bf4d8
[ 3777.034841] R13: ffffffffa1dfb4b1 R14: ffff9ab775c657a0 R15: ffff9ab7796bd4b8
[ 3777.035960] FS:  00007f0c97635fc0(0000) GS:ffff9ab77fc00000(0000) knlGS:0000000000000000
[ 3777.037140] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3777.037887] CR2: 00007f0c96f7f793 CR3: 0000000063819000 CR4: 00000000000006f0
[ 3777.038724] Call Trace:
[ 3777.039206]  dispose_list+0x51/0x80
[ 3777.039954]  evict_inodes+0x15b/0x1b0
[ 3777.040567]  generic_shutdown_super+0x3a/0x110
[ 3777.041255]  kill_anon_super+0xe/0x20
[ 3777.041846]  btrfs_kill_super+0x12/0xa0 [btrfs]
[ 3777.042558]  deactivate_locked_super+0x34/0x60
[ 3777.043239]  cleanup_mnt+0x3b/0x70
[ 3777.043727]  task_work_run+0x8d/0xc0
[ 3777.044229]  exit_to_usermode_loop+0x99/0xa0
[ 3777.044793]  do_syscall_64+0x17d/0x190
[ 3777.045301]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3777.045932] RIP: 0033:0x7f0c96efea57
[ 3777.046423] RSP: 002b:00007ffc3ae13b98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 3777.047406] RAX: 0000000000000000 RBX: 000055cf12f21970 RCX: 00007f0c96efea57
[ 3777.048283] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055cf12f21b50
[ 3777.049404] RBP: 0000000000000000 R08: 0000000000000005 R09: 00000000ffffffff
[ 3777.050826] R10: 000055cf12f21b70 R11: 0000000000000246 R12: 000055cf12f21b50
[ 3777.052190] R13: 00007f0c974191c4 R14: 0000000000000000 R15: 0000000000000000
[ 3777.053487] Code: a0 fe ff ff 00 0f 84 6e fe ff ff 0f 0b 48 83 bb a8 fe ff ff 00 0f 84 6c fe ff ff 0f 0b 48 83 bb d8 fe ff ff 00 0f 84 6a fe ff ff <0f> 0b 48 83 bb b0 fe ff ff 00 0f 84 68 fe ff ff 0f 0b e9 61 fe 
[ 3777.057227] irq event stamp: 13006
[ 3777.058032] hardirqs last  enabled at (13005): [<ffffffffa1800972>] restore_regs_and_return_to_kernel+0x0/0x2e
[ 3777.059601] hardirqs last disabled at (13006): [<ffffffffa1800f9c>] error_entry+0x6c/0xc0
[ 3777.060838] softirqs last  enabled at (13004): [<ffffffffa1a003a8>] __do_softirq+0x3a8/0x518
[ 3777.061938] softirqs last disabled at (12969): [<ffffffffa10667d1>] irq_exit+0xc1/0xd0
[ 3777.062945] ---[ end trace e11771ebe2e788d2 ]---
[ 3777.064111] WARNING: CPU: 0 PID: 12036 at fs/btrfs/inode.c:9319 btrfs_destroy_inode+0x1d5/0x290 [btrfs]
[ 3777.065765] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop [last unloaded: libcrc32c]
[ 3777.067440] CPU: 0 PID: 12036 Comm: umount Tainted: G        W         4.17.0-rc7-default+ #153
[ 3777.068528] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 3777.069766] RIP: 0010:btrfs_destroy_inode+0x1d5/0x290 [btrfs]
[ 3777.070464] RSP: 0018:ffffb2dac5943dc8 EFLAGS: 00010206
[ 3777.071129] RAX: ffff9ab763fe1000 RBX: ffff9ab7796bdcc0 RCX: 0000000000000000
[ 3777.072256] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ab7796bdcc0
[ 3777.073273] RBP: ffffb2dac5943e38 R08: 0000000000000000 R09: 0000000000000002
[ 3777.074104] R10: ffffb2dac5943d28 R11: f9929087e0f2246e R12: ffff9ab7796bdcc0
[ 3777.075013] R13: ffffffffa1dfb4b1 R14: ffff9ab775c657a0 R15: ffff9ab7796bd4b8
[ 3777.076092] FS:  00007f0c97635fc0(0000) GS:ffff9ab77fc00000(0000) knlGS:0000000000000000
[ 3777.077289] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3777.077984] CR2: 00007f0c96f7f793 CR3: 0000000063819000 CR4: 00000000000006f0
[ 3777.078895] Call Trace:
[ 3777.079466]  dispose_list+0x51/0x80
[ 3777.080254]  evict_inodes+0x15b/0x1b0
[ 3777.081055]  generic_shutdown_super+0x3a/0x110
[ 3777.081999]  kill_anon_super+0xe/0x20
[ 3777.082822]  btrfs_kill_super+0x12/0xa0 [btrfs]
[ 3777.083867]  deactivate_locked_super+0x34/0x60
[ 3777.084761]  cleanup_mnt+0x3b/0x70
[ 3777.085346]  task_work_run+0x8d/0xc0
[ 3777.085970]  exit_to_usermode_loop+0x99/0xa0
[ 3777.086779]  do_syscall_64+0x17d/0x190
[ 3777.087552]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3777.088695] RIP: 0033:0x7f0c96efea57
[ 3777.089317] RSP: 002b:00007ffc3ae13b98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 3777.090470] RAX: 0000000000000000 RBX: 000055cf12f21970 RCX: 00007f0c96efea57
[ 3777.091638] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055cf12f21b50
[ 3777.093002] RBP: 0000000000000000 R08: 0000000000000005 R09: 00000000ffffffff
[ 3777.094038] R10: 000055cf12f21b70 R11: 0000000000000246 R12: 000055cf12f21b50
[ 3777.095069] R13: 00007f0c974191c4 R14: 0000000000000000 R15: 0000000000000000
[ 3777.096525] Code: ef e8 90 a7 fe ff e9 5f ff ff ff 0f 0b 48 83 bb d8 02 00 00 00 0f 84 76 fe ff ff 0f 0b 48 83 bb f0 fe ff ff 00 0f 84 74 fe ff ff <0f> 0b 48 83 bb e8 fe ff ff 00 0f 84 72 fe ff ff 0f 0b 8b 93 e4 
[ 3777.099172] irq event stamp: 13862
[ 3777.100023] hardirqs last  enabled at (13861): [<ffffffffa1673c69>] _raw_spin_unlock_irq+0x29/0x50
[ 3777.101676] hardirqs last disabled at (13862): [<ffffffffa1800f9c>] error_entry+0x6c/0xc0
[ 3777.102918] softirqs last  enabled at (13610): [<ffffffffa1a003a8>] __do_softirq+0x3a8/0x518
[ 3777.104284] softirqs last disabled at (13529): [<ffffffffa10667d1>] irq_exit+0xc1/0xd0
[ 3777.105502] ---[ end trace e11771ebe2e788d3 ]---
[ 3777.106190] WARNING: CPU: 0 PID: 12036 at fs/btrfs/inode.c:9320 btrfs_destroy_inode+0x1e5/0x290 [btrfs]
[ 3777.108063] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop [last unloaded: libcrc32c]
[ 3777.110159] CPU: 0 PID: 12036 Comm: umount Tainted: G        W         4.17.0-rc7-default+ #153
[ 3777.112111] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 3777.114053] RIP: 0010:btrfs_destroy_inode+0x1e5/0x290 [btrfs]
[ 3777.115352] RSP: 0018:ffffb2dac5943dc8 EFLAGS: 00010206
[ 3777.116485] RAX: ffff9ab763fe1000 RBX: ffff9ab7796bdcc0 RCX: 0000000000000000
[ 3777.117554] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ab7796bdcc0
[ 3777.118703] RBP: ffffb2dac5943e38 R08: 0000000000000000 R09: 0000000000000002
[ 3777.119848] R10: ffffb2dac5943d28 R11: f9929087e0f2246e R12: ffff9ab7796bdcc0
[ 3777.120863] R13: ffffffffa1dfb4b1 R14: ffff9ab775c657a0 R15: ffff9ab7796bd4b8
[ 3777.121862] FS:  00007f0c97635fc0(0000) GS:ffff9ab77fc00000(0000) knlGS:0000000000000000
[ 3777.122874] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3777.123988] CR2: 00007f0c96f7f793 CR3: 0000000063819000 CR4: 00000000000006f0
[ 3777.125471] Call Trace:
[ 3777.126125]  dispose_list+0x51/0x80
[ 3777.126970]  evict_inodes+0x15b/0x1b0
[ 3777.127684]  generic_shutdown_super+0x3a/0x110
[ 3777.129545]  kill_anon_super+0xe/0x20
[ 3777.130180]  btrfs_kill_super+0x12/0xa0 [btrfs]
[ 3777.130902]  deactivate_locked_super+0x34/0x60
[ 3777.132117]  cleanup_mnt+0x3b/0x70
[ 3777.132855]  task_work_run+0x8d/0xc0
[ 3777.133607]  exit_to_usermode_loop+0x99/0xa0
[ 3777.134503]  do_syscall_64+0x17d/0x190
[ 3777.135556]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3777.136793] RIP: 0033:0x7f0c96efea57
[ 3777.137633] RSP: 002b:00007ffc3ae13b98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 3777.139085] RAX: 0000000000000000 RBX: 000055cf12f21970 RCX: 00007f0c96efea57
[ 3777.140578] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055cf12f21b50
[ 3777.141818] RBP: 0000000000000000 R08: 0000000000000005 R09: 00000000ffffffff
[ 3777.143127] R10: 000055cf12f21b70 R11: 0000000000000246 R12: 000055cf12f21b50
[ 3777.144081] R13: 00007f0c974191c4 R14: 0000000000000000 R15: 0000000000000000
[ 3777.144925] Code: d8 02 00 00 00 0f 84 76 fe ff ff 0f 0b 48 83 bb f0 fe ff ff 00 0f 84 74 fe ff ff 0f 0b 48 83 bb e8 fe ff ff 00 0f 84 72 fe ff ff <0f> 0b 8b 93 e4 fe ff ff 85 d2 0f 84 70 fe ff ff 0f 0b 48 83 bb 
[ 3777.147229] irq event stamp: 13890
[ 3777.148064] hardirqs last  enabled at (13889): [<ffffffffa1800972>] restore_regs_and_return_to_kernel+0x0/0x2e
[ 3777.149617] hardirqs last disabled at (13890): [<ffffffffa1800f9c>] error_entry+0x6c/0xc0
[ 3777.150857] softirqs last  enabled at (13888): [<ffffffffa1a003a8>] __do_softirq+0x3a8/0x518
[ 3777.152652] softirqs last disabled at (13865): [<ffffffffa10667d1>] irq_exit+0xc1/0xd0
[ 3777.154311] ---[ end trace e11771ebe2e788d4 ]---
[ 3777.155432] WARNING: CPU: 0 PID: 12036 at fs/btrfs/inode.c:9324 btrfs_destroy_inode+0x225/0x290 [btrfs]
[ 3777.157624] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop [last unloaded: libcrc32c]
[ 3777.160226] CPU: 0 PID: 12036 Comm: umount Tainted: G        W         4.17.0-rc7-default+ #153
[ 3777.162027] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 3777.164092] RIP: 0010:btrfs_destroy_inode+0x225/0x290 [btrfs]
[ 3777.165410] RSP: 0018:ffffb2dac5943dc8 EFLAGS: 00010206
[ 3777.166474] RAX: ffff9ab763fe1000 RBX: ffff9ab7796bdcc0 RCX: 0000000000000000
[ 3777.167876] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ab7796bdcc0
[ 3777.169390] RBP: ffffb2dac5943e38 R08: 0000000000000000 R09: 0000000000000002
[ 3777.170757] R10: ffffb2dac5943d28 R11: f9929087e0f2246e R12: ffff9ab7796bdcc0
[ 3777.172284] R13: ffffffffa1dfb4b1 R14: ffff9ab775c657a0 R15: ffff9ab7796bd4b8
[ 3777.173912] FS:  00007f0c97635fc0(0000) GS:ffff9ab77fc00000(0000) knlGS:0000000000000000
[ 3777.175587] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3777.176927] CR2: 00007f0c96f7f793 CR3: 0000000063819000 CR4: 00000000000006f0
[ 3777.178464] Call Trace:
[ 3777.178948]  dispose_list+0x51/0x80
[ 3777.179773]  evict_inodes+0x15b/0x1b0
[ 3777.180492]  generic_shutdown_super+0x3a/0x110
[ 3777.181186]  kill_anon_super+0xe/0x20
[ 3777.182189]  btrfs_kill_super+0x12/0xa0 [btrfs]
[ 3777.183043]  deactivate_locked_super+0x34/0x60
[ 3777.183956]  cleanup_mnt+0x3b/0x70
[ 3777.184697]  task_work_run+0x8d/0xc0
[ 3777.185518]  exit_to_usermode_loop+0x99/0xa0
[ 3777.186556]  do_syscall_64+0x17d/0x190
[ 3777.187529]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3777.188687] RIP: 0033:0x7f0c96efea57
[ 3777.189402] RSP: 002b:00007ffc3ae13b98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 3777.190891] RAX: 0000000000000000 RBX: 000055cf12f21970 RCX: 00007f0c96efea57
[ 3777.192374] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055cf12f21b50
[ 3777.193715] RBP: 0000000000000000 R08: 0000000000000005 R09: 00000000ffffffff
[ 3777.195118] R10: 000055cf12f21b70 R11: 0000000000000246 R12: 000055cf12f21b50
[ 3777.196565] R13: 00007f0c974191c4 R14: 0000000000000000 R15: 0000000000000000
[ 3777.197880] Code: a0 fe ff ff 00 0f 84 6e fe ff ff 0f 0b 48 83 bb a8 fe ff ff 00 0f 84 6c fe ff ff 0f 0b 48 83 bb d8 fe ff ff 00 0f 84 6a fe ff ff <0f> 0b 48 83 bb b0 fe ff ff 00 0f 84 68 fe ff ff 0f 0b e9 61 fe 
[ 3777.201524] irq event stamp: 13914
[ 3777.202095] hardirqs last  enabled at (13913): [<ffffffffa1800972>] restore_regs_and_return_to_kernel+0x0/0x2e
[ 3777.203757] hardirqs last disabled at (13914): [<ffffffffa1800f9c>] error_entry+0x6c/0xc0
[ 3777.205651] softirqs last  enabled at (13912): [<ffffffffa1a003a8>] __do_softirq+0x3a8/0x518
[ 3777.207698] softirqs last disabled at (13893): [<ffffffffa10667d1>] irq_exit+0xc1/0xd0
[ 3777.209357] ---[ end trace e11771ebe2e788d5 ]---
[ 3777.232148] WARNING: CPU: 0 PID: 12036 at fs/btrfs/extent-tree.c:9887 btrfs_free_block_groups+0x2da/0x450 [btrfs]
[ 3777.235235] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop [last unloaded: libcrc32c]
[ 3777.238218] CPU: 0 PID: 12036 Comm: umount Tainted: G        W         4.17.0-rc7-default+ #153
[ 3777.240323] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 3777.242512] RIP: 0010:btrfs_free_block_groups+0x2da/0x450 [btrfs]
[ 3777.244021] RSP: 0018:ffffb2dac5943df0 EFLAGS: 00010206
[ 3777.245531] RAX: ffff9ab77b56dce8 RBX: ffff9ab77b56dce8 RCX: 0000000000000000
[ 3777.247203] RDX: 0000000000000000 RSI: ffff9ab76427e580 RDI: ffff9ab77b56d000
[ 3777.248845] RBP: ffff9ab76427c000 R08: 0000000000000000 R09: ffff9ab77b56d118
[ 3777.250504] R10: ffff9ab77b56d108 R11: 0000000000000002 R12: ffff9ab76427c0f8
[ 3777.252005] R13: ffff9ab76427c138 R14: 0000000000000000 R15: dead000000000100
[ 3777.253379] FS:  00007f0c97635fc0(0000) GS:ffff9ab77fc00000(0000) knlGS:0000000000000000
[ 3777.254884] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3777.256042] CR2: 00007f0c96f7f793 CR3: 0000000063819000 CR4: 00000000000006f0
[ 3777.257067] Call Trace:
[ 3777.257535]  close_ctree+0x159/0x350 [btrfs]
[ 3777.258214]  generic_shutdown_super+0x64/0x110
[ 3777.258918]  kill_anon_super+0xe/0x20
[ 3777.259716]  btrfs_kill_super+0x12/0xa0 [btrfs]
[ 3777.260690]  deactivate_locked_super+0x34/0x60
[ 3777.261625]  cleanup_mnt+0x3b/0x70
[ 3777.262355]  task_work_run+0x8d/0xc0
[ 3777.263099]  exit_to_usermode_loop+0x99/0xa0
[ 3777.263986]  do_syscall_64+0x17d/0x190
[ 3777.264750]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3777.265738] RIP: 0033:0x7f0c96efea57
[ 3777.266611] RSP: 002b:00007ffc3ae13b98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 3777.268414] RAX: 0000000000000000 RBX: 000055cf12f21970 RCX: 00007f0c96efea57
[ 3777.269792] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055cf12f21b50
[ 3777.271429] RBP: 0000000000000000 R08: 0000000000000005 R09: 00000000ffffffff
[ 3777.272706] R10: 000055cf12f21b70 R11: 0000000000000246 R12: 000055cf12f21b50
[ 3777.273998] R13: 00007f0c974191c4 R14: 0000000000000000 R15: 0000000000000000
[ 3777.275237] Code: 25 00 00 48 39 c6 0f 84 bf 00 00 00 49 bf 00 01 00 00 00 00 ad de 48 8b 9d 80 25 00 00 48 83 bb 60 ff ff ff 00 0f 84 13 01 00 00 <0f> 0b 48 8d b3 18 ff ff ff 31 c9 31 d2 48 89 ef e8 41 33 ff ff 
[ 3777.279102] irq event stamp: 25740
[ 3777.279934] hardirqs last  enabled at (25739): [<ffffffffa1673c69>] _raw_spin_unlock_irq+0x29/0x50
[ 3777.281740] hardirqs last disabled at (25740): [<ffffffffa1800f9c>] error_entry+0x6c/0xc0
[ 3777.283021] softirqs last  enabled at (18912): [<ffffffffa1a003a8>] __do_softirq+0x3a8/0x518
[ 3777.284726] softirqs last disabled at (18875): [<ffffffffa10667d1>] irq_exit+0xc1/0xd0
[ 3777.285922] ---[ end trace e11771ebe2e788d6 ]---
[ 3777.286715] BTRFS info (device vdb): space_info 1 has 1072140288 free, is not full
[ 3777.288564] BTRFS info (device vdb): space_info total=1073741824, used=1581056, pinned=0, reserved=0, may_use=20480, readonly=0
[ 3777.291201] WARNING: CPU: 0 PID: 12036 at fs/btrfs/extent-tree.c:9887 btrfs_free_block_groups+0x2da/0x450 [btrfs]
[ 3777.293407] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop [last unloaded: libcrc32c]
[ 3777.295577] CPU: 0 PID: 12036 Comm: umount Tainted: G        W         4.17.0-rc7-default+ #153
[ 3777.297231] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 3777.299200] RIP: 0010:btrfs_free_block_groups+0x2da/0x450 [btrfs]
[ 3777.300633] RSP: 0018:ffffb2dac5943df0 EFLAGS: 00010206
[ 3777.301924] RAX: ffff9ab77b56d0e8 RBX: ffff9ab77b56d0e8 RCX: 000000000233be00
[ 3777.303612] RDX: 000000000233bc00 RSI: ffff9ab77fc24d50 RDI: 0000000000024d50
[ 3777.305279] RBP: ffff9ab76427c000 R08: 0000000000000001 R09: 0000000000000000
[ 3777.306852] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9ab77b56dee0
[ 3777.308422] R13: ffff9ab77b56dee0 R14: 0000000000000000 R15: dead000000000100
[ 3777.309730] FS:  00007f0c97635fc0(0000) GS:ffff9ab77fc00000(0000) knlGS:0000000000000000
[ 3777.311497] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3777.312714] CR2: 00007f0c96f7f793 CR3: 0000000063819000 CR4: 00000000000006f0
[ 3777.314277] Call Trace:
[ 3777.314923]  close_ctree+0x159/0x350 [btrfs]
[ 3777.315908]  generic_shutdown_super+0x64/0x110
[ 3777.316831]  kill_anon_super+0xe/0x20
[ 3777.317643]  btrfs_kill_super+0x12/0xa0 [btrfs]
[ 3777.318606]  deactivate_locked_super+0x34/0x60
[ 3777.319671]  cleanup_mnt+0x3b/0x70
[ 3777.320504]  task_work_run+0x8d/0xc0
[ 3777.321300]  exit_to_usermode_loop+0x99/0xa0
[ 3777.322161]  do_syscall_64+0x17d/0x190
[ 3777.323096]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3777.324239] RIP: 0033:0x7f0c96efea57
[ 3777.325027] RSP: 002b:00007ffc3ae13b98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 3777.326654] RAX: 0000000000000000 RBX: 000055cf12f21970 RCX: 00007f0c96efea57
[ 3777.327963] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055cf12f21b50
[ 3777.329239] RBP: 0000000000000000 R08: 0000000000000005 R09: 00000000ffffffff
[ 3777.330673] R10: 000055cf12f21b70 R11: 0000000000000246 R12: 000055cf12f21b50
[ 3777.332119] R13: 00007f0c974191c4 R14: 0000000000000000 R15: 0000000000000000
[ 3777.333585] Code: 25 00 00 48 39 c6 0f 84 bf 00 00 00 49 bf 00 01 00 00 00 00 ad de 48 8b 9d 80 25 00 00 48 83 bb 60 ff ff ff 00 0f 84 13 01 00 00 <0f> 0b 48 8d b3 18 ff ff ff 31 c9 31 d2 48 89 ef e8 41 33 ff ff 
[ 3777.337656] irq event stamp: 26048
[ 3777.338434] hardirqs last  enabled at (26047): [<ffffffffa120e7a1>] kfree+0x101/0x2f0
[ 3777.341262] hardirqs last disabled at (26048): [<ffffffffa1800f9c>] error_entry+0x6c/0xc0
[ 3777.343145] softirqs last  enabled at (26014): [<ffffffffa1a003a8>] __do_softirq+0x3a8/0x518
[ 3777.344829] softirqs last disabled at (25995): [<ffffffffa10667d1>] irq_exit+0xc1/0xd0
[ 3777.346318] ---[ end trace e11771ebe2e788d7 ]---
[ 3777.347424] BTRFS info (device vdb): space_info 4 has 1073037312 free, is not full
[ 3777.348932] BTRFS info (device vdb): space_info total=1073741824, used=114688, pinned=0, reserved=0, may_use=524288, readonly=65536
 [18:07:11] [failed, exit status 1] - output mismatch (see /tmp/fstests/results//generic/095.out.bad)
    --- tests/generic/095.out	2018-04-12 16:57:00.632225551 +0000
    +++ /tmp/fstests/results//generic/095.out.bad	2018-06-20 18:07:11.768000000 +0000
    @@ -1,2 +1,3 @@
     QA output created by 095
     Silence is golden
    +_check_dmesg: something found in dmesg (see /tmp/fstests/results//generic/095.dmesg)
    ...
    (Run 'diff -u tests/generic/095.out /tmp/fstests/results//generic/095.out.bad'  to see the entire diff)
[ 3777.788995] BTRFS: device fsid 20efa141-80c4-4ac0-9deb-ef9fda9ee42a devid 1 transid 5 /dev/vdb
[ 3777.806243] BTRFS info (device vdb): disk space caching is enabled
[ 3777.808414] BTRFS info (device vdb): has skinny extents
[ 3777.838993] BTRFS info (device vdb): checking UUID tree
 [18:07:12] 1s
[ 3777.993068] BTRFS info (device vdb): disk space caching is enabled
[ 3777.994868] BTRFS info (device vdb): has skinny extents

generic/208		[18:54:07][ 6593.361040] run fstests generic/208 at 2018-06-20 18:54:07
[ 6624.274500] 
[ 6624.275022] ======================================================
[ 6624.276332] WARNING: possible circular locking dependency detected
[ 6624.277410] 4.17.0-rc7-default+ #153 Tainted: G        W        
[ 6624.278412] ------------------------------------------------------
[ 6624.279494] aio-dio-invalid/6245 is trying to acquire lock:
[ 6624.280436] 0000000002491ae0 (&mm->mmap_sem){++++}, at: get_user_pages_unlocked+0x5e/0x1d0
[ 6624.282033] 
[ 6624.282033] but task is already holding lock:
[ 6624.283352] 00000000b1b0a2d4 (&ei->dio_sem){++++}, at: btrfs_direct_IO+0x397/0x420 [btrfs]
[ 6624.285138] 
[ 6624.285138] which lock already depends on the new lock.
[ 6624.285138] 
[ 6624.287029] 
[ 6624.287029] the existing dependency chain (in reverse order) is:
[ 6624.288808] 
[ 6624.288808] -> #4 (&ei->dio_sem){++++}:
[ 6624.290126]        btrfs_log_changed_extents+0x7f/0x9d0 [btrfs]
[ 6624.291527]        btrfs_log_inode+0x9dd/0x1200 [btrfs]
[ 6624.292671]        btrfs_log_inode_parent+0x2a2/0xaf0 [btrfs]
[ 6624.294074]        btrfs_log_dentry_safe+0x4a/0x70 [btrfs]
[ 6624.295374]        btrfs_sync_file+0x368/0x520 [btrfs]
[ 6624.296402]        do_fsync+0x38/0x60
[ 6624.297178]        __x64_sys_fsync+0x10/0x20
[ 6624.298063]        do_syscall_64+0x5a/0x190
[ 6624.298926]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 6624.300051] 
[ 6624.300051] -> #3 (&ei->log_mutex){+.+.}:
[ 6624.301374]        btrfs_record_unlink_dir+0x2a/0xa0 [btrfs]
[ 6624.302668]        btrfs_rename+0x375/0xd10 [btrfs]
[ 6624.303641]        vfs_rename+0x3bf/0x920
[ 6624.304378]        do_renameat2+0x46e/0x520
[ 6624.305125]        __x64_sys_rename+0x1c/0x20
[ 6624.305912]        do_syscall_64+0x5a/0x190
[ 6624.306809]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 6624.307950] 
[ 6624.307950] -> #2 (sb_internal#4){++++}:
[ 6624.309107]        percpu_down_write+0x22/0x120
[ 6624.310018]        freeze_super+0xb3/0x180
[ 6624.310894]        do_vfs_ioctl+0x549/0x6b0
[ 6624.311791]        ksys_ioctl+0x3a/0x70
[ 6624.312574]        __x64_sys_ioctl+0x16/0x20
[ 6624.313460]        do_syscall_64+0x5a/0x190
[ 6624.314272]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 6624.315379] 
[ 6624.315379] -> #1 (sb_pagefaults#3){++++}:
[ 6624.316637]        btrfs_page_mkwrite+0x6a/0x550 [btrfs]
[ 6624.317855]        do_page_mkwrite+0x2b/0xa0
[ 6624.318859]        __handle_mm_fault+0x6cf/0xca0
[ 6624.319931]        handle_mm_fault+0x194/0x3a0
[ 6624.320799]        __do_page_fault+0x233/0x480
[ 6624.321723]        async_page_fault+0x1e/0x30
[ 6624.322667] 
[ 6624.322667] -> #0 (&mm->mmap_sem){++++}:
[ 6624.323818]        down_read+0x3b/0x60
[ 6624.324488]        get_user_pages_unlocked+0x5e/0x1d0
[ 6624.325634]        get_user_pages_fast+0xaa/0x140
[ 6624.326722]        iov_iter_get_pages+0xbe/0x2b0
[ 6624.327667]        do_blockdev_direct_IO+0x1f85/0x2c70
[ 6624.328731]        btrfs_direct_IO+0x169/0x420 [btrfs]
[ 6624.329636]        generic_file_direct_write+0x9d/0x160
[ 6624.330574]        btrfs_file_write_iter+0x217/0x610 [btrfs]
[ 6624.331579]        aio_write+0x113/0x1a0
[ 6624.332472]        do_io_submit+0x3ca/0x9a0
[ 6624.333453]        do_syscall_64+0x5a/0x190
[ 6624.334443]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 6624.335691] 
[ 6624.335691] other info that might help us debug this:
[ 6624.335691] 
[ 6624.337440] Chain exists of:
[ 6624.337440]   &mm->mmap_sem --> &ei->log_mutex --> &ei->dio_sem
[ 6624.337440] 
[ 6624.339687]  Possible unsafe locking scenario:
[ 6624.339687] 
[ 6624.340941]        CPU0                    CPU1
[ 6624.341953]        ----                    ----
[ 6624.342977]   lock(&ei->dio_sem);
[ 6624.343662]                                lock(&ei->log_mutex);
[ 6624.344832]                                lock(&ei->dio_sem);
[ 6624.345939]   lock(&mm->mmap_sem);
[ 6624.346661] 
[ 6624.346661]  *** DEADLOCK ***
[ 6624.346661] 
[ 6624.347961] 2 locks held by aio-dio-invalid/6245:
[ 6624.348955]  #0: 000000007312bf7b (sb_writers#14){++++}, at: aio_write+0x18e/0x1a0
[ 6624.350546]  #1: 00000000b1b0a2d4 (&ei->dio_sem){++++}, at: btrfs_direct_IO+0x397/0x420 [btrfs]
[ 6624.352239] 
[ 6624.352239] stack backtrace:
[ 6624.353174] CPU: 2 PID: 6245 Comm: aio-dio-invalid Tainted: G        W         4.17.0-rc7-default+ #153
[ 6624.354987] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[ 6624.357065] Call Trace:
[ 6624.357633]  dump_stack+0x85/0xcb
[ 6624.358283]  print_circular_bug.isra.38+0x1d7/0x1e4
[ 6624.359241]  __lock_acquire+0x126e/0x1330
[ 6624.360188]  ? update_load_avg+0x5d3/0x770
[ 6624.361152]  ? lock_acquire+0x9f/0x210
[ 6624.362068]  ? lock_acquire+0x9f/0x210
[ 6624.362891]  ? __lock_is_held+0x55/0x90
[ 6624.363620]  lock_acquire+0x9f/0x210
[ 6624.364257]  ? get_user_pages_unlocked+0x5e/0x1d0
[ 6624.365123]  down_read+0x3b/0x60
[ 6624.365773]  ? get_user_pages_unlocked+0x5e/0x1d0
[ 6624.366639]  get_user_pages_unlocked+0x5e/0x1d0
[ 6624.367465]  get_user_pages_fast+0xaa/0x140
[ 6624.368390]  iov_iter_get_pages+0xbe/0x2b0
[ 6624.369335]  do_blockdev_direct_IO+0x1f85/0x2c70
[ 6624.370341]  ? btrfs_releasepage+0x70/0x70 [btrfs]
[ 6624.371433]  ? can_nocow_extent+0x480/0x480 [btrfs]
[ 6624.372462]  ? __lock_acquire+0x2ba/0x1330
[ 6624.373305]  ? btrfs_direct_IO+0x397/0x420 [btrfs]
[ 6624.374295]  ? can_nocow_extent+0x480/0x480 [btrfs]
[ 6624.375264]  ? btrfs_releasepage+0x70/0x70 [btrfs]
[ 6624.376337]  ? btrfs_direct_IO+0x169/0x420 [btrfs]
[ 6624.377283]  btrfs_direct_IO+0x169/0x420 [btrfs]
[ 6624.378144]  ? btrfs_releasepage+0x70/0x70 [btrfs]
[ 6624.379025]  generic_file_direct_write+0x9d/0x160
[ 6624.379880]  btrfs_file_write_iter+0x217/0x610 [btrfs]
[ 6624.380805]  aio_write+0x113/0x1a0
[ 6624.381432]  ? lock_acquire+0x9f/0x210
[ 6624.382128]  ? find_held_lock+0x2d/0x90
[ 6624.382837]  ? __might_fault+0x3e/0x90
[ 6624.383492]  ? do_io_submit+0x3ca/0x9a0
[ 6624.384195]  do_io_submit+0x3ca/0x9a0
[ 6624.384892]  ? do_syscall_64+0x5a/0x190
[ 6624.385580]  do_syscall_64+0x5a/0x190
[ 6624.386281]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 6624.387217] RIP: 0033:0x7f7ff3fe8787
[ 6624.388088] RSP: 002b:00007ffddb036ca8 EFLAGS: 00000202 ORIG_RAX: 00000000000000d1
[ 6624.389673] RAX: ffffffffffffffda RBX: 0000000000001864 RCX: 00007f7ff3fe8787
[ 6624.391082] RDX: 00007ffddb036cb8 RSI: 0000000000000001 RDI: 00007f7ff440e000
[ 6624.392555] RBP: 0000000000000003 R08: 00007f7ff4405740 R09: 00007f7ff3fe32a0
[ 6624.393839] R10: 000000000000000e R11: 0000000000000202 R12: 0000000000000000
[ 6624.395091] R13: 00007ffddb036ed0 R14: 0000000000000000 R15: 0000000000000000
 [18:57:28] - output mismatch (see /tmp/fstests/results//generic/208.out.bad)
    --- tests/generic/208.out	2018-04-12 16:57:00.640225551 +0000
    +++ /tmp/fstests/results//generic/208.out.bad	2018-06-20 18:57:28.112000000 +0000
    @@ -1,2 +1,3 @@
     QA output created by 208
     ran for 200 seconds without error, passing
    +_check_dmesg: something found in dmesg (see /tmp/fstests/results//generic/208.dmesg)
    ...
    (Run 'diff -u tests/generic/208.out /tmp/fstests/results//generic/208.out.bad'  to see the entire diff)
[ 6793.859180] BTRFS info (device vda): disk space caching is enabled
[ 6793.862416] BTRFS info (device vda): has skinny extents

