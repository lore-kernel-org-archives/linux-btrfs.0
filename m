Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47901 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbbIWOng (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 10:43:36 -0400
Date: Wed, 23 Sep 2015 14:43:34 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?utf-8?B?VmFja8OhxZkgRnJhbnRpxaFlaw==?= <vackarf@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs check dont repair
Message-ID: <20150923144334.GP5918@carfax.org.uk>
References: <CAMH1C+r4yYU8hYfcZpFRyN1UWY8OPTs5Md7MdE=bm2RW9udREQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kOdvwer/5gjFgNo6"
In-Reply-To: <CAMH1C+r4yYU8hYfcZpFRyN1UWY8OPTs5Md7MdE=bm2RW9udREQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kOdvwer/5gjFgNo6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2015 at 04:39:27PM +0200, Vack=C3=A1=C5=99 Franti=C5=A1ek w=
rote:
> Hello,
>=20
> i have problem with my btrfs, can you help me, please? Its on my
> notebook. Sometimes it exhausted battery during sleep and died. But
> everytime FS was ok. But ones mount fail.
>=20
> Do you have any idea how repair it?
[snip]
> [root@rak ~]# dmesg | tail
[snip]
> [ 4108.444472] BTRFS critical (device sdb2): corrupt leaf, bad key
> order: block=3D3242455040,root=3D1, slot=3D0

   You have bad RAM. You should run memtest and fix the hardware first.

   After that, there's some patches that should allow btrfs repair to
fix bad key orders in most situations -- I think David was picking
them up again, but I don't know what state they're in right now.

   Hugo.

> [ 4108.444649] BTRFS critical (device sdb2): corrupt leaf, bad key
> order: block=3D3242455040,root=3D1, slot=3D0
> [ 4108.444681] BTRFS error (device sdb2): Error removing orphan entry,
> stopping orphan cleanup
> [ 4108.444684] BTRFS error (device sdb2): could not do orphan cleanup -22
> [ 4111.047323] BTRFS: open_ctree failed
>=20
> [root@rak ~]# uname -a
> Linux rak 4.1.2-2-ARCH #1 SMP PREEMPT Wed Jul 15 08:30:32 UTC 2015
> x86_64 GNU/Linux
>=20
> [root@rak ~]# btrfs fi show /dev/sdb2
> Label: 'data'  uuid: 754a3186-c0ae-4680-ab28-864c8bdad8b5
>         Total devices 1 FS bytes used 1.23TiB
>         devid    1 size 1.72TiB used 1.24TiB path /dev/sdb2
>=20
> btrfs-progs v4.2
>=20
> [root@rak ~]# btrfs --version
> btrfs-progs v4.2
>=20
> [root@rak ~]#   btrfs fi show
> Label: 'data'  uuid: 754a3186-c0ae-4680-ab28-864c8bdad8b5
>         Total devices 1 FS bytes used 1.23TiB
>         devid    1 size 1.72TiB used 1.24TiB path /dev/sdb2
>=20
> btrfs-progs v4.2

--=20
Hugo Mills             | Sometimes, when I'm alone, I Google myself.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--kOdvwer/5gjFgNo6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJWArqWAAoJEFheFHXiqx3kVxUP92evyzmpxqpztewjk5AooVuQ
po986ONJRckkO7TilCrA97KaO2vSoYOFaG+eXAaEp7lonJkYsiQIu2F1VYdbLB8X
JMSn2YAt6hwJb3ZDzmnXygUFehSfnL9sm+fZ2PX9jP5jCbc//cFMUN1I/s6l9JC8
vsosYjwYBElBQZcSa+l++pcpcV5pMpK3/MA6qp55HafsCBhFFPhlJ5KmTZ+lxtJr
tXLCOdj/ZCTOf+FjPmPMc4MBKisYjvjVJ0eGA5atAy87G591YfHcqUmiHSKK/pbE
wzf6eTX22osw5v3Wd+i+O36ADhO+fiCUUEAiC4PjNsosFUft6YU5GJPzyWgrUaM9
rtjDsRPnbDU1MkVbOezp8o4O4NkwdZk+uBWSmOlGzpYXNXAGY9unehv4AkNu56PC
HWMv/Z6qPkZMowDhAK0Pf3Upgn/Do550mmObpGuLaCectf7QUKnXTrlHRFjuzfdM
k2fGm9KIZqNpzWJ1M0vwXFib512lJbcxvGhmU1JYwwkf74k86q9qK04Wu+1c+x0O
YXxj17Nork1Pzp7orExIXOv269wB0zfRNMmzfPwjZeUOe2TRCum/eHz51WEmhjJ2
CK9lxbJ5XIUudxkIkEf+kSAXGGVLiY4j8Se/HWR53Q8yjUMK9DQM6lTXVDVwPRBR
prFa7srjEiGUOVYbiOA=
=rzdc
-----END PGP SIGNATURE-----

--kOdvwer/5gjFgNo6--
