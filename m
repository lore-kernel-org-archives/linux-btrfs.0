Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53735 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753111AbeAZKBQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 05:01:16 -0500
Subject: Re: [PATCH 09/15] btrfs-progs: lowmem check: change logic of leaf
 process if repair
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-10-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <82116eb9-1ae0-a619-142e-79b27f44d431@gmx.com>
Date: Fri, 26 Jan 2018 18:01:08 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-10-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hsl4VWQOS50VUbTAtLp2gNn8wZjgyeUD6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hsl4VWQOS50VUbTAtLp2gNn8wZjgyeUD6
Content-Type: multipart/mixed; boundary="ePXn27wPhD5woi0wmAuGP1X9V1c082hqb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <82116eb9-1ae0-a619-142e-79b27f44d431@gmx.com>
Subject: Re: [PATCH 09/15] btrfs-progs: lowmem check: change logic of leaf
 process if repair
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-10-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-10-suy.fnst@cn.fujitsu.com>

--ePXn27wPhD5woi0wmAuGP1X9V1c082hqb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> In lowmem check without repair, process_one_leaf_v2() will process one
> entire leaf and inner check_inode_item() leads path point next
> leaf.
> In the beginning, process_one_leaf_v2() will let path point fist inode
> item or first position where inode id changed.
>=20
> However, in lowmem repair, process_one_leaf_v2() will be interrupted
> to process one leaf because repair will CoW the leaf. Then some items
> unprocessed is skipped.
> Since repair may also delete some items, we can't use tricks like
> record last checked key.
>=20
> So, only for lowmem repair:
> 1. check_inode_item is responsible for handle case missing inode item.

I think the idea to use inode item as the indicator is a good idea.
And since only check_inode_item() can delete inode item, let it to
handle the path is reasonable.

> 2. process_one_leaf_v2() do not modify path manually, and check_inode()=

>    promise that @path points last checked item.
>    Only when something are fixed, process_one_leaf_v2() will continue
>    to check in next round.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++=
--------
>  1 file changed, 59 insertions(+), 9 deletions(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index e57eea4e61c9..ae0a9e146399 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -2007,6 +2007,8 @@ static int process_one_leaf_v2(struct btrfs_root =
*root, struct btrfs_path *path,
> =20
>  	cur_bytenr =3D cur->start;
> =20
> +	if (repair)
> +		goto again;
>  	/* skip to first inode item or the first inode number change */
>  	nritems =3D btrfs_header_nritems(cur);
>  	for (i =3D 0; i < nritems; i++) {
> @@ -2033,9 +2035,12 @@ again:
>  		goto out;
> =20
>  	/* still have inode items in thie leaf */
> -	if (cur->start =3D=3D cur_bytenr)
> +	if (cur->start =3D=3D cur_bytenr) {
> +		ret =3D btrfs_next_item(root, path);
> +		if (ret > 0)
> +			goto out;
>  		goto again;
> -
> +	}
>  	/*
>  	 * we have switched to another leaf, above nodes may
>  	 * have changed, here walk down the path, if a node
> @@ -5721,6 +5726,8 @@ static int repair_dir_item(struct btrfs_root *roo=
t, struct btrfs_key *key,
>  				      ino);
>  			}
>  		}
> +	} else {
> +		true_filetype =3D filetype;

This modification doesn't seems related to this patch.

Maybe it's better to move it 4th patch?

>  	}
> =20
>  	/*
> @@ -6489,6 +6496,45 @@ out:
>  	return ret;
>  }
> =20
> +/*
> + * Try insert new inode item frist.
> + * If failed, jump to next inode item.
> + */
> +static int handle_inode_item_missing(struct btrfs_root *root,
> +				     struct btrfs_path *path)
> +{
> +	struct btrfs_key key;
> +	int ret;
> +
> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> +
> +	ret =3D repair_inode_item_missing(root, key.objectid, 0);
> +	if (!ret) {
> +		btrfs_release_path(path);
> +		ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +		if (ret)
> +			goto next_inode;
> +		else
> +			goto out;
> +	}
> +
> +next_inode:
> +	error("inode item[%llu] is missing, skip to check next inode",
> +	      key.objectid);
> +	while (1) {
> +		ret =3D btrfs_next_item(root, path);
> +		if (ret > 0)
> +			goto out;

ret < 0 case is not handled.

> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> +		if (key.type =3D=3D BTRFS_INODE_ITEM_KEY) {
> +			ret =3D 0;
> +			break;
> +		}
> +	}
> +out:
> +	return ret;
> +}
> +
>  /*
>   * Check INODE_ITEM and related ITEMs (the same inode number)
>   * 1. check link count
> @@ -6536,6 +6582,13 @@ static int check_inode_item(struct btrfs_root *r=
oot, struct btrfs_path *path,
>  			err |=3D LAST_ITEM;
>  		return err;
>  	}
> +	if (key.type !=3D BTRFS_INODE_ITEM_KEY && repair) {
> +		ret =3D handle_inode_item_missing(root, path);
> +		if (ret > 0)
> +			err |=3D LAST_ITEM;
> +		if (ret)
> +			return err;
> +	}
> =20
>  	ii =3D btrfs_item_ptr(node, slot, struct btrfs_inode_item);
>  	isize =3D btrfs_inode_size(node, ii);
> @@ -6561,7 +6614,6 @@ static int check_inode_item(struct btrfs_root *ro=
ot, struct btrfs_path *path,
>  		btrfs_item_key_to_cpu(node, &key, slot);
>  		if (key.objectid !=3D inode_id)
>  			goto out;
> -
>  		switch (key.type) {
>  		case BTRFS_INODE_REF_KEY:
>  			ret =3D check_inode_ref(root, &key, path, namebuf,
> @@ -6608,12 +6660,10 @@ static int check_inode_item(struct btrfs_root *=
root, struct btrfs_path *path,
>  	}
> =20
>  out:
> -	if (err & LAST_ITEM) {
> -		btrfs_release_path(path);
> -		ret =3D btrfs_search_slot(NULL, root, &last_key, path, 0, 0);
> -		if (ret)
> -			return err;
> -	}
> +	btrfs_release_path(path);
> +	ret =3D btrfs_search_slot(NULL, root, &last_key, path, 0, 0);
> +	if (ret)
> +		return err;

Why the LAST_ITEM bit is ignored now?

Thanks,
Qu

> =20
>  	/* verify INODE_ITEM nlink/isize/nbytes */
>  	if (dir) {
>=20


--ePXn27wPhD5woi0wmAuGP1X9V1c082hqb--

--hsl4VWQOS50VUbTAtLp2gNn8wZjgyeUD6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq/GQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjOoAf7BHGgHk9oGihnsjAKNGzU+psv
MdTaDkaGmrOzLuvEnezNDsYIaiyxh3YXKjWHa0d2QbIjurwPs3jzXc+u9YM55X6/
M8TVrFFbwUcLoDZwoSHlSL7KLACbFcStMsW7ugBNf/w2QvldTz36ogy+7MEwOotZ
pFtxeYaB0EL1OgeSDBzYPgE6BhigwxqGv2Ijcyd7BX+m7ZdVnvwP3xJvVtl67clA
WoHkrKX/zei6uju91rThKCL/lXhe67GpdbwXSKChPKixN6TlGaWbzWndbEr0SKwQ
eEvHUvjiISLnPdc5HBlPXEbWF1XOgGHLeUmBv23n/SbuIXvqrH5xusDdKv9VGA==
=5rTo
-----END PGP SIGNATURE-----

--hsl4VWQOS50VUbTAtLp2gNn8wZjgyeUD6--
