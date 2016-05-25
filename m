Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36448 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbcEYLHO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 07:07:14 -0400
Date: Wed, 25 May 2016 11:07:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Copy on write of unmodified data
Message-ID: <20160525110711.GJ16712@carfax.org.uk>
References: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
 <20160525092958.GH16712@carfax.org.uk>
 <dc2b10c2-24b4-0686-f382-c53cfce7a9df@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OX7PPUk8qMPP4++R"
In-Reply-To: <dc2b10c2-24b4-0686-f382-c53cfce7a9df@zytor.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OX7PPUk8qMPP4++R
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 25, 2016 at 04:00:00AM -0700, H. Peter Anvin wrote:
> On 05/25/16 02:29, Hugo Mills wrote:
> > On Wed, May 25, 2016 at 01:58:15AM -0700, H. Peter Anvin wrote:
> >> Hi,
> >>
> >> I'm looking at using a btrfs with snapshots to implement a generational
> >> backup capacity.  However, doing it the na=EFve way would have the side
> >> effect that for a file that has been partially modified, after
> >> snapshotting the file would be written with *mostly* the same data.  H=
ow
> >> does btrfs' COW algorithm deal with that?  If necessary I might want to
> >> write some smarter user space utilities for this.
> >=20
> >    Sounds like it might be a job for one of the dedup tools
> > (deupremove, bedup), or, if you're writing your own, the safe
> > deduplication ioctl which underlies those tools.
> >=20
>=20
> I guess I would prefer if data wasn't first duplicated and then
> deduplicated if possible.  It sounds like I ought to write a "smart
> copy-overwrite" tool for this.

   I _think_ rsync --in-place may help here. IIRC, it'll only
overwrite the sections of files that have changed, rather than write
and replace the whole file. (I may be wrong about that, though. I
haven't tested it at that level).

   There's also the in-band dedup patches that have been on the
mailing list recently. That's probably going to need massive amounts
of RAM, though.

   Hugo.

--=20
Hugo Mills             | Putting U back in Honor, Valor, and Trth.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--OX7PPUk8qMPP4++R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXRYdfAAoJEFheFHXiqx3kObAQAKeot21KNaWKZiq3ZwZG1kbo
OpZbgD8+D8eWMWCgAFnpkaRM0fMPVkm9qFbN9plKo7aT7WboVvOVrhFdBHz6Jw2m
znGIuOMuNGrBgivThUXHPL0BpBNIglQC/S+ZISChjRxcIfyPH/fDXg0pW2Gaw6bI
xPCiy8uGp7iunSicgpow2FN8y/TF9RSpkq3xU6X6amvviKCqs22oJ9iCZ2FJKvdU
Vlpt6U9AJrHQn20ersLlYXmF9L8vFlrdKf02SSGOoDBgCWefl5upKnMMb5JRwQVX
7mJG/ad/m4SCgj6sXflH28jtfpbtvC71/e72QCHLXt1Ns8U8qD44zwZqgHMWYWa+
YfVkvUUIvktMaJMlldgCa3dG4auUZHKxDN6OHOecBDS+5QzupEEytqT3id4rowLo
tnm/x0REPOR6ZD41CuFXJoU581iAim2CBqvG1B0gJ7y81CrD3xtFrcmvL869Ho4K
/BKA+9+YT9JOFX6dVYI2sqiCGn/pSIycx4qaCepc9rj0Khzbc78yLQ5WNT7dqLnr
vG21e2xBT6bnpNKDPoJyiaM00BqHwai9OgbnlYQxbyqVKGlA75SPSAWTTDXprtgE
zgnRF0vljGn3O2A4PRdleOaHM2ZX1IEfZF0uQ2q3MNATtjHJKoCqj/BoiRBjkbXY
YezZmB6ssQtMHCpiL3Mo
=ww+2
-----END PGP SIGNATURE-----

--OX7PPUk8qMPP4++R--
