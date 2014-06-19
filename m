Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:32921 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaFSWZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 18:25:19 -0400
Date: Thu, 19 Jun 2014 15:25:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        takeuchi_satoru@jp.fujitsu.com
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP build_backref_tree+0x9fc/0xcc4
Message-ID: <20140619222518.GA20894@merlins.org>
References: <20140609234007.GD19071@merlins.org> <53A08925.8020700@fb.com> <20140617185549.GP19071@merlins.org> <53A1AFB6.40906@fb.com> <20140618202135.GE19071@merlins.org> <53A30BDD.6080309@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A30BDD.6080309@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 19, 2014 at 09:12:13AM -0700, Josef Bacik wrote:
> Ok undo what you did and apply this and re-run.  It is going spit out a 
> metric
> shittone of data, but all I want is the last chunk of stuff between
> 
> running build_backref_tree
> <some shit>
> block <some more shit> wasn't checked
> done building backref tree
> 
> I changed it to return an error instead of bugging, so if it still bugs 
> attach
> that as well so I can figure out where down the stack we need to fix.  
> Thanks,

Patch applied, here is the new crash. The output is short, so here is all of
it:

BTRFS info (device sdb1): disk space caching is enabled
BTRFS: detected SSD devices, enabling SSD mode
BTRFS info (device sdb1): continuing balance
BTRFS info (device sdb1): relocating block group 82699091968 flags 1
BTRFS info (device sdb1): found 3719 extents
running build_backref_tree
building backref for bytenr 73005293568
adding block in path 173444124672, level 1, cur level 0, need_check 1
adding block in path 2176913408, level 3, cur level 0, need_check 0
doing the checking for block 173444124672
building backref for bytenr 173444124672
exist is 67327229952, checked 1
found shared ref 173244198912, needs checking
doing the checking for block 173244198912
building backref for bytenr 173244198912
found shared ref 2177122304, needs checking
found shared ref 2177081344, needs checking
found shared ref 2176827392, needs checking
doing the checking for block 2177122304
building backref for bytenr 2177122304
doing the checking for block 2177081344
building backref for bytenr 2177081344
doing the checking for block 2176827392
building backref for bytenr 2176827392
block 2176913408 wasn't checked
done building backref tree
------------[ cut here ]------------
kernel BUG at fs/btrfs/relocation.c:443!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in: des_generic nfsv3 nfsv4 xt_NFLOG nfnetlink_log nfnetlink xt_tcpudp xt_comment xt_multiport ip6table_filter ip6_tables iptable_filter ip_tables x_tables fuse autofs4 bnep rfcomm parport_pc ppdev binfmt_misc ecb intel_rapl rpcsec_gss_krb5 btusb bluetooth 6lowpan_iphc nfsd nfs_acl auth_rpcgss x86_pkg_temp_thermal intel_powerclamp coretemp nfs fscache lockd sunrpc kvm crct10dif_pclmul crc32_pclmul snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic crc32c_intel snd_usb_audio snd_hda_intel ghash_clmulni_intel snd_hda_controller snd_hda_codec snd_hwdep snd_usbmidi_lib snd_pcm_oss snd_mixer_oss snd_pcm uvcvideo videobuf2_core videodev snd_seq_midi snd_seq_midi_event aesni_intel snd_seq snd_rawmidi media videobuf2_vmalloc videobuf2_memops snd_timer snd_seq_device ablk_helper psmouse serio_raw hp_wmi sparse_keymap tpm_infineon cryptd lrw gf128mul glue_helper snd soundcore rfkill sb_edac aes_x86_64 edac_core ehci_pci lpc_ich microcode ehci_hcd tpm_tis evdev wmi tpm processor lp parport loop hid_generic usbhid hid uas usb_storage dm_mod firewire_ohci firewire_core xhci_hcd crc_itu_t usbcore isci usb_common e1000e libsas ptp pps_core scsi_transport_sas
CPU: 4 PID: 14292 Comm: btrfs-balance Not tainted 3.15.1-amd64-i915-preempt-20140216jbp2 #2
Hardware name: Hewlett-Packard HP Z620 Workstation/158A, BIOS J61 v01.17 11/05/2012
task: ffff880fae66e6d0 ti: ffff880fae37c000 task.ti: ffff880fae37c000
RIP: 0010:[<ffffffff81268d33>]  [<ffffffff81268d33>] remove_backref_node+0x64/0xd5
RSP: 0018:ffff880fae37fc10  EFLAGS: 00010283
RAX: 0000000000000047 RBX: ffff8808065863c0 RCX: ffff880803c350e8
RDX: 0000000000000048 RSI: ffff8807e67cc280 RDI: 0000000000000282
RBP: ffff880fae37fc40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000ffe8f802 R12: ffff8808065865c0
R13: ffff880803c35020 R14: ffff8807e67cc280 R15: ffff880806586600
FS:  0000000000000000(0000) GS:ffff88082fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff53d50020 CR3: 0000000001c13000 CR4: 00000000000407e0
Stack:
 ffff880803c35124 ffff8807cbe1fd10 ffff880803c35108 ffff880803c350e8
 00000000ffffffea ffff880803c35000 ffff880fae37fcb8 ffffffff8126afa6
 ffff880803c35020 000000011af11358 ffffea001af11390 0000000000000000
Call Trace:
 [<ffffffff8126afa6>] relocate_block_group+0x390/0x49a
 [<ffffffff8126b20b>] btrfs_relocate_block_group+0x15b/0x26d
 [<ffffffff81249b80>] btrfs_relocate_chunk.isra.23+0x5c/0x5e8
 [<ffffffff8161fb8b>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff812458cc>] ? free_extent_buffer+0x8a/0x8d
 [<ffffffff8124c406>] btrfs_balance+0x9b6/0xb74
 [<ffffffff8161684d>] ? printk+0x54/0x56
 [<ffffffff8124c5c4>] ? btrfs_balance+0xb74/0xb74
 [<ffffffff8124c61d>] balance_kthread+0x59/0x7b
 [<ffffffff8106b4b4>] kthread+0xae/0xb6
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816266fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
Code: f7 49 8b 5e 28 e8 3a c9 ff ff 49 8d 7e 10 e8 31 c9 ff ff 48 8b 7d d0 4c 89 f6 e8 89 d8 ff ff 48 3b 1b 75 1d 4d 39 7c 24 40 74 02 <0f> 0b 4c 89 e6 4c 89 ef 49 89 dc e8 2f ff ff ff 80 4b 71 02 eb 
RIP  [<ffffffff81268d33>] remove_backref_node+0x64/0xd5
 RSP <ffff880fae37fc10>
---[ end trace 3611f7c2174a33f9 ]---
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
---[ end Kernel panic - not syncing: Fatal exception

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
