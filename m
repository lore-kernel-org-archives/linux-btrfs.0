Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:37681 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbeCIX6B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Mar 2018 18:58:01 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 227065FDC3
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Mar 2018 23:58:00 +0000 (UTC)
Received: from mailgw-01.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id tlII9mmDXV4n for <linux-btrfs@vger.kernel.org>;
        Fri,  9 Mar 2018 23:57:58 +0000 (UTC)
Received: from heisenberg-old.fritz.box (ppp-82-135-88-141.dynamic.mnet-online.de [82.135.88.141])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-01.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Mar 2018 23:57:58 +0000 (UTC)
Message-ID: <1520639877.5641.46.camel@scientia.net>
Subject: call trace on btrfs send/receive
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sat, 10 Mar 2018 00:57:57 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey.

The following still happens with 4.15 kernel/progs:

btrfs send -p oldsnap newsnap | btrfs receive /some/other/fs

Mar 10 00:48:10 heisenberg kernel: WARNING: CPU: 5 PID: 32197 at /build/linux-PFKtCE/linux-4.15.4/fs/btrfs/send.c:6487 btrfs_ioctl_send+0x48f/0xfb0 [btrfs]
Mar 10 00:48:10 heisenberg kernel: Modules linked in: udp_diag tcp_diag inet_diag algif_skcipher af_alg uas vhost_net vhost tap xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat tun bridge stp llc ctr ccm fuse ebtable_filter ebtables devlink cpufreq_userspace cpufreq_powersave cpufreq_conservative ip6t_REJECT nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_policy ipt_REJECT nf_reject_ipv4 xt_comment nf_conntrack_ipv4 nf_defrag_ipv4 xt_multiport xt_conntrack nf_conntrack binfmt_misc iptable_filter joydev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic arc4 intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp btusb btrtl btbcm btintel kvm_intel iwldvm bluetooth kvm irqbypass rtsx_pci_sdmmc rtsx_pci_ms memstick mmc_core
Mar 10 00:48:10 heisenberg kernel:  mac80211 iTCO_wdt crct10dif_pclmul iTCO_vendor_support uvcvideo crc32_pclmul videobuf2_vmalloc videobuf2_memops ghash_clmulni_intel videobuf2_v4l2 drbg intel_cstate videobuf2_core iwlwifi ansi_cprng intel_uncore videodev ecdh_generic crc16 media intel_rapl_perf sg psmouse i915 i2c_i801 snd_hda_intel pcspkr cfg80211 rtsx_pci snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper fujitsu_laptop snd_pcm sparse_keymap drm video snd_timer ac button snd battery mei_me lpc_ich soundcore i2c_algo_bit mei mfd_core shpchp loop parport_pc ppdev sunrpc lp parport ip_tables x_tables autofs4 dm_crypt dm_mod raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx libcrc32c raid1 raid0 multipath linear md_mod btrfs crc32c_generic xor zstd_decompress zstd_compress xxhash raid6_pq
Mar 10 00:48:10 heisenberg kernel:  uhci_hcd sd_mod usb_storage crc32c_intel ahci libahci aesni_intel libata ehci_pci aes_x86_64 evdev xhci_pci crypto_simd cryptd glue_helper xhci_hcd ehci_hcd serio_raw scsi_mod e1000e ptp usbcore pps_core usb_common
Mar 10 00:48:10 heisenberg kernel: CPU: 5 PID: 32197 Comm: btrfs Not tainted 4.15.0-1-amd64 #1 Debian 4.15.4-1
Mar 10 00:48:10 heisenberg kernel: Hardware name: FUJITSU LIFEBOOK E782/FJNB253, BIOS Version 2.11 07/15/2014
Mar 10 00:48:10 heisenberg kernel: RIP: 0010:btrfs_ioctl_send+0x48f/0xfb0 [btrfs]
Mar 10 00:48:10 heisenberg kernel: RSP: 0018:ffffa4cc0a377c48 EFLAGS: 00010293
Mar 10 00:48:10 heisenberg kernel: RAX: 0000000000000000 RBX: ffff958718b1140c RCX: 0000000000000001
Mar 10 00:48:10 heisenberg kernel: RDX: 0000000000000001 RSI: 0000000000000015 RDI: ffff958718b1140c
Mar 10 00:48:10 heisenberg kernel: RBP: ffff9587617c1c00 R08: 0000000040000000 R09: 0000000000000060
Mar 10 00:48:10 heisenberg kernel: R10: 0000000000000015 R11: 0000000000000246 R12: ffff958718b11000
Mar 10 00:48:10 heisenberg kernel: R13: ffff9587b7cfdad0 R14: ffff95850d8d4000 R15: ffff958718b11000
Mar 10 00:48:10 heisenberg kernel: FS:  00007f5f0866a8c0(0000) GS:ffff95881e340000(0000) knlGS:0000000000000000
Mar 10 00:48:10 heisenberg kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 10 00:48:10 heisenberg kernel: CR2: 00007f5f073a4e38 CR3: 00000001e6b56004 CR4: 00000000001606e0
Mar 10 00:48:10 heisenberg kernel: Call Trace:
Mar 10 00:48:10 heisenberg kernel:  ? kmem_cache_alloc_trace+0x14b/0x1a0
Mar 10 00:48:10 heisenberg kernel:  ? insert_reserved_file_extent.constprop.69+0x2c1/0x2f0 [btrfs]
Mar 10 00:48:10 heisenberg kernel:  ? btrfs_opendir+0x3e/0x70 [btrfs]
Mar 10 00:48:10 heisenberg kernel:  ? _cond_resched+0x15/0x40
Mar 10 00:48:10 heisenberg kernel:  ? __kmalloc_track_caller+0x190/0x220
Mar 10 00:48:10 heisenberg kernel:  ? __check_object_size+0xaf/0x1b0
Mar 10 00:48:10 heisenberg kernel:  _btrfs_ioctl_send+0x80/0x110 [btrfs]
Mar 10 00:48:10 heisenberg kernel:  ? task_change_group_fair+0xb3/0x100
Mar 10 00:48:10 heisenberg kernel:  ? cpu_cgroup_fork+0x66/0x90
Mar 10 00:48:10 heisenberg kernel:  btrfs_ioctl+0xfab/0x2450 [btrfs]
Mar 10 00:48:10 heisenberg kernel:  ? enqueue_entity+0x106/0x6b0
Mar 10 00:48:10 heisenberg kernel:  ? enqueue_task_fair+0x67/0x7d0
Mar 10 00:48:10 heisenberg kernel:  ? do_vfs_ioctl+0xa4/0x630
Mar 10 00:48:10 heisenberg kernel:  do_vfs_ioctl+0xa4/0x630
Mar 10 00:48:10 heisenberg kernel:  ? _do_fork+0x14d/0x3f0
Mar 10 00:48:10 heisenberg kernel:  SyS_ioctl+0x74/0x80
Mar 10 00:48:10 heisenberg kernel:  do_syscall_64+0x6f/0x130
Mar 10 00:48:10 heisenberg kernel:  entry_SYSCALL_64_after_hwframe+0x21/0x86
Mar 10 00:48:10 heisenberg kernel: RIP: 0033:0x7f5f07493f07
Mar 10 00:48:10 heisenberg kernel: RSP: 002b:00007fff8a4619d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Mar 10 00:48:10 heisenberg kernel: RAX: ffffffffffffffda RBX: 000055b941872270 RCX: 00007f5f07493f07
Mar 10 00:48:10 heisenberg kernel: RDX: 00007fff8a461ab0 RSI: 0000000040489426 RDI: 0000000000000004
Mar 10 00:48:10 heisenberg kernel: RBP: 0000000000000001 R08: 0000000000000000 R09: 00007f5f073a5700
Mar 10 00:48:10 heisenberg kernel: R10: 00007f5f073a59d0 R11: 0000000000000246 R12: 0000000000000001
Mar 10 00:48:10 heisenberg kernel: R13: 0000000000000004 R14: 0000000000002db3 R15: 0000000000000001
Mar 10 00:48:10 heisenberg kernel: Code: ff 48 8b 83 e0 01 00 00 48 85 c0 0f 85 ce fd ff ff e9 0f fe ff ff 4c 89 e7 e8 fe 6d ff ff 48 c7 04 24 ff ff ff ff e9 06 ff ff ff <0f> ff e9 f1 fb ff ff 48 8b 45 08 c7 43 1c 00 00 01 00 ba ff ff 
Mar 10 00:48:10 heisenberg kernel: ---[ end trace 0c34308a4949ccc5 ]---


I've had both filesystems fscked (normal&lowmem) before with no errors,
the source fs I've had additionally effectively scrubbed (by reading in
all data on it, well at least all in the subvol I've sent/received) and
compared it to my own stored SHA512sums in XATTRS.


I think I'm having such a call trace more or less every time I do
send/receive... but the process exits with $?=0 and all data seems to
be fine afterwards.


Any ideas?


Thanks,
Chris.
