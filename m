Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:38023 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753138AbeB1Qns (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 11:43:48 -0500
Received: by mail-qt0-f172.google.com with SMTP id n12so3752417qtl.5
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 08:43:48 -0800 (PST)
Received: from desktop (ip-72-2-52-196.nyc.us.northamericancoax.com. [196.52.2.72])
        by smtp.gmail.com with ESMTPSA id u5sm1256788qkh.36.2018.02.28.08.43.45
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Feb 2018 08:43:46 -0800 (PST)
Message-ID: <1519836220.1693.23.camel@gmail.com>
Subject: [Bug report] BTRFS partition re-mounted as read-only after few
 minutes of use
From: peteryuchuang@gmail.com
To: linux-btrfs@vger.kernel.org
Date: Wed, 28 Feb 2018 17:43:40 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On my laptop, which has just been switched to BTRFS, the root partition
(a BTRFS partition inside an encrypted LVM. The drive is an NVMe) is
re-mounted as read-only few minutes after boot. 

Trace:

[  199.974591] ------------[ cut here ]------------
[  199.974593] BTRFS: Transaction aborted (error -95)
[  199.974647] WARNING: CPU: 0 PID: 324 at fs/btrfs/inode.c:3042
btrfs_finish_ordered_io+0x7ab/0x850 [btrfs]
[  199.974648] Modules linked in: tun fuse cmac rfcomm bnep
snd_hda_codec_hdmi ip6t_REJECT snd_hda_codec_generic nf_reject_ipv6
nf_log_ipv6 xt_hl nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_rt ipt_REJECT
nf_reject_ipv4 nf_log_ipv4 nf_log_common xt_LOG xt_limit xt_tcpudp
nls_iso8859_1 nls_cp437 vfat fat nf_conntrack_ipv4 nf_defrag_ipv4
xt_addrtype xt_conntrack snd_soc_skl snd_soc_skl_ipc snd_hda_ext_core
snd_soc_sst_dsp snd_soc_sst_ipc snd_soc_acpi brcmfmac snd_soc_core
ip6table_filter ip6_tables brcmutil nf_conntrack_netbios_ns
snd_compress nf_conntrack_broadcast nf_nat_ftp ac97_bus cfg80211
snd_pcm_dmaengine nf_nat nf_conntrack_ftp nf_conntrack libcrc32c
crc32c_generic thunderbolt iptable_filter iTCO_wdt mmc_core
iTCO_vendor_support crypto_user msr intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp
[  199.974675]  kvm_intel snd_hda_intel snd_hda_codec kvm snd_hda_core
applesmc snd_hwdep input_polldev irqbypass snd_pcm intel_cstate
snd_timer intel_uncore intel_rapl_perf pcspkr i915 snd i2c_i801
soundcore joydev mousedev input_leds i2c_algo_bit drm_kms_helper
hci_uart btbcm btqca btintel drm bluetooth mei_me 8250_dw intel_gtt mei
agpgart acpi_als shpchp syscopyarea idma64 sysfillrect sbs sysimgblt
fb_sys_fops ecdh_generic rfkill kfifo_buf sbshc industrialio rtc_cmos
evdev mac_hid ac apple_bl facetimehd(O) videobuf2_dma_sg
videobuf2_memops videobuf2_v4l2 videobuf2_core videodev media ip_tables
x_tables btrfs xor zstd_decompress zstd_compress xxhash raid6_pq
dm_crypt algif_skcipher af_alg dm_mod crct10dif_pclmul crc32_pclmul
crc32c_intel ghash_clmulni_intel pcbc aesni_intel aes_x86_64
crypto_simd
[  199.974710]  glue_helper cryptd xhci_pci xhci_hcd usbcore usb_common
applespi(O) crc16 led_class intel_lpss_pci intel_lpss
spi_pxa2xx_platform
[  199.974718] CPU: 0 PID: 324 Comm: kworker/u8:6 Tainted:
G     U     O     4.15.5-1-ARCH #1
[  199.974718] Hardware name: Apple Inc. MacBookPro14,1/Mac-
B4831CEBD52A0C4C, BIOS MBP141.88Z.0169.B00.1712141501 12/14/2017
[  199.974734] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[btrfs]
[  199.974746] RIP: 0010:btrfs_finish_ordered_io+0x7ab/0x850 [btrfs]
[  199.974747] RSP: 0018:ffffb3310128bdc8 EFLAGS: 00010286
[  199.974749] RAX: 0000000000000000 RBX: ffffa25b1e150b60 RCX:
0000000000000001
[  199.974749] RDX: 0000000080000001 RSI: ffffffff9fe47fd0 RDI:
00000000ffffffff
[  199.974750] RBP: ffffa25a2df7dad0 R08: 0000000000000001 R09:
0000000000000412
[  199.974751] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffa25a2df7d8e0
[  199.974752] R13: ffffa25a2df7d8c0 R14: ffffa25b1f037f78 R15:
0000000000000001
[  199.974753] FS:  0000000000000000(0000) GS:ffffa25b2ec00000(0000)
knlGS:0000000000000000
[  199.974754] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  199.974755] CR2: 00007fd9cc5dd3e7 CR3: 000000006300a002 CR4:
00000000003606f0
[  199.974756] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  199.974756] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[  199.974757] Call Trace:
[  199.974774]  normal_work_helper+0x39/0x370 [btrfs]
[  199.974779]  process_one_work+0x1ce/0x410
[  199.974782]  worker_thread+0x2b/0x3d0
[  199.974784]  ? process_one_work+0x410/0x410
[  199.974785]  kthread+0x113/0x130
[  199.974787]  ? kthread_create_on_node+0x70/0x70
[  199.974789]  ? do_syscall_64+0x74/0x190
[  199.974791]  ? SyS_exit_group+0x10/0x10
[  199.974793]  ret_from_fork+0x35/0x40
[  199.974795] Code: 08 01 e9 a4 fb ff ff 49 8b 46 60 f0 0f ba a8 50 12
00 00 02 72 17 8b 74 24 10 83 fe fb 74 32 48 c7 c7 38 a7 6c c0 e8 85 7a
a3 de <0f> 0b 8b 4c 24 10 ba e2 0b 00 00 eb b1 4c 8b 23 4c 8b 53 10 41 
[  199.974820] ---[ end trace c8ed62ff6a525901 ]---
[  199.974822] BTRFS: error (device dm-2) in
btrfs_finish_ordered_io:3042: errno=-95 unknown
[  199.974824] BTRFS info (device dm-2): forced readonly
[  199.976696] BTRFS error (device dm-2): pending csums is 6447104

Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=198945
Kernel version: 4.15.5
Distro: Arch Linux
