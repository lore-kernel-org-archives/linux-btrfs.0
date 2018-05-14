Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from z8.mailgun.us ([104.130.96.8]:44187 "EHLO z8.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751449AbeENJXB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 05:23:01 -0400
Received: by mail-it0-f47.google.com with SMTP id 144-v6so9280362iti.5
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 02:18:00 -0700 (PDT)
MIME-Version: 1.0
From: Lukas Tribus <lukas@ltri.eu>
Date: Mon, 14 May 2018 11:17:59 +0200
Message-ID: <CACC_My9Vvd4p9LyKUTqYMLU1sXTNTB7xmpbx_ZtGEvBA8=M2=Q@mail.gmail.com>
Subject: 4.13 call trace in btrfs_update_device
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,


seeing calltraces like this on a Ubuntu 4.13 kernel, not sure what
happens here and what the impact is:


[13729.871604] ------------[ cut here ]------------
[13729.871647] WARNING: CPU: 1 PID: 3048 at
/build/linux-hwe-rDkE7z/linux-hwe-4.13.0/fs/btrfs/ctree.h:1559
btrfs_update_device+0x1b4/0x1c0 [btrfs]
[13729.871648] Modules linked in: xen_pciback xt_physdev br_netfilter
iptable_filter ip_tables x_tables xen_netback xen_blkback
algif_skcipher af_alg xen_gntdev xen_evtchn xenfs xen_privcmd
nls_iso8859_1 dm_crypt intel_rapl bridge stp llc x86_pkg_temp_thermal
intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel intel_rapl_perf shpchp ie31200_edac mei_me mei
nuvoton_cir rc_core lpc_ich mac_hid ib_iser rdma_cm iw_cm ib_cm
ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4
btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear
hid_generic usbhid hid i915 aesni_intel firewire_ohci i2c_algo_bit
aes_x86_64 tg3 crypto_simd drm_kms_helper ptp firewire_core cryptd
syscopyarea mxm_wmi glue_helper
[13729.871702]  crc_itu_t pps_core sysfillrect ahci sysimgblt
fb_sys_fops libahci drm wmi video
[13729.871714] CPU: 1 PID: 3048 Comm: btrfs-cleaner Tainted: G
W       4.13.0-41-generic #46~16.04.1-Ubuntu
[13729.871715] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./Z77 Extreme6, BIOS P2.80 07/01/2013
[13729.871717] task: ffff8802a1211740 task.stack: ffffc90042310000
[13729.871743] RIP: e030:btrfs_update_device+0x1b4/0x1c0 [btrfs]
[13729.871744] RSP: e02b:ffffc90042313d10 EFLAGS: 00010206
[13729.871746] RAX: 0000000000000fff RBX: 0000000000000000 RCX: 00000917dfcfbe00
[13729.871748] RDX: 0000000000000004 RSI: 0000000000003dd4 RDI: ffff8801126aaaf0
[13729.871749] RBP: ffffc90042313d58 R08: 0000000000003dd8 R09: ffffc90042313cc8
[13729.871751] R10: 0000000000001000 R11: 0000000000000003 R12: ffff8802a2779a10
[13729.871752] R13: ffff8802a30ad000 R14: 0000000000003db4 R15: ffff8801126aaaf0
[13729.871761] FS:  0000000000000000(0000) GS:ffff8802b2480000(0000)
knlGS:ffff8802b2480000
[13729.871762] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[13729.871764] CR2: 00007f870df80480 CR3: 00000001a1618000 CR4: 0000000000042660
[13729.871766] Call Trace:
[13729.871795]  btrfs_remove_chunk+0x2b8/0x880 [btrfs]
[13729.871819]  btrfs_delete_unused_bgs+0x336/0x3e0 [btrfs]
[13729.871841]  cleaner_kthread+0x155/0x190 [btrfs]
[13729.871847]  kthread+0x10c/0x140
[13729.871868]  ? run_one_async_done+0xc0/0xc0 [btrfs]
[13729.871871]  ? kthread_create_on_node+0x70/0x70
[13729.871875]  ret_from_fork+0x35/0x40
[13729.871877] Code: 00 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8
73 23 ff ff 4c 89 ff e8 7b f5 fc ff e9 d9 fe ff ff b8 f4 ff ff ff e9
d9 fe ff ff <0f> ff eb b8 e8 53 e8 ba c0 0f 1f 00 0f 1f 44 00 00 55 48
89 e5
[13729.871923] ---[ end trace 2e6095c7c763f649 ]---
[13729.885370] ------------[ cut here ]------------
[13729.885411] WARNING: CPU: 2 PID: 3048 at
/build/linux-hwe-rDkE7z/linux-hwe-4.13.0/fs/btrfs/ctree.h:1559
btrfs_update_device+0x1b4/0x1c0 [btrfs]
[13729.885412] Modules linked in: xen_pciback xt_physdev br_netfilter
iptable_filter ip_tables x_tables xen_netback xen_blkback
algif_skcipher af_alg xen_gntdev xen_evtchn xenfs xen_privcmd
nls_iso8859_1 dm_crypt intel_rapl bridge stp llc x86_pkg_temp_thermal
intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel intel_rapl_perf shpchp ie31200_edac mei_me mei
nuvoton_cir rc_core lpc_ich mac_hid ib_iser rdma_cm iw_cm ib_cm
ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4
btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear
hid_generic usbhid hid i915 aesni_intel firewire_ohci i2c_algo_bit
aes_x86_64 tg3 crypto_simd drm_kms_helper ptp firewire_core cryptd
syscopyarea mxm_wmi glue_helper
[13729.885466]  crc_itu_t pps_core sysfillrect ahci sysimgblt
fb_sys_fops libahci drm wmi video
[13729.885478] CPU: 2 PID: 3048 Comm: btrfs-cleaner Tainted: G
W       4.13.0-41-generic #46~16.04.1-Ubuntu
[13729.885479] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./Z77 Extreme6, BIOS P2.80 07/01/2013
[13729.885481] task: ffff8802a1211740 task.stack: ffffc90042310000
[13729.885506] RIP: e030:btrfs_update_device+0x1b4/0x1c0 [btrfs]
[13729.885508] RSP: e02b:ffffc90042313d10 EFLAGS: 00010206
[13729.885510] RAX: 0000000000000fff RBX: 0000000000000000 RCX: 00000917dfcfbe00
[13729.885512] RDX: 0000000000000004 RSI: 0000000000003dd4 RDI: ffff8801126aaaf0
[13729.885513] RBP: ffffc90042313d58 R08: 0000000000003dd8 R09: ffffc90042313cc8
[13729.885514] R10: 0000000000001000 R11: 0000000000000003 R12: ffff8802a25414d0
[13729.885516] R13: ffff8802a30ad000 R14: 0000000000003db4 R15: ffff8801126aaaf0
[13729.885524] FS:  0000000000000000(0000) GS:ffff8802b2500000(0000)
knlGS:ffff88003d300000
[13729.885525] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[13729.885527] CR2: 0000000002418e58 CR3: 00000002a966e000 CR4: 0000000000042660
[13729.885529] Call Trace:
[13729.885557]  btrfs_remove_chunk+0x2b8/0x880 [btrfs]
[13729.885580]  btrfs_delete_unused_bgs+0x336/0x3e0 [btrfs]
[13729.885603]  cleaner_kthread+0x155/0x190 [btrfs]
[13729.885608]  kthread+0x10c/0x140
[13729.885629]  ? run_one_async_done+0xc0/0xc0 [btrfs]
[13729.885632]  ? kthread_create_on_node+0x70/0x70
[13729.885636]  ret_from_fork+0x35/0x40
[13729.885638] Code: 00 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8
73 23 ff ff 4c 89 ff e8 7b f5 fc ff e9 d9 fe ff ff b8 f4 ff ff ff e9
d9 fe ff ff <0f> ff eb b8 e8 53 e8 ba c0 0f 1f 00 0f 1f 44 00 00 55 48
89 e5
[13729.885684] ---[ end trace 2e6095c7c763f64a ]---
[13729.886013] ------------[ cut here ]------------
[13729.886038] WARNING: CPU: 2 PID: 3048 at
/build/linux-hwe-rDkE7z/linux-hwe-4.13.0/fs/btrfs/ctree.h:1559
btrfs_update_device+0x1b4/0x1c0 [btrfs]
[13729.886039] Modules linked in: xen_pciback xt_physdev br_netfilter
iptable_filter ip_tables x_tables xen_netback xen_blkback
algif_skcipher af_alg xen_gntdev xen_evtchn xenfs xen_privcmd
nls_iso8859_1 dm_crypt intel_rapl bridge stp llc x86_pkg_temp_thermal
intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel intel_rapl_perf shpchp ie31200_edac mei_me mei
nuvoton_cir rc_core lpc_ich mac_hid ib_iser rdma_cm iw_cm ib_cm
ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4
btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear
hid_generic usbhid hid i915 aesni_intel firewire_ohci i2c_algo_bit
aes_x86_64 tg3 crypto_simd drm_kms_helper ptp firewire_core cryptd
syscopyarea mxm_wmi glue_helper
[13729.886088]  crc_itu_t pps_core sysfillrect ahci sysimgblt
fb_sys_fops libahci drm wmi video
[13729.886098] CPU: 2 PID: 3048 Comm: btrfs-cleaner Tainted: G
W       4.13.0-41-generic #46~16.04.1-Ubuntu
[13729.886099] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./Z77 Extreme6, BIOS P2.80 07/01/2013
[13729.886100] task: ffff8802a1211740 task.stack: ffffc90042310000
[13729.886122] RIP: e030:btrfs_update_device+0x1b4/0x1c0 [btrfs]
[13729.886123] RSP: e02b:ffffc90042313d10 EFLAGS: 00010206
[13729.886125] RAX: 0000000000000fff RBX: 0000000000000000 RCX: 00000917dfcfbe00
[13729.886127] RDX: 0000000000000004 RSI: 0000000000003dd4 RDI: ffff8801126aaaf0
[13729.886128] RBP: ffffc90042313d58 R08: 0000000000003dd8 R09: ffffc90042313cc8
[13729.886130] R10: 0000000000001000 R11: 0000000000000003 R12: ffff8802a25414d0
[13729.886131] R13: ffff8802a30ad000 R14: 0000000000003db4 R15: ffff8801126aaaf0
[13729.886137] FS:  0000000000000000(0000) GS:ffff8802b2500000(0000)
knlGS:ffff88003d300000
[13729.886138] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[13729.886140] CR2: 0000000002418e58 CR3: 00000002a966e000 CR4: 0000000000042660
[13729.886141] Call Trace:
[13729.886165]  btrfs_remove_chunk+0x2b8/0x880 [btrfs]
[13729.886187]  btrfs_delete_unused_bgs+0x336/0x3e0 [btrfs]
[13729.886208]  cleaner_kthread+0x155/0x190 [btrfs]
[13729.886212]  kthread+0x10c/0x140
[13729.886231]  ? run_one_async_done+0xc0/0xc0 [btrfs]
[13729.886234]  ? kthread_create_on_node+0x70/0x70
[13729.886237]  ret_from_fork+0x35/0x40
[13729.886239] Code: 00 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8
73 23 ff ff 4c 89 ff e8 7b f5 fc ff e9 d9 fe ff ff b8 f4 ff ff ff e9
d9 fe ff ff <0f> ff eb b8 e8 53 e8 ba c0 0f 1f 00 0f 1f 44 00 00 55 48
89 e5
[13729.886284] ---[ end trace 2e6095c7c763f64b ]---



Anyone seen this before? Do I need to worry about my data?
This is a 6 device (LUKS encrypted) raid-1 pool with a little over 9 TB of data.


Any advice would be much appreciated.



Thanks,
Lukas
