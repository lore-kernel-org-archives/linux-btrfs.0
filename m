Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:46171 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753244AbeDRFEJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 01:04:09 -0400
Subject: Re: [PATCH v2 03/10] btrfs-progs: use btrfs_find_free_dir_index to
 find free inode index
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-4-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7f4c44c8-8b59-7aee-bfc1-5f921ae2887c@gmx.com>
Date: Wed, 18 Apr 2018 13:04:02 +0800
MIME-Version: 1.0
In-Reply-To: <20180327070658.13064-4-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5aPhOQ0vbF0FyLnhnjqRU2dviUG77dZdm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5aPhOQ0vbF0FyLnhnjqRU2dviUG77dZdm
Content-Type: multipart/mixed; boundary="8mfn3MoTn6CvLwEUHP3hyFO2wqNHvvINk";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <7f4c44c8-8b59-7aee-bfc1-5f921ae2887c@gmx.com>
Subject: Re: [PATCH v2 03/10] btrfs-progs: use btrfs_find_free_dir_index to
 find free inode index
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-4-lufq.fnst@cn.fujitsu.com>

--8mfn3MoTn6CvLwEUHP3hyFO2wqNHvvINk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8827=E6=97=A5 15:06, Lu Fengqi wrote:
> Since we have an existing function to find free inode index, we can
> reuse it here.
>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  inode.c | 27 +++++++--------------------
>  1 file changed, 7 insertions(+), 20 deletions(-)
>=20
> diff --git a/inode.c b/inode.c
> index 478036562652..86905365dfd8 100644
> --- a/inode.c
> +++ b/inode.c
> @@ -628,7 +628,7 @@ int btrfs_link_subvol(struct btrfs_trans_handle *tr=
ans, struct btrfs_root *root,
>  	struct btrfs_inode_item *inode_item;
>  	struct extent_buffer *leaf;
>  	struct btrfs_key key;
> -	u64 index =3D 2;
> +	u64 index;
>  	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
>  	int len;
>  	int i;
> @@ -638,28 +638,15 @@ int btrfs_link_subvol(struct btrfs_trans_handle *=
trans, struct btrfs_root *root,
>  	if (len =3D=3D 0 || len > BTRFS_NAME_LEN)
>  		return -EINVAL;
> =20
> -	/* find the free dir_index */
> -	btrfs_init_path(&path);
> -	key.objectid =3D dirid;
> -	key.type =3D BTRFS_DIR_INDEX_KEY;
> -	key.offset =3D (u64)-1;
> -
> -	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> -	if (ret <=3D 0) {
> -		error("search for DIR_INDEX dirid %llu failed: %d",
> -				(unsigned long long)dirid, ret);
> +	/* add the dir_item/dir_index */
> +	ret =3D btrfs_find_free_dir_index(root, dirid, &index);
> +	if (ret < 0) {
> +		error("unable to find free dir index dirid %llu failed: %d",
> +		      (unsigned long long)dirid, ret);
>  		goto fail;
>  	}
> =20
> -	if (path.slots[0] > 0) {
> -		path.slots[0]--;
> -		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> -		if (key.objectid =3D=3D dirid && key.type =3D=3D BTRFS_DIR_INDEX_KEY=
)
> -			index =3D key.offset + 1;
> -	}
> -	btrfs_release_path(&path);
> -
> -	/* add the dir_item/dir_index */
> +	btrfs_init_path(&path);
>  	key.objectid =3D dirid;
>  	key.offset =3D 0;
>  	key.type =3D  BTRFS_INODE_ITEM_KEY;
>=20


--8mfn3MoTn6CvLwEUHP3hyFO2wqNHvvINk--

--5aPhOQ0vbF0FyLnhnjqRU2dviUG77dZdm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrW0cIACgkQwj2R86El
/qjZzgf/bxiAq4BAjTzlYK8FHQJiGuBU93oWjN50S2wzBi8NuW+xvHX5HCIjyomu
HQg1nkty5lLrr4pCUrmHOOBasuqlFqWMKsGqEaocHj5abiBw3pjxh6Rvn8/z8qaW
9C4crbVdvIvmI/vZnPOI09UW3IiFMyicHGhxuDjNk/PwODQNyIAxMxy8i9nxLVAZ
nVAw3CgwbD/nNwpyG1mhyijhlONQr7Sz8uOT7QuflRCKylkvMxHyg3oQ+IhSugop
tgsR8i/MYBxZUimsO8XkzMMe6j1CyFQkDLa6Vvr5oVuuUOh993T+6GctU3HW2jTI
CijphK1x6DiqxZ4MU+FUI9tfj1Y49w==
=MM9m
-----END PGP SIGNATURE-----

--5aPhOQ0vbF0FyLnhnjqRU2dviUG77dZdm--
