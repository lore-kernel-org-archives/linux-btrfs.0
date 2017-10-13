Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:54428 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757815AbdJMIkX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 04:40:23 -0400
Received: by mail-lf0-f50.google.com with SMTP id d10so8750998lfg.11
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 01:40:22 -0700 (PDT)
MIME-Version: 1.0
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
Date: Fri, 13 Oct 2017 10:40:20 +0200
Message-ID: <CAC+fKQXPGpwuhVz7oNLzPLd0ydo+kiqG1vpcWvx+-DZ+2jL6Bg@mail.gmail.com>
Subject: Btrfs warnings in kernel 4.13.5
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've upgraded my system to Fedora 27 and now I see many btrfs
warnings, although the system seems to be working fine. Is this
something I should worry about?

I have a scrub running with no errors so far:

# btrfs scrub status /mnt/btrfs
scrub status for 038b2b48-fd2d-4565-b2b1-d07847ecca8c
        scrub started at Thu Oct 12 19:35:55 2017, running for 03:28:41
        total bytes scrubbed: 3.35TiB with 0 errors

# uname -a
Linux xenon 4.13.5-300.fc27.x86_64 #1 SMP Thu Oct 5 16:57:11 UTC 2017
x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.13.2

# btrfs fi show
Label: 'btrfs_raid1'  uuid: 038b2b48-fd2d-4565-b2b1-d07847ecca8c
        Total devices 4 FS bytes used 1.81TiB
        devid    4 size 1.82TiB used 1.19TiB path /dev/bcache32
        devid    5 size 1.82TiB used 1.19TiB path /dev/bcache16
        devid    6 size 1.82TiB used 1.19TiB path /dev/bcache0
        devid    7 size 1.79TiB used 158.00GiB path /dev/bcache48

# btrfs fi usage /mnt/btrfs
Overall:
    Device size:                   7.24TiB
    Device allocated:              3.72TiB
    Device unallocated:            3.53TiB
    Device missing:                  0.00B
    Used:                          3.62TiB
    Free (estimated):              1.81TiB      (min: 1.81TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:1.85TiB, Used:1.80TiB
   /dev/bcache0    1.18TiB
   /dev/bcache16           1.18TiB
   /dev/bcache32           1.18TiB
   /dev/bcache48         157.00GiB

Metadata,RAID1: Size:7.00GiB, Used:5.78GiB
   /dev/bcache0    5.00GiB
   /dev/bcache16           4.00GiB
   /dev/bcache32           4.00GiB
   /dev/bcache48           1.00GiB

System,RAID1: Size:32.00MiB, Used:320.00KiB
   /dev/bcache16          32.00MiB
   /dev/bcache32          32.00MiB

Unallocated:
   /dev/bcache0  647.02GiB
   /dev/bcache16         647.98GiB
   /dev/bcache32         645.98GiB
   /dev/bcache48           1.63TiB

All my bcache devices are in writethrough mode:

# bcache-status -s
--- bcache ---
UUID                        d82cf90a-756c-4b8a-b871-72714cdae024
Block Size                  4.00 KiB
Bucket Size                 2.0 MiB
Congested?                  False
Read Congestion             2.0ms
Write Congestion            20.0ms
Total Cache Size            95 GiB
Total Cache Used            95 GiB    (100%)
Total Cache Unused          0 B    (0%)
Evictable Cache             95 GiB    (100%)
Replacement Policy          [lru] fifo random
Cache Mode                  [writethrough] writeback writearound none
Total Hits                  150430    (62%)
Total Misses                90622
Total Bypass Hits           1036307    (100%)
Total Bypass Misses         0
Total Bypassed              2 GiB
--- Backing Device ---
  Device File               /dev/sde4 (8:68)
  bcache Device File        /dev/bcache48 (252:48)
  Size                      2 TiB
  Cache Mode                [writethrough] writeback writearound none
  Readahead                 0.0k
  Sequential Cutoff         4.0 MiB
  Merge sequential?         False
  State                     clean
  Writeback?                True
  Dirty Data                0 B
  Total Hits                14066    (57%)
  Total Misses              10363
  Total Bypass Hits         40454    (100%)
  Total Bypass Misses       0
  Total Bypassed            134.3 MiB
--- Cache Device ---
  Device File               /dev/sda4 (8:4)
  Size                      95 GiB
  Block Size                4.00 KiB
  Bucket Size               2.0 MiB
  Replacement Policy        [lru] fifo random
  Discard?                  False
  I/O Errors                0
  Metadata Written          99.1 MiB
  Data Written              6 GiB
  Buckets                   48432
  Cache Used                95 GiB    (100%)
  Cache Unused              0 B    (0%)
--- Backing Device ---
  Device File               /dev/sdb1 (8:17)
  bcache Device File        /dev/bcache32 (252:32)
  Size                      2 TiB
  Cache Mode                [writethrough] writeback writearound none
  Readahead                 0.0k
  Sequential Cutoff         4.0 MiB
  Merge sequential?         False
  State                     clean
  Writeback?                True
  Dirty Data                0 B
  Total Hits                28167    (40%)
  Total Misses              42227
  Total Bypass Hits         632707    (100%)
  Total Bypass Misses       0
  Total Bypassed            2 GiB
--- Backing Device ---
  Device File               /dev/sdc1 (8:33)
  bcache Device File        /dev/bcache16 (252:16)
  Size                      2 TiB
  Cache Mode                [writethrough] writeback writearound none
  Readahead                 0.0k
  Sequential Cutoff         4.0 MiB
  Merge sequential?         False
  State                     clean
  Writeback?                True
  Dirty Data                0 B
  Total Hits                67948    (74%)
  Total Misses              23356
  Total Bypass Hits         201077    (100%)
  Total Bypass Misses       0
  Total Bypassed            576.0 MiB
--- Backing Device ---
  Device File               /dev/sdd1 (8:49)
  bcache Device File        /dev/bcache0 (252:0)
  Size                      2 TiB
  Cache Mode                [writethrough] writeback writearound none
  Readahead                 0.0k
  Sequential Cutoff         4.0 MiB
  Merge sequential?         False
  State                     clean
  Writeback?                True
  Dirty Data                0 B
  Total Hits                40249    (73%)
  Total Misses              14676
  Total Bypass Hits         162406    (100%)
  Total Bypass Misses       0
  Total Bypassed            590.3 MiB

[  337.813416] ------------[ cut here ]------------
[  337.813453] WARNING: CPU: 5 PID: 459 at fs/btrfs/ctree.h:1559
btrfs_update_device+0x1be/0x1d0 [btrfs]
[  337.813454] Modules linked in: rfcomm fuse vhost_net vhost tap
xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat
ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
libcrc32c iptable_mangle iptable_raw iptable_security bridge stp llc
ebtable_filter ebtables ip6table_filter ip6_tables cmac bnep vfat fat
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic
snd_usb_audio snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
snd_hda_core snd_usbmidi_lib eeepc_wmi
[  337.813494]  btusb btrtl uvcvideo snd_hwdep crct10dif_pclmul
crc32_pclmul videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 snd_seq
videobuf2_core ghash_clmulni_intel videodev intel_cstate asus_wmi
snd_rawmidi intel_uncore btbcm snd_seq_device btintel bluetooth
intel_rapl_perf sparse_keymap media ecdh_generic joydev wmi_bmof
snd_pcm rfkill i2c_i801 video iTCO_wdt iTCO_vendor_support mei_me mei
snd_timer wmi snd soundcore shpchp lpc_ich nfsd auth_rpcgss nfs_acl
lockd grace sunrpc binfmt_misc btrfs xor raid6_pq amdkfd amd_iommu_v2
radeon bcache i2c_algo_bit drm_kms_helper crc32c_intel ttm r8169
serio_raw drm mii
[  337.813534] CPU: 5 PID: 459 Comm: btrfs-cleaner Not tainted
4.13.5-300.fc27.x86_64 #1
[  337.813535] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4102 09/09/2013
[  337.813537] task: ffff9e98479ecc80 task.stack: ffffb3a4c2290000
[  337.813561] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
[  337.813563] RSP: 0018:ffffb3a4c2293d28 EFLAGS: 00010206
[  337.813565] RAX: 0000000000000fff RBX: ffff9e9844f3ad20 RCX: 000001c97480fe00
[  337.813566] RDX: 0000000000000004 RSI: 0000000000003e98 RDI: ffff9e9821e5e000
[  337.813567] RBP: ffffb3a4c2293d70 R08: 0000000000003e9c R09: ffffb3a4c2293ce0
[  337.813568] R10: 0000000000001000 R11: 0000000000000003 R12: ffff9e9843aed000
[  337.813569] R13: 0000000000000000 R14: 0000000000003e78 R15: ffff9e9821e5e000
[  337.813572] FS:  0000000000000000(0000) GS:ffff9e985ed40000(0000)
knlGS:0000000000000000
[  337.813573] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  337.813574] CR2: 00001f89b1c4d000 CR3: 000000037ce09000 CR4: 00000000000426e0
[  337.813576] Call Trace:
[  337.813603]  btrfs_remove_chunk+0x365/0x870 [btrfs]
[  337.813624]  btrfs_delete_unused_bgs+0x30d/0x3d0 [btrfs]
[  337.813644]  cleaner_kthread+0x165/0x180 [btrfs]
[  337.813650]  kthread+0x125/0x140
[  337.813667]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[  337.813670]  ? kthread_park+0x60/0x60
[  337.813675]  ret_from_fork+0x25/0x30
[  337.813677] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 fa
20 ff ff 4c 89 ff e8 f2 ee fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9
d0 fe ff ff <0f> ff eb b6 e8 29 bd ab ca 66 0f 1f 84 00 00 00 00 00 66
66 66
[  337.813713] ---[ end trace 3609a7da677d8844 ]---
[  337.814256] ------------[ cut here ]------------
[  337.814281] WARNING: CPU: 5 PID: 459 at fs/btrfs/ctree.h:1559
btrfs_update_device+0x1be/0x1d0 [btrfs]
[  337.814281] Modules linked in: rfcomm fuse vhost_net vhost tap
xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat
ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
libcrc32c iptable_mangle iptable_raw iptable_security bridge stp llc
ebtable_filter ebtables ip6table_filter ip6_tables cmac bnep vfat fat
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic
snd_usb_audio snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
snd_hda_core snd_usbmidi_lib eeepc_wmi
[  337.814316]  btusb btrtl uvcvideo snd_hwdep crct10dif_pclmul
crc32_pclmul videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 snd_seq
videobuf2_core ghash_clmulni_intel videodev intel_cstate asus_wmi
snd_rawmidi intel_uncore btbcm snd_seq_device btintel bluetooth
intel_rapl_perf sparse_keymap media ecdh_generic joydev wmi_bmof
snd_pcm rfkill i2c_i801 video iTCO_wdt iTCO_vendor_support mei_me mei
snd_timer wmi snd soundcore shpchp lpc_ich nfsd auth_rpcgss nfs_acl
lockd grace sunrpc binfmt_misc btrfs xor raid6_pq amdkfd amd_iommu_v2
radeon bcache i2c_algo_bit drm_kms_helper crc32c_intel ttm r8169
serio_raw drm mii
[  337.814352] CPU: 5 PID: 459 Comm: btrfs-cleaner Tainted: G        W
      4.13.5-300.fc27.x86_64 #1
[  337.814353] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4102 09/09/2013
[  337.814354] task: ffff9e98479ecc80 task.stack: ffffb3a4c2290000
[  337.814375] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
[  337.814376] RSP: 0018:ffffb3a4c2293d28 EFLAGS: 00010206
[  337.814378] RAX: 0000000000000fff RBX: ffff9e9844f3ad20 RCX: 000001d1c100fe00
[  337.814379] RDX: 0000000000000004 RSI: 0000000000003f5c RDI: ffff9e9821e5e000
[  337.814380] RBP: ffffb3a4c2293d70 R08: 0000000000003f60 R09: ffffb3a4c2293ce0
[  337.814381] R10: 0000000000001000 R11: 0000000000000003 R12: ffff9e9844995800
[  337.814382] R13: 0000000000000000 R14: 0000000000003f3c R15: ffff9e9821e5e000
[  337.814384] FS:  0000000000000000(0000) GS:ffff9e985ed40000(0000)
knlGS:0000000000000000
[  337.814385] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  337.814387] CR2: 00001f89b1c4d000 CR3: 000000037ce09000 CR4: 00000000000426e0
[  337.814388] Call Trace:
[  337.814410]  btrfs_remove_chunk+0x365/0x870 [btrfs]
[  337.814443]  btrfs_delete_unused_bgs+0x30d/0x3d0 [btrfs]
[  337.814462]  cleaner_kthread+0x165/0x180 [btrfs]
[  337.814466]  kthread+0x125/0x140
[  337.814483]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[  337.814485]  ? kthread_park+0x60/0x60
[  337.814488]  ret_from_fork+0x25/0x30
[  337.814490] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 fa
20 ff ff 4c 89 ff e8 f2 ee fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9
d0 fe ff ff <0f> ff eb b6 e8 29 bd ab ca 66 0f 1f 84 00 00 00 00 00 66
66 66
[  337.814529] ---[ end trace 3609a7da677d8845 ]---
[  337.822161] ------------[ cut here ]------------
[  337.822185] WARNING: CPU: 5 PID: 459 at fs/btrfs/ctree.h:1559
btrfs_update_device+0x1be/0x1d0 [btrfs]
[  337.822185] Modules linked in: rfcomm fuse vhost_net vhost tap
xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat
ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
libcrc32c iptable_mangle iptable_raw iptable_security bridge stp llc
ebtable_filter ebtables ip6table_filter ip6_tables cmac bnep vfat fat
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic
snd_usb_audio snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
snd_hda_core snd_usbmidi_lib eeepc_wmi
[  337.822221]  btusb btrtl uvcvideo snd_hwdep crct10dif_pclmul
crc32_pclmul videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 snd_seq
videobuf2_core ghash_clmulni_intel videodev intel_cstate asus_wmi
snd_rawmidi intel_uncore btbcm snd_seq_device btintel bluetooth
intel_rapl_perf sparse_keymap media ecdh_generic joydev wmi_bmof
snd_pcm rfkill i2c_i801 video iTCO_wdt iTCO_vendor_support mei_me mei
snd_timer wmi snd soundcore shpchp lpc_ich nfsd auth_rpcgss nfs_acl
lockd grace sunrpc binfmt_misc btrfs xor raid6_pq amdkfd amd_iommu_v2
radeon bcache i2c_algo_bit drm_kms_helper crc32c_intel ttm r8169
serio_raw drm mii
[  337.822256] CPU: 5 PID: 459 Comm: btrfs-cleaner Tainted: G        W
      4.13.5-300.fc27.x86_64 #1
[  337.822257] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4102 09/09/2013
[  337.822258] task: ffff9e98479ecc80 task.stack: ffffb3a4c2290000
[  337.822278] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
[  337.822279] RSP: 0018:ffffb3a4c2293d28 EFLAGS: 00010206
[  337.822281] RAX: 0000000000000fff RBX: ffff9e9844f3ad20 RCX: 000001c97480fe00
[  337.822282] RDX: 0000000000000004 RSI: 0000000000003e98 RDI: ffff9e9821e5e000
[  337.822283] RBP: ffffb3a4c2293d70 R08: 0000000000003e9c R09: ffffb3a4c2293ce0
[  337.822284] R10: 0000000000001000 R11: 0000000000000003 R12: ffff9e9843aed000
[  337.822285] R13: 0000000000000000 R14: 0000000000003e78 R15: ffff9e9821e5e000
[  337.822287] FS:  0000000000000000(0000) GS:ffff9e985ed40000(0000)
knlGS:0000000000000000
[  337.822288] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  337.822289] CR2: 00001f89b1c4d000 CR3: 000000037ce09000 CR4: 00000000000426e0
[  337.822290] Call Trace:
[  337.822328]  btrfs_remove_chunk+0x365/0x870 [btrfs]
[  337.822347]  btrfs_delete_unused_bgs+0x30d/0x3d0 [btrfs]
[  337.822373]  cleaner_kthread+0x165/0x180 [btrfs]
[  337.822376]  kthread+0x125/0x140
[  337.822392]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[  337.822394]  ? kthread_park+0x60/0x60
[  337.822409]  ret_from_fork+0x25/0x30
[  337.822410] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 fa
20 ff ff 4c 89 ff e8 f2 ee fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9
d0 fe ff ff <0f> ff eb b6 e8 29 bd ab ca 66 0f 1f 84 00 00 00 00 00 66
66 66
[  337.822446] ---[ end trace 3609a7da677d8846 ]---
[  337.822868] ------------[ cut here ]------------
[  337.822890] WARNING: CPU: 5 PID: 459 at fs/btrfs/ctree.h:1559
btrfs_update_device+0x1be/0x1d0 [btrfs]
[  337.822891] Modules linked in: rfcomm fuse vhost_net vhost tap
xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat
ebtable_broute ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
libcrc32c iptable_mangle iptable_raw iptable_security bridge stp llc
ebtable_filter ebtables ip6table_filter ip6_tables cmac bnep vfat fat
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic
snd_usb_audio snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
snd_hda_core snd_usbmidi_lib eeepc_wmi
[  337.822928]  btusb btrtl uvcvideo snd_hwdep crct10dif_pclmul
crc32_pclmul videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 snd_seq
videobuf2_core ghash_clmulni_intel videodev intel_cstate asus_wmi
snd_rawmidi intel_uncore btbcm snd_seq_device btintel bluetooth
intel_rapl_perf sparse_keymap media ecdh_generic joydev wmi_bmof
snd_pcm rfkill i2c_i801 video iTCO_wdt iTCO_vendor_support mei_me mei
snd_timer wmi snd soundcore shpchp lpc_ich nfsd auth_rpcgss nfs_acl
lockd grace sunrpc binfmt_misc btrfs xor raid6_pq amdkfd amd_iommu_v2
radeon bcache i2c_algo_bit drm_kms_helper crc32c_intel ttm r8169
serio_raw drm mii
[  337.822963] CPU: 5 PID: 459 Comm: btrfs-cleaner Tainted: G        W
      4.13.5-300.fc27.x86_64 #1
[  337.822964] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4102 09/09/2013
[  337.822965] task: ffff9e98479ecc80 task.stack: ffffb3a4c2290000
[  337.822983] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
[  337.822984] RSP: 0018:ffffb3a4c2293d28 EFLAGS: 00010206
[  337.822986] RAX: 0000000000000fff RBX: ffff9e9844f3ad20 RCX: 000001d1c100fe00
[  337.822987] RDX: 0000000000000004 RSI: 0000000000003efa RDI: ffff9e9821e5e000
[  337.822988] RBP: ffffb3a4c2293d70 R08: 0000000000003efe R09: ffffb3a4c2293ce0
[  337.822989] R10: 0000000000001000 R11: 0000000000000003 R12: ffff9e9844999c00
[  337.822990] R13: 0000000000000000 R14: 0000000000003eda R15: ffff9e9821e5e000
[  337.822994] FS:  0000000000000000(0000) GS:ffff9e985ed40000(0000)
knlGS:0000000000000000
[  337.822995] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  337.822996] CR2: 00001f89b1c4d000 CR3: 000000037ce09000 CR4: 00000000000426e0
[  337.822997] Call Trace:
[  337.823017]  btrfs_remove_chunk+0x365/0x870 [btrfs]
[  337.823036]  btrfs_delete_unused_bgs+0x30d/0x3d0 [btrfs]
[  337.823054]  cleaner_kthread+0x165/0x180 [btrfs]
[  337.823057]  kthread+0x125/0x140
[  337.823074]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[  337.823078]  ? kthread_park+0x60/0x60
[  337.823081]  ret_from_fork+0x25/0x30
[  337.823083] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 fa
20 ff ff 4c 89 ff e8 f2 ee fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9
d0 fe ff ff <0f> ff eb b6 e8 29 bd ab ca 66 0f 1f 84 00 00 00 00 00 66
66 66
[  337.823118] ---[ end trace 3609a7da677d8847 ]---
