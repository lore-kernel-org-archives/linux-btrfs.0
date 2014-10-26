Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49831 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaJZLDV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Oct 2014 07:03:21 -0400
Received: by mail-wi0-f175.google.com with SMTP id h11so2214946wiw.8
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Oct 2014 04:03:19 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sun, 26 Oct 2014 14:02:39 +0300
Message-ID: <CAGqmi75bar+4zp4p78WRjR4rrFonJ4mdA=i9q7Q-6rN3H84MkQ@mail.gmail.com>
Subject: [BUG] fs/btrfs/delayed-inode.c: 1410 btrfs_commit_transaction+0x388/0x950()
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[$] uname -a
Linux beplan 3.18.0-rc1-next-20141023-ARCH-dirty #1 SMP PREEMPT Sat
Oct 25 22:19:01 FET 2014 x86_64 GNU/Linux

I have a custom config for kernel, and i disable debugs feature in kernel.
If needed i can enable it and recompile kernel.

After this message, system boot continue and working good.
I catch this message every time when i hard reset my system.

[   45.407343] ------------[ cut here ]------------
[   45.407352] WARNING: CPU: 2 PID: 137 at
fs/btrfs/delayed-inode.c:1410 btrfs_commit_transaction+0x388/0x950()
[   45.407369] Modules linked in: pci_stub vboxpci(O) vboxnetflt(O)
vboxnetadp(O) vboxdrv(O) ctr ccm bnep loop joydev uvcvideo
videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev
rtsx_usb_sdmmc media mmc_core mousedev rtsx_usb_ms usbhid memstick
rtsx_usb ecb ath3k btusb bluetooth crc16 snd_hda_codec_hdmi
thinkpad_acpi nvram coretemp hwmon intel_rapl i915 arc4
x86_pkg_temp_thermal intel_powerclamp ath9k crct10dif_pclmul
ath9k_common crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64
lrw gf128mul ath9k_hw glue_helper drm_kms_helper drm
snd_hda_codec_conexant snd_hda_codec_generic alx mdio ablk_helper
iTCO_wdt iTCO_vendor_support cryptd ath mac80211 ideapad_laptop pcspkr
snd_hda_intel cfg80211 evdev mac_hid snd_hda_controller sparse_keymap
rfkill snd_hda_codec thermal intel_gtt
[   45.407407]  snd_hwdep snd_pcm snd_timer battery ac i2c_algo_bit
i2c_i801 video snd serio_raw i2c_core soundcore shpchp processor
mei_me mei lpc_ich button sch_fq_codel uas usb_storage ehci_pci
crc32c_intel xhci_pci xhci_hcd ehci_hcd usbcore usb_common
[   45.407420] CPU: 2 PID: 137 Comm: btrfs-transacti Tainted: G
W  O   3.18.0-rc1-next-20141023-ARCH-dirty #1
[   45.407421] Hardware name: LENOVO 20238/INVALID, BIOS
79CN46WW(V3.05) 12/23/2013
[   45.407422]  0000000000000000 0000000000000009 ffffffff81537313
0000000000000000
[   45.407424]  ffffffff81048a3d ffff880255f1a460 ffff880253097000
0000000000000000
[   45.407426]  ffff880255f78000 ffff880255e901a0 ffffffff811f17b8
ffff880253097000
[   45.407428] Call Trace:
[   45.407433]  [<ffffffff81537313>] ? dump_stack+0x49/0x6a
[   45.407436]  [<ffffffff81048a3d>] ? warn_slowpath_common+0x6d/0x90
[   45.407439]  [<ffffffff811f17b8>] ? btrfs_commit_transaction+0x388/0x950
[   45.407441]  [<ffffffff811f1e0b>] ? start_transaction+0x8b/0x540
[   45.407445]  [<ffffffff811ed625>] ? transaction_kthread+0x1d5/0x240
[   45.407447]  [<ffffffff811ed450>] ? btrfs_cleanup_transaction+0x4e0/0x4e0
[   45.407450]  [<ffffffff8106229e>] ? kthread+0xce/0xf0
[   45.407453]  [<ffffffff81060000>] ? task_tgid_nr_ns+0x40/0x40
[   45.407455]  [<ffffffff810621d0>] ? kthread_create_on_node+0x180/0x180
[   45.407458]  [<ffffffff8153cb6c>] ? ret_from_fork+0x7c/0xb0
[   45.407459]  [<ffffffff810621d0>] ? kthread_create_on_node+0x180/0x180
[   45.407461] ---[ end trace 6ad315228ee71ec9 ]--

-- 
Have a nice day,
Timofey.
