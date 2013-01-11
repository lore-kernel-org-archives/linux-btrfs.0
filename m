Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:34922 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3AKSNq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 13:13:46 -0500
Received: by mail-vb0-f50.google.com with SMTP id ft2so1704097vbb.37
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2013 10:13:45 -0800 (PST)
MIME-Version: 1.0
Reply-To: chris.r.carlin@gmail.com
In-Reply-To: <CAHX0HSbVxW0HvvXi-LXPqGUDu5AZgNRJssMeWRp_MetvVc_gwQ@mail.gmail.com>
References: <CAHX0HSbVxW0HvvXi-LXPqGUDu5AZgNRJssMeWRp_MetvVc_gwQ@mail.gmail.com>
From: Chris Carlin <chrisrcarlin@gmail.com>
Date: Fri, 11 Jan 2013 13:13:24 -0500
Message-ID: <CAHX0HSZGuE_N1x3DTRPcQZ66B4Sqs7T9sj33=pyVs64wQSWwtw@mail.gmail.com>
Subject: Errors not found by btrfsck or scrub
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a week-old filesystem that is reported clean by btrfsck and
scrub, but that fails under operations ranging from du to sync and
umount (but no failures if mounted readonly).

My problem sounds similar to a few other reports (e.g. TM's in
http://thread.gmane.org/gmane.comp.file-systems.btrfs/22014 ) that
seem to hint at problems with full metadata. My df shows:

# btrfs fi df /mnt/btrfs
Data, RAID0: total=776.32GB, used=717.56GB
Data: total=81.00GB, used=29.44GB
System, DUP: total=8.00MB, used=72.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=512.00MB, used=511.60MB
Metadata, DUP: total=1.00GB, used=1022.39MB

That looks suspicious to me, both the 1GB vs 1022MB and that there is
both DUP and RAID1 metadata. The balance operation I ran after adding
a second device finished without errors; could it have actually
failed? At this point balance DOES fail (locks up) every time...

This computer is Ubuntu, but I've updated to the latest kernel and
btrfs-tools I could find, and the problems remain.

Below is what showed up in dmesg during the run of scrub. Most of the
time the error is "btrfs: block rsv returned -28", but the aborted
transaction and auto-ro is always there.

Anything I can do to help identify a bug here? Clearly one problem is
that the filesystem checking tools can't find anything wrong, much
less fix the filesystem.

~Chris

scrub:
[12208.367036] btrfs: run_one_delayed_ref returned -28
[12208.367049] ------------[ cut here ]------------
[12208.367152] WARNING: at /home/apw/COD/linux/fs/btrfs/super.c:221
__btrfs_abort_transaction+0x99/0xb0 [btrfs]()
[12208.367155] Hardware name: KT600-8237
[12208.367158] btrfs: Transaction aborted
[12208.367161] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs
msdos jfs xfs reiserfs ext2 i2c_viapro serio_raw matrox_w1 wire
w83627hf hwmon_vid shpchp mac_hid lp parport btrfs zlib_deflate
libcrc32c hid_generic usbhid hid sata_via pata_via sata_sil r8169
[12208.367199] Pid: 1955, comm: btrfs-transacti Not tainted
3.5.7-03050702-generic #201212170935
[12208.367201] Call Trace:
[12208.367218]  [<c1045a52>] warn_slowpath_common+0x72/0xa0
[12208.367243]  [<e0960fa9>] ? __btrfs_abort_transaction+0x99/0xb0 [btrfs]
[12208.367267]  [<e0960fa9>] ? __btrfs_abort_transaction+0x99/0xb0 [btrfs]
[12208.367273]  [<c1045b23>] warn_slowpath_fmt+0x33/0x40
[12208.367297]  [<e0960fa9>] __btrfs_abort_transaction+0x99/0xb0 [btrfs]
[12208.367329]  [<e0976c0e>] btrfs_run_delayed_refs+0x29e/0x2e0 [btrfs]
[12208.367362]  [<e098763a>] btrfs_commit_transaction+0x3aa/0x8b0 [btrfs]
[12208.367371]  [<c1066eb0>] ? add_wait_queue+0x50/0x50
[12208.367400]  [<e0988208>] ? start_transaction+0x38/0x50 [btrfs]
[12208.367427]  [<e0981b1d>] transaction_kthread+0x1ed/0x260 [btrfs]
[12208.367437]  [<c107066e>] ? complete+0x4e/0x60
[12208.367464]  [<e0981930>] ?
btrfs_destroy_delayed_refs.isra.86+0x1c0/0x1c0 [btrfs]
[12208.367470]  [<c1066812>] kthread+0x72/0x80
[12208.367475]  [<c10667a0>] ? flush_kthread_worker+0x90/0x90
[12208.367484]  [<c15e5d3e>] kernel_thread_helper+0x6/0x10
[12208.367488] ---[ end trace d44c7f4de69ddd30 ]---
[12208.367493] BTRFS error (device sdb1) in
btrfs_run_delayed_refs:2455: error 28
[12208.367504] btrfs is forced readonly
[12208.367510] BTRFS warning (device sdb1): Skipping commit of aborted
transaction.
[12208.367515] BTRFS error (device sdb1) in cleanup_transaction:1226: error 28
