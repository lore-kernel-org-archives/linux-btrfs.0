Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41364 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCGICQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Mar 2014 03:02:16 -0500
Date: Fri, 7 Mar 2014 08:02:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Michael Russo <mike@papersolve.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during raid1 rebalance
Message-ID: <20140307080213.GC6318@carfax.org.uk>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>
 <20140303183911.GL13899@carfax.org.uk>
 <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com>
 <73124688-5EDF-4DB5-AC9E-9F365397DD28@colorremedies.com>
 <loom.20140305T190503-404@post.gmane.org>
 <pan$23ceb$3bedfe62$bfb976de$e16d8fde@cox.net>
 <loom.20140307T021006-737@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
In-Reply-To: <loom.20140307T021006-737@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 01:13:53AM +0000, Michael Russo wrote:
> Duncan <1i5t5.duncan <at> cox.net> writes:
>=20
> > But if you're not using compression, /that/ can't explain it...
> >=20
>=20
> Ha! Well while that was an interesting discussion of fragmentation,
> I am only using the default mount options here and so no compression.=20
> The only reason I'm really even looking at the fragmentation=20
> issue is because running the defragment (with varying sizes of
> "-t" which I'm not sure why that's even necessary) seemed
> to force btrfs to move segments around and let me rebalance
> more block groups.  I don't even care if the files are defragged,
> I just want them all in the RAID1 profile.  Hopefully if I move
> each file out to some other FS like /dev/shm and then back
> it will work, I just gotta hack a script together to do so.

   I _think_ the problem here is that there may have been some extents
created during the conversion which were over 1 GiB in size (or at
least which run across two or more chunks). This causes problems,
because there's nowhere that they can be written to by the balance --
which preserves extents -- because none of the allocation units
(chunks) are big enough.

   The defrag operation, by its nature, _doesn't_ preserve extents,
and thus can act to break up the large extents, making it possible to
balance the chunks that the offending extents live on.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- If the first-ever performance is the premi=E8re,  is the ---    =
=20
                  last-ever performance the derri=E8re?                  =
=20

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUxl9BVheFHXiqx3kAQIauxAAvOr6Bj43BuR9S3FGM5ttlKkXYNrOM+VH
ofcRMbjEq91wE1WPmKwRfi/2lOCSMdmpd8KpZUzuikx7BDi0q4UqzXYtSj6Mg2c1
3X//pSmKA0VhRAHGP5LI16RDUb+7WHWNd/oZqOSnYgljpU1TwLSlmG+Ktg1KlElW
w5iDBNRjEnJVRcZ/GPTXvugmhPlcxmjMR8pnBCK+4x6H8JQ+n6fmDjutlu37ES8j
Cl9kNncKxCHp8PkJKFidLT51g2Qu40J2HGZTEicCAPMa/iyWlcR2O/VdrASYCUn7
j0+I3Mjzqo73+Uqd5Vym5G2ma+GtS14ihBFdtKTUfHAIaoI+Dkgfh8UAv1Q6eGTM
gR/tSz5u7wKGEWcYy9vA0zoEAqjpx2TVjn9e4Kpj4gyvVTQlvs6LU2qE9qZkd79i
F9KnHf9LW7seaeQ0xnuzc/F8o2CrCpB4I71NZ1MbJ75y2i0Gdp0YzV+AFK8gQBFz
THbd5hGPgN+v835rxG57cBRCM5YIarLYwnxizSff+X9f2uXi1XNnRPBCSE7JLT8Q
YvH3nIwVErNWjfs18zgX7LstKlsPzZLFTbVAT5hPsAV4aU1ZZZOBllCXy2Q4njVh
D1XHoyxJsGFPCmaZO5ZcvTAK0PwjsTijBwK0TTodDAEHPNIurRrUkKbsUbHwIt0V
FZPgDSEvfsA=
=7Y9d
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
