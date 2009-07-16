From: Michael Raskin <a0091f122@rambler.ru>
Subject: BTRFS warnings on the tons-of-symlinks operations
Date: Thu, 16 Jul 2009 17:42:33 +0400
Message-ID: <4A5F2E49.2010105@rambler.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090406060508040704070907"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090406060508040704070907
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit

These warnings occur in the process of creating lots of symlinks before
system hangs (well, this time I was luckier and system didn't hang..)

I checked: when system hanged, it was always the same offset in the same
function. I failed to get more good traces. I send the best I got.

After lots of attempts I passed the usual hanging step.. With lots of
warnings I already mentioned.

--------------090406060508040704070907
Content-Type: text/plain;
 name="btrfs.warn"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="btrfs.warn"

[  190.218701] ------------[ cut here ]------------
[  190.218770] WARNING: at fs/btrfs/inode.c:3116 inode_tree_add+0xd0/0x16=
2 [btrfs]()
[  190.218774] Hardware name: X51RL              =20
[  190.218776] Modules linked in: raid456 raid6_pq async_xor async_memcpy=
 async_tx xor raid1 snd_pcm_oss snd_mixer_oss raid0 af_packet md_mod ipv6=
 ipip tunnel4 radeon drm snd_hda_codec_si3054 snd_hda_codec_realtek snd_h=
da_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page=
_alloc atiixp ftdi_sio usbserial loop ati_agp agpgart p4_clockmod speedst=
ep_lib 8139too mii kqemu fuse thermal thermal_sys hwmon ac battery asus_l=
aptop backlight led_class tun usb_storage usb_libusual dm_mod ide_generic=
 ide_gd_mod ide_cd_mod ide_core sr_mod cdrom pata_marvell ata_piix sata_u=
li sata_sis pata_sis sata_via sata_nv ahci fbdev xtkbd atkbd ohci_hcd ssb=
 pcmcia pcmcia_core firmware_class ehci_hcd uhci_hcd usbhid hid usbcore u=
nix btrfs zlib_deflate libcrc32c crc32c libata sd_mod scsi_mod crc_t10dif=
 jfs nls_base xfs exportfs ext3 jbd mbcache synaptics_i2c i2c_core sermou=
se psmouse libps2 pcips2 i8042 serio evdev mousedev
[  190.218882] Pid: 4675, comm: perl Not tainted 2.6.31-rc3 #1
[  190.218885] Call Trace:
[  190.218928]  [<f8c17117>] ? inode_tree_add+0xd0/0x162 [btrfs]
[  190.218937]  [<c1062acd>] warn_slowpath_common+0xe0/0x148
[  190.218942]  [<c1062b5e>] warn_slowpath_null+0x29/0x3a
[  190.218985]  [<f8c17117>] inode_tree_add+0xd0/0x162 [btrfs]
[  190.219027]  [<f8c1d936>] btrfs_iget+0x6cb/0x6f8 [btrfs]
[  190.219034]  [<c103e22d>] ? kmap_atomic+0x22/0x32
[  190.219077]  [<f8c1dbeb>] btrfs_lookup_dentry+0x288/0x2d1 [btrfs]
[  190.219120]  [<f8c1dc6b>] btrfs_lookup+0x37/0x82 [btrfs]
[  190.219137]  [<c1182ebb>] do_lookup+0x153/0x2cb
[  190.219142]  [<c11847fe>] __link_path_walk+0xcf8/0xf61
[  190.219147]  [<c1185599>] path_walk+0xb4/0x19b
[  190.219152]  [<c118787b>] do_path_lookup+0x4f/0x193
[  190.219157]  [<c118a06b>] user_path_at+0x94/0xe4
[  190.219165]  [<c117b499>] vfs_fstatat+0x5f/0xc0
[  190.219170]  [<c117b586>] vfs_lstat+0x24/0x34
[  190.219175]  [<c117b5b8>] sys_lstat64+0x22/0x60
[  190.219182]  [<c1005523>] sysenter_do_call+0x12/0x28
[  190.219186] ---[ end trace ce4ad504bff439c7 ]---
[  215.132710] ------------[ cut here ]------------
[  215.132773] WARNING: at fs/btrfs/inode.c:3116 inode_tree_add+0xd0/0x16=
2 [btrfs]()
[  215.132777] Hardware name: X51RL              =20
[  215.132780] Modules linked in: raid456 raid6_pq async_xor async_memcpy=
 async_tx xor raid1 snd_pcm_oss snd_mixer_oss raid0 af_packet md_mod ipv6=
 ipip tunnel4 radeon drm snd_hda_codec_si3054 snd_hda_codec_realtek snd_h=
da_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page=
_alloc atiixp ftdi_sio usbserial loop ati_agp agpgart p4_clockmod speedst=
ep_lib 8139too mii kqemu fuse thermal thermal_sys hwmon ac battery asus_l=
aptop backlight led_class tun usb_storage usb_libusual dm_mod ide_generic=
 ide_gd_mod ide_cd_mod ide_core sr_mod cdrom pata_marvell ata_piix sata_u=
li sata_sis pata_sis sata_via sata_nv ahci fbdev xtkbd atkbd ohci_hcd ssb=
 pcmcia pcmcia_core firmware_class ehci_hcd uhci_hcd usbhid hid usbcore u=
nix btrfs zlib_deflate libcrc32c crc32c libata sd_mod scsi_mod crc_t10dif=
 jfs nls_base xfs exportfs ext3 jbd mbcache synaptics_i2c i2c_core sermou=
se psmouse libps2 pcips2 i8042 serio evdev mousedev
[  215.132885] Pid: 4675, comm: perl Tainted: G        W  2.6.31-rc3 #1
[  215.132888] Call Trace:
[  215.132929]  [<f8c17117>] ? inode_tree_add+0xd0/0x162 [btrfs]
[  215.132939]  [<c1062acd>] warn_slowpath_common+0xe0/0x148
[  215.132945]  [<c1062b5e>] warn_slowpath_null+0x29/0x3a
[  215.132986]  [<f8c17117>] inode_tree_add+0xd0/0x162 [btrfs]
[  215.133028]  [<f8c1d936>] btrfs_iget+0x6cb/0x6f8 [btrfs]
[  215.133035]  [<c103e22d>] ? kmap_atomic+0x22/0x32
[  215.133078]  [<f8c1dbeb>] btrfs_lookup_dentry+0x288/0x2d1 [btrfs]
[  215.133120]  [<f8c1dc6b>] btrfs_lookup+0x37/0x82 [btrfs]
[  215.133136]  [<c1182ebb>] do_lookup+0x153/0x2cb
[  215.133141]  [<c11847fe>] __link_path_walk+0xcf8/0xf61
[  215.133146]  [<c1185599>] path_walk+0xb4/0x19b
[  215.133151]  [<c118787b>] do_path_lookup+0x4f/0x193
[  215.133157]  [<c118a06b>] user_path_at+0x94/0xe4
[  215.133164]  [<c117b499>] vfs_fstatat+0x5f/0xc0
[  215.133169]  [<c117b586>] vfs_lstat+0x24/0x34
[  215.133175]  [<c117b5b8>] sys_lstat64+0x22/0x60
[  215.133181]  [<c1005523>] sysenter_do_call+0x12/0x28
[  215.133186] ---[ end trace ce4ad504bff439c8 ]---
[  216.230921] ------------[ cut here ]------------
[  216.230988] WARNING: at fs/btrfs/inode.c:3116 inode_tree_add+0xd0/0x16=
2 [btrfs]()
[  216.230992] Hardware name: X51RL              =20
[  216.230995] Modules linked in: raid456 raid6_pq async_xor async_memcpy=
 async_tx xor raid1 snd_pcm_oss snd_mixer_oss raid0 af_packet md_mod ipv6=
 ipip tunnel4 radeon drm snd_hda_codec_si3054 snd_hda_codec_realtek snd_h=
da_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page=
_alloc atiixp ftdi_sio usbserial loop ati_agp agpgart p4_clockmod speedst=
ep_lib 8139too mii kqemu fuse thermal thermal_sys hwmon ac battery asus_l=
aptop backlight led_class tun usb_storage usb_libusual dm_mod ide_generic=
 ide_gd_mod ide_cd_mod ide_core sr_mod cdrom pata_marvell ata_piix sata_u=
li sata_sis pata_sis sata_via sata_nv ahci fbdev xtkbd atkbd ohci_hcd ssb=
 pcmcia pcmcia_core firmware_class ehci_hcd uhci_hcd usbhid hid usbcore u=
nix btrfs zlib_deflate libcrc32c crc32c libata sd_mod scsi_mod crc_t10dif=
 jfs nls_base xfs exportfs ext3 jbd mbcache synaptics_i2c i2c_core sermou=
se psmouse libps2 pcips2 i8042 serio evdev mousedev
[  216.231101] Pid: 4675, comm: perl Tainted: G        W  2.6.31-rc3 #1
[  216.231104] Call Trace:
[  216.231145]  [<f8c17117>] ? inode_tree_add+0xd0/0x162 [btrfs]
[  216.231155]  [<c1062acd>] warn_slowpath_common+0xe0/0x148
[  216.231160]  [<c1062b5e>] warn_slowpath_null+0x29/0x3a
[  216.231203]  [<f8c17117>] inode_tree_add+0xd0/0x162 [btrfs]
[  216.231245]  [<f8c1d936>] btrfs_iget+0x6cb/0x6f8 [btrfs]
[  216.231252]  [<c103e22d>] ? kmap_atomic+0x22/0x32
[  216.231295]  [<f8c1dbeb>] btrfs_lookup_dentry+0x288/0x2d1 [btrfs]
[  216.231337]  [<f8c1dc6b>] btrfs_lookup+0x37/0x82 [btrfs]
[  216.231354]  [<c1182ebb>] do_lookup+0x153/0x2cb
[  216.231359]  [<c11847fe>] __link_path_walk+0xcf8/0xf61
[  216.231365]  [<c1185599>] path_walk+0xb4/0x19b
[  216.231370]  [<c118787b>] do_path_lookup+0x4f/0x193
[  216.231375]  [<c118a06b>] user_path_at+0x94/0xe4
[  216.231382]  [<c117b499>] vfs_fstatat+0x5f/0xc0
[  216.231387]  [<c117b586>] vfs_lstat+0x24/0x34
[  216.231392]  [<c117b5b8>] sys_lstat64+0x22/0x60
[  216.231399]  [<c1005523>] sysenter_do_call+0x12/0x28
[  216.231404] ---[ end trace ce4ad504bff439c9 ]---
[  219.769624] ------------[ cut here ]------------
[  219.769702] WARNING: at fs/btrfs/inode.c:3116 inode_tree_add+0xd0/0x16=
2 [btrfs]()
[  219.769707] Hardware name: X51RL              =20
[  219.769709] Modules linked in: raid456 raid6_pq async_xor async_memcpy=
 async_tx xor raid1 snd_pcm_oss snd_mixer_oss raid0 af_packet md_mod ipv6=
 ipip tunnel4 radeon drm snd_hda_codec_si3054 snd_hda_codec_realtek snd_h=
da_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page=
_alloc atiixp ftdi_sio usbserial loop ati_agp agpgart p4_clockmod speedst=
ep_lib 8139too mii kqemu fuse thermal thermal_sys hwmon ac battery asus_l=
aptop backlight led_class tun usb_storage usb_libusual dm_mod ide_generic=
 ide_gd_mod ide_cd_mod ide_core sr_mod cdrom pata_marvell ata_piix sata_u=
li sata_sis pata_sis sata_via sata_nv ahci fbdev xtkbd atkbd ohci_hcd ssb=
 pcmcia pcmcia_core firmware_class ehci_hcd uhci_hcd usbhid hid usbcore u=
nix btrfs zlib_deflate libcrc32c crc32c libata sd_mod scsi_mod crc_t10dif=
 jfs nls_base xfs exportfs ext3 jbd mbcache synaptics_i2c i2c_core sermou=
se psmouse libps2 pcips2 i8042 serio evdev mousedev
[  219.769846] Pid: 4675, comm: perl Tainted: G        W  2.6.31-rc3 #1
[  219.769850] Call Trace:
[  219.769896]  [<f8c17117>] ? inode_tree_add+0xd0/0x162 [btrfs]
[  219.769907]  [<c1062acd>] warn_slowpath_common+0xe0/0x148
[  219.769912]  [<c1062b5e>] warn_slowpath_null+0x29/0x3a
[  219.769955]  [<f8c17117>] inode_tree_add+0xd0/0x162 [btrfs]
[  219.769997]  [<f8c1d936>] btrfs_iget+0x6cb/0x6f8 [btrfs]
[  219.770026]  [<c103e22d>] ? kmap_atomic+0x22/0x32
[  219.770071]  [<f8c1dbeb>] btrfs_lookup_dentry+0x288/0x2d1 [btrfs]
[  219.770114]  [<f8c1dc6b>] btrfs_lookup+0x37/0x82 [btrfs]
[  219.770131]  [<c1182ebb>] do_lookup+0x153/0x2cb
[  219.770136]  [<c11847fe>] __link_path_walk+0xcf8/0xf61
[  219.770141]  [<c1185599>] path_walk+0xb4/0x19b
[  219.770146]  [<c118787b>] do_path_lookup+0x4f/0x193
[  219.770151]  [<c118a06b>] user_path_at+0x94/0xe4
[  219.770159]  [<c117b499>] vfs_fstatat+0x5f/0xc0
[  219.770164]  [<c117b586>] vfs_lstat+0x24/0x34
[  219.770169]  [<c117b5b8>] sys_lstat64+0x22/0x60
[  219.770176]  [<c1005523>] sysenter_do_call+0x12/0x28
[  219.770181] ---[ end trace ce4ad504bff439ca ]---
[  344.554787] usbcore: registered new interface driver usblp
[  345.834544] warning: `named' uses 32-bit capabilities (legacy support =
in use)

--------------090406060508040704070907
Content-Type: text/plain;
 name="btrfs.fail2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfs.fail2"

[  389.505428] BUG: unable to handle kernel NULL pointer dereference at 00000008[  389.505592] IP: [<c1295e76>] __rb_rotate_left+0x12/0x8c
[  389.505704] *pdpt = 00000000291d1001 *pde = 0000000000000000
[  389.505855] Oops: 0000 [#1] SMP
[  389.506003] last sysfs file: /sys/class/power_supply/BAT0/energy_full
[  389.508706]
[  389.508706] Pid: 4751, comm: perl Tainted: G        W  (2.6.31-rc3 #1) X51RL

[  389.508706] EIP: 0060:[<c1295e76>] EFLAGS: 00010282 CPU: 0
[  389.508706] EIP is at __rb_rotate_left+0x12/0x8c
[  389.508706] EAX: e543e0bc EBX: 00000000 ECX: c103393f EDX: e7de4d64
[  389.508706] ESI: e543e0bc EDI: f58f7a64 EBP: e95b2d4c ESP: e95b2d40
[  389.508706]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  389.508706] Process perl (pid: 4751, ti=e95b2000 task=e940a4f0 task.ti=e95b2000)
[  389.508706] Stack:

--------------090406060508040704070907--
