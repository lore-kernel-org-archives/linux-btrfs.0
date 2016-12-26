Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34362 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932257AbcLZP5d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 10:57:33 -0500
Received: by mail-io0-f173.google.com with SMTP id p42so298624981ioo.1
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Dec 2016 07:57:33 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Mon, 26 Dec 2016 17:57:32 +0200
Message-ID: <CAOE4rSxUw8rAgio7oQyvpKgpPGSpvvApc2cRSu0wM5bqvBn4QQ@mail.gmail.com>
Subject: WARNING at fs/btrfs/extent-tree.c:3201 btrfs_cross_ref_exist (v4.8.11)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When doing btrfs balance, this warning appeared in kernel log

[ 1158.352427] ------------[ cut here ]------------
[ 1158.352442] WARNING: CPU: 5 PID: 6 at
/mnt/linux/fs/btrfs/extent-tree.c:3201 btrfs_cross_ref_exist+0xe8/0xf0
[btrfs]
[ 1158.352443] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp xt_CT ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set nfnetlink
ebtable_nat ebtable_broute ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter
ip6_tables stp llc iptable_filter kvm_amd kvm irqbypass saa7134_alsa
it87 hwmon_vid crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
saa7134 aesni_intel aes_x86_64 lrw tveeprom snd_hda_codec_hdmi
snd_hda_codec_realtek gf128mul snd_hda_codec_generic
[ 1158.352477]  rc_core glue_helper v4l2_common videobuf2_dma_sg
snd_hda_intel videobuf2_memops snd_hda_codec ablk_helper
videobuf2_v4l2 r8169 cryptd videobuf2_core mac_hid videodev mxm_wmi
snd_hda_core mii evdev media k10temp fam15h_power snd_hwdep pcspkr
snd_pcm sp5100_tco snd_timer snd i2c_piix4 acpi_cpufreq shpchp
tpm_infineon tpm_tis soundcore wmi button tpm_tis_core tpm
sch_fq_codel vboxnetflt(O) vboxnetadp(O) nfsd pci_stub auth_rpcgss
oid_registry nfs_acl lockd grace sunrpc vboxpci(O) vboxdrv(O)
nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq sd_mod ata_generic
pata_acpi serio_raw atkbd libps2 ohci_pci nvidia_drm(PO)
nvidia_modeset(PO) nvidia(PO) firewire_ohci firewire_core crc_itu_t
drm_kms_helper pata_atiixp syscopyarea sysfillrect ehci_pci sysimgblt
fb_sys_fops xhci_pci ohci_hcd xhci_hcd ehci_hcd
[ 1158.352519]  ahci drm libahci usbcore usb_common i2c_core i8042
serio mvsas libsas scsi_transport_sas libata scsi_mod crc32c_generic
crc32c_intel vfat fat ip_tables x_tables
[ 1158.352582] CPU: 5 PID: 6 Comm: kworker/u16:0 Tainted: P        W
O    4.8.11-ARCH-dirty #1
[ 1158.352583] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 1158.352585] Workqueue: writeback wb_workfn (flush-btrfs-5)
[ 1158.352588]  0000000000000286 00000000f6b4c4af ffff880612f276f0
ffffffff812e9a00
[ 1158.352591]  0000000000000000 0000000000000000 ffff880612f27730
ffffffff8107bcab
[ 1158.352594]  00000c8100000002 ffff88060115f000 ffff880609ada800
0000000000000001
[ 1158.352598] Call Trace:
[ 1158.352600]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[ 1158.352602]  [<ffffffff8107bcab>] __warn+0xcb/0xf0
[ 1158.352605]  [<ffffffff8107bddd>] warn_slowpath_null+0x1d/0x20
[ 1158.352619]  [<ffffffffa10785a8>] btrfs_cross_ref_exist+0xe8/0xf0 [btrfs]
[ 1158.352636]  [<ffffffffa109d3d2>] run_delalloc_nocow+0x7b2/0xbd0 [btrfs]
[ 1158.352654]  [<ffffffffa109db96>] run_delalloc_range+0x3a6/0x3c0 [btrfs]
[ 1158.352673]  [<ffffffffa10b6cb5>]
writepage_delalloc.isra.20+0x105/0x170 [btrfs]
[ 1158.352691]  [<ffffffffa10b95a9>] __extent_writepage+0xd9/0x370 [btrfs]
[ 1158.352693]  [<ffffffff811b38f0>] ? __page_check_address+0x1c0/0x1c0
[ 1158.352711]  [<ffffffffa10b9aff>]
extent_write_cache_pages.isra.16.constprop.31+0x2bf/0x400 [btrfs]
[ 1158.352730]  [<ffffffffa10ba41d>] extent_writepages+0x5d/0x90 [btrfs]
[ 1158.352747]  [<ffffffffa1099790>] ? btrfs_direct_IO+0x380/0x380 [btrfs]
[ 1158.352764]  [<ffffffffa1097c38>] btrfs_writepages+0x28/0x30 [btrfs]
[ 1158.352766]  [<ffffffff8117de0e>] do_writepages+0x1e/0x30
[ 1158.352769]  [<ffffffff81229525>] __writeback_single_inode+0x45/0x3b0
[ 1158.352771]  [<ffffffff81229e2a>] writeback_sb_inodes+0x2ba/0x5c0
[ 1158.352773]  [<ffffffff8122a3cb>] wb_writeback+0x10b/0x350
[ 1158.352775]  [<ffffffff8122adc2>] wb_workfn+0x112/0x450
[ 1158.352778]  [<ffffffff810b9e39>] ? pick_next_task_fair+0x309/0x4d0
[ 1158.352781]  [<ffffffff810a27a7>] ? finish_task_switch+0x77/0x1e0
[ 1158.352783]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 1158.352786]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 1158.352788]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 1158.352791]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 1158.352793]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 1158.352796]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 1158.352799]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 1158.352800] ---[ end trace 8e5f1bbb5e9b7cb6 ]---
