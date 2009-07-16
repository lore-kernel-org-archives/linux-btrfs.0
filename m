From: Michael Raskin <a0091f122@rambler.ru>
Subject: Btrfs warnings: -rc2
Date: Thu, 16 Jul 2009 18:36:09 +0400
Message-ID: <4A5F3AD9.5040005@rambler.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060400070809020403030809"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060400070809020403030809
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit

	I checked the same usage scenario with -rc2 kernel..

	Looks like it is just because of allmodconfig. Interesting fact,
though: now warnings are thrown on on-disk operations, errors are on
rbtree operations.

--------------060400070809020403030809
Content-Type: text/plain;
 name="btrfs.warn"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="btrfs.warn"

[  781.230303] ------------[ cut here ]------------
[  781.230368] WARNING: at fs/btrfs/inode.c:3117 inode_tree_add+0xd0/0x16=
2 [btrfs]()
[  781.230371] Hardware name: X51RL
[  781.230374] Modules linked in: usblp raid456 raid6_pq async_xor async_=
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
[  781.230479] Pid: 25678, comm: perl Not tainted 2.6.31-rc2 #1
[  781.230482] Call Trace:
[  781.230523]  [<f8c16113>] ? inode_tree_add+0xd0/0x162 [btrfs]
[  781.230532]  [<c106412d>] warn_slowpath_common+0xe0/0x148
[  781.230538]  [<c10641be>] warn_slowpath_null+0x29/0x3a
[  781.230579]  [<f8c16113>] inode_tree_add+0xd0/0x162 [btrfs]
[  781.230621]  [<f8c1c933>] btrfs_iget+0x6cb/0x6f8 [btrfs]
[  781.230627]  [<c103f829>] ? kmap_atomic+0x22/0x32
[  781.230669]  [<f8c1cbe8>] btrfs_lookup_dentry+0x288/0x2d1 [btrfs]
[  781.230711]  [<f8c1cc68>] btrfs_lookup+0x37/0x82 [btrfs]
[  781.230728]  [<c1185273>] do_lookup+0x153/0x2cb
[  781.230733]  [<c1186bb6>] __link_path_walk+0xcf8/0xf61
[  781.230738]  [<c1187951>] path_walk+0xb4/0x19b
[  781.230743]  [<c1189c33>] do_path_lookup+0x4f/0x193
[  781.230748]  [<c118c423>] user_path_at+0x94/0xe4
[  781.230755]  [<c117d819>] vfs_fstatat+0x5f/0xc0
[  781.230761]  [<c117d906>] vfs_lstat+0x24/0x34
[  781.230766]  [<c117d938>] sys_lstat64+0x22/0x60
[  781.230772]  [<c1005523>] sysenter_do_call+0x12/0x28
[  781.230776] ---[ end trace aefd5bf8b0fdf91e ]---

--------------060400070809020403030809--
