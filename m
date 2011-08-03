From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: BTRFS partition won't mount
Date: Wed, 3 Aug 2011 21:50:31 +0100
Message-ID: <20110803205031.GA18558@carfax.org.uk>
References: <1F6ED4EA7957EB4FADAE461E036D456A25D75644F9@exch01lex.ceradyne.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Adam Newby <anewby@ceradyne.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1F6ED4EA7957EB4FADAE461E036D456A25D75644F9@exch01lex.ceradyne.com>
List-ID: <linux-btrfs.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 03, 2011 at 04:46:01PM -0400, Adam Newby wrote:
> I recently had a power failure and can no longer mount my /home
> directory. The harddrive has two BTRFS partitions: sda7(/) and
> sda8(/home). The / partition loads up just fine, but /home does
> not. I've tried btrfsck as shown below and I've included dmesg
> pertaining to btrfs. This is on ArchLinux and the software versions
> are as follows:
> btrfs-progs-unstable 0.19.20101006-1
> linux 3.0

   Try the instructions on the wiki at [1]. (And please feed back
and/or fix any issues you have with the instructions -- they're still
quite new and probably have awkward corners).

> I actually have quite a bit of data on this partition that I would
> rather not lose. Please help!

   You *really* need to think about making good backups (otherwise
we'll have to set the cwillu on you).

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mount_my_filesystem.2C_and_I_get_a_kernel_oops.21

> Thanks,
> Adam
> 
> btrfsck /dev/sda8:
> found 152764059648 bytes used err is 1
> total csum bytes: 148756860
> total tree bytes: 436686848
> total fs tree bytes: 160870400
> btree space waste bytes: 110424811
> file data blocks allocated: 4925582483456
>  referenced 114231959552
> Btrfs Btrfs v0.19
> root 5 inode 738980 errors 400
> root 5 inode 771936 errors 400
> root 5 inode 771937 errors 400
> root 5 inode 771938 errors 400
> root 5 inode 771939 errors 400
> root 5 inode 771941 errors 400
> root 5 inode 771942 errors 400
> 
> dmesg |grep btrfs
> [   15.148281] btrfs: unlinked 13 orphans
> [   27.156006] kernel BUG at fs/btrfs/inode.c:4586!
> [   27.156124] Modules linked in: vboxnetflt vboxdrv snd_hda_codec_hdmi joydev usbhid hid snd_hda_codec_idt snd_hda_intel snd_hda_codec sdhci_pci sdhci psmouse snd_pcm snd_hwdep btusb firewire_ohci bluetooth crc16 dell_wmi sg nvidia(P) firewire_core arc4 snd_timer evdev serio_raw sparse_keymap i2c_i801 iwlagn mmc_core snd battery video soundcore intel_ips wmi ppdev dell_laptop parport_pc container button ac mac80211 cfg80211 pcspkr rfkill parport dcdbas iTCO_wdt i2c_core crc_itu_t iTCO_vendor_support intel_agp snd_page_alloc processor intel_gtt e1000e btrfs zlib_deflate crc32c libcrc32c ext2 mbcache ehci_hcd usbcore sr_mod cdrom sd_mod ahci libahci libata scsi_mod
> [   27.157096] RIP: 0010:[<ffffffffa010b781>]  [<ffffffffa010b781>] btrfs_add_link+0x161/0x1c0 [btrfs]
> [   27.158176]  [<ffffffffa013482f>] add_inode_ref+0x30f/0x3d0 [btrfs]
> [   27.158245]  [<ffffffffa013567b>] replay_one_buffer+0x2bb/0x3b0 [btrfs]
> [   27.158318]  [<ffffffffa0122f27>] ? alloc_extent_buffer+0x87/0x3d0 [btrfs]
> [   27.158391]  [<ffffffffa0132cd1>] walk_down_log_tree+0x391/0x540 [btrfs]
> [   27.160851]  [<ffffffffa0132f7d>] walk_log_tree+0xfd/0x270 [btrfs]
> [   27.165784]  [<ffffffffa0136d11>] btrfs_recover_log_trees+0x211/0x300 [btrfs]
> [   27.168297]  [<ffffffffa01353c0>] ? replay_one_dir_item+0xe0/0xe0 [btrfs]
> [   27.170832]  [<ffffffffa00fd907>] open_ctree+0x13e7/0x17a0 [btrfs]
> [   27.178506]  [<ffffffffa00d879e>] btrfs_mount+0x40e/0x5c0 [btrfs]
> [   27.212137] RIP  [<ffffffffa010b781>] btrfs_add_link+0x161/0x1c0 [btrfs]

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- "You got very nice eyes, Deedee. Never noticed them ---       
                           before. They real?"                           

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOObSXIKyzvlFcI40RAl2xAJ9XQR2JmqMGVfVa5WA+x6SKbJFrnACfRist
i1R0ySxggLROhypozfYdmeg=
=XMYh
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
