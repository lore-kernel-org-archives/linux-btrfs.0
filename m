Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51336 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759083Ab2J0WCS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 18:02:18 -0400
Date: Sat, 27 Oct 2012 23:02:15 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs behave on checksum mismatch?
Message-ID: <20121027220215.GA5042@carfax.org.uk>
References: <20121027215645.GU2381@yeono.kjorling.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
In-Reply-To: <20121027215645.GU2381@yeono.kjorling.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 27, 2012 at 09:56:45PM +0000, Michael Kj=F6rling wrote:
> I came across the tidbit that ZFS has a contract guarantee that the
> data read back will either be correct (the checksum computed over the
> data read from the disk matches the checksum stored on disk), or you
> get an I/O error. Obviously, this greatly reduces the probability that
> the data is invalid. (Particularly when taken in combination with the
> disk firmware's own ECC and checksumming.)
>=20
> With the default options, does btrfs make any similar guarantees? If
> not, then are there any options to force it to make such guarantees?

   It does indeed do the same thing: if the checksum doesn't match the
block, then the alternative block is read (if one exists, e.g. RAID-1,
RAID-10). If that does not exist, or also has a checksum failure, then
EIO is returned.

   Hugo.

> I'm interested in this both from a specification and an implementation
> point of view.
>=20
> The last thing anyone wants is probably undetected bit rot, and with
> today's large drives, even with the quite low bit rot numbers it can
> be a real concern. If even the act of simply successfully reading a
> file guarantees, to the extent of the checksumming algorithm's ability
> to detect changes, that the data read is the same as was once written,
> that would be a major selling point for btrfs for me personally.
>=20
> The closest I was able to find was that btrfs uses crc32c currently
> for data and metadata checksumming and that this can be turned off if
> so desired (using the "nodatasum" mount option), but nothing about
> what the file system code does or is supposed to do in the face of a
> checksum mismatch.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- It used to take a lot of talent and a certain type of ---     =20
        upbringing to be perfectly polite and have filthy manners       =20
            at the same time. Now all it needs is a computer.           =20

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUIxZ579z9OVl50rAAQL/3Q//RmRquDcaK6FM+qCYTQ58eOvAAzlCoQYq
mxq1viJ8z3VvUwPmJ5ZVuv89NBadWTq7+qh5gJBagFy83NZKLdcAJB0aG4KNRWtV
bEC7y9sRpSH7XCTVe9EuD1LGPNyvDZqfNx8xMI7uoeNgxx8aX+OCGQl830thZZqq
cDTi78aF8kktNUo3g2haWk5aPKNyrZQJRCmmUxmvLC4NkWIZAia+YxOC2wYmBx2X
xzSd4g54T/S/faBUhmBN6GMHG9rsTRQH2r2hwOH/Ui3JRSa4FBQJlYc+PsTEJ1D6
wukFKYl0517U+AimToG1EeHRfYTNBJzfGt8vlTZpvGM2klm752aPm8QF4i1/R/6o
EPlxSndZ63kcfCB9FfLJGIOljEqOTgC1CF9QcM9poKWtPUM2L1juU4FLWu2e3Ege
7IzYOK3P2WABujkBtD7L4pSgqGUs8QRPjfu5MP1fW+x1WK+o+V42XFYLjqVOVoNC
nI8m7pEuj8EdaPOQyxmEa00i39a/La0Bz0EkxS7OYk/xvw5tB8yCz1RrOwVeFMdf
E3LZ7ZZtbls1UEismfLfB2gHx2dbVwy7tEzyqs4QWUtfyhq4VulrcM6RC+7Mb3uL
4kZFqqChY8BX7P4Gn0cU39g1+V7778W+vv51je98PSHdzqAh+9eys6TLGDfFNqPm
88LgGnA8yVg=
=+0GW
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
