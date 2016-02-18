Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37086 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424633AbcBRI3w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 03:29:52 -0500
Received: by mail-wm0-f53.google.com with SMTP id g62so13976736wme.0
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 00:29:51 -0800 (PST)
MIME-Version: 1.0
From: Jan Alexander Steffens <jan.steffens@gmail.com>
Date: Thu, 18 Feb 2016 09:29:31 +0100
Message-ID: <CAMQ-g0cfWswiW94MEocyGU1PoMtOUyio-bB6N79LtpU8jDwJaw@mail.gmail.com>
Subject: Oops on Send
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,

I'm getting reproducible Oopses when attempting "btrfs send" on my
root vol, quickly ending in a hard lockup of the machine. Both
incremental send and non-incremental send crash, the former much
earlier. The volume is in a LUKS container.

The initial fault is always during LZO decompression, but scrub does
not find any errors. Could this be invalid compressed data with good
checksums? "btrfs check" finds bad extent backrefs which --repair
claims to fix, but they reappear on a subsequent check.

Is there a way to find out which files' extents are damaged so I can
delete them and complete my backup?

I'm not subscribed, so please include my address in To or Cc.

Kind regards,
Jan



BUG: unable to handle kernel paging request at ffffc90001bb6000
IP: [<ffffffff812d4d16>] memcpy_erms+0x6/0x10
PGD 40f08d067 PUD 40f08e067 PMD 40c65e067 PTE 0
Oops: 0002 [#1] PREEMPT SMP
Modules linked in: ctr ccm xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT
nf_reject_ipv4 xt_tcpudp rfcomm tun bridge stp llc ebtable_filter
ebtables ip6table_filter ip6_tables iptable_filter uas usb_storage
bnep joydev mousedev tpm_infineon arc4 nls_iso8859_1 nls_cp437 vfat
fat snd_hda_codec_via snd_hda_codec_generic snd_hda_codec_hdmi
iTCO_wdt iTCO_vendor_support iwlmvm mac80211 x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm iwlwifi irqbypass btusb btrtl
btbcm input_leds btintel led_class cfg80211 bluetooth psmouse
serio_raw snd_hda_intel e1000e snd_hda_codec rfkill i2c_i801
rtsx_pci_ms crc16 memstick snd_hda_core ptp mei_me pps_core snd_hwdep
lpc_ich mei
 shpchp snd_pcm wmi thermal battery fjes evdev tpm_tis mac_hid ac
processor sch_fq_codel usbip_host usbip_core snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_timer snd soundcore cuse
fuse nfs lockd grace sunrpc fscache tcp_cdg tpm_rng rng_core tpm
vhba(O) ip_tables x_tables btrfs xor raid6_pq sha256_ssse3
sha256_generic hmac drbg ansi_cprng algif_skcipher af_alg dm_crypt
dm_mod sd_mod rtsx_pci_sdmmc mmc_core atkbd libps2 crct10dif_pclmul
xhci_pci crc32_pclmul crc32c_intel xhci_hcd aesni_intel ehci_pci ahci
aes_x86_64 lrw ehci_hcd libahci gf128mul glue_helper ablk_helper
cryptd libata scsi_mod usbcore rtsx_pci usb_common i8042 serio i915
video button intel_gtt i2c_algo_bit drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops drm
CPU: 4 PID: 12114 Comm: kworker/u16:5 Tainted: G           O    4.4.1-2-ARCH #1
Hardware name: Notebook                         W740SU
         /W740SU                          , BIOS 4.6.5 09/11/2014
Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
task: ffff8803942f9b80 ti: ffff8803aee78000 task.ti: ffff8803aee78000
RIP: 0010:[<ffffffff812d4d16>]  [<ffffffff812d4d16>] memcpy_erms+0x6/0x10
RSP: 0018:ffff8803aee7bc58  EFLAGS: 00010286
RAX: ffffc90001bb5ff8 RBX: 0000000000001000 RCX: 0000000000000ff8
RDX: 0000000000001000 RSI: ffff880260ca7008 RDI: ffffc90001bb6000
RBP: ffff8803aee7bd28 R08: ffffc90001bb4000 R09: 0000000000001000
R10: 0000000000000000 R11: ffff880408b5c398 R12: 0000000000000000
R13: 0000000000230021 R14: ffff880408b5c398 R15: 0000000000230029
FS:  0000000000000000(0000) GS:ffff88041fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90001bb6000 CR3: 0000000001809000 CR4: 00000000001406e0
Stack:
 ffffffffa04dbce3 ffffffff8102166e ffff8803aee7bc90 0000160000000000
 ffff8803581f5800 000000000000000e 0000000000000000 000000000022e029
 ffffc90001bb4000 0000000000000002 00000000001a0000 0000001a00000048
Call Trace:
 [<ffffffffa04dbce3>] ? lzo_decompress_biovec+0x1e3/0x2d0 [btrfs]
 [<ffffffff8102166e>] ? kernel_fpu_end+0xe/0x20
 [<ffffffffa04dc785>] end_compressed_bio_read+0x1c5/0x300 [btrfs]
 [<ffffffff81292c7f>] bio_endio+0x3f/0x60
 [<ffffffffa048919c>] end_workqueue_fn+0x3c/0x40 [btrfs]
 [<ffffffffa04c4a17>] btrfs_scrubparity_helper+0x77/0x2e0 [btrfs]
 [<ffffffffa04c4d6e>] btrfs_endio_helper+0xe/0x10 [btrfs]
 [<ffffffff8108e21b>] process_one_work+0x14b/0x440
 [<ffffffff8108e558>] worker_thread+0x48/0x4a0
 [<ffffffff8108e510>] ? process_one_work+0x440/0x440
 [<ffffffff81093ff8>] kthread+0xd8/0xf0
 [<ffffffff81093f20>] ? kthread_worker_fn+0x170/0x170
 [<ffffffff81591e8f>] ret_from_fork+0x3f/0x70
 [<ffffffff81093f20>] ? kthread_worker_fn+0x170/0x170
Code: f3 c3 90 90 90 eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83
e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3>
a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38
RIP  [<ffffffff812d4d16>] memcpy_erms+0x6/0x10
 RSP <ffff8803aee7bc58>
CR2: ffffc90001bb6000
---[ end trace 99ccc6da83f67660 ]---
BUG: unable to handle kernel paging request at ffffffffffffffd8
IP: [<ffffffff81094500>] kthread_data+0x10/0x20
PGD 180c067 PUD 180e067 PMD 0
Oops: 0000 [#2] PREEMPT SMP
Modules linked in: ctr ccm xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT
nf_reject_ipv4 xt_tcpudp rfcomm tun bridge stp llc ebtable_filter
ebtables ip6table_filter ip6_tables iptable_filter uas usb_storage
bnep joydev mousedev tpm_infineon arc4 nls_iso8859_1 nls_cp437 vfat
fat snd_hda_codec_via snd_hda_codec_generic snd_hda_codec_hdmi
iTCO_wdt iTCO_vendor_support iwlmvm mac80211 x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm iwlwifi irqbypass btusb btrtl
btbcm input_leds btintel led_class cfg80211 bluetooth psmouse
serio_raw snd_hda_intel e1000e snd_hda_codec rfkill i2c_i801
rtsx_pci_ms crc16 memstick snd_hda_core ptp mei_me pps_core snd_hwdep
lpc_ich mei
 shpchp snd_pcm wmi thermal battery fjes evdev tpm_tis mac_hid ac
processor sch_fq_codel usbip_host usbip_core snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_timer snd soundcore cuse
fuse nfs lockd grace sunrpc fscache tcp_cdg tpm_rng rng_core tpm
vhba(O) ip_tables x_tables btrfs xor raid6_pq sha256_ssse3
sha256_generic hmac drbg ansi_cprng algif_skcipher af_alg dm_crypt
dm_mod sd_mod rtsx_pci_sdmmc mmc_core atkbd libps2 crct10dif_pclmul
xhci_pci crc32_pclmul crc32c_intel xhci_hcd aesni_intel ehci_pci ahci
aes_x86_64 lrw ehci_hcd libahci gf128mul glue_helper ablk_helper
cryptd libata scsi_mod usbcore rtsx_pci usb_common i8042 serio i915
video button intel_gtt i2c_algo_bit drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops drm
CPU: 4 PID: 12114 Comm: kworker/u16:5 Tainted: G      D    O    4.4.1-2-ARCH #1
Hardware name: Notebook                         W740SU
         /W740SU                          , BIOS 4.6.5 09/11/2014
task: ffff8803942f9b80 ti: ffff8803aee78000 task.ti: ffff8803aee78000
RIP: 0010:[<ffffffff81094500>]  [<ffffffff81094500>] kthread_data+0x10/0x20
RSP: 0018:ffff8803aee7b948  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000004 RCX: ffffffff81a61700
RDX: 0000000000000004 RSI: 0000000000000004 RDI: ffff8803942f9b80
RBP: ffff8803aee7b948 R08: 00000000ffffffff R09: 0000000000000000
R10: ffff8803942f9be0 R11: 0000000000000810 R12: 0000000000000000
R13: 0000000000015700 R14: ffff8803942f9b80 R15: ffff88041fb15700
FS:  0000000000000000(0000) GS:ffff88041fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000028 CR3: 0000000001809000 CR4: 00000000001406e0
Stack:
 ffff8803aee7b960 ffffffff8108edf1 ffff88041fb15700 ffff8803aee7b9b0
 ffffffff8158dbd0 ffff8803aee7b9a0 ffffffff00000004 ffff8803942f9b80
 ffff8803aee7c000 ffff8803942fa238 ffff8803aee7b560 ffffc90001bb6000
Call Trace:
 [<ffffffff8108edf1>] wq_worker_sleeping+0x11/0x90
 [<ffffffff8158dbd0>] __schedule+0x640/0xa70
 [<ffffffff8158e03c>] schedule+0x3c/0x90
 [<ffffffff810795c8>] do_exit+0x768/0xae0
 [<ffffffff8101976a>] oops_end+0x9a/0xd0
 [<ffffffff81063bbc>] no_context+0x15c/0x380
 [<ffffffff810ad566>] ? enqueue_task_fair+0xa6/0x8f0
 [<ffffffff81063f08>] __bad_area_nosemaphore+0x128/0x230
 [<ffffffff8109e654>] ? check_preempt_curr+0x54/0x90
 [<ffffffff81064023>] bad_area_nosemaphore+0x13/0x20
 [<ffffffff81064482>] __do_page_fault+0x222/0x450
 [<ffffffff8109f39d>] ? try_to_wake_up+0x18d/0x390
 [<ffffffff810646d2>] do_page_fault+0x22/0x30
 [<ffffffff81593c88>] page_fault+0x28/0x30
 [<ffffffff812d4d16>] ? memcpy_erms+0x6/0x10
 [<ffffffffa04dbce3>] ? lzo_decompress_biovec+0x1e3/0x2d0 [btrfs]
 [<ffffffff8102166e>] ? kernel_fpu_end+0xe/0x20
 [<ffffffffa04dc785>] end_compressed_bio_read+0x1c5/0x300 [btrfs]
 [<ffffffff81292c7f>] bio_endio+0x3f/0x60
 [<ffffffffa048919c>] end_workqueue_fn+0x3c/0x40 [btrfs]
 [<ffffffffa04c4a17>] btrfs_scrubparity_helper+0x77/0x2e0 [btrfs]
 [<ffffffffa04c4d6e>] btrfs_endio_helper+0xe/0x10 [btrfs]
 [<ffffffff8108e21b>] process_one_work+0x14b/0x440
 [<ffffffff8108e558>] worker_thread+0x48/0x4a0
 [<ffffffff8108e510>] ? process_one_work+0x440/0x440
 [<ffffffff81093ff8>] kthread+0xd8/0xf0
 [<ffffffff81093f20>] ? kthread_worker_fn+0x170/0x170
 [<ffffffff81591e8f>] ret_from_fork+0x3f/0x70
 [<ffffffff81093f20>] ? kthread_worker_fn+0x170/0x170
Code: 41 5d 5d c3 e8 36 eb f6 ff e9 13 ff ff ff 0f 1f 00 66 2e 0f 1f
84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 10 05 00 00 55 48 89 e5 <48>
8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
RIP  [<ffffffff81094500>] kthread_data+0x10/0x20
 RSP <ffff8803aee7b948>
CR2: ffffffffffffffd8
---[ end trace 99ccc6da83f67661 ]---
Fixing recursive fault but reboot is needed!
