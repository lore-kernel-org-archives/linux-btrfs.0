Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36496 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752420AbcLIBMJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 20:12:09 -0500
Received: by mail-wm0-f45.google.com with SMTP id g23so4461151wme.1
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 17:12:08 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Fri, 9 Dec 2016 03:12:06 +0200
Message-ID: <CAOE4rSw35049cf5JHg5OURf8eM9dQUc__Fuy0ZX5syjpwA4f_w@mail.gmail.com>
Subject: WARNING at extent-tree.c:1621 lookup_inline_extent_backref and
 extent-tree.c:2960 btrfs_run_delayed_refs (Linux 4.8.11)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Basically some sectors on multi-disk btrfs filesystem got corrupted
due HDD fault.
Now after scrub have finished (with some uncorrectable errors) when
doing metadata balance

$ btrfs balance start -m /mnt/Data

[  612.683979] WARNING: CPU: 0 PID: 6 at
/mnt/linux/fs/btrfs/extent-tree.c:1621
lookup_inline_extent_backref+0x45a/0x5a0 [btrfs]
[  612.683980] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_broute ebtable_nat ip6table_mangle ip6table_security
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
iptable_mangle iptable_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
ebtable_filter ebtables ip6table_filter bridge ip6_tables stp
iptable_filter llc it87 hwmon_vid kvm_amd kvm irqbypass
crct10dif_pclmul saa7134_alsa crc32_pclmul snd_hda_codec_hdmi
snd_hda_codec_realtek ghash_clmulni_intel aesni_intel
snd_hda_codec_generic aes_x86_64 saa7134 lrw gf128mul snd_hda_intel
[  612.684023]  tveeprom snd_hda_codec glue_helper rc_core ablk_helper
snd_hda_core v4l2_common cryptd videobuf2_dma_sg videobuf2_memops
videobuf2_v4l2 videobuf2_core videodev mac_hid evdev mxm_wmi pcspkr
k10temp fam15h_power media r8169 mii snd_hwdep snd_pcm snd_timer snd
sp5100_tco acpi_cpufreq shpchp tpm_infineon tpm_tis tpm_tis_core wmi
button tpm i2c_piix4 soundcore nfsd auth_rpcgss oid_registry nfs_acl
lockd sch_fq_codel grace sunrpc nvidia_uvm(PO) btrfs xor zlib_deflate
raid6_pq sd_mod ata_generic pata_acpi serio_raw atkbd libps2
nvidia_drm(PO) nvidia_modeset(PO) ohci_pci nvidia(PO) drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops xhci_pci drm xhci_hcd
firewire_ohci ohci_hcd ehci_pci ehci_hcd firewire_core crc_itu_t
pata_atiixp usbcore ahci libahci usb_common i2c_core i8042 serio
[  612.684077]  mvsas libsas scsi_transport_sas libata scsi_mod
crc32c_generic crc32c_intel vfat fat ip_tables x_tables
[  612.684088] CPU: 0 PID: 6 Comm: kworker/u16:0 Tainted: P
O    4.8.11-ARCH-dirty #1
[  612.684089] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  612.684107] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  612.684110]  0000000000000286 00000000defb6477 ffff880612f27a10
ffffffff812e9a00
[  612.684113]  0000000000000000 0000000000000000 ffff880612f27a50
ffffffff8107bcab
[  612.684116]  0000065500000053 ffff880477ed6e00 0000009626bbf000
0000000000000000
[  612.684119] Call Trace:
[  612.684125]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[  612.684128]  [<ffffffff8107bcab>] __warn+0xcb/0xf0
[  612.684131]  [<ffffffff8107bddd>] warn_slowpath_null+0x1d/0x20
[  612.684145]  [<ffffffffa10840aa>]
lookup_inline_extent_backref+0x45a/0x5a0 [btrfs]
[  612.684159]  [<ffffffffa1076a2b>] ? leaf_space_used+0xeb/0x120 [btrfs]
[  612.684174]  [<ffffffffa10853c8>]
insert_inline_extent_backref+0x68/0xf0 [btrfs]
[  612.684188]  [<ffffffffa10785ba>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  612.684202]  [<ffffffffa1085a8c>]
__btrfs_inc_extent_ref.isra.22+0x9c/0x260 [btrfs]
[  612.684218]  [<ffffffffa10f7def>] ? find_ref_head+0x6f/0x80 [btrfs]
[  612.684233]  [<ffffffffa108b568>]
__btrfs_run_delayed_refs+0x768/0x12e0 [btrfs]
[  612.684249]  [<ffffffffa108f1a1>] btrfs_run_delayed_refs+0xa1/0x2a0 [btrfs]
[  612.684264]  [<ffffffffa108f434>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[  612.684281]  [<ffffffffa10dae9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[  612.684298]  [<ffffffffa10db19e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[  612.684302]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[  612.684304]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[  612.684307]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[  612.684310]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[  612.684312]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[  612.684316]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[  612.684319]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[  612.684320] ---[ end trace 89b3284677d454e0 ]---
[  612.684323] ------------[ cut here ]------------
[  612.684339] WARNING: CPU: 0 PID: 6 at
/mnt/linux/fs/btrfs/extent-tree.c:2960
btrfs_run_delayed_refs+0x277/0x2a0 [btrfs]
[  612.684340] BTRFS: Transaction aborted (error -5)
[  612.684340] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_broute ebtable_nat ip6table_mangle ip6table_security
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
iptable_mangle iptable_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
ebtable_filter ebtables ip6table_filter bridge ip6_tables stp
iptable_filter llc it87 hwmon_vid kvm_amd kvm irqbypass
crct10dif_pclmul saa7134_alsa crc32_pclmul snd_hda_codec_hdmi
snd_hda_codec_realtek ghash_clmulni_intel aesni_intel
snd_hda_codec_generic aes_x86_64 saa7134 lrw gf128mul snd_hda_intel
[  612.684375]  tveeprom snd_hda_codec glue_helper rc_core ablk_helper
snd_hda_core v4l2_common cryptd videobuf2_dma_sg videobuf2_memops
videobuf2_v4l2 videobuf2_core videodev mac_hid evdev mxm_wmi pcspkr
k10temp fam15h_power media r8169 mii snd_hwdep snd_pcm snd_timer snd
sp5100_tco acpi_cpufreq shpchp tpm_infineon tpm_tis tpm_tis_core wmi
button tpm i2c_piix4 soundcore nfsd auth_rpcgss oid_registry nfs_acl
lockd sch_fq_codel grace sunrpc nvidia_uvm(PO) btrfs xor zlib_deflate
raid6_pq sd_mod ata_generic pata_acpi serio_raw atkbd libps2
nvidia_drm(PO) nvidia_modeset(PO) ohci_pci nvidia(PO) drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops xhci_pci drm xhci_hcd
firewire_ohci ohci_hcd ehci_pci ehci_hcd firewire_core crc_itu_t
pata_atiixp usbcore ahci libahci usb_common i2c_core i8042 serio
[  612.684419]  mvsas libsas scsi_transport_sas libata scsi_mod
crc32c_generic crc32c_intel vfat fat ip_tables x_tables
[  612.684427] CPU: 0 PID: 6 Comm: kworker/u16:0 Tainted: P        W
O    4.8.11-ARCH-dirty #1
[  612.684428] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  612.684446] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  612.684447]  0000000000000286 00000000defb6477 ffff880612f27c90
ffffffff812e9a00
[  612.684451]  ffff880612f27ce0 0000000000000000 ffff880612f27cd0
ffffffff8107bcab
[  612.684454]  00000b900000000e ffffffffa11317d8 ffff880610076c80
0000000000000020
[  612.684457] Call Trace:
[  612.684459]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[  612.684462]  [<ffffffff8107bcab>] __warn+0xcb/0xf0
[  612.684465]  [<ffffffff8107bd2f>] warn_slowpath_fmt+0x5f/0x80
[  612.684480]  [<ffffffffa108bea5>] ?
__btrfs_run_delayed_refs+0x10a5/0x12e0 [btrfs]
[  612.684495]  [<ffffffffa108f377>] btrfs_run_delayed_refs+0x277/0x2a0 [btrfs]
[  612.684510]  [<ffffffffa108f434>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[  612.684528]  [<ffffffffa10dae9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[  612.684545]  [<ffffffffa10db19e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[  612.684548]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[  612.684550]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[  612.684552]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[  612.684555]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[  612.684557]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[  612.684560]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[  612.684563]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[  612.684565] ---[ end trace 89b3284677d454e1 ]---
[  612.684567] BTRFS: error (device sdg) in
btrfs_run_delayed_refs:2960: errno=-5 IO failure
[  612.684625] BTRFS info (device sdg): forced readonly



Label: 'Data'  uuid: 1ec5b839-acc6-4f70-be9d-6f9e6118c71c
        Total devices 9 FS bytes used 11.79TiB
        devid    1 size 2.73TiB used 2.73TiB path /dev/sdc
        devid    3 size 1.82TiB used 1.81TiB path /dev/sde
        devid    4 size 1.82TiB used 1.82TiB path /dev/sdg
        devid    5 size 931.51GiB used 928.47GiB path /dev/sdh
        devid    6 size 1.82TiB used 1.81TiB path /dev/sdd
        devid    7 size 2.73TiB used 2.72TiB path /dev/sdp
        devid    8 size 2.73TiB used 5.00GiB path /dev/sdb
        devid    9 size 2.73TiB used 5.00GiB path /dev/sdf
        devid   10 size 2.73TiB used 4.00GiB path /dev/sdo

Data, single: total=11.76TiB, used=11.76TiB
System, RAID1: total=32.00MiB, used=1.50MiB
Metadata, RAID1: total=28.00GiB, used=27.08GiB
GlobalReserve, single: total=512.00MiB, used=158.19MiB

Overall:
    Device size:                  20.01TiB
    Device allocated:             11.82TiB
    Device unallocated:            8.19TiB
    Device missing:                  0.00B
    Used:                         11.81TiB
    Free (estimated):              8.20TiB      (min: 4.10TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 158.19MiB)

Data,single: Size:11.76TiB, Used:11.76TiB
   /dev/sdb        1.00GiB
   /dev/sdc        2.73TiB
   /dev/sdd        1.79TiB
   /dev/sde        1.81TiB
   /dev/sdf        1.00GiB
   /dev/sdg        1.82TiB
   /dev/sdh      928.47GiB
   /dev/sdp        2.70TiB

Metadata,RAID1: Size:28.00GiB, Used:27.08GiB
   /dev/sdb        4.00GiB
   /dev/sdd       22.00GiB
   /dev/sdf        4.00GiB
   /dev/sdo        4.00GiB
   /dev/sdp       22.00GiB

System,RAID1: Size:32.00MiB, Used:1.50MiB
   /dev/sdd       32.00MiB
   /dev/sdp       32.00MiB

Unallocated:
   /dev/sdb        2.72TiB
   /dev/sdc        3.05GiB
   /dev/sdd        4.06GiB
   /dev/sde        5.03GiB
   /dev/sdf        2.72TiB
   /dev/sdg       41.02MiB
   /dev/sdh        3.04GiB
   /dev/sdo        2.72TiB
   /dev/sdp        5.06GiB
