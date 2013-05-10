Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41328 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3EJUVb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 16:21:31 -0400
Date: Fri, 10 May 2013 21:21:26 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marcus =?iso-8859-1?Q?L=F6vgren?= <marcuslvgrn@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs balance invalid argument error
Message-ID: <20130510202126.GE26072@carfax.org.uk>
References: <CAB_++mrnzWd9BNHMEK=k7rVdV1x+VjX7JW2ANnEaJ_i1PG-rUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ns7jmDPpOpCD+GE/"
In-Reply-To: <CAB_++mrnzWd9BNHMEK=k7rVdV1x+VjX7JW2ANnEaJ_i1PG-rUA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Ns7jmDPpOpCD+GE/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 10, 2013 at 10:07:56PM +0200, Marcus L=F6vgren wrote:
> Hi list,
>=20
> I am using kernel 3.9.0, btrfs-progs 0.20-rc1-253-g7854c8b.
>=20
> I have a three disk array of level single:
>=20
> # btrfs fi sh
> Label: none  uuid: 2e905f8f-e525-4114-afa6-cce48f77b629
>         Total devices 3 FS bytes used 3.80TB
>         devid    1 size 2.73TB used 2.25TB path /dev/sdd
>         devid    2 size 2.73TB used 1.55TB path /dev/sdc
>         devid    3 size 2.73TB used 0.00 path /dev/sdb
>=20
> Btrfs v0.20-rc1-253-g7854c8b
>=20
> # btrfs fi df /mnt/data
> Data: total=3D3.79TB, used=3D3.79TB
> System: total=3D4.00MB, used=3D420.00KB
> Metadata: total=3D6.01GB, used=3D4.87GB
>=20
>=20
> When running
> # btrfs balance start -dconvert=3Draid5 -mconvert=3Draid5 /mnt/data
>=20
> I get
>=20
> ERROR: error during balancing '/mnt/data' - Invalid argument
> There may be more info in syslog - try dmesg | tail
>=20
> dmesg | tail says:
>=20
> btrfs: unable to start balance with target data profile 128
>=20
> Isn't it possible to convert raid level to raid5?

   Yes, it should be possible. It looks like the kernel's got a
problem with it, which is odd because 3.9 should know about RAID-5.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I think that everything darkling says is actually a joke. ---   =20
         It's just that we haven't worked out most of them yet.         =20

--Ns7jmDPpOpCD+GE/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUY1WxVheFHXiqx3kAQL9LxAAlpUQjQ/MKBpSxuvYWI9S6PBbONfy4qfN
zBPBBT9oBLWRwIyX4zaDVKCOU5nEUtCfe9MEQtgtjlJxled1jJA0Yn62CXBx9/+w
zxXSaoeIX3lqlWUx26a1YnxlWXd2DB51BuxCn3BBgBeAhXGe2OkCh/BjbQhjg8F8
/rezxNmSGcqUswJw8Sl2KI31ly4DxspK//aT2Ji1DT+uGLA6p6vjPZk3IG+IC9L0
58t1kFXv4pbPO317PANLpI3grfzxgUUcLJY6gMhvmyrttC1Isr0pJv/4Ifnv0MAA
+A5joNmkhgM4kH1glvHrZ6mWFvyuJDq0W8Xi1uvjAtxQbJr7l2kb4pcfHjrs1tOW
pGI+7hp1VlywL0rAojAVM40ClSxP6oQnVzdxuRlTpwSGVGqLY3RLmh/VjrdjJJDx
/fpjzV753ub4s2edv1kwC+q21FXWa12wOMmRZywfQxJ9GR37ZG0W9TWDy3RARNir
9sDjw2eQ2Pn3NVRJ0R6CU9jYj6KHX6f+CX7AHQ5s7ggNnv2kGyOT5nhquocZCiQS
U2IYqx/nIYTn+3TsXjEntYqsz9VBvrkFoLleIG+ssVcWFP1PFS4rYR13TAWHkG11
wFrCVrIh2QkWUGkVLoNEkO7sEbGCMQai2nRWS2OjjHC4uCPJZKXCxDQzCv6ugIHh
tvKkPDLmFP8=
=DSuN
-----END PGP SIGNATURE-----

--Ns7jmDPpOpCD+GE/--
