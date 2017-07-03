Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33622 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbdGCBUz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jul 2017 21:20:55 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1dRq2m-0005Ct-C6
        for linux-btrfs@vger.kernel.org; Mon, 03 Jul 2017 03:20:52 +0200
Date: Mon, 3 Jul 2017 03:20:52 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: WARN_ON(rc->block_group->reserved > 0)
Message-ID: <20170703012052.kc3wr6c6znrzdh3d@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
I got a WARN_ON(rc->block_group->reserved > 0) on for-4.13 -- just
letting you guys know, as there were related fixes recently.

I'm on late 4.12-rc7 + kdave/for-4.13-part1 + v4 of Qu's chunk check +
unrelated.  Filesystem has ssd,compress=lzo.

Jul  3 02:01:56 umbar kernel: [169904.878882] BTRFS info (device sda1): relocating block group 2594583871488 flags metadata
Jul  3 02:03:05 umbar kernel: [169973.953332] BTRFS info (device sda1): found 27955 extents
Jul  3 02:03:05 umbar kernel: [169974.031514] ------------[ cut here ]------------
Jul  3 02:03:05 umbar kernel: [169974.031525] WARNING: CPU: 5 PID: 19695 at fs/btrfs/relocation.c:4408 btrfs_relocate_block_group+0x23b/0x250
Jul  3 02:03:05 umbar kernel: [169974.031526] Modules linked in: veth ntfs vfat msdos fat dm_mod tun arc4 rtl8xxxu mac80211 cp210x pl2303 usbserial cfg80211 rfkill nouveau video ttm
Jul  3 02:03:05 umbar kernel: [169974.031543] CPU: 5 PID: 19695 Comm: btrfs Not tainted 4.12.0-rc7-debug-00168-g9bb9281b642d #1
Jul  3 02:03:05 umbar kernel: [169974.031544] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
Jul  3 02:03:05 umbar kernel: [169974.031546] task: ffff88014f7e7140 task.stack: ffffc9000ad38000
Jul  3 02:03:05 umbar kernel: [169974.031550] RIP: 0010:btrfs_relocate_block_group+0x23b/0x250
Jul  3 02:03:05 umbar kernel: [169974.031552] RSP: 0018:ffffc9000ad3bbc8 EFLAGS: 00010206
Jul  3 02:03:05 umbar kernel: [169974.031554] RAX: ffff880215931c00 RBX: ffff88021540b800 RCX: 0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.031555] RDX: 0000000000000000 RSI: ffff880128b368c0 RDI: ffff88022624c328
Jul  3 02:03:05 umbar kernel: [169974.031557] RBP: ffffc9000ad3bbf0 R08: 0000000000000000 R09: 0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.031558] R10: 0000024985400000 R11: 000000000000029c R12: ffff88022624c000
Jul  3 02:03:05 umbar kernel: [169974.031559] R13: 0000000000000000 R14: ffff88022624c328 R15: 0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.031561] FS:  00007eff5e88e8c0(0000) GS:ffff88022fd40000(0000) knlGS:0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.031563] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jul  3 02:03:05 umbar kernel: [169974.031564] CR2: 000055ee3873f000 CR3: 0000000115d06000 CR4: 00000000000006e0
Jul  3 02:03:05 umbar kernel: [169974.031565] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.031566] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Jul  3 02:03:05 umbar kernel: [169974.031567] Call Trace:
Jul  3 02:03:05 umbar kernel: [169974.031572]  btrfs_relocate_chunk+0x59/0x100
Jul  3 02:03:05 umbar kernel: [169974.031575]  btrfs_balance+0xb61/0x1380
Jul  3 02:03:05 umbar kernel: [169974.031578]  ? get_page_from_freelist+0x29c/0xd60
Jul  3 02:03:05 umbar kernel: [169974.031582]  btrfs_ioctl_balance+0x30f/0x380
Jul  3 02:03:05 umbar kernel: [169974.031585]  btrfs_ioctl+0xe16/0x27f0
Jul  3 02:03:05 umbar kernel: [169974.031588]  ? lru_cache_add_active_or_unevictable+0x31/0xb0
Jul  3 02:03:05 umbar kernel: [169974.031591]  ? __handle_mm_fault+0x9bd/0xde0
Jul  3 02:03:05 umbar kernel: [169974.031595]  do_vfs_ioctl+0x9c/0x5e0
Jul  3 02:03:05 umbar kernel: [169974.031599]  ? __do_page_fault+0x21a/0x430
Jul  3 02:03:05 umbar kernel: [169974.031601]  SyS_ioctl+0x86/0xa0
Jul  3 02:03:05 umbar kernel: [169974.031605]  entry_SYSCALL_64_fastpath+0x17/0x98
Jul  3 02:03:05 umbar kernel: [169974.031607] RIP: 0033:0x7eff5d930d97
Jul  3 02:03:05 umbar kernel: [169974.031608] RSP: 002b:00007ffec49ab148 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
Jul  3 02:03:05 umbar kernel: [169974.031610] RAX: ffffffffffffffda RBX: 00007eff5dbe9b00 RCX: 00007eff5d930d97
Jul  3 02:03:05 umbar kernel: [169974.031612] RDX: 00007ffec49ab1d8 RSI: 00000000c4009420 RDI: 0000000000000003
Jul  3 02:03:05 umbar kernel: [169974.031613] RBP: 0000000000008041 R08: 00005601cf50e000 R09: 0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.031614] R10: 0000000000000541 R11: 0000000000000206 R12: 0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.031615] R13: 00007eff5dbe9b58 R14: 0000000000000000 R15: 0000000000008060
Jul  3 02:03:05 umbar kernel: [169974.031617] Code: ff 31 f6 48 8b 78 30 e8 04 59 d2 ff c6 83 b0 05 00 00 01 e9 6d ff ff ff 41 bd f4 ff ff ff e9 4a fe ff ff 44 89 f8 e9 9e fe ff ff <0f> ff eb 9f 0f ff eb 94 41 89 c5 e9 a2 fe ff ff 0f 1f 44 00 00 
Jul  3 02:03:05 umbar kernel: [169974.031652] ---[ end trace 76e66417695bd009 ]---
Jul  3 02:03:05 umbar kernel: [169974.612790] ------------[ cut here ]------------
Jul  3 02:03:05 umbar kernel: [169974.612797] WARNING: CPU: 3 PID: 215 at fs/btrfs/extent-tree.c:134 btrfs_put_block_group+0x56/0x70
Jul  3 02:03:05 umbar kernel: [169974.612798] Modules linked in: veth ntfs vfat msdos fat dm_mod tun arc4 rtl8xxxu mac80211 cp210x pl2303 usbserial cfg80211 rfkill nouveau video ttm
Jul  3 02:03:05 umbar kernel: [169974.612808] CPU: 3 PID: 215 Comm: btrfs-cleaner Tainted: G        W       4.12.0-rc7-debug-00168-g9bb9281b642d #1
Jul  3 02:03:05 umbar kernel: [169974.612809] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
Jul  3 02:03:05 umbar kernel: [169974.612810] task: ffff880221a12240 task.stack: ffffc9000164c000
Jul  3 02:03:05 umbar kernel: [169974.612811] RIP: 0010:btrfs_put_block_group+0x56/0x70
Jul  3 02:03:05 umbar kernel: [169974.612812] RSP: 0018:ffffc9000164fe20 EFLAGS: 00010206
Jul  3 02:03:05 umbar kernel: [169974.612813] RAX: ffff880221a12240 RBX: ffff88022624c000 RCX: 0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.612814] RDX: ffff880221a12240 RSI: 0000000000000282 RDI: ffff880215931c00
Jul  3 02:03:05 umbar kernel: [169974.612814] RBP: ffffc9000164fe28 R08: 0000000000000000 R09: 0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.612815] R10: 0000000000000000 R11: 00000000000002d2 R12: ffff880215931c00
Jul  3 02:03:05 umbar kernel: [169974.612816] R13: ffff8802217cfe00 R14: ffff8802217cfed0 R15: ffff880215931d28
Jul  3 02:03:05 umbar kernel: [169974.612817] FS:  0000000000000000(0000) GS:ffff88022fcc0000(0000) knlGS:0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.612817] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jul  3 02:03:05 umbar kernel: [169974.612818] CR2: 00007f36591435d8 CR3: 00000002141d2000 CR4: 00000000000006e0
Jul  3 02:03:05 umbar kernel: [169974.612819] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul  3 02:03:05 umbar kernel: [169974.612819] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Jul  3 02:03:05 umbar kernel: [169974.612820] Call Trace:
Jul  3 02:03:05 umbar kernel: [169974.612823]  btrfs_delete_unused_bgs+0x23c/0x3b0
Jul  3 02:03:05 umbar kernel: [169974.612825]  ? __schedule+0x1df/0x800
Jul  3 02:03:05 umbar kernel: [169974.612827]  cleaner_kthread+0x167/0x180
Jul  3 02:03:05 umbar kernel: [169974.612829]  kthread+0x11b/0x140
Jul  3 02:03:05 umbar kernel: [169974.612830]  ? __btree_submit_bio_start+0x10/0x10
Jul  3 02:03:05 umbar kernel: [169974.612831]  ? kthread_create_on_node+0x40/0x40
Jul  3 02:03:05 umbar kernel: [169974.612833]  ret_from_fork+0x22/0x30
Jul  3 02:03:05 umbar kernel: [169974.612833] Code: 48 8b bf e0 00 00 00 e8 49 77 e0 ff 48 89 df e8 41 77 e0 ff 5b 5d c3 f3 c3 0f ff 66 2e 0f 1f 84 00 00 00 00 00 eb d6 0f ff eb bf <0f> ff 0f 1f 84 00 00 00 00 00 eb ba 0f 1f 40 00 66 2e 0f 1f 84 
Jul  3 02:03:05 umbar kernel: [169974.612849] ---[ end trace 76e66417695bd00a ]---

Not reproducible on demand. :(


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
