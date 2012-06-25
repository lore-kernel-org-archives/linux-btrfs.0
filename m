Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54742 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab2FYS3j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 14:29:39 -0400
Received: from merkaba.localnet (ppp-88-217-126-64.dynamic.mnet-online.de [88.217.126.64])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id CD8AA187
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2012 20:29:37 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: 3.5-rc4: BTRFS unmountable after hard lockup
Date: Mon, 25 Jun 2012 20:29:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201206252029.34545.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I got a X server / drm related crash or hard lockup. After I rebooted I
tried to mount the BTRFS on my esata disk. It has big metadata 
(mkfs.btrfs -l 32768 -n 32768).


I got:

[   43.764274] ata5: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 0xe frozen
[   43.764278] ata5: irq_stat 0x00000040, connection status changed
[   43.764281] ata5: SError: { PHYRdyChg CommWake DevExch }
[   43.764287] ata5: hard resetting link
[   46.978917] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   46.989402] ata5.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   46.989407] ata5.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   46.990609] ata5.00: ATA-8: Hitachi HTS545050B9A300, PB4OC60G, max UDMA/133
[   46.990613] ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[   46.991925] ata5.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   46.991930] ata5.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   46.993155] ata5.00: configured for UDMA/133
[   47.003851] ata5: EH complete
[   47.003958] scsi 4:0:0:0: Direct-Access     ATA      Hitachi HTS54505 PB4O PQ: 0 ANSI: 5
[   47.004135] sd 4:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   47.004191] sd 4:0:0:0: [sdb] Write Protect is off
[   47.004194] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   47.004218] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   47.050154]  sdb: sdb1
[   47.050390] sd 4:0:0:0: [sdb] Attached SCSI disk
[   58.100217] CPU1: Package power limit notification (total events = 1)
[   58.100220] CPU3: Package power limit notification (total events = 1)
[   58.100221] CPU2: Package power limit notification (total events = 1)
[   58.100225] CPU0: Package power limit notification (total events = 1)
[   58.103689] CPU1: Package power limit normal
[   58.103691] CPU3: Package power limit normal
[   58.103692] CPU2: Package power limit normal
[   58.103695] CPU0: Package power limit normal
[  249.200560] device label daten devid 1 transid 2194 /dev/sdb1
[  249.201186] btrfs: use lzo compression
[  249.201192] btrfs: disk space caching is enabled
[  249.241975] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
[  251.620610] ------------[ cut here ]------------
[  251.620693] kernel BUG at fs/btrfs/inode.c:3758!
[  251.620767] invalid opcode: 0000 [#1] PREEMPT SMP 
[  251.620842] CPU 1 
[  251.620960] 
[  251.620988] Pid: 3430, comm: mount Tainted: G           O 3.5.0-rc4-tp520 #1 LENOVO 42433WG/42433WG
[  251.621149] RIP: 0010:[<ffffffffa023a93f>]  [<ffffffffa023a93f>] btrfs_evict_inode+0xcd/0x278 [btrfs]
[  251.621289] RSP: 0018:ffff880157033a58  EFLAGS: 00010246
[  251.621370] RAX: 0000000000000000 RBX: ffff8801c1747800 RCX: 000000000000001a
[  251.621477] RDX: 000000000000001a RSI: 0000000000000002 RDI: ffff880157032000
[  251.621584] RBP: ffff8800851c5d20 R08: ffff880157033978 R09: 0000000000000002
[  251.621691] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffa027a230
[  251.621799] R13: 0000000000008000 R14: 0000000000008000 R15: ffff8801c1740400
[  251.621907] FS:  00007ffa1402e7e0(0000) GS:ffff88021e240000(0000) knlGS:0000000000000000
[  251.622029] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  251.622116] CR2: ffffffffff600400 CR3: 000000014a97d000 CR4: 00000000000407e0
[  251.622224] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  251.622332] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  251.622440] Process mount (pid: 3430, threadinfo ffff880157032000, task ffff88015983be70)
[  251.622562] Stack:
[  251.622597]  0000000000000000 ffff8800851c5da8 ffff8800851c5d20 ffff8800851c5d20
[  251.622711]  ffff8800851c5e18 ffffffffa027a230 ffff8800851c5d20 ffff8801c1742c00
[  251.622825]  ffff8801c1740400 ffffffff8111787c ffff88020dca8cf0 ffff8801c1747800
[  251.622936] Call Trace:
[  251.622982]  [<ffffffff8111787c>] ? evict+0xa3/0x153
[  251.623077]  [<ffffffffa0260ef6>] ? fixup_inode_link_counts+0xd2/0xfb [btrfs]
[  251.623201]  [<ffffffffa022ee3c>] ? btrfs_read_fs_root_no_name+0x92/0x24e [btrfs]
[  251.623331]  [<ffffffffa0261db3>] ? btrfs_recover_log_trees+0x207/0x2dd [btrfs]
[  251.623458]  [<ffffffffa0260a3b>] ? replay_one_extent+0x439/0x439 [btrfs]
[  251.623578]  [<ffffffffa0230fac>] ? open_ctree+0x1354/0x1680 [btrfs]
[  251.627492]  [<ffffffff811b60b0>] ? ida_get_new_above+0x16c/0x17d
[  251.631356]  [<ffffffffa02153fa>] ? btrfs_mount+0x3cb/0x516 [btrfs]
[  251.635197]  [<ffffffff810ef373>] ? alloc_pages_current+0xb2/0xcd
[  251.638971]  [<ffffffff811078c9>] ? mount_fs+0x61/0x144
[  251.642736]  [<ffffffff8111a390>] ? vfs_kern_mount+0x62/0xe3
[  251.646426]  [<ffffffff8111aa2a>] ? do_kern_mount+0x49/0xdd
[  251.650039]  [<ffffffff8111c20f>] ? do_mount+0x68a/0x710
[  251.653636]  [<ffffffff8111c3b5>] ? sys_mount+0x80/0xba
[  251.657204]  [<ffffffff813d53b9>] ? system_call_fastpath+0x16/0x1b
[  251.660791] Code: 00 48 83 ca ff 31 f6 48 89 ef e8 d8 05 01 00 48 8b 83 20 01 00 00 83 b8 40 0e 00 00 00 74 0e 48 8b 45 98 a8 
20 0f 85 7b 01 00 00 <0f> 0b 83 7d 48 00 74 0f 83 bb f8 00 00 00 00 0f 84 66 01 00 00 
[  251.668347] RIP  [<ffffffffa023a93f>] btrfs_evict_inode+0xcd/0x278 [btrfs]
[  251.672204]  RSP <ffff880157033a58>
[  251.698474] ---[ end trace 431fcd3e91e1f4fd ]---
[  265.799887] nepomukservices[2181]: segfault at 0 ip           (null) sp 00007fff403d0ca8 error 14 in 
nepomukservicestub[400000+7000]


BTRFS was not mounted. After trying to mount again, I got:

merkaba:~> ps aux | grep " D" | grep -v grep 
root      3446  0.0  0.0      0     0 ?        D    20:22   0:00 [btrfs-transacti]
root      4666  0.0  0.0  18640  1184 tty1     D+   20:24   0:00 mount /mnt/amazon-daten

Any hints how to get my disk mounted?

I have a fairly recent backup, but I would prefer when I do not have to
replay it. Its one of my expectations for a file system: be safe on sudden
write interruptions like power loss or crash.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
