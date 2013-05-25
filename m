Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57668 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147Ab3EYWuH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 18:50:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UgNHn-000253-HJ
	for linux-btrfs@vger.kernel.org; Sun, 26 May 2013 00:50:03 +0200
Received: from 89-76-82-110.dynamic.chello.pl ([89.76.82.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 00:50:03 +0200
Received: from pp by 89-76-82-110.dynamic.chello.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 00:50:03 +0200
To: linux-btrfs@vger.kernel.org
From: Piotr =?iso-8859-2?q?Paw=B3ow?= <pp@siedziba.pl>
Subject: Re: Kernel BUG: __tree_mod_log_rewind
Date: Sat, 25 May 2013 22:42:59 +0000 (UTC)
Message-ID: <knrepj$5pc$1@ger.gmane.org>
References: <CAEm3SNDqn6D5mm=1uTnOzpqKZVH6N6JDtj3AuJb9N2oqFB9cqg@mail.gmail.com>
	<5188E1A1.3060904@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I can get btrfs to throw a kernel bug easily by running btrfs fi defrag
>> on some files in 3.9.0:
> 
> Thanks for reporting. It's a known bug (that ought to be fixed before
> the 3.9 release in fact).

I'm still getting a BUG in __tree_mod_log_rewind on kernels 3.9.2 and 3.10-rc2
when trying to defragment my Steam folder:

[420853.901366] ------------[ cut here ]------------
[420853.901371] Kernel BUG at ffffffffa0136503 [verbose debug info unavailable]
[420853.901374] invalid opcode: 0000 [#1] SMP 
[420853.901376] Modules linked in: nls_iso8859_1 pci_stub snd_hrtimer parport_pc ppdev bnep rfcomm bluetooth binfmt_misc dm_crypt snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec kvm_intel snd_hwdep snd_pcm snd_seq_midi kvm snd_rawmidi snd_seq_midi_event snd_seq dm_multipath snd_timer snd_seq_device scsi_dh microcode snd serio_raw soundcore gpio_ich nvidia(POF) snd_page_alloc lpc_ich mac_hid asus_atk0110 hwmon_vid coretemp lp parport btrfs zlib_deflate libcrc32c raid10 raid456 async_memcpy async_raid6_recov async_pq async_xor async_tx xor raid6_pq raid1 raid0 multipath linear hid_generic hid_a4tech usbhid hid dm_mirror dm_region_hash dm_log usb_storage firewire_ohci firewire_core crc_itu_t 8139too 8139cp atl1 [last unloaded: vboxdrv]
[420853.901417] CPU 0 
[420853.901421] Pid: 17770, comm: btrfs-endio-wri Tainted: PF          O 3.9.2-030902-generic #201305111035 System manufacturer P5KC/P5KC
[420853.901423] RIP: 0010:[<ffffffffa0136503>]  [<ffffffffa0136503>] __tree_mod_log_rewind+0x253/0x260 [btrfs]
[420853.901442] RSP: 0018:ffff880116eab838  EFLAGS: 00010293
[420853.901444] RAX: 0000000000000000 RBX: ffff88007631a930 RCX: ffff880116eab7d8
[420853.901446] RDX: 0000000028c78f56 RSI: 0000000000000819 RDI: ffff88004f9bcd00
[420853.901447] RBP: ffff880116eab868 R08: 0000000000001000 R09: ffff880116eab7e8
[420853.901449] R10: 000000000002f96f R11: 0000000000000000 R12: ffff880124a67b80
[420853.901451] R13: 000000000000003c R14: ffff8801015bc500 R15: 00000000000014f7
[420853.901453] FS:  0000000000000000(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
[420853.901455] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[420853.901456] CR2: 00007fe6f0b19928 CR3: 00000000c6106000 CR4: 00000000000007f0
[420853.901458] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[420853.901460] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[420853.901462] Process btrfs-endio-wri (pid: 17770, threadinfo ffff880116eaa000, task ffff880115f05d40)
[420853.901463] Stack:
[420853.901464]  ffff880116eab858 ffff88001c1f0a80 00000000000014f7 ffff880000000000
[420853.901468]  00000001264d3000 ffff880123b44000 ffff880116eab8b8 ffffffffa01365ef
[420853.901471]  ffff880124a67b80 ffff88007631a930 ffff88005ce97800 0000000000000001
[420853.901474] Call Trace:
[420853.901484]  [<ffffffffa01365ef>] tree_mod_log_rewind+0xdf/0x240 [btrfs]
[420853.901493]  [<ffffffffa013e5cb>] btrfs_search_old_slot+0x4cb/0x670 [btrfs]
[420853.901507]  [<ffffffffa01b9238>] __resolve_indirect_ref+0xc8/0x150 [btrfs]
[420853.901519]  [<ffffffffa0157f7f>] ? btree_read_extent_buffer_pages.constprop.121+0xcf/0x120 [btrfs]
[420853.901532]  [<ffffffffa01b935e>] __resolve_indirect_refs+0x9e/0x200 [btrfs]
[420853.901544]  [<ffffffffa01b8e79>] ? __add_missing_keys.isra.13+0x89/0x120 [btrfs]
[420853.901557]  [<ffffffffa01b9b5d>] find_parent_nodes+0x45d/0x6b0 [btrfs]
[420853.901570]  [<ffffffffa01b9e49>] btrfs_find_all_roots+0x99/0x100 [btrfs]
[420853.901575]  [<ffffffff81187854>] ? kfree+0x134/0x170
[420853.901587]  [<ffffffffa0165620>] ? btrfs_submit_direct+0x190/0x190 [btrfs]
[420853.901599]  [<ffffffffa0165620>] ? btrfs_submit_direct+0x190/0x190 [btrfs]
[420853.901612]  [<ffffffffa01baa97>] iterate_extent_inodes+0x177/0x2c0 [btrfs]
[420853.901625]  [<ffffffffa01bac72>] iterate_inodes_from_logical+0x92/0xb0 [btrfs]
[420853.901637]  [<ffffffffa0165620>] ? btrfs_submit_direct+0x190/0x190 [btrfs]
[420853.901648]  [<ffffffffa0161a68>] record_extent_backrefs+0x78/0xf0 [btrfs]
[420853.901661]  [<ffffffffa016cb24>] relink_file_extents+0x44/0x180 [btrfs]
[420853.901673]  [<ffffffffa016cd95>] btrfs_finish_ordered_io+0x135/0x4d0 [btrfs]
[420853.901685]  [<ffffffffa016d145>] finish_ordered_fn+0x15/0x20 [btrfs]
[420853.901698]  [<ffffffffa018cc80>] worker_loop+0xa0/0x320 [btrfs]
[420853.901710]  [<ffffffffa018cbe0>] ? check_pending_worker_creates.isra.1+0xf0/0xf0 [btrfs]
[420853.901714]  [<ffffffff810804a0>] kthread+0xc0/0xd0
[420853.901717]  [<ffffffff810803e0>] ? flush_kthread_worker+0xb0/0xb0
[420853.901722]  [<ffffffff817126ec>] ret_from_fork+0x7c/0xb0
[420853.901724]  [<ffffffff810803e0>] ? flush_kthread_worker+0xb0/0xb0
[420853.901726] Code: c1 49 63 46 58 48 89 c2 48 c1 e2 05 48 8d 54 10 65 49 63 46 2c 48 89 c6 48 c1 e6 05 48 8d 74 30 65 e8 62 a7 04 00 e9 a5 fe ff ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 
[420853.901754] RIP  [<ffffffffa0136503>] __tree_mod_log_rewind+0x253/0x260 [btrfs]
[420853.901763]  RSP <ffff880116eab838>
[420853.901766] ---[ end trace 594047585a976e99 ]---

and 3.10-rc2:

[  485.921762] ------------[ cut here ]------------
[  485.921767] Kernel BUG at ffffffffa0124ea3 [verbose debug info unavailable]
[  485.921769] invalid opcode: 0000 [#1] SMP 
[  485.921772] Modules linked in: snd_hrtimer dm_crypt snd_hda_codec_hdmi dm_multipath snd_hda_codec_realtek snd_hda_intel scsi_dh snd_hda_codec snd_hwdep nvidia(POF) kvm_intel parport_pc gpio_ich snd_pcm ppdev serio_raw kvm snd_page_alloc snd_seq_midi lpc_ich snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer asus_atk0110 snd drm mac_hid microcode soundcore rfcomm bnep bluetooth hwmon_vid coretemp lp parport binfmt_misc btrfs zlib_deflate libcrc32c raid10 raid456 async_memcpy async_raid6_recov async_pq async_xor async_tx xor raid6_pq raid1 raid0 multipath linear hid_generic hid_a4tech usbhid hid dm_mirror dm_region_hash dm_log firewire_ohci firewire_core crc_itu_t 8139too 8139cp atl1
[  485.921809] CPU: 0 PID: 1568 Comm: btrfs-endio-wri Tainted: PF          O 3.10.0-031000rc2-generic #201305201835
[  485.921811] Hardware name: System manufacturer P5KC/P5KC, BIOS 1203    06/25/2008
[  485.921812] task: ffff880125515dc0 ti: ffff880127232000 task.ti: ffff880127232000
[  485.921814] RIP: 0010:[<ffffffffa0124ea3>]  [<ffffffffa0124ea3>] __tree_mod_log_rewind+0x253/0x260 [btrfs]
[  485.921833] RSP: 0018:ffff880127233848  EFLAGS: 00010297
[  485.921834] RAX: 0000000000000000 RBX: ffff88007e832dc0 RCX: ffff8801272337e8
[  485.921836] RDX: 0000000028c3f233 RSI: 0000000000000e6a RDI: ffff8801259a9f00
[  485.921838] RBP: ffff880127233878 R08: 0000000000001000 R09: ffff8801272337f8
[  485.921839] R10: 000000000002adad R11: 0000000000000000 R12: ffff8801273c5680
[  485.921841] R13: 000000000000006d R14: ffff8800c97fa800 R15: 0000006c00000000
[  485.921843] FS:  0000000000000000(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
[  485.921844] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  485.921846] CR2: 00007f42852d0000 CR3: 0000000035193000 CR4: 00000000000007f0
[  485.921847] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  485.921849] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  485.921850] Stack:
[  485.921851]  ffff880127233868 ffff88007d0228c0 0000006c00000000 ffff880000000000
[  485.921854]  0000000049f37000 ffff880123ae4000 ffff8801272338c8 ffffffffa0124fab
[  485.921857]  ffff8801273c5680 ffff88007e832dc0 ffff8801293a5a20 0000000000000001
[  485.921860] Call Trace:
[  485.921869]  [<ffffffffa0124fab>] tree_mod_log_rewind+0xfb/0x260 [btrfs]
[  485.921878]  [<ffffffffa012d1a8>] btrfs_search_old_slot+0x538/0x6c0 [btrfs]
[  485.921892]  [<ffffffffa01a6848>] __resolve_indirect_ref+0xc8/0x150 [btrfs]
[  485.921904]  [<ffffffffa01a6966>] __resolve_indirect_refs+0x96/0x1f0 [btrfs]
[  485.921917]  [<ffffffffa016d395>] ? free_extent_buffer+0x35/0x40 [btrfs]
[  485.921930]  [<ffffffffa01a717b>] find_parent_nodes+0x47b/0x6d0 [btrfs]
[  485.921942]  [<ffffffffa01a7469>] btrfs_find_all_roots+0x99/0x100 [btrfs]
[  485.921954]  [<ffffffffa0153cf0>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
[  485.921966]  [<ffffffffa0153cf0>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
[  485.921979]  [<ffffffffa01a7ff5>] iterate_extent_inodes+0x135/0x250 [btrfs]
[  485.921991]  [<ffffffffa01a81a2>] iterate_inodes_from_logical+0x92/0xb0 [btrfs]
[  485.922003]  [<ffffffffa0153cf0>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
[  485.922014]  [<ffffffffa0150148>] record_extent_backrefs+0x78/0xf0 [btrfs]
[  485.922026]  [<ffffffffa015b1e4>] relink_file_extents+0x44/0x180 [btrfs]
[  485.922038]  [<ffffffffa015b455>] btrfs_finish_ordered_io+0x135/0x4d0 [btrfs]
[  485.922049]  [<ffffffffa015b805>] finish_ordered_fn+0x15/0x20 [btrfs]
[  485.922061]  [<ffffffffa017aba0>] worker_loop+0xa0/0x2f0 [btrfs]
[  485.922074]  [<ffffffffa017ab00>] ? check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
[  485.922079]  [<ffffffff8106b890>] kthread+0xc0/0xd0
[  485.922081]  [<ffffffff8106b7d0>] ? flush_kthread_worker+0xb0/0xb0
[  485.922085]  [<ffffffff816d59dc>] ret_from_fork+0x7c/0xb0
[  485.922088]  [<ffffffff8106b7d0>] ? flush_kthread_worker+0xb0/0xb0
[  485.922089] Code: c1 49 63 46 58 48 89 c2 48 c1 e2 05 48 8d 54 10 65 49 63 46 2c 48 89 c6 48 c1 e6 05 48 8d 74 30 65 e8 62 9e 04 00 e9 a5 fe ff ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 
[  485.922114] RIP  [<ffffffffa0124ea3>] __tree_mod_log_rewind+0x253/0x260 [btrfs]
[  485.922123]  RSP <ffff880127233848>
[  485.922125] ---[ end trace c99a0e9f2e380154 ]---
[  491.584786] ------------[ cut here ]------------
[  491.584791] Kernel BUG at ffffffffa0124ea3 [verbose debug info unavailable]
[  491.584794] invalid opcode: 0000 [#2] SMP 
[  491.584796] Modules linked in: snd_hrtimer dm_crypt snd_hda_codec_hdmi dm_multipath snd_hda_codec_realtek snd_hda_intel scsi_dh snd_hda_codec snd_hwdep nvidia(POF) kvm_intel parport_pc gpio_ich snd_pcm ppdev serio_raw kvm snd_page_alloc snd_seq_midi lpc_ich snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer asus_atk0110 snd drm mac_hid microcode soundcore rfcomm bnep bluetooth hwmon_vid coretemp lp parport binfmt_misc btrfs zlib_deflate libcrc32c raid10 raid456 async_memcpy async_raid6_recov async_pq async_xor async_tx xor raid6_pq raid1 raid0 multipath linear hid_generic hid_a4tech usbhid hid dm_mirror dm_region_hash dm_log firewire_ohci firewire_core crc_itu_t 8139too 8139cp atl1
[  491.584833] CPU: 1 PID: 2644 Comm: btrfs-endio-wri Tainted: PF     D    O 3.10.0-031000rc2-generic #201305201835
[  491.584834] Hardware name: System manufacturer P5KC/P5KC, BIOS 1203    06/25/2008
[  491.584836] task: ffff880124385dc0 ti: ffff880124aea000 task.ti: ffff880124aea000
[  491.584838] RIP: 0010:[<ffffffffa0124ea3>]  [<ffffffffa0124ea3>] __tree_mod_log_rewind+0x253/0x260 [btrfs]
[  491.584855] RSP: 0018:ffff880124aeb788  EFLAGS: 00010297
[  491.584857] RAX: 0000000000000000 RBX: ffff8800503c5400 RCX: ffff880124aeb728
[  491.584858] RDX: 0000000028c68560 RSI: 0000000000000a8c RDI: ffff8800463acc80
[  491.584860] RBP: ffff880124aeb7b8 R08: 0000000000001000 R09: ffff880124aeb738
[  491.584861] R10: 000000000002af03 R11: 0000000000000000 R12: ffff880047951380
[  491.584863] R13: 000000000000004f R14: ffff8800463acb00 R15: 0000041600000000
[  491.584865] FS:  0000000000000000(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000000
[  491.584867] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  491.584868] CR2: 00007f0afdc7f000 CR3: 00000000b23bd000 CR4: 00000000000007e0
[  491.584870] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  491.584871] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  491.584872] Stack:
[  491.584874]  ffff880124aeb7a8 ffff8800503c5040 0000041600000000 ffff880000000000
[  491.584877]  00000000497fb000 ffff880123ae4000 ffff880124aeb808 ffffffffa0124fab
[  491.584879]  ffff880047951380 ffff8800503c5400 ffff8801293a9cf0 0000000000000001
[  491.584882] Call Trace:
[  491.584892]  [<ffffffffa0124fab>] tree_mod_log_rewind+0xfb/0x260 [btrfs]
[  491.584901]  [<ffffffffa012d1a8>] btrfs_search_old_slot+0x538/0x6c0 [btrfs]
[  491.584910]  [<ffffffffa012f4cd>] btrfs_next_old_leaf+0xed/0x450 [btrfs]
[  491.584923]  [<ffffffffa01644e6>] ? btrfs_get_token_64+0x26/0xf0 [btrfs]
[  491.584937]  [<ffffffffa01a66ac>] add_all_parents.isra.15+0x18c/0x260 [btrfs]
[  491.584949]  [<ffffffffa01a68ae>] __resolve_indirect_ref+0x12e/0x150 [btrfs]
[  491.584961]  [<ffffffffa01a6966>] __resolve_indirect_refs+0x96/0x1f0 [btrfs]
[  491.584974]  [<ffffffffa01a717b>] find_parent_nodes+0x47b/0x6d0 [btrfs]
[  491.584985]  [<ffffffffa0153cf0>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
[  491.584997]  [<ffffffffa0153cf0>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
[  491.585009]  [<ffffffffa0153cf0>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
[  491.585021]  [<ffffffffa01a7fa0>] iterate_extent_inodes+0xe0/0x250 [btrfs]
[  491.585034]  [<ffffffffa016d395>] ? free_extent_buffer+0x35/0x40 [btrfs]
[  491.585046]  [<ffffffffa01a81a2>] iterate_inodes_from_logical+0x92/0xb0 [btrfs]
[  491.585058]  [<ffffffffa0153cf0>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
[  491.585069]  [<ffffffffa0150148>] record_extent_backrefs+0x78/0xf0 [btrfs]
[  491.585081]  [<ffffffffa015b1e4>] relink_file_extents+0x44/0x180 [btrfs]
[  491.585093]  [<ffffffffa015b455>] btrfs_finish_ordered_io+0x135/0x4d0 [btrfs]
[  491.585104]  [<ffffffffa015b805>] finish_ordered_fn+0x15/0x20 [btrfs]
[  491.585117]  [<ffffffffa017aba0>] worker_loop+0xa0/0x2f0 [btrfs]
[  491.585129]  [<ffffffffa017ab00>] ? check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
[  491.585133]  [<ffffffff8106b890>] kthread+0xc0/0xd0
[  491.585136]  [<ffffffff8106b7d0>] ? flush_kthread_worker+0xb0/0xb0
[  491.585140]  [<ffffffff816d59dc>] ret_from_fork+0x7c/0xb0
[  491.585142]  [<ffffffff8106b7d0>] ? flush_kthread_worker+0xb0/0xb0
[  491.585144] Code: c1 49 63 46 58 48 89 c2 48 c1 e2 05 48 8d 54 10 65 49 63 46 2c 48 89 c6 48 c1 e6 05 48 8d 74 30 65 e8 62 9e 04 00 e9 a5 fe ff ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 
[  491.585169] RIP  [<ffffffffa0124ea3>] __tree_mod_log_rewind+0x253/0x260 [btrfs]
[  491.585177]  RSP <ffff880124aeb788>
[  491.585180] ---[ end trace c99a0e9f2e380155 ]---

