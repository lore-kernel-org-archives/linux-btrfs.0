Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33944 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaFTAyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 20:54:02 -0400
Date: Thu, 19 Jun 2014 17:53:59 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        takeuchi_satoru@jp.fujitsu.com
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP build_backref_tree+0x9fc/0xcc4
Message-ID: <20140620005359.GA10485@merlins.org>
References: <20140609234007.GD19071@merlins.org> <53A08925.8020700@fb.com> <20140617185549.GP19071@merlins.org> <53A1AFB6.40906@fb.com> <20140618202135.GE19071@merlins.org> <53A30BDD.6080309@fb.com> <20140619222518.GA20894@merlins.org> <53A36928.1030104@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A36928.1030104@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 19, 2014 at 03:50:16PM -0700, Josef Bacik wrote:
> Ok same drill as before, reset and apply this, hopefully no panic this time
> 
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 65245a0..bca5240 100644

Here's the output
BTRFS info (device sdb1): disk space caching is enabled
BTRFS: detected SSD devices, enabling SSD mode
BTRFS info (device sdb1): continuing balance
BTRFS info (device sdb1): relocating block group 82699091968 flags 1
BTRFS info (device sdb1): found 3719 extents
running build_backref_tree
building backref for bytenr 73005293568 level 0
eb in path 173444124672, level 1, cowonly 0, owner 256, gen 231481, last snap 243545, reloc 0, root 256
is shared, need_check 1
eb in path 67327229952, level 2, cowonly 0, owner 256, gen 243615, last snap 243545, reloc 0, root 256
isn't shared, need_check 0
eb in path 2176913408, level 3, cowonly 0, owner 256, gen 253956, last snap 243545, reloc 1, root 256
is shared, need_check 0
eb in path 2320281600, level 4, cowonly 0, owner 256, gen 253957, last snap 243545, reloc 0, root 256
isn't shared, need_check 0
doing the checking for block 173444124672
building backref for bytenr 173444124672 level 1
exist is 67327229952, checked 1
found shared ref 173244198912, needs checking
doing the checking for block 173244198912
building backref for bytenr 173244198912 level 2
found shared ref 2177122304, needs checking
found shared ref 2177081344, needs checking
found shared ref 2176827392, needs checking
doing the checking for block 2177122304
building backref for bytenr 2177122304 level 3
eb in path 2314657792, level 4, cowonly 0, owner 6125, gen 253957, last snap 243545, reloc 0, root 6125
isn't shared, need_check 1
doing the checking for block 2177081344
building backref for bytenr 2177081344 level 3
eb in path 2320146432, level 4, cowonly 0, owner 6123, gen 253957, last snap 243338, reloc 0, root 6123
isn't shared, need_check 1
doing the checking for block 2176827392
building backref for bytenr 2176827392 level 3
eb in path 2320363520, level 4, cowonly 0, owner 6124, gen 253957, last snap 243441, reloc 0, root 6124
isn't shared, need_check 1
block 2176913408 wasn't checked
done building backref tree
------------[ cut here ]------------
kernel BUG at fs/btrfs/relocation.c:411!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in: des_generic nfsv3 nfsv4 xt_NFLOG nfnetlink_log nfnetlink xt_tcpudp xt_comment xt_multiport ip6table_filter ip6_tables iptable_filter ip_tables x_tables fuse autofs4 rfcomm parport_pc bnep ppdev binfmt_misc ecb btusb bluetooth intel_rapl 6lowpan_iphc x86_pkg_temp_thermal intel_powerclamp coretemp kvm rpcsec_gss_krb5 nfsd nfs_acl auth_rpcgss nfs snd_hda_codec_hdmi crct10dif_pclmul crc32_pclmul crc32c_intel fscache lockd sunrpc ghash_clmulni_intel snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller aesni_intel snd_hda_codec ablk_helper snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm cryptd lrw snd_hwdep snd_usbmidi_lib snd_seq_midi snd_seq_midi_event snd_rawmidi uvcvideo gf128mul sb_edac videobuf2_core snd_seq psmouse videodev media videobuf2_vmalloc videobuf2_memops snd_timer snd_seq_device edac_core ehci_pci glue_helper tpm_infineon hp_wmi sparse_keymap snd soundcore serio_raw rfkill aes_x86_64 ehci_hcd microcode lpc_ich tpm_tis tpm evdev wmi processor lp parport loop hid_generic usbhid hid uas usb_storage dm_mod firewire_ohci xhci_hcd firewire_core crc_itu_t usbcore e1000e isci usb_common ptp libsas pps_core scsi_transport_sas
CPU: 5 PID: 17084 Comm: btrfs-balance Not tainted 3.15.1-amd64-i915-preempt-20140216jbp3 #3
Hardware name: Hewlett-Packard HP Z620 Workstation/158A, BIOS J61 v01.17 11/05/2012
task: ffff880fcc858190 ti: ffff880fcd030000 task.ti: ffff880fcd030000
RIP: 0010:[<ffffffff81268bfb>]  [<ffffffff81268bfb>] drop_backref_node+0x19/0x5d
RSP: 0018:ffff880fcd033bf8  EFLAGS: 00010287
RAX: ffff8807dc9ce180 RBX: ffff8807dc9ce140 RCX: ffff880807eaf8e8
RDX: 0000000000000043 RSI: ffff8807dc9ce140 RDI: ffff880807eaf820
RBP: ffff880fcd033c08 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffe77402 R12: ffff880806f7c140
R13: ffff880807eaf820 R14: ffff8807e19fb040 R15: ffff880807eaf924
FS:  0000000000000000(0000) GS:ffff88082fca0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fab45ef3000 CR3: 0000000001c13000 CR4: 00000000000407e0
Stack:
 ffff880806f7c140 ffff880806f7c140 ffff880fcd033c40 ffffffff81268ca4
 ffff8807cb274d10 ffff880807eaf908 ffff880807eaf8e8 00000000ffffffea
 ffff880807eaf800 ffff880fcd033cb8 ffffffff8126af02 ffff880807eaf820
Call Trace:
 [<ffffffff81268ca4>] remove_backref_node+0x65/0xc1
 [<ffffffff8126af02>] relocate_block_group+0x390/0x49a
 [<ffffffff8126b167>] btrfs_relocate_block_group+0x15b/0x26d
 [<ffffffff81249b80>] btrfs_relocate_chunk.isra.23+0x5c/0x5e8
 [<ffffffff8161fbfb>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff812458cc>] ? free_extent_buffer+0x8a/0x8d
 [<ffffffff8124c406>] btrfs_balance+0x9b6/0xb74
 [<ffffffff816167ad>] ? printk+0x54/0x56
 [<ffffffff8124c5c4>] ? btrfs_balance+0xb74/0xb74
 [<ffffffff8124c61d>] balance_kthread+0x59/0x7b
 [<ffffffff8106b4b4>] kthread+0xae/0xb6
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8162677c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
Code: 7b 68 e8 6b cc fd ff 48 c7 43 68 00 00 00 00 5b 5d c3 66 66 66 66 90 55 48 8d 46 40 48 89 e5 41 54 53 48 39 46 40 48 89 f3 74 02 <0f> 0b 49 89 fc 48 89 f7 e8 a1 ff ff ff 48 8d 7b 30 e8 3b ca ff 
RIP  [<ffffffff81268bfb>] drop_backref_node+0x19/0x5d
 RSP <ffff880fcd033bf8>
---[ end trace 539f3f31bdb6112f ]---
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
---[ end Kernel panic - not syncing: Fatal exception
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
