Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallback6.mail.ru ([94.100.176.134]:52254 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3BCRyV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Feb 2013 12:54:21 -0500
Received: from smtp47.i.mail.ru (smtp47.i.mail.ru [94.100.177.107])
	by fallback6.mail.ru (mPOP.Fallback_MX) with ESMTP id 880B7A571365
	for <linux-btrfs@vger.kernel.org>; Sun,  3 Feb 2013 21:42:07 +0400 (MSK)
Received: from [195.91.224.225] (port=20573 helo=401a0bf1)
	by smtp47.i.mail.ru with esmtpa (envelope-from <7c6f434c@mail.ru>)
	id 1U23ZT-00045x-Lw
	for linux-btrfs@vger.kernel.org; Sun, 03 Feb 2013 21:41:39 +0400
Date: Sun, 03 Feb 2013 21:48:33 +0400
From: Michael Raskin <7c6f434c@mail.ru>
To: linux-btrfs@vger.kernel.org
Subject: 
Reply-To: 7c6f434c@mail.ru
Mime-Version: 1.0
Content-type: text/plain; charset="UTF-8"
Message-Id: <E1U23ZT-00045x-Lw.7c6f434c-mail-ru@smtp47.i.mail.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have an btrfs-image of corrupted BtrFS partition

After btrfsck --repair, mount failed with segfault both before and after

No subvolumes

http://dev.mccme.ru/~raskin/btrfs.corruption.img.gz

[   41.169414] device label home-corrupted devid 1 transid 398696 /dev/sda
[   41.170974] btrfs: disk space caching is enabled
[   41.189699] btrfs: mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.
[   41.433117] parent transid verify failed on 88661934080 wanted 398697 found 398691
[   41.451047] parent transid verify failed on 88661934080 wanted 398697 found 398691
[   41.498321] ------------[ cut here ]------------
[   41.498326] kernel BUG at fs/btrfs/tree-log.c:1922!
[   41.498328] invalid opcode: 0000 [#1] SMP 
[   41.498331] Modules linked in: ppdev parport_pc i2c_piix4 i2c_core parport microcode raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear 8139cp 8139too mii
[   41.498347] CPU 0 
[   41.498350] Pid: 1580, comm: mount Not tainted 3.7.4-alt330-amd64 #2 Bochs Bochs
[   41.498352] RIP: 0010:[<ffffffff813ad1e2>]  [<ffffffff813ad1e2>] replay_one_buffer+0x141/0x29b
[   41.498366] RSP: 0000:ffff880006fcf928  EFLAGS: 00010286
[   41.498367] RAX: 00000000ffffffe4 RBX: ffff880006fcfaa8 RCX: 0000000060000000
[   41.498369] RDX: 0000000000000008 RSI: 0000000000000020 RDI: 0000000000000000
[   41.498370] RBP: ffff880006fcf9a8 R08: 00000000ffffffe4 R09: ffff880006fcf6c8
[   41.498371] R10: 0000000000000001 R11: ffff880006fcf958 R12: ffff880001f30560
[   41.498373] R13: 0000000000000000 R14: ffff880002a7d120 R15: ffff880002b78000
[   41.498374] FS:  0000000000000000(0000) GS:ffff880007200000(0063) knlGS:00000000f757d700
[   41.498376] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[   41.498377] CR2: 00000000083a3bb0 CR3: 00000000053f3000 CR4: 00000000000006f0
[   41.498381] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   41.498385] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   41.498386] Process mount (pid: 1580, threadinfo ffff880006fce000, task ffff880000a0ae00)
[   41.498387] Stack:
[   41.498388]  0000000000001000 0000000000001000 0000160000000000 0000000900000000
[   41.498391]  ffff880002b79800 0000800000000000 000000000090b0ad 0000000000000001
[   41.498393]  0000000000000000 ffff880006fcfa54 ffff880002a7d090 ffff880006fcfa54
[   41.498395] Call Trace:
[   41.498402]  [<ffffffff813a7e45>] walk_down_log_tree+0x1a9/0x35e
[   41.498404]  [<ffffffff813a8265>] walk_log_tree+0x99/0x1ce
[   41.498407]  [<ffffffff813aa32c>] btrfs_recover_log_trees+0x205/0x31b
[   41.498409]  [<ffffffff813ad0a1>] ? add_inode_ref+0x80e/0x80e
[   41.498412]  [<ffffffff8137df3b>] open_ctree+0x1492/0x184f
[   41.498419]  [<ffffffff8135f269>] btrfs_mount+0x382/0x525
[   41.498429]  [<ffffffff810fe530>] ? pcpu_next_pop+0x38/0x45
[   41.498431]  [<ffffffff810ff5a4>] ? pcpu_alloc+0x87b/0x8c5
[   41.498438]  [<ffffffff8114cbef>] ? alloc_vfsmnt+0x9e/0x187
[   41.498444]  [<ffffffff811380d9>] mount_fs+0x6b/0x14f
[   41.498447]  [<ffffffff810ff609>] ? __alloc_percpu+0xb/0xd
[   41.498449]  [<ffffffff8114e34d>] vfs_kern_mount+0x62/0xcf
[   41.498451]  [<ffffffff8114e42b>] do_kern_mount+0x48/0xd8
[   41.498453]  [<ffffffff8114ebad>] do_mount+0x6f2/0x755
[   41.498456]  [<ffffffff810fb4ff>] ? memdup_user+0x48/0x68
[   41.498459]  [<ffffffff810fb558>] ? strndup_user+0x39/0x4e
[   41.498463]  [<ffffffff81171577>] compat_sys_mount+0x213/0x24d
[   41.498467]  [<ffffffff8170c729>] ia32_do_call+0x13/0x13
[   41.498468] Code: fe e8 51 c9 ff ff 85 c0 74 04 0f 0b eb fe 48 8b 7b 20 4c 8d 4d b0 45 89 e8 4c 89 e1 4c 89 f2 4c 89 fe e8 1c dc ff ff 85 c0 74 04 <0f> 0b eb fe 81 7d ac 00 80 00 00 75 18 48 8b 7b 20 48 8b 55 b0 
[   41.498484] RIP  [<ffffffff813ad1e2>] replay_one_buffer+0x141/0x29b
[   41.498486]  RSP <ffff880006fcf928>
[   41.498489] ---[ end trace b03c7e7060c0017c ]---

-o recovery,ro didn't help

btrfs-zero-log didn't help

-o recovery,ro,clear_cache after btrfs-zero-log worked

Is the image of any use or should I just delete it?

Thanks
Michael Raskin



