Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gst.name ([78.46.150.186]:49451 "EHLO gst.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab3IZF0L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 01:26:11 -0400
Date: Thu, 26 Sep 2013 07:26:07 +0200
From: Guenther Starnberger <linux-btrfs@gst.priv.at>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/relocation.c:1060 during rebalancing
Message-ID: <20130926052607.GA14037@gst.name>
References: <20130925065647.GC13842@gst.name>
 <20130925144641.GW6810@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130925144641.GW6810@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 25, 2013 at 04:46:41PM +0200, David Sterba wrote:

> 3.12-rc really? I'd like to see the stacktrace then.

Yes - this also happens on 3.12-rc kernels. Here's the stacktrace for 4b97280
(which is several commits ahead of 3.12-rc2):

[  126.735598] btrfs: disk space caching is enabled
[  126.737038] btrfs: has skinny extents
[  144.769929] BTRFS debug (device dm-0): unlinked 1 orphans
[  144.836240] btrfs: continuing balance
[  153.441134] btrfs: relocating block group 1542996361216 flags 1
[  295.780293] btrfs: found 18 extents
[  310.107200] ------------[ cut here ]------------
[  310.108496] kernel BUG at fs/btrfs/relocation.c:1060!
[  310.109709] invalid opcode: 0000 [#1] PREEMPT SMP 
[  310.110268] Modules linked in: btrfs raid6_pq crc32c libcrc32c xor xts gf128mul dm_crypt dm_mod usb_storage psmouse ppdev e1000 evdev pcspkr serio_raw joydev microcode snd_intel8x0 snd_ac97_codec i2c_piix4 i2c_core ac97_bus snd_pcm snd_page_alloc snd_timer parport_pc parport snd soundcore intel_agp button battery processor ac intel_gtt ext4 crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom sd_mod ata_generic pata_acpi ohci_pci ata_piix ahci libahci ohci_hcd ehci_pci ehci_hcd usbcore usb_common libata scsi_mod
[  310.110268] CPU: 0 PID: 366 Comm: btrfs-balance Not tainted 3.12.0-1-00083-g4b97280-dirty #1
[  310.110268] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  310.110268] task: ffff880078b00000 ti: ffff880078afe000 task.ti: ffff880078afe000
[  310.110268] RIP: 0010:[<ffffffffa04f6e8a>]  [<ffffffffa04f6e8a>] build_backref_tree+0x112a/0x11d0 [btrfs]
[  310.110268] RSP: 0018:ffff880078affab8  EFLAGS: 00010246
[  310.110268] RAX: 0000000000000000 RBX: ffff8800784d4000 RCX: ffff88006a2a9d90
[  310.110268] RDX: ffff880078affb30 RSI: ffff8800784d4020 RDI: ffff88006a2a9d80
[  310.110268] RBP: ffff880078affba0 R08: ffff880077d07e00 R09: ffff880078affa70
[  310.110268] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  310.110268] R13: ffff880078c95d80 R14: ffff880077d07c80 R15: ffff88006a2a9d90
[  310.110268] FS:  0000000000000000(0000) GS:ffff88007fa00000(0000) knlGS:0000000000000000
[  310.110268] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  310.110268] CR2: 00007f51ca3af010 CR3: 000000007bf8d000 CR4: 00000000000006f0
[  310.110268] Stack:
[  310.110268]  ffff880077d07d00 0000000000000000 ffff88006a2a9320 ffff880077d07e00
[  310.110268]  ffff880077d07e00 ffff880078c95d80 ffff88007ad99000 ffff880078c95120
[  310.110268]  ffff880077d07bc0 ffff8800784d4120 ffff880077d07d00 ffff8800784d4124
[  310.110268] Call Trace:
[  310.110268]  [<ffffffffa04f8378>] relocate_tree_blocks+0x1d8/0x630 [btrfs]
[  310.110268]  [<ffffffffa04f9880>] relocate_block_group+0x280/0x690 [btrfs]
[  310.110268]  [<ffffffffa04f9e2d>] btrfs_relocate_block_group+0x19d/0x2e0 [btrfs]
[  310.110268]  [<ffffffffa04d1a88>] btrfs_relocate_chunk.isra.28+0x68/0x780 [btrfs]
[  310.110268]  [<ffffffffa048af08>] ? btrfs_search_slot+0x498/0x970 [btrfs]
[  310.110268]  [<ffffffffa04c73d9>] ? release_extent_buffer+0xa9/0xd0 [btrfs]
[  310.110268]  [<ffffffffa04ccd1f>] ? free_extent_buffer+0x4f/0xa0 [btrfs]
[  310.110268]  [<ffffffffa04d5033>] btrfs_balance+0x913/0xeb0 [btrfs]
[  310.110268]  [<ffffffffa04d5640>] balance_kthread+0x70/0x80 [btrfs]
[  310.110268]  [<ffffffffa04d55d0>] ? btrfs_balance+0xeb0/0xeb0 [btrfs]
[  310.110268]  [<ffffffff81083b70>] kthread+0xc0/0xd0
[  310.110268]  [<ffffffff81083ab0>] ? kthread_create_on_node+0x120/0x120
[  310.110268]  [<ffffffff814ef37c>] ret_from_fork+0x7c/0xb0
[  310.110268]  [<ffffffff81083ab0>] ? kthread_create_on_node+0x120/0x120
[  310.110268] Code: 4c 89 ef e8 e9 f1 f8 ff 48 8b bd 50 ff ff ff e8 dd f1 f8 ff 48 83 bd 30 ff ff ff 00 0f 85 0c fd ff ff 31 c0 e9 ae ef ff ff 0f 0b <0f> 0b 48 8b 85 30 ff ff ff 49 8d 7e 20 48 8b 70 18 48 89 c2 e8 
[  310.110268] RIP  [<ffffffffa04f6e8a>] build_backref_tree+0x112a/0x11d0 [btrfs]
[  310.110268]  RSP <ffff880078affab8>
[  310.160477] ---[ end trace 1caf0f84ada634a2 ]---

> > kernel BUG at fs/btrfs/relocation.c:1060!
> > RIP: 0010:[<ffffffffa04f5d3a>]  [<ffffffffa04f5d3a>] build_backref_tree+0x112a/0x11d0 [btrfs]
> 
> This matches the known bug in 3.11, fix was submitted to 3.11.x stable.

The kernel under which I've first noticed this issue was 3.11.1. Should this
version already contain the fix?

- Guenther
