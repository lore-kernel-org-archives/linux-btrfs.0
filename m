Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59437 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbdK0KcN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 05:32:13 -0500
Subject: Re: [PATCH 2/3] btrfs-progs: check: record returned errors after
 walk_down_tree_v2()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-3-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f199297f-213b-500e-d425-37a1c486aa63@gmx.com>
Date: Mon, 27 Nov 2017 18:32:05 +0800
MIME-Version: 1.0
In-Reply-To: <20171127031353.9338-3-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s05o7lAFCNgIVu1mWV3CoIfRjsinutNB8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s05o7lAFCNgIVu1mWV3CoIfRjsinutNB8
Content-Type: multipart/mixed; boundary="b7uRHfBWaG1EDEnQxUKUnlFqMxLHOpMdv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <f199297f-213b-500e-d425-37a1c486aa63@gmx.com>
Subject: Re: [PATCH 2/3] btrfs-progs: check: record returned errors after
 walk_down_tree_v2()
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171127031353.9338-3-suy.fnst@cn.fujitsu.com>

--b7uRHfBWaG1EDEnQxUKUnlFqMxLHOpMdv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8827=E6=97=A5 11:13, Su Yue wrote:
> In lowmem mode with '--repair', check_chunks_and_extents_v2()
> will fix accounting in block groups and clear the error
> bit BG_ACCOUNTING_ERROR.
> However, return value of check_btrfs_root() is 0 either 1 instead of
> error bits.
>=20
> If extent tree is on error, lowmem repair always prints error and
> returns nonzero value even the filesystem is fine after repair.
>=20
> So let @err contains bits after walk_down_tree_v2().
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index 3a72f8e3877d..c7b570bef9c3 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -6607,7 +6607,7 @@ static int check_btrfs_root(struct btrfs_trans_ha=
ndle *trans,
>  		ret =3D walk_down_tree_v2(trans, root, &path, &level, &nrefs,
>  					ext_ref, check_all);
> =20
> -		err |=3D !!ret;
> +		err |=3D ret;

Since ret from walk_down_tree_v2() can be plus, minus and 0, using bit
OR here is quite confusing.

For example, if ret is -1, it will makes all bits of err to 1.

Please don't mix bit operation with possible minus value.
(And feel free to fix similar problems)

Thanks,
Qu

> =20
>  		/* if ret is negative, walk shall stop */
>  		if (ret < 0) {
>=20


--b7uRHfBWaG1EDEnQxUKUnlFqMxLHOpMdv--

--s05o7lAFCNgIVu1mWV3CoIfRjsinutNB8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlob6aUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgZoQgAmZ+rlHy0/TAAnZFzGpPZOqxQ
tTc7nXgmWLAsl9+0E4Q0VS/0y8rmmDUGU8q4TOagq7PF2zwY3Xu1LiGVUlxx0ayr
vjXv1AMgBaoRlBnXknWZzKwqVKHoA7LIsczGKogJSH/P2tZEwWrC+9WzjnhjJgFp
8sbn7jJPSS5+LAqSOK1Y9DCVYCNLUPhmTf6gtz4ZPZAkSXUs4e/XLq6X5/PDT/q9
CQ7tij6qxOiSwwndqhDtdQWB/4ClIjtD+IxBLB7urTjufykJVbcqZpd9cPJUa3la
swBnauhW1dSpPvs1a4dE5sxzWODE/8G1FBK7yxR888JniSoS3zF2F+gYFqh28w==
=Us0N
-----END PGP SIGNATURE-----

--s05o7lAFCNgIVu1mWV3CoIfRjsinutNB8--
