Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57182 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751844AbdLTFvd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 00:51:33 -0500
Subject: Re: [PATCH v2 09/17] btrfs-progs: lowmem check: start to remove
 parameters @trans in lowmem
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-10-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3009296d-c010-ed37-acf6-4bdf8a4bcc11@gmx.com>
Date: Wed, 20 Dec 2017 13:51:11 +0800
MIME-Version: 1.0
In-Reply-To: <20171220045731.19343-10-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hPevlfMEoISugBOcD8TgMXpRyTT6CUxhh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hPevlfMEoISugBOcD8TgMXpRyTT6CUxhh
Content-Type: multipart/mixed; boundary="TkjRl2EOVZDjx8TTrkCnFPWh1YHRMJGp8";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <3009296d-c010-ed37-acf6-4bdf8a4bcc11@gmx.com>
Subject: Re: [PATCH v2 09/17] btrfs-progs: lowmem check: start to remove
 parameters @trans in lowmem
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-10-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-10-suy.fnst@cn.fujitsu.com>

--TkjRl2EOVZDjx8TTrkCnFPWh1YHRMJGp8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 12:57, Su Yue wrote:
> Since extents can be avoid overwrite by excluding or new chunk
> allocation. It's unnessesary to do all repairs in one transaction.
>=20
> This patch removes parameter @trans of repair_extent_data_item().
> repair_extent_data_item() calls try_avoid_extents_overwrite()
> and starts a transaction by itself.
>=20
> Note: This patch and next patches cause error in lowmem repair like:
> "Error: Commit_root already set when starting transaction".
> This error will disappear after removing @trans finished.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index bc405d0f3fc0..20bf3d230946 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -12064,18 +12064,19 @@ out:
>  	return err;
>  }
> =20
> +static int try_avoid_extents_overwrite(struct btrfs_fs_info *fs_info);=

>  /*
>   * If @err contains BACKREF_MISSING then add extent of the
>   * file_extent_data_item.
>   *
>   * Returns error bits after reapir.
>   */
> -static int repair_extent_data_item(struct btrfs_trans_handle *trans,
> -				   struct btrfs_root *root,
> +static int repair_extent_data_item(struct btrfs_root *root,
>  				   struct btrfs_path *pathp,
>  				   struct node_refs *nrefs,
>  				   int err)
>  {
> +	struct btrfs_trans_handle *trans =3D NULL;
>  	struct btrfs_file_extent_item *fi;
>  	struct btrfs_key fi_key;
>  	struct btrfs_key key;
> @@ -12092,6 +12093,7 @@ static int repair_extent_data_item(struct btrfs=
_trans_handle *trans,
>  	u64 file_offset;
>  	int generation;
>  	int slot;
> +	int need_insert =3D 0;
>  	int ret =3D 0;
> =20
>  	eb =3D pathp->nodes[0];
> @@ -12130,9 +12132,20 @@ static int repair_extent_data_item(struct btrf=
s_trans_handle *trans,
>  		ret =3D -EIO;
>  		goto out;
>  	}
> +	need_insert =3D ret;
> =20
> +	ret =3D try_avoid_extents_overwrite(root->fs_info);

Even it's much cheaper to pin extent tree using chunk unit, I don't
think it's a good idea to do it every time you are going to fix some
extent tree problem.

Why not just do it at the beginning of extent tree check?

Thanks,
Qu

> +	if (ret)
> +		goto out;
> +	trans =3D btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		ret =3D PTR_ERR(trans);
> +		trans =3D NULL;
> +		error("fail to start transaction %s", strerror(-ret));
> +		goto out;
> +	}
>  	/* insert an extent item */
> -	if (ret > 0) {
> +	if (need_insert) {
>  		key.objectid =3D disk_bytenr;
>  		key.type =3D BTRFS_EXTENT_ITEM_KEY;
>  		key.offset =3D num_bytes;
> @@ -12172,6 +12185,8 @@ static int repair_extent_data_item(struct btrfs=
_trans_handle *trans,
> =20
>  	err &=3D ~BACKREF_MISSING;
>  out:
> +	if (trans)
> +		btrfs_commit_transaction(trans, root);
>  	btrfs_release_path(&path);
>  	if (ret)
>  		error("can't repair root %llu extent data item[%llu %llu]",
> @@ -13445,8 +13460,7 @@ again:
>  	case BTRFS_EXTENT_DATA_KEY:
>  		ret =3D check_extent_data_item(root, path, nrefs, account_bytes);
>  		if (repair && ret)
> -			ret =3D repair_extent_data_item(trans, root, path, nrefs,
> -						      ret);
> +			ret =3D repair_extent_data_item(root, path, nrefs, ret);
>  		err |=3D ret;
>  		break;
>  	case BTRFS_BLOCK_GROUP_ITEM_KEY:
>=20


--TkjRl2EOVZDjx8TTrkCnFPWh1YHRMJGp8--

--hPevlfMEoISugBOcD8TgMXpRyTT6CUxhh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo5+k8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qju7Qf9Ea5XUR2ntDZ8FoBvV33rCmyv
guVWSOeTEduqRrTl0XLYk6RSao+36eTFCSmMzsa0vfx5v1QuBAEsZ9LbiNu3hA3w
R+Psu9jGtS+l7iR6OJAPo23x5AeRsTC+Aydpj/2s7TJPmlb6Nk0MPpB3BgCTEfu1
vlz9M3Uc9Z4leyqCq3gwO5HM+F3Tv/mYl0bRDmrFEkimRsv4GdWF0IhNj32V5cwa
8idpR1TnPlTH8XkAUScsM92esr8LrUocgjB0Fh5XlTps8axeyGKWpsUb7te6BFsl
pn08z0xVtAY2IovdkSmL+IX3hPWkW4lsFVjhwgABdSntMQj25vWg/mfqE09DRw==
=G6mM
-----END PGP SIGNATURE-----

--hPevlfMEoISugBOcD8TgMXpRyTT6CUxhh--
