From: Michael Raskin <a0091f122@rambler.ru>
Subject: OOPS with btrfs on -rc2: trace
Date: Thu, 16 Jul 2009 18:40:11 +0400
Message-ID: <4A5F3BCB.7050405@rambler.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050205050802040004020700"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050205050802040004020700
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit

The same tons-of-symlinking activity

--------------050205050802040004020700
Content-Type: text/plain;
 name="btrfs.fail4"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="btrfs.fail4"

[ 1104.390880] BUG: unable to handle kernel NULL pointer dereference at 0=
0000008
[ 1104.390887] IP: [<c1298272>] __rb_rotate_left+0x12/0x8c
[ 1104.390895] *pdpt =3D 0000000034d5c001 *pde =3D 0000000000000000=20
[ 1104.390901] Oops: 0000 [#1] SMP=20
[ 1104.390905] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scal=
ing_cur_freq
[ 1104.390912] Modules linked in: usblp raid456 raid6_pq async_xor async_=
memcpy async_tx xor snd_pcm_oss snd_mixer_oss raid1 af_packet raid0 md_mo=
d ipv6 ipip tunnel4 radeon drm snd_hda_codec_si3054 snd_hda_codec_realtek=
 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore sn=
d_page_alloc atiixp ftdi_sio usbserial loop ati_agp agpgart p4_clockmod s=
peedstep_lib 8139too mii kqemu fuse thermal thermal_sys hwmon ac battery =
asus_laptop backlight led_class tun usb_storage usb_libusual dm_mod ide_g=
eneric ide_gd_mod ide_cd_mod ide_core sr_mod cdrom pata_marvell ata_piix =
sata_uli sata_sis pata_sis sata_via sata_nv ahci fbdev xtkbd atkbd ohci_h=
cd ssb pcmcia pcmcia_core firmware_class ehci_hcd uhci_hcd usbhid hid usb=
core unix btrfs zlib_deflate libcrc32c crc32c libata sd_mod scsi_mod crc_=
t10dif jfs nls_base xfs exportfs ext3 jbd mbcache synaptics_i2c i2c_core =
sermouse psmouse libps2 pcips2 i8042 serio evdev mousedev
[ 1104.391014]=20
[ 1104.391018] Pid: 18699, comm: perl Tainted: G        W  (2.6.31-rc2 #1=
) X51RL              =20
[ 1104.391022] EIP: 0060:[<c1298272>] EFLAGS: 00010282 CPU: 0
[ 1104.391028] EIP is at __rb_rotate_left+0x12/0x8c
[ 1104.391031] EAX: e60a4fec EBX: 00000000 ECX: c1034f3b EDX: e70d20bc
[ 1104.391035] ESI: e60a4fec EDI: f58bfa64 EBP: ee56dd4c ESP: ee56dd40
[ 1104.391039]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.391043] Process perl (pid: 18699, ti=3Dee56d000 task=3Df109bd90 ta=
sk.ti=3Dee56d000)
[ 1104.391046] Stack:
[ 1104.391049]  e2e34adc e2e34adc e60a4fec ee56dd68 c12984c4 f58bfa64 e28=
41c94 e2e34adc
[ 1104.391057] <0> e2841cfc e75405d4 ee56dd84 f8c16174 f58bf800 e2841bd8 =
e2841cfc ee56ddbc
[ 1104.391066] <0> 00000000 ee56dddc f8c1c933 0033c53f 80000000 fffff000 =
e2841bd8 00000011
[ 1104.391076] Call Trace:
[ 1104.391082]  [<c12984c4>] ? rb_insert_color+0x14c/0x19d
[ 1104.391120]  [<f8c16174>] ? inode_tree_add+0x131/0x162 [btrfs]
[ 1104.391162]  [<f8c1c933>] ? btrfs_iget+0x6cb/0x6f8 [btrfs]
[ 1104.391168]  [<c103f829>] ? kmap_atomic+0x22/0x32
[ 1104.391210]  [<f8c1cbe8>] ? btrfs_lookup_dentry+0x288/0x2d1 [btrfs]
[ 1104.391253]  [<f8c1cc68>] ? btrfs_lookup+0x37/0x82 [btrfs]
[ 1104.391268]  [<c1185273>] ? do_lookup+0x153/0x2cb
[ 1104.391274]  [<c1186bb6>] ? __link_path_walk+0xcf8/0xf61
[ 1104.391279]  [<c1187951>] ? path_walk+0xb4/0x19b
[ 1104.391284]  [<c1189c33>] ? do_path_lookup+0x4f/0x193
[ 1104.391289]  [<c118c423>] ? user_path_at+0x94/0xe4
[ 1104.391296]  [<c117d819>] ? vfs_fstatat+0x5f/0xc0
[ 1104.391301]  [<c117d906>] ? vfs_lstat+0x24/0x34
[ 1104.391307]  [<c117d938>] ? sys_lstat64+0x22/0x60
[ 1104.391312]  [<c1005523>] ? sysenter_do_call+0x12/0x28
[ 1104.391316] Code: 00 00 8d 65 f8 5b 5e 5d c3 55 89 e5 b8 04 b7 63 c1 e=
8 a8 15 e4 ff 5d c3 90 55 89 e5 57 56 53 89 c6 89 d7 8b 58 04 8b 10 83 e2=
 fc <8b> 4b 08 89 48 04 85 c9 74 17 8b 01 83 e0 03 09 f0 89 01 83 05=20
[ 1104.391364] EIP: [<c1298272>] __rb_rotate_left+0x12/0x8c SS:ESP 0068:e=
e56dd40
[ 1104.391371] CR2: 0000000000000008
[ 1104.391376] ---[ end trace aefd5bf8b0fdf921 ]---


--------------050205050802040004020700--
