Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51541 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752591AbeGBADL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Jul 2018 20:03:11 -0400
Subject: Re: btrfs check --readonly crash
To: Lewis Diamond <me@lewisdiamond.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAHwd=GkFPxS=nOviDs41+e-JNXX1QWLctP=hb-rO=vCJiyuFDA@mail.gmail.com>
 <23369eaa-d1cd-d8fd-4553-5c072a5eca36@gmx.com>
 <CAHwd=GmtzjzY5xkXoueKZy2ORn0zLG+fLtLYsUm5fD7GEAGJcQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dd5c77da-610d-e2c4-7eaa-3a728d8e60c3@gmx.com>
Date: Mon, 2 Jul 2018 08:03:04 +0800
MIME-Version: 1.0
In-Reply-To: <CAHwd=GmtzjzY5xkXoueKZy2ORn0zLG+fLtLYsUm5fD7GEAGJcQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="esdXqOZ2a3xn1n9b1BEcZ2yz2st5wb7z5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--esdXqOZ2a3xn1n9b1BEcZ2yz2st5wb7z5
Content-Type: multipart/mixed; boundary="th0Y1DgOkiDiA8N6EBLgsYsI8BMM24kCE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lewis Diamond <me@lewisdiamond.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <dd5c77da-610d-e2c4-7eaa-3a728d8e60c3@gmx.com>
Subject: Re: btrfs check --readonly crash
References: <CAHwd=GkFPxS=nOviDs41+e-JNXX1QWLctP=hb-rO=vCJiyuFDA@mail.gmail.com>
 <23369eaa-d1cd-d8fd-4553-5c072a5eca36@gmx.com>
 <CAHwd=GmtzjzY5xkXoueKZy2ORn0zLG+fLtLYsUm5fD7GEAGJcQ@mail.gmail.com>
In-Reply-To: <CAHwd=GmtzjzY5xkXoueKZy2ORn0zLG+fLtLYsUm5fD7GEAGJcQ@mail.gmail.com>

--th0Y1DgOkiDiA8N6EBLgsYsI8BMM24kCE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8802=E6=97=A5 02:01, Lewis Diamond wrote:
> Yes, you are right, after running `btrfs check --clear-space-cache v1
> <dev>` a `btrfs check --readonly` passes without error. Thanks!
>=20
> I'm absolutely not familiar with the btrfs code, but would it be
> possible to have some error handling in `btrfs check` that picks up
> this situation instead of crashing?

Patch submitted already:
https://patchwork.kernel.org/patch/10498479/

Thanks,
Qu

>=20
> On Sat, Jun 30, 2018 at 10:07 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8801=E6=97=A5 09:59, Lewis Diamond wrote:
>>> Hi,
>>> I've been told to report this issue to this mailing list.
>>>
>>> sudo btrfs check --readonly /dev/sdc
>>> Checking filesystem on /dev/sdc
>>> UUID: 2630aec8-8399-4bd8-9397-8c04953a35d5
>>> checking extents
>>> checking free space cache
>>> there is no free space entry for 1596152365056-1596152381440
>>> there is no free space entry for 1596152365056-1597220323328
>>> cache appears valid but isn't 1596146581504
>>> there is no free space entry for 1613348585472-1613348618240
>>> there is no free space entry for 1613348585472-1614400192512
>>> cache appears valid but isn't 1613326450688
>>> block group 1645538705408 has wrong amount of free space, free space
>>> cache has 58212352 block group has 58277888
>>> failed to load free space cache for block group 1645538705408
>>> block group 1683119669248 has wrong amount of free space, free space
>>> cache has 52838400 block group has 52953088
>>> failed to load free space cache for block group 1683119669248
>>> btrfs: unable to add free space :-17
>>
>> Your free space cache is corrupted.
>> And if not handled well, it could (may have already) damaged your fs
>> further.
>>
>> You could try "btrfs check --clear-space-cache v1 <dev>" to remove the=

>> free space cache completely and re-try "btrfs check --readonly" to see=

>> if it works.
>>
>> Thanks,
>> Qu
>>
>>> free-space-cache.c:843: btrfs_add_free_space: BUG_ON `ret =3D=3D -EEX=
IST`
>>> triggered, value 1
>>> btrfs(+0x37337)[0x556024d5d337]
>>> btrfs(btrfs_add_free_space+0x11d)[0x556024d5da2d]
>>> btrfs(load_free_space_cache+0xde9)[0x556024d5e889]
>>> btrfs(cmd_check+0x15fe)[0x556024d8b9ee]
>>> btrfs(main+0x88)[0x556024d38768]
>>> /usr/lib/libc.so.6(__libc_start_main+0xeb)[0x7f9382a9506b]
>>> btrfs(_start+0x2a)[0x556024d3888a]
>>> Aborted
>>>
>>>
>>> This happened on a USB HDD duo in raid 1 which had btrfs issues
>>> (probably due to a bad controller). One of the hdd was subsequently
>>> dropped by a 2 year old (causing subsequent checks to crash).
>>>
>>> -Lewis
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--th0Y1DgOkiDiA8N6EBLgsYsI8BMM24kCE--

--esdXqOZ2a3xn1n9b1BEcZ2yz2st5wb7z5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls5a7gACgkQwj2R86El
/qijgwf/RCnuC8a7miU00EqcI5ZyOAUTagPMLVGdewPyeOjTdbRqXivfskQA31+L
8EFea75qmzmYPSfGbLQC+om5agps1AhrjLLyWdm0iVdMVrNwPjxtsfdT1JivyHUK
2eoLX6pjmdR5b294musTCVwyKoYlN080xgzJy+3kSLL3tnrXDywf7sFAxCqfKUH7
f3fQS4zrM8munnYvNPpywHcHOtlc43/0pMRLSCy3ShIUA6x0c5OnVfC0kxBU1K8E
+O9qbUdFECQFjB4geHcnmSwQdsUAEQGNkDDTSPUuGCdh+oz5NaXC8jU1zBdvJ2m/
XgrARw6+fQX0wjZP0yzizexFz35xcg==
=Tq60
-----END PGP SIGNATURE-----

--esdXqOZ2a3xn1n9b1BEcZ2yz2st5wb7z5--
