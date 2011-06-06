From: Marek Otahal <markotahal@gmail.com>
Subject: kernel BUG at fs/btrfs/inode.c:4676!
Date: Mon, 6 Jun 2011 12:19:56 +0200
Message-ID: <201106061220.05696.markotahal@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10378600.RqnutFfbvi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart10378600.RqnutFfbvi
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,=20
the issue happens every time when i have to hard power-off my notebook (sus=
pend problems).=20
With kernel 2.6.39 the partition is unmountable, solution is to boot 2.6.38=
 kernel which=20
1/ is able to mount the partition,=20
2/ by doing that fixes the problem so later .39 (after clean shutdown) can =
mount it also.=20

Attached dmesg follows.=20

Thank you,=20
Mark

mount options:
/dev/mapper/homeDevice /home btrfs defaults,relatime,nodev,nosuid,compress-=
force=3Dlzo 0 2 # /dev/sda9 home

dmesg:
[   56.994241] loop: module loaded
[   57.172283] Btrfs loaded
[   57.191655] device label store devid 1 transid 26106 /dev/dm-3
[   57.218783] device label home devid 1 transid 450932 /dev/dm-2
[   57.459448] scsi 4:0:0:0: Direct-Access     Generic- Multi-Card       1.=
00 PQ: 0 ANSI: 0 CCS
[   57.460293] sd 4:0:0:0: Attached scsi generic sg1 type 0
[   57.467030] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[   61.585618] EXT4-fs (sda4): warning: checktime reached, running e2fsck i=
s recommended
[   61.671534] EXT4-fs (sda4): re-mounted. Opts: (null)
[   62.211037] device label home devid 1 transid 450932 /dev/mapper/homeDev=
ice
[   62.212058] btrfs: force lzo compression
[   65.335194] ------------[ cut here ]------------
[   65.335308] kernel BUG at fs/btrfs/inode.c:4676!
[   65.335406] invalid opcode: 0000 [#1] PREEMPT SMP=20
[   65.335532] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
[   65.337833] Modules linked in: btrfs zlib_deflate crc32c libcrc32c loop =
uas ums_realtek uvcvideo usb_storage msr videodev media btusb bluetooth sbs=
 sbshc arc4 ecb b43 mac80211 joydev cfg80211 ssb mmc_core pcmcia sg fuse tg=
3 uhci_hcd ideapad_laptop evdev sparse_keymap psmouse pcspkr snd_hda_codec_=
realtek iTCO_wdt iTCO_vendor_support rfkill serio_raw ehci_hcd snd_hda_inte=
l pcmcia_core i2c_i801 libphy usbcore ac wmi battery thermal snd_hda_codec =
snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc acpi_cpufreq freq_=
table processor mperf sha256_generic sha512_generic ext4 mbcache jbd2 crc16=
 cryptd aes_i586 aes_generic xts gf128mul dm_crypt dm_mod sd_mod ata_piix l=
ibata scsi_mod i915 drm_kms_helper drm i2c_algo_bit button i2c_core video i=
ntel_agp intel_gtt agpgart
[   65.337833]=20
[   65.337833] Pid: 883, comm: mount Not tainted 2.6.39-ARCH #1 LENOVO     =
                      41875QG         /Kuril                          =20
[   65.337833] EIP: 0060:[<f9604072>] EFLAGS: 00010282 CPU: 1
[   65.337833] EIP is at btrfs_add_link+0x172/0x200 [btrfs]
[   65.337833] EAX: ffffffef EBX: ef448908 ECX: 00000119 EDX: 00000111
[   65.337833] ESI: 004255d9 EDI: 00000020 EBP: eec77ba4 ESP: eec77b48
[   65.337833]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   65.337833] Process mount (pid: 883, ti=3Deec76000 task=3Df4c8c450 task.=
ti=3Deec76000)
[   65.337833] Stack:
[   65.396712]  00000020 004255d9 00000000 eec77b87 00000001 0000e55e 00000=
000 f960d6f8
[   65.396712]  eec77b88 eec77b8c eec77b90 eec77b94 ef472000 f5076800 ef448=
ba8 6f43c090
[   65.396712]  000046ab 01000000 00000000 00000000 00000000 0046ab6f 00000=
000 eec77c0c
[   65.396712] Call Trace:
[   65.396712]  [<f960d6f8>] ? btrfs_inode_ref_index+0xd8/0xe0 [btrfs]
[   65.396712]  [<f962cfcf>] add_inode_ref+0x28f/0x320 [btrfs]
[   65.396712]  [<f962de69>] replay_one_buffer+0x239/0x320 [btrfs]
[   65.396712]  [<f961cc97>] ? alloc_extent_buffer+0x77/0x3a0 [btrfs]
[   65.396712]  [<f962b7a9>] walk_down_log_tree+0x1d9/0x370 [btrfs]
[   65.396712]  [<f962b9d9>] walk_log_tree+0x99/0x1c0 [btrfs]
[   65.396712]  [<f962f2fa>] btrfs_recover_log_trees+0x1da/0x2a0 [btrfs]
[   65.396712]  [<f962dc30>] ? replay_one_dir_item+0xb0/0xb0 [btrfs]
[   65.396712]  [<f95f6749>] open_ctree+0x1129/0x1490 [btrfs]
[   65.396712]  [<c11ac7a9>] ? strlcpy+0x39/0x50
[   65.396712]  [<f95d756b>] btrfs_mount+0x4ab/0x5b0 [btrfs]
[   65.396712]  [<c1109d31>] mount_fs+0x31/0x170
[   65.396712]  [<c11207ac>] vfs_kern_mount+0x4c/0x90
[   65.396712]  [<c1120b49>] do_kern_mount+0x39/0xd0
[   65.396712]  [<c1121e31>] do_mount+0x161/0x700
[   65.396712]  [<c11226f6>] sys_mount+0x66/0xa0
[   65.396712]  [<c1330edf>] sysenter_do_call+0x12/0x28
[   65.396712] Code: 44 24 08 00 00 00 00 89 4c 24 0c 8b 4d 08 89 34 24 e8 =
73 cc fe ff 85 c0 0f 84 f0 fe ff ff 8b 5d f4 8b 75 f8 8b 7d fc 89 ec 5d c3 =
<0f> 0b 8b 81 d8 fe ff ff 8d 55 e3 b9 11 00 00 00 89 d7 05 03 01=20
[   65.396712] EIP: [<f9604072>] btrfs_add_link+0x172/0x200 [btrfs] SS:ESP =
0068:eec77b48
[   65.397464] ---[ end trace 5f278c10a67bc917 ]---
[   65.519660] Adding 2561304k swap on /dev/mapper/swapDevice.  Priority:-1=
 extents:1 across:2561304k=20
[   67.243199] microcode: CPU0 sig=3D0x106c2, pf=3D0x4, revision=3D0x20a
[   67.292031] microcode: CPU1 sig=3D0x106c2, pf=3D0x4, revision=3D0x20a
[   67.298402] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   67.305857] microcode: CPU0 updated to revision 0x218, date =3D 2009-04-=
10
[   67.315268] microcode: CPU1 updated to revision 0x218, date =3D 2009-04-=
10
[   70.985116] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   71.152025] Bluetooth: RFCOMM TTY layer initialized
[   71.156497] Bluetooth: RFCOMM socket layer initialized
[   71.160691] Bluetooth: RFCOMM ver 1.11
[  118.324105] ip_tables: (C) 2000-2006 Netfilter Core Team
[  118.574729] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)

=2D-=20

Marek Otahal :o)

--nextPart10378600.RqnutFfbvi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJN7KnNAAoJEKvC5zPWx/wKBcMP/1std6Kli6pswhX41XghJiZm
ExIna1d1QcZwIVJDBMmpoH/zaMHSsHFMNVzYneCE2neChiQ47yLGrbL9JaGWnN29
lVsgbo87qpY/GSpvACPZbMtxqJtjbZeV3UWv6F4BN+huVrAMbmizwl6db6dif3A+
Qr4xgVEqiqSoghOcRXShOuo7vJKAtB9f8pHMs+Eqg7r+tXzUXMNeF6CgfXHuJIdR
w27feliS8ls7Uk3/Mn3xUfTi/MO78gcWgW92aBvDK3sl1lEqO7t9K9SLKhaDgvfg
yet6skUCB/eddOXpRGyoL4T31cBisC0r2aRdi9eO0m0N9KtERUSzDB0cM6h9yBSA
+IVkf9VItGuBWSsrClpyhM9/kP0D0Mc4dA6gdIpTKcNl3gxqHXwTGxuhD8gHP7J2
qw9JORGKckgm9tTiJXFnuPncVwh3VByoGC5ewVlvnT88if1HlQlteD03FOxsQ9sN
JZonhke4qX7aE6UOzRWkUh8L53E3fQWBoINij+mQB4/lskMD7y6mpDMS0CaMdKxB
PJtjhAprau/RPTxSFz0Awnn3kzOhsIZsVUMgNHbSHICKMP8XfKOJ2Ot3tqFap3cX
2J+fs+mNFOnt3t821zFRu+VJav885doKEsDgo7gslEB8QhRSrWx55G+cNBA7sgGh
qzeg85eElY0p25BLPMGg
=ulnY
-----END PGP SIGNATURE-----

--nextPart10378600.RqnutFfbvi--
