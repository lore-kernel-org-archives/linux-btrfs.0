Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45452 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbaKTRL2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 12:11:28 -0500
Date: Thu, 20 Nov 2014 17:11:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Ken D'Ambrosio" <ken@jots.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send erroring...
Message-ID: <20141120171127.GM32735@carfax.org.uk>
References: <282a8749999cb6fed86f4ecd15152db0@webmail.jots.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4oQnj4jcM03NhqPN"
In-Reply-To: <282a8749999cb6fed86f4ecd15152db0@webmail.jots.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4oQnj4jcM03NhqPN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2014 at 11:57:50AM -0500, Ken D'Ambrosio wrote:
> Hi!  Trying to do a "btrfs send", and failing with:
>=20
> root@khamul:~# btrfs send /biggie/BACKUP/ | btrfs receive /tmp/sdd1/
> At subvol /biggie/BACKUP/
> At subvol BACKUP
> ERROR: rename o2046806-17126-0 -> volumes/ccdn-ch2-01 failed. No
> such file or directory

   This looks like one of several bugs that have been fixed
recently. What kernel version and userspace tools version are you
using?

   Hugo.

> Judging by disk capacity, it hits this about 40% of the way through.
> As my disk has subvolumes on it, which are underneath
> /biggie/BACKUP/, is there a different way I should go about
> "sending" an entire disk?
>=20
> Thanks!
>=20
> -Ken

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- =A91973 Unclear Research Ltd ---                  =
=20

--4oQnj4jcM03NhqPN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUbiC+AAoJEFheFHXiqx3k0GMP/AuB0eIopghjh6P3vPkFHYEU
dfsubEvxmEdpRE9E5Tn5zDSCZyy5+bKlCJoNa9FqZ3/2C6Cvmbwc1HTICTERX4PY
0XRuGzGaRVGEoCR761IMYuQagENtJ8dt+J6AMnjmEREeXLozQVHYFcQQEo8+p4GY
RR+bOntQ7/OASh9x871RKJnKUa+uCojMDbtgE4ajOeKWupAm+jtOBv6OliILmn8q
TPVyYLR4UGk8Sjt6wzBJ37Z1/iIv+SNnB56yRoDDRF/pvi67fqqLqBGel9Imquel
lQV8ShkTGHgd/gwsRqbkLnCtL54qGPbXhxK67QIKfdtig3UPB9Yt3finAnZscqv+
SDCj5yrx81Xuh/lNZT1rloPSfoqwK+1Wz7FIkPzVLtoZANmsLXSnDbg8saSFyPo2
wzEyZhfLVeEf8FzgmwX5oo05av8XkcgxNxsr0K0vs4Q2gnLwsBOxGW4B/K3vwbLj
WhNmmKlVIbOKVRRYqiki/D1m4PDbFuKEJCY68xx2E+uyXXbQJlf1Dj+MGICAqGIt
o6YBXfv4TVhqcu8aZZUgAVKe4dogdgs5da4A3Iu0OOMNYLeK92dcpK52tRg9ZdLR
DRDcPx6uN7pGCqBkJWOcjbF8oec6qyf+3yeefN8dyKiqxrPOXiWAQl0V9FXWC30S
pg2TLreYZsqQu/oHcZMO
=3MMT
-----END PGP SIGNATURE-----

--4oQnj4jcM03NhqPN--
