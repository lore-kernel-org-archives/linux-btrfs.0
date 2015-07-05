Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:32876 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbbGESh4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jul 2015 14:37:56 -0400
Received: by igh16 with SMTP id 16so9750861igh.0
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jul 2015 11:37:56 -0700 (PDT)
MIME-Version: 1.0
From: David Wilhelm <thefeshy@gmail.com>
Date: Sun, 5 Jul 2015 14:37:26 -0400
Message-ID: <CAKhV5s4=WR6t35Vo0JWekMKiv2ZOJF-py4sVSB4THZNd7cOe_Q@mail.gmail.com>
Subject: kernel crash on btrfs device delete missing
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am running a btrfs disk array of 13 disks in RAID 10 mode.  Two days
after the last successful scrub one of the disks failed.  I attempted
to do a "btrfs device delete missing" to remove the disk.
Unfortunately, at this time I suffered another disk failure, this time
the system disk which was not part of the array (but which was
formatted btrfs.)  This caused the system to hang after some minutes.

After replacing the system disk and restoring it from backups, I again
mounted the array in degraded mode and attempted to "btrfs device
delete missing."  It ran for about ten minutes, and iotop showed the
expected disk activity.  Unfortunately I then got a "kernel BUG"
screen and a log full of stack traces:

Jul 04 11:49:09 the-server.la-la.lan kernel: ------------[ cut here
]------------
Jul 04 11:49:09 the-server.la-la.lan kernel: WARNING: CPU: 2 PID: 3816
at fs/btrfs/delayed-ref.c:475 update_existing_ref.isra.2+0x1b5/0x1e0
[btrfs]()
Jul 04 11:49:09 the-server.la-la.lan kernel: Modules linked in:
xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype
iptable_filter br_netfilter nf_nat nf_conntrack bridge stp llc macvlan
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm mxm_wmi crct10dif_pclmul crc32_pclmul iTCO_wdt
iTCO_vendor_support snd_hda_codec_hdmi ghash_clmulni_intel
snd_hda_codec_realtek aesni_intel snd_hda_codec_generic aes_x86_64 lrw
gf128mul glue_helper ablk_helper cryptd serio_raw pcspkr i2c_i801
snd_hda_intel joydev evdev snd_hda_controller mousedev snd_hda_codec
mac_hid tg3 snd_hwdep snd_pcm lpc_ich ptp pps_core snd_timer libphy
snd mei_me mei soundcore battery nuvoton_cir rc_core tpm_tis wmi tpm
i915 video drm_kms_helper drm intel_gtt i2c_algo_bit i2c_core
Jul 04 11:49:09 the-server.la-la.lan kernel:  ie31200_edac shpchp
edac_core processor button sch_fq_codel fuse ip_tables x_tables btrfs
xor raid6_pq hid_generic usbhid hid sd_mod atkbd libps2 crc32c_intel
xhci_pci ahci ehci_pci libahci ehci_hcd xhci_hcd mpt2sas libata
raid_class scsi_transport_sas usbcore usb_common scsi_mod i8042 serio
Jul 04 11:49:09 the-server.la-la.lan kernel: CPU: 2 PID: 3816 Comm:
btrfs Tainted: G        W       4.0.7-2-ARCH #1
Jul 04 11:49:09 the-server.la-la.lan kernel: Hardware name: To Be
Filled By O.E.M. To Be Filled By O.E.M./Z77 Extreme4, BIOS P2.90
07/11/2013
Jul 04 11:49:09 the-server.la-la.lan kernel:  0000000000000000
00000000b63f28db ffff8800ac81f688 ffffffff81574ec3
Jul 04 11:49:09 the-server.la-la.lan kernel:  0000000000000000
0000000000000000 ffff8800ac81f6c8 ffffffff81074e7a
Jul 04 11:49:09 the-server.la-la.lan kernel:  0000000000000000
ffff8801f38fba50 ffff880185530388 ffff8800c8956bb0
Jul 04 11:49:09 the-server.la-la.lan kernel: Call Trace:
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff81574ec3>]
dump_stack+0x4c/0x6e
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff81074e7a>]
warn_slowpath_common+0x8a/0xc0
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff81074faa>]
warn_slowpath_null+0x1a/0x20
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02bf8a5>]
update_existing_ref.isra.2+0x1b5/0x1e0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02bf9bc>]
add_delayed_tree_ref+0xec/0x1b0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02c07fe>]
btrfs_add_delayed_tree_ref+0x10e/0x180 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa025a730>]
btrfs_free_extent+0xe0/0x140 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02469f6>] ?
btrfs_release_path+0x46/0xb0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa025aabe>]
do_walk_down+0x32e/0x9d0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa0258ad2>] ?
walk_down_proc+0x312/0x330 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa025b22d>]
walk_down_tree+0xcd/0x110 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa025ee3f>]
btrfs_drop_snapshot+0x3ff/0x8a0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02c7c39>]
merge_reloc_roots+0xe9/0x280 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02c803e>]
relocate_block_group+0x26e/0x720 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02c86c6>]
btrfs_relocate_block_group+0x1d6/0x2e0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa029b97e>]
btrfs_relocate_chunk.isra.20+0x3e/0xc0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa029c551>]
btrfs_shrink_device+0x1f1/0x470 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02a0bbb>]
btrfs_rm_device+0x36b/0x860 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02abe5f>]
btrfs_ioctl+0xeff/0x2950 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff811e8731>] ?
putname+0x41/0x80
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff811e942e>] ?
user_path_at_empty+0x6e/0xd0
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff81193c0f>] ?
__vma_link_rb+0x6f/0x90
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff811ebd06>]
do_vfs_ioctl+0x2c6/0x4d0
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff811ddd03>] ?
SyS_newstat+0x33/0x60
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff811ebf91>]
SyS_ioctl+0x81/0xa0
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff8157a7c9>]
system_call_fastpath+0x12/0x17
Jul 04 11:49:09 the-server.la-la.lan kernel: ---[ end trace
6d8a8c57a9a3051d ]---
Jul 04 11:49:09 the-server.la-la.lan kernel: ------------[ cut here
]------------
Jul 04 11:49:09 the-server.la-la.lan kernel: WARNING: CPU: 2 PID: 3816
at fs/btrfs/delayed-ref.c:475 update_existing_ref.isra.2+0x1b5/0x1e0
[btrfs]()
Jul 04 11:49:09 the-server.la-la.lan kernel: Modules linked in:
xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype
iptable_filter br_netfilter nf_nat nf_conntrack bridge stp llc macvlan
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm mxm_wmi crct10dif_pclmul crc32_pclmul iTCO_wdt
iTCO_vendor_support snd_hda_codec_hdmi ghash_clmulni_intel
snd_hda_codec_realtek aesni_intel snd_hda_codec_generic aes_x86_64 lrw
gf128mul glue_helper ablk_helper cryptd serio_raw pcspkr i2c_i801
snd_hda_intel joydev evdev snd_hda_controller mousedev snd_hda_codec
mac_hid tg3 snd_hwdep snd_pcm lpc_ich ptp pps_core snd_timer libphy
snd mei_me mei soundcore battery nuvoton_cir rc_core tpm_tis wmi tpm
i915 video drm_kms_helper drm intel_gtt i2c_algo_bit i2c_core
Jul 04 11:49:09 the-server.la-la.lan kernel:  ie31200_edac shpchp
edac_core processor button sch_fq_codel fuse ip_tables x_tables btrfs
xor raid6_pq hid_generic usbhid hid sd_mod atkbd libps2 crc32c_intel
xhci_pci ahci ehci_pci libahci ehci_hcd xhci_hcd mpt2sas libata
raid_class scsi_transport_sas usbcore usb_common scsi_mod i8042 serio
Jul 04 11:49:09 the-server.la-la.lan kernel: CPU: 2 PID: 3816 Comm:
btrfs Tainted: G        W       4.0.7-2-ARCH #1
Jul 04 11:49:09 the-server.la-la.lan kernel: Hardware name: To Be
Filled By O.E.M. To Be Filled By O.E.M./Z77 Extreme4, BIOS P2.90
07/11/2013
Jul 04 11:49:09 the-server.la-la.lan kernel:  0000000000000000
00000000b63f28db ffff8800ac81f688 ffffffff81574ec3
Jul 04 11:49:09 the-server.la-la.lan kernel:  0000000000000000
0000000000000000 ffff8800ac81f6c8 ffffffff81074e7a
Jul 04 11:49:09 the-server.la-la.lan kernel:  0000000000000000
ffff8801f38fbaa8 ffff8801f38fa2e8 ffff8800c8956bb0
Jul 04 11:49:09 the-server.la-la.lan kernel: Call Trace:
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff81574ec3>]
dump_stack+0x4c/0x6e
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff81074e7a>]
warn_slowpath_common+0x8a/0xc0
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff81074faa>]
warn_slowpath_null+0x1a/0x20
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02bf8a5>]
update_existing_ref.isra.2+0x1b5/0x1e0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02bf9bc>]
add_delayed_tree_ref+0xec/0x1b0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02c07fe>]
btrfs_add_delayed_tree_ref+0x10e/0x180 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa025a730>]
btrfs_free_extent+0xe0/0x140 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02469f6>] ?
btrfs_release_path+0x46/0xb0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa025aabe>]
do_walk_down+0x32e/0x9d0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa0258ad2>] ?
walk_down_proc+0x312/0x330 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa025b22d>]
walk_down_tree+0xcd/0x110 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa025ee3f>]
btrfs_drop_snapshot+0x3ff/0x8a0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02c7c39>]
merge_reloc_roots+0xe9/0x280 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02c803e>]
relocate_block_group+0x26e/0x720 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02c86c6>]
btrfs_relocate_block_group+0x1d6/0x2e0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa029b97e>]
btrfs_relocate_chunk.isra.20+0x3e/0xc0 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa029c551>]
btrfs_shrink_device+0x1f1/0x470 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02a0bbb>]
btrfs_rm_device+0x36b/0x860 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffffa02abe5f>]
btrfs_ioctl+0xeff/0x2950 [btrfs]
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff811e8731>] ?
putname+0x41/0x80
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff811e942e>] ?
user_path_at_empty+0x6e/0xd0
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff81193c0f>] ?
__vma_link_rb+0x6f/0x90
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff811ebd06>]
do_vfs_ioctl+0x2c6/0x4d0
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff811ddd03>] ?
SyS_newstat+0x33/0x60
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff811ebf91>]
SyS_ioctl+0x81/0xa0
Jul 04 11:49:09 the-server.la-la.lan kernel:  [<ffffffff8157a7c9>]
system_call_fastpath+0x12/0x17
Jul 04 11:49:09 the-server.la-la.lan kernel: ---[ end trace
6d8a8c57a9a3051e ]---
Jul 04 11:49:15 the-server.la-la.lan kernel: ------------[ cut here
]------------
Jul 04 11:49:15 the-server.la-la.lan kernel: kernel BUG at
fs/btrfs/extent-tree.c:2248!
Jul 04 11:49:15 the-server.la-la.lan kernel: invalid opcode: 0000 [#1]
PREEMPT SMP
Jul 04 11:49:15 the-server.la-la.lan kernel: Modules linked in:
xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype
iptable_filter br_netfilter nf_nat nf_conntrack bridge stp llc macvlan
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm mxm_wmi crct10dif_pclmul crc32_pclmul iTCO_wdt
iTCO_vendor_support snd_hda_codec_hdmi ghash_clmulni_intel
snd_hda_codec_realtek aesni_intel snd_hda_codec_generic aes_x86_64 lrw
gf128mul glue_helper ablk_helper cryptd serio_raw pcspkr i2c_i801
snd_hda_intel joydev evdev snd_hda_controller mousedev snd_hda_codec
mac_hid tg3 snd_hwdep snd_pcm lpc_ich ptp pps_core snd_timer libphy
snd mei_me mei soundcore battery nuvoton_cir rc_core tpm_tis wmi tpm
i915 video drm_kms_helper drm intel_gtt i2c_algo_bit i2c_core
Jul 04 11:49:15 the-server.la-la.lan kernel:  ie31200_edac shpchp
edac_core processor button sch_fq_codel fuse ip_tables x_tables btrfs
xor raid6_pq hid_generic usbhid hid sd_mod atkbd libps2 crc32c_intel
xhci_pci ahci ehci_pci libahci ehci_hcd xhci_hcd mpt2sas libata
raid_class scsi_transport_sas usbcore usb_common scsi_mod i8042 serio
Jul 04 11:49:15 the-server.la-la.lan kernel: CPU: 2 PID: 3816 Comm:
btrfs Tainted: G        W       4.0.7-2-ARCH #1
Jul 04 11:49:15 the-server.la-la.lan kernel: Hardware name: To Be
Filled By O.E.M. To Be Filled By O.E.M./Z77 Extreme4, BIOS P2.90
07/11/2013
Jul 04 11:49:15 the-server.la-la.lan kernel: task: ffff8800ce75a880
ti: ffff8800ac81c000 task.ti: ffff8800ac81c000
Jul 04 11:49:15 the-server.la-la.lan kernel: RIP:
0010:[<ffffffffa025c34a>]  [<ffffffffa025c34a>]
__btrfs_run_delayed_refs+0x10da/0x12c0 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel: RSP:
0018:ffff8800ac81f808  EFLAGS: 00010202
Jul 04 11:49:15 the-server.la-la.lan kernel: RAX: 0000000000004000
RBX: 000014a133e6c000 RCX: ffff8801b67aeb00
Jul 04 11:49:15 the-server.la-la.lan kernel: RDX: 0000000000000000
RSI: ffff88020f823070 RDI: ffff88020f823068
Jul 04 11:49:15 the-server.la-la.lan kernel: RBP: ffff8800ac81f938
R08: ffff8802066b60b1 R09: 0000000000000001
Jul 04 11:49:15 the-server.la-la.lan kernel: R10: ffffea0007ce5a40
R11: 00000000000029ea R12: ffff88020f823000
Jul 04 11:49:15 the-server.la-la.lan kernel: R13: 0000000000000000
R14: ffff88018576b268 R15: ffff8800c8956bb0
Jul 04 11:49:15 the-server.la-la.lan kernel: FS:
00007f58481468c0(0000) GS:ffff88021f300000(0000)
knlGS:0000000000000000
Jul 04 11:49:15 the-server.la-la.lan kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jul 04 11:49:15 the-server.la-la.lan kernel: CR2: 00007f9942eb2148
CR3: 00000000af3f9000 CR4: 00000000001407e0
Jul 04 11:49:15 the-server.la-la.lan kernel: Stack:
Jul 04 11:49:15 the-server.la-la.lan kernel:  0000000000000001
0000000000000000 ffff880000000001 0000000000000001
Jul 04 11:49:15 the-server.la-la.lan kernel:  0000000000000000
ffffffff812e8fbd 000012d50a62c000 0000000000004000
Jul 04 11:49:15 the-server.la-la.lan kernel:  ffff8800c8956bb0
ffff8801d0b81800 ffff8800ac81f878 ffffffffa02540da
Jul 04 11:49:15 the-server.la-la.lan kernel: Call Trace:
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffff812e8fbd>] ?
__percpu_counter_add+0x5d/0xa0
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa02540da>] ?
add_pinned_bytes+0x4a/0x60 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa025ccd7>] ?
walk_up_proc+0xd7/0x500 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa0260893>]
btrfs_run_delayed_refs.part.35+0x73/0x270 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa0260aa5>]
btrfs_run_delayed_refs+0x15/0x30 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa0271218>]
btrfs_should_end_transaction+0x58/0x60 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa025ee95>]
btrfs_drop_snapshot+0x455/0x8a0 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa02c7c39>]
merge_reloc_roots+0xe9/0x280 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa02c803e>]
relocate_block_group+0x26e/0x720 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa02c86c6>]
btrfs_relocate_block_group+0x1d6/0x2e0 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa029b97e>]
btrfs_relocate_chunk.isra.20+0x3e/0xc0 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa029c551>]
btrfs_shrink_device+0x1f1/0x470 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa02a0bbb>]
btrfs_rm_device+0x36b/0x860 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffffa02abe5f>]
btrfs_ioctl+0xeff/0x2950 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffff811e8731>] ?
putname+0x41/0x80
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffff811e942e>] ?
user_path_at_empty+0x6e/0xd0
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffff81193c0f>] ?
__vma_link_rb+0x6f/0x90
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffff811ebd06>]
do_vfs_ioctl+0x2c6/0x4d0
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffff811ddd03>] ?
SyS_newstat+0x33/0x60
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffff811ebf91>]
SyS_ioctl+0x81/0xa0
Jul 04 11:49:15 the-server.la-la.lan kernel:  [<ffffffff8157a7c9>]
system_call_fastpath+0x12/0x17
Jul 04 11:49:15 the-server.la-la.lan kernel: Code: a5 48 ff ff ff 4c
8b ad 40 ff ff ff 44 8b 95 38 ff ff ff 65 ff 0d 1f f5 da 5f 74 05 e9
10 f9 ff ff e8 ec 12 07 e1 e9 06 f9 ff ff <0f> 0b 3c b6 0f 84 5c fc ff
ff 3c b8 0f 85 c4 f6 ff ff 48 8b 3d
Jul 04 11:49:15 the-server.la-la.lan kernel: RIP  [<ffffffffa025c34a>]
__btrfs_run_delayed_refs+0x10da/0x12c0 [btrfs]
Jul 04 11:49:15 the-server.la-la.lan kernel:  RSP <ffff8800ac81f808>
Jul 04 11:49:15 the-server.la-la.lan kernel: ---[ end trace
6d8a8c57a9a3051f ]---
Jul 04 11:49:35 the-server.la-la.lan kernel: ------------[ cut here
]------------
Jul 04 11:49:35 the-server.la-la.lan kernel: kernel BUG at
fs/btrfs/extent-tree.c:2248!
Jul 04 11:49:35 the-server.la-la.lan kernel: invalid opcode: 0000 [#2]
PREEMPT SMP
Jul 04 11:49:35 the-server.la-la.lan kernel: Modules linked in:
xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype
iptable_filter br_netfilter nf_nat nf_conntrack bridge stp llc macvlan
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm mxm_wmi crct10dif_pclmul crc32_pclmul iTCO_wdt
iTCO_vendor_support snd_hda_codec_hdmi ghash_clmulni_intel
snd_hda_codec_realtek aesni_intel snd_hda_codec_generic aes_x86_64 lrw
gf128mul glue_helper ablk_helper cryptd serio_raw pcspkr i2c_i801
snd_hda_intel joydev evdev snd_hda_controller mousedev snd_hda_codec
mac_hid tg3 snd_hwdep snd_pcm lpc_ich ptp pps_core snd_timer libphy
snd mei_me mei soundcore battery nuvoton_cir rc_core tpm_tis wmi tpm
i915 video drm_kms_helper drm intel_gtt i2c_algo_bit i2c_core
Jul 04 11:49:35 the-server.la-la.lan kernel:  ie31200_edac shpchp
edac_core processor button sch_fq_codel fuse ip_tables x_tables btrfs
xor raid6_pq hid_generic usbhid hid sd_mod atkbd libps2 crc32c_intel
xhci_pci ahci ehci_pci libahci ehci_hcd xhci_hcd mpt2sas libata
raid_class scsi_transport_sas usbcore usb_common scsi_mod i8042 serio
Jul 04 11:49:35 the-server.la-la.lan kernel: CPU: 2 PID: 3651 Comm:
btrfs-transacti Tainted: G      D W       4.0.7-2-ARCH #1
Jul 04 11:49:35 the-server.la-la.lan kernel: Hardware name: To Be
Filled By O.E.M. To Be Filled By O.E.M./Z77 Extreme4, BIOS P2.90
07/11/2013
Jul 04 11:49:35 the-server.la-la.lan kernel: task: ffff8800c658e540
ti: ffff8800af230000 task.ti: ffff8800af230000
Jul 04 11:49:35 the-server.la-la.lan kernel: RIP:
0010:[<ffffffffa025c34a>]  [<ffffffffa025c34a>]
__btrfs_run_delayed_refs+0x10da/0x12c0 [btrfs]
Jul 04 11:49:35 the-server.la-la.lan kernel: RSP:
0018:ffff8800af233c08  EFLAGS: 00010202
Jul 04 11:49:35 the-server.la-la.lan kernel: RAX: 0000000000004000
RBX: 000014a133e6c000 RCX: ffff8801b67ae4d0
Jul 04 11:49:35 the-server.la-la.lan kernel: RDX: 0000000000000000
RSI: ffff88020f823d90 RDI: ffff88020f823d88
Jul 04 11:49:35 the-server.la-la.lan kernel: RBP: ffff8800af233d38
R08: ffff8802066b6269 R09: 0000000000000001
Jul 04 11:49:35 the-server.la-la.lan kernel: R10: ffffea0007ce5a40
R11: 00000000000029ea R12: ffff88020f823d20
Jul 04 11:49:35 the-server.la-la.lan kernel: R13: 0000000000000000
R14: ffff88018576b420 R15: ffff8800c8956d10
Jul 04 11:49:35 the-server.la-la.lan kernel: FS:
0000000000000000(0000) GS:ffff88021f300000(0000)
knlGS:0000000000000000
Jul 04 11:49:35 the-server.la-la.lan kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jul 04 11:49:35 the-server.la-la.lan kernel: CR2: 00000000016e38e0
CR3: 000000000180b000 CR4: 00000000001407e0
Jul 04 11:49:35 the-server.la-la.lan kernel: Stack:
Jul 04 11:49:35 the-server.la-la.lan kernel:  0000000000000001
0000000000000000 000015b100000001 ffff880000000001
Jul 04 11:49:35 the-server.la-la.lan kernel:  0000000000000000
ffff8800c658e5a8 ffff88021f313eb0 ffff8800c658e5a8
Jul 04 11:49:35 the-server.la-la.lan kernel:  ffff88021f313eb0
0000000000000001 ffff8800af233ca8 ffffffff810abedb
Jul 04 11:49:35 the-server.la-la.lan kernel: Call Trace:
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffff810abedb>] ?
dequeue_entity+0x13b/0x5c0
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffff810145a8>] ?
__switch_to+0xe8/0x610
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffffa0260893>]
btrfs_run_delayed_refs.part.35+0x73/0x270 [btrfs]
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffffa0260aa5>]
btrfs_run_delayed_refs+0x15/0x30 [btrfs]
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffffa0271882>]
btrfs_commit_transaction+0x52/0xc10 [btrfs]
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffffa02724d5>] ?
start_transaction+0x95/0x5a0 [btrfs]
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffffa026d3a5>]
transaction_kthread+0x1d5/0x240 [btrfs]
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffffa026d1d0>] ?
btrfs_cleanup_transaction+0x5a0/0x5a0 [btrfs]
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffff810934b8>]
kthread+0xd8/0xf0
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffff810933e0>] ?
kthread_worker_fn+0x170/0x170
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffff8157a718>]
ret_from_fork+0x58/0x90
Jul 04 11:49:35 the-server.la-la.lan kernel:  [<ffffffff810933e0>] ?
kthread_worker_fn+0x170/0x170
Jul 04 11:49:35 the-server.la-la.lan kernel: Code: a5 48 ff ff ff 4c
8b ad 40 ff ff ff 44 8b 95 38 ff ff ff 65 ff 0d 1f f5 da 5f 74 05 e9
10 f9 ff ff e8 ec 12 07 e1 e9 06 f9 ff ff <0f> 0b 3c b6 0f 84 5c fc ff
ff 3c b8 0f 85 c4 f6 ff ff 48 8b 3d
Jul 04 11:49:35 the-server.la-la.lan kernel: RIP  [<ffffffffa025c34a>]
__btrfs_run_delayed_refs+0x10da/0x12c0 [btrfs]
Jul 04 11:49:35 the-server.la-la.lan kernel:  RSP <ffff8800af233c08>
Jul 04 11:49:35 the-server.la-la.lan kernel: ---[ end trace
6d8a8c57a9a30520 ]---

I only included two of the "update_existing_ref" errors, but there
were quite a few of them.

The array is still readable, and obviously all important data is
backed up - but I'd like to know where to go from here to troubleshoot
both the array and this crash.

Thank you,
David Wilhelm
