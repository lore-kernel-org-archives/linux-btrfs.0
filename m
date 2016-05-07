Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:37572 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcEGPpU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 May 2016 11:45:20 -0400
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram  and disk are ok. it still mounts, but I cannot repair
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 07 May 2016 17:45:16 +0200
From: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
In-Reply-To: <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
 <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
 <20160505174854.GA1012@vader.dhcp.thefacebook.com>
 <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
Message-ID: <2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs + dmcrypt + compress=lzo + autodefrag = corruption at first boot
So discard is not the culprit. Will try to remove compress=lzo and 
autodefrag and see if it still happens.

[  748.224346] BTRFS error (device dm-0): memmove bogus src_offset 5431 
move len 4294962894 len 16384
[  748.226206] ------------[ cut here ]------------
[  748.227831] kernel BUG at fs/btrfs/extent_io.c:5723!
[  748.229498] invalid opcode: 0000 [#1] PREEMPT SMP
[  748.231161] Modules linked in: ext4 mbcache jbd2 nls_iso8859_1 
nls_cp437 vfat fat snd_hda_codec_hdmi dell_laptop dcdbas dell_wmi 
iTCO_wdt iTCO_vendor_support intel_rapl x86_pkg_temp_thermal 
intel_powerclamp coretemp kvm_intel arc4 kvm irqbypass psmouse serio_raw 
pcspkr elan_i2c snd_soc_ssm4567 snd_soc_rt286 snd_soc_rl6347a 
snd_soc_core i2c_hid iwlmvm snd_compress snd_pcm_dmaengine ac97_bus 
mac80211 uvcvideo videobuf2_vmalloc btusb videobuf2_memops cdc_ether 
btrtl usbnet iwlwifi btbcm videobuf2_v4l2 btintel intel_pch_thermal 
videobuf2_core i2c_i801 videodev r8152 rtsx_pci_ms cfg80211 bluetooth 
visor media mii memstick joydev evdev mousedev input_leds rfkill mac_hid 
crc16 i915 fan thermal wmi dw_dmac int3403_thermal video dw_dmac_core 
drm_kms_helper snd_soc_sst_acpi i2c_designware_platform 
snd_soc_sst_match
[  748.237203]  snd_hda_intel 8250_dw i2c_designware_core gpio_lynxpoint 
spi_pxa2xx_platform drm int3402_thermal snd_hda_codec battery tpm_crb 
intel_hid snd_hda_core sparse_keymap fjes snd_hwdep int3400_thermal 
acpi_thermal_rel tpm_tis snd_pcm intel_gtt tpm acpi_als syscopyarea 
sysfillrect snd_timer sysimgblt fb_sys_fops mei_me i2c_algo_bit 
processor_thermal_device kfifo_buf processor snd industrialio acpi_pad 
ac int340x_thermal_zone mei intel_soc_dts_iosf button lpc_ich soundcore 
shpchp sch_fq_codel ip_tables x_tables btrfs xor raid6_pq 
jitterentropy_rng sha256_ssse3 sha256_generic hmac drbg ansi_cprng 
algif_skcipher af_alg uas usb_storage dm_crypt dm_mod sd_mod 
rtsx_pci_sdmmc atkbd libps2 crct10dif_pclmul crc32_pclmul crc32c_intel 
ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper
[  748.244176]  ablk_helper cryptd ahci libahci libata scsi_mod xhci_pci 
rtsx_pci xhci_hcd i8042 serio sdhci_acpi sdhci led_class mmc_core pl2303 
mos7720 usbserial parport hid_generic usbhid hid usbcore usb_common
[  748.246662] CPU: 0 PID: 2316 Comm: pacman Not tainted 4.5.1-1-ARCH #1
[  748.249123] Hardware name: Dell Inc. XPS 13 9343/0F5KF3, BIOS A07 
11/11/2015
[  748.251576] task: ffff8800d9d98e40 ti: ffff8800cec10000 task.ti: 
ffff8800cec10000
[  748.254064] RIP: 0010:[<ffffffffa0300bac>]  [<ffffffffa0300bac>] 
memmove_extent_buffer+0x10c/0x110 [btrfs]
[  748.256600] RSP: 0018:ffff8800cec13c18  EFLAGS: 00010246
[  748.259120] RAX: 0000000000000000 RBX: ffff88020c01ba40 RCX: 
0000000000000056
[  748.261631] RDX: 0000000000000000 RSI: ffff88021e40db38 RDI: 
ffff88021e40db38
[  748.264166] RBP: ffff8800cec13c48 R08: 0000000000000000 R09: 
000000000000033b
[  748.266716] R10: 0000000000000000 R11: 000000000000033b R12: 
00000000ffffeece
[  748.269267] R13: 0000000100000405 R14: 00000001000004c9 R15: 
ffff88020c01ba40
[  748.271818] FS:  00007f14d4271740(0000) GS:ffff88021e400000(0000) 
knlGS:0000000000000000
[  748.274392] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  748.276987] CR2: 0000000001630008 CR3: 00000000cffc8000 CR4: 
00000000003406f0
[  748.279603] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  748.282220] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  748.284815] Stack:
[  748.287422]  00000000e3438cd2 ffff88020c01ba40 00000000000000c4 
000000000000002a
[  748.290082]  000000000000006b 00000000000003a0 ffff8800cec13ce8 
ffffffffa02b612c
[  748.292754]  ffffffffa02b433d ffff8800da9ca820 0000002800000000 
ffff8800daa78bd0
[  748.295441] Call Trace:
[  748.298104]  [<ffffffffa02b612c>] btrfs_del_items+0x33c/0x4a0 [btrfs]
[  748.300827]  [<ffffffffa02b433d>] ? btrfs_search_slot+0x90d/0x990 
[btrfs]
[  748.303564]  [<ffffffffa02f3d9c>] ? btrfs_get_token_8+0x6c/0x130 
[btrfs]
[  748.306311]  [<ffffffffa02e5ca9>] 
btrfs_truncate_inode_items+0x649/0xd20 [btrfs]
[  748.309071]  [<ffffffffa0330b5e>] ? 
btrfs_delayed_inode_release_metadata.isra.1+0x4e/0xf0 [btrfs]
[  748.311860]  [<ffffffffa02e7315>] btrfs_evict_inode+0x485/0x5d0 
[btrfs]
[  748.314627]  [<ffffffff81207e55>] evict+0xc5/0x190
[  748.317412]  [<ffffffff81208689>] iput+0x1d9/0x260
[  748.320199]  [<ffffffff811fd689>] do_unlinkat+0x199/0x2d0
[  748.322988]  [<ffffffff811fdf66>] SyS_unlink+0x16/0x20
[  748.325781]  [<ffffffff815ad6ae>] entry_SYSCALL_64_fastpath+0x12/0x6d
[  748.328584] Code: 41 5e 41 5f 5d c3 48 8b 7f 18 48 89 f2 48 c7 c6 40 
44 36 a0 e8 06 90 fa ff 0f 0b 48 8b 7f 18 48 c7 c6 08 44 36 a0 e8 f4 8f 
fa ff <0f> 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 55 41 54 53 48 89 fb
[  748.331558] RIP  [<ffffffffa0300bac>] 
memmove_extent_buffer+0x10c/0x110 [btrfs]
[  748.334473]  RSP <ffff8800cec13c18>
[  748.356077] ---[ end trace 9bfb28800ab52273 ]---
[  748.359042] note: pacman[2316] exited with preempt_count 2
