Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34358 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752418AbcLXRf3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Dec 2016 12:35:29 -0500
Received: by mail-io0-f172.google.com with SMTP id p42so274423554ioo.1
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Dec 2016 09:35:29 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Sat, 24 Dec 2016 19:35:28 +0200
Message-ID: <CAOE4rSyfCg5CT3+_ip+pgfcXd9KvTLTfX2P2ea+e-feP_jN0pQ@mail.gmail.com>
Subject: [BUG] kernel BUG at fs/btrfs/extent_io.c:2315 btrfs_check_repairable (v4.8.11)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs scrub on two disk RAID1 btrfs partition with compression enabled
causes kernel panic.

Note that these kernel panics looks about same as I reported year ago
which I had on different btrfs partition. See
http://www.spinics.net/lists/linux-btrfs/msg46660.html

extent_io.c:2315 is
BUG_ON(failrec->this_mirror != failed_mirror);


kernel log while doing scrub

[ 3109.019982] BTRFS error (device sdn): parent transid verify failed
on 1794259419136 wanted 772699 found 771854
[ 3109.080764] BTRFS info (device sdn): read error corrected: ino 1
off 1794259419136 (dev /dev/sdn sector 1576435968)
[ 3109.083452] BTRFS info (device sdn): read error corrected: ino 1
off 1794259423232 (dev /dev/sdn sector 1576435976)
[ 3109.085865] BTRFS info (device sdn): read error corrected: ino 1
off 1794259427328 (dev /dev/sdn sector 1576435984)
[ 3109.089351] BTRFS info (device sdn): read error corrected: ino 1
off 1794259431424 (dev /dev/sdn sector 1576435992)
[ 3241.066275] BTRFS warning (device sdn): checksum error at logical
1816149245952 on dev /dev/sdn, sector 1082318624, root 497, inode
2518996, offset 0, length 4096, links 1 (path: .config/chromium/Local
State)
[ 3241.066284] BTRFS error (device sdn): bdev /dev/sdn errs: wr 73679,
rd 2, flush 205, corrupt 4, gen 0
[ 3241.066860] BTRFS error (device sdn): fixed up error at logical
1816149245952 on dev /dev/sdn
[ 3269.456132] BTRFS info (device sdn): csum failed ino 5590401 extent
821501775872 csum 516487097 wanted 4242536704 mirror 0
[ 3269.456532] BTRFS info (device sdn): csum failed ino 5590401 extent
821501775872 csum 516487097 wanted 4242536704 mirror 0
[ 3269.456604] ------------[ cut here ]------------
[ 3269.456638] kernel BUG at /mnt/linux/fs/btrfs/extent_io.c:2315!
[ 3269.456685] invalid opcode: 0000 [#1] PREEMPT SMP
[ 3269.456715] Modules linked in: nls_iso8859_4 nls_cp775 xt_CHECKSUM
[ 3269.456764] BTRFS info (device sdn): csum failed ino 5590401 extent
821501775872 csum 516487097 wanted 4242536704 mirror 0
[ 3269.456873]  ipt_MASQUERADE
[ 3269.456903]  nf_nat_masquerade_ipv4 tun cfg80211 rfkill
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT xt_tcpudp
[ 3269.457002] BTRFS info (device sdn): csum failed ino 5590401 extent
821501775872 csum 516487097 wanted 4242536704 mirror 0
[ 3269.457103]  ip6t_rpfilter
[ 3269.457127]  ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6
xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat
nf_conntrack_ipv6
[ 3269.457261] BTRFS info (device sdn): csum failed ino 5590401 extent
821501775872 csum 516487097 wanted 4242536704 mirror 0
[ 3269.457368]  nf_defrag_ipv6
[ 3269.457397]  nf_nat_ipv6 ip6table_raw ip6table_mangle
ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack iptable_raw iptable_mangle
iptable_security bridge ebtable_filter ebtables stp llc
ip6table_filter ip6_tables iptable_filter kvm_amd kvm
snd_hda_codec_realtek saa7134_alsa snd_hda_codec_hdmi
snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul
snd_usb_audio ghash_clmulni_intel snd_hda_intel aesni_intel saa7134
aes_x86_64 snd_usbmidi_lib lrw tveeprom mousedev rc_core snd_rawmidi
snd_hda_codec snd_seq_device joydev snd_hda_core mac_hid gf128mul
v4l2_common videobuf2_dma_sg videobuf2_memops evdev videobuf2_v4l2
r8169 videobuf2_core glue_helper videodev ablk_helper mii snd_hwdep
mxm_wmi snd_pcm fam15h_power it87 cryptd k10temp pcspkr hwmon_vid
media
[ 3269.458216]  snd_timer tpm_infineon acpi_cpufreq tpm_tis snd shpchp
sp5100_tco soundcore tpm_tis_core i2c_piix4 tpm wmi button nfsd
auth_rpcgss oid_registry sch_fq_codel nfs_acl lockd vboxnetflt(O)
grace vboxnetadp(O) pci_stub vboxpci(O) sunrpc vboxdrv(O)
nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic usbhid hid
sd_mod ata_generic pata_acpi serio_raw atkbd libps2 nvidia_drm(PO)
ohci_pci nvidia_modeset(PO) nvidia(PO) firewire_ohci firewire_core
crc_itu_t pata_atiixp drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops ehci_pci drm ahci xhci_pci ehci_hcd libahci ohci_hcd
xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas libsas
scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel vfat
fat ip_tables x_tables
[ 3269.459022] CPU: 0 PID: 2525 Comm: kworker/u16:17 Tainted: P
   O    4.8.11-ARCH-dirty #1
[ 3269.459105] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 3269.459224] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[ 3269.459282] task: ffff8805f746d580 task.stack: ffff8805558b4000
[ 3269.459339] RIP: 0010:[<ffffffffa10b079c>]  [<ffffffffa10b079c>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[ 3269.459455] RSP: 0018:ffff8805558b7cc0  EFLAGS: 00010206
[ 3269.459507] RAX: 0000000000000001 RBX: ffff8805430c1f40 RCX: 0000000000000000
[ 3269.459576] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8806079a6f70
[ 3269.463064] RBP: ffff8805558b7cd8 R08: 0000025f57c00000 R09: 0000025f97c00000
[ 3269.466563] R10: ffff88054012dbd0 R11: 000000002ec05cc0 R12: 000000002ec05cc0
[ 3269.470063] R13: ffff88052ec055a8 R14: ffff88052ec055a8 R15: ffff88060f15e2f8
[ 3269.473515] FS:  0000000000000000(0000) GS:ffff88062ec00000(0000)
knlGS:0000000000000000
[ 3269.476946] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3269.480344] CR2: 00000000023b4800 CR3: 00000005f3f2a000 CR4: 00000000000406f0
[ 3269.483748] Stack:
[ 3269.487103]  ffffea0014c30f40 0000000000040000 ffff88052ec05630
ffff8805558b7d90
[ 3269.490520]  ffffffffa10b0cdf 00000001801c001a ffff8805558b7d10
ffff8805f746d580
[ 3269.493917]  ffff8805f746d580 ffff88052ec05540 ffff88060f15e148
0000000000000000
[ 3269.497296] Call Trace:
[ 3269.500636]  [<ffffffffa10b0cdf>] end_bio_extent_readpage+0x44f/0x5f0 [btrfs]
[ 3269.504004]  [<ffffffff812b0dc3>] bio_endio+0x53/0x60
[ 3269.507342]  [<ffffffffa1083a0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[ 3269.510673]  [<ffffffffa10c2e9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 3269.513996]  [<ffffffffa10c324e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[ 3269.517248]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 3269.520435]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 3269.523598]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3269.526699]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3269.529708]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 3269.532645]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 3269.535611]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 3269.538509]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 3269.541349] Code: 25 89 4b 28 e9 7c ff ff ff 44 3b 63 28 75 1c c7
43 30 00 00 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d2 8d
48 02 eb d6 <0f> 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
41 54
[ 3269.547286] RIP  [<ffffffffa10b079c>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[ 3269.550173]  RSP <ffff8805558b7cc0>
[ 3269.557632] ------------[ cut here ]------------
[ 3269.557693] ---[ end trace d5ed7a648e783b54 ]---
[ 3269.563052] kernel BUG at /mnt/linux/fs/btrfs/extent_io.c:2315!
[ 3269.565719] invalid opcode: 0000 [#2] PREEMPT SMP
[ 3269.568318] Modules linked in: nls_iso8859_4 nls_cp775 xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun cfg80211 rfkill
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT xt_tcpudp
ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6
xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_mangle ip6table_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_mangle iptable_security bridge ebtable_filter ebtables stp llc
ip6table_filter ip6_tables iptable_filter kvm_amd kvm
snd_hda_codec_realtek saa7134_alsa snd_hda_codec_hdmi
snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul
snd_usb_audio ghash_clmulni_intel snd_hda_intel aesni_intel
[ 3269.584440]  saa7134 aes_x86_64 snd_usbmidi_lib lrw tveeprom
mousedev rc_core snd_rawmidi snd_hda_codec snd_seq_device joydev
snd_hda_core mac_hid gf128mul v4l2_common videobuf2_dma_sg
videobuf2_memops evdev videobuf2_v4l2 r8169 videobuf2_core glue_helper
videodev ablk_helper mii snd_hwdep mxm_wmi snd_pcm fam15h_power it87
cryptd k10temp pcspkr hwmon_vid media snd_timer tpm_infineon
acpi_cpufreq tpm_tis snd shpchp sp5100_tco soundcore tpm_tis_core
i2c_piix4 tpm wmi button nfsd auth_rpcgss oid_registry sch_fq_codel
nfs_acl lockd vboxnetflt(O) grace vboxnetadp(O) pci_stub vboxpci(O)
sunrpc vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq
hid_generic usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd
libps2 nvidia_drm(PO) ohci_pci nvidia_modeset(PO) nvidia(PO)
firewire_ohci firewire_core
[ 3269.601074]  crc_itu_t pata_atiixp drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops ehci_pci drm ahci xhci_pci ehci_hcd
libahci ohci_hcd xhci_hcd usbcore usb_common i2c_core i8042 serio
mvsas libsas scsi_transport_sas libata scsi_mod crc32c_generic
crc32c_intel vfat fat ip_tables x_tables
[ 3269.609756] CPU: 1 PID: 77 Comm: kworker/u16:1 Tainted: P      D
O    4.8.11-ARCH-dirty #1
[ 3269.612708] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 3269.615733] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[ 3269.618745] task: ffff8806128f1c80 task.stack: ffff880611844000
[ 3269.621736] RIP: 0010:[<ffffffffa10b079c>]  [<ffffffffa10b079c>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[ 3269.624809] RSP: 0018:ffff880611847cc0  EFLAGS: 00010206
[ 3269.627836] RAX: 0000000000000001 RBX: ffff8805430c1e40 RCX: 0000000000000000
[ 3269.630875] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8806079a6f70
[ 3269.633892] RBP: ffff880611847cd8 R08: 0000025f57c00000 R09: 0000025f97c00000
[ 3269.636899] R10: ffff88054012da20 R11: 000000002ec04500 R12: 000000002ec04500
[ 3269.639908] R13: ffff88052ec05828 R14: ffff88052ec05828 R15: ffff88060f15e2f8
[ 3269.642896] FS:  0000000000000000(0000) GS:ffff88062ec40000(0000)
knlGS:0000000000000000
[ 3269.645903] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3269.648897] CR2: 0000000000716420 CR3: 00000005fec76000 CR4: 00000000000406e0
[ 3269.651916] Stack:
[ 3269.654901]  ffffea0014c30f80 0000000000041000 ffff88052ec058b0
ffff880611847d90
[ 3269.657955]  ffffffffa10b0cdf 00000001801c0018 ffff880611847d10
ffff8806128f1c80
[ 3269.661019]  ffff8806128f1c80 ffff88052ec057c0 ffff88060f15e148
0000000000000000
[ 3269.664098] Call Trace:
[ 3269.667166]  [<ffffffffa10b0cdf>] end_bio_extent_readpage+0x44f/0x5f0 [btrfs]
[ 3269.670308]  [<ffffffff812b0dc3>] bio_endio+0x53/0x60
[ 3269.673457]  [<ffffffffa1083a0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[ 3269.676627]  [<ffffffffa10c2e9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 3269.679818]  [<ffffffffa10c324e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[ 3269.682989]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 3269.686105]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 3269.689164]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3269.692190]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 3269.695184]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 3269.698180]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 3269.701173]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 3269.704145] Code: 25 89 4b 28 e9 7c ff ff ff 44 3b 63 28 75 1c c7
43 30 00 00 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d2 8d
48 02 eb d6 <0f> 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
41 54
[ 3269.710433] RIP  [<ffffffffa10b079c>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[ 3269.713429]  RSP <ffff880611847cc0>
[ 3269.716360] ------------[ cut here ]------------
[ 3269.716952] ---[ end trace d5ed7a648e783b55 ]---
[ 3269.721016] kernel BUG at /mnt/linux/fs/btrfs/extent_io.c:2315!
[ 3269.723168] invalid opcode: 0000 [#3] PREEMPT SMP
[ 3269.725271] Modules linked in: nls_iso8859_4 nls_cp775 xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun cfg80211 rfkill
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT xt_tcpudp
ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6
xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_mangle ip6table_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_mangle iptable_security bridge ebtable_filter ebtables stp llc
ip6table_filter ip6_tables iptable_filter kvm_amd kvm
snd_hda_codec_realtek saa7134_alsa snd_hda_codec_hdmi
snd_hda_codec_generic irqbypass crct10dif_pclmul crc32_pclmul
snd_usb_audio ghash_clmulni_intel snd_hda_intel aesni_intel
[ 3269.738315]  saa7134 aes_x86_64 snd_usbmidi_lib lrw tveeprom
mousedev rc_core snd_rawmidi snd_hda_codec snd_seq_device joydev
snd_hda_core mac_hid gf128mul v4l2_common videobuf2_dma_sg
videobuf2_memops evdev videobuf2_v4l2 r8169 videobuf2_core glue_helper
videodev ablk_helper mii snd_hwdep mxm_wmi snd_pcm fam15h_power it87
cryptd k10temp pcspkr hwmon_vid media snd_timer tpm_infineon
acpi_cpufreq tpm_tis snd shpchp sp5100_tco soundcore tpm_tis_core
i2c_piix4 tpm wmi button nfsd auth_rpcgss oid_registry sch_fq_codel
nfs_acl lockd vboxnetflt(O) grace vboxnetadp(O) pci_stub vboxpci(O)
sunrpc vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq
hid_generic usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd
libps2 nvidia_drm(PO) ohci_pci nvidia_modeset(PO) nvidia(PO)
firewire_ohci firewire_core
[ 3269.751579]  crc_itu_t pata_atiixp drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops ehci_pci drm ahci xhci_pci ehci_hcd
libahci ohci_hcd xhci_hcd usbcore usb_common i2c_core i8042 serio
mvsas libsas scsi_transport_sas libata scsi_mod crc32c_generic
crc32c_intel vfat fat ip_tables x_tables
[ 3269.758429] CPU: 2 PID: 2332 Comm: kworker/u16:2 Tainted: P      D
  O    4.8.11-ARCH-dirty #1
[ 3269.760741] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 3269.763123] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[ 3269.765685] task: ffff8805f6f9c740 task.stack: ffff88058eae8000
[ 3269.768391] RIP: 0010:[<ffffffffa10b079c>]  [<ffffffffa10b079c>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[ 3269.771157] RSP: 0018:ffff88058eaebcc0  EFLAGS: 00010206
[ 3269.773882] RAX: 0000000000000001 RBX: ffff8805430c1780 RCX: 0000000000000000
[ 3269.776622] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8806079a6f70
[ 3269.779342] RBP: ffff88058eaebcd8 R08: 0000025f57c00000 R09: 0000025f97c00000
[ 3269.781706] R10: ffff88054012d240 R11: 000000002ec04f00 R12: 000000002ec04f00
[ 3269.784071] R13: ffff88052ec050a8 R14: ffff88052ec050a8 R15: ffff88060f15e2f8
[ 3269.786430] FS:  0000000000000000(0000) GS:ffff88062ec80000(0000)
knlGS:0000000000000000
[ 3269.788796] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3269.791143] CR2: 00007f10459a1170 CR3: 00000005f3f2a000 CR4: 00000000000406e0
[ 3269.793506] Stack:
[ 3269.795846]  ffffea0014c30fc0 0000000000042000 ffff88052ec05130
ffff88058eaebd90
[ 3269.798248]  ffffffffa10b0cdf 00000001801c0016 ffff88058eaebd10
ffff8805f6f9c740
[ 3269.800645]  ffff8805f6f9c740 ffff88052ec05040 ffff88060f15e148
0000000000000000
[ 3269.803052] Call Trace:
[ 3269.805452]  [<ffffffffa10b0cdf>] end_bio_extent_readpage+0x44f/0x5f0 [btrfs]
[ 3269.807889]  [<ffffffff812b0dc3>] bio_endio+0x53/0x60
[ 3269.810327]  [<ffffffffa1083a0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[ 3269.812786]  [<ffffffffa10c2e9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 3269.815263]  [<ffffffffa10c324e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[ 3269.817722]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 3269.820133]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 3269.822499]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 3269.824845]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 3269.827161]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 3269.829482]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 3269.831801]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 3269.834099] Code: 25 89 4b 28 e9 7c ff ff ff 44 3b 63 28 75 1c c7
43 30 00 00 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d2 8d
48 02 eb d6 <0f> 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
41 54
[ 3269.839009] RIP  [<ffffffffa10b079c>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[ 3269.841338]  RSP <ffff88058eaebcc0>
[ 3269.843621] ------------[ cut here ]------------
[ 3269.843688] ---[ end trace d5ed7a648e783b56 ]---
[ 3269.848012] kernel BUG at /mnt/linux/fs/btrfs/extent_io.c:2315!
[ 3269.850163] invalid opcode: 0000 [#4] PREEMPT SMP
