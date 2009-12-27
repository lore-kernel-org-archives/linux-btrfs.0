From: "Lex \"x-demon\" Rivera" <x-demon@x-demon.org>
Subject: Btrfs fails randomly
Date: Sun, 27 Dec 2009 10:34:45 +0300
Message-ID: <fcfb36620912262334s68416a0aj66db9f7c8c7e0f88@mail.gmail.com>
References: <fcfb36620912262329s73b1f1ffj5eb7f3ae8acb0013@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <fcfb36620912262329s73b1f1ffj5eb7f3ae8acb0013@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs fails randomly, after this error in dmesg i can't exec any apps,
but can read/write to disc. Log attached, it's always the same, except
process that caused this.

t fs/btrfs/ordered-data.c:672!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Modules linked in: ipv6 fuse aes_i586 aes_generic rfcomm sco bridge
stp llc bnep l2cap crc16 ext3 jbd mbcache arc4 ecb b43 btusb
snd_hda_codec_analog bluetooth snd_seq_dummy pciehp uvcvideo mac80211
pci_hotplug videodev v4l1_compat cfg80211 snd_seq_oss rfkill
snd_seq_midi_event cpufreq_conservative snd_hda_intel iTCO_wdt ssb
snd_seq iTCO_vendor_support snd_hda_codec snd_seq_device joydev
snd_hwdep snd_pcm_oss snd_mixer_oss hp_accel snd_pcm mmc_core
lis3lv02d acpi_cpufreq snd_timer uhci_hcd snd ehci_hcd fan
input_polldev pcmcia soundcore sky2 usbcore led_class wmi
snd_page_alloc pcmcia_core evdev psmouse ac thermal battery serio_raw
pcspkr sg freq_table processor rtc_cmos rtc_core rtc_lib sd_mod
ata_piix ahci libata scsi_mod btrfs crc32c libcrc32c zlib_deflate lzo
lzo_decompress lzo_compress i915 drm_kms_helper drm i2c_algo_bit
button i2c_core video output intel_agp agpgart

Pid: 15778, comm: iron Not tainted (2.6.32-ZEN #1) HP 2140
EIP: 0060:[<f85bd96b>] EFLAGS: 00210287 CPU: 1
EIP is at btrfs_ordered_update_i_size+0x40b/0x750 [btrfs]
EAX: 00006000 EBX: 00005e7d ECX: a40e8f80 EDX: 00000000
ESI: 00000000 EDI: b2dc5684 EBP: 00000000 ESP: a3157e74
=C2=A0DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
=C2=A0Process iron (pid: 15778, ti=3Da3156000 task=3Db68e6bd0 task.ti=3D=
a3156000)
=C2=A0Stack:
=C2=A000005e7c 00000000 00000020 00000000 00000000 22222222 22222222 b2=
dc5570
=C2=A0<0> b2dc5550 00000000 b2dc55cc f858cd75 f6983000 00000000 00005e7=
d fffff000
=C2=A0<0> b2dc5570 0000d000 00000000 a3157f34 00000000 b2dc5684 0000000=
0 f85ac3f7
=C2=A0Call Trace:
[<f858cd75>] ? __find_space_info+0x55/0x60 [btrfs]
[<f85ac3f7>] ? btrfs_setattr+0x1e7/0x310 [btrfs]
[<810f7324>] ? notify_change+0x134/0x320
[<812b144c>] ? __mutex_lock_slowpath+0x1ec/0x2c0
[<810e1721>] ? do_truncate+0x61/0x90
[<810cf186>] ? mmap_region+0x1b6/0x450
[<810e1842>] ? do_sys_ftruncate+0xf2/0x150
[<810e18cd>] ? sys_ftruncate64+0x2d/0x40
[<810039f3>] ? sysenter_do_call+0x12/0x28
Code: 9c 00 00 00 85 c0 74 30 8b 50 bc 8d 48 b8 8b 40 b8 39 d6 72 23
77 04 39 c3 72 1d 03 41 10 13 51 14 39 d6 72 06 77 11 39 c3 73 0d <0f>
0b 8d 76 00 eb fb 8d b6 00 00 00 00 8b 44 24 20 8b 88 98 00
EIP: [<f85bd96b>] btrfs_ordered_update_i_size+0x40b/0x750 [btrfs]
SS:ESP 0068:a3157e74
---[ end trace 1adab407699b39c3 ]---



Best regards, Lex "x-demon" Rivera
|| ICQ 625558 | Jabber x-demon@x-demon.org | http://x-demon.org ||
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
