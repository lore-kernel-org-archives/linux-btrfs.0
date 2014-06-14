Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60483 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaFNQWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Jun 2014 12:22:05 -0400
Date: Sat, 14 Jun 2014 09:21:55 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Cc: takeuchi_satoru@jp.fujitsu.com
Message-ID: <20140614162155.GQ6584@merlins.org>
References: <20140609234007.GD19071@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140609234007.GD19071@merlins.org>
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP
 build_backref_tree+0x9fc/0xcc4
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 09, 2014 at 04:40:07PM -0700, Marc MERLIN wrote:
> I did a balance on a system that had 3.11 (yes, I know, it's old). It hung.
> So, I rebooted with 3.13, and it failed in fs/btrfs/relocation
> 
> Problem #1: I cannot stop the relocation. It starts on its own as soon as I
> mount the FS, and I can't stop it.
> Is there a bug to fix that?

Chris,

As Russell pointed out, I can stop the balance at mount, but back to the
bug, can you make btrfs not crash like this if it gets input it doesn't
expect?

Separately, I'll send one lsat offer to give data off the FS to give you
a chance to figure out how it got into that state and potentially find
another bug.
That is unless there were one or more known corruption bugs that have
been fixed and that there is nothing to be learned from looking into
this.

Thanks,
Marc
 
> Problem #2: I rebooted with 3.15rc5, and now it's worse.
> [ 1569.598026] kernel BUG at fs/btrfs/relocation.c:1064!
> then leads to
> [ 1569.613240] RIP  [<ffffffff81267ef0>] build_backref_tree+0x9fc/0xcc4
> [ 1569.613491]  RSP <ffff880fde599ad8>
> [ 1569.614119] ---[ end trace da0f24875bbde960 ]---
> [ 1569.614398] Kernel panic - not syncing: Fatal exception
> (full trace below)
> 
> I'm sure that filesystem is damaged in some way, but the kernel of course
> should not crash.
> 
> 3.15 dies here:
> struct backref_node *build_backref_tree(struct reloc_control *rc,
> (...)
> 		if (!RB_EMPTY_NODE(&upper->rb_node)) {
> 			if (upper->lowest) {
> 				list_del_init(&upper->lower);
> 				upper->lowest = 0;
> 			}
> 
> 			list_add_tail(&edge->list[UPPER], &upper->lower);
> 			continue;
> 		}
> 
> 		BUG_ON(!upper->checked); <<<< here
> 
> So I'm sure I hit a bug and my FS has issues, but can't the kernel do something better
> like abort the rebalance instead of crashing?
> 
> In the meantime, does anyone want anything off that filesystem before I wipe it?
> 
> 
> => Crash on 3.13:
> btrfs: found 4930 extents
> btrfs: relocating block group 82699091968 flags 1
> btrfs: found 3719 extents
> ------------[ cut here ]------------
> kernel BUG at /build/buildd/linux-lts-trusty-3.13.0/fs/btrfs/relocation.c:1062!
> invalid opcode: 0000 [#1] SMP 
> Modules linked in: rfcomm parport_pc ppdev bnep binfmt_misc rpcsec_gss_krb5 nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc snd_hda_codec_hdmi nvidia(POF) snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_usb_audio snd_pcm snd_hwdep snd_usbmidi_lib snd_seq_midi snd_seq_midi_event snd_seq btusb bluetooth uvcvideo videobuf2_core videodev videobuf2_vmalloc videobuf2_memops snd_rawmidi snd_timer snd_seq_device drm snd psmouse gpio_ich sb_edac hp_wmi serio_raw edac_core mei_me mei mac_hid soundcore sparse_keymap snd_page_alloc lpc_ich wmi tpm_infineon lp parport btrfs raid6_pq xor libcrc32c hid_generic usbhid hid usb_storage firewire_ohci isci e1000e firewire_core libsas crc_itu_t ptp ahci libahci pps_core scsi_transport_sas
> CPU: 4 PID: 1710 Comm: btrfs-balance Tainted: PF          O 3.13.0-29-generic #53~precise1-Ubuntu
> Hardware name: Hewlett-Packard HP Z620 Workstation/158A, BIOS J61 v01.17 11/05/2012
> task: ffff881000bec7d0 ti: ffff8810018a2000 task.ti: ffff8810018a2000
> RIP: 0010:[<ffffffffa01c04a8>]  [<ffffffffa01c04a8>] build_backref_tree+0x1228/0x1290 [btrfs]
> RSP: 0018:ffff8810018a3ab8  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff880801a8fa20 RCX: ffff880801d2cf50
> RDX: ffff880801d2c390 RSI: ffff880801d2c640 RDI: ffff8807ecad9c80
> RBP: ffff8810018a3bb8 R08: ffff8807ecad9c80 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff880801d2c650
> R13: ffff8807ecad9900 R14: 0000000000000000 R15: ffff88003582a800
> FS:  0000000000000000(0000) GS:ffff88080fc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f10ee50a370 CR3: 0000000001c0d000 CR4: 00000000000407e0
> Stack:
>  ffff8807ecad9780 01ffffffa01bded0 ffff880801d2c620 ffff88003582a920
>  ffff8807ecad9c80 ffff8807ff72e800 ffff8807ecad9240 ffff8807ecad9200
>  ffff880801a8fa20 ffff880801a8fab0 ffff88003582a924 ffff88003582a820
> Call Trace:
>  [<ffffffffa01c064b>] relocate_tree_blocks+0x13b/0x1e0 [btrfs]
>  [<ffffffffa01c12b9>] relocate_block_group+0x199/0x550 [btrfs]
>  [<ffffffffa01c182a>] btrfs_relocate_block_group+0x1ba/0x300 [btrfs]
>  [<ffffffffa01999f6>] btrfs_relocate_chunk.isra.62+0x56/0x3f0 [btrfs]
>  [<ffffffffa01556b3>] ? block_group_cache_tree_search+0xb3/0xf0 [btrfs]
>  [<ffffffffa018dfe6>] ? release_extent_buffer+0x36/0xe0 [btrfs]
>  [<ffffffffa019c60c>] __btrfs_balance+0x32c/0x420 [btrfs]
>  [<ffffffffa019ca38>] btrfs_balance+0x338/0x5d0 [btrfs]
>  [<ffffffffa019cd54>] balance_kthread+0x84/0x90 [btrfs]
>  [<ffffffffa019ccd0>] ? btrfs_balance+0x5d0/0x5d0 [btrfs]
>  [<ffffffff8108f9a9>] kthread+0xc9/0xe0
>  [<ffffffff8108f8e0>] ? flush_kthread_worker+0xb0/0xb0
>  [<ffffffff817665fc>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8108f8e0>] ? flush_kthread_worker+0xb0/0xb0
> Code: ff ff 48 89 df e8 79 cb f8 ff 48 8b bd 48 ff ff ff e8 6d cb f8 ff 48 83 bd 58 ff ff ff 00 0f 84 62 ef ff ff e9 87 fd ff ff 0f 0b <0f> 0b 48 8b 85 20 ff ff ff 49 8d 7f 20 48 8b 70 18 48 89 c2 e8 
> RIP  [<ffffffffa01c04a8>] build_backref_tree+0x1228/0x1290 [btrfs]
>  RSP <ffff8810018a3ab8>
> ---[ end trace 1b7853634ea4bd18 ]---
> 
> 
> => Crash on 3.15:
> [ 1565.477358] BTRFS info (device sdb1): disk space caching is enabled
> [ 1565.567580] BTRFS: detected SSD devices, enabling SSD mode
> [ 1565.739226] BTRFS info (device sdb1): continuing balance
> [ 1565.790228] BTRFS info (device sdb1): relocating block group 82699091968 flags 1
> [ 1567.768219] BTRFS info (device sdb1): found 3719 extents
> [ 1569.597766] ------------[ cut here ]------------
> [ 1569.598026] kernel BUG at fs/btrfs/relocation.c:1064!
> [ 1569.598269] invalid opcode: 0000 [#1] PREEMPT SMP 
> [ 1569.598528] Modules linked in: des_generic nfsv3 nfsv4 fuse autofs4 bnep rfcomm parport_pc ppdev binfmt_misc uvcvideo videobuf2_core videodev media videobuf2_vmalloc videobuf2_memops snd_usb_audio snd_usbmidi_lib ecb btusb bluetooth 6lowpan_iphc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec intel_rapl x86_pkg_temp_thermal snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm intel_powerclamp coretemp rpcsec_gss_krb5 nfsd kvm snd_seq_midi snd_rawmidi snd_seq_midi_event nfs_acl auth_rpcgss snd_seq snd_timer snd_seq_device nfs ehci_pci ehci_hcd hp_wmi crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel tpm_infineon snd sparse_keymap rfkill sb_edac psmouse evdev fscache soundcore lockd edac_core serio_raw lpc_ich wmi aesni_intel processor ablk_helper cryptd lrw gf128mul sunrpc tpm_tis glue_helper tpm aes_x86_64 microcode lp parport loop hid_generic usbhid hid uas usb_storage dm_mod firewire_ohci xhci_hcd firewire_core crc_itu_t usbcore e1000e usb_common isci ptp pps_core libsas scsi_transport_sas
> [ 1569.602494] CPU: 4 PID: 6244 Comm: btrfs-balance Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s2 #1
> [ 1569.602963] Hardware name: Hewlett-Packard HP Z620 Workstation/158A, BIOS J61 v01.17 11/05/2012
> [ 1569.603433] task: ffff880fde596210 ti: ffff880fde598000 task.ti: ffff880fde598000 [ 1569.603898] RIP: 0010:[<ffffffff81267ef0>]  [<ffffffff81267ef0>] build_backref_tree+0x9fc/0xcc4
> [ 1569.604382] RSP: 0018:ffff880fde599ad8  EFLAGS: 00010246
> [ 1569.604622] RAX: ffff880fde599b00 RBX: ffff880806836c10 RCX: ffff8807d8ea74d0
> [ 1569.604867] RDX: ffff8808060d9750 RSI: ffff880fde599b58 RDI: ffff8807d8f51e90
> [ 1569.605109] RBP: ffff880fde599bb8 R08: ffff88080682c940 R09: 0000000000001000
> [ 1569.605352] R10: 0000160000000000 R11: 6db6db6db6db6db7 R12: ffff8807d8f51e90
> [ 1569.605598] R13: ffff880fde599b68 R14: ffff880806836bc0 R15: ffff880805f64800
> [ 1569.605842] FS:  0000000000000000(0000) GS:ffff88082fc80000(0000) knlGS:0000000000000000
> [ 1569.606310] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1569.606550] CR2: 00007fa936051000 CR3: 0000000001c11000 CR4: 00000000000407e0
> [ 1569.606791] Stack:
> [ 1569.607025]  ffff8807d8ebc940 ffff8807d8f51820 ffff8807d8ebc940 ffff880807907d00
> [ 1569.607512]  01ff881004811580 ffff880fde599b68 ffff880805f64920 0000000000000000
> [ 1569.608001]  ffff880f00000005 ffff8807d9a78f50 ffff880fde599b58 0000000000000000
> [ 1569.608487] Call Trace:
> [ 1569.608728]  [<ffffffff81269bd2>] relocate_tree_blocks+0x16a/0x44c
> [ 1569.608972]  [<ffffffff8126aa03>] relocate_block_group+0x239/0x49a
> [ 1569.609217]  [<ffffffff8126adbf>] btrfs_relocate_block_group+0x15b/0x26d
> [ 1569.609465]  [<ffffffff81249838>] btrfs_relocate_chunk.isra.23+0x5c/0x5e8
> [ 1569.609711]  [<ffffffff8161efbb>] ? _raw_spin_unlock+0x17/0x2a
> [ 1569.609955]  [<ffffffff81245584>] ? free_extent_buffer+0x8a/0x8d
> [ 1569.610200]  [<ffffffff8124c0be>] btrfs_balance+0x9b6/0xb74
> [ 1569.610442]  [<ffffffff81615c3d>] ? printk+0x54/0x56
> [ 1569.610684]  [<ffffffff8124c27c>] ? btrfs_balance+0xb74/0xb74
> [ 1569.610928]  [<ffffffff8124c2d5>] balance_kthread+0x59/0x7b
> [ 1569.611173]  [<ffffffff8106b467>] kthread+0xae/0xb6
> [ 1569.611413]  [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
> [ 1569.611664]  [<ffffffff81625b3c>] ret_from_fork+0x7c/0xb0
> [ 1569.611905]  [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
> [ 1569.612149] Code: 0d 48 89 df e8 f4 e7 ff ff 41 80 66 71 fd 49 8b 46 58
> 4d 89 66 58 49 89 1c 24 49 89 44 24 08 4c 89 20 e9 80 00 00 00 a8 10 75 02
> <0f> 0b 83 e0 01 39 85 78 ff ff ff 74 02 0f 0b 83 bd 78 ff ff ff 
> [ 1569.613240] RIP  [<ffffffff81267ef0>] build_backref_tree+0x9fc/0xcc4
> [ 1569.613491]  RSP <ffff880fde599ad8>
> [ 1569.614119] ---[ end trace da0f24875bbde960 ]---
> [ 1569.614398] Kernel panic - not syncing: Fatal exception
> [ 1569.614738] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> [ 1569.615245] ---[ end Kernel panic - not syncing: Fatal exception
> 
> 
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
