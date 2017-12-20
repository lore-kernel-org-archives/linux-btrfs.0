Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54292 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932090AbdLTFl1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 00:41:27 -0500
Subject: Re: [PATCH v2 06/17] btrfs-progs: lowmem check: introduce
 force_cow_in_new_chunk()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <37268331-348d-fe29-db97-e289bb2dea1c@gmx.com>
Date: Wed, 20 Dec 2017 13:41:03 +0800
MIME-Version: 1.0
In-Reply-To: <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a5v4ETLA4wFJfkGClhyWPTJy2LRCjX25j"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a5v4ETLA4wFJfkGClhyWPTJy2LRCjX25j
Content-Type: multipart/mixed; boundary="VXpHVfUEjB3IuBIg7Pf6Lnwy5At0NGqRA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <37268331-348d-fe29-db97-e289bb2dea1c@gmx.com>
Subject: Re: [PATCH v2 06/17] btrfs-progs: lowmem check: introduce
 force_cow_in_new_chunk()
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>

--VXpHVfUEjB3IuBIg7Pf6Lnwy5At0NGqRA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 12:57, Su Yue wrote:
> Introduce create_chunk_and_block_block_group() to allocate new chunk
> and corresponding block group.
>=20
> The new function force_cow_in_new_chunk() first allocates new chunk
> and records its start.
> Then it modifies all metadata block groups cached and full.
> Finally it marks the new block group uncached and unfree.
> In the next CoW, extents states will be updated automatically by
> cache_block_group().
>=20
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 80 insertions(+)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index d98d4bda7357..311c8a9f45e8 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -10911,6 +10911,86 @@ out:
>  	return ret;
>  }
> =20
> +static int create_chunk_and_block_group(struct btrfs_fs_info *fs_info,=

> +					u64 flags, u64 *start, u64 *nbytes)
> +{
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_root *root =3D fs_info->extent_root;
> +	int ret;
> +
> +	if ((flags & BTRFS_BLOCK_GROUP_TYPE_MASK) =3D=3D 0)
> +		return -EINVAL;
> +
> +	trans =3D btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		ret =3D PTR_ERR(trans);
> +		error("error starting transaction %s", strerror(-ret));
> +		return ret;
> +	}
> +	ret =3D btrfs_alloc_chunk(trans, fs_info, start, nbytes, flags);
> +	if (ret) {
> +		error("fail to allocate new chunk %s", strerror(-ret));
> +		goto out;
> +	}
> +	ret =3D btrfs_make_block_group(trans, fs_info, 0, flags,
> +			     BTRFS_FIRST_CHUNK_TREE_OBJECTID, *start, *nbytes);
> +	if (ret) {
> +		error("fail to make block group for chunk %llu %llu %s",
> +		      *start, *nbytes, strerror(-ret));
> +		goto out;
> +	}
> +out:
> +	btrfs_commit_transaction(trans, root);
> +	return ret;
> +}
> +
> +static int force_cow_in_new_chunk(struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_block_group_cache *bg;
> +	u64 start;
> +	u64 nbytes;
> +	u64 alloc_profile;
> +	u64 flags;
> +	int ret;
> +
> +	alloc_profile =3D (fs_info->avail_metadata_alloc_bits &
> +			 fs_info->metadata_alloc_profile);
> +	flags =3D BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
> +	if (btrfs_fs_incompat(fs_info, MIXED_GROUPS))
> +		flags |=3D BTRFS_BLOCK_GROUP_DATA;
> +
> +	ret =3D create_chunk_and_block_group(fs_info, flags, &start, &nbytes)=
;

Why bother allocating a new chunk by yourself?

Just mark all block groups full and that's all.

Any later tree block allocation like btrfs_search_slot() with @cow =3D 1
will trigger chunk allocation automatically.

Thanks,
Qu

> +	if (!ret)
> +		printf("Create new chunk %llu %llu\n", start, nbytes);
> +	else
> +		goto err;
> +
> +	flags =3D BTRFS_BLOCK_GROUP_METADATA;
> +	/* Mark all metadata block groups cached and full in free space*/
> +	ret =3D modify_block_groups_cache(fs_info, flags, 1);
> +	if (ret)
> +		goto clear_bg_cache;
> +
> +	bg =3D btrfs_lookup_block_group(fs_info, start);
> +	if (!bg) {
> +		ret =3D -ENOENT;
> +		error("fail to look up block group %llu %llu", start, nbytes);
> +		goto clear_bg_cache;
> +	}
> +
> +	/* Clear block group cache just allocated */
> +	ret =3D modify_block_group_cache(fs_info, bg, 0);
> +	if (ret)
> +		goto clear_bg_cache;
> +
> +	return 0;
> +
> +clear_bg_cache:
> +	modify_block_groups_cache(fs_info, flags, 0);
> +err:
> +	return ret;
> +}
> +
>  static int check_extent_refs(struct btrfs_root *root,
>  			     struct cache_tree *extent_cache)
>  {
>=20


--VXpHVfUEjB3IuBIg7Pf6Lnwy5At0NGqRA--

--a5v4ETLA4wFJfkGClhyWPTJy2LRCjX25j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo59/AXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qip7gf/XS2rkC9ED4hDAyWSXFwBt8pQ
gdcQA+i3x4I3udXkJmOVrvCBTOkiIOf9CiOJAoc1Fi8mxfdb8T6iqnzRqHKlpMXJ
GbPsJ1G/JJZw4uMnJtWXOgf1yhaggYGlMxad54MWyLtIwq36dNAnOD8+xYTAfd+U
WX/ahIM5B/QdCP6SASs/dlnOLjXNgGiBU10d7wieyYUnX9Teau5jDIHGnO1qSvsh
zk2MxI2N9B5FfJ6cRNja5oTEKyWhBhn4ooymEb1NldT4NCCYo3R+q3m98AUwAgiJ
CPnGC1KExPu3Ei+px7ZTRZUiZgVlt5lO8j0ZwkEKb4oX9hGNXkdgWgJEe0gtEQ==
=iHUr
-----END PGP SIGNATURE-----

--a5v4ETLA4wFJfkGClhyWPTJy2LRCjX25j--
