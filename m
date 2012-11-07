Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gerolde.archlinux.org ([66.211.214.132]:44698 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2KGItm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2012 03:49:42 -0500
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com [209.85.220.46])
	by gerolde.archlinux.org (Postfix) with ESMTPSA id C5AF6900A3
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 03:49:41 -0500 (EST)
Received: by mail-pa0-f46.google.com with SMTP id hz1so999648pad.19
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2012 00:49:40 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 7 Nov 2012 09:49:40 +0100
Message-ID: <CAMQ-g0cJqR1qYQJ2PPjWYZ9xSEOZce0AgxVWuG=vWhT19HTC4w@mail.gmail.com>
Subject: Snapshot bug (run_one_delayed_ref; Object already exists)
From: Jan Steffens <heftig@archlinux.org>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello linux-btrfs,

Our package build server (which uses btrfs snapshots to copy build
chroots, rapidly deleting and creating them) has run into a btrfs
error today:

[    8.405865] device label chroots devid 1 transid 93081 /dev/dm-4
[    8.670127] device label chroots devid 1 transid 93081
/dev/mapper/vg_brynhild-chroots
[    8.670630] btrfs: use lzo compression
[    8.670633] btrfs: disk space caching is enabled
[  227.316041] btrfs: run_one_delayed_ref returned -17
[  227.316045] ------------[ cut here ]------------
[  227.316060] WARNING: at fs/btrfs/super.c:246
__btrfs_abort_transaction+0xad/0xc0 [btrfs]()
[  227.316061] Hardware name: MS-7522
[  227.316062] btrfs: Transaction aborted
[  227.316063] Modules linked in:
[  227.316064]  tun btrfs libcrc32c zlib_deflate coretemp kvm_intel
kvm acpi_cpufreq uhci_hcd crc32c_intel mperf i7core_edac iTCO_wdt
iTCO_vendor_support ehci_hcd gpio_ic
h i2c_i801 r8169 edac_core i2c_core lpc_ich usbcore microcode wmi
usb_common processor mii ext4 crc16 jbd2 mbcache dm_mod raid1 md_mod
sd_mod ahci libahci libata scsi_mod
[  227.316087] Pid: 2390, comm: btrfs-endio-wri Not tainted 3.6.3-1-ARCH #1
[  227.316089] Call Trace:
[  227.316096]  [<ffffffff81055c7f>] warn_slowpath_common+0x7f/0xc0
[  227.316099]  [<ffffffff81055d76>] warn_slowpath_fmt+0x46/0x50
[  227.316105]  [<ffffffffa07dbecd>] __btrfs_abort_transaction+0xad/0xc0 [btrfs]
[  227.316113]  [<ffffffffa07f273a>] btrfs_run_delayed_refs+0x23a/0x2e0 [btrfs]
[  227.316122]  [<ffffffffa0804d67>] __btrfs_end_transaction+0xc7/0x3a0 [btrfs]
[  227.316131]  [<ffffffffa08050b5>] btrfs_end_transaction+0x15/0x20 [btrfs]
[  227.316140]  [<ffffffffa080afc5>] btrfs_finish_ordered_io+0x135/0x420 [btrfs]
[  227.316148]  [<ffffffffa080b2c5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  227.316157]  [<ffffffffa082baed>] worker_loop+0x13d/0x570 [btrfs]
[  227.316166]  [<ffffffffa082b9b0>] ? btrfs_queue_worker+0x320/0x320 [btrfs]
[  227.316169]  [<ffffffff81079913>] kthread+0x93/0xa0
[  227.316174]  [<ffffffff8149ad84>] kernel_thread_helper+0x4/0x10
[  227.316177]  [<ffffffff81079880>] ? kthread_freezable_should_stop+0x70/0x70
[  227.316179]  [<ffffffff8149ad80>] ? gs_change+0x13/0x13
[  227.316181] ---[ end trace 4c297f2ed063eaf3 ]---
[  227.316183] BTRFS error (device dm-4) in
btrfs_run_delayed_refs:2521: Object already exists
[  227.316231] btrfs is forced readonly
[  249.074396] ------------[ cut here ]------------
[  249.074436] kernel BUG at fs/btrfs/transaction.c:1640!
[  249.074472] invalid opcode: 0000 [#1] PREEMPT SMP
[  249.074587] Modules linked in: tun btrfs libcrc32c zlib_deflate
coretemp kvm_intel kvm acpi_cpufreq uhci_hcd crc32c_intel mperf
i7core_edac iTCO_wdt iTCO_vendor_support ehci_hcd gpio_ich i2c_i801
r8169 edac_core i2c_core lpc_ich usbcore microcode wmi usb_common
processor mii ext4 crc16 jbd2 mbcache dm_mod raid1 md_mod sd_mod ahci
libahci libata scsi_mod
[  249.075723] CPU 5
[  249.075755] Pid: 377, comm: btrfs-cleaner Tainted: G        W
3.6.3-1-ARCH #1 MSI MS-7522/MSI X58 Pro-E (MS-7522)
[  249.075827] RIP: 0010:[<ffffffffa08059a1>]  [<ffffffffa08059a1>]
btrfs_clean_old_snapshots+0x141/0x150 [btrfs]
[  249.075909] RSP: 0018:ffff88022c597e60  EFLAGS: 00010286
[  249.075945] RAX: 00000000ffffffe2 RBX: ffff880228912470 RCX: 00000000ffffffe2
[  249.075985] RDX: 0000000000001bb5 RSI: ffffffffa08655e0 RDI: ffff880233364000
[  249.076024] RBP: ffff88022c597ea0 R08: 0000000000000000 R09: ffff88023fcbb900
[  249.076064] R10: ffffffffa07df07a R11: ffffffffa07f4430 R12: ffff88022c597e60
[  249.076103] R13: ffff880000000000 R14: 0000160000000000 R15: ffff880228912000
[  249.076143] FS:  0000000000000000(0000) GS:ffff88023fca0000(0000)
knlGS:0000000000000000
[  249.076211] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  249.076262] CR2: 00007fae5271a934 CR3: 000000000180c000 CR4: 00000000000007e0
[  249.076315] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  249.076368] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  249.076421] Process btrfs-cleaner (pid: 377, threadinfo
ffff88022c596000, task ffff88022ca93060)
[  249.076489] Stack:
[  249.076603]  ffff880228911c70 ffff88023227bc70 ffff88022ca93060
ffff880233324800
[  249.076784]  ffff88022ca93060 ffff88022ca93060 ffff88022ca93060
0000000000000000
[  249.076955]  ffff88022c597ee0 ffffffffa07fc7d8 ffff880233324800
0000000000000000
[  249.077126] Call Trace:
[  249.077175]  [<ffffffffa07fc7d8>] cleaner_kthread+0xa8/0x120 [btrfs]
[  249.077231]  [<ffffffffa07fc730>] ? btrfs_alloc_root+0x50/0x50 [btrfs]
[  249.077286]  [<ffffffff81079913>] kthread+0x93/0xa0
[  249.077408]  [<ffffffff8149ad84>] kernel_thread_helper+0x4/0x10
[  249.077466]  [<ffffffff81079880>] ? kthread_freezable_should_stop+0x70/0x70
[  249.077523]  [<ffffffff8149ad80>] ? gs_change+0x13/0x13
[  249.077571] Code: 7f 80 31 d2 31 f6 4c 89 ff e8 ac e8 fe ff eb 81
66 2e 0f 1f 84 00 00 00 00 00 48 83 c4 18 31 c0 5b 41 5c 41 5d 41 5e
41 5f 5d c3 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5
66 66
[  249.079375] RIP  [<ffffffffa08059a1>]
btrfs_clean_old_snapshots+0x141/0x150 [btrfs]
[  249.079473]  RSP <ffff88022c597e60>
[  249.079528] ---[ end trace 4c297f2ed063eaf4 ]---

fstab:
/dev/mapper/vg_brynhild-chroots /var/lib/archbuild btrfs
noatime,subvolid=0,compress=lzo 0 2

The btrfs is contained in a LVM on an md RAID1.

I'll have to overwrite the FS to get work to resume, so more debugging
on this particular filesystem will be impossible. :(
btrfs-debug-tree output is available, though, if wanted (321.7 MiB
xz-compressed; 3,805.0 MiB uncompressed).

Regards,
Jan Steffens
