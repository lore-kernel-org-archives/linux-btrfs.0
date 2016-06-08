Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay05.ispgateway.de ([80.67.31.100]:35005 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbcFHO5n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jun 2016 10:57:43 -0400
Received: from [77.13.71.57] (helo=hermione.invalid)
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
	(Exim 4.84)
	(envelope-from <envelope@m-berberich.de>)
	id 1bAevK-0005Dm-HX
	for linux-btrfs@vger.kernel.org; Wed, 08 Jun 2016 16:57:38 +0200
Received: from berberic by hermione.invalid with local (Exim 4.87)
	(envelope-from <envelope@m-berberich.de>)
	id 1bAevK-0003KM-1s
	for linux-btrfs@vger.kernel.org; Wed, 08 Jun 2016 16:57:38 +0200
Date: Wed, 8 Jun 2016 16:57:38 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: 4.6.1 crash probably during find
Message-ID: <20160608145738.GA6277@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

System crashed. SysRq stilled worked.
btrfs check does not find error on any filesystem.

[82275.348754] general protection fault: 0000 [#1] PREEMPT SMP 
[82275.354640] Modules linked in: cp210x usbserial rc_digittrade mt2060 af9013 uas intel_rapl kvm_intel dvb_usb_af9015 dvb_usb_v2 dvb_core kvm rc_core irqbypass input_leds ghash_clmulni_intel usb_storage serio_raw it87 hwmon_vid firewire_sbp2 firewire_core ppdev lp autofs4
[82275.379649] CPU: 3 PID: 21655 Comm: find Not tainted 4.6.1 #2
[82275.385604] Hardware name: Gigabyte Technology Co., Ltd. H87-HD3/H87-HD3, BIOS F10 08/18/2015
[82275.394404] task: ffff8802a6d1b500 ti: ffff88025586c000 task.ti: ffff88025586c000
[82275.402127] RIP: 0010:[<ffffffff811d6bff>]  [<ffffffff811d6bff>] find_inode+0x3f/0xc0
[82275.410224] RSP: 0018:ffff88025586fad8  EFLAGS: 00010286
[82275.415708] RAX: 0000000000000000 RBX: f7ff88021d39bd50 RCX: ffff88025586fb90
[82275.423074] RDX: ffffffff812f7fe0 RSI: ffff88080acf87b8 RDI: f7ff88021d39be30
[82275.430439] RBP: ffff88025586fb08 R08: ffff88025586fb90 R09: ffffffff812cca91
[82275.437810] R10: ffff88080a2e1100 R11: 0000000000000002 R12: ffff88025586fb90
[82275.445176] R13: ffffffff812f7fe0 R14: ffff88080acf87b8 R15: ffff88080815e800
[82275.452540] FS:  00007f66c9121800(0000) GS:ffff88082e2c0000(0000) knlGS:0000000000000000
[82275.460893] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[82275.466824] CR2: 0000558caf8adde8 CR3: 000000025e2b6000 CR4: 00000000001406e0
[82275.474189] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[82275.481560] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[82275.488927] Stack:
[82275.491002]  ffff88025586faf0 ffff88080815e800 ffff88080acf87b8 ffff88025586fb90
[82275.498684]  ffffffff812f7fe0 ffff8803cfc1eb60 ffff88025586fb50 ffffffff811d7eac
[82275.506366]  ffff8807c61ca230 ffffffff812f82b0 0000000000000000 ffff880225bb1300
[82275.514048] Call Trace:
[82275.516574]  [<ffffffff812f7fe0>] ? do_async_commit+0x40/0x40
[82275.522507]  [<ffffffff811d7eac>] iget5_locked+0x7c/0x1c0
[82275.528079]  [<ffffffff812f82b0>] ? create_pinned_em+0x130/0x130
[82275.534282]  [<ffffffff813033fb>] btrfs_iget+0x4b/0x6a0
[82275.539679]  [<ffffffff81313856>] ? release_extent_buffer+0x26/0xc0
[82275.546147]  [<ffffffff81319616>] ? free_extent_buffer+0x46/0x90
[82275.552349]  [<ffffffff8130420e>] btrfs_lookup_dentry+0x3ee/0x520
[82275.558642]  [<ffffffff8130434d>] btrfs_lookup+0xd/0x30
[82275.564038]  [<ffffffff811c67a8>] lookup_real+0x18/0x60
[82275.569441]  [<ffffffff811c6c58>] lookup_slow+0x58/0xe0
[82275.574836]  [<ffffffff811c9615>] walk_component+0x1c5/0x430
[82275.580678]  [<ffffffff811c75b6>] ? path_init+0x266/0x370
[82275.586252]  [<ffffffff811c9e28>] path_lookupat+0x58/0x100
[82275.591914]  [<ffffffff811cc4a9>] filename_lookup+0x99/0x150
[82275.597758]  [<ffffffff812cca91>] ? btrfs_free_path+0x21/0x30
[82275.603690]  [<ffffffff812fb6f8>] ? btrfs_real_readdir+0x198/0x5e0
[82275.610070]  [<ffffffff811cc12d>] ? getname_flags+0x6d/0x1f0
[82275.615912]  [<ffffffff811cc601>] user_path_at_empty+0x31/0x40
[82275.621937]  [<ffffffff811c1aae>] vfs_fstatat+0x4e/0xa0
[82275.627330]  [<ffffffff811d9de9>] ? __fd_install+0x59/0x100
[82275.633082]  [<ffffffff811c1fa5>] SYSC_newfstatat+0x15/0x30
[82275.638835]  [<ffffffff811da519>] ? f_dupfd+0x69/0x80
[82275.644050]  [<ffffffff811cec74>] ? SyS_fcntl+0x114/0x540
[82275.649621]  [<ffffffff811c2049>] SyS_newfstatat+0x9/0x10
[82275.655193]  [<ffffffff819e011b>] entry_SYSCALL_64_fastpath+0x13/0x8f
[82275.661843] Code: 48 8b 3e 48 85 ff 74 35 49 89 f6 49 89 d5 49 89 cc 48 81 ef e0 00 00 00 48 89 fb 75 0e eb 1e 48 89 fb 48 81 eb e0 00 00 00 74 12 <4c> 39 7b 28 74 1d 48 8b bb e0 00 00 00 48 85 ff 75 e2 31 c0 48 
[82275.682196] RIP  [<ffffffff811d6bff>] find_inode+0x3f/0xc0
[82275.687873]  RSP <ffff88025586fad8>
[82275.696634] ---[ end trace 50dd42c58e9d164c ]---
[82275.701395] note: find[21655] exited with preempt_count 1

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | 
