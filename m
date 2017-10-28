Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55743 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbdJ1H6h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Oct 2017 03:58:37 -0400
Subject: Re: USB upgrade fun
To: Kai Hendry <hendry@iki.fi>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
 <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
 <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
 <1509174195.600847.1153723936.0D8751F2@webmail.messagingengine.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8cff4fc5-6a33-e076-bfdb-d40dca8023ed@gmx.com>
Date: Sat, 28 Oct 2017 15:58:21 +0800
MIME-Version: 1.0
In-Reply-To: <1509174195.600847.1153723936.0D8751F2@webmail.messagingengine.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aqMjj4XWekcPL2o6TSr8NR6gcTCg4gF7e"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aqMjj4XWekcPL2o6TSr8NR6gcTCg4gF7e
Content-Type: multipart/mixed; boundary="mtXitfBw9jweN2g5boUGgcuTEUr8Nw4gj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Kai Hendry <hendry@iki.fi>, "Austin S. Hemmelgarn"
 <ahferroin7@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <8cff4fc5-6a33-e076-bfdb-d40dca8023ed@gmx.com>
Subject: Re: USB upgrade fun
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
 <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
 <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
 <1509174195.600847.1153723936.0D8751F2@webmail.messagingengine.com>
In-Reply-To: <1509174195.600847.1153723936.0D8751F2@webmail.messagingengine.com>

--mtXitfBw9jweN2g5boUGgcuTEUr8Nw4gj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8828=E6=97=A5 15:03, Kai Hendry wrote:
> On Fri, 13 Oct 2017, at 09:42 AM, Kai Hendry wrote:
>> It probably is... since when I remove my new 4TB USB disk from the
>> front, I am at least able to mount my two 2x2TB in degraded mode and s=
ee
>> my data!
>=20
> Just a follow up. I have not been of late been able to mount my data,
> even in degraded mode.
>=20
> However someone on #btrfs suggested I try an older Linux kernel & I als=
o
> found https://www.spinics.net/lists/linux-btrfs/msg69905.html to
> reaffirm my suspicions.
>=20
> Low and behold I can mount with an older kernel
> (linux-4.4.3-1-x86_64.pkg.tar.xz) !! But if I reboot into 4.13.9-1-ARCH=
,
> no worky:
>=20
> [  489.139903] BTRFS warning (device sdb1): devid 3 uuid
> e5f03f81-35e7-4a29-9608-bd78864cc0ad is missing
> [  489.524334] BTRFS info (device sdb1): bdev (null) errs: wr 0, rd 1,
> flush 0, corrupt 0, gen 0
> [  489.524367] BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 13361,=

> rd 31990017, flush 155, corrupt 0, gen 0
> [  502.934069] BTRFS warning (device sdb1): missing devices (1) exceeds=

> the limit (0), writeable mount is not allowed
> [  502.980748] BTRFS error (device sdb1): open_ctree failed
>=20
>=20
> Does anyone know how I can track the progress of "--fix-dev-size"? It
> doesn't seem part of btrfs-progs 4.13-1...
>=20
Didn't follow the whole thread, so I can't say much about the original
problem.

But concerning "--fix-dev-size", it's not merged into mainline yet.
So if you really want to try it, you could use the out-of-tree btrfs-prog=
s:
https://github.com/adam900710/btrfs-progs/tree/check_unaligned_dev

Don't get confused with the name, to use "fix-dev-size" you need to run
"btrfs rescue fix-dev-size"

However, according to your kernel message, it seems that you're missing
one device, in which case "fix-dev-size" can't handle yet.

So I'm afraid it can't help much for your case.

Thanks,
Qu


--mtXitfBw9jweN2g5boUGgcuTEUr8Nw4gj--

--aqMjj4XWekcPL2o6TSr8NR6gcTCg4gF7e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln0OJ0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi2Xwf+K8o4/+K+gC4MM/JKZRLKHE7P
9kf1hOdBsOp4rR0+QEnxNAzAFuPiaV29JoHHkPZRy66SJCBm25pH6x2GqnwVM8Gc
1foJfxI18NGVwnreM3PtVLpexUdzYgupPulx0GLRMqbbaSrbZ5ElnAT2v9nFoANi
yZhS67LYom+XX9t9l5fCOoH+WcvbQJkhywK0xrkOgi/F3fSeHCwaN7Ml5ey+7RwQ
6dZp4Z7U5gXcoDWf+E5t8BeiXOdgQiK3d3LmYodhIXE4nW7HD7V41KPWdMY0jgUK
gGrLkVVDjucMwZwZBDmbB/bRW/WDG+MpQRjGgN8zWneVPa6Xrq0B1NWNc8su8g==
=4lV3
-----END PGP SIGNATURE-----

--aqMjj4XWekcPL2o6TSr8NR6gcTCg4gF7e--
