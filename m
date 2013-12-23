Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34299 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3LWJjy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Dec 2013 04:39:54 -0500
Date: Mon, 23 Dec 2013 09:39:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Nacho Man <nacho2874@yahoo.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: unlinked orphans.
Message-ID: <20131223093953.GH17179@carfax.org.uk>
References: <1387780037.66690.YahooMailNeo@web162601.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uu2n37VG4rOBDVuR"
In-Reply-To: <1387780037.66690.YahooMailNeo@web162601.mail.bf1.yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Uu2n37VG4rOBDVuR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 22, 2013 at 10:27:17PM -0800, Nacho Man wrote:
> Hello,
> I ran dmesg and saw a bunch of these:
> [564421.874063] BTRFS debug (device sda2): unlinked 32 orphans
> [568021.386733] BTRFS debug (device sda2): unlinked 32 orphans
> [569943.269610] BTRFS debug (device sda2): unlinked 32 orphans
> [570929.840278] BTRFS debug (device sda2): unlinked 32 orphans
> [570942.035251] BTRFS debug (device sda2): unlinked 33 orphans
> [571623.719086] BTRFS debug (device sda2): unlinked 32 orphans
> [572075.684003] BTRFS debug (device sda2): unlinked 32 orphans
>=20
> I just counted and there's a 175 of them.=A0 Do I have to worry?=A0 I've =
been working on a toolchain and some other stuff for the PS3 so my hard dri=
ve was being accessed a bit.=A0 Could it be related?=A0 Thanks.

   No, this is harmless. Orphans are files that were deleted while
they were still held open by a process. POSIX semantics requires that
the file data is still readable by the process, but that the file's
hardlink(s) are no longer visible -- so there's no way of finding the
file again by "normal" methods. Once the process closes the file, it
is unlinked.

   With btrfs, making a snapshot of a subvolume with (still open)
orphan files in it will close the orphans on the new copy, because
they're new files. This leads to the messages above.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- Ceci est un travail pour l'Australien. ---             =20

--Uu2n37VG4rOBDVuR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUrgE6FheFHXiqx3kAQJUxBAArHS21y3xRB2SzTC0xCzxmUeoIlv/49zD
uwCmLqt9ba4YRmcnICONbqL9eeRqpr3JOoBAaI4VLr2XF/84NYY8mbsLF9dYfaVY
XpjAF5Pl57vaLNTmztvBAcoMLCIZa56P9U8XF9Hd8xrU3zEQGYXvmqQP7vY7/MCA
7ldSgifsZiO/MJ0UAtZVHdsBnRN4anNHI/sxc6Su27R4Y6NE1c8e9LzlGjVPVxuh
4U18KwDLHqSMyV3Wq4vzgXXnr1qSnJx1MjbZfkr/jrQzSBdughcrHnr2fyx22vDi
n4uKpMSDCR8urcfUIFTL1p+eKSUTY6fI2a9l7//ORcImurMPH8q12rpauQt2hmh0
2TlV3HYh0ZOtDMHvAHDuR6vxGk7yn7O86UebV7hKLPqbSbU5ifdOfl+A5hV3R1Sv
UZlG3S+o+gBYJG1B9WXi2c6xzYGydS7hb4PcHboTVRW2/4JcJA5TeySrome+zfmr
Rp10UrVqJbScEoWBeR+o/dMIRL+4mCmZZo0y50Vh944NVlghOIonpSKC55XBI1p4
WtcX8DdxjPah8J9M3Op7RWr2+p9+xxlg7ct++HiRIYvSF/djPBJD+McJ1iVo+bgU
FydtQQKe7C0OyvzE/KRbUyr6QGmqRJByzFbaYRyXcrYv3uSo7UOzF4FYpu++UZex
PsWU58oy6Ag=
=DZBx
-----END PGP SIGNATURE-----

--Uu2n37VG4rOBDVuR--
