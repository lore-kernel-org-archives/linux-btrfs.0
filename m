Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50076 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932250AbeAYA7X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 19:59:23 -0500
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: "^m'e" <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
 <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
 <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com>
 <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com>
 <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <95a8eb10-8fa7-c1c7-13c3-e4fd194fd76a@gmx.com>
Date: Thu, 25 Jan 2018 08:59:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1BYwO8d6pgjwUL9ZJDDSHbXDszDRn6CC5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1BYwO8d6pgjwUL9ZJDDSHbXDszDRn6CC5
Content-Type: multipart/mixed; boundary="rMZdvjXuBapvoLoKJscmta4c4NhMxKt5v";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ^m'e <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <95a8eb10-8fa7-c1c7-13c3-e4fd194fd76a@gmx.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
 <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
 <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com>
 <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com>
 <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
In-Reply-To: <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>

--rMZdvjXuBapvoLoKJscmta4c4NhMxKt5v
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8825=E6=97=A5 03:00, ^m'e wrote:
> The complete check:
>=20
> Checking filesystem on /dev/sdb3
> UUID: de1723e2-150c-4448-bb36-be14d7d96093
> ERROR: extent[64368619520, 524288] referencer count mismatch (root:
> 257, owner: 7804556, offset: 212992) wanted: 1, have: 0
> ERROR: data extent[1862352896 425984] backref lost
> ERROR: data extent[1886453760 479232] backref lost
> ERROR: data extent[1902219264 524288] backref lost
> ERROR: data extent[1817378816 151552] backref lost
> ERROR: data extent[1799688192 57344] backref lost
> ERROR: data extent[1830277120 258048] backref lost
> ERROR: data extent[2558107648 1368064] backref lost

Well, a little surprised to know that --repair doesn't repair it.
I'll fix them after all other problems are fixed.

> ERROR: errors found in extent allocation tree or chunk allocation
> cache and super generation don't match, space cache will be invalidated=

> ERROR: root 257 DIR_ITEM[30039322 4007295565] couldn't find relative
> INODE_ITEM[0] namelen 0 filename  filetype 0
> ERROR: root 257 DIR_ITEM[30039322 4007295565] data_len shouldn't be 329=
07

OK, another root, other than the root I'm repairing.

So the corruption seems to happen in multiple snapshots.

Anyway, I could fix it using the same code, just changing the root object=
id.

At least, the fix in the offending DIR_ITEM is working.
Just a few more roots needs to be fixed.

> ERROR: root 257 DIR_ITEM[30039322 4007295565] couldn't find relative
> INODE_ITEM[0] namelen 3 filename  filetype 0
> ERROR: root 258 EXTENT_DATA[1119172 1966080] prealloc shouldn't have da=
tasum
> ERROR: root 1327 EXTENT_DATA[60710 18219008] prealloc shouldn't have da=
tasum
> ERROR: root 1331 EXTENT_DATA[60710 18219008] prealloc shouldn't have da=
tasum
> ERROR: root 1333 EXTENT_DATA[60710 18219008] prealloc shouldn't have da=
tasum
> ERROR: root 1362 EXTENT_DATA[1119172 1966080] prealloc shouldn't have d=
atasum
> ERROR: root 1366 EXTENT_DATA[1119172 1966080] prealloc shouldn't have d=
atasum
> ERROR: root 1382 EXTENT_DATA[1119172 1966080] prealloc shouldn't have d=
atasum

Not a big problem, so handle it later.

> ERROR: root 1385 DIR_ITEM[30039322 2438219243] couldn't find relative
> INODE_ITEM[0] namelen 12 filename metadata.xml filetype 1
> ERROR: root 1385 DIR INODE [30039322] size(152) not equal to 136
> ERROR: root 1385 INODE REF[30039324 30039322] and DIR_ITEM[30039322
> 2438219243] mismatch namelen 12 filename metadata.xml filetype 1

And I forgot this one.
But this is pretty simple, I'll focus on previous problems and handle it
later.

Thanks,
Qu

> found 104348008448 bytes used err is -5
> total csum bytes: 99534904
> total tree bytes: 3204612096
> total fs tree bytes: 2984034304
> total extent tree bytes: 87818240
> btree space waste bytes: 778261104
> file data blocks allocated: 242964852736
>  referenced 198454632448
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--rMZdvjXuBapvoLoKJscmta4c4NhMxKt5v--

--1BYwO8d6pgjwUL9ZJDDSHbXDszDRn6CC5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlppK+UXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgs5QgAmVjd5+KZhkBtUStnfv0rogpF
rfr5ZtKoYA93g6k0I5X0f9hpCJ6mReFCBbTF/NndIsbd5j+Og95SaeVeRRA6WuRo
20wvbQd/ebFFdzMlrTa4pnclmnoUYzzS0EhdJHz0WEswM0fiBRk+nlkkSs/s+rjg
cZckiJz0geDCLsi4GFp1vYP1SlRkL4XFkVIv9BrX+cTIWRxNBA+rNdWdyDcvnZp2
Ka94Yz8Cp2nAQRRcLBwlVbi6DnXV/h7qPWDA78rImyyIMgv9wpGcMp7EaI03DrAH
PJ6U2VbdG1NG2UV7Q2hv8KBMSbiwt2xhVTcjA1A6wafmk2s4AxpkzXx/q1l++g==
=chOI
-----END PGP SIGNATURE-----

--1BYwO8d6pgjwUL9ZJDDSHbXDszDRn6CC5--
