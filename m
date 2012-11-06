Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50147 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2KFMsH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2012 07:48:07 -0500
Date: Tue, 6 Nov 2012 12:48:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs handle sudden shutdowns?
Message-ID: <20121106124802.GA29581@carfax.org.uk>
References: <20121106123308.GA2676@yeono.kjorling.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
In-Reply-To: <20121106123308.GA2676@yeono.kjorling.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 06, 2012 at 12:33:08PM +0000, Michael Kj=F6rling wrote:
> Can btrfs deal reasonably gracefully with sudden shutdowns? (I'm
> mainly thinking of power outages which lead to logical structure
> damage but not physical media damage.)

   In theory (i.e. by the design of the FS), you should be able to
pull the plug on btrfs at any point, and the FS will always be
consistent.

   This makes some assumptions: That writing a single page to the FS
is atomic. That the hardware reports barriers to the OS reliably. i.e.
if the hardware says it's fully stored data without losing it, then it
actually has.

   There are also some caveats: while the FS should always be
consistent, the latest transaction write may not have been completed,
so you could potentially lose up to 30 seconds of writes to the FS
=66rom immediately before the crash.

   If the FS does corrupt over a power failure, and the hardware can
be demonstrated to be good, then we have a bug that needs to be
tracked down. (There have been a number of these over the development
of the FS so far, but they do get fixed).

> What would be the risk points, file-system-wise?
>=20
> Can for example a rotating snapshot schedule mitigate some or all
> issues relating to sudden shutdowns, if any? (_For example_, take a
> snapshot every minute, keeping the last five; if the main file system
> fails to mount, then could the most recent usable snapshot be used as
> a fallback, or is it likely to be equally damaged or inconsistent?)

   No, snapshots give you no additional guarantees -- if the FS
corrupts and is unmountable, a snapshot is part of the same FS and
will also be unmountable.

> Obviously a UPS or other form of fallback power is preferable to no
> UPS if power outages are a concern, so as to allow a controlled system
> shutdown (or fail-over to a more long-term backup power supply) in the
> event of a prolonged power outage, but I'm wondering about situations
> where such don't exist or even fail.

   As I said above, the FS structures _should_ be completely reliable
in the face of power loss; that they haven't been in the past is
definitely a bug, and those bugs have been / are being fixed as
they're found. We've had very few transid match failures recently,
which used to be the main failure mode for these bugs. I don't know
whether that's because people aren't reporting them, or because
they're not happening nearly so often these days. I suspect the
latter.

   I guess the question for you is: are you after the _expected_
behaviour of the FS (should always be consistent on good hardware, but
you may lose up to 30 seconds of writes), or are you after mitigation
strategies in the face of FS bugs (keep off-site backups and be
prepared to use them)?

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- emacs:  Eighty Megabytes And Constantly Swapping. ---       =20

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJkHAr9z9OVl50rAAQIqJQ//Rf4YvbTKJbNrLxn1JAgWDdyWct5oKSht
mLID5fM4gYBSZnaB7NTijOzTDF9IsCzK8KM0XFUDan2XPLBNQ5BF/vecFhmg98Jf
nFrTV/dcKDLqkUYGCOBWBRtAtOuYjzlhu52Q7ILiOs5W2oa30qkOQREMjVj+31v3
qrvTvMmSK0JPk1p5vGreFNn7oNYtqpIcldX7JhPtzbv7w9MwUhTvl3GQFZCp0U49
qGX7S1svVfCuu6YTgdbxefKA6G9fYbgy2L9XGiDa+QdS2kmpTQie3Kd1gV86znf0
uDH/4nouHGOK+PAHd4fHsz6+zVo06BD6ciAB5RUkGBHVC3opSF4z65jM2daa0xJR
K0Neffa42/xa1Ai17CrsukWQNEN76Jvu8R9rcU98j4X2jFf139bvKScKmp9Wz2TD
oOadWmDOQNcR8SNeUr32TIjZlHwVSyxFx2eXv5sbAn/llKr6txHVmEHyN8nmWWl8
BmBmGxE9QIhSuZyV+Ub2yvn25IpkqmI0NBtl8vM0Yp0PE6ySEXsuy5A7IKYBJ91G
UV5SSVLXkHnYR/8mpracQBDuUi7xGuFZXvsVqQ8kBSB0LvLl24hjdKmtRVYh7v9o
/17cZrA+rG3y2+Ruas08TNOE67ynVPZZazQ8j0LqL+Q0VdXhsFI+rqr3On2kcLV2
7q/UGvH3vi4=
=4gl8
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
