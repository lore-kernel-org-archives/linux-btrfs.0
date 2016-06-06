Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:58122 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbcFFLri (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 07:47:38 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.84_2)
	(envelope-from <kilobyte@angband.pl>)
	id 1b9t0G-0008Pg-TS
	for linux-btrfs@vger.kernel.org; Mon, 06 Jun 2016 13:47:32 +0200
Date: Mon, 6 Jun 2016 13:47:32 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Transaction aborted in btrfs_rename2
Message-ID: <20160606114732.GA30582@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
I just got this thrice, in 4.7-rc1 and 4.7-rc2:

[ 1836.672368] ------------[ cut here ]------------
[ 1836.672382] WARNING: CPU: 1 PID: 16348 at fs/btrfs/inode.c:9820 btrfs_rename2+0xcd2/0x2a50
[ 1836.672385] BTRFS: Transaction aborted (error -2)
[ 1836.672387] Modules linked in: nvidia(PO) usb_storage
[ 1836.672396] CPU: 1 PID: 16348 Comm: gcc-6 Tainted: P           O    4.7.0-rc2-debug+ #3
[ 1836.672399] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[ 1836.672402]  ffffffff81f8b504 ffff880062c47c78 ffffffff8165be6d 0000000000000007
[ 1836.672407]  ffff880062c47cd0 0000000000000000 ffff880062c47cc0 ffffffff81110c1c
[ 1836.672411]  ffff880062c47d20 0000265c814e8642 0000000000000000 0000000000a25ade
[ 1836.672415] Call Trace:
[ 1836.672423]  [<ffffffff8165be6d>] dump_stack+0x4e/0x71
[ 1836.672429]  [<ffffffff81110c1c>] __warn+0x10c/0x150
[ 1836.672433]  [<ffffffff81110caa>] warn_slowpath_fmt+0x4a/0x50
[ 1836.672437]  [<ffffffff814f4842>] btrfs_rename2+0xcd2/0x2a50
[ 1836.672443]  [<ffffffff814dfcfb>] ? btrfs_permission+0x5b/0xc0
[ 1836.672448]  [<ffffffff81d288c8>] ? down_write+0x18/0x60
[ 1836.672453]  [<ffffffff8133a0cc>] vfs_rename+0x7cc/0xc30
[ 1836.672457]  [<ffffffff8133dc8b>] SyS_rename+0x32b/0x420
[ 1836.672461]  [<ffffffff81d2ab9f>] entry_SYSCALL_64_fastpath+0x17/0x93
[ 1836.672464] ---[ end trace 6405b6e3d0e6c945 ]---
[ 1836.672468] BTRFS warning (device sda1): btrfs_rename:9820: Aborting unused transaction(No such entry).
[ 1836.675505] BTRFS warning (device sda1): btrfs_rename:9820: Aborting unused transaction(No such entry).
<repeated 1152 times>
[ 1837.935238] BTRFS warning (device sda1): btrfs_rename:9820: Aborting unused transaction(No such entry).
[ 1837.937602] BTRFS: error (device sda1) in btrfs_rename:9820: errno=-2 No such entry
[ 1837.937607] BTRFS info (device sda1): forced readonly
[ 1838.086754] BTRFS warning (device sda1): Skipping commit of aborted transaction.
[ 1838.086762] BTRFS: error (device sda1) in cleanup_transaction:1857: errno=-2 No such entry
[ 1838.086782] BTRFS info (device sda1): delayed_refs has NO entry

Didn't trigger during a week of other work, yet a kernel compile triggers
this reliably.

Filesystem appears consistent (btrfs check, scrub).
Mount options: noatime,compress=lzo,ssd,space_cache.

-- 
An imaginary friend squared is a real enemy.
