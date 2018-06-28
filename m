Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:39448 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965653AbeF1NTp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 09:19:45 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-02.dd24.net (Postfix) with ESMTP id A24415FB5B
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 13:19:43 +0000 (UTC)
Received: from mailgw-02.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id pHiYC20Bj_ec for <linux-btrfs@vger.kernel.org>;
        Thu, 28 Jun 2018 13:19:41 +0000 (UTC)
Received: from gar-nb-etp06.garching.physik.uni-muenchen.de (unknown [141.84.41.131])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-02.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 13:19:41 +0000 (UTC)
Message-ID: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
Subject: call trace: WARNING:  at
 /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Thu, 28 Jun 2018 15:19:40 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey.

On a 4.16.16 kernel with a RAID 1 btrfs I got the following messages
since today.

Data seems still to be readable (correctly)... and there are no other
errors (like SATA errors) in the kernel log.

Any idea what these could mean?

Thanks,
Chris.


[   72.168662] WARNING: CPU: 0 PID: 242 at /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device+0x1b2/0x1c0 [btrfs]
[   72.168701] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_conservative snd_hda_codec_hdmi ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_policy ipt_REJECT nf_reject_ipv4 xt_comment xt_tcpudp nf_conntrack_ipv4 powernow_k8 nf_defrag_ipv4 edac_mce_amd snd_hda_intel kvm_amd snd_hda_codec ccp rng_core snd_hda_core kvm snd_hwdep irqbypass snd_pcm wmi_bmof radeon snd_timer ttm xt_multiport snd pcspkr soundcore drm_kms_helper k8temp ohci_pci ata_generic pata_atiixp ohci_hcd ehci_pci sg wmi xt_conntrack drm nf_conntrack i2c_algo_bit ehci_hcd usbcore button sp5100_tco usb_common shpchp i2c_piix4 iptable_filter binfmt_misc sunrpc hwmon_vid ip_tables x_tables autofs4 btrfs zstd_decompress zstd_compress xxhash sd_mod raid10 raid456 async_raid6_recov
[   72.168776]  async_memcpy async_pq async_xor async_tx libcrc32c crc32c_generic xor raid6_pq raid1 raid0 multipath linear md_mod evdev ahci libahci serio_raw libata r8169 mii scsi_mod
[   72.168820] CPU: 0 PID: 242 Comm: btrfs-cleaner Not tainted 4.16.0-2-amd64 #1 Debian 4.16.16-2
[   72.168852] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7551/KA780G (MS-7551), BIOS V16.6 05/12/2010
[   72.168907] RIP: 0010:btrfs_update_device+0x1b2/0x1c0 [btrfs]
[   72.168939] RSP: 0018:ffffbd5a810a3d60 EFLAGS: 00010206
[   72.168973] RAX: 0000000000000fff RBX: ffff938e847f8000 RCX: 000000e8a0db1e00
[   72.169006] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff938e7a8015e0
[   72.169040] RBP: ffff938e8fb97a00 R08: ffffbd5a810a3d10 R09: ffffbd5a810a3d18
[   72.169073] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
[   72.169106] R13: 0000000000003f3c R14: ffff938e7a8015e0 R15: ffff938e8f0c6328
[   72.169140] FS:  0000000000000000(0000) GS:ffff938e9dc00000(0000) knlGS:0000000000000000
[   72.169177] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.169210] CR2: 00007fcff92ce000 CR3: 000000020575e000 CR4: 00000000000006f0
[   72.169243] Call Trace:
[   72.169304]  btrfs_remove_chunk+0x2a9/0x8c0 [btrfs]
[   72.169359]  btrfs_delete_unused_bgs+0x323/0x3f0 [btrfs]
[   72.169415]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[   72.169469]  cleaner_kthread+0x152/0x160 [btrfs]
[   72.169506]  kthread+0x113/0x130
[   72.169540]  ? kthread_create_worker_on_cpu+0x70/0x70
[   72.169575]  ? SyS_exit_group+0x10/0x10
[   72.169610]  ret_from_fork+0x35/0x40
[   72.169643] Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 16 23 ff ff 4c 89 f7 e8 9e ef fc ff e9 de fe ff ff 41 bc f4 ff ff ff e9 db fe ff ff <0f> 0b eb b7 e8 85 4c 1a c5 0f 1f 44 00 00 66 66 66 66 90 41 55 
[   72.169705] ---[ end trace ed549af9d9cf6190 ]---
[   72.170009] WARNING: CPU: 0 PID: 242 at /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device+0x1b2/0x1c0 [btrfs]
[   72.170050] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_conservative snd_hda_codec_hdmi ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_policy ipt_REJECT nf_reject_ipv4 xt_comment xt_tcpudp nf_conntrack_ipv4 powernow_k8 nf_defrag_ipv4 edac_mce_amd snd_hda_intel kvm_amd snd_hda_codec ccp rng_core snd_hda_core kvm snd_hwdep irqbypass snd_pcm wmi_bmof radeon snd_timer ttm xt_multiport snd pcspkr soundcore drm_kms_helper k8temp ohci_pci ata_generic pata_atiixp ohci_hcd ehci_pci sg wmi xt_conntrack drm nf_conntrack i2c_algo_bit ehci_hcd usbcore button sp5100_tco usb_common shpchp i2c_piix4 iptable_filter binfmt_misc sunrpc hwmon_vid ip_tables x_tables autofs4 btrfs zstd_decompress zstd_compress xxhash sd_mod raid10 raid456 async_raid6_recov
[   72.170152]  async_memcpy async_pq async_xor async_tx libcrc32c crc32c_generic xor raid6_pq raid1 raid0 multipath linear md_mod evdev ahci libahci serio_raw libata r8169 mii scsi_mod
[   72.170204] CPU: 0 PID: 242 Comm: btrfs-cleaner Tainted: G        W        4.16.0-2-amd64 #1 Debian 4.16.16-2
[   72.170241] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7551/KA780G (MS-7551), BIOS V16.6 05/12/2010
[   72.170300] RIP: 0010:btrfs_update_device+0x1b2/0x1c0 [btrfs]
[   72.170333] RSP: 0018:ffffbd5a810a3d60 EFLAGS: 00010206
[   72.170367] RAX: 0000000000000fff RBX: ffff938e847f8000 RCX: 000000e8a0db1e00
[   72.170401] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff938e7a8015e0
[   72.170434] RBP: ffff938e8fb97a00 R08: ffffbd5a810a3d10 R09: ffffbd5a810a3d18
[   72.170468] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
[   72.170501] R13: 0000000000003f3c R14: ffff938e7a8015e0 R15: ffff938e8f0c6328
[   72.170535] FS:  0000000000000000(0000) GS:ffff938e9dc00000(0000) knlGS:0000000000000000
[   72.170571] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.170604] CR2: 00007fcff92ce000 CR3: 000000020575e000 CR4: 00000000000006f0
[   72.170638] Call Trace:
[   72.170696]  btrfs_remove_chunk+0x2a9/0x8c0 [btrfs]
[   72.170751]  btrfs_delete_unused_bgs+0x323/0x3f0 [btrfs]
[   72.170806]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[   72.170861]  cleaner_kthread+0x152/0x160 [btrfs]
[   72.170897]  kthread+0x113/0x130
[   72.170930]  ? kthread_create_worker_on_cpu+0x70/0x70
[   72.170966]  ? SyS_exit_group+0x10/0x10
[   72.171000]  ret_from_fork+0x35/0x40
[   72.171033] Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 16 23 ff ff 4c 89 f7 e8 9e ef fc ff e9 de fe ff ff 41 bc f4 ff ff ff e9 db fe ff ff <0f> 0b eb b7 e8 85 4c 1a c5 0f 1f 44 00 00 66 66 66 66 90 41 55 
[   72.171097] ---[ end trace ed549af9d9cf6191 ]---
[  967.276408] WARNING: CPU: 0 PID: 242 at /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device+0x1b2/0x1c0 [btrfs]
[  967.276452] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_conservative snd_hda_codec_hdmi ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_policy ipt_REJECT nf_reject_ipv4 xt_comment xt_tcpudp nf_conntrack_ipv4 powernow_k8 nf_defrag_ipv4 edac_mce_amd snd_hda_intel kvm_amd snd_hda_codec ccp rng_core snd_hda_core kvm snd_hwdep irqbypass snd_pcm wmi_bmof radeon snd_timer ttm xt_multiport snd pcspkr soundcore drm_kms_helper k8temp ohci_pci ata_generic pata_atiixp ohci_hcd ehci_pci sg wmi xt_conntrack drm nf_conntrack i2c_algo_bit ehci_hcd usbcore button sp5100_tco usb_common shpchp i2c_piix4 iptable_filter binfmt_misc sunrpc hwmon_vid ip_tables x_tables autofs4 btrfs zstd_decompress zstd_compress xxhash sd_mod raid10 raid456 async_raid6_recov
[  967.276554]  async_memcpy async_pq async_xor async_tx libcrc32c crc32c_generic xor raid6_pq raid1 raid0 multipath linear md_mod evdev ahci libahci serio_raw libata r8169 mii scsi_mod
[  967.276606] CPU: 0 PID: 242 Comm: btrfs-cleaner Tainted: G        W        4.16.0-2-amd64 #1 Debian 4.16.16-2
[  967.276642] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7551/KA780G (MS-7551), BIOS V16.6 05/12/2010
[  967.276703] RIP: 0010:btrfs_update_device+0x1b2/0x1c0 [btrfs]
[  967.276737] RSP: 0018:ffffbd5a810a3d60 EFLAGS: 00010206
[  967.276771] RAX: 0000000000000fff RBX: ffff938de01509a0 RCX: 000000e8a0db1e00
[  967.276804] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff938e177fc7a8
[  967.276838] RBP: ffff938e8fb97a00 R08: ffffbd5a810a3d10 R09: ffffbd5a810a3d18
[  967.276872] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
[  967.276906] R13: 0000000000003f3c R14: ffff938e177fc7a8 R15: ffff938e8f0c6328
[  967.276940] FS:  0000000000000000(0000) GS:ffff938e9dc00000(0000) knlGS:0000000000000000
[  967.276976] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  967.277010] CR2: 0000563538320878 CR3: 00000002114dc000 CR4: 00000000000006f0
[  967.277044] Call Trace:
[  967.277104]  btrfs_remove_chunk+0x2a9/0x8c0 [btrfs]
[  967.277161]  btrfs_delete_unused_bgs+0x323/0x3f0 [btrfs]
[  967.277217]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[  967.277272]  cleaner_kthread+0x152/0x160 [btrfs]
[  967.277310]  kthread+0x113/0x130
[  967.277344]  ? kthread_create_worker_on_cpu+0x70/0x70
[  967.277379]  ? SyS_exit_group+0x10/0x10
[  967.277414]  ret_from_fork+0x35/0x40
[  967.277447] Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 16 23 ff ff 4c 89 f7 e8 9e ef fc ff e9 de fe ff ff 41 bc f4 ff ff ff e9 db fe ff ff <0f> 0b eb b7 e8 85 4c 1a c5 0f 1f 44 00 00 66 66 66 66 90 41 55 
[  967.277510] ---[ end trace ed549af9d9cf6192 ]---
[  967.277747] WARNING: CPU: 0 PID: 242 at /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device+0x1b2/0x1c0 [btrfs]
[  967.277786] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_conservative snd_hda_codec_hdmi ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_policy ipt_REJECT nf_reject_ipv4 xt_comment xt_tcpudp nf_conntrack_ipv4 powernow_k8 nf_defrag_ipv4 edac_mce_amd snd_hda_intel kvm_amd snd_hda_codec ccp rng_core snd_hda_core kvm snd_hwdep irqbypass snd_pcm wmi_bmof radeon snd_timer ttm xt_multiport snd pcspkr soundcore drm_kms_helper k8temp ohci_pci ata_generic pata_atiixp ohci_hcd ehci_pci sg wmi xt_conntrack drm nf_conntrack i2c_algo_bit ehci_hcd usbcore button sp5100_tco usb_common shpchp i2c_piix4 iptable_filter binfmt_misc sunrpc hwmon_vid ip_tables x_tables autofs4 btrfs zstd_decompress zstd_compress xxhash sd_mod raid10 raid456 async_raid6_recov
[  967.277886]  async_memcpy async_pq async_xor async_tx libcrc32c crc32c_generic xor raid6_pq raid1 raid0 multipath linear md_mod evdev ahci libahci serio_raw libata r8169 mii scsi_mod
[  967.277936] CPU: 0 PID: 242 Comm: btrfs-cleaner Tainted: G        W        4.16.0-2-amd64 #1 Debian 4.16.16-2
[  967.277972] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7551/KA780G (MS-7551), BIOS V16.6 05/12/2010
[  967.278033] RIP: 0010:btrfs_update_device+0x1b2/0x1c0 [btrfs]
[  967.278066] RSP: 0018:ffffbd5a810a3d60 EFLAGS: 00010206
[  967.278100] RAX: 0000000000000fff RBX: ffff938de01509a0 RCX: 000000e8a0db1e00
[  967.278134] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff938e177fc7a8
[  967.278168] RBP: ffff938e8fb97a00 R08: ffffbd5a810a3d10 R09: ffffbd5a810a3d18
[  967.278202] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
[  967.278236] R13: 0000000000003f3c R14: ffff938e177fc7a8 R15: ffff938e8f0c6328
[  967.278270] FS:  0000000000000000(0000) GS:ffff938e9dc00000(0000) knlGS:0000000000000000
[  967.278307] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  967.278340] CR2: 0000563538320878 CR3: 00000002114dc000 CR4: 00000000000006f0
[  967.278374] Call Trace:
[  967.278432]  btrfs_remove_chunk+0x2a9/0x8c0 [btrfs]
[  967.278489]  btrfs_delete_unused_bgs+0x323/0x3f0 [btrfs]
[  967.278545]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[  967.278600]  cleaner_kthread+0x152/0x160 [btrfs]
[  967.278635]  kthread+0x113/0x130
[  967.278669]  ? kthread_create_worker_on_cpu+0x70/0x70
[  967.278703]  ? SyS_exit_group+0x10/0x10
[  967.278738]  ret_from_fork+0x35/0x40
[  967.278771] Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 16 23 ff ff 4c 89 f7 e8 9e ef fc ff e9 de fe ff ff 41 bc f4 ff ff ff e9 db fe ff ff <0f> 0b eb b7 e8 85 4c 1a c5 0f 1f 44 00 00 66 66 66 66 90 41 55 
[  967.278836] ---[ end trace ed549af9d9cf6193 ]---
[  967.279036] WARNING: CPU: 0 PID: 242 at /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device+0x1b2/0x1c0 [btrfs]
[  967.279074] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_conservative snd_hda_codec_hdmi ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_policy ipt_REJECT nf_reject_ipv4 xt_comment xt_tcpudp nf_conntrack_ipv4 powernow_k8 nf_defrag_ipv4 edac_mce_amd snd_hda_intel kvm_amd snd_hda_codec ccp rng_core snd_hda_core kvm snd_hwdep irqbypass snd_pcm wmi_bmof radeon snd_timer ttm xt_multiport snd pcspkr soundcore drm_kms_helper k8temp ohci_pci ata_generic pata_atiixp ohci_hcd ehci_pci sg wmi xt_conntrack drm nf_conntrack i2c_algo_bit ehci_hcd usbcore button sp5100_tco usb_common shpchp i2c_piix4 iptable_filter binfmt_misc sunrpc hwmon_vid ip_tables x_tables autofs4 btrfs zstd_decompress zstd_compress xxhash sd_mod raid10 raid456 async_raid6_recov
[  967.279175]  async_memcpy async_pq async_xor async_tx libcrc32c crc32c_generic xor raid6_pq raid1 raid0 multipath linear md_mod evdev ahci libahci serio_raw libata r8169 mii scsi_mod
[  967.279224] CPU: 0 PID: 242 Comm: btrfs-cleaner Tainted: G        W        4.16.0-2-amd64 #1 Debian 4.16.16-2
[  967.279261] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7551/KA780G (MS-7551), BIOS V16.6 05/12/2010
[  967.279321] RIP: 0010:btrfs_update_device+0x1b2/0x1c0 [btrfs]
[  967.279355] RSP: 0018:ffffbd5a810a3d60 EFLAGS: 00010206
[  967.279388] RAX: 0000000000000fff RBX: ffff938de01509a0 RCX: 000000e8a0db1e00
[  967.279422] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff938e177fc7a8
[  967.279456] RBP: ffff938e8fb97a00 R08: ffffbd5a810a3d10 R09: ffffbd5a810a3d18
[  967.280145] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
[  967.280169] R13: 0000000000003f3c R14: ffff938e177fc7a8 R15: ffff938e8f0c6328
[  967.280169] FS:  0000000000000000(0000) GS:ffff938e9dc00000(0000) knlGS:0000000000000000
[  967.280169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  967.280169] CR2: 0000563538320878 CR3: 00000002114dc000 CR4: 00000000000006f0
[  967.280169] Call Trace:
[  967.280169]  btrfs_remove_chunk+0x2a9/0x8c0 [btrfs]
[  967.280169]  btrfs_delete_unused_bgs+0x323/0x3f0 [btrfs]
[  967.280169]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[  967.280169]  cleaner_kthread+0x152/0x160 [btrfs]
[  967.280169]  kthread+0x113/0x130
[  967.280169]  ? kthread_create_worker_on_cpu+0x70/0x70
[  967.280169]  ? SyS_exit_group+0x10/0x10
[  967.280169]  ret_from_fork+0x35/0x40
[  967.280169] Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 16 23 ff ff 4c 89 f7 e8 9e ef fc ff e9 de fe ff ff 41 bc f4 ff ff ff e9 db fe ff ff <0f> 0b eb b7 e8 85 4c 1a c5 0f 1f 44 00 00 66 66 66 66 90 41 55 
[  967.280169] ---[ end trace ed549af9d9cf6194 ]---
[ 1516.410609] WARNING: CPU: 1 PID: 242 at /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device+0x1b2/0x1c0 [btrfs]
[ 1516.410647] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_conservative snd_hda_codec_hdmi ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_policy ipt_REJECT nf_reject_ipv4 xt_comment xt_tcpudp nf_conntrack_ipv4 powernow_k8 nf_defrag_ipv4 edac_mce_amd snd_hda_intel kvm_amd snd_hda_codec ccp rng_core snd_hda_core kvm snd_hwdep irqbypass snd_pcm wmi_bmof radeon snd_timer ttm xt_multiport snd pcspkr soundcore drm_kms_helper k8temp ohci_pci ata_generic pata_atiixp ohci_hcd ehci_pci sg wmi xt_conntrack drm nf_conntrack i2c_algo_bit ehci_hcd usbcore button sp5100_tco usb_common shpchp i2c_piix4 iptable_filter binfmt_misc sunrpc hwmon_vid ip_tables x_tables autofs4 btrfs zstd_decompress zstd_compress xxhash sd_mod raid10 raid456 async_raid6_recov
[ 1516.410757]  async_memcpy async_pq async_xor async_tx libcrc32c crc32c_generic xor raid6_pq raid1 raid0 multipath linear md_mod evdev ahci libahci serio_raw libata r8169 mii scsi_mod
[ 1516.410826] CPU: 1 PID: 242 Comm: btrfs-cleaner Tainted: G        W        4.16.0-2-amd64 #1 Debian 4.16.16-2
[ 1516.410861] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7551/KA780G (MS-7551), BIOS V16.6 05/12/2010
[ 1516.410941] RIP: 0010:btrfs_update_device+0x1b2/0x1c0 [btrfs]
[ 1516.410975] RSP: 0018:ffffbd5a810a3d60 EFLAGS: 00010206
[ 1516.411008] RAX: 0000000000000fff RBX: ffff938dbbafd380 RCX: 000000e8a0db1e00
[ 1516.411043] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff938e30d156f8
[ 1516.411076] RBP: ffff938e8fb97a00 R08: ffffbd5a810a3d10 R09: ffffbd5a810a3d18
[ 1516.411110] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
[ 1516.411144] R13: 0000000000003f3c R14: ffff938e30d156f8 R15: ffff938e8f0c6328
[ 1516.411178] FS:  0000000000000000(0000) GS:ffff938e9dc40000(0000) knlGS:0000000000000000
[ 1516.411214] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1516.411247] CR2: 00007f2041f7c018 CR3: 00000002114dc000 CR4: 00000000000006e0
[ 1516.411280] Call Trace:
[ 1516.411340]  btrfs_remove_chunk+0x2a9/0x8c0 [btrfs]
[ 1516.411396]  btrfs_delete_unused_bgs+0x323/0x3f0 [btrfs]
[ 1516.411451]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[ 1516.411505]  cleaner_kthread+0x152/0x160 [btrfs]
[ 1516.411542]  kthread+0x113/0x130
[ 1516.411576]  ? kthread_create_worker_on_cpu+0x70/0x70
[ 1516.411611]  ? SyS_exit_group+0x10/0x10
[ 1516.411646]  ret_from_fork+0x35/0x40
[ 1516.411679] Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 16 23 ff ff 4c 89 f7 e8 9e ef fc ff e9 de fe ff ff 41 bc f4 ff ff ff e9 db fe ff ff <0f> 0b eb b7 e8 85 4c 1a c5 0f 1f 44 00 00 66 66 66 66 90 41 55 
[ 1516.411742] ---[ end trace ed549af9d9cf6195 ]---
