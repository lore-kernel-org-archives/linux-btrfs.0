Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:53168 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdJSIQj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 04:16:39 -0400
Received: by mail-wm0-f43.google.com with SMTP id k4so14639338wmc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 01:16:39 -0700 (PDT)
To: 1i5t5.duncan@cox.net, linux-btrfs@vger.kernel.org
References: <pan$7012a$2aa3b3f4$9c2bb50d$e909647e@cox.net>
Subject: Re: 4.13: "error in btrfs_run_delayed_refs:3009: errno=-28 No space
 left" with 1.3TB unallocated / 737G free?
From: Vladimir Panteleev <thecybershadow@gmail.com>
Message-ID: <0caa6041-8ba6-52f6-950e-f07ee0470b63@gmail.com>
Date: Thu, 19 Oct 2017 08:16:35 +0000
MIME-Version: 1.0
In-Reply-To: <pan$7012a$2aa3b3f4$9c2bb50d$e909647e@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 17 Oct 2017 16:21:04 -0700, Duncan wrote:
> * try the balance on 4.14-rc5+, where the known bug should be fixed

Thanks! However, I'm getting the same error on 4.14.0-rc5-g9aa0d2dde6eb. 
The stack trace is different, though:

[25886.024757] BTRFS: Transaction aborted (error -28)
[25886.024793] ------------[ cut here ]------------
[25886.024807] WARNING: CPU: 3 PID: 1904 at fs/btrfs/extent-tree.c:7062 
__btrfs_free_extent.isra.24+0xc23/0xda0 [btrfs]
[25886.024808] Modules linked in: ctr fuse xt_nat vhost_net vhost tap 
xt_CHECKSUM iptable_mangle xt_conntrack ipt_REJECT nf_reject_ipv4 
xt_tcpudp ebtable_filter ebtables ip6table_filter ip6_tables 
iptable_filter devlink tun nls_utf8 cifs ccm dns_resolver fscache uinput 
it87 hwmon_vid ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
libcrc32c crc32c_generic sit tunnel4 ip_tunnel snd_hda_codec_hdmi 8021q 
mrp snd_hda_codec_realtek snd_hda_codec_generic iTCO_wdt 
iTCO_vendor_support nls_iso8859_1 nls_cp437 mxm_wmi vfat fat 
nvidia_drm(PO) intel_rapl nvidia_modeset(PO) x86_pkg_temp_thermal 
intel_powerclamp nvidia(PO) coretemp kvm_intel kvm irqbypass 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc arc4 aesni_intel 
aes_x86_64 ath9k crypto_simd
[25886.024830]  glue_helper cryptd ath9k_common ath9k_hw intel_cstate 
ath3k ath intel_rapl_perf btusb snd_hda_intel btrtl btbcm pl2303 btintel 
drm_kms_helper uvcvideo snd_usb_audio snd_hda_codec videobuf2_vmalloc 
snd_usbmidi_lib mac80211 bluetooth videobuf2_memops snd_rawmidi 
videobuf2_v4l2 ecdh_generic usbserial crc16 i2c_i801 lpc_ich cdc_acm 
snd_seq_device snd_hda_core videobuf2_core drm e1000e cfg80211 snd_hwdep 
snd_pcm syscopyarea r8169 sysfillrect snd_timer videodev sysimgblt mii 
rfkill mei_me ptp fb_sys_fops snd mousedev input_leds joydev evdev 
ioatdma led_class mac_hid media soundcore mei pps_core dca shpchp wmi 
bridge tpm_infineon tpm_tis tpm_tis_core stp llc tpm button sch_fq_codel 
sg ip_tables x_tables sr_mod cdrom btrfs xor zstd_decompress 
zstd_compress xxhash raid6_pq sd_mod hid_generic
[25886.024855]  hid_dr ff_memless usbhid hid crc32c_intel isci xhci_pci 
ahci libsas ehci_pci xhci_hcd scsi_transport_sas libahci ehci_hcd 
usbcore libata usb_common scsi_mod serio
[25886.024863] CPU: 3 PID: 1904 Comm: btrfs-transacti Tainted: P 
   O    4.14.0-rc5-g9aa0d2dde6eb #2
[25886.024864] Hardware name: Gigabyte Technology Co., Ltd. To be filled 
by O.E.M./X79S-UP5, BIOS F5f 03/19/2014
[25886.024865] task: ffff880eb8f1d880 task.stack: ffffc9000c81c000
[25886.024871] RIP: 0010:__btrfs_free_extent.isra.24+0xc23/0xda0 [btrfs]
[25886.024871] RSP: 0018:ffffc9000c81fc28 EFLAGS: 00010282
[25886.024873] RAX: 0000000000000026 RBX: 00000854ddb40000 RCX: 
0000000000000000
[25886.024873] RDX: 0000000000000000 RSI: ffff880fff2cdc48 RDI: 
ffff880fff2cdc48
[25886.024874] RBP: ffffc9000c81fcd0 R08: 0000000000000613 R09: 
0000000000000007
[25886.024875] R10: 0000000000001000 R11: 0000000000000001 R12: 
ffff880ec87c6000
[25886.024876] R13: 00000000ffffffe4 R14: 0000000000000000 R15: 
ffff880ff4f4a690
[25886.024877] FS:  0000000000000000(0000) GS:ffff880fff2c0000(0000) 
knlGS:0000000000000000
[25886.024878] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25886.024879] CR2: 00007f1c6cb9c0d0 CR3: 0000000002c09003 CR4: 
00000000001606e0
[25886.024880] Call Trace:
[25886.024887]  ? btrfs_previous_extent_item+0xe1/0x110 [btrfs]
[25886.024895]  ? btrfs_merge_delayed_refs+0x8c/0x550 [btrfs]
[25886.024901]  __btrfs_run_delayed_refs+0x6ee/0x12f0 [btrfs]
[25886.024909]  btrfs_run_delayed_refs+0x6b/0x250 [btrfs]
[25886.024916]  btrfs_commit_transaction+0x48/0x920 [btrfs]
[25886.024922]  ? start_transaction+0x99/0x420 [btrfs]
[25886.024929]  transaction_kthread+0x182/0x1b0 [btrfs]
[25886.024932]  kthread+0x125/0x140
[25886.024939]  ? btrfs_cleanup_transaction+0x520/0x520 [btrfs]
[25886.024940]  ? kthread_create_on_node+0x70/0x70
[25886.024942]  ret_from_fork+0x25/0x30
[25886.024944] Code: d7 e0 0f ff eb d0 44 89 ee 48 c7 c7 68 b7 40 a0 e8 
c4 8d d7 e0 0f ff e9 7c fb ff ff 44 89 ee 48 c7 c7 68 b7 40 a0 e8 ae 8d 
d7 e0 <0f> ff e9 00 f5 ff ff 8b 55 20 48 89 c1 49 89 d8 48 c7 c6 48 b8
[25886.024961] ---[ end trace 3570a54b286cb501 ]---
[25886.024966] BTRFS: error (device sda1) in __btrfs_free_extent:7062: 
errno=-28 No space left
[25886.024968] BTRFS info (device sda1): forced readonly
[25886.024969] BTRFS: error (device sda1) in 
btrfs_run_delayed_refs:3089: errno=-28 No space left

Aside from rebuilding the filesystem, what are my options? Should I try 
to temporarily add a file from another volume as a device and retry the 
balance? If so, what would be a good size for the temporary device?

-- 
Best regards,
  Vladimir
