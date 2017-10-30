Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48880 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750928AbdJ3Bqz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 21:46:55 -0400
Message-ID: <1509328001.2721.78.camel@decadent.org.uk>
Subject: Re: [stable] btrfs name length fixes
From: Ben Hutchings <ben@decadent.org.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, stable <stable@vger.kernel.org>
Date: Mon, 30 Oct 2017 01:46:41 +0000
In-Reply-To: <837a9f6f-adb3-bf63-09db-9f3eb368fca8@gmx.com>
References: <1509297309.2721.73.camel@decadent.org.uk>
         <bce85efc-21e6-e5b6-e26a-0bde01f19be7@gmx.com>
         <1509322782.2721.74.camel@decadent.org.uk>
         <837a9f6f-adb3-bf63-09db-9f3eb368fca8@gmx.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-4b7GNyTzGZWGcNmBtGiI"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-4b7GNyTzGZWGcNmBtGiI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-10-30 at 08:45 +0800, Qu Wenruo wrote:
>=20
> On 2017=E5=B9=B410=E6=9C=8830=E6=97=A5 08:19, Ben Hutchings wrote:
> > On Mon, 2017-10-30 at 07:59 +0800, Qu Wenruo wrote:
[...]
> > > These fixes will soon be replace by centralized tree-checker faciliti=
es.
> >=20
> > Is that likely to be a small enough change to be reasonably backport-
> > able?
>=20
> It depends.
>=20
> Check the thread with the subject "[PATCH v3 0/5] Enhance tree block
> validation checker"
>=20
> ----
>  fs/btrfs/Makefile       |   2 +-
>  fs/btrfs/ctree.h        |   4 +
>  fs/btrfs/disk-io.c      | 284 +-------------------------------
>  fs/btrfs/tree-checker.c | 429
> ++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 437 insertions(+), 282 deletions(-)
>  create mode 100644 fs/btrfs/tree-checker.c
> ----

That looks like it would be too big for stable.

> Since it's centralized, most of the modification will be in
> tree-checker.c, and make the impact to existing code to minimal.
>=20
> However that patchset is just the skeleton of the whole thing, name_len
> related code is not moved to tree-checker yet.
>=20
>=20
> On the other hand, the whole name_len patchset is just an enhanced
> validation checker, I'm not pretty sure if such thing should be back
> ported especially when it's just a whack-a-hole solution.

I see.  Thanks for the information.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.


--=-4b7GNyTzGZWGcNmBtGiI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAln2hIIACgkQ57/I7JWG
EQms+A//YK7p4XMIF8xAiKExFGW8/9os8rgRpr9ijIOIbK+yFpEuiPF4ixkknPNa
oiqGTw4cp68XHkDncbkPGfxLoXSB60eJk1vdIgtIwswIvL7pmGDlhh2pDMKTmhTr
Wq1MyWTYf7OyTdvhsAY+FUbpsO1f+M83w2WlpuniCDQc1ozHV+1K15Am8+5SW2tJ
h+JxKI48stnITn5pYZa9tnLdDUkChuQQWtgttaNfmYHXW4m9YMnTMOa9DJVt8f4A
Vc1M21CFJ4L8JUasTyyzBXy53FDDREIvF47S79qu3hnoHkuEjgL2qGJlMd/bxmch
M99Gz4ogbxO4MtQOzF1tJYHLDNazY515z+eRGHrrl9GcGmefp3bFJZ4YPJS9iIlo
0uiT+oLpzEpF9oPZxnwHM6cg1Qs5f0hplfykogrw3p9aviywJ5SSTkkF4ACqXvgd
izZzBNdpvayq1Y8cz6WrM5EW+OlPTI094Pzcwf5XPw1Mefe5eryU4B+kYsEnXsl9
Z/hW/mPl/FtDIuwBsERr9ZUjwJJVFD6P29x/fyDnw1Z6F4E151xWaHkV45JdnCwn
w/XZYjTyuIKFgk9qUFGB1YY9WatOMVQzU1ICu2TckAX1qvYZ/wHRNxAHOwLqD9c/
uXwO9x1CMYuYf6zbafU/Y8P62w3/uyj15/p2Ihm0U9CwzVqW4Ok=
=iXpu
-----END PGP SIGNATURE-----

--=-4b7GNyTzGZWGcNmBtGiI--
