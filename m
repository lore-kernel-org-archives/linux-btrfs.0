Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62612 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752423AbdLFGSS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Dec 2017 01:18:18 -0500
Subject: Re: Chunk-Recovery fails with alignment error
To: Chris Murphy <lists@colorremedies.com>,
        Benjamin Beichler <hadrian2002@googlemail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <CAJCQCtQtYBP98QEWAn5Ks1YuEB9G1ZQ15TBk8i3MjeBOB1892g@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ec9e46bf-7f9e-5fc3-b8a9-c77c26bea768@gmx.com>
Date: Wed, 6 Dec 2017 14:18:12 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQtYBP98QEWAn5Ks1YuEB9G1ZQ15TBk8i3MjeBOB1892g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i2HURfrtbcTUh6IRt8uvCal3KHKsnAJSD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i2HURfrtbcTUh6IRt8uvCal3KHKsnAJSD
Content-Type: multipart/mixed; boundary="fOfTMJo1BnNU7aFwq64KseU7p2jEAFuap";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Benjamin Beichler <hadrian2002@googlemail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <ec9e46bf-7f9e-5fc3-b8a9-c77c26bea768@gmx.com>
Subject: Re: Chunk-Recovery fails with alignment error
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <CAJCQCtQtYBP98QEWAn5Ks1YuEB9G1ZQ15TBk8i3MjeBOB1892g@mail.gmail.com>
In-Reply-To: <CAJCQCtQtYBP98QEWAn5Ks1YuEB9G1ZQ15TBk8i3MjeBOB1892g@mail.gmail.com>

--fOfTMJo1BnNU7aFwq64KseU7p2jEAFuap
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8806=E6=97=A5 14:08, Chris Murphy wrote:
> On Tue, Dec 5, 2017 at 12:22 PM, Benjamin Beichler
> <hadrian2002@googlemail.com> wrote:
>> Hi,
>>
>> I have a setup as following:  (1,7TB drive + 128GB SSD in Bcache) <=3D=
=3D>
>> luks device <=3D=3D> btrfs FS
>> I have been running Arch linux with newest stable kernel 4.14.
>=20
> There is a known bug in 4.14 that affects all bcache backed file
> systems (maybe more, I think it's not a bcache specific bug). You need
> to downgrade or upgrade your kernel. Fix should be in 4.14.2.
>=20
> The bug was found quickly enough I'm surprised 4.14.0 would be in Arch
> stable, let alone it *still* being in stable.

Although the latest kernel is 4.14.3, it's only several days age.

It seems that the kernel update cycle of arch get sped up.

Normally kernel should stay in testing repo for a while and when it
moves into core, it's normally already *.2 or more.

Thanks,
Qu

>=20
>=20


--fOfTMJo1BnNU7aFwq64KseU7p2jEAFuap--

--i2HURfrtbcTUh6IRt8uvCal3KHKsnAJSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloni6QXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhXXQgAghebsErq1cBGMdMPWGnRRMKL
gQYJxD3zOG17XRlLfznFBe/KH0FdfB/JTrzKQ4r3Dvi1b/Jvdt7gbzqFbEWLoGvW
lX0nEMZFlFsqZWj7jXYtoyJ+MKX9S4ejaV7yhO5Dd8CjHS0LdxnwCepg9qiTMoy0
mSNfMokHqTByyBngZG+HS16HvknLsNn7VPxAanAGqgEhFvGcNoyrlB77zRqX7RWy
f6w9Evc7mOCitFvH9F2pQtPIgawVMFKNipZeDkU/IYBicleUsWemX7aYHNCVSxs/
VjkT0FKfJJLV3VNJLjDzUF5SpU0pj/Q4Unt0RDIa92JmkIHsNZohXS/NnhMVjw==
=tISO
-----END PGP SIGNATURE-----

--i2HURfrtbcTUh6IRt8uvCal3KHKsnAJSD--
