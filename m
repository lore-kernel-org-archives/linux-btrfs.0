Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55985 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751121AbeBPD5Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 22:57:24 -0500
Subject: Re: Metadata / Data on Heterogeneous Media
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <50dba73c-9b0b-636f-f44a-224cf355f6aa@gmx.com>
Date: Fri, 16 Feb 2018 11:57:13 +0800
MIME-Version: 1.0
In-Reply-To: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="62swESeRo0yQFKOR8pztNhbsSGb5G6ov1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--62swESeRo0yQFKOR8pztNhbsSGb5G6ov1
Content-Type: multipart/mixed; boundary="2QZ8oIGowktEPnAmuxVQceYS301Aqo8D5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <50dba73c-9b0b-636f-f44a-224cf355f6aa@gmx.com>
Subject: Re: Metadata / Data on Heterogeneous Media
References: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>
In-Reply-To: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>

--2QZ8oIGowktEPnAmuxVQceYS301Aqo8D5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8816=E6=97=A5 01:15, Ellis H. Wilson III wrote:
> In discussing the performance of various metadata operations over the
> past few days I've had this idea in the back of my head, and wanted to
> see if anybody had already thought about it before (likely, I would gue=
ss).
>=20
> It appears based on this page:
> https://btrfs.wiki.kernel.org/index.php/Btrfs_design
> that data and metadata in BTRFS are fairly well isolated from one
> another, particularly in the case of large files.=C2=A0 This appears
> reinforced by a recent comment from Qu ("...btrfs strictly
> split metadata and data usage...").
>=20
> Yet, while there are plenty of options to RAID0/1/10/etc across
> generally homogeneous media types, there doesn't appear to be any
> functionality (at least that I can find) to segment different BTRFS
> internals to different types of devices.=C2=A0 E.G., place metadata tre=
es and
> extent block groups on SSD, and data trees and extent block groups on
> HDD(s).

Just want to point out that, metadata trees, block groups, *AND* tree
blocks of file trees (data trees in your words) are all *METADATA*.

That's to say, btrfs can't isolate tree blocks from file trees and other
trees. They are all tree blocks, thus all metadata.

Real data is, non-inlined, non-hole data. Tree blocks of file tress has
pointers to data, but the tree blocks of file trees are still metadata.


So even on day, btrfs supports to alloc data/meta chunks using different
strategy, we are still a step away from your
different-chunk-for-different-tree idea.

Thanks,
Qu

>=20
> Is this something that has already been considered (and if so,
> implemented, which would make me extremely happy)?=C2=A0 Is it feasible=
 it is
> hasn't been approached yet?=C2=A0 I admit my internal knowledge of BTRF=
S is
> fleeting, though I'm trying to work on that daily at this time, so
> forgive me if this is unapproachable for obvious architectural reasons.=

>=20
> Best,
>=20
> ellis
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--2QZ8oIGowktEPnAmuxVQceYS301Aqo8D5--

--62swESeRo0yQFKOR8pztNhbsSGb5G6ov1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqGVpoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh2tQgAk9pUb/eD9ziSgPFtRLsdUhYy
aS5uFcFRsuUaQS8wYT1UMrq1lk76VJ4VBTznfgQYZ8OSaPpFk1xY+5JYJ9wb5Jma
xcBAy2OFZAN80x+Km+QtGA4T3d6AX0GKCge7dxAwHpVwwK1k3B88deI8+sQdiui6
G0Pm11lp829cEHvTcCcMWS5Feo6DA/j65Nc62vdngLcz5rxKl+30exqWvFj4PL8W
v7AZ7RXsEzri+Ej+fNv1G9dXysLICp2SP+zSeC1PWFdPTSCyCm/dpduDyo1vhElL
Xk4Xt32+CGv/juY54HgN+HuL4OIn1ZwtAJZ3u65S4C0D/kGQUE1uMwLnoY5Ztw==
=Fu2k
-----END PGP SIGNATURE-----

--62swESeRo0yQFKOR8pztNhbsSGb5G6ov1--
