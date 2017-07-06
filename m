Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:54331 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdGFQcc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 12:32:32 -0400
Date: Thu, 6 Jul 2017 18:32:25 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nick Terrell <terrelln@fb.com>
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Message-ID: <20170706163225.xbluc2gi2nlaafzo@angband.pl>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170629194108.1674498-4-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 29, 2017 at 12:41:07PM -0700, Nick Terrell wrote:
> Add zstd compression and decompression support to BtrFS. zstd at its
> fastest level compresses almost as well as zlib, while offering much
> faster compression and decompression, approaching lzo speeds.

Got a reproducible crash on amd64:

[98235.266511] BUG: unable to handle kernel paging request at ffffc90001251000
[98235.267485] IP: ZSTD_storeSeq.constprop.24+0x67/0xe0
[98235.269395] PGD 227034067 
[98235.269397] P4D 227034067 
[98235.271587] PUD 227035067 
[98235.273657] PMD 223323067 
[98235.275744] PTE 0

[98235.281545] Oops: 0002 [#1] SMP
[98235.283353] Modules linked in: loop veth tun fuse arc4 rtl8xxxu mac80211 cfg80211 cp210x pl2303 rfkill usbserial nouveau video mxm_wmi ttm
[98235.285203] CPU: 0 PID: 10850 Comm: kworker/u12:9 Not tainted 4.12.0+ #1
[98235.287070] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[98235.288964] Workqueue: btrfs-delalloc btrfs_delalloc_helper
[98235.290934] task: ffff880224984140 task.stack: ffffc90007e5c000
[98235.292731] RIP: 0010:ZSTD_storeSeq.constprop.24+0x67/0xe0
[98235.294579] RSP: 0018:ffffc90007e5fa68 EFLAGS: 00010282
[98235.296395] RAX: ffffc90001251001 RBX: 0000000000000094 RCX: ffffc9000118f930
[98235.298380] RDX: 0000000000000006 RSI: ffffc900011b06b0 RDI: ffffc9000118d1e0
[98235.300321] RBP: 000000000000009f R08: 1fffffffffffbe58 R09: 0000000000000000
[98235.302282] R10: ffffc9000118f970 R11: 0000000000000005 R12: ffffc9000118f878
[98235.304221] R13: 000000000000005b R14: ffffc9000118f915 R15: ffffc900011cfe88
[98235.306147] FS:  0000000000000000(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
[98235.308162] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[98235.310129] CR2: ffffc90001251000 CR3: 000000021018d000 CR4: 00000000000006f0
[98235.312095] Call Trace:
[98235.314008]  ? ZSTD_compressBlock_fast+0x94b/0xb30
[98235.315975]  ? ZSTD_compressContinue_internal+0x1a0/0x580
[98235.317938]  ? ZSTD_compressStream_generic+0x248/0x2f0
[98235.319877]  ? ZSTD_compressStream+0x41/0x60
[98235.321821]  ? zstd_compress_pages+0x236/0x5d0
[98235.323724]  ? btrfs_compress_pages+0x5e/0x80
[98235.325684]  ? compress_file_range.constprop.79+0x1eb/0x750
[98235.327668]  ? async_cow_start+0x2e/0x50
[98235.329594]  ? btrfs_worker_helper+0x1b9/0x1d0
[98235.331486]  ? process_one_work+0x158/0x2f0
[98235.333361]  ? worker_thread+0x45/0x3a0
[98235.335253]  ? process_one_work+0x2f0/0x2f0
[98235.337189]  ? kthread+0x10e/0x130
[98235.339020]  ? kthread_park+0x60/0x60
[98235.340819]  ? ret_from_fork+0x22/0x30
[98235.342637] Code: 8b 4e d0 4c 89 48 d0 4c 8b 4e d8 4c 89 48 d8 4c 8b 4e e0 4c 89 48 e0 4c 8b 4e e8 4c 89 48 e8 4c 8b 4e f0 4c 89 48 f0 4c 8b 4e f8 <4c> 89 48 f8 48 39 f1 75 a2 4e 8d 04 c0 48 8b 31 48 83 c0 08 48 
[98235.346773] RIP: ZSTD_storeSeq.constprop.24+0x67/0xe0 RSP: ffffc90007e5fa68
[98235.348809] CR2: ffffc90001251000
[98235.363216] ---[ end trace 5fb3ad0f2aec0605 ]---
[98235.363218] BUG: unable to handle kernel paging request at ffffc9000393a000
[98235.363239] IP: ZSTD_storeSeq.constprop.24+0x67/0xe0
[98235.363241] PGD 227034067 
[98235.363242] P4D 227034067 
[98235.363243] PUD 227035067 
[98235.363244] PMD 21edec067 
[98235.363245] PTE 0
(More of the above follows.)

My reproducer copies an uncompressed tarball onto a fresh filesystem:
.----
#!/bin/sh
set -e

losetup -D; umount /mnt/vol1 ||:
dd if=/dev/zero of=/tmp/disk bs=2048 seek=1048575 count=1
mkfs.btrfs -msingle /tmp/disk
losetup -f /tmp/disk
sleep 1 # yay udev races
mount -onoatime,compress=$1 /dev/loop0 /mnt/vol1
time sh -c 'cp -p ~kilobyte/tmp/kernel.tar /mnt/vol1 && umount /mnt/vol1'
losetup -D
`----
(run it with arg of "zstd")

Kernel is 4.12.0 + btrfs-for-4.13 + v4 of Qu's chunk check + some unrelated
stuff + zstd; in case it matters I've pushed my tree to
https://github.com/kilobyte/linux/tree/zstd-crash

The payload is a tarball of the above, but, for debugging compression you
need the exact byte stream.  https://angband.pl/tmp/kernel.tar.xz --
without xz, I compressed it for transport.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
