From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: btrfs on MIPS with 16K page size
Date: Wed, 27 Jul 2011 01:02:32 +0600
Message-ID: <20110727010232.553f8480@natsu>
References: <20110627010018.7133192e@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xm3VVBdolvuD92njUK16y+4"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110627010018.7133192e@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/xm3VVBdolvuD92njUK16y+4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Jun 2011 01:00:18 +0600
Roman Mamedov <rm@romanrm.ru> wrote:

> I am having some trouble with btrfs on the MIPS (Little Endian) architect=
ure.
>=20
> Linux hoshi 2.6.39-libre-lemote-rm1 #1 Sun May 29 17:48:16 YEKST 2011 mip=
s64 GNU/Linux
>=20
> btrfs-tools                0.19+20101101-1
>=20
> First of all, the kernel I use has a 16K page size; the only other option=
 here is 64K, but that
> one is experimental (and 4K pages can't be used). So my mkfs.btrfs looked=
 like this:=20
> ----------------------------------------
> # mkfs.btrfs /dev/sdb2=20
>=20
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>=20
> fs created label (null) on /dev/sdb2
> 	nodesize 16384 leafsize 16384 sectorsize 16384 size 55.79GB
> Btrfs Btrfs v0.19
> ----------------------------------------
> Then when mounting this newly-created FS I am getting this output in dmes=
g (but the FS seems to
> mount fine after that):
>=20
> [18483.211686] device fsid 4f4166647bc24d39-853307fabbe34bb0 devid 1 tran=
sid 10 /dev/sdb2
> [18483.216001] ------------[ cut here ]------------
> [18483.216301] WARNING: at fs/btrfs/extent_io.c:3824 write_extent_buffer+=
0x1b8/0x270 [btrfs]()
> [18483.216541] Modules linked in: btrfs zlib_deflate crc32c libcrc32c udf=
 crc_itu_t netconsole
> configfs usb_storage uas tun ipv6 option usb_wwan usbserial snd_cs5535aud=
io snd_ac97_codec
> ohci_hcd ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm ehci_hcd usbcore snd_=
timer snd
> loongson2_cpufreq nls_base soundcore r8169 snd_page_alloc
> [18483.217771] Call Trace:
> [18483.217898] [<ffffffff8076b5e8>] dump_stack+0x8/0x40
> [18483.218072] [<ffffffff8023dbc0>] warn_slowpath_common+0x78/0x160
> [18483.218319] [<ffffffffc0576cd0>] write_extent_buffer+0x1b8/0x270 [btrf=
s]
> [18483.218606] [<ffffffffc058c258>] btrfs_read_sys_array+0xa8/0x220 [btrf=
s]
> [18483.218895] [<ffffffffc0540948>] open_ctree+0x1000/0x1c68 [btrfs]
> [18483.219152] [<ffffffffc0506db8>] btrfs_mount+0x5a0/0x7d8 [btrfs]
> [18483.219372] [<ffffffff80343628>] mount_fs+0x58/0x1b8
> [18483.219541] [<ffffffff80365c9c>] do_kern_mount+0x74/0x178
> [18483.219716] [<ffffffff80367e98>] do_mount+0x690/0xac8
> [18483.219895] [<ffffffff8039c2e4>] compat_sys_mount+0x94/0x268
> [18483.220081] [<ffffffff802191f8>] handle_sys+0x158/0x178
> [18483.220248]=20
> [18483.220346] ---[ end trace 73234e8ad8eaf7bf ]---
>=20
> My questions are,
> - What's up with the warning in dmesg?
> - Can this filesystem (nodesize 16384 leafsize 16384 sectorsize 16384) be=
 mounted on an
>   x86 system with page size of 4K at all, if I move the disk there (didn'=
t try that yet)?
> - If not, isn't that suboptimal to have mkfs in some circumstances create=
 a
>   non-cross-architecture FS by default?
> - Can I force it make one by specifying -l 4096 -n 4096 -s 4096,
> - ...and then will I have no problems using such FS both on 16K and 4K-pa=
ged machines?

Forcing does not work:
----
root@hoshi:~# mkfs.btrfs -n 4096 -l 4096 -s 4096 /dev/etherd/e9.8=20
Illegal leafsize 4096
root@hoshi:~# mkfs.btrfs -n 4096 -s 4096 /dev/etherd/e9.8=20
Illegal nodesize 4096
----


Only setting sector size supposedly passes OK, but the result is still sect=
or size 16384:
----
root@hoshi:~# mkfs.btrfs -s 4096 /dev/etherd/e9.8=20

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/etherd/e9.8
	nodesize 16384 leafsize 16384 sectorsize 16384 size 29.80GB
Btrfs Btrfs v0.19
----


Also the issue still happens with kernel 3.0.0.
----
[  519.579806] Btrfs loaded
[  519.581140] device fsid a6200e33-9982-4002-849d-6df984154e5b devid 1 tra=
nsid 7 /dev/etherd/e9.8
[  519.585434] ------------[ cut here ]------------
[  519.586063] WARNING: at fs/btrfs/extent_io.c:3630 write_extent_buffer+0x=
1b8/0x270 [btrfs]()
[  519.586627] Modules linked in: btrfs zlib_deflate crc32c libcrc32c aoe f=
use ipv6 usb_storage uas ohci_hcd snd_cs5535audio snd_ac97_codec ac97_bus s=
nd_pcm_oss snd_mixer_oss snd_pcm ehci_hcd loongson2_cpufreq snd_timer snd u=
sbcore soundcore snd_page_alloc nls_base r8169
[  519.588700] Call Trace:
[  519.588964] [<ffffffff80774e14>] dump_stack+0x8/0x40
[  519.589360] [<ffffffff8023d7a0>] warn_slowpath_common+0x78/0x160
[  519.589857] [<ffffffffc03dbf00>] write_extent_buffer+0x1b8/0x270 [btrfs]
[  519.590411] [<ffffffffc03f0a90>] btrfs_read_sys_array+0xa8/0x218 [btrfs]
[  519.590955] [<ffffffffc03a5510>] open_ctree+0x1200/0x1e50 [btrfs]
[  519.591496] [<ffffffffc036ae68>] btrfs_mount+0x5a8/0x7e0 [btrfs]
[  519.591970] [<ffffffff80348c48>] mount_fs+0x58/0x1b8
[  519.592358] [<ffffffff8036b08c>] do_kern_mount+0x74/0x178
[  519.592758] [<ffffffff8036cd3c>] do_mount+0x694/0xad0
[  519.593147] [<ffffffff803a17fc>] compat_sys_mount+0x94/0x268
[  519.593575] [<ffffffff80219018>] handle_sys+0x158/0x178
[  519.593957]=20
[  519.594143] ---[ end trace 7792b9225987a9a5 ]---
----

--=20
With respect,
Roman

--Sig_/xm3VVBdolvuD92njUK16y+4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4vD0gACgkQTLKSvz+PZwjsJgCffHgWGD6quWd6kmxuCxYrcdtk
viwAoJaobyHFfB8xaMBaJP61rdu5U3ip
=j4QC
-----END PGP SIGNATURE-----

--Sig_/xm3VVBdolvuD92njUK16y+4--
