Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:43927 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751997AbeCYLkL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Mar 2018 07:40:11 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: Fix DIR_ITEM checking in lowmem
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <526599b8-80b1-47a1-90ab-dc144927abee@gmx.com>
Date: Sun, 25 Mar 2018 19:39:59 +0800
MIME-Version: 1.0
In-Reply-To: <1521816494-22947-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9zkisFkCP86X17KFfQsX65lCQ7M0RSFGx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9zkisFkCP86X17KFfQsX65lCQ7M0RSFGx
Content-Type: multipart/mixed; boundary="aZ82E0QETZ333MCLO8gqq5OnEdxJfw3y9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <526599b8-80b1-47a1-90ab-dc144927abee@gmx.com>
Subject: Re: [PATCH 1/2] btrfs-progs: Fix DIR_ITEM checking in lowmem
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1521816494-22947-1-git-send-email-nborisov@suse.com>

--aZ82E0QETZ333MCLO8gqq5OnEdxJfw3y9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8823=E6=97=A5 22:48, Nikolay Borisov wrote:
> When checking the validity of a DIR_ITEM item the index variable
> is explicitly set to -1 so that the index check in find_inode_ref()
> is ignored. This is necessary due to possible name collisions in DIR_IT=
EMS
> (i.e multiple files with the same crc32c for their names, resulting in =
the
> identical key->offset). Currently the code is broken due to index being=
 set to
> -1 at the beginning of check_dir_item and subsequently reset to the ind=
ex found
> in find_inode_ref. On subsequent iterations of the while loop in check_=
dir_items
> we are going to erroneously perform index checking, since index is not =
-1 but=20
> whatever the index value of the last handled INODE_REF ITEM.
> Without this patch check in lowmem mode produces the following false wa=
rnings=20
> positivess:
>=20
> ERROR: root 5 INODE REF[1991456, 256] name 5ab4e28b~~~~~~~~QBXUT2GBJDRT=
5CB6ZWAJVDHK filetype 1 missing
>=20
> But the items for this name are in fact correct:=20
>=20
> ------------------SNIP------------------------
> item 13 key (256 DIR_ITEM 4227063046) itemoff 2945 itemsize 140
> 	location key (220890 INODE_ITEM 0) type FILE
> 	transid 2278 data_len 0 name_len 40
> 	name: 5ab4e1bb~~~~~~~~65KNTAWVJ5VD4SV2R3BKFCXL
> 	location key (1991456 INODE_ITEM 0) type FILE
> 	transid 2285 data_len 0 name_len 40
> 	name: 5ab4e28b~~~~~~~~QBXUT2GBJDRT5CB6ZWAJVDHK
>=20
> item 21 key (1991456 INODE_REF 256) itemoff 2104 itemsize 50
> 	index 1934146 namelen 40 name: 5ab4e28b~~~~~~~~QBXUT2GBJDRT5CB6ZWAJVDH=
K
> -------------------SNIP-------------------------
>=20
> Fix this by moving the code setting index at the beginning of the while=

> loop. This ensure that for each item in DIR_ITEM we have index set
> correctly.
>=20
> Fixes: 564901eac7a4 ("btrfs-progs: check: introduce print_dir_item_err(=
)")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  check/mode-lowmem.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>=20
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 2982e92..8bd50d1 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1217,14 +1217,6 @@ static int check_dir_item(struct btrfs_root *roo=
t, struct btrfs_key *di_key,
>  	int tmp_err;
>  	int need_research =3D 0;
> =20
> -	/*
> -	 * For DIR_ITEM set index to (u64)-1, so that find_inode_ref
> -	 * ignore index check.
> -	 */
> -	if (di_key->type =3D=3D BTRFS_DIR_INDEX_KEY)
> -		index =3D di_key->offset;
> -	else
> -		index =3D (u64)-1;
>  begin:
>  	err =3D 0;
>  	cur =3D 0;
> @@ -1254,6 +1246,15 @@ begin:
>  	memset(namebuf, 0, sizeof(namebuf) / sizeof(*namebuf));
> =20
>  	while (cur < total) {
> +		/*
> +		 * For DIR_ITEM set index to (u64)-1, so that find_inode_ref
> +		 * ignore index check.
> +		 */
> +		if (di_key->type =3D=3D BTRFS_DIR_INDEX_KEY)
> +			index =3D di_key->offset;
> +		else
> +			index =3D (u64)-1;
> +
>  		data_len =3D btrfs_dir_data_len(node, di);
>  		tmp_err =3D 0;
>  		if (data_len)
>=20


--aZ82E0QETZ333MCLO8gqq5OnEdxJfw3y9--

--9zkisFkCP86X17KFfQsX65lCQ7M0RSFGx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq3io8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgZFwgAla8+RRXulb2aq6yS2Cb5V/ZP
rWH6V9R/IGHx7s9mdj6mWXsN4vN/3SPLBE/MDTybz+cnwSq7/ELlU3KLfStjKPrC
cWotkTln883eWDG9wUN2ZbXv2brXeCWMNbb7GHDDoSJdwhJTj9/hxkhuLBJbIIXl
22A/Y0MZeOxEuVIOFBwfUkiWoz3sJAVuqMP//aLkfs9om/YfImeMu0/evZjBhy2B
XXuCzTPQ4A9I1Lz9IjkQkbgcGMDfb/x8D0YkEYhzG2eMlQRGwjM0DN8gdQSfdX8M
bU1FwL0o+ykc2F/5IjrGzPyjVW8C2X1vPY5yrJHByWFhgRyc5kLL7EDiOLQTVA==
=rktA
-----END PGP SIGNATURE-----

--9zkisFkCP86X17KFfQsX65lCQ7M0RSFGx--
