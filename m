Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:46893 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751217AbeBUEQg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 23:16:36 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 3BDEA5FE95
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Feb 2018 04:09:11 +0000 (UTC)
Received: from mailgw-02.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id ZErXW_QwMA2C for <linux-btrfs@vger.kernel.org>;
        Wed, 21 Feb 2018 04:09:09 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-88-141.dynamic.mnet-online.de [82.135.88.141])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-02.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Feb 2018 04:09:09 +0000 (UTC)
Message-ID: <1519186148.24817.1.camel@scientia.net>
Subject: BUG: unable to handle kernel paging request at ffff9fb75f827100
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 21 Feb 2018 05:09:08 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

Not sure if that's a bug in btrfs... maybe someone's interested in it.

Cheers,
Chris.

# uname -a
Linux heisenberg 4.14.0-3-amd64 #1 SMP Debian 4.14.17-1 (2018-02-14) x86_64 GNU/Linux


Feb 21 04:55:51 heisenberg kernel: BUG: unable to handle kernel paging request at ffff9fb75f827100
Feb 21 04:55:51 heisenberg kernel: IP: btrfs_drop_inode+0x16/0x40 [btrfs]
Feb 21 04:55:51 heisenberg kernel: PGD 410806067 P4D 410806067 PUD 0 
Feb 21 04:55:51 heisenberg kernel: Oops: 0000 [#1] SMP PTI
Feb 21 04:55:51 heisenberg kernel: Modules linked in: vhost_net vhost tap xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat tun bridge stp llc ctr ccm fuse ebtable_filter ebtables devlink cpufreq_userspace cpufreq_powersave cpufreq_conservative ip6t_REJECT nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_policy ipt_REJECT nf_reject_ipv4 xt_comment nf_conntrack_ipv4 nf_defrag_ipv4 xt_multiport xt_conntrack nf_conntrack iptable_filter binfmt_misc arc4 snd_hda_codec_hdmi btusb btrtl btbcm btintel bluetooth snd_hda_codec_realtek snd_hda_codec_generic drbg uvcvideo videobuf2_vmalloc videobuf2_memops snd_soc_skl snd_usb_audio ansi_cprng snd_soc_skl_ipc cdc_mbim cdc_wdm snd_usbmidi_lib snd_soc_sst_ipc cdc_ncm snd_soc_sst_dsp snd_rawmidi ecdh_generic
Feb 21 04:55:51 heisenberg kernel:  videobuf2_v4l2 i2c_designware_platform iwlmvm snd_hda_ext_core videobuf2_core usbnet i2c_designware_core snd_seq_device snd_soc_sst_match mii snd_soc_core videodev snd_compress media mac80211 intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass intel_cstate snd_hda_intel intel_uncore iwlwifi snd_hda_codec intel_rapl_perf snd_hda_core snd_hwdep snd_pcm pcspkr joydev evdev cfg80211 serio_raw snd_timer rfkill snd iTCO_wdt sg soundcore iTCO_vendor_support i915 wmi shpchp drm_kms_helper mei_me battery fujitsu_laptop mei tpm_crb idma64 button drm sparse_keymap video i2c_algo_bit ac acpi_pad intel_lpss_pci intel_lpss mfd_core loop parport_pc ppdev sunrpc lp parport ip_tables x_tables autofs4 algif_skcipher af_alg ext4 crc16 mbcache jbd2 fscrypto ecb hid_generic
Feb 21 04:55:51 heisenberg kernel:  usbhid hid dm_crypt dm_mod raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx libcrc32c raid1 raid0 multipath linear md_mod btrfs crc32c_generic xor zstd_decompress zstd_compress xxhash uas raid6_pq uhci_hcd ehci_pci ehci_hcd usb_storage sd_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd e1000e xhci_pci ahci ptp libahci xhci_hcd psmouse pps_core libata sdhci_pci sdhci i2c_i801 scsi_mod mmc_core usbcore usb_common
Feb 21 04:55:51 heisenberg kernel: CPU: 3 PID: 50 Comm: kswapd0 Not tainted 4.14.0-3-amd64 #1 Debian 4.14.17-1
Feb 21 04:55:51 heisenberg kernel: Hardware name: FUJITSU LIFEBOOK U757/FJNB2A5, BIOS Version 1.16 07/05/2017
Feb 21 04:55:51 heisenberg kernel: task: ffff9fbff9523040 task.stack: ffffad5e83780000
Feb 21 04:55:51 heisenberg kernel: RIP: 0010:btrfs_drop_inode+0x16/0x40 [btrfs]
Feb 21 04:55:51 heisenberg kernel: RSP: 0018:ffffad5e83783c28 EFLAGS: 00010286
Feb 21 04:55:51 heisenberg kernel: RAX: 0000000000000001 RBX: ffff9fbe05d69330 RCX: 0000000000000000
Feb 21 04:55:51 heisenberg kernel: RDX: ffff9fb75f827000 RSI: ffffffffc075f2b0 RDI: ffff9fbe05d69330
Feb 21 04:55:51 heisenberg kernel: RBP: ffff9fbff2040800 R08: ffff9fbff1ddea08 R09: ffffad5e83783d88
Feb 21 04:55:51 heisenberg kernel: R10: 00000000001bf318 R11: 00000000ffffffff R12: ffff9fbe05d693b8
Feb 21 04:55:51 heisenberg kernel: R13: ffff9fbe05d69488 R14: ffff9fbfc26cecc0 R15: 0000000000000000
Feb 21 04:55:51 heisenberg kernel: FS:  0000000000000000(0000) GS:ffff9fc01dd80000(0000) knlGS:0000000000000000
Feb 21 04:55:51 heisenberg kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb 21 04:55:51 heisenberg kernel: CR2: ffff9fb75f827100 CR3: 000000041020a004 CR4: 00000000003606e0
Feb 21 04:55:51 heisenberg kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 21 04:55:51 heisenberg kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Feb 21 04:55:51 heisenberg kernel: Call Trace:
Feb 21 04:55:51 heisenberg kernel:  iput+0xf7/0x210
Feb 21 04:55:51 heisenberg kernel:  __dentry_kill+0xce/0x160
Feb 21 04:55:51 heisenberg kernel:  shrink_dentry_list+0xe0/0x2d0
Feb 21 04:55:51 heisenberg kernel:  prune_dcache_sb+0x52/0x70
Feb 21 04:55:51 heisenberg kernel:  super_cache_scan+0xf7/0x1a0
Feb 21 04:55:51 heisenberg kernel:  shrink_slab.part.49+0x1e8/0x3e0
Feb 21 04:55:51 heisenberg kernel:  shrink_node+0x123/0x300
Feb 21 04:55:51 heisenberg kernel:  kswapd+0x299/0x6f0
Feb 21 04:55:51 heisenberg kernel:  ? mem_cgroup_shrink_node+0x190/0x190
Feb 21 04:55:51 heisenberg kernel:  kthread+0x11a/0x130
Feb 21 04:55:51 heisenberg kernel:  ? kthread_create_on_node+0x70/0x70
Feb 21 04:55:51 heisenberg kernel:  ret_from_fork+0x35/0x40
Feb 21 04:55:51 heisenberg kernel: Code: 83 bd 60 ff ff ff 00 0f 84 fa fd ff ff 0f ff e9 f3 fd ff ff 90 0f 1f 44 00 00 48 8b 97 10 fe ff ff b8 01 00 00 00 48 85 d2 74 1e <8b> 8a 00 01 00 00 85 c9 74 14 8b 57 48 85 d2 74 0d 31 c0 48 83 
Feb 21 04:55:51 heisenberg kernel: RIP: btrfs_drop_inode+0x16/0x40 [btrfs] RSP: ffffad5e83783c28
Feb 21 04:55:51 heisenberg kernel: CR2: ffff9fb75f827100
Feb 21 04:55:51 heisenberg kernel: ---[ end trace 03e4e7dde4debf59 ]---
