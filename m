Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39596 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbcEZJAs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 05:00:48 -0400
Date: Thu, 26 May 2016 09:00:44 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs on disk consistency
Message-ID: <20160526090044.GN16712@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xdWF/UuCWMRSqXrg"
In-Reply-To: <loom.20160526T103320-318@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <loom.20160526T103320-318@post.gmane.org>


--xdWF/UuCWMRSqXrg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 26, 2016 at 08:47:39AM +0000, sri wrote:
> In traditional file systems such as ext3/ext4 when a snapshot (say with=
=20
> LVM2) is taken, all I/O are frozen and entire file system including meta=
=20
> dta is part of snapshot.=20
>=20
> Btrfs snapshot also managed by file system itself and btrfs snapshot is=
=20
> actually does a sub volume snapshot which makes a portion of logical=20
> entity can be made read only so that no I/Os happen to that tree.
>=20
> Since snapshot is at sub volume level, other metadata such as extent tree=
,=20
> chunk tree, super block etc.. will still in active state and I/Os can go=
=20
> on them will not get flushed to disk (which is not required for btrfs sub=
=20
> volume snapshot).
>=20
>=20
> Since btrfs is always consistent (With COW and check-sum), does it holds=
=20
> good if I copy blocks at disk level to another disk starting form 0 to en=
d=20
> of disk ?
> My guess is NO.

   Correct.

> Or is there a way to freeze I/Os at btrfs level so that entire metadata i=
s=20
> flushed to the disk ( all trees such as extent tree, chunk tree or what=
=20
> ever metadata of btrfs file system used at VFS layer) so that  disk to=20
> disk copy can be triggered so that I will be having all sub volumes are=
=20
> copied to an alternate disk which I should be able to use on another=20
> machine or if the original disk is gone for toss.=20

   Na=EFvely, doing that within btrfs would effectively hang the FS for
the lifetime of the suspension, so it would be a really bad idea.

   In general, this would be the use-case for LVM. However, that's a
dangerous operation with btrfs, because the snapshot ends up being
included in the original FS (because it has the same UUID), and thus
causes the kernel to get very confused, leading to probable FS
corruption.

   Hugo.

--=20
Hugo Mills             | "No! My collection of rare, incurable diseases!
hugo@... carfax.org.uk | Violated!"
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                Stimpson J. Cat, The Ren & Stimpy S=
how

--xdWF/UuCWMRSqXrg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXRrs8AAoJEFheFHXiqx3ktaEP/3QQLDcdYvTRARrACAt3lIMv
WPlWve/+cp8yg8Km7xtXTadF/ocAwo8EThUpYW14/VkGE6Nety/vddRj7iqKVTWx
E0HrUuvKwCLFtpIJAXdeTdodho2Rzh+f3nBR41FbTwp4UKas4sCFj81Z74ocLUrs
KeYL4SLws6vGJNeQeW3I8uLx+gO9rJxVvk+V9P68GsoFYUItt3ncRureolka/qPk
Hcmz2++ZwVltpfMUO+ls5FpCGCr+1Fx+DYmbl/oyKljguE2Dfk1wzjwRxHyq1fXh
xvqaA9/lfNd2ajruiIB1Au2wOr+O8cXxUj+s+KIjzj7AGNwioy616lCS24om3pl+
d5pbCH+lPHKFiIza3AweujlA6kHtCLRwyTvpktZ51MhdDDYmTDqSrzYQEA2UJAXO
t1MywFf7m9ouLA6mXpTRfoMQyK5WJ2ufnHjodu80Nkhkvi34DWKb9NuMCsDJnTBU
b6ep00tN1ZFN96l1QtCUijqP1fb3iyhF/x+upNhmr3JJQRGVEGWDODid3C7xP5SF
fV7mEsFCLyDuutAJBJMphaYqQltEF11SkJNgSV81LvQK+cubYfHryV9clb/GokHg
R8IVsUWBdB3V/k9c0xO6q5fwmiLDWZr5D7Cw0HeoPHuneH6arK8/xdEKFU0if4lF
oIHbazclCyiW1dDUQiiF
=PlrD
-----END PGP SIGNATURE-----

--xdWF/UuCWMRSqXrg--
