Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.31.104]:59354 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbcESKZ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 06:25:58 -0400
Received: from [77.13.71.64] (helo=hermione.invalid)
	by smtprelay06.ispgateway.de with esmtpsa (TLSv1.2:AES128-GCM-SHA256:128)
	(Exim 4.84)
	(envelope-from <envelope@m-berberich.de>)
	id 1b3L9N-0000Bp-Q1
	for linux-btrfs@vger.kernel.org; Thu, 19 May 2016 12:25:53 +0200
Received: from berberic by hermione.invalid with local (Exim 4.87)
	(envelope-from <envelope@m-berberich.de>)
	id 1b3L9N-0001oA-B5
	for linux-btrfs@vger.kernel.org; Thu, 19 May 2016 12:25:53 +0200
Date: Thu, 19 May 2016 12:25:53 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: Crash after WARN_ON(BTRFS_I(inode)->csum_bytes)
Message-ID: <20160519102553.GA4164@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

a near total system crash (reboot via magic-sysreq-keys was possible)
which seems to be associated to btrfs.

btrfs check (v 4.5.2) does not find any problem with any filesystems
on the system.

Kernel is stock 4.6, booting without initramfs, system is Debian
stretch (testing).

[154452.371396] ------------[ cut here ]------------
[154452.376261] WARNING: CPU: 4 PID: 22333 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x23e/0x2b0
[154452.385319] Modules linked in: cp210x usbserial rc_digittrade mt2060 af9013 uas intel_rapl kvm_intel kvm irqbypass ghash_clmulni_intel input_leds serio_raw dvb_usb_af9015 dvb_usb_v2 dvb_core rc_core usb_storage it87 hwmon_vid firewire_sbp2 firewire_core ppdev lp autofs4
[154452.410449] CPU: 4 PID: 22333 Comm: debtags Tainted: G        W       4.6.0 #1
[154452.417983] Hardware name: Gigabyte Technology Co., Ltd. H87-HD3/H87-HD3, BIOS F10 08/18/2015
[154452.426856]  0000000000000000 ffff8801078d3d48 ffffffff813f634d 0000000000000000
[154452.434616]  0000000000000000 ffff8801078d3d88 ffffffff8108daf6 0000242d819df8b1
[154452.442376]  ffff88028cfdf0e8 ffff88028cfdf0e8 ffff8800ca3e3800 ffff88028cfdf170
[154452.450137] Call Trace:
[154452.452753]  [<ffffffff813f634d>] dump_stack+0x4f/0x72
[154452.458140]  [<ffffffff8108daf6>] __warn+0xc6/0xe0
[154452.463167]  [<ffffffff8108dbc8>] warn_slowpath_null+0x18/0x20
[154452.469270]  [<ffffffff8130795e>] btrfs_destroy_inode+0x23e/0x2b0
[154452.475649]  [<ffffffff811d73e6>] destroy_inode+0x36/0x60
[154452.481304]  [<ffffffff811d753d>] evict+0x12d/0x190
[154452.486421]  [<ffffffff811d77c1>] iput+0x1d1/0x240
[154452.491448]  [<ffffffff811d3c8d>] __dentry_kill+0x16d/0x1d0
[154452.497280]  [<ffffffff811d3e1b>] dput+0x12b/0x220
[154452.502306]  [<ffffffff811ce767>] SyS_rename+0x2c7/0x360
[154452.507872]  [<ffffffff819dfd5b>] entry_SYSCALL_64_fastpath+0x13/0x8f
[154452.514632] ---[ end trace 108fc543c76a3117 ]---
[154460.456586] general protection fault: 0000 [#1] PREEMPT SMP
[154460.462559] Modules linked in: cp210x usbserial rc_digittrade mt2060 af9013 uas intel_rapl kvm_intel kvm irqbypass ghash_clmulni_intel input_leds serio_raw dvb_usb_af9015 dvb_usb_v2 dvb_core rc_core usb_storage it87 hwmon_vid firewire_sbp2 firewire_core ppdev lp autofs4
[154460.487670] CPU: 6 PID: 22513 Comm: find Tainted: G        W       4.6.0 #1
[154460.494948] Hardware name: Gigabyte Technology Co., Ltd. H87-HD3/H87-HD3, BIOS F10 08/18/2015
[154460.503840] task: ffff880107208000 ti: ffff8807cdd24000 task.ti: ffff8807cdd24000
[154460.511655] RIP: 0010:[<ffffffff811d6bcf>]  [<ffffffff811d6bcf>] find_inode+0x3f/0xc0
[154460.519863] RSP: 0018:ffff8807cdd27ad8  EFLAGS: 00010206
[154460.525434] RAX: 0000000000000000 RBX: 582677919991aa21 RCX: ffff8807cdd27b90
[154460.532899] RDX: ffffffff812f7fb0 RSI: ffff88080b1ee930 RDI: 582677919991ab01
[154460.540367] RBP: ffff8807cdd27b08 R08: ffff8807cdd27b90 R09: ffffffff812cca61
[154460.547837] R10: ffff88080a2e1100 R11: 0000000000000003 R12: ffff8807cdd27b90
[154460.555302] R13: ffffffff812f7fb0 R14: ffff88080b1ee930 R15: ffff88080838b800
[154460.562760] FS:  00007f9459528800(0000) GS:ffff88082e380000(0000) knlGS:0000000000000000
[154460.571213] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[154460.577235] CR2: 00007f945954d000 CR3: 00000003e5342000 CR4: 00000000001406e0
[154460.584692] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[154460.592147] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[154460.599605] Stack:
[154460.601770]  ffff8807cdd27af0 ffff88080838b800 ffff88080b1ee930 ffff8807cdd27b90
[154460.609576]  ffffffff812f7fb0 ffff880231a2e1c0 ffff8807cdd27b50 ffffffff811d7e7c
[154460.617356]  ffff8801c3b0ed20 ffffffff812f8280 0000000000000000 ffff88010eaef780
[154460.625134] Call Trace:
[154460.627752]  [<ffffffff812f7fb0>] ? do_async_commit+0x40/0x40
[154460.633775]  [<ffffffff811d7e7c>] iget5_locked+0x7c/0x1c0
[154460.639440]  [<ffffffff812f8280>] ? create_pinned_em+0x130/0x130
[154460.645733]  [<ffffffff813033cb>] btrfs_iget+0x4b/0x6a0
[154460.651218]  [<ffffffff81313806>] ? release_extent_buffer+0x26/0xc0
[154460.657781]  [<ffffffff813195c6>] ? free_extent_buffer+0x46/0x90
[154460.664072]  [<ffffffff813041de>] btrfs_lookup_dentry+0x3ee/0x520
[154460.670454]  [<ffffffff8130431d>] btrfs_lookup+0xd/0x30
[154460.675938]  [<ffffffff811c6778>] lookup_real+0x18/0x60
[154460.681422]  [<ffffffff811c6c28>] lookup_slow+0x58/0xe0
[154460.686908]  [<ffffffff811c95e5>] walk_component+0x1c5/0x430
[154460.692860]  [<ffffffff811c7586>] ? path_init+0x266/0x370
[154460.698525]  [<ffffffff811c9df8>] path_lookupat+0x58/0x100
[154460.704278]  [<ffffffff811cc479>] filename_lookup+0x99/0x150
[154460.710211]  [<ffffffff81187b71>] ? tlb_flush_mmu_free+0x31/0x50
[154460.716502]  [<ffffffff81188c07>] ? tlb_finish_mmu+0x17/0x50
[154460.722433]  [<ffffffff811cc0fd>] ? getname_flags+0x6d/0x1f0
[154460.728363]  [<ffffffff811cc5d1>] user_path_at_empty+0x31/0x40
[154460.734475]  [<ffffffff811c1a7e>] vfs_fstatat+0x4e/0xa0
[154460.739960]  [<ffffffff811c1f75>] SYSC_newfstatat+0x15/0x30
[154460.745817]  [<ffffffff81191b57>] ? vm_munmap+0x47/0x60
[154460.751314]  [<ffffffff811c2019>] SyS_newfstatat+0x9/0x10
[154460.756979]  [<ffffffff819dfd5b>] entry_SYSCALL_64_fastpath+0x13/0x8f
[154460.763718] Code: 48 8b 3e 48 85 ff 74 35 49 89 f6 49 89 d5 49 89 cc 48 81 ef e0 00 00 00 48 89 fb 75 0e eb 1e 48 89 fb 48 81 eb e0 00 00 00 74 12 <4c> 39 7b 28 74 1d 48 8b bb e0 00 00 00 48 85 ff 75 e2 31 c0 48
[154460.784196] RIP  [<ffffffff811d6bcf>] find_inode+0x3f/0xc0
[154460.789965]  RSP <ffff8807cdd27ad8>
[154460.799258] ---[ end trace 108fc543c76a3118 ]---

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | 
