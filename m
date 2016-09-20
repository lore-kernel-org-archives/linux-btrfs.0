Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:43981 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbcITBjg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 21:39:36 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.84_2)
        (envelope-from <kilobyte@angband.pl>)
        id 1bmA1v-0005DB-HS
        for linux-btrfs@vger.kernel.org; Tue, 20 Sep 2016 03:39:27 +0200
Date: Tue, 20 Sep 2016 03:39:27 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: splat in split_leaf with integrity checking
Message-ID: <20160920013927.GA17326@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
I just had the following splat in 4.8-rc6 for the third time in a week:

[413782.442899] BTRFS critical (device sda1): corrupt leaf, non-root leaf's nritems is 0: block=692012023808,root=1, slot=0
[413782.453888] BTRFS info (device sda1): leaf 692012023808 total ptrs 0 free space 16283
[413782.462918] BTRFS: assertion failed: 0, file: fs/btrfs/disk-io.c, line: 4050
[413782.469995] ------------[ cut here ]------------
[413782.474921] kernel BUG at fs/btrfs/ctree.h:3368!
[413782.479644] invalid opcode: 0000 [#1] SMP
[413782.483760] Modules linked in: ntfs vfat msdos fat dm_mod vboxpci(O) vboxnetflt(O) vboxdrv(O) usb_storage cp210x pl2303 usbserial nvidia(PO) [last unloaded: vboxnetadp]
[413782.499205] CPU: 0 PID: 5904 Comm: kworker/u12:18 Tainted: P           O    4.8.0-rc6-debug3+ #3
[413782.508110] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[413782.517191] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[413782.523407] task: ffff88022e3f6700 task.stack: ffff880210760000
[413782.529464] RIP: 0010:[<ffffffff81714040>]  [<ffffffff81714040>] assfail.constprop.22+0x1c/0x2a
[413782.538296] RSP: 0018:ffff8802107639c8  EFLAGS: 00010292
[413782.543739] RAX: 0000000000000040 RBX: ffff8801517abde0 RCX: 0000000000000001
[413782.550999] RDX: 0000000000000001 RSI: 0000000000000247 RDI: ffffffff831419cc
[413782.558236] RBP: ffff8802107639c8 R08: 0000000000000000 R09: ffffffff83143a20
[413782.565490] R10: 0000000000002165 R11: 0000000000071046 R12: ffff880228925000
[413782.572744] R13: ffff880228934000 R14: 000000000011430d R15: ffff8801b0008e00
[413782.579980] FS:  0000000000000000(0000) GS:ffff880237c00000(0000) knlGS:0000000000000000
[413782.588204] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[413782.594061] CR2: 00007fdfcc78d000 CR3: 0000000002406000 CR4: 00000000000006f0
[413782.601323] Stack:
[413782.603428]  ffff880210763a00 ffffffff816259da ffff880218518000 0000000000000100
[413782.611012]  ffff8800446d8000 0000000000000001 ffff8801517abde0 ffff880210763ac8
[413782.618568]  ffffffff815ede43 000000a100000001 0000000000000000 ffff880095f02858
[413782.626141] Call Trace:
[413782.628686]  [<ffffffff816259da>] btrfs_mark_buffer_dirty+0x17a/0x2b0
[413782.635253]  [<ffffffff815ede43>] split_leaf+0x8c3/0xc10
[413782.640670]  [<ffffffff815eedac>] btrfs_search_slot+0xc1c/0x1480
[413782.646771]  [<ffffffff815f1e1b>] btrfs_insert_empty_items+0x7b/0x110
[413782.653331]  [<ffffffff8166a2ce>] ? free_extent_buffer+0xe/0x20
[413782.659379]  [<ffffffff815e5633>] ? btrfs_release_path+0x33/0x1e0
[413782.665583]  [<ffffffff8161a977>] btrfs_csum_file_blocks+0x377/0xb90
[413782.672040]  [<ffffffff81632f4b>] add_pending_csums.isra.19+0x7b/0x130
[413782.678671]  [<ffffffff8163dd36>] btrfs_finish_ordered_io+0x286/0x8f0
[413782.685213]  [<ffffffff8163e3b0>] finish_ordered_fn+0x10/0x20
[413782.691070]  [<ffffffff81682ab2>] btrfs_scrubparity_helper+0xa2/0x3d0
[413782.697604]  [<ffffffff81682e69>] btrfs_endio_write_helper+0x9/0x10
[413782.703967]  [<ffffffff81142549>] process_one_work+0x209/0x790
[413782.709911]  [<ffffffff81142b2c>] worker_thread+0x5c/0x680
[413782.715508]  [<ffffffff81142ad0>] ? process_one_work+0x790/0x790
[413782.721627]  [<ffffffff8114c226>] kthread+0xf6/0x150
[413782.726680]  [<ffffffff81ecca7f>] ret_from_fork+0x1f/0x40
[413782.732191]  [<ffffffff8114c130>] ? kthread_worker_fn+0x360/0x360
[413782.738402] Code: 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 89 f1 48 c7 c2 44 1c 1b 82 48 89 fe 48 c7 c7 70 07 1a 82 48 89 e5 e8 78 4b b5 ff <0f> 0b 48 c7 c7 d0 25 90 82 e8 d2 c0 11 00 55 48 89 e5 41 57 41 
[413782.758489] RIP  [<ffffffff81714040>] assfail.constprop.22+0x1c/0x2a
[413782.764957]  RSP <ffff8802107639c8>
[413782.771482] ---[ end trace 5d39ae0a5304d4c7 ]---

Kernel built with
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
(and frame pointers, UBSAN, etc)

It's not pristine Linus' tree -- I have the xfs-reflink patch set
(djwong/for-dave-for-4.9-2) which does superficial changes to vfs; no xfs
partitions mounted nor even present on any attached disks during the week,
though.

No idea how new this is, I haven't been running 4.8-rcs until recently.

/dev/sda1 is ssd,compress=lzo,noatime.

Not 100% sure the first two splats were this, the aftereffects kill the
system immediately and I had no serial console attached; it didn't then
reproduce until today.

1. copying a largish source tree to a different subvolume
2. dpkg -i kernel-image
3. partway into scp-ying in a 60GB file, 8.1GB that successfully copied
   is readable

The filesystem appears to be kosher as far as I can tell (btrfs check,
scrub, tar cf - >/dev/null).

Haven't tried without xfs-reflink yet -- it'd take another week to
reproduce...


Meow!
-- 
Second "wet cat laying down on a powered-on box-less SoC on the desk" close
shave in a week.  Protect your ARMs, folks!
