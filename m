From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 3 Aug 2009 10:57:41 -0400
Message-ID: <20090803145741.GC3765@think>
References: <4A74401B.90801@mccme.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Raskin Michael <raskin@mccme.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A74401B.90801@mccme.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 01, 2009 at 05:16:11PM +0400, Raskin Michael wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> This is distinct from the old mass-symlinking warnings. I run a program
> which promised to hardlink all the same-content files on the partition.
> The failure occured reasonably quickly...

As Yan said on IRC there's a limit to the number of hardlinks per file
in a given directory.  We clearly need to change this from BUG() to
return a nice error.

-chris

> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.12 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJKdEAXAAoJEE6tnN0aWvw3IgYIAKWlV6BOJs46PxXqvou1tHL5
> OFnSfGsUh5NmI31cthO1M7Uzy0xQ3iZ48NINZbqb8BZac1NBUzSWNzJqqiDpFLb5
> 33m8hfLvcVxbGAutm7hhp5NCK8VUw9ej4ZFLU5CE9ViyT4dFyaZA6osMpJ5lueIw
> RnBdJStao01a7cMyEbY3WqUE/KxoPRU2s4cC1GuV5iHKL6iur9lGHOEQxcpL91yM
> 7Jw2pNLYGZ/LYToigVtPs2ZHSPlc/SKTBu9pDbRHmTebZ8LUBZQ/KCnaStm+x8ei
> dRx5ERmhRQWg4q09eGrQ8Bh0H2v68brReVf0Sx/QWaS3NLmeozbuubqZI8fvVOQ=
> =Vvs9
> -----END PGP SIGNATURE-----

> [102404.782966] BUG: unable to handle kernel NULL pointer dereference at (null)
> [102404.782982] IP: [<f9ea4ead>] PageUptodate+0x11/0x39 [btrfs]
> [102404.783028] *pdpt = 000000002270d001 *pde = 0000000000000000 
> [102404.783034] Oops: 0000 [#1] SMP 
> [102404.783039] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> [102404.783045] Modules linked in: arc4 ecb ath5k mac80211 led_class ath cfg80211 rfkill usblp raid456 raid6_pq async_xor async_memcpy async_tx xor raid1 raid0 af_packet md_mod snd_pcm_oss snd_mixer_oss video output ipv6 ipip tunnel4 radeon drm snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc ftdi_sio usbserial loop ati_agp agpgart p4_clockmod speedstep_lib 8139too mii kqemu fuse thermal thermal_sys hwmon ac battery tun usb_storage usb_libusual dm_mod ide_generic ide_gd_mod pata_marvell ata_piix sata_uli sata_sis pata_sis sata_via sata_nv xtkbd atkbd ohci_hcd ssb pcmcia pcmcia_core firmware_class ehci_hcd uhci_hcd usbhid hid usbcore unix btrfs zlib_deflate libcrc32c crc32c sd_mod crc_t10dif jfs nls_base xfs ex
 portfs ext3 jbd mbcache synaptics_i2c sermouse psmouse libps2 pcips2 i8042 serio evdev mousedev ide_cd_mod ide_core pktcdvd ahci sr_mod cdrom pata_atiixp libata scsi_mod radeonfb fb_ddc backlight i2c_algo_bit cfbcopyarea i2c_
> core cfbimgblt cfbfillrect fbcon fbdev tileblit font bitblit fbcon_rotate fbcon_cw fbcon_ud fbcon_ccw softcursor fb
> [102404.783172] 
> [102404.783178] Pid: 1355, comm: nix-store Not tainted (2.6.31-rc4 #1) X51RL               
> [102404.783182] EIP: 0060:[<f9ea4ead>] EFLAGS: 00210246 CPU: 0
> [102404.783219] EIP is at PageUptodate+0x11/0x39 [btrfs]
> [102404.783223] EAX: 00000000 EBX: 00000000 ECX: f3c48112 EDX: 00000012
> [102404.783227] ESI: efbded70 EDI: 000000ba EBP: d0aa1cb0 ESP: d0aa1cb0
> [102404.783230]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [102404.783235] Process nix-store (pid: 1355, ti=d0aa1000 task=eefd0000 task.ti=d0aa1000)
> [102404.783238] Stack:
> [102404.783240]  d0aa1cd0 f9ea608b f4d85e10 efbded70 000fbeb0 04150f46 efbded70 00000001
> [102404.783249] <0> d0aa1d28 f9e5e367 000000a8 04150f46 0000007e 00000000 f3c65690 f580f800
> [102404.783258] <0> f51f3360 00000010 00000040 d0aa1d10 c103e301 c103e655 00000163 00000010
> [102404.783268] Call Trace:
> [102404.783313]  [<f9ea608b>] ? copy_extent_buffer+0xb0/0x197 [btrfs]
> [102404.783352]  [<f9e5e367>] ? copy_for_split+0xd6/0x383 [btrfs]
> [102404.783361]  [<c103e301>] ? kunmap_atomic+0x75/0xaf
> [102404.783366]  [<c103e655>] ? kmap_atomic+0x22/0x32
> [102404.783409]  [<f9ea5be7>] ? write_extent_buffer+0x1cc/0x205 [btrfs]
> [102404.783448]  [<f9e610e2>] ? split_leaf+0x6e0/0x7a1 [btrfs]
> [102404.783488]  [<f9e63849>] ? btrfs_search_slot+0x8d9/0x9fc [btrfs]
> [102404.783527]  [<f9e63c77>] ? btrfs_insert_empty_items+0x58/0xea [btrfs]
> [102404.783568]  [<f9e7743d>] ? btrfs_insert_inode_ref+0x94/0x285 [btrfs]
> [102404.783610]  [<f9e89f8b>] ? btrfs_add_link+0xdf/0x154 [btrfs]
> [102404.783653]  [<f9e8a032>] ? btrfs_add_nondir+0x32/0x90 [btrfs]
> [102404.783695]  [<f9e8ad49>] ? btrfs_link+0x10f/0x23c [btrfs]
> [102404.783702]  [<c1221665>] ? security_inode_permission+0x46/0x56
> [102404.783719]  [<c118801b>] ? vfs_link+0x163/0x221
> [102404.783725]  [<c118c622>] ? sys_linkat+0x182/0x225
> [102404.783731]  [<c1175135>] ? sys_fchmodat+0x125/0x13d
> [102404.783736]  [<c117d9c6>] ? sys_lstat64+0x4c/0x60
> [102404.783742]  [<c118c6e7>] ? sys_link+0x22/0x32
> [102404.783748]  [<c1005543>] ? sysenter_do_call+0x12/0x28
> [102404.783751] Code: 0c 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 b8 fc aa ee f9 e8 c1 4c 23 c7 5d c3 90 90 55 89 e5 83 05 18 2b f0 f9 01 83 15 1c 2b f0 f9 00 <8b> 00 c1 e8 03 83 e0 01 74 1c 83 05 20 2b f0 f9 01 83 15 24 2b 
> [102404.783800] EIP: [<f9ea4ead>] PageUptodate+0x11/0x39 [btrfs] SS:ESP 0068:d0aa1cb0
> [102404.783838] CR2: 0000000000000000
> [102404.783843] ---[ end trace 5618f0a7ac8fd890 ]---
> 


