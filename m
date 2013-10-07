Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gst.name ([78.46.150.186]:59080 "EHLO gst.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab3JGA1p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Oct 2013 20:27:45 -0400
Date: Mon, 7 Oct 2013 02:27:35 +0200
From: Guenther Starnberger <linux-btrfs@gst.priv.at>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: kernel BUG at fs/btrfs/relocation.c:1060 during rebalancing
Message-ID: <20131007002735.GB14037@gst.name>
References: <20130925065647.GC13842@gst.name>
 <20130925144641.GW6810@twin.jikos.cz>
 <20130926052607.GA14037@gst.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130926052607.GA14037@gst.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 26, 2013 at 07:26:07AM +0200, Guenther Starnberger wrote:

> Yes - this also happens on 3.12-rc kernels. Here's the stacktrace for 4b97280
> (which is several commits ahead of 3.12-rc2):

As an update to my previous mail: I just tried to continue the balance with an
updated btrfs-next kernel (4380ae355c5c17c150d29bf0c07f44046102ca2e) but I'm
still seeing the same issue:

[  273.810775] btrfs: disk space caching is enabled
[  273.812257] btrfs: has skinny extents
[  291.906125] BTRFS debug (device dm-0): unlinked 1 orphans
[  291.979115] btrfs: continuing balance
[  296.214254] btrfs: relocating block group 1542996361216 flags 1
[  411.032805] btrfs: found 18 extents
[  449.598891] ------------[ cut here ]------------
[  449.600360] kernel BUG at fs/btrfs/relocation.c:1060!
[  449.601603] invalid opcode: 0000 [#1] PREEMPT SMP 
[  449.601971] Modules linked in: btrfs raid6_pq crc32c libcrc32c zlib_deflate xor xts gf128mul dm_crypt dm_mod usb_storage snd_intel8x0 snd_ac97_codec ac97_bus psmouse snd_pcm snd_page_alloc snd_timer ppdev microcode snd joydev evdev pcspkr serio_raw parport_pc parport i2c_piix4 intel_agp intel_gtt mperf i2c_core e1000 soundcore processor battery button ac ext4 crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom sd_mod ata_generic pata_acpi ohci_pci ata_piix ahci libahci ohci_hcd ehci_pci ehci_hcd usbcore usb_common libata scsi_mod
[  449.601971] CPU: 0 PID: 390 Comm: btrfs-balance Not tainted 3.11.0-1-90707-g4380ae3-dirty #1
[  449.601971] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  449.601971] task: ffff88007ad45cd0 ti: ffff8800786e4000 task.ti: ffff8800786e4000
[  449.601971] RIP: 0010:[<ffffffffa04f5f1a>]  [<ffffffffa04f5f1a>] build_backref_tree+0x112a/0x11d0 [btrfs]
[  449.601971] RSP: 0018:ffff8800786e5ab8  EFLAGS: 00010246
[  449.601971] RAX: 0000000000000000 RBX: ffff88007ad6e800 RCX: ffff8800780c81d0
[  449.601971] RDX: ffff8800786e5b30 RSI: ffff88007ad6e820 RDI: ffff8800780c81c0
[  449.601971] RBP: ffff8800786e5ba0 R08: ffff88007806d000 R09: ffff8800786e5a70
[  449.601971] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  449.601971] R13: ffff88007888a120 R14: ffff88007806d600 R15: ffff8800780c81d0
[  449.601971] FS:  0000000000000000(0000) GS:ffff88007fa00000(0000) knlGS:0000000000000000
[  449.601971] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  449.601971] CR2: 00007fe6529864f0 CR3: 000000007bb99000 CR4: 00000000000006f0
[  449.601971] Stack:
[  449.601971]  ffff88007806da80 0000000000000000 ffff8800780c8060 ffff88007806d000
[  449.601971]  ffff88007806d000 ffff88007888a120 ffff88007ad6e000 ffff88007888a240
[  449.601971]  ffff88007806d340 ffff88007ad6e920 ffff88007806da80 ffff88007ad6e924
[  449.601971] Call Trace:
[  449.601971]  [<ffffffffa04f7408>] relocate_tree_blocks+0x1d8/0x630 [btrfs]
[  449.601971]  [<ffffffffa04f8920>] relocate_block_group+0x280/0x690 [btrfs]
[  449.601971]  [<ffffffffa04f8ecd>] btrfs_relocate_block_group+0x19d/0x2e0 [btrfs]
[  449.601971]  [<ffffffffa04d0ca8>] btrfs_relocate_chunk.isra.28+0x68/0x780 [btrfs]
[  449.601971]  [<ffffffffa0489dd8>] ? btrfs_search_slot+0x498/0x970 [btrfs]
[  449.601971]  [<ffffffffa04c6499>] ? release_extent_buffer+0xa9/0xd0 [btrfs]
[  449.601971]  [<ffffffffa04cbdff>] ? free_extent_buffer+0x4f/0xa0 [btrfs]
[  449.601971]  [<ffffffffa04d40c3>] btrfs_balance+0x913/0xeb0 [btrfs]
[  449.601971]  [<ffffffffa04d46d0>] balance_kthread+0x70/0x80 [btrfs]
[  449.601971]  [<ffffffffa04d4660>] ? btrfs_balance+0xeb0/0xeb0 [btrfs]
[  449.601971]  [<ffffffff81083680>] kthread+0xc0/0xd0
[  449.601971]  [<ffffffff810835c0>] ? kthread_create_on_node+0x120/0x120
[  449.601971]  [<ffffffff814ddeac>] ret_from_fork+0x7c/0xb0
[  449.601971]  [<ffffffff810835c0>] ? kthread_create_on_node+0x120/0x120
[  449.601971] Code: 4c 89 ef e8 29 f0 f8 ff 48 8b bd 50 ff ff ff e8 1d f0 f8 ff 48 83 bd 30 ff ff ff 00 0f 85 0c fd ff ff 31 c0 e9 ae ef ff ff 0f 0b <0f> 0b 48 8b 85 30 ff ff ff 49 8d 7e 20 48 8b 70 18 48 89 c2 e8 
[  449.601971] RIP  [<ffffffffa04f5f1a>] build_backref_tree+0x112a/0x11d0 [btrfs]
[  449.601971]  RSP <ffff8800786e5ab8>
[  449.645464] ---[ end trace 0478746bd226d078 ]---

- Guenther
