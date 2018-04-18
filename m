Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:35293 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbeDRFC5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 01:02:57 -0400
Subject: Re: [PATCH v2 02/10] btrfs-progs: extract btrfs_link_subvol from
 btrfs_mksubvol
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-3-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55438435-3da6-6b84-a8dc-22cc976e648f@gmx.com>
Date: Wed, 18 Apr 2018 13:02:43 +0800
MIME-Version: 1.0
In-Reply-To: <20180327070658.13064-3-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kbTtReYORJ4CwLarH6zAfGNuHwHccJM1S"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kbTtReYORJ4CwLarH6zAfGNuHwHccJM1S
Content-Type: multipart/mixed; boundary="qWNl7Zs3WiWqCmqGVugEEu0D5xBdUO5MB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <55438435-3da6-6b84-a8dc-22cc976e648f@gmx.com>
Subject: Re: [PATCH v2 02/10] btrfs-progs: extract btrfs_link_subvol from
 btrfs_mksubvol
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-3-lufq.fnst@cn.fujitsu.com>

--qWNl7Zs3WiWqCmqGVugEEu0D5xBdUO5MB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8827=E6=97=A5 15:06, Lu Fengqi wrote:
> The original btrfs_mksubvol is too specific to specify the directory th=
at
> the subvolume will link to. Furthermore, in this transaction, we don't =
only
> need to create root_ref/dir-item, but also update the refs or flags of
> root_item. Extract a generic btrfs_link_subvol that allow the caller pa=
ss a
> trans argument for later subvolume undelete.

The idea makes sense.

Although some small nitpicks inlined below.

>=20
> No functional changes for the btrfs_mksubvol.
>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  convert/main.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
>  ctree.h        |  5 +++--
>  inode.c        | 46 +++++++++++++++++++++-------------------------
>  3 files changed, 81 insertions(+), 27 deletions(-)
>=20
> diff --git a/convert/main.c b/convert/main.c
> index 6bdfab40d0b0..dd6b42a1f2b1 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -1002,6 +1002,63 @@ err:
>  	return ret;
>  }
> =20
> +/*
> + * Link the subvolume specified by @root_objectid to the root_dir of @=
root.

However the function name is btrfs_mksubvol(), not btrfs_link_subvol().
After reading the code, it turns out that btrfs_mksubvol() is just an
less generic btrfs_link_subvol().

> + * @root		the root of the file tree which the subvolume will
> + *			be linked to.

Here you're using btrfs_root for source subvolume.

> + * @subvol_name		the name of the subvolume which will be linked.
> + * @root_objectid	specify the subvolume which will be linked.

But here you're specifying subvolume id as destination.

It would be much better to unify both parameter to the same structure.
And personally I prefer both btrfs_root.

> + * @convert		the flag to determine whether to try to resolve
> + *			the name conflict.

This parameter is not used in this function, and the name "convert"
doesn't reflect the name conflict check.

Personally speaking, I would like the parameters to be something like
btrfs_mksubolv(struct btrfs_root *dst_root,
               struct btrfs_root *src_root)

> + *
> + * Return the root of the subvolume if success, otherwise return NULL.=

> + */
> +static struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
> +					 const char *subvol_name,
> +					 u64 root_objectid,
> +					 bool convert)
> +{
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_root *subvol_root =3D NULL;
> +	struct btrfs_key key;
> +	u64 dirid =3D btrfs_root_dirid(&root->root_item);
> +	int ret;
> +
> +
> +	trans =3D btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		error("unable to start transaction");
> +		goto fail;
> +	}
> +
> +	ret =3D btrfs_link_subvol(trans, root, subvol_name, root_objectid, di=
rid,
> +				true);
> +	if (ret) {
> +		error("unable to link subvolume %s", subvol_name);
> +		goto fail;
> +	}
> +
> +	ret =3D btrfs_commit_transaction(trans, root);
> +	if (ret) {
> +		error("transaction commit failed: %d", ret);
> +		goto fail;
> +	}
> +
> +	key.objectid =3D root_objectid;
> +	key.offset =3D (u64)-1;
> +	key.type =3D BTRFS_ROOT_ITEM_KEY;
> +
> +	subvol_root =3D btrfs_read_fs_root(root->fs_info, &key);
> +	if (!subvol_root) {
> +		error("unable to link subvolume %s", subvol_name);
> +		goto fail;
> +	}
> +
> +fail:
> +	return subvol_root;
> +}
> +
>  /*
>   * Migrate super block to its default position and zero 0 ~ 16k
>   */
> diff --git a/ctree.h b/ctree.h
> index 0fc31dd8d998..4bff0b821472 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -2797,8 +2797,9 @@ int btrfs_del_orphan_item(struct btrfs_trans_hand=
le *trans,
>  			  struct btrfs_root *root, u64 offset);
>  int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *r=
oot,
>  		char *name, int namelen, u64 parent_ino, u64 *ino, int mode);
> -struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root, const char =
*base,
> -				  u64 root_objectid, bool convert);
> +int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_r=
oot *root,
> +		      const char *base, u64 root_objectid, u64 dirid,
> +		      bool convert);
> =20
>  /* file.c */
>  int btrfs_get_extent(struct btrfs_trans_handle *trans,
> diff --git a/inode.c b/inode.c
> index 8d0812c7cf50..478036562652 100644
> --- a/inode.c
> +++ b/inode.c
> @@ -606,19 +606,28 @@ out:
>  	return ret;
>  }
> =20
> -struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
> -				  const char *base, u64 root_objectid,
> -				  bool convert)
> +/*
> + * Link the subvolume specified by @root_objectid to the directory spe=
cified by
> + * @dirid on the file tree specified by @root.
> + *
> + * @root		the root of the file tree where the directory on.
> + * @base		the name of the subvolume which will be linked.
> + * @root_objectid	specify the subvolume which will be linked.

Same nitpick about parameter here.

Thanks,
Qu

> + * @dirid		specify the directory which the subvolume will be
> + *			linked to.
> + * @convert		the flag to determine whether to try to resolve
> + *			the name conflict.
> + */
> +int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_r=
oot *root,
> +		      const char *base, u64 root_objectid, u64 dirid,
> +		      bool convert)
>  {
> -	struct btrfs_trans_handle *trans;
>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
>  	struct btrfs_root *tree_root =3D fs_info->tree_root;
> -	struct btrfs_root *new_root =3D NULL;
>  	struct btrfs_path path;
>  	struct btrfs_inode_item *inode_item;
>  	struct extent_buffer *leaf;
>  	struct btrfs_key key;
> -	u64 dirid =3D btrfs_root_dirid(&root->root_item);
>  	u64 index =3D 2;
>  	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
>  	int len;
> @@ -627,8 +636,9 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root=
 *root,
> =20
>  	len =3D strlen(base);
>  	if (len =3D=3D 0 || len > BTRFS_NAME_LEN)
> -		return NULL;
> +		return -EINVAL;
> =20
> +	/* find the free dir_index */
>  	btrfs_init_path(&path);
>  	key.objectid =3D dirid;
>  	key.type =3D BTRFS_DIR_INDEX_KEY;
> @@ -649,12 +659,7 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_roo=
t *root,
>  	}
>  	btrfs_release_path(&path);
> =20
> -	trans =3D btrfs_start_transaction(root, 1);
> -	if (IS_ERR(trans)) {
> -		error("unable to start transaction");
> -		goto fail;
> -	}
> -
> +	/* add the dir_item/dir_index */
>  	key.objectid =3D dirid;
>  	key.offset =3D 0;
>  	key.type =3D  BTRFS_INODE_ITEM_KEY;
> @@ -675,6 +680,7 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root=
 *root,
> =20
>  	memcpy(buf, base, len);
>  	if (convert) {
> +		/* try to resolve name conflict by adding the number suffix */
>  		for (i =3D 0; i < 1024; i++) {
>  			ret =3D btrfs_insert_dir_item(trans, root, buf, len,
>  					dirid, &key, BTRFS_FT_DIR, index);
> @@ -719,18 +725,8 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_roo=
t *root,
>  		goto fail;
>  	}
> =20
> -	ret =3D btrfs_commit_transaction(trans, root);
> -	if (ret) {
> -		error("transaction commit failed: %d", ret);
> -		goto fail;
> -	}
> =20
> -	new_root =3D btrfs_read_fs_root(fs_info, &key);
> -	if (IS_ERR(new_root)) {
> -		error("unable to fs read root: %lu", PTR_ERR(new_root));
> -		new_root =3D NULL;
> -	}
>  fail:
> -	btrfs_init_path(&path);
> -	return new_root;
> +	btrfs_release_path(&path);
> +	return ret;
>  }
>=20


--qWNl7Zs3WiWqCmqGVugEEu0D5xBdUO5MB--

--kbTtReYORJ4CwLarH6zAfGNuHwHccJM1S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrW0XMACgkQwj2R86El
/qgIBgf7Bp2/MpnYCRxKSIRfDmHkHbTIIt6rZAQLFCcRxiplBv2NxD9mAMMWOmcZ
DuskUN35vsBm1vTad3ZgM/AVep+iveoZ1QxWwbWaWoCpVOdLopMu2U64wZ5jeRuO
w5GmkLgPNMSR2Lo3ElDQ6cAHyVAeUi2MxWtWGSjQtgj7HJaFXUAlmKI8O9XBueP8
jy5M1rYJhRVWs2dBj9SB8Yx7qg6c2quR1GA5uwPNkfHMOptSXdL4A7/CTZljAVST
WBPhiKOLp/f/Uty3gODxuWQ4pQv/HI13qde+AyA287OiGmoxevRvEHa8nI5ByioI
WXlrk8Nc1CS8slMxqWjGyPT55x5kgQ==
=5/tc
-----END PGP SIGNATURE-----

--kbTtReYORJ4CwLarH6zAfGNuHwHccJM1S--
