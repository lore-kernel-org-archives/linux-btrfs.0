Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49456 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751109AbdKBFoY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 01:44:24 -0400
Subject: Re: kernel BUG at fs/btrfs/ctree.h:3457!
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <92334609-a0a2-6cb4-5127-0c3767917ad2@gmx.com>
Date: Thu, 2 Nov 2017 13:44:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3MK8PSHixQ3kKBAlWxWIrj66eqOAQBjFP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3MK8PSHixQ3kKBAlWxWIrj66eqOAQBjFP
Content-Type: multipart/mixed; boundary="rBS10qgcJpQexoHLeVKsSE1BdwuCM4id0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
 btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <92334609-a0a2-6cb4-5127-0c3767917ad2@gmx.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.h:3457!
References: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
In-Reply-To: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>

--rBS10qgcJpQexoHLeVKsSE1BdwuCM4id0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8802=E6=97=A5 13:19, Lakshmipathi.G wrote:
> Hi.
>=20
> I'm constantly hitting this bug while running btrfs-progs:fsck-test:012=
 .
> Screencast: https://asciinema.org/a/wQxZjCeVvX2kVqKjVBGyR0klq
>=20
> Logged more details: https://bugzilla.kernel.org/show_bug.cgi?id=3D1975=
87
> Anyone else got this issue or something wrong with my test environment?=


Failed to reproduce it with btrfs-progs v4.13.3.
Kernel is v4.14-rc7.

According to your output, it shows that tree-checker caught the
irregular file extent for free space cache, just as expected.

The strange part is, the file extent for free space cache is created by
kernel, as the ASSERT() is triggering from write time verification.
And kernel strangely put some data into the uninitialized file extent,
trigger the problem.

I'll try to reproduce it with FS_CHECK_INTEGRITY enabled.

Thanks,
Qu


>=20
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--rBS10qgcJpQexoHLeVKsSE1BdwuCM4id0--

--3MK8PSHixQ3kKBAlWxWIrj66eqOAQBjFP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln6sLIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgqPQgAikuBH8cnv3adx9SerDitMvIn
Lrnq1oMWOeIMnW7rsgpd/2dDy9eG9tx/5N6CEn42jJhv6riYpSTyqLUfniNVegtl
qe8AzcXdvFMjOWA66WxTxEWXpDJQOvoCLWgbIuca/7QgB5ZneijVI9CtZ7g+BgzY
ZRREdjpylWDs/GP0c8hxDdyvF61lN9E4I90eDAk69KRbibE95bghx6FJkxbiICug
sDaaplgYZb4oX6G1vhtydvp5YTb8l1IH9bZFZiuDicQcCZTWIntO7KfsGmsBOYuJ
bTkClv/QnY1xtZJCsmp68+6zOpKagZ9wOxTVnjjx/vtRIRvvKYNj/l5eiuZ+HQ==
=Ykfh
-----END PGP SIGNATURE-----

--3MK8PSHixQ3kKBAlWxWIrj66eqOAQBjFP--
