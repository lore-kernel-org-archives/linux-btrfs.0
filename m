Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gst.name ([78.46.150.186]:48828 "EHLO gst.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab3IYHDj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 03:03:39 -0400
Date: Wed, 25 Sep 2013 08:56:47 +0200
From: Guenther Starnberger <linux-btrfs@gst.priv.at>
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/relocation.c:1060 during rebalancing
Message-ID: <20130925065647.GC13842@gst.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On one of my btrfs filesystems I'm encountering a reproducable kernel bug
during rebalancing. This issue originally appeared on Linux 3.11.1, but I am
also able to reproduce it in a VM using btrfs-next (c024ca6) and Linux
3.12-rc2 (4a10c2a).

I did the following operations (in chronological order) on the filesystem
before this issue appeared, so they might be responsible for putting the
filesystem into a bad state. However, according to fsck the filesystem looks
fine.

- Regular deduplications with bedup.

- Mounting the previously uncompressed filesystem with the lzo compression
  option and then using defrag to defrag (and compress) each file.

- Running out of diskspace during a bedup run with size cutoff 0, although the
  actual disk usage should be less than 50%. Based on the suggestions in the
  FAQ (http://goo.gl/qCgZR) I decided to try rebalancing the filesystem.

- Rebalance the filesystem (btrfs fi balance /mountpoint -dusage=5) which lead
  to the kernel bug. Subsequent rebalancing runs after reboots and with
  different kernel versions exhibit the same problem.

Log output:

4,694,2141772062,-;------------[ cut here ]------------
2,695,2141773153,-;kernel BUG at fs/btrfs/relocation.c:1060!
4,696,2141774227,-;invalid opcode: 0000 [#1] PREEMPT SMP 
4,697,2141775124,-;Modules linked in: btrfs raid6_pq crc32c libcrc32c zlib_deflate xor xts gf128mul dm_crypt dm_mod usb_storage snd_intel8x0 snd_ac97_codec pcspkr psmouse i2c_piix4 i2c_core ppdev ac97_bus e1000 snd_pcm snd_page_alloc microcode snd_timer intel_agp joydev evdev parport_pc snd serio_raw intel_gtt ac parport soundcore battery button mperf processor ext4 crc16 mbcache jbd2 sr_mod cdrom sd_mod ata_generic pata_acpi hid_generic usbhid hid ata_piix ahci libahci ohci_pci ohci_hcd ehci_pci ehci_hcd usbcore usb_common libata scsi_mod
4,698,2141775124,-;CPU: 0 PID: 480 Comm: btrfs-balance Not tainted 3.11.0-1-90676-gc024ca6-dirty #1
4,699,2141775124,-;Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
4,700,2141775124,-;task: ffff88007c2d3b10 ti: ffff880068d44000 task.ti: ffff880068d44000
4,701,2141775124,-;RIP: 0010:[<ffffffffa04f5d3a>]  [<ffffffffa04f5d3a>] build_backref_tree+0x112a/0x11d0 [btrfs]
4,702,2141775124,-;RSP: 0018:ffff880068d45ab8  EFLAGS: 00010246
4,703,2141775124,-;RAX: 0000000000000000 RBX: ffff88007c2ef800 RCX: ffff88004db48dd0
4,704,2141775124,-;RDX: ffff880068d45b30 RSI: ffff88007c2ef820 RDI: ffff88004db48dc0
4,705,2141775124,-;RBP: ffff880068d45ba0 R08: ffff88004dae7a80 R09: ffff880068d45a70
4,706,2141775124,-;R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
4,707,2141775124,-;R13: ffff8800787e3900 R14: ffff88004dae7200 R15: ffff88004db48dd0
4,708,2141775124,-;FS:  0000000000000000(0000) GS:ffff88007fa00000(0000) knlGS:0000000000000000
4,709,2141775124,-;CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
4,710,2141775124,-;CR2: 00007ffa7bbd9408 CR3: 00000000764a4000 CR4: 00000000000006f0
4,711,2141775124,-;Stack:
4,712,2141775124,-; ffff88004dae7480 0000000000000000 ffff88004db48560 ffff88004dae7a80
4,713,2141775124,-; ffff88004dae7a80 ffff8800787e3900 ffff88007c2ee800 ffff8800787e3120
4,714,2141775124,-; ffff88004dae76c0 ffff88007c2ef920 ffff88004dae7480 ffff88007c2ef924
4,715,2141775124,-;Call Trace:
4,716,2141775124,-; [<ffffffffa04f7228>] relocate_tree_blocks+0x1d8/0x630 [btrfs]
4,717,2141775124,-; [<ffffffffa04f8730>] relocate_block_group+0x280/0x690 [btrfs]
4,718,2141775124,-; [<ffffffffa04f8cdd>] btrfs_relocate_block_group+0x19d/0x2e0 [btrfs]
4,719,2141775124,-; [<ffffffffa04d0938>] btrfs_relocate_chunk.isra.27+0x68/0x780 [btrfs]
4,720,2141775124,-; [<ffffffffa0489d88>] ? btrfs_search_slot+0x498/0x970 [btrfs]
4,721,2141775124,-; [<ffffffffa04c5fb9>] ? release_extent_buffer+0xa9/0xd0 [btrfs]
4,722,2141775124,-; [<ffffffffa04cbbcf>] ? free_extent_buffer+0x4f/0xa0 [btrfs]
4,723,2141775124,-; [<ffffffffa04d3ee3>] btrfs_balance+0x913/0xeb0 [btrfs]
4,724,2141775124,-; [<ffffffffa04d44f0>] balance_kthread+0x70/0x80 [btrfs]
4,725,2141775124,-; [<ffffffffa04d4480>] ? btrfs_balance+0xeb0/0xeb0 [btrfs]
4,726,2141775124,-; [<ffffffff81083680>] kthread+0xc0/0xd0
4,727,2141775124,-; [<ffffffff810835c0>] ? kthread_create_on_node+0x120/0x120
4,728,2141775124,-; [<ffffffff814ddf2c>] ret_from_fork+0x7c/0xb0
4,729,2141775124,-; [<ffffffff810835c0>] ? kthread_create_on_node+0x120/0x120
4,730,2141775124,-;Code: 4c 89 ef e8 b9 f1 f8 ff 48 8b bd 50 ff ff ff e8 ad f1 f8 ff 48 83 bd 30 ff ff ff 00 0f 85 0c fd ff ff 31 c0 e9 ae ef ff ff 0f 0b <0f> 0b 48 8b 85 30 ff ff ff 49 8d 7e 20 48 8b 70 18 48 89 c2 e8 
1,731,2141775124,-;RIP  [<ffffffffa04f5d3a>] build_backref_tree+0x112a/0x11d0 [btrfs]
4,732,2141775124,-; RSP <ffff880068d45ab8>
4,733,2141819898,-;---[ end trace fa708b06a85e0e77 ]---

This issue looks very similar to
https://bugzilla.novell.com/show_bug.cgi?id=839952 but the cause for the issue
in the bug tracker should have been fixed in b6c60c8 which seems to be part of
the btrfs-next tree. I can still reproduce the problem on btrfs-next, so it's
either a different issue, or not fully fixed yet.

- Guenther
