From: Jan Steffens <jan.steffens@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:4676!
Date: Thu, 9 Jun 2011 17:39:31 +0200
Message-ID: <BANLkTimfLnTnUEYAQkhcCQ6UGE1LYYE5Z6RdQeOtLCiK3e771g@mail.gmail.com>
References: <201106061220.05696.markotahal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106061220.05696.markotahal@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 6, 2011 at 12:19 PM, Marek Otahal <markotahal@gmail.com> wr=
ote:
> Hello,
> the issue happens every time when i have to hard power-off my noteboo=
k (suspend problems).
> With kernel 2.6.39 the partition is unmountable, solution is to boot =
2.6.38 kernel which
> 1/ is able to mount the partition,
> 2/ by doing that fixes the problem so later .39 (after clean shutdown=
) can mount it also.
>
> Attached dmesg follows.
>
> Thank you,
> Mark
>
> mount options:
> /dev/mapper/homeDevice /home btrfs defaults,relatime,nodev,nosuid,com=
press-force=3Dlzo 0 2 # /dev/sda9 home
>
> dmesg:
> [ =C2=A0 56.994241] loop: module loaded
> [ =C2=A0 57.172283] Btrfs loaded
> [ =C2=A0 57.191655] device label store devid 1 transid 26106 /dev/dm-=
3
> [ =C2=A0 57.218783] device label home devid 1 transid 450932 /dev/dm-=
2
> [ =C2=A0 57.459448] scsi 4:0:0:0: Direct-Access =C2=A0 =C2=A0 Generic=
- Multi-Card =C2=A0 =C2=A0 =C2=A0 1.00 PQ: 0 ANSI: 0 CCS
> [ =C2=A0 57.460293] sd 4:0:0:0: Attached scsi generic sg1 type 0
> [ =C2=A0 57.467030] sd 4:0:0:0: [sdb] Attached SCSI removable disk
> [ =C2=A0 61.585618] EXT4-fs (sda4): warning: checktime reached, runni=
ng e2fsck is recommended
> [ =C2=A0 61.671534] EXT4-fs (sda4): re-mounted. Opts: (null)
> [ =C2=A0 62.211037] device label home devid 1 transid 450932 /dev/map=
per/homeDevice
> [ =C2=A0 62.212058] btrfs: force lzo compression
> [ =C2=A0 65.335194] ------------[ cut here ]------------
> [ =C2=A0 65.335308] kernel BUG at fs/btrfs/inode.c:4676!
> [ =C2=A0 65.335406] invalid opcode: 0000 [#1] PREEMPT SMP
> [ =C2=A0 65.335532] last sysfs file: /sys/devices/virtual/bdi/btrfs-1=
/uevent
> [ =C2=A0 65.337833] Modules linked in: btrfs zlib_deflate crc32c libc=
rc32c loop uas ums_realtek uvcvideo usb_storage msr videodev media btus=
b bluetooth sbs sbshc arc4 ecb b43 mac80211 joydev cfg80211 ssb mmc_cor=
e pcmcia sg fuse tg3 uhci_hcd ideapad_laptop evdev sparse_keymap psmous=
e pcspkr snd_hda_codec_realtek iTCO_wdt iTCO_vendor_support rfkill seri=
o_raw ehci_hcd snd_hda_intel pcmcia_core i2c_i801 libphy usbcore ac wmi=
 battery thermal snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcor=
e snd_page_alloc acpi_cpufreq freq_table processor mperf sha256_generic=
 sha512_generic ext4 mbcache jbd2 crc16 cryptd aes_i586 aes_generic xts=
 gf128mul dm_crypt dm_mod sd_mod ata_piix libata scsi_mod i915 drm_kms_=
helper drm i2c_algo_bit button i2c_core video intel_agp intel_gtt agpga=
rt
> [ =C2=A0 65.337833]
> [ =C2=A0 65.337833] Pid: 883, comm: mount Not tainted 2.6.39-ARCH #1 =
LENOVO =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 41875QG =C2=A0 =C2=A0 =C2=A0 =C2=A0 /Kuril
> [ =C2=A0 65.337833] EIP: 0060:[<f9604072>] EFLAGS: 00010282 CPU: 1
> [ =C2=A0 65.337833] EIP is at btrfs_add_link+0x172/0x200 [btrfs]
> [ =C2=A0 65.337833] EAX: ffffffef EBX: ef448908 ECX: 00000119 EDX: 00=
000111
> [ =C2=A0 65.337833] ESI: 004255d9 EDI: 00000020 EBP: eec77ba4 ESP: ee=
c77b48
> [ =C2=A0 65.337833] =C2=A0DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 006=
8
> [ =C2=A0 65.337833] Process mount (pid: 883, ti=3Deec76000 task=3Df4c=
8c450 task.ti=3Deec76000)
> [ =C2=A0 65.337833] Stack:
> [ =C2=A0 65.396712] =C2=A000000020 004255d9 00000000 eec77b87 0000000=
1 0000e55e 00000000 f960d6f8
> [ =C2=A0 65.396712] =C2=A0eec77b88 eec77b8c eec77b90 eec77b94 ef47200=
0 f5076800 ef448ba8 6f43c090
> [ =C2=A0 65.396712] =C2=A0000046ab 01000000 00000000 00000000 0000000=
0 0046ab6f 00000000 eec77c0c
> [ =C2=A0 65.396712] Call Trace:
> [ =C2=A0 65.396712] =C2=A0[<f960d6f8>] ? btrfs_inode_ref_index+0xd8/0=
xe0 [btrfs]
> [ =C2=A0 65.396712] =C2=A0[<f962cfcf>] add_inode_ref+0x28f/0x320 [btr=
fs]
> [ =C2=A0 65.396712] =C2=A0[<f962de69>] replay_one_buffer+0x239/0x320 =
[btrfs]
> [ =C2=A0 65.396712] =C2=A0[<f961cc97>] ? alloc_extent_buffer+0x77/0x3=
a0 [btrfs]
> [ =C2=A0 65.396712] =C2=A0[<f962b7a9>] walk_down_log_tree+0x1d9/0x370=
 [btrfs]
> [ =C2=A0 65.396712] =C2=A0[<f962b9d9>] walk_log_tree+0x99/0x1c0 [btrf=
s]
> [ =C2=A0 65.396712] =C2=A0[<f962f2fa>] btrfs_recover_log_trees+0x1da/=
0x2a0 [btrfs]
> [ =C2=A0 65.396712] =C2=A0[<f962dc30>] ? replay_one_dir_item+0xb0/0xb=
0 [btrfs]
> [ =C2=A0 65.396712] =C2=A0[<f95f6749>] open_ctree+0x1129/0x1490 [btrf=
s]
> [ =C2=A0 65.396712] =C2=A0[<c11ac7a9>] ? strlcpy+0x39/0x50
> [ =C2=A0 65.396712] =C2=A0[<f95d756b>] btrfs_mount+0x4ab/0x5b0 [btrfs=
]
> [ =C2=A0 65.396712] =C2=A0[<c1109d31>] mount_fs+0x31/0x170
> [ =C2=A0 65.396712] =C2=A0[<c11207ac>] vfs_kern_mount+0x4c/0x90
> [ =C2=A0 65.396712] =C2=A0[<c1120b49>] do_kern_mount+0x39/0xd0
> [ =C2=A0 65.396712] =C2=A0[<c1121e31>] do_mount+0x161/0x700
> [ =C2=A0 65.396712] =C2=A0[<c11226f6>] sys_mount+0x66/0xa0
> [ =C2=A0 65.396712] =C2=A0[<c1330edf>] sysenter_do_call+0x12/0x28
> [ =C2=A0 65.396712] Code: 44 24 08 00 00 00 00 89 4c 24 0c 8b 4d 08 8=
9 34 24 e8 73 cc fe ff 85 c0 0f 84 f0 fe ff ff 8b 5d f4 8b 75 f8 8b 7d =
fc 89 ec 5d c3 <0f> 0b 8b 81 d8 fe ff ff 8d 55 e3 b9 11 00 00 00 89 d7 =
05 03 01
> [ =C2=A0 65.396712] EIP: [<f9604072>] btrfs_add_link+0x172/0x200 [btr=
fs] SS:ESP 0068:eec77b48
> [ =C2=A0 65.397464] ---[ end trace 5f278c10a67bc917 ]---
> [ =C2=A0 65.519660] Adding 2561304k swap on /dev/mapper/swapDevice. =C2=
=A0Priority:-1 extents:1 across:2561304k
> [ =C2=A0 67.243199] microcode: CPU0 sig=3D0x106c2, pf=3D0x4, revision=
=3D0x20a
> [ =C2=A0 67.292031] microcode: CPU1 sig=3D0x106c2, pf=3D0x4, revision=
=3D0x20a
> [ =C2=A0 67.298402] microcode: Microcode Update Driver: v2.00 <tigran=
@aivazian.fsnet.co.uk>, Peter Oruba
> [ =C2=A0 67.305857] microcode: CPU0 updated to revision 0x218, date =3D=
 2009-04-10
> [ =C2=A0 67.315268] microcode: CPU1 updated to revision 0x218, date =3D=
 2009-04-10
> [ =C2=A0 70.985116] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [ =C2=A0 71.152025] Bluetooth: RFCOMM TTY layer initialized
> [ =C2=A0 71.156497] Bluetooth: RFCOMM socket layer initialized
> [ =C2=A0 71.160691] Bluetooth: RFCOMM ver 1.11
> [ =C2=A0118.324105] ip_tables: (C) 2000-2006 Netfilter Core Team
> [ =C2=A0118.574729] nf_conntrack version 0.5.0 (16384 buckets, 65536 =
max)
>
> --
>
> Marek Otahal :o)
>

I've been running into the same problem, with the same workaround.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
