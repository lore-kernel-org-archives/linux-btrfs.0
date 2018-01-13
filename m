Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54815 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965242AbeAMA4q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 19:56:46 -0500
Subject: Re: invalid files names, btrfs check can't repair it
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
Date: Sat, 13 Jan 2018 08:56:24 +0800
MIME-Version: 1.0
In-Reply-To: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hyf60O4nCt8l7x2yg2BSUEQQwOAx37ONc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hyf60O4nCt8l7x2yg2BSUEQQwOAx37ONc
Content-Type: multipart/mixed; boundary="4Zc33QKMDuHR8oaNks8DxdSCg3QTHeFo5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
 linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
 David Sterba <dsterba@suse.com>
Message-ID: <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
Subject: Re: invalid files names, btrfs check can't repair it
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
In-Reply-To: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>

--4Zc33QKMDuHR8oaNks8DxdSCg3QTHeFo5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8813=E6=97=A5 05:04, Sebastian Andrzej Siewior w=
rote:
> Hi,
>=20
> so I had bad memory and before I realized it and removed it btrfs took =
some
> damage. Now I have this:
>=20
> |ls -lh crap/
> |ls: cannot access 'crap/2f3f379b2a3d7499471edb74869efe-1948311.d': No =
such file or directory
> |ls: cannot access 'crap/454bf066ddfbf42e0f3b77ea71c82f-878732.o': No s=
uch file or directory
> |total 0
> |-????????? ? ? ? ?            ? 2f3f379b2a3d7499471edb74869efe-1948311=
=2Ed
> |-????????? ? ? ? ?            ? 454bf066ddfbf42e0f3b77ea71c82f-878732.=
o
>=20
> and in dmesg I see:
>=20
> | BTRFS critical (device sda4): invalid dir item type: 33
> | BTRFS critical (device sda4): invalid dir item name len: 8231
>=20
> `btrfs check' (from v4.14.1) finds them and prints them but has no idea=

> what to do with it. Would it be possible to let the check tool rename
> the offended filename to something (like its inode number) put it in
> lost+found if it has any data attached to it and otherwise simply remov=
e
> it? Right now I can't remove that folder.

'Btrfs check' output please.

And in fact, btrfs check --repair has the ability to move/re-link such
file and keeps its content, as long as there is any info found in
DIR_INDEX/DIR_ITEM/INODE_REF.

If repair can't handle it, the output could help us to craft such case
and enhance btrfs-progs to repair it.

Thanks,
Qu

>=20
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--4Zc33QKMDuHR8oaNks8DxdSCg3QTHeFo5--

--hyf60O4nCt8l7x2yg2BSUEQQwOAx37ONc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpZWTgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg28gf+Iadgf1PJj8DqsEW4YapmHPQE
vJGeVT5lA+rctO/481Myg17bjb2oy1dbJw0KptcOyISPYrWAFA9AZ0tLy69W83g0
jusDKrWFwfWVfQRFH0ec0UXEOVpRhjHSxYhWeuuHsxNZBL2jXQlX/aAPHIyGaVqL
qTr/eh/nUO9ZAT4frIjZ9ywgKpLwqU0mDzT96cBch1SpRcyY/ez6+DDx3O5EPbGW
GeGMccEV69FgDwS5Mr16YC79lRLCjuggWXnKvDY1NBJmCR/FY8/bnHu8fSvaVR9B
OsPYqgVINvse6ed2eSNlNEqSrC5k5XEgoP1wvW3D10jOIgsvfzfGImitD2K8uQ==
=UH/p
-----END PGP SIGNATURE-----

--hyf60O4nCt8l7x2yg2BSUEQQwOAx37ONc--
