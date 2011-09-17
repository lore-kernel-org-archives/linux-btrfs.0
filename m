From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2299
Date: Sat, 17 Sep 2011 20:25:02 +0200
Message-ID: <1316283907.3253.8.camel@picard>
References: <1314582311.2724.4.camel@picard>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-Ap+unGtC7e+ZUaNPrd0Y"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314582311.2724.4.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>


--=-Ap+unGtC7e+ZUaNPrd0Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

1. Once the blank screen happened ot 23:00 UTC instead of 03:00 UTC
2. I tried to disable the caches
3. I tried to rsync via ext3 + btrfs-convert. I noticed something - in
old fs the df looked like:

Data: total=3D30.01GB, used=3D28.42GB
System, DUP: total=3D8.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D1.00GB, used=3D199.47MB
Metadata: total=3D8.00MB, used=3D0.00

on new one (with ext3 image):
Data: total=3D33.33GB, used=3D20.52GB
System: total=3D32.00MB, used=3D4.00KB
Metadata: total=3D16.64GB, used=3D11.36GB

and without:
Data: total=3D33.33GB, used=3D20.04GB
System: total=3D32.00MB, used=3D4.00KB
Metadata: total=3D16.64GB, used=3D10.88GB

Given that lzo compression was used about 4 GB data difference was
expected (difference depending on mount options on rsynbc). However:

1. What is DUP?
2. Why metadata is so big on convertion from ext3 while data is small
(the sum is about right - 31GB vs 28.5GB)?

Regards

--=-Ap+unGtC7e+ZUaNPrd0Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOdOYCAAoJEJIdee2Vr4aPspIQALLebDEfYzvulchsf4kIzK9F
BwP779fEnSM5HuW7Mn1GCCCej2xJJ3SJyC9WJhWMVK/SWot0eTDpeyqyCVNIlUI+
1h0+tztRVaUeNRsfddVTIeBkG1bdQdQH/wjG/j8TC2RA9xOPHpMnl6utOTlD1T9/
f3rLE4yZ+py+ak9ItUSRyqa/X7rt9g1DunsVtX0vIe68lujcTdTz6Tcp3YM6hD4T
PjfirGaglJlL28Aqo6Zac/ln2zyoCCUGibNYZktByHTNPc07fwzO0bDckQhCtHwO
wqko7Yuu6h8K555fpYonmkxUs6viG0WBllk69A6ApYma1oNewzrTzWCZAFfcq8LO
/NojjufGloMiuMWAHFUefkyf6w8PxchSK49nTwNPJqLSrSIkPyYRbNAvOrmFZ5/X
BIXtuwP2euHckg1Nz8A/zvqPQuMrd+e5WooUGo5sWFOD/uGE11fxYCAmXJKycxPA
XIvWqgb2JhWSq0xqF26sqj/TsJQ35mo2spFV8HRrOU7fc/40nE3BTsC4O8Q1dlLB
NKUPLU7Y5QQXKZVzQgGOApvtUh1iBephdkwgzQRP6dEe75R7KoVGJS4O3VrkRst+
hQ9WyRiGnsR8gbIHPudv+Dhc3nauG+rSJh3Wx62X0Xg8ro6xVPHRiCeeGN2M0skD
6r+tAhf4TQ42Sthztb7a
=QCBj
-----END PGP SIGNATURE-----

--=-Ap+unGtC7e+ZUaNPrd0Y--


