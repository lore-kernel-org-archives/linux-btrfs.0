Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54763 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbeABIPR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 03:15:17 -0500
Subject: Re: Btrfs reserve metadata problem
To: robbieko <robbieko@synology.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <d74d1cc471fb12f8ea55cba36e82582b@synology.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bd714240-8787-6dec-2520-8c82476cdd55@gmx.com>
Date: Tue, 2 Jan 2018 16:15:01 +0800
MIME-Version: 1.0
In-Reply-To: <d74d1cc471fb12f8ea55cba36e82582b@synology.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="o4xmyGMw7qmpGnt9LEiY5aZCRvbfbzSRS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o4xmyGMw7qmpGnt9LEiY5aZCRvbfbzSRS
Content-Type: multipart/mixed; boundary="13ITXbYpr1RkDccwDqeRKGIjPJ9irl0z2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: robbieko <robbieko@synology.com>,
 Linux Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <bd714240-8787-6dec-2520-8c82476cdd55@gmx.com>
Subject: Re: Btrfs reserve metadata problem
References: <d74d1cc471fb12f8ea55cba36e82582b@synology.com>
In-Reply-To: <d74d1cc471fb12f8ea55cba36e82582b@synology.com>

--13ITXbYpr1RkDccwDqeRKGIjPJ9irl0z2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8802=E6=97=A5 15:51, robbieko wrote:
> Hi All,
>=20
> When testing Btrfs with fio 4k random write, I found that volume with
> smaller free space available has lower performance.
>=20
> It seems that the smaller the free space of volume is, the smaller
> amount of dirty page filesystem could have.
> There are only 6 MB dirty pages when free space of volume is only 10GB
> with 16KB-nodesize and cow disabled.
>=20
> btrfs will reserve metadata for every write.
> The amount to reserve is calculated as follows: nodesize *
> BTRFS_MAX_LEVEL(8) * 2, i.e., it reserves 256KB of metadata.
> The maximum amount of metadata reservation depends on size of metadata
> currently in used and free space within volume(free chunk size /16)
> When metadata reaches the limit, btrfs will need to flush the data to
> release the reservation.
>=20
> 1. Is there any logic behind the value (free chunk size /16)
>=20
> =C2=A0/*
> =C2=A0 * If we have dup, raid1 or raid10 then only half of the free
> =C2=A0 * space is actually useable. For raid56, the space info used
> =C2=A0 * doesn't include the parity drive, so we don't have to
> =C2=A0 * change the math
> =C2=A0 */
> =C2=A0if (profile & (BTRFS_BLOCK_GROUP_DUP |
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_RAID=
1 |
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GROUP_RAID=
10))
> =C2=A0 avail >>=3D 1;
>=20
> =C2=A0/*
> =C2=A0 * If we aren't flushing all things, let us overcommit up to
> =C2=A0 * 1/2th of the space. If we can flush, don't let us overcommit
> =C2=A0 * too much, let it overcommit up to 1/8 of the space.
> =C2=A0 */
> =C2=A0if (flush =3D=3D BTRFS_RESERVE_FLUSH_ALL)
> =C2=A0 avail >>=3D 3;
> =C2=A0else
> =C2=A0 avail >>=3D 1;
>=20
> 2. Is there any way to improve this problem?

One solution is to reduce the metadata reserve.

I experienced similar problem, although in qgroup metadata reservation
other than extent level reservation.

In qgroup respect, it only needs to care about the "net" reservation it
needs, so qgroup rsv can do a special calculation, get rid of the
over-killed nodesize * BTRFS_MAX_LEVEL(8) * 2.

But for extent allocator, it must ensure that there is enough space for
delalloc, so such qgroup trick can't be applied directly.


Although we can still reduce the amount a lot.

Personally speaking, btrfs may only need at most (current_tree_level +
2) * nodesize for each meta rsv.
(One for possible tree level increase, and one for extra leaf split).

And specially for delalloc, all delalloc result (file extents) are
adjust to each other, which could further reduce the meta reservation.

For example, if there are 4 outstanding extents to be written to disk,
we only need (current_tree_level + 2) *nodesize.
As even if we need to increase the tree level *AND* split tree, we will
definitely have enough free space to contain just 4 file extents.
(After a rough calculation, we can keep that meta rsv until outstanding
extent exceed 307)

So we could definitely reduce meta rsv amount needed to reduce
unnecessary flush.

Thanks,
Qu

>=20
> Thanks.
> Robbie Ko
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--13ITXbYpr1RkDccwDqeRKGIjPJ9irl0z2--

--o4xmyGMw7qmpGnt9LEiY5aZCRvbfbzSRS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpLP4UXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi7iQf/a3rczFmXhw90K2uM/BLMa54U
4g5ryj6oOSoGYE9ipZrpb/xLBth1sLt2JhH3LRbaDKRG6oxcPlK8UIOPMWyFKUzg
PMFZiJTtilBFtd06W5pU/77k3FAlpk6aKAGXWuflkXl9/x9YIrvkPN3qWquIwL/Z
dHKIbaSt4SqmtbxpJToIAvxayhbZsE54mYfM6QeTsluM/ZKT+7GBUcrg41Xcnn9f
Avc/isOVd0Wh/ZRrGFq0ORICdKxvlVKKwSvKpmkgkhkIqjmSY0xwwM44eky/futv
O/7roVeS51pTrKQOMpPdKtKvjvGzSlGfhUjBzC+7zErGDRoaFx+u1+2VKXA9Rw==
=oQX8
-----END PGP SIGNATURE-----

--o4xmyGMw7qmpGnt9LEiY5aZCRvbfbzSRS--
