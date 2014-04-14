Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51448 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaDNLby (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 07:31:54 -0400
Date: Mon, 14 Apr 2014 12:31:51 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Subvolumes and isolation
Message-ID: <20140414113151.GM27956@carfax.org.uk>
References: <pan.2014.04.14.10.38.45@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QxIEt88oQPsT6QmF"
In-Reply-To: <pan.2014.04.14.10.38.45@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--QxIEt88oQPsT6QmF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2014 at 10:38:45AM +0000, Holger Hoffst=E4tte wrote:
>=20
> So I'm happily using subvolumes and snapshots and was wondering about
> subvolume low-level isolation. Assuming metadata=3Dsingle, would a corrupt
> metadata block in one subvolume's directory tree affect any other subvolu=
mes
> on the same physical partition, or would the fallout from this bad block =
be
> contained?

   With snapshots, potentially the FS trees can be shared as well
(that's what a snapshot is -- it's a CoW copy of the FS tree of a
subvol), so a corrupt block in the FS tree could be shared between the
subvols.

   With separately-created subvolumes (btrfs sub crea), the FS trees
will be independent from each other, but they will still share the
same extent tree (and all the other trees).

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- You've read the project plan.  Forget that. We're going to Do --- =20
                      Stuff and Have Fun doing it.                      =20

--QxIEt88oQPsT6QmF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU0vHJ1heFHXiqx3kAQL4mA/+I4jEtMhClLzhzBDCzZCvr2NFh0ZepJJ3
sl14rejZtObTeCzsKPx9274xeYLjnqTv7qNpR1ksQt2Uujvb98sxoBjig89sPUfO
Za0lXfuULN2PL+s8pUUpc04HXEPMDZn3Aod557LLUeGHA806cgwYw2GWJnro13d+
gHqiyd7OIJN4KRnnxrxBsNP1W4XML/gwvElu9kzjDsraLTXP2u2yBzE27Y9x22gv
u3s9qd0+nkkpk3VhSRMOjDm27zCJduVzoebm/9UwA4uF77pPJaJ9j0sLNS87e6k5
ybjuUTfRuRIECueWw7w6VVHLt8s5PYTQdY1iifmrTjVOv27LvYXegNT9V6rZ/uE5
dtSURVj7fa9eIH572JDJcCo4BYaUvD/1p52uXqOWWqU18Do8vfj0B0EoUmTyJnZr
yPmNhB/fk7rydSdClBnSLEh1NfUz+ukKr0TuJYQpvRCxEtpcA//+QaLT/EhTo9o6
zVJhAZdOnjiD9lfi1dHEKgsikwqqOxMxmKAoGHpGQr94ASrQRO6x6KgNZpoqVXlG
MG8ywYmeQ2JeUMwkQTu20VFX4FECLv0ZdQHlD08u6qtNy7rhl4VaYNsBUberUmqM
w1mkHTyXhdHKXPJGkaPwqiHLq7OsWZBvkITdxDX+4b9eXhF9Rf7F/NwV3XmzMFbO
nZZ9LZTvyiU=
=kIPz
-----END PGP SIGNATURE-----

--QxIEt88oQPsT6QmF--
