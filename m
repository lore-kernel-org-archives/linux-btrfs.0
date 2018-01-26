Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57692 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752102AbeAZJXG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 04:23:06 -0500
Subject: Re: [PATCH 03/15] btrfs-progs: lowmem check: find filetype in
 repair_inode_missing()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-4-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <51da7d7d-5891-48e7-eab0-a46e19fc7d26@gmx.com>
Date: Fri, 26 Jan 2018 17:22:59 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-4-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4mckIdj1A8Ms6jmj87ObkepBeMXKTzUOj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4mckIdj1A8Ms6jmj87ObkepBeMXKTzUOj
Content-Type: multipart/mixed; boundary="Wp8jatFH5lvLRwsxfFTlLu7IEXhv9SRrH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <51da7d7d-5891-48e7-eab0-a46e19fc7d26@gmx.com>
Subject: Re: [PATCH 03/15] btrfs-progs: lowmem check: find filetype in
 repair_inode_missing()
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-4-suy.fnst@cn.fujitsu.com>

--Wp8jatFH5lvLRwsxfFTlLu7IEXhv9SRrH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> If parameter @filetype is 0, repair_inode_missing will find filetype
> automatically.
>=20
> And let it return -EEXIST instead of 0 if inode item is existed.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  cmds-check.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index b200fdccf0e5..08a2662e603c 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -5161,6 +5161,9 @@ out:
>  /*
>   * Insert the missing inode item.
>   *
> + * @filetype: if 0, find file type automatically.
> + *                  if find nothing, set inode as regular file.
> + *
>   * Returns 0 means success.
>   * Returns <0 means error.
>   */
> @@ -5176,6 +5179,19 @@ static int repair_inode_item_missing(struct btrf=
s_root *root, u64 ino,
>  	key.type =3D BTRFS_INODE_ITEM_KEY;
>  	key.offset =3D 0;
> =20
> +	if (!filetype) {
> +		ret =3D find_file_type_lowmem(root, ino, &filetype);
> +		if (ret) {
> +			ret =3D guess_file_type_lowmem(root, ino, &filetype);
> +			if (ret) {
> +				filetype =3D BTRFS_FT_REG_FILE;
> +				error(
> +		"can't get file type for inode %llu, using FILE as fallback",
> +				      ino);
> +			}
> +		}
> +	}
> +
>  	btrfs_init_path(&path);
>  	trans =3D btrfs_start_transaction(root, 1);
>  	if (IS_ERR(trans)) {
> @@ -5184,7 +5200,9 @@ static int repair_inode_item_missing(struct btrfs=
_root *root, u64 ino,
>  	}
> =20
>  	ret =3D btrfs_search_slot(trans, root, &key, &path, 1, 1);
> -	if (ret < 0 || !ret)
> +	if (!ret)
> +		ret =3D -EEXIST;
> +	if (ret < 0)
>  		goto fail;
> =20
>  	/* insert inode item */
>=20


--Wp8jatFH5lvLRwsxfFTlLu7IEXhv9SRrH--

--4mckIdj1A8Ms6jmj87ObkepBeMXKTzUOj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq83MXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgyxgf/XUmb9Lou4X6xSXx6qA6GFRCv
2IccOjZB4IDiAxX+2vVA19U0kI6SPKzQXAjaUetMkGkiOHg2xICcTz3qUFiIt8jM
eRF8khKKTxmtizJfHfOmmWeDDYe181M9Ce8jupVjlNl9qhUKUY7Dc1koTWXjNG/Y
oLR4E0zDe4b8Flpmz2qXzsz0pfvSmMpGhNh1iX5y1Vj6Hp3MIrHdi6jmQukyAkZX
9NPu9emIozuTUdFW1slUABmlNbbJ7p0WR1wEG/ovuvicb/7At8OeOveX0lVAfVrW
iBnmu2YfYnpFZeAU1t9StAQdenOpGXsAUnPhp9aoUpudIjHXbf5E94pPHvT4GQ==
=uiDs
-----END PGP SIGNATURE-----

--4mckIdj1A8Ms6jmj87ObkepBeMXKTzUOj--
