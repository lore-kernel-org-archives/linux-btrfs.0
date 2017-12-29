Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63677 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753736AbdL2EA5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 23:00:57 -0500
Subject: Re: Hand Patching a BTRFS Superblock?
To: swestrup@gmail.com
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
 <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com>
 <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
 <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
 <CAJt7KB_QMivwW8APX0Bxw4m+K4BRhZ0Qh1zxOxEkcpO5hF48EQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cda353c4-8e9c-7bea-0c59-b4afc388da58@gmx.com>
Date: Fri, 29 Dec 2017 12:00:49 +0800
MIME-Version: 1.0
In-Reply-To: <CAJt7KB_QMivwW8APX0Bxw4m+K4BRhZ0Qh1zxOxEkcpO5hF48EQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6Mtmc4jGyJIlr8gjix1gIfJPIV7eRcYo3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6Mtmc4jGyJIlr8gjix1gIfJPIV7eRcYo3
Content-Type: multipart/mixed; boundary="AG0GD6oZykOnNwaRbXvzGIDtUEiBtdzRw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: swestrup@gmail.com
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <cda353c4-8e9c-7bea-0c59-b4afc388da58@gmx.com>
Subject: Re: Hand Patching a BTRFS Superblock?
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
 <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com>
 <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
 <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
 <CAJt7KB_QMivwW8APX0Bxw4m+K4BRhZ0Qh1zxOxEkcpO5hF48EQ@mail.gmail.com>
In-Reply-To: <CAJt7KB_QMivwW8APX0Bxw4m+K4BRhZ0Qh1zxOxEkcpO5hF48EQ@mail.gmail.com>

--AG0GD6oZykOnNwaRbXvzGIDtUEiBtdzRw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8829=E6=97=A5 11:35, Stirling Westrup wrote:
> On Thu, Dec 28, 2017 at 9:08 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>=20
>>
>> I strongly recommend to do a binary search for magic number "5f42 4852=

>> 6653 5f4d" to locate the real offset (if it's offset, not a toasted im=
age)
>>
> I don't understand, how would I do a binary search for that signature?
>=20
The most stupid idea is to use xxd and grep.

Something like:

# xxd /dev/sde | grep 5f42 -C1


--AG0GD6oZykOnNwaRbXvzGIDtUEiBtdzRw--

--6Mtmc4jGyJIlr8gjix1gIfJPIV7eRcYo3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpFvfEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhoogf8DNabbUvNlVrbbBVWC50zFv77
49HSliZhumjAuwAH9045a/r3MTB2J3rS4K/fLc28Rmmk59+BQMYRG5EA3AYhS9tU
NnGCwcsTk1vPn1jeO740jl+D0HyAKLka+QCytvb1T2xBB9qb32TWSyZ7pc0JFTs4
3kealdSj6h7R9JWiOxxdBGKnPRn/dgbOKffZBzG1iUhtLgjYQ5tLfiJIeYgyX1xZ
2b9qKnqGaPEWF3RrYFmFKQZrLZL9UEGoLvsd33W6whNwXwvmHGvyTFGiS50htMBj
fQuHKYP9yj5kGTeTossaMwwb/bcLxCUVSYzUPWaLyJ+ebf5843tPC/rhmlHGVg==
=wS47
-----END PGP SIGNATURE-----

--6Mtmc4jGyJIlr8gjix1gIfJPIV7eRcYo3--
