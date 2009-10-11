From: paran@lysator.liu.se (=?utf-8?Q?P=C3=A4r?= Andersson)
Subject: Re: Mass-Hardlinking Oops
Date: Sun, 11 Oct 2009 17:05:53 +0200
Message-ID: <87my3y3r8u.fsf@faran.nsc.liu.se>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>
	<4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090803235920.C13173@mccme.ru> (Mikhail Raskin's message of
	"Tue, 4 Aug 2009 00:01:20 +0400 (MSD)")
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mikhail Raskin <raskin@mccme.ru> writes:

> On Mon, 3 Aug 2009, Tomasz Chmielewski wrote:
>> BTW, what limit is that?
>=20
> 272 links. Creating 273-th link causes BUG(). The limit seems so
> arbitrary that it maybe can be made higher.. 32-bit (billions of
> links) seem totally unrestrictive..

I just ran into the max hard link per directory limit, and remembered
this thread. I get EMLINK when trying to create more than 311 (not 272)
links in a directory, so at least the BUG() is fixed.

What is the reason for the limit, and is there any chance of increasing
it to something more reasonable as Mikhail suggested?

For comparison I tried to create 200k hardlinks to the the same file in
the same directory on btrfs, ext4, reiserfs and xfs:

fs      limit
=2D-      -----
btrfs   311
reiser  64535
ext4    65000
xfs     higher than 200000, if there is a limit

Regards,
P=C3=A4r Andersson

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrR9FIACgkQyi5LJcueYEvmigCgtBdGkz5r0gHI4Dqjd9RIHeDa
COoAoI2i6PRRvjCElqNGQL6LHJV9qMIN
=kvFM
-----END PGP SIGNATURE-----
--=-=-=--
