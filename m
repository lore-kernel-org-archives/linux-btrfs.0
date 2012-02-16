From: Roman Mamedov <rm@romanrm.ru>
Subject: NOCOW + compress-force = bug
Date: Thu, 16 Feb 2012 19:55:15 +0600
Message-ID: <20120216195515.643f4aa7@natsu>
References: <4F38B8F0.5020506@yahoo.com>
	<4F38BE53.4080204@parallels.com>
	<20120213141040.GG15350@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/veAUPMTq837EXvEkhPaP=Cd"; protocol="application/pgp-signature"
Cc: dima <dolenin@parallels.com>, linux-btrfs@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213141040.GG15350@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/veAUPMTq837EXvEkhPaP=Cd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Please be aware that there seems to be a possible problem with using NOCOW
flag on files situated on a filesystem mounted with compress-force(=3Dlzo, =
in my
case).

Since experimenting with NOCOW, I started regularly hitting this BUG at
extent-tree.c:5813=20

  5813                 BUG_ON(!(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));

I was unable to make netconsole work over a bridged interface, so can only
post screenshots of this OOPS:
  http://romanrm.ru/pics/2012/2012-02-16-btrfs-bug-1.jpg
  http://romanrm.ru/pics/2012/2012-02-16-btrfs-bug-2.jpg

This happened four times already, and always on snapshot creation (but not
every case). I have hourly snapshots in crontab, and only one case out of a=
bout
ten fails with this problem. Did not try to deliberately reproduce it yet by
manually making snapshots very often, etc.

On Mon, 13 Feb 2012 15:10:40 +0100
David Sterba <dave@jikos.cz> wrote:

> Hi,
>=20
> On Mon, Feb 13, 2012 at 04:40:03PM +0900, dima wrote:
> > Actually it is possible. Check out David's response to my question from=
=20
> > some time ago:
> > http://permalink.gmane.org/gmane.comp.file-systems.btrfs/14227
>=20
> this was a quick aid, please see attached file for an updated tool to set
> the file flags, now added 'z' for NOCOMPRESS flag, and supports chattr
> syntax plus all of the standard file flags.
>=20
> Setting and unsetting nocow is done like 'fileflags +C file' or -C for
> unseting. Without any + or - options it prints current state.
>=20
>=20
> david


--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/veAUPMTq837EXvEkhPaP=Cd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk89CsMACgkQTLKSvz+PZwhfIwCfZj1Db0//kskrJVYWemXrPa1z
v2MAn25DFtjzFosf60LrMeoSYb/2vM1v
=Bbg3
-----END PGP SIGNATURE-----

--Sig_/veAUPMTq837EXvEkhPaP=Cd--
