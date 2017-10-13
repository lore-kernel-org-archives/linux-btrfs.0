Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:46812 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756708AbdJMI5P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 04:57:15 -0400
Received: by mail-lf0-f52.google.com with SMTP id g70so8788489lfl.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 01:57:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC+fKQXPGpwuhVz7oNLzPLd0ydo+kiqG1vpcWvx+-DZ+2jL6Bg@mail.gmail.com>
References: <CAC+fKQXPGpwuhVz7oNLzPLd0ydo+kiqG1vpcWvx+-DZ+2jL6Bg@mail.gmail.com>
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
Date: Fri, 13 Oct 2017 10:57:12 +0200
Message-ID: <CAC+fKQV3GGrzRcW=jgOiz=rYrcFZhgr2XQWeGcW2eNwWOSOOSg@mail.gmail.com>
Subject: Re: Btrfs warnings in kernel 4.13.5
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-10-13 10:40 GMT+02:00 Juan Orti Alcaine <j.orti.alcaine@gmail.com>:
> Hi,
>
> I've upgraded my system to Fedora 27 and now I see many btrfs
> warnings, although the system seems to be working fine. Is this
> something I should worry about?


I'm getting more warnings:

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
[  805.824111] FS-Cache: Loaded
[  805.835188] FS-Cache: Netfs 'nfs' registered for caching
[  805.861120] Key type dns_resolver registered
[  805.891629] NFS: Registering the id_resolver key type
[  805.891635] Key type id_resolver registered
[  805.891635] Key type id_legacy registered
[  807.427618] nf_conntrack: default automatic helper assignment has
been turned off for security reasons and CT-based  firewall rule not
found. Use the iptables CT target to attach helpers instead.
[ 2512.070835] ------------[ cut here ]------------
[ 2512.070873] WARNING: CPU: 4 PID: 14051 at fs/btrfs/ctree.h:1559
btrfs_update_device+0x1be/0x1d0 [btrfs]
[ 2512.070874] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver
nfs fscache rfcomm fuse vhost_net vhost tap xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6
xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c
iptable_mangle iptable_raw iptable_security bridge stp llc
ebtable_filter ebtables ip6table_filter ip6_tables cmac bnep vfat fat
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic
snd_usb_audio snd_hda_codec_hdmi snd_hda_intel
[ 2512.070914]  snd_hda_codec snd_hda_core snd_usbmidi_lib eeepc_wmi
btusb btrtl uvcvideo snd_hwdep crct10dif_pclmul crc32_pclmul
videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 snd_seq
videobuf2_core ghash_clmulni_intel videodev intel_cstate asus_wmi
snd_rawmidi intel_uncore btbcm snd_seq_device btintel bluetooth
intel_rapl_perf sparse_keymap media ecdh_generic joydev wmi_bmof
snd_pcm rfkill i2c_i801 video iTCO_wdt iTCO_vendor_support mei_me mei
snd_timer wmi snd soundcore shpchp lpc_ich nfsd auth_rpcgss nfs_acl
lockd grace sunrpc binfmt_misc btrfs xor raid6_pq amdkfd amd_iommu_v2
radeon bcache i2c_algo_bit drm_kms_helper crc32c_intel ttm r8169
serio_raw drm mii
[ 2512.070956] CPU: 4 PID: 14051 Comm: btrfs Tainted: G        W
4.13.5-300.fc27.x86_64 #1
[ 2512.070957] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4102 09/09/2013
[ 2512.070959] task: ffff9e94fbc20000 task.stack: ffffb3a4cb1b8000
[ 2512.070983] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
[ 2512.070984] RSP: 0018:ffffb3a4cb1bb9b8 EFLAGS: 00010206
[ 2512.070986] RAX: 0000000000000fff RBX: ffff9e984a1eea10 RCX: 000001c97480fe00
[ 2512.070988] RDX: 0000000000000004 RSI: 0000000000003e98 RDI: ffff9e97f7ad3180
[ 2512.070989] RBP: ffffb3a4cb1bba00 R08: 0000000000003e9c R09: ffffb3a4cb1bb970
[ 2512.070990] R10: 0000000000001000 R11: 0000000000000003 R12: ffff9e9843aed000
[ 2512.070991] R13: 0000000000000000 R14: 0000000000003e78 R15: ffff9e97f7ad3180
[ 2512.070993] FS:  00007f7c32e81700(0000) GS:ffff9e985ed00000(0000)
knlGS:0000000000000000
[ 2512.070994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2512.070996] CR2: 00007fcec0f98028 CR3: 00000000d86b1000 CR4: 00000000000426e0
[ 2512.070997] Call Trace:
[ 2512.071023]  btrfs_finish_chunk_alloc+0x136/0x4f0 [btrfs]
[ 2512.071046]  ? free_extent_buffer+0x4b/0xa0 [btrfs]
[ 2512.071063]  ? btrfs_insert_item+0x80/0xf0 [btrfs]
[ 2512.071082]  btrfs_create_pending_block_groups+0xea/0x250 [btrfs]
[ 2512.071098]  ? btrfs_create_pending_block_groups+0xea/0x250 [btrfs]
[ 2512.071119]  __btrfs_end_transaction+0x8e/0x2d0 [btrfs]
[ 2512.071138]  btrfs_end_transaction+0x10/0x20 [btrfs]
[ 2512.071186]  btrfs_inc_block_group_ro+0xe6/0x170 [btrfs]
[ 2512.071219]  scrub_enumerate_chunks+0x1fc/0x6a0 [btrfs]
[ 2512.071228]  ? remove_wait_queue+0x40/0x70
[ 2512.071256]  btrfs_scrub_dev+0x20a/0x550 [btrfs]
[ 2512.071260]  ? __mnt_want_write+0x46/0x60
[ 2512.071290]  btrfs_ioctl+0x1343/0x24d0 [btrfs]
[ 2512.071294]  ? wake_up_q+0x44/0x80
[ 2512.071297]  ? rwsem_wake+0x8e/0xe0
[ 2512.071302]  do_vfs_ioctl+0xa5/0x600
[ 2512.071306]  ? ioc_create_icq+0x5b/0x1c0
[ 2512.071309]  ? do_vfs_ioctl+0xa5/0x600
[ 2512.071312]  ? get_task_io_context+0x46/0x80
[ 2512.071316]  SyS_ioctl+0x79/0x90
[ 2512.071321]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[ 2512.071324] RIP: 0033:0x7f7c32f91117
[ 2512.071326] RSP: 002b:00007f7c32e80d48 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 2512.071329] RAX: ffffffffffffffda RBX: 00007f7c32e81700 RCX: 00007f7c32f91117
[ 2512.071330] RDX: 00005610fd88a660 RSI: 00000000c400941b RDI: 0000000000000003
[ 2512.071332] RBP: 0000000000000000 R08: 00007f7c32e81700 R09: 0000000000000000
[ 2512.071333] R10: 00007f7c32e81700 R11: 0000000000000246 R12: 00007f7c32e80e40
[ 2512.071335] R13: 00007ffd91b8af10 R14: 0000000000000000 R15: 0000000000000000
[ 2512.071338] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 fa
20 ff ff 4c 89 ff e8 f2 ee fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9
d0 fe ff ff <0f> ff eb b6 e8 29 bd ab ca 66 0f 1f 84 00 00 00 00 00 66
66 66
[ 2512.071391] ---[ end trace 3609a7da677d8848 ]---
[ 2512.071476] ------------[ cut here ]------------
[ 2512.071509] WARNING: CPU: 4 PID: 14051 at fs/btrfs/ctree.h:1559
btrfs_update_device+0x1be/0x1d0 [btrfs]
[ 2512.071510] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver
nfs fscache rfcomm fuse vhost_net vhost tap xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6
xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c
iptable_mangle iptable_raw iptable_security bridge stp llc
ebtable_filter ebtables ip6table_filter ip6_tables cmac bnep vfat fat
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic
snd_usb_audio snd_hda_codec_hdmi snd_hda_intel
[ 2512.071565]  snd_hda_codec snd_hda_core snd_usbmidi_lib eeepc_wmi
btusb btrtl uvcvideo snd_hwdep crct10dif_pclmul crc32_pclmul
videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 snd_seq
videobuf2_core ghash_clmulni_intel videodev intel_cstate asus_wmi
snd_rawmidi intel_uncore btbcm snd_seq_device btintel bluetooth
intel_rapl_perf sparse_keymap media ecdh_generic joydev wmi_bmof
snd_pcm rfkill i2c_i801 video iTCO_wdt iTCO_vendor_support mei_me mei
snd_timer wmi snd soundcore shpchp lpc_ich nfsd auth_rpcgss nfs_acl
lockd grace sunrpc binfmt_misc btrfs xor raid6_pq amdkfd amd_iommu_v2
radeon bcache i2c_algo_bit drm_kms_helper crc32c_intel ttm r8169
serio_raw drm mii
[ 2512.071624] CPU: 4 PID: 14051 Comm: btrfs Tainted: G        W
4.13.5-300.fc27.x86_64 #1
[ 2512.071626] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4102 09/09/2013
[ 2512.071628] task: ffff9e94fbc20000 task.stack: ffffb3a4cb1b8000
[ 2512.071657] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
[ 2512.071659] RSP: 0018:ffffb3a4cb1bb9b8 EFLAGS: 00010206
[ 2512.071662] RAX: 0000000000000fff RBX: ffff9e984a1eea10 RCX: 000001d1c100fe00
[ 2512.071664] RDX: 0000000000000004 RSI: 0000000000003f5c RDI: ffff9e97f7ad3180
[ 2512.071665] RBP: ffffb3a4cb1bba00 R08: 0000000000003f60 R09: ffffb3a4cb1bb970
[ 2512.071667] R10: 0000000000001000 R11: 0000000000000003 R12: ffff9e9844995800
[ 2512.071669] R13: 0000000000000000 R14: 0000000000003f3c R15: ffff9e97f7ad3180
[ 2512.071676] FS:  00007f7c32e81700(0000) GS:ffff9e985ed00000(0000)
knlGS:0000000000000000
[ 2512.071677] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2512.071679] CR2: 00007fcec0f98028 CR3: 00000000d86b1000 CR4: 00000000000426e0
[ 2512.071681] Call Trace:
[ 2512.071713]  btrfs_finish_chunk_alloc+0x136/0x4f0 [btrfs]
[ 2512.071744]  btrfs_create_pending_block_groups+0xea/0x250 [btrfs]
[ 2512.071771]  ? btrfs_create_pending_block_groups+0xea/0x250 [btrfs]
[ 2512.071802]  __btrfs_end_transaction+0x8e/0x2d0 [btrfs]
[ 2512.071829]  btrfs_end_transaction+0x10/0x20 [btrfs]
[ 2512.071860]  btrfs_inc_block_group_ro+0xe6/0x170 [btrfs]
[ 2512.071893]  scrub_enumerate_chunks+0x1fc/0x6a0 [btrfs]
[ 2512.071899]  ? remove_wait_queue+0x40/0x70
[ 2512.071931]  btrfs_scrub_dev+0x20a/0x550 [btrfs]
[ 2512.071935]  ? __mnt_want_write+0x46/0x60
[ 2512.071964]  btrfs_ioctl+0x1343/0x24d0 [btrfs]
[ 2512.071968]  ? wake_up_q+0x44/0x80
[ 2512.071972]  ? rwsem_wake+0x8e/0xe0
[ 2512.071977]  do_vfs_ioctl+0xa5/0x600
[ 2512.071981]  ? ioc_create_icq+0x5b/0x1c0
[ 2512.071985]  ? do_vfs_ioctl+0xa5/0x600
[ 2512.071988]  ? get_task_io_context+0x46/0x80
[ 2512.071992]  SyS_ioctl+0x79/0x90
[ 2512.071997]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[ 2512.071999] RIP: 0033:0x7f7c32f91117
[ 2512.072001] RSP: 002b:00007f7c32e80d48 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 2512.072004] RAX: ffffffffffffffda RBX: 00007f7c32e81700 RCX: 00007f7c32f91117
[ 2512.072006] RDX: 00005610fd88a660 RSI: 00000000c400941b RDI: 0000000000000003
[ 2512.072007] RBP: 0000000000000000 R08: 00007f7c32e81700 R09: 0000000000000000
[ 2512.072009] R10: 00007f7c32e81700 R11: 0000000000000246 R12: 00007f7c32e80e40
[ 2512.072010] R13: 00007ffd91b8af10 R14: 0000000000000000 R15: 0000000000000000
[ 2512.072013] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 fa
20 ff ff 4c 89 ff e8 f2 ee fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9
d0 fe ff ff <0f> ff eb b6 e8 29 bd ab ca 66 0f 1f 84 00 00 00 00 00 66
66 66
[ 2512.072067] ---[ end trace 3609a7da677d8849 ]---
