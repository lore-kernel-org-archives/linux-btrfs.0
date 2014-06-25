Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36991 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaFYTkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 15:40:36 -0400
Date: Wed, 25 Jun 2014 12:40:34 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        takeuchi_satoru@jp.fujitsu.com
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP build_backref_tree+0x9fc/0xcc4
Message-ID: <20140625194034.GC18416@merlins.org>
References: <20140609234007.GD19071@merlins.org> <53A08925.8020700@fb.com> <20140617185549.GP19071@merlins.org> <53A1AFB6.40906@fb.com> <20140618202135.GE19071@merlins.org> <53A30BDD.6080309@fb.com> <20140619222518.GA20894@merlins.org> <53A36928.1030104@fb.com> <20140620005359.GA10485@merlins.org> <53A45601.9070305@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A45601.9070305@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 20, 2014 at 08:40:49AM -0700, Josef Bacik wrote:
> On 06/19/2014 05:53 PM, Marc MERLIN wrote:
> >On Thu, Jun 19, 2014 at 03:50:16PM -0700, Josef Bacik wrote:
> >>Ok same drill as before, reset and apply this, hopefully no panic this 
> >>time
> >>
> >>
> >>diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> >>index 65245a0..bca5240 100644
> >
> 
> Ok I see what it is but I want to get rid of the panicing so we're going
> to do this dance a few more times until it's just failing to mount instead
> of panicing, and then we'll fix the actual bug.  Give this a whirl, and
> I've added another printk just to make sure what I think is happening is
> actually what's happening, so same drill as before.  Thanks,

Patch applied. The panic moved :)

[  313.756971] BTRFS: device label btrfs_pool2 devid 1 transid 254006 /dev/sda1
[  313.757467] BTRFS info (device sda1): disk space caching is enabled
[  313.835538] BTRFS: detected SSD devices, enabling SSD mode
[  313.932327] BTRFS info (device sda1): continuing balance
[  313.990048] BTRFS info (device sda1): relocating block group 82699091968 flags 1
[  316.085055] BTRFS info (device sda1): found 3719 extents
[  317.797058] running build_backref_tree
[  317.797075] building backref for bytenr 73005293568 level 0
[  317.797090] eb in path 173444124672, level 1, cowonly 0, owner 256, gen 231481, last snap 243545, reloc 0, root 256
[  317.797097] is shared, need_check 1
[  317.797104] eb in path 67327229952, level 2, cowonly 0, owner 256, gen 243615, last snap 243545, reloc 0, root 256
[  317.797109] isn't shared, need_check 0
[  317.797117] eb in path 2176913408, level 3, cowonly 0, owner 256, gen 253956, last snap 243545, reloc 1, root 256
[  317.797122] is shared, need_check 0
[  317.797129] eb in path 2320281600, level 4, cowonly 0, owner 256, gen 253957, last snap 243545, reloc 0, root 256
[  317.797134] isn't shared, need_check 0
[  317.797139] doing the checking for block 173444124672
[  317.797144] building backref for bytenr 173444124672 level 1
[  317.797562] exist is 67327229952, checked 1
[  317.797571] exist is fucking us, bytenr 67327229952, type 176
[  317.797578] found shared ref 173244198912, needs checking
[  317.797583] doing the checking for block 173244198912
[  317.797588] building backref for bytenr 173244198912 level 2
[  317.798242] found shared ref 2177122304, needs checking
[  317.798251] found shared ref 2177081344, needs checking
[  317.798257] found shared ref 2176827392, needs checking
[  317.798263] doing the checking for block 2177122304
[  317.798268] building backref for bytenr 2177122304 level 3
[  317.798779] eb in path 2314657792, level 4, cowonly 0, owner 6125, gen 253957, last snap 243545, reloc 0, root 6125
[  317.798787] isn't shared, need_check 1
[  317.798798] doing the checking for block 2177081344
[  317.798804] building backref for bytenr 2177081344 level 3
[  317.798962] eb in path 2320146432, level 4, cowonly 0, owner 6123, gen 253957, last snap 243338, reloc 0, root 6123
[  317.798970] isn't shared, need_check 1
[  317.798976] doing the checking for block 2176827392
[  317.798981] building backref for bytenr 2176827392 level 3
[  317.799144] eb in path 2320363520, level 4, cowonly 0, owner 6124, gen 253957, last snap 243441, reloc 0, root 6124
[  317.799151] isn't shared, need_check 1
[  317.799158] block 2176913408 wasn't checked
[  317.799162] done building backref tree
[  317.799193] general protection fault: 0000 [#1] PREEMPT SMP 
[  317.799207] Modules linked in: xt_NFLOG xt_tcpudp xt_comment xt_multiport ip6table_filter ip6_tables iptable_filter ip_tables x_tables nfnetlink_log nfnetlink fuse autofs4 rfcomm bnep bluetooth 6lowpan_iphc rfkill binfmt_misc snd_hda_codec_hdmi snd_hda_codec_analog snd_hda_codec_generic intel_powerclamp coretemp kvm_intel kvm snd_hda_intel snd_hda_controller snd_hda_codec crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel ehci_pci snd_hwdep rpcsec_gss_krb5 snd_pcm_oss snd_mixer_oss snd_pcm nfsd auth_rpcgss snd_seq_midi snd_seq_midi_event nfs_acl snd_rawmidi nfs lockd sunrpc snd_seq snd_seq_device ppdev aes_x86_64 ehci_hcd snd_timer lrw parport_pc dcdbas i7core_edac lp gf128mul gpio_ich dell_wmi parport snd edac_core acpi_cpufreq soundcore lpc_ich processor loop glue_helper tpm_tis tpm sparse_keymap wmi psmouse serio_raw joydev ablk_helper cryptd evdev fscache microcode hid_generic usbhid hid sr_mod cdrom dm_mod tg3 libphy ptp pps_core uhci_hcd usbcore usb_common
[  317.799543] CPU: 1 PID: 4903 Comm: btrfs-balance Not tainted 3.15.1-amd64-i915-preempt-20140216jbp4 #1
[  317.799548] Hardware name: Dell Inc. Precision WorkStation T3500  /09KPNV, BIOS A10 01/21/2011
[  317.799555] task: ffff8805abd56450 ti: ffff8805abd58000 task.ti: ffff8805abd58000
[  317.799560] RIP: 0010:[<ffffffff81265654>]  [<ffffffff81265654>] list_del+0x8/0x2f
[  317.799573] RSP: 0018:ffff8805abd5bc00  EFLAGS: 00010287
[  317.799579] RAX: dead000000200200 RBX: ffff8805abfb1640 RCX: ffff8805f57b88e8
[  317.799584] RDX: dead000000100100 RSI: ffff8805f6d83940 RDI: ffff8805abff8750
[  317.799589] RBP: ffff8805abd5bc40 R08: 0000000000000000 R09: 0000000000000000
[  317.799594] R10: 00000000ffffffff R11: 0000000000000000 R12: ffff8805f6d83940
[  317.799599] R13: ffff8805f57b8820 R14: ffff8805abff8740 R15: ffff8805f6d83980
[  317.799605] FS:  0000000000000000(0000) GS:ffff880617220000(0000) knlGS:0000000000000000
[  317.799610] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  317.799615] CR2: 00007f644026f000 CR3: 0000000001c13000 CR4: 00000000000007e0
[  317.799621] Stack:
[  317.799625]  ffff8805abd5bc40 ffffffff81268c9d ffff8805f57b8924 ffff8805ba7f86e0
[  317.799643]  ffff8805f57b8908 ffff8805f57b88e8 00000000ffffffea ffff8805f57b8800
[  317.799659]  ffff8805abd5bcb8 ffffffff8126af28 ffff8805f57b8820 00000001138d93a8
[  317.799674] Call Trace:
[  317.799683]  [<ffffffff81268c9d>] ? remove_backref_node+0x4c/0xd5
[  317.799690]  [<ffffffff8126af28>] relocate_block_group+0x390/0x49a
[  317.799698]  [<ffffffff8126b18d>] btrfs_relocate_block_group+0x15b/0x26d
[  317.799706]  [<ffffffff81249b80>] btrfs_relocate_chunk.isra.23+0x5c/0x5e8
[  317.799715]  [<ffffffff8161fc1b>] ? _raw_spin_unlock+0x17/0x2a
[  317.799722]  [<ffffffff812458cc>] ? free_extent_buffer+0x8a/0x8d
[  317.799729]  [<ffffffff8124c406>] btrfs_balance+0x9b6/0xb74
[  317.799737]  [<ffffffff816167cd>] ? printk+0x54/0x56
[  317.799745]  [<ffffffff8124c5c4>] ? btrfs_balance+0xb74/0xb74
[  317.799752]  [<ffffffff8124c61d>] balance_kthread+0x59/0x7b
[  317.799759]  [<ffffffff8106b4b4>] kthread+0xae/0xb6
[  317.799765]  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
[  317.799774]  [<ffffffff8162677c>] ret_from_fork+0x7c/0xb0
[  317.799780]  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
[  317.799785] Code: 00 00 00 48 c7 c7 fd 89 aa 81 e8 ad 41 eb ff 48 85 c0 48 89 05 6e 6b cb 00 0f 84 7b ff ff ff 31 c0 5d c3 48 8b 47 08 48 8b 17 55 <48> 89 42 08 48 89 10 48 b8 00 01 10 00 00 00 ad de 48 89 07 48 
[  317.799984] RIP  [<ffffffff81265654>] list_del+0x8/0x2f
[  317.799994]  RSP <ffff8805abd5bc00>
[  317.800032] ---[ end trace a9b76875452f420d ]---
[  317.800039] Kernel panic - not syncing: Fatal exception
[  317.800181] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[  317.800187] ---[ end Kernel panic - not syncing: Fatal exception

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
