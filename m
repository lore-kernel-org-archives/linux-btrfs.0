Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:32878 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbcLXCW1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 21:22:27 -0500
Received: by mail-io0-f179.google.com with SMTP id d9so265311787ioe.0
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 18:22:26 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Sat, 24 Dec 2016 04:22:24 +0200
Message-ID: <CAOE4rSz5zeQYcGU3saZOk9HHb53NOwVF_vZV6m_UgQLftr9efQ@mail.gmail.com>
Subject: [BUG] kernel BUG at fs/btrfs/extent_io.c:2041 repair_io_failure (v4.8.11)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On two disk RAID1 btrfs partition one disk went offline, other was
still writing, then kernel paniced.

Label: 'RAID1'  uuid: 8aef11a9-beb6-49ea-9b2d-7876611a39e5
        Total devices 2 FS bytes used 917.20GiB
        devid    1 size 2.73TiB used 920.03GiB path /dev/sdj
        devid    2 size 2.73TiB used 920.03GiB path /dev/sdn

Overall:
    Device size:                   5.46TiB
    Device allocated:              1.80TiB
    Device unallocated:            3.66TiB
    Device missing:                  0.00B
    Used:                          1.79TiB
    Free (estimated):              1.83TiB      (min: 1.83TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:914.00GiB, Used:912.68GiB
   /dev/sdj      914.00GiB
   /dev/sdn      914.00GiB

Metadata,RAID1: Size:6.00GiB, Used:4.52GiB
   /dev/sdj        6.00GiB
   /dev/sdn        6.00GiB

System,RAID1: Size:32.00MiB, Used:160.00KiB
   /dev/sdj       32.00MiB
   /dev/sdn       32.00MiB

Unallocated:
   /dev/sdj        1.83TiB
   /dev/sdn        1.83TiB


Now kernel panics every time after some time when accessing that partition.

extent_io.c:2041 is
BUG_ON(mirror_num != bbio->mirror_num);

dmesg

[  171.468669] BTRFS error (device sdn): parent transid verify failed
on 1794253783040 wanted 772697 found 771847
[  171.488617] BTRFS info (device sdn): read error corrected: ino 1
off 1794253783040 (dev /dev/sdn sector 1576424960)
[  171.488922] BTRFS info (device sdn): read error corrected: ino 1
off 1794253787136 (dev /dev/sdn sector 1576424968)
[  171.489207] BTRFS info (device sdn): read error corrected: ino 1
off 1794253791232 (dev /dev/sdn sector 1576424976)
[  171.489489] BTRFS info (device sdn): read error corrected: ino 1
off 1794253795328 (dev /dev/sdn sector 1576424984)
[  197.641616] BTRFS error (device sdn): parent transid verify failed
on 1794268528640 wanted 772699 found 771865
[  197.656218] BTRFS info (device sdn): read error corrected: ino 1
off 1794268528640 (dev /dev/sdn sector 1576453760)
[  197.656340] BTRFS info (device sdn): read error corrected: ino 1
off 1794268532736 (dev /dev/sdn sector 1576453768)
[  197.656453] BTRFS info (device sdn): read error corrected: ino 1
off 1794268536832 (dev /dev/sdn sector 1576453776)
[  197.656607] BTRFS info (device sdn): read error corrected: ino 1
off 1794268540928 (dev /dev/sdn sector 1576453784)
[  265.066837] BTRFS info (device sdn): csum failed ino 5590401 extent
821501775872 csum 516487097 wanted 4242536704 mirror 0
[  265.067037] BTRFS info (device sdn): csum failed ino 5590401 extent
821501775872 csum 516487097 wanted 4242536704 mirror 0
[  265.077267] ------------[ cut here ]------------
[  265.080747] kernel BUG at /mnt/linux/fs/btrfs/extent_io.c:2041!
[  265.084205] invalid opcode: 0000 [#1] PREEMPT SMP
[  265.087610] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  265.108475]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  265.129382]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  265.139737] CPU: 4 PID: 151 Comm: kworker/u16:2 Tainted: P
 O    4.8.11-ARCH-dirty #1
[  265.143160] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  265.143187] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  265.143188] task: ffff880607383900 task.stack: ffff8806073ac000
[  265.143207] RIP: 0010:[<ffffffffa10bb08d>]  [<ffffffffa10bb08d>]
repair_io_failure+0x25d/0x290 [btrfs]
[  265.143209] RSP: 0018:ffff8806073afc08  EFLAGS: 00010202
[  265.143210] RAX: 0000000000000000 RBX: 000000007d9acc80 RCX: 0000000000000000
[  265.143211] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8805f4634f00
[  265.143212] RBP: ffff8806073afc68 R08: ffff8805f4634f00 R09: ffff8805f4634f00
[  265.143213] R10: 0000000000000001 R11: 0000000000000002 R12: 0000000000001000
[  265.143214] R13: ffff88057d9ac2e8 R14: 0000025f5c820000 R15: ffff880609be2000
[  265.143218] FS:  0000000000000000(0000) GS:ffff88062ed00000(0000)
knlGS:0000000000000000
[  265.143219] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  265.143220] CR2: 00007fd8fbd82000 CR3: 0000000611098000 CR4: 00000000000406e0
[  265.143221] Stack:
[  265.143234]  0000000000040000 ffff88060e3ce730 0000000009be2120
ffffea000dc1df40
[  265.143236]  0000000000010000 ffff8805f4634f00 00000000649ea36e
ffff8805c98c3a50
[  265.143238]  0000000000040000 ffff880609be2000 ffff88060e3ce730
ffff88060e3ce5a8
[  265.143238] Call Trace:
[  265.143258]  [<ffffffffa10bb32f>] clean_io_failure+0x18f/0x1a0 [btrfs]
[  265.143277]  [<ffffffffa10bbc46>] end_bio_extent_readpage+0x3b6/0x5f0 [btrfs]
[  265.143281]  [<ffffffff812b0dc3>] bio_endio+0x53/0x60
[  265.143296]  [<ffffffffa108ea0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[  265.143313]  [<ffffffffa10cde9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[  265.143331]  [<ffffffffa10ce24e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[  265.143334]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[  265.143336]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[  265.143339]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[  265.143342]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[  265.143344]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[  265.143347]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[  265.143350]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[  265.143373] Code: 41 bb fb ff ff ff e9 42 fe ff ff be 01 00 00 00
4c 89 ff e8 d6 98 05 00 4c 89 ef e8 be 5c 1f e0 41 bb fb ff ff ff e9
22 fe ff ff <0f> 0b be 01 00 00 00 4c 89 ff e8 b4 98 05 00 4c 89 ef e8
9c 5c
[  265.143391] RIP  [<ffffffffa10bb08d>] repair_io_failure+0x25d/0x290 [btrfs]
[  265.143392]  RSP <ffff8806073afc08>
[  265.143476] ---[ end trace 1afee654ae2112b7 ]---
[  265.143490] BUG: unable to handle kernel paging request at 00000000649ea36e
[  265.143493] IP: [<ffffffff810bfeeb>] __wake_up_common+0x2b/0x80
[  265.143500] PGD 5fd872067 PUD 0
[  265.143502] Oops: 0000 [#2] PREEMPT SMP
[  265.143524] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  265.143552]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  265.143563]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  265.143565] CPU: 4 PID: 151 Comm: kworker/u16:2 Tainted: P      D
 O    4.8.11-ARCH-dirty #1
[  265.143566] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  265.143581] task: ffff880607383900 task.stack: ffff8806073ac000
[  265.143585] RIP: 0010:[<ffffffff810bfeeb>]  [<ffffffff810bfeeb>]
__wake_up_common+0x2b/0x80
[  265.143586] RSP: 0018:ffff8806073afe40  EFLAGS: 00010096
[  265.143587] RAX: 0000000000000282 RBX: ffff8806073aff10 RCX: 0000000000000000
[  265.143588] RDX: 00000000649ea36e RSI: 0000000000000003 RDI: ffff8806073aff10
[  265.143589] RBP: ffff8806073afe78 R08: 0000000000000000 R09: 0000000000000024
[  265.143590] R10: ffffffff81805200 R11: 00000000000598ac R12: ffff8806073aff18
[  265.143591] R13: 0000000000000282 R14: 0000000000000000 R15: 0000000000000003
[  265.143592] FS:  0000000000000000(0000) GS:ffff88062ed00000(0000)
knlGS:0000000000000000
[  265.143593] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  265.143595] CR2: 0000000000000028 CR3: 0000000611098000 CR4: 00000000000406e0
[  265.143595] Stack:
[  265.143598]  0000000100000088 0000000000000000 ffff8806073aff10
ffff8806073aff08
[  265.143600]  0000000000000282 0000000000000000 0000000000000000
ffff8806073afe88
[  265.143602]  ffffffff810bffa3 ffff8806073afeb0 ffffffff810c09f7
ffff880607384028
[  265.143602] Call Trace:
[  265.143605]  [<ffffffff810bffa3>] __wake_up_locked+0x13/0x20
[  265.143607]  [<ffffffff810c09f7>] complete+0x37/0x50
[  265.143610]  [<ffffffff8107934f>] mm_release+0xbf/0x140
[  265.143612]  [<ffffffff81080008>] do_exit+0x798/0xb20
[  265.143615]  [<ffffffff815cca57>] rewind_stack_do_exit+0x17/0x20
[  265.143618]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[  265.143646] Code: 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41
54 4c 8d 67 08 53 41 89 f7 48 83 ec 10 89 55 cc 48 8b 57 08 4c 89 45
d0 49 39 d4 <48> 8b 32 74 40 48 8d 42 e8 4c 8d 6e e8 41 89 ce 8b 18 48
8b 4d
[  265.143649] RIP  [<ffffffff810bfeeb>] __wake_up_common+0x2b/0x80
[  265.143650]  RSP <ffff8806073afe40>
[  265.143650] CR2: 00000000649ea36e
[  265.143651] ---[ end trace 1afee654ae2112b8 ]---
[  265.143652] Fixing recursive fault but reboot is needed!
[  265.143654] BUG: scheduling while atomic: kworker/u16:2/151/0x00000003
[  265.143677] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  265.143707]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  265.143718]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  265.143720] CPU: 4 PID: 151 Comm: kworker/u16:2 Tainted: P      D
 O    4.8.11-ARCH-dirty #1
[  265.143720] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  265.143735]  0000000000000086 00000000649ea36e ffff8806073afe50
ffffffff812e9a00
[  265.143737]  ffff88062ed17cc0 0000000000000009 ffff8806073afe60
ffffffff810a2964
[  265.143739]  ffff8806073afeb8 ffffffff815c71e0 00ffffff8116c8ef
ffff880600000008
[  265.143740] Call Trace:
[  265.143742]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[  265.143745]  [<ffffffff810a2964>] __schedule_bug+0x54/0x70
[  265.143749]  [<ffffffff815c71e0>] __schedule+0x600/0x780
[  265.143751]  [<ffffffff815c739c>] schedule+0x3c/0x90
[  265.143754]  [<ffffffff81080192>] do_exit+0x922/0xb20
[  265.143756]  [<ffffffff815cca57>] rewind_stack_do_exit+0x17/0x20
[  265.143760]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[  265.143769] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  265.143771] IP: [<ffffffff8109b650>] kthread_data+0x10/0x20
[  265.143773] PGD 1809067 PUD 180b067 PMD 0
[  265.143774] Oops: 0000 [#3] PREEMPT SMP
[  265.143800] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  265.143828]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  265.143839]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  265.143843] CPU: 4 PID: 151 Comm: kworker/u16:2 Tainted: P      D W
 O    4.8.11-ARCH-dirty #1
[  265.143843] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  265.143856] task: ffff880607383900 task.stack: ffff8806073ac000
[  265.143859] RIP: 0010:[<ffffffff8109b650>]  [<ffffffff8109b650>]
kthread_data+0x10/0x20
[  265.143860] RSP: 0018:ffff8806073afe50  EFLAGS: 00010002
[  265.143861] RAX: 0000000000000000 RBX: ffff88062ed17cc0 RCX: 0000000000000004
[  265.143864] RDX: ffff88061600c000 RSI: ffff880607383980 RDI: ffff880607383900
[  265.143865] RBP: ffff8806073afe50 R08: 00000000ffffffff R09: 0000000000000000
[  265.143866] R10: 0000000000000000 R11: 0000000000047c00 R12: ffff880607383ed8
[  265.143867] R13: ffff88062ed17cc0 R14: ffff880607383900 R15: 0000000000017cc0
[  265.143868] FS:  0000000000000000(0000) GS:ffff88062ed00000(0000)
knlGS:0000000000000000
[  265.143869] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  265.143870] CR2: 0000000000000028 CR3: 0000000611098000 CR4: 00000000000406e0
[  265.143871] Stack:
[  265.143873]  ffff8806073afe60 ffffffff81095d8e ffff8806073afeb8
ffffffff815c7107
[  265.143876]  00ffffff8116c8ef ffff880600000008 ffff880607383900
ffff8806073afe98
[  265.143878]  ffff8806073b0000 0000000000000009 ffff8806073afd98
00000000649ea36e
[  265.143878] Call Trace:
[  265.143881]  [<ffffffff81095d8e>] wq_worker_sleeping+0xe/0x80
[  265.143884]  [<ffffffff815c7107>] __schedule+0x527/0x780
[  265.143888]  [<ffffffff815c739c>] schedule+0x3c/0x90
[  265.143890]  [<ffffffff81080192>] do_exit+0x922/0xb20
[  265.143893]  [<ffffffff815cca57>] rewind_stack_do_exit+0x17/0x20
[  265.143896]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[  265.143923] Code: 89 df e8 64 d7 fd ff e9 3c ff ff ff 0f 1f 44 00
00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 78 05 00 00
55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
00 00
[  265.143925] RIP  [<ffffffff8109b650>] kthread_data+0x10/0x20
[  265.143925]  RSP <ffff8806073afe50>
[  265.143926] CR2: ffffffffffffffd8
[  265.143927] ---[ end trace 1afee654ae2112b9 ]---
[  265.143928] Fixing recursive fault but reboot is needed!
[  265.143929] BUG: scheduling while atomic: kworker/u16:2/151/0x00000003
[  265.143966] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  265.144000]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  265.144011]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  265.144013] CPU: 4 PID: 151 Comm: kworker/u16:2 Tainted: P      D W
 O    4.8.11-ARCH-dirty #1
[  265.144014] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  265.144028]  0000000000000086 00000000649ea36e ffff8806073afe50
ffffffff812e9a00
[  265.144030]  ffff88062ed17cc0 0000000000000009 ffff8806073afe60
ffffffff810a2964
[  265.144032]  ffff8806073afeb8 ffffffff815c71e0 00ffffff8116c8ef
ffff880600000008
[  265.144033] Call Trace:
[  265.144035]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[  265.144038]  [<ffffffff810a2964>] __schedule_bug+0x54/0x70
[  265.144041]  [<ffffffff815c71e0>] __schedule+0x600/0x780
[  265.144044]  [<ffffffff815c739c>] schedule+0x3c/0x90
[  265.144046]  [<ffffffff81080192>] do_exit+0x922/0xb20
[  265.144049]  [<ffffffff815cca57>] rewind_stack_do_exit+0x17/0x20
[  265.144052]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[  293.113823] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
[apps.plugin:1051]
[  293.116067] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  293.130685]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  293.146969]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  293.155517] CPU: 1 PID: 1051 Comm: apps.plugin Tainted: P      D W
O    4.8.11-ARCH-dirty #1
[  293.158419] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  293.161350] task: ffff880609e50e40 task.stack: ffff880609e78000
[  293.164245] RIP: 0010:[<ffffffff810c85e9>]  [<ffffffff810c85e9>]
queued_spin_lock_slowpath+0x179/0x1a0
[  293.167152] RSP: 0018:ffff880609e7bc60  EFLAGS: 00000202
[  293.170002] RAX: 0000000000000101 RBX: ffff880607383900 RCX: 0000000000000001
[  293.172830] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff880607384028
[  293.175610] RBP: ffff880609e7bc60 R08: 0000000000000101 R09: ffff880609e7bde0
[  293.178339] R10: ffff8803ad01a026 R11: ffff88060e20a6f8 R12: ffff88060c260cb8
[  293.181022] R13: ffff880609e7bd78 R14: ffff880607384028 R15: ffff8806118661a0
[  293.183653] FS:  00007f9ae973c700(0000) GS:ffff88062ec40000(0000)
knlGS:0000000000000000
[  293.186265] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  293.188828] CR2: 00007fd8fc55dfb8 CR3: 000000060b549000 CR4: 00000000000406e0
[  293.191364] Stack:
[  293.193832]  ffff880609e7bc70 ffffffff815caed7 ffff880609e7bca8
ffffffff81267896
[  293.196322]  ffff880609e7bde0 ffff880609e7bde0 ffff88060e20a6c0
ffff880609e7bd78
[  293.198759]  ffff880609e7bd70 ffff880609e7bd00 ffffffff81207ecb
ffff8806088f2900
[  293.201140] Call Trace:
[  293.203461]  [<ffffffff815caed7>] _raw_spin_lock+0x27/0x30
[  293.205780]  [<ffffffff81267896>] pid_revalidate+0x56/0x100
[  293.208061]  [<ffffffff81207ecb>] lookup_fast+0x2eb/0x310
[  293.210341]  [<ffffffff812096f4>] path_openat+0x1d4/0x11b0
[  293.212606]  [<ffffffff81078271>] ? get_task_mm+0x41/0x50
[  293.214853]  [<ffffffff81267624>] ? proc_single_show+0x54/0x80
[  293.217097]  [<ffffffff8120b8a1>] do_filp_open+0x91/0x100
[  293.219343]  [<ffffffff81219619>] ? __alloc_fd+0xc9/0x180
[  293.221589]  [<ffffffff811f9cf7>] do_sys_open+0x147/0x210
[  293.223837]  [<ffffffff811f9dde>] SyS_open+0x1e/0x20
[  293.226086]  [<ffffffff815cb2b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[  293.228349] Code: 44 39 c0 74 e6 4d 85 c9 c6 07 01 74 30 41 c7 41
08 01 00 00 00 e9 52 ff ff ff 83 fa 01 0f 84 b0 fe ff ff 8b 07 84 c0
74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 5d c3 f3 90 4c
8b 09
[  321.111053] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s!
[apps.plugin:1051]
[  321.113391] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  321.130711]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  321.149108]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  321.158193] CPU: 1 PID: 1051 Comm: apps.plugin Tainted: P      D W
O L  4.8.11-ARCH-dirty #1
[  321.161186] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  321.164189] task: ffff880609e50e40 task.stack: ffff880609e78000
[  321.167156] RIP: 0010:[<ffffffff810c85e9>]  [<ffffffff810c85e9>]
queued_spin_lock_slowpath+0x179/0x1a0
[  321.170160] RSP: 0018:ffff880609e7bc60  EFLAGS: 00000202
[  321.173122] RAX: 0000000000000101 RBX: ffff880607383900 RCX: 0000000000000001
[  321.176101] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff880607384028
[  321.179079] RBP: ffff880609e7bc60 R08: 0000000000000101 R09: ffff880609e7bde0
[  321.182058] R10: ffff8803ad01a026 R11: ffff88060e20a6f8 R12: ffff88060c260cb8
[  321.185038] R13: ffff880609e7bd78 R14: ffff880607384028 R15: ffff8806118661a0
[  321.188015] FS:  00007f9ae973c700(0000) GS:ffff88062ec40000(0000)
knlGS:0000000000000000
[  321.191001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  321.193965] CR2: 00007fd8fc55dfb8 CR3: 000000060b549000 CR4: 00000000000406e0
[  321.196942] Stack:
[  321.199871]  ffff880609e7bc70 ffffffff815caed7 ffff880609e7bca8
ffffffff81267896
[  321.202864]  ffff880609e7bde0 ffff880609e7bde0 ffff88060e20a6c0
ffff880609e7bd78
[  321.205858]  ffff880609e7bd70 ffff880609e7bd00 ffffffff81207ecb
ffff8806088f2900
[  321.208853] Call Trace:
[  321.211787]  [<ffffffff815caed7>] _raw_spin_lock+0x27/0x30
[  321.214750]  [<ffffffff81267896>] pid_revalidate+0x56/0x100
[  321.217712]  [<ffffffff81207ecb>] lookup_fast+0x2eb/0x310
[  321.220673]  [<ffffffff812096f4>] path_openat+0x1d4/0x11b0
[  321.223635]  [<ffffffff81078271>] ? get_task_mm+0x41/0x50
[  321.226597]  [<ffffffff81267624>] ? proc_single_show+0x54/0x80
[  321.229562]  [<ffffffff8120b8a1>] do_filp_open+0x91/0x100
[  321.232523]  [<ffffffff81219619>] ? __alloc_fd+0xc9/0x180
[  321.235484]  [<ffffffff811f9cf7>] do_sys_open+0x147/0x210
[  321.238444]  [<ffffffff811f9dde>] SyS_open+0x1e/0x20
[  321.241398]  [<ffffffff815cb2b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[  321.244366] Code: 44 39 c0 74 e6 4d 85 c9 c6 07 01 74 30 41 c7 41
08 01 00 00 00 e9 52 ff ff ff 83 fa 01 0f 84 b0 fe ff ff 8b 07 84 c0
74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 5d c3 f3 90 4c
8b 09
[  325.154030] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  325.156327]  4-...: (1 GPs behind) idle=319/140000000000000/0
softirq=15521/15522 fqs=5374
[  325.158614]  (detected by 2, t=18003 jiffies, g=8376, c=8375, q=995)
[  325.160866] Task dump for CPU 4:
[  325.163053] kworker/u16:2   D 0000000000000086     0   151      2 0x00000000
[  325.165253]  0000000000000000 ffff88062ed17cc0 0000000000000000
0000000000017cc0
[  325.167415]  ffff8806073afe30 ffffffff81031e44 0000000000000086
00000000649ea36e
[  325.169524]  ffff8806073afe50 0000000000000086 ffff88062ed17cc0
0000000000000009
[  325.171589] Call Trace:
[  325.173583]  [<ffffffff81031e44>] ? show_stack+0x34/0x70
[  325.175558]  [<ffffffff815caed7>] ? _raw_spin_lock+0x27/0x30
[  325.177474]  [<ffffffff815c6c72>] ? __schedule+0x92/0x780
[  325.179330]  [<ffffffff815c739c>] ? schedule+0x3c/0x90
[  325.181135]  [<ffffffff81080192>] ? do_exit+0x922/0xb20
[  325.182880]  [<ffffffff815cca57>] ? rewind_stack_do_exit+0x17/0x20
[  325.184586]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[  349.108280] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s!
[apps.plugin:1051]
[  349.110404] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  349.124112]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  349.139755]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  349.148096] CPU: 1 PID: 1051 Comm: apps.plugin Tainted: P      D W
O L  4.8.11-ARCH-dirty #1
[  349.150949] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  349.153847] task: ffff880609e50e40 task.stack: ffff880609e78000
[  349.156744] RIP: 0010:[<ffffffff810c85e9>]  [<ffffffff810c85e9>]
queued_spin_lock_slowpath+0x179/0x1a0
[  349.159716] RSP: 0018:ffff880609e7bc60  EFLAGS: 00000202
[  349.162689] RAX: 0000000000000101 RBX: ffff880607383900 RCX: 0000000000000001
[  349.165706] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff880607384028
[  349.168729] RBP: ffff880609e7bc60 R08: 0000000000000101 R09: ffff880609e7bde0
[  349.171752] R10: ffff8803ad01a026 R11: ffff88060e20a6f8 R12: ffff88060c260cb8
[  349.174782] R13: ffff880609e7bd78 R14: ffff880607384028 R15: ffff8806118661a0
[  349.177816] FS:  00007f9ae973c700(0000) GS:ffff88062ec40000(0000)
knlGS:0000000000000000
[  349.180897] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  349.183986] CR2: 00007fd8fc55dfb8 CR3: 000000060b549000 CR4: 00000000000406e0
[  349.187099] Stack:
[  349.190133]  ffff880609e7bc70 ffffffff815caed7 ffff880609e7bca8
ffffffff81267896
[  349.193206]  ffff880609e7bde0 ffff880609e7bde0 ffff88060e20a6c0
ffff880609e7bd78
[  349.196245]  ffff880609e7bd70 ffff880609e7bd00 ffffffff81207ecb
ffff8806088f2900
[  349.199241] Call Trace:
[  349.202171]  [<ffffffff815caed7>] _raw_spin_lock+0x27/0x30
[  349.205107]  [<ffffffff81267896>] pid_revalidate+0x56/0x100
[  349.208039]  [<ffffffff81207ecb>] lookup_fast+0x2eb/0x310
[  349.210951]  [<ffffffff812096f4>] path_openat+0x1d4/0x11b0
[  349.213851]  [<ffffffff81078271>] ? get_task_mm+0x41/0x50
[  349.216741]  [<ffffffff81267624>] ? proc_single_show+0x54/0x80
[  349.219605]  [<ffffffff8120b8a1>] do_filp_open+0x91/0x100
[  349.222461]  [<ffffffff81219619>] ? __alloc_fd+0xc9/0x180
[  349.225313]  [<ffffffff811f9cf7>] do_sys_open+0x147/0x210
[  349.228163]  [<ffffffff811f9dde>] SyS_open+0x1e/0x20
[  349.231010]  [<ffffffff815cb2b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[  349.233883] Code: 44 39 c0 74 e6 4d 85 c9 c6 07 01 74 30 41 c7 41
08 01 00 00 00 e9 52 ff ff ff 83 fa 01 0f 84 b0 fe ff ff 8b 07 84 c0
74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 5d c3 f3 90 4c
8b 09
[  377.105506] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s!
[apps.plugin:1051]
[  377.108488] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  377.126807]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  377.145178]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  377.154249] CPU: 1 PID: 1051 Comm: apps.plugin Tainted: P      D W
O L  4.8.11-ARCH-dirty #1
[  377.157237] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  377.160233] task: ffff880609e50e40 task.stack: ffff880609e78000
[  377.163196] RIP: 0010:[<ffffffff810c85e9>]  [<ffffffff810c85e9>]
queued_spin_lock_slowpath+0x179/0x1a0
[  377.166197] RSP: 0018:ffff880609e7bc60  EFLAGS: 00000202
[  377.169154] RAX: 0000000000000101 RBX: ffff880607383900 RCX: 0000000000000001
[  377.172126] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff880607384028
[  377.175100] RBP: ffff880609e7bc60 R08: 0000000000000101 R09: ffff880609e7bde0
[  377.178067] R10: ffff8803ad01a026 R11: ffff88060e20a6f8 R12: ffff88060c260cb8
[  377.181050] R13: ffff880609e7bd78 R14: ffff880607384028 R15: ffff8806118661a0
[  377.184036] FS:  00007f9ae973c700(0000) GS:ffff88062ec40000(0000)
knlGS:0000000000000000
[  377.187029] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  377.190000] CR2: 00007fd8fc55dfb8 CR3: 000000060b549000 CR4: 00000000000406e0
[  377.192984] Stack:
[  377.195921]  ffff880609e7bc70 ffffffff815caed7 ffff880609e7bca8
ffffffff81267896
[  377.198921]  ffff880609e7bde0 ffff880609e7bde0 ffff88060e20a6c0
ffff880609e7bd78
[  377.201918]  ffff880609e7bd70 ffff880609e7bd00 ffffffff81207ecb
ffff8806088f2900
[  377.204917] Call Trace:
[  377.207857]  [<ffffffff815caed7>] _raw_spin_lock+0x27/0x30
[  377.210824]  [<ffffffff81267896>] pid_revalidate+0x56/0x100
[  377.213793]  [<ffffffff81207ecb>] lookup_fast+0x2eb/0x310
[  377.216761]  [<ffffffff812096f4>] path_openat+0x1d4/0x11b0
[  377.219727]  [<ffffffff81078271>] ? get_task_mm+0x41/0x50
[  377.222696]  [<ffffffff81267624>] ? proc_single_show+0x54/0x80
[  377.225669]  [<ffffffff8120b8a1>] do_filp_open+0x91/0x100
[  377.228638]  [<ffffffff81219619>] ? __alloc_fd+0xc9/0x180
[  377.231606]  [<ffffffff811f9cf7>] do_sys_open+0x147/0x210
[  377.234542]  [<ffffffff811f9dde>] SyS_open+0x1e/0x20
[  377.237507]  [<ffffffff815cb2b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[  377.240483] Code: 44 39 c0 74 e6 4d 85 c9 c6 07 01 74 30 41 c7 41
08 01 00 00 00 e9 52 ff ff ff 83 fa 01 0f 84 b0 fe ff ff 8b 07 84 c0
74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 5d c3 f3 90 4c
8b 09
[  401.853013] INFO: rcu_bh detected stalls on CPUs/tasks:
[  401.855586]  0-...: (1 GPs behind) idle=66f/1/0 softirq=0/12234 fqs=5460
[  401.858507]  2-...: (1 GPs behind) idle=ea1/140000000000000/0
softirq=0/13465 fqs=5460
[  401.861381]  4-...: (1 GPs behind) idle=319/140000000000000/0
softirq=0/15522 fqs=5460
[  401.864171]  (detected by 3, t=18002 jiffies, g=-299, c=-300, q=1)
[  401.866914] Task dump for CPU 0:
[  401.869572] swapper/0       R  running task        0     0      0 0x00000008
[  401.872218]  ffff880609b64c00 0000003defd15889 ffffffff81803eb0
ffffffff81477101
[  401.874832]  0000000100000060 0000000100000000 ffffffff81804000
ffff880609b64c00
[  401.877386]  ffffffff818f8290 ffffffff8189bde0 0000000000000000
ffffffff81803ec0
[  401.879890] Call Trace:
[  401.882303]  [<ffffffff81477101>] ? cpuidle_enter_state+0xf1/0x2e0
[  401.884695]  [<ffffffff81477327>] ? cpuidle_enter+0x17/0x20
[  401.887007]  [<ffffffff810c0b2a>] ? call_cpuidle+0x2a/0x50
[  401.889247]  [<ffffffff810c0f35>] ? cpu_startup_entry+0x2c5/0x380
[  401.891423]  [<ffffffff815be5a4>] ? rest_init+0x84/0x90
[  401.893527]  [<ffffffff8191efdd>] ? start_kernel+0x443/0x464
[  401.895588]  [<ffffffff8191e120>] ? early_idt_handler_array+0x120/0x120
[  401.897617]  [<ffffffff8191e2d6>] ? x86_64_start_reservations+0x2a/0x2c
[  401.899607]  [<ffffffff8191e424>] ? x86_64_start_kernel+0x14c/0x16f
[  401.901543] Task dump for CPU 2:
[  401.903434] smbd            R  running task        0   909      1 0x00000008
[  401.905359]  ffff88060d6cbd88 ffffffff810a3650 0000000000000296
000000004a0c1222
[  401.907312]  ffff88060d6cbd88 ffffffff812fe748 ffff88060d6cbda8
ffffffff812e980b
[  401.909268]  ffff880612e13d98 ffff88062ed17cc0 ffff88060d6cbe48
ffffffff810afe5b
[  401.911216] Call Trace:
[  401.913134]  [<ffffffff810a3650>] ? cpu_cgroup_fork+0x50/0x70
[  401.915065]  [<ffffffff812fe748>] ? find_next_bit+0x18/0x20
[  401.916968]  [<ffffffff812e980b>] cpumask_next_and+0x2b/0x40
[  401.918852]  [<ffffffff810afe5b>] select_task_rq_fair+0x47b/0x740
[  401.920720]  [<ffffffff815caed7>] ? _raw_spin_lock+0x27/0x30
[  401.922562]  [<ffffffff810a3507>] ? __task_rq_lock+0x37/0x80
[  401.924390]  [<ffffffff810a70f8>] wake_up_new_task+0x118/0x230
[  401.926227]  [<ffffffff8107afb6>] _do_fork+0x136/0x3c0
[  401.928033]  [<ffffffff8107b2e9>] SyS_clone+0x19/0x20
[  401.929821]  [<ffffffff81003b97>] do_syscall_64+0x57/0xb0
[  401.931614]  [<ffffffff815cb361>] entry_SYSCALL64_slow_path+0x25/0x25
[  401.933425] Task dump for CPU 4:
[  401.935230] kworker/u16:2   D 0000000000000086     0   151      2 0x00000000
[  401.937110]  0000000000000000 ffff88062ed17cc0 0000000000000000
0000000000017cc0
[  401.939005]  ffff8806073afe30 ffffffff81031e44 0000000000000086
00000000649ea36e
[  401.940903]  ffff8806073afe50 0000000000000086 ffff88062ed17cc0
0000000000000009
[  401.942817] Call Trace:
[  401.944705]  [<ffffffff81031e44>] ? show_stack+0x34/0x70
[  401.946631]  [<ffffffff815caed7>] ? _raw_spin_lock+0x27/0x30
[  401.948551]  [<ffffffff815c6c72>] ? __schedule+0x92/0x780
[  401.950408]  [<ffffffff815c739c>] ? schedule+0x3c/0x90
[  401.952205]  [<ffffffff81080192>] ? do_exit+0x922/0xb20
[  401.953962]  [<ffffffff815cca57>] ? rewind_stack_do_exit+0x17/0x20
[  401.955711]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[  405.102728] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s!
[apps.plugin:1051]
[  405.104547] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  405.116839]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  405.131158]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  405.139103] CPU: 1 PID: 1051 Comm: apps.plugin Tainted: P      D W
O L  4.8.11-ARCH-dirty #1
[  405.141832] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  405.144598] task: ffff880609e50e40 task.stack: ffff880609e78000
[  405.147364] RIP: 0010:[<ffffffff810c85e9>]  [<ffffffff810c85e9>]
queued_spin_lock_slowpath+0x179/0x1a0
[  405.150168] RSP: 0018:ffff880609e7bc60  EFLAGS: 00000202
[  405.152978] RAX: 0000000000000101 RBX: ffff880607383900 RCX: 0000000000000001
[  405.155829] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff880607384028
[  405.158656] RBP: ffff880609e7bc60 R08: 0000000000000101 R09: ffff880609e7bde0
[  405.161472] R10: ffff8803ad01a026 R11: ffff88060e20a6f8 R12: ffff88060c260cb8
[  405.164295] R13: ffff880609e7bd78 R14: ffff880607384028 R15: ffff8806118661a0
[  405.167118] FS:  00007f9ae973c700(0000) GS:ffff88062ec40000(0000)
knlGS:0000000000000000
[  405.169977] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  405.172834] CR2: 00007fd8fc55dfb8 CR3: 000000060b549000 CR4: 00000000000406e0
[  405.175738] Stack:
[  405.178620]  ffff880609e7bc70 ffffffff815caed7 ffff880609e7bca8
ffffffff81267896
[  405.181590]  ffff880609e7bde0 ffff880609e7bde0 ffff88060e20a6c0
ffff880609e7bd78
[  405.184571]  ffff880609e7bd70 ffff880609e7bd00 ffffffff81207ecb
ffff8806088f2900
[  405.187545] Call Trace:
[  405.190479]  [<ffffffff815caed7>] _raw_spin_lock+0x27/0x30
[  405.193432]  [<ffffffff81267896>] pid_revalidate+0x56/0x100
[  405.196369]  [<ffffffff81207ecb>] lookup_fast+0x2eb/0x310
[  405.199283]  [<ffffffff812096f4>] path_openat+0x1d4/0x11b0
[  405.202185]  [<ffffffff81078271>] ? get_task_mm+0x41/0x50
[  405.205076]  [<ffffffff81267624>] ? proc_single_show+0x54/0x80
[  405.207947]  [<ffffffff8120b8a1>] do_filp_open+0x91/0x100
[  405.210808]  [<ffffffff81219619>] ? __alloc_fd+0xc9/0x180
[  405.213663]  [<ffffffff811f9cf7>] do_sys_open+0x147/0x210
[  405.216491]  [<ffffffff811f9dde>] SyS_open+0x1e/0x20
[  405.219342]  [<ffffffff815cb2b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[  405.222219] Code: 44 39 c0 74 e6 4d 85 c9 c6 07 01 74 30 41 c7 41
08 01 00 00 00 e9 52 ff ff ff 83 fa 01 0f 84 b0 fe ff ff 8b 07 84 c0
74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 5d c3 f3 90 4c
8b 09
[  433.099949] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
[apps.plugin:1051]
[  433.102926] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_nat ebtable_broute ip6table_mangle ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
ip6table_security iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
iptable_security ebtable_filter ebtables bridge ip6table_filter stp
ip6_tables llc iptable_filter it87 hwmon_vid kvm_amd snd_usb_audio kvm
snd_usbmidi_lib irqbypass snd_hda_codec_hdmi crct10dif_pclmul
input_leds crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek
mousedev snd_rawmidi snd_seq_device joydev
[  433.121288]  led_class aesni_intel snd_hda_codec_generic
saa7134_alsa aes_x86_64 lrw snd_hda_intel evdev snd_hda_codec gf128mul
mac_hid glue_helper saa7134 mxm_wmi ablk_helper cryptd fam15h_power
k10temp pcspkr snd_hda_core tveeprom rc_core r8169 snd_hwdep
v4l2_common videobuf2_dma_sg mii videobuf2_memops videobuf2_v4l2
tpm_infineon snd_pcm videobuf2_core acpi_cpufreq tpm_tis videodev
snd_timer tpm_tis_core button wmi media snd sp5100_tco tpm i2c_piix4
soundcore shpchp nfsd sch_fq_codel auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
ohci_pci nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) firewire_ohci
firewire_core
[  433.139700]  crc_itu_t pata_atiixp drm_kms_helper ahci syscopyarea
ehci_pci sysfillrect sysimgblt fb_sys_fops ehci_hcd xhci_pci ohci_hcd
libahci drm xhci_hcd usbcore usb_common i2c_core i8042 serio mvsas
libsas scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel
vfat fat ip_tables x_tables
[  433.148791] CPU: 1 PID: 1051 Comm: apps.plugin Tainted: P      D W
O L  4.8.11-ARCH-dirty #1
[  433.151786] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[  433.154790] task: ffff880609e50e40 task.stack: ffff880609e78000
[  433.157761] RIP: 0010:[<ffffffff810c85e9>]  [<ffffffff810c85e9>]
queued_spin_lock_slowpath+0x179/0x1a0
[  433.160768] RSP: 0018:ffff880609e7bc60  EFLAGS: 00000202
[  433.163731] RAX: 0000000000000101 RBX: ffff880607383900 RCX: 0000000000000001
[  433.166712] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff880607384028
[  433.169692] RBP: ffff880609e7bc60 R08: 0000000000000101 R09: ffff880609e7bde0
[  433.172672] R10: ffff8803ad01a026 R11: ffff88060e20a6f8 R12: ffff88060c260cb8
[  433.175652] R13: ffff880609e7bd78 R14: ffff880607384028 R15: ffff8806118661a0
[  433.178629] FS:  00007f9ae973c700(0000) GS:ffff88062ec40000(0000)
knlGS:0000000000000000
[  433.181616] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  433.184580] CR2: 00007fd8fc55dfb8 CR3: 000000060b549000 CR4: 00000000000406e0
[  433.187556] Stack:
[  433.190485]  ffff880609e7bc70 ffffffff815caed7 ffff880609e7bca8
ffffffff81267896
[  433.193478]  ffff880609e7bde0 ffff880609e7bde0 ffff88060e20a6c0
ffff880609e7bd78
[  433.196471]  ffff880609e7bd70 ffff880609e7bd00 ffffffff81207ecb
ffff8806088f2900
[  433.199465] Call Trace:
[  433.202411]  [<ffffffff815caed7>] _raw_spin_lock+0x27/0x30
[  433.205363]  [<ffffffff81267896>] pid_revalidate+0x56/0x100
[  433.208338]  [<ffffffff81207ecb>] lookup_fast+0x2eb/0x310
[  433.211311]  [<ffffffff812096f4>] path_openat+0x1d4/0x11b0
[  433.214284]  [<ffffffff81078271>] ? get_task_mm+0x41/0x50
[  433.217257]  [<ffffffff81267624>] ? proc_single_show+0x54/0x80
[  433.220233]  [<ffffffff8120b8a1>] do_filp_open+0x91/0x100
[  433.223206]  [<ffffffff81219619>] ? __alloc_fd+0xc9/0x180
[  433.226177]  [<ffffffff811f9cf7>] do_sys_open+0x147/0x210
[  433.229148]  [<ffffffff811f9dde>] SyS_open+0x1e/0x20
[  433.232115]  [<ffffffff815cb2b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[  433.235095] Code: 44 39 c0 74 e6 4d 85 c9 c6 07 01 74 30 41 c7 41
08 01 00 00 00 e9 52 ff ff ff 83 fa 01 0f 84 b0 fe ff ff 8b 07 84 c0
74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 5d c3 f3 90 4c
8b 09



another time, different error

[ 1026.462277] BUG: unable to handle kernel paging request at ffffc90003e45000
[ 1026.464789] IP: [<ffffffff812f7192>] __memcpy+0x12/0x20
[ 1026.467469] PGD 61608f067 PUD 616098067 PMD 609215067 PTE 0
[ 1026.470057] Oops: 0002 [#1] PREEMPT SMP
[ 1026.472515] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp xt_CT ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set nfnetlink
ebtable_nat ebtable_broute ip6table_security ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_raw iptable_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
iptable_raw ebtable_filter ebtables ip6table_filter bridge ip6_tables
stp iptable_filter llc it87 hwmon_vid kvm_amd kvm irqbypass
crct10dif_pclmul snd_usb_audio crc32_pclmul ghash_clmulni_intel
snd_usbmidi_lib snd_rawmidi snd_hda_codec_hdmi aesni_intel
saa7134_alsa joydev aes_x86_64 input_leds mousedev snd_seq_device
[ 1026.490409]  led_class snd_hda_codec_realtek lrw
snd_hda_codec_generic saa7134 gf128mul snd_hda_intel snd_hda_codec
glue_helper tveeprom evdev mac_hid r8169 mxm_wmi pcspkr ablk_helper
cryptd fam15h_power rc_core snd_hda_core k10temp v4l2_common mii
snd_hwdep videobuf2_dma_sg videobuf2_memops snd_pcm videobuf2_v4l2
videobuf2_core snd_timer videodev snd acpi_cpufreq tpm_infineon
soundcore wmi media sp5100_tco tpm_tis tpm_tis_core tpm button
i2c_piix4 shpchp nfsd auth_rpcgss oid_registry nfs_acl sch_fq_codel
lockd grace vboxnetflt(O) vboxnetadp(O) sunrpc pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) ohci_pci drm_kms_helper
firewire_ohci syscopyarea sysfillrect
[ 1026.508391]  firewire_core sysimgblt fb_sys_fops crc_itu_t xhci_pci
ahci pata_atiixp drm xhci_hcd ehci_pci libahci ehci_hcd ohci_hcd
usbcore usb_common i2c_core i8042 serio mvsas libsas
scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel vfat
fat ip_tables x_tables
[ 1026.517281] CPU: 2 PID: 249 Comm: kworker/u16:12 Tainted: P
  O    4.8.11-ARCH-dirty #1
[ 1026.520218] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 1026.523171] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[ 1026.526066] task: ffff880605548000 task.stack: ffff880604a60000
[ 1026.528931] RIP: 0010:[<ffffffff812f7192>]  [<ffffffff812f7192>]
__memcpy+0x12/0x20
[ 1026.531872] RSP: 0018:ffff880604a63c50  EFLAGS: 00010246
[ 1026.534837] RAX: ffffc90003e44ff8 RBX: 0000000000001000 RCX: 00000000000001ff
[ 1026.537821] RDX: 0000000000000000 RSI: ffff880253a15008 RDI: ffffc90003e45000
[ 1026.540799] RBP: ffff880604a63d20 R08: ffffc90003e43000 R09: 0000000072745367
[ 1026.543818] R10: 0000000000000000 R11: 000000eefde93e6c R12: ffff8800b3c172d8
[ 1026.546880] R13: 0000000000000000 R14: 000000007274735f R15: 0000000072747367
[ 1026.549897] FS:  0000000000000000(0000) GS:ffff88062ec80000(0000)
knlGS:0000000000000000
[ 1026.552873] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1026.555790] CR2: ffffc90003e45000 CR3: 000000060e9ea000 CR4: 00000000000406e0
[ 1026.558747] Stack:
[ 1026.561613]  ffffffffa10bfcf8 ffffffff811d77a0 0000000000000001
0000160000000000
[ 1026.564507]  ffff8806110041e0 000000000000000b 0000000000000000
0000000072745367
[ 1026.567436]  ffffc90003e43000 0000000000000002 0000000000020000
00000020a10c0643
[ 1026.570343] Call Trace:
[ 1026.573221]  [<ffffffffa10bfcf8>] ? lzo_decompress_biovec+0x1e8/0x2e0 [btrfs]
[ 1026.576177]  [<ffffffff811d77a0>] ? kmem_cache_free+0x1e0/0x210
[ 1026.579177]  [<ffffffffa10c0819>] end_compressed_bio_read+0x1b9/0x300 [btrfs]
[ 1026.582210]  [<ffffffff812b0dc3>] bio_endio+0x53/0x60
[ 1026.585281]  [<ffffffffa1065a0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[ 1026.588356]  [<ffffffffa10a4e9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 1026.591433]  [<ffffffffa10a524e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[ 1026.594522]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 1026.597557]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 1026.600536]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 1026.603493]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 1026.606415]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 1026.609336]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 1026.612241]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 1026.615098] Code: c3 e8 53 fb ff ff 48 8b 43 60 48 2b 43 50 88 43
4e 5b 5d eb ea 90 90 90 90 0f 1f 44 00 00 48 89 f8 48 89 d1 48 c1 e9
03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89
d1 f3
[ 1026.621086] RIP  [<ffffffff812f7192>] __memcpy+0x12/0x20
[ 1026.623889]  RSP <ffff880604a63c50>
[ 1026.626611] CR2: ffffc90003e45000
[ 1026.629258] ---[ end trace fb0225444318cedb ]---
[ 1026.629262] BUG: unable to handle kernel paging request at ffffc90003e5b000
[ 1026.629266] IP: [<ffffffff812f7192>] __memcpy+0x12/0x20
[ 1026.629270] PGD 61608f067 PUD 616098067 PMD 609215067 PTE 0
[ 1026.629272] Oops: 0002 [#2] PREEMPT SMP
[ 1026.629302] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp xt_CT ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set nfnetlink
ebtable_nat ebtable_broute ip6table_security ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_raw iptable_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
iptable_raw ebtable_filter ebtables ip6table_filter bridge ip6_tables
stp iptable_filter llc it87 hwmon_vid kvm_amd kvm irqbypass
crct10dif_pclmul snd_usb_audio crc32_pclmul ghash_clmulni_intel
snd_usbmidi_lib snd_rawmidi snd_hda_codec_hdmi aesni_intel
saa7134_alsa joydev aes_x86_64 input_leds mousedev snd_seq_device
[ 1026.629340]  led_class snd_hda_codec_realtek lrw
snd_hda_codec_generic saa7134 gf128mul snd_hda_intel snd_hda_codec
glue_helper tveeprom evdev mac_hid r8169 mxm_wmi pcspkr ablk_helper
cryptd fam15h_power rc_core snd_hda_core k10temp v4l2_common mii
snd_hwdep videobuf2_dma_sg videobuf2_memops snd_pcm videobuf2_v4l2
videobuf2_core snd_timer videodev snd acpi_cpufreq tpm_infineon
soundcore wmi media sp5100_tco tpm_tis tpm_tis_core tpm button
i2c_piix4 shpchp nfsd auth_rpcgss oid_registry nfs_acl sch_fq_codel
lockd grace vboxnetflt(O) vboxnetadp(O) sunrpc pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) ohci_pci drm_kms_helper
firewire_ohci syscopyarea sysfillrect
[ 1026.629354]  firewire_core sysimgblt fb_sys_fops crc_itu_t xhci_pci
ahci pata_atiixp drm xhci_hcd ehci_pci libahci ehci_hcd ohci_hcd
usbcore usb_common i2c_core i8042 serio mvsas libsas
scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel vfat
fat ip_tables x_tables
[ 1026.629357] CPU: 4 PID: 164 Comm: kworker/u16:5 Tainted: P      D
 O    4.8.11-ARCH-dirty #1
[ 1026.629358] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 1026.629381] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[ 1026.629382] task: ffff8806128a63c0 task.stack: ffff880606d34000
[ 1026.629386] RIP: 0010:[<ffffffff812f7192>]  [<ffffffff812f7192>]
__memcpy+0x12/0x20
[ 1026.629387] RSP: 0018:ffff880606d37c50  EFLAGS: 00010246
[ 1026.629388] RAX: ffffc90003e5aff8 RBX: 0000000000001000 RCX: 00000000000001ff
[ 1026.629390] RDX: 0000000000000000 RSI: ffff8805c9dfc008 RDI: ffffc90003e5b000
[ 1026.629391] RBP: ffff880606d37d20 R08: ffffc90003e59000 R09: 0000000058452e67
[ 1026.629392] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8805beccff18
[ 1026.629393] R13: 0000000000000000 R14: 0000000058454e5f R15: 0000000058454e67
[ 1026.629395] FS:  0000000000000000(0000) GS:ffff88062ed00000(0000)
knlGS:0000000000000000
[ 1026.629397] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1026.629398] CR2: ffffc90003e5b000 CR3: 00000003104e2000 CR4: 00000000000406e0
[ 1026.629399] Stack:
[ 1026.629402]  ffffffffa10bfcf8 ffff88062ecd7d30 ffff8803dc914000
0000160000000000
[ 1026.629405]  ffff880611004600 000000000000000b 0000000000000000
0000000058452e67
[ 1026.629408]  ffffc90003e59000 0000000000000002 0000000000040000
00000020a10c0643
[ 1026.629408] Call Trace:
[ 1026.629428]  [<ffffffffa10bfcf8>] ? lzo_decompress_biovec+0x1e8/0x2e0 [btrfs]
[ 1026.629448]  [<ffffffffa10c0819>] end_compressed_bio_read+0x1b9/0x300 [btrfs]
[ 1026.629451]  [<ffffffff812b0dc3>] bio_endio+0x53/0x60
[ 1026.629469]  [<ffffffffa1065a0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[ 1026.629489]  [<ffffffffa10a4e9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 1026.629510]  [<ffffffffa10a524e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[ 1026.629513]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 1026.629516]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 1026.629518]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 1026.629521]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 1026.629524]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 1026.629527]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 1026.629531]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 1026.629560] Code: c3 e8 53 fb ff ff 48 8b 43 60 48 2b 43 50 88 43
4e 5b 5d eb ea 90 90 90 90 0f 1f 44 00 00 48 89 f8 48 89 d1 48 c1 e9
03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89
d1 f3
[ 1026.629562] RIP  [<ffffffff812f7192>] __memcpy+0x12/0x20
[ 1026.629563]  RSP <ffff880606d37c50>
[ 1026.629564] CR2: ffffc90003e5b000
[ 1026.629566] ---[ end trace fb0225444318cedc ]---
[ 1026.629626] BUG: unable to handle kernel paging request at 00000000d406ea4c
[ 1026.629630] IP: [<ffffffff810bfeeb>] __wake_up_common+0x2b/0x80
[ 1026.629632] PGD 15f4c3067 PUD 0
[ 1026.629634] Oops: 0000 [#3] PREEMPT SMP
[ 1026.629671] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp xt_CT ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set nfnetlink
ebtable_nat ebtable_broute ip6table_security ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_raw iptable_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
iptable_raw ebtable_filter ebtables ip6table_filter bridge ip6_tables
stp iptable_filter llc it87 hwmon_vid kvm_amd kvm irqbypass
crct10dif_pclmul snd_usb_audio crc32_pclmul ghash_clmulni_intel
snd_usbmidi_lib snd_rawmidi snd_hda_codec_hdmi aesni_intel
saa7134_alsa joydev aes_x86_64 input_leds mousedev snd_seq_device
[ 1026.629711]  led_class snd_hda_codec_realtek lrw
snd_hda_codec_generic saa7134 gf128mul snd_hda_intel snd_hda_codec
glue_helper tveeprom evdev mac_hid r8169 mxm_wmi pcspkr ablk_helper
cryptd fam15h_power rc_core snd_hda_core k10temp v4l2_common mii
snd_hwdep videobuf2_dma_sg videobuf2_memops snd_pcm videobuf2_v4l2
videobuf2_core snd_timer videodev snd acpi_cpufreq tpm_infineon
soundcore wmi media sp5100_tco tpm_tis tpm_tis_core tpm button
i2c_piix4 shpchp nfsd auth_rpcgss oid_registry nfs_acl sch_fq_codel
lockd grace vboxnetflt(O) vboxnetadp(O) sunrpc pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) ohci_pci drm_kms_helper
firewire_ohci syscopyarea sysfillrect
[ 1026.629727]  firewire_core sysimgblt fb_sys_fops crc_itu_t xhci_pci
ahci pata_atiixp drm xhci_hcd ehci_pci libahci ehci_hcd ohci_hcd
usbcore usb_common i2c_core i8042 serio mvsas libsas
scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel vfat
fat ip_tables x_tables
[ 1026.629729] CPU: 4 PID: 164 Comm: kworker/u16:5 Tainted: P      D
 O    4.8.11-ARCH-dirty #1
[ 1026.629730] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 1026.629747] task: ffff8806128a63c0 task.stack: ffff880606d34000
[ 1026.629751] RIP: 0010:[<ffffffff810bfeeb>]  [<ffffffff810bfeeb>]
__wake_up_common+0x2b/0x80
[ 1026.629752] RSP: 0018:ffff880606d37e40  EFLAGS: 00010096
[ 1026.629754] RAX: 0000000000000282 RBX: ffff880606d37f10 RCX: 0000000000000000
[ 1026.629755] RDX: 00000000d406ea4c RSI: 0000000000000003 RDI: ffff880606d37f10
[ 1026.629756] RBP: ffff880606d37e78 R08: 0000000000000000 R09: 0000000000000024
[ 1026.629757] R10: ffffffff81805200 R11: 00000000000577a8 R12: ffff880606d37f18
[ 1026.629758] R13: 0000000000000282 R14: ffffc90003e5b000 R15: 0000000000000003
[ 1026.629760] FS:  0000000000000000(0000) GS:ffff88062ed00000(0000)
knlGS:0000000000000000
[ 1026.629762] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1026.629763] CR2: 0000000000000028 CR3: 00000003104e2000 CR4: 00000000000406e0
[ 1026.629764] Stack:
[ 1026.629767]  0000000181003016 0000000000000000 ffff880606d37f10
ffff880606d37f08
[ 1026.629770]  0000000000000282 ffffc90003e5b000 ffff8806128a63c0
ffff880606d37e88
[ 1026.629772]  ffffffff810bffa3 ffff880606d37eb0 ffffffff810c09f7
ffff8806128a6ae8
[ 1026.629773] Call Trace:
[ 1026.629776]  [<ffffffff810bffa3>] __wake_up_locked+0x13/0x20
[ 1026.629779]  [<ffffffff810c09f7>] complete+0x37/0x50
[ 1026.629781]  [<ffffffff8107934f>] mm_release+0xbf/0x140
[ 1026.629785]  [<ffffffff81080008>] do_exit+0x798/0xb20
[ 1026.629788]  [<ffffffff815cca57>] rewind_stack_do_exit+0x17/0x20
[ 1026.629791]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 1026.629820] Code: 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41
54 4c 8d 67 08 53 41 89 f7 48 83 ec 10 89 55 cc 48 8b 57 08 4c 89 45
d0 49 39 d4 <48> 8b 32 74 40 48 8d 42 e8 4c 8d 6e e8 41 89 ce 8b 18 48
8b 4d
[ 1026.629823] RIP  [<ffffffff810bfeeb>] __wake_up_common+0x2b/0x80
[ 1026.629824]  RSP <ffff880606d37e40>
[ 1026.629825] CR2: 00000000d406ea4c
[ 1026.629826] ---[ end trace fb0225444318cedd ]---
[ 1026.629827] Fixing recursive fault but reboot is needed!
[ 1026.629829] BUG: scheduling while atomic: kworker/u16:5/164/0x00000003
[ 1026.629862] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp xt_CT ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip_set nfnetlink
ebtable_nat ebtable_broute ip6table_security ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_raw iptable_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
iptable_raw ebtable_filter ebtables ip6table_filter bridge ip6_tables
stp iptable_filter llc it87 hwmon_vid kvm_amd kvm irqbypass
crct10dif_pclmul snd_usb_audio crc32_pclmul ghash_clmulni_intel
snd_usbmidi_lib snd_rawmidi snd_hda_codec_hdmi aesni_intel
saa7134_alsa joydev aes_x86_64 input_leds mousedev snd_seq_device
[ 1026.629899]  led_class snd_hda_codec_realtek lrw
snd_hda_codec_generic saa7134 gf128mul snd_hda_intel snd_hda_codec
glue_helper tveeprom evdev mac_hid r8169 mxm_wmi pcspkr ablk_helper
cryptd fam15h_power rc_core snd_hda_core k10temp v4l2_common mii
snd_hwdep videobuf2_dma_sg videobuf2_memops snd_pcm videobuf2_v4l2
videobuf2_core snd_timer videodev snd acpi_cpufreq tpm_infineon
soundcore wmi media sp5100_tco tpm_tis tpm_tis_core tpm button
i2c_piix4 shpchp nfsd auth_rpcgss oid_registry nfs_acl sch_fq_codel
lockd grace vboxnetflt(O) vboxnetadp(O) sunrpc pci_stub vboxpci(O)
vboxdrv(O) nvidia_uvm(PO) btrfs xor zlib_deflate raid6_pq hid_generic
usbhid hid sd_mod ata_generic pata_acpi serio_raw atkbd libps2
nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) ohci_pci drm_kms_helper
firewire_ohci syscopyarea sysfillrect
[ 1026.629915]  firewire_core sysimgblt fb_sys_fops crc_itu_t xhci_pci
ahci pata_atiixp drm xhci_hcd ehci_pci libahci ehci_hcd ohci_hcd
usbcore usb_common i2c_core i8042 serio mvsas libsas
scsi_transport_sas libata scsi_mod crc32c_generic crc32c_intel vfat
fat ip_tables x_tables
[ 1026.629917] CPU: 4 PID: 164 Comm: kworker/u16:5 Tainted: P      D
 O    4.8.11-ARCH-dirty #1
[ 1026.629918] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 1026.629934]  0000000000000086 00000000d406ea4c ffff880606d37e50
ffffffff812e9a00
[ 1026.629937]  ffff88062ed17cc0 0000000000000009 ffff880606d37e60
ffffffff810a2964
[ 1026.629939]  ffff880606d37eb8 ffffffff815c71e0 00ffffff8116c8ef
ffff880600000008
[ 1026.629940] Call Trace:
[ 1026.629943]  [<ffffffff812e9a00>] dump_stack+0x63/0x83
[ 1026.629946]  [<ffffffff810a2964>] __schedule_bug+0x54/0x70
[ 1026.629950]  [<ffffffff815c71e0>] __schedule+0x600/0x780
[ 1026.629953]  [<ffffffff815c739c>] schedule+0x3c/0x90
[ 1026.629956]  [<ffffffff81080192>] do_exit+0x922/0xb20
[ 1026.629959]  [<ffffffff815cca57>] rewind_stack_do_exit+0x17/0x20
[ 1026.629962]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 1026.629972] BUG: unable to handle kernel paging request at ffffffffffffffd8
[ 1026.629974] IP: [<ffffffff8109b650>] kthread_data+0x10/0x20
[ 1026.629977] PGD 1809067 PUD 180b067 PMD 0
[ 1026.629979] Oops: 0000 [#4] PREEMPT SMP
