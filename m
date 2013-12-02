Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gst.name ([78.46.150.186]:36598 "EHLO gst.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab3LBIXg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Dec 2013 03:23:36 -0500
Date: Mon, 2 Dec 2013 09:15:43 +0100
From: Guenther Starnberger <linux-btrfs@gst.priv.at>
To: linux-btrfs@vger.kernel.org
Subject: "No space left on device" although there's space left
Message-ID: <20131202081543.GA1104@gst.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a problem with a btrfs filesystem where i regularly get "no space left
on device" errors, although there should be plenty of free space left.

I already tried all of the things mentioned in the FAQ such as balancing the
filesystem, mounting with the clear_cache option, mounting with different
metadata_ratio options (i tried 4 and 12).

Here's the output of "btrfs fi df":
Data, single: total=1.30TiB, used=1.25TiB
System, DUP: total=32.00MiB, used=156.00KiB
Metadata, DUP: total=16.00GiB, used=15.12GiB

(The total partition size is 2.8T. For some reason "btrfs di df" doesn't
display this correctly, but "btrfs fi show" does.)

One way to reproduce this problem is to run "bedup". After deduplicating a few
files it will fail with "[Errno 28] No space left on device" within an ioctl
clone call. I'm running a very recent stable kernel version (3.12.1).

Anything else that I could try to resolve this problem (apart from running
balance, using clear_cache as mount option, changing the metadata_ratio)?

Here are two different dmesg messages showing the out-of-space error during a
clone operation:

[52123.891381] ------------[ cut here ]------------
[52123.891398] WARNING: CPU: 0 PID: 11091 at fs/btrfs/super.c:255 __btrfs_abort_transaction+0x11d/0x130 [btrfs]()
[52123.891400] btrfs: Transaction aborted (error -28)
[52123.891401] Modules linked in: tun btrfs raid6_pq libcrc32c xor joydev hdaps(O) uvcvideo videobuf2_vmalloc videobuf2_memops btusb videobuf2_core qcserial bluetooth videodev usb_wwan media usbserial arc4 iwldvm intel_powerclamp coretemp kvm_intel snd_hda_codec_hdmi mac80211 kvm iTCO_wdt i915 thinkpad_acpi snd_hda_codec_conexant iTCO_vendor_support drm_kms_helper iwlwifi nvram drm psmouse cfg80211 evdev snd_hda_intel snd_hda_codec serio_raw rfkill mei_me mei shpchp snd_hwdep snd_pcm snd_page_alloc snd_timer snd soundcore e1000e microcode i2c_algo_bit intel_agp intel_gtt wmi intel_ips ptp i2c_i801 i2c_core pps_core thermal lpc_ich battery ac video button acpi_cpufreq processor tp_smapi(O) thinkpad_ec(O) nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2 usb_storage dm_crypt dm_mod crct10dif_pclmul crct10dif_common
[52123.891450]  crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ehci_pci ehci_hcd usbcore usb_common ata_piix sd_mod ahci libahci ata_generic libata scsi_mod
[52123.891462] CPU: 0 PID: 11091 Comm: bedup Tainted: G        W  O 3.12.1-3-ARCH #1
[52123.891463] Hardware name: LENOVO 3680U4M/3680U4M, BIOS 6QET68WW (1.38 ) 12/01/2011
[52123.891465]  0000000000000009 ffff88009aa15b40 ffffffff814ed7ab ffff88009aa15b88
[52123.891467]  ffff88009aa15b78 ffffffff81062bbd 00000000ffffffe4 ffff8800b614d800
[52123.891469]  ffff88021e58b320 ffffffffa0d14120 0000000000000c1c ffff88009aa15bd8
[52123.891471] Call Trace:
[52123.891479]  [<ffffffff814ed7ab>] dump_stack+0x54/0x8d
[52123.891484]  [<ffffffff81062bbd>] warn_slowpath_common+0x7d/0xa0
[52123.891530]  [<ffffffff81062c2c>] warn_slowpath_fmt+0x4c/0x50
[52123.891538]  [<ffffffffa0c76b7d>] __btrfs_abort_transaction+0x11d/0x130 [btrfs]
[52123.891545]  [<ffffffffa0d0d168>] btrfs_clone+0x7f7/0x864 [btrfs]
[52123.891554]  [<ffffffffa0ccfba9>] btrfs_ioctl_clone+0x429/0x450 [btrfs]
[52123.891568]  [<ffffffffa0cd415d>] btrfs_ioctl+0xe1d/0x2820 [btrfs]
[52123.891582]  [<ffffffffa0cc21d2>] ? extent_fiemap+0x3c2/0x4e0 [btrfs]
[52123.891594]  [<ffffffffa0ca6180>] ? btrfs_get_extent+0x9b0/0x9b0 [btrfs]
[52123.891599]  [<ffffffff811b6a15>] do_vfs_ioctl+0x2e5/0x4d0
[52123.891602]  [<ffffffff811b6c81>] SyS_ioctl+0x81/0xa0
[52123.891607]  [<ffffffff811a4b09>] ? SyS_read+0x49/0xa0
[52123.891611]  [<ffffffff814fc32d>] system_call_fastpath+0x1a/0x1f
[52123.891613] ---[ end trace 283ad43d7f5f7914 ]---
[52123.891616] BTRFS error (device dm-1) in btrfs_clone:3100: errno=-28 No space left
[52123.891620] BTRFS info (device dm-1): forced readonly

[75774.193909] ------------[ cut here ]------------
[75774.193927] WARNING: CPU: 2 PID: 13815 at fs/btrfs/super.c:255 __btrfs_abort_transaction+0x11d/0x130 [btrfs]()
[75774.193928] btrfs: Transaction aborted (error -28)
[75774.193929] Modules linked in: fuse tun btrfs raid6_pq libcrc32c xor joydev hdaps(O) uvcvideo videobuf2_vmalloc videobuf2_memops btusb videobuf2_core qcserial bluetooth videodev usb_wwan media usbserial arc4 iwldvm intel_powerclamp coretemp kvm_intel snd_hda_codec_hdmi mac80211 kvm iTCO_wdt i915 thinkpad_acpi snd_hda_codec_conexant iTCO_vendor_support drm_kms_helper iwlwifi nvram drm psmouse cfg80211 evdev snd_hda_intel snd_hda_codec serio_raw rfkill mei_me mei shpchp snd_hwdep snd_pcm snd_page_alloc snd_timer snd soundcore e1000e microcode i2c_algo_bit intel_agp intel_gtt wmi intel_ips ptp i2c_i801 i2c_core pps_core thermal lpc_ich battery ac video button acpi_cpufreq processor tp_smapi(O) thinkpad_ec(O) nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2 usb_storage dm_crypt dm_mod crct10dif_pclmul
[75774.193976]  crct10dif_common crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ehci_pci ehci_hcd usbcore usb_common ata_piix sd_mod ahci libahci ata_generic libata scsi_mod
[75774.193988] CPU: 2 PID: 13815 Comm: bedup Tainted: G        W  O 3.12.1-3-ARCH #1
[75774.193990] Hardware name: LENOVO 3680U4M/3680U4M, BIOS 6QET68WW (1.38 ) 12/01/2011
[75774.193991]  0000000000000009 ffff88021662db40 ffffffff814ed7ab ffff88021662db88
[75774.193993]  ffff88021662db78 ffffffff81062bbd 00000000ffffffe4 ffff88013c66d800
[75774.193995]  ffff88021e58ba00 ffffffffa0d14120 0000000000000c1c ffff88021662dbd8
[75774.193997] Call Trace:
[75774.194005]  [<ffffffff814ed7ab>] dump_stack+0x54/0x8d
[75774.194010]  [<ffffffff81062bbd>] warn_slowpath_common+0x7d/0xa0
[75774.194012]  [<ffffffff81062c2c>] warn_slowpath_fmt+0x4c/0x50
[75774.194016]  [<ffffffffa0c76b7d>] __btrfs_abort_transaction+0x11d/0x130 [btrfs]
[75774.194022]  [<ffffffffa0d0d168>] btrfs_clone+0x7f7/0x864 [btrfs]
[75774.194029]  [<ffffffffa0ccfba9>] btrfs_ioctl_clone+0x429/0x450 [btrfs]
[75774.194036]  [<ffffffffa0cd415d>] btrfs_ioctl+0xe1d/0x2820 [btrfs]
[75774.194041]  [<ffffffff8113d4a7>] ? __free_pages+0x47/0x50
[75774.194043]  [<ffffffff8113d620>] ? free_pages.part.59+0x40/0x50
[75774.194045]  [<ffffffff8113d643>] ? free_pages+0x13/0x20
[75774.194048]  [<ffffffff8115c4f5>] ? tlb_finish_mmu+0x35/0x60
[75774.194051]  [<ffffffff81164903>] ? unmap_region+0xd3/0x110
[75774.194054]  [<ffffffff811b6a15>] do_vfs_ioctl+0x2e5/0x4d0
[75774.194056]  [<ffffffff81166ab8>] ? do_munmap+0x298/0x380
[75774.194057]  [<ffffffff811b6c81>] SyS_ioctl+0x81/0xa0
[75774.194060]  [<ffffffff814fc32d>] system_call_fastpath+0x1a/0x1f
[75774.194061] ---[ end trace 283ad43d7f5f7915 ]---
[75774.194064] BTRFS error (device dm-1) in btrfs_clone:3100: errno=-28 No space left
[75774.194066] BTRFS info (device dm-1): forced readonly

- Guenther
