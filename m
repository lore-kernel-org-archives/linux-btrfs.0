Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42375 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2KFNyY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2012 08:54:24 -0500
Date: Tue, 6 Nov 2012 13:54:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs handle sudden shutdowns?
Message-ID: <20121106135422.GB29581@carfax.org.uk>
References: <20121106123308.GA2676@yeono.kjorling.se>
 <20121106124802.GA29581@carfax.org.uk>
 <20121106134702.GA3900@yeono.kjorling.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
In-Reply-To: <20121106134702.GA3900@yeono.kjorling.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 06, 2012 at 01:47:02PM +0000, Michael Kj=F6rling wrote:
> On 6 Nov 2012 12:48 +0000, from hugo@carfax.org.uk (Hugo Mills):
> >    There are also some caveats: while the FS should always be
> > consistent, the latest transaction write may not have been completed,
> > so you could potentially lose up to 30 seconds of writes to the FS
> > from immediately before the crash.
>=20
> I'd rather lose the most recent 30 seconds of writes but have a
> consistent file system with as-consistent-as-can-be-expected data,
> than end up with a corrupted file system.
>=20
> On that note; can this value be tuned currently, is it hardcoded, or
> is it stored in metadata somewhere but the tooling to tune it is not
> yet available?

   As far as I understand, no, it's hard-coded.

> >    If the FS does corrupt over a power failure, and the hardware can
> > be demonstrated to be good, then we have a bug that needs to be
> > tracked down. (There have been a number of these over the development
> > of the FS so far, but they do get fixed).
>=20
> Is there a simple way to tell ahead of time whether the hardware meets
> the assumptions made by the file system with regards to write barriers
> etc.?

   "Most" hardware does. I think there's a "barriers disabled" warning
in the kernel logs on mounting the FS, and some time ago there were
rumours of a tool to check for it (from Red Hat, but I don't know if
it ever saw the light of day). That's all for the case where the
hardware explicitly states that it doesn't support barriers.

   More concerning is the out-of-spec hardware which claims to support
barriers and utterly fails to do so. I don't think there's much you
can do to detect that case, other than force failures and try to catch
it out -- then return it to the manufacturer under whatever consumer
protection laws you have, on the grounds that it's no fit for purpose.

   I think the number of actual such hard disks that do this is fairly
small, but they are out there. I'm not aware of a blacklist/quirks
list for them.

> >    I guess the question for you is: are you after the _expected_
> > behaviour of the FS (should always be consistent on good hardware, but
> > you may lose up to 30 seconds of writes), or are you after mitigation
> > strategies in the face of FS bugs (keep off-site backups and be
> > prepared to use them)?
>=20
> I already have full, daily on-site backups on an external drive that
> is logically unmounted except for when backups are running, as well as
> partial off-site backups to cloud storage - and of course, taking
> advantage of btrfs's snapshotting support there is no real reason why
> I couldn't increase the backup frequency while retaining data
> consistency. Losing half a minute of writes is fairly inconsequential
> for personal use as long as the file system remains consistent, and in
> the face of disastrous corruption it is at least possible to do a full
> restore to bare metal from rescue media and backup without losing too
> much. Not trivial time-wise (that's currently 1.4 TB over USB 2.0),
> but possible.

   OK, so I hope I've managed to answer your question satisfactorily.
Let us know if there's any outstanding queries you want cleared up. :)

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- "I will not be pushed,  filed, stamped, indexed, briefed, ---   =20
               debriefed or numbered.  My life is my own."              =20

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJkWjr9z9OVl50rAAQKayA/9FagScQRjLFv/n8Zo8Q7dmTfuGeB1FBtZ
gWY+7bT9j3WfoAnq6v2lg6aixMLOkQy+kP0mmb81SsX70/MNqFbrO5KkdfV/VuON
+SwlkgB6WUKjC8tjNjsuBw+d3wj9Ex44ZjSOtt7zaudtiyBR2s6lFGlzxijovQWw
j6Oa2QfOYRqKMHalTpecGGlS9kr9iA6jWnOTGluy0U+tH8DZu7QApXVyV0yADZvs
YM9VAb7i4+pGnp8scxVwVu1Y+Pc0QHJz2rFgpEkbbNWkTVHGuHOPNl1fi1NoYhEd
JFwnPavdVA9CRGqCUt8hDwRsnLH6X2Z2pwjxX6LIVDWiPPFEJVbyzn+TCx5Z2m9z
eFx+dxumhiWJggu4ZMOqhvDf9mZjd/q5YQQWhEOXRjlW3l7hsHhX4PLIgkaIjH7/
H5Z+dhk+z8xXD812rlrCkX1m5QVpDZpzdQWFanBxGRDssaxQFfrTnuACmUBVwJLF
L0cngMQpZbe3jsWc/xGF4N6/sg9XoUeImSCtnT7pCHcVmHw3mf8trkjhsUplRyvl
vUV6P8dEvcwdse1dFu+LH8aHgFnMG+hb4oHHyP9LSvSlqfkPeHVscBLJHEhMpk2g
UDXiHA0GCClRSV63s8eGgWPRm4qw1UNodb5RiK+ZOgp+ZDomyk3pav+dmN6nYiMn
oQ/Cj3l6x+o=
=gHQw
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
