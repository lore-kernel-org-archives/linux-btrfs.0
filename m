From: Roman Mamedov <rm@romanrm.ru>
Subject: btrfs on MIPS with 16K page size
Date: Mon, 27 Jun 2011 01:00:18 +0600
Message-ID: <20110627010018.7133192e@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rFwTbOt0lzLCmKTvbg4XsHW"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/rFwTbOt0lzLCmKTvbg4XsHW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I am having some trouble with btrfs on the MIPS (Little Endian) architectur=
e.

Linux hoshi 2.6.39-libre-lemote-rm1 #1 Sun May 29 17:48:16 YEKST 2011 mips6=
4 GNU/Linux

btrfs-tools                0.19+20101101-1

First of all, the kernel I use has a 16K page size; the only other option h=
ere is 64K, but that
one is experimental (and 4K pages can't be used). So my mkfs.btrfs looked l=
ike this:=20
----------------------------------------
# mkfs.btrfs /dev/sdb2=20

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdb2
	nodesize 16384 leafsize 16384 sectorsize 16384 size 55.79GB
Btrfs Btrfs v0.19
----------------------------------------
Then when mounting this newly-created FS I am getting this output in dmesg =
(but the FS seems to
mount fine after that):

[18483.211686] device fsid 4f4166647bc24d39-853307fabbe34bb0 devid 1 transi=
d 10 /dev/sdb2
[18483.216001] ------------[ cut here ]------------
[18483.216301] WARNING: at fs/btrfs/extent_io.c:3824 write_extent_buffer+0x=
1b8/0x270 [btrfs]()
[18483.216541] Modules linked in: btrfs zlib_deflate crc32c libcrc32c udf c=
rc_itu_t netconsole
configfs usb_storage uas tun ipv6 option usb_wwan usbserial snd_cs5535audio=
 snd_ac97_codec
ohci_hcd ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm ehci_hcd usbcore snd_ti=
mer snd
loongson2_cpufreq nls_base soundcore r8169 snd_page_alloc
[18483.217771] Call Trace:
[18483.217898] [<ffffffff8076b5e8>] dump_stack+0x8/0x40
[18483.218072] [<ffffffff8023dbc0>] warn_slowpath_common+0x78/0x160
[18483.218319] [<ffffffffc0576cd0>] write_extent_buffer+0x1b8/0x270 [btrfs]
[18483.218606] [<ffffffffc058c258>] btrfs_read_sys_array+0xa8/0x220 [btrfs]
[18483.218895] [<ffffffffc0540948>] open_ctree+0x1000/0x1c68 [btrfs]
[18483.219152] [<ffffffffc0506db8>] btrfs_mount+0x5a0/0x7d8 [btrfs]
[18483.219372] [<ffffffff80343628>] mount_fs+0x58/0x1b8
[18483.219541] [<ffffffff80365c9c>] do_kern_mount+0x74/0x178
[18483.219716] [<ffffffff80367e98>] do_mount+0x690/0xac8
[18483.219895] [<ffffffff8039c2e4>] compat_sys_mount+0x94/0x268
[18483.220081] [<ffffffff802191f8>] handle_sys+0x158/0x178
[18483.220248]=20
[18483.220346] ---[ end trace 73234e8ad8eaf7bf ]---

My questions are,
- What's up with the warning in dmesg?
- Can this filesystem (nodesize 16384 leafsize 16384 sectorsize 16384) be m=
ounted on an
  x86 system with page size of 4K at all, if I move the disk there (didn't =
try that yet)?
- If not, isn't that suboptimal to have mkfs in some circumstances create a
  non-cross-architecture FS by default?
- Can I force it make one by specifying -l 4096 -n 4096 -s 4096,
- ...and then will I have no problems using such FS both on 16K and 4K-page=
d machines?

--=20
With respect,
Roman

--Sig_/rFwTbOt0lzLCmKTvbg4XsHW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4HgcIACgkQTLKSvz+PZwiPzACffvZtW0ZrnZjNQZ8u8lAEI9wN
rYwAoIZ7/7EMAhuKGTn79ZSA/QELZ3Aj
=Nv7H
-----END PGP SIGNATURE-----

--Sig_/rFwTbOt0lzLCmKTvbg4XsHW--
