Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60317 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752217AbeBVE4V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 23:56:21 -0500
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Ellis H . Wilson III" <ellisw@panasas.com>
References: <20180222045215.16426-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c85baf37-d030-1718-1ee8-c64d2f031101@gmx.com>
Date: Thu, 22 Feb 2018 12:56:02 +0800
MIME-Version: 1.0
In-Reply-To: <20180222045215.16426-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6W6CFJl0ryPyRkmRNUVG29QaekM6XlzrB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6W6CFJl0ryPyRkmRNUVG29QaekM6XlzrB
Content-Type: multipart/mixed; boundary="anC2QohiE3p585bp0RA6cq171xaso6Idd";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Ellis H . Wilson III" <ellisw@panasas.com>
Message-ID: <c85baf37-d030-1718-1ee8-c64d2f031101@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
References: <20180222045215.16426-1-wqu@suse.com>
In-Reply-To: <20180222045215.16426-1-wqu@suse.com>

--anC2QohiE3p585bp0RA6cq171xaso6Idd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8822=E6=97=A5 12:52, Qu Wenruo wrote:
> btrfs_read_block_groups() is used to build up the block group cache for=

> all block groups, so it will iterate all block group items in extent
> tree.
>=20
> For large filesystem (TB level), it will search for BLOCK_GROUP_ITEM
> thousands times, which is the most time consuming part of mounting
> btrfs.
>=20
> So this patch will try to speed it up by:
>=20
> 1) Avoid unnecessary readahead
>    We were using READA_FORWARD to search for block group item.
>    However block group items are in fact scattered across quite a lot o=
f
>    leaves. Doing readahead will just waste our IO (especially important=

>    for HDD).
>=20
>    In real world case, for a filesystem with 3T used space, it would
>    have about 50K extent tree leaves, but only have 3K block group
>    items. Meaning we need to iterate 16 leaves to meet one block group
>    on average.
>=20
>    So readahead won't help but waste slow HDD seeks.
>=20
> 2) Use chunk mapping to locate block group items
>    Since one block group item always has one corresponding chunk item,
>    we could use chunk mapping to get the block group item size.
>=20
>    With block group item size, we can do a pinpoint tree search, instea=
d
>    of searching with some uncertain value and do forward search.
>=20
>    In some case, like next BLOCK_GROUP_ITEM is in the next leaf of
>    current path, we could save such unnecessary tree block read.
>=20
> Cc: Ellis H. Wilson III <ellisw@panasas.com>

Hi Ellis,

Would you please try this patch to see if it helps to speedup the mount
of your large filesystem?

Thanks,
Qu

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Since all my TB level storage is all occupied by my NAS, any feedback
> (especially for the real world mount speed change) is welcome.
> ---
>  fs/btrfs/extent-tree.c | 88 +++++++++++++++---------------------------=
--------
>  1 file changed, 26 insertions(+), 62 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2f4328511ac8..a3faa0cbe056 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9713,60 +9713,6 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_=
info, u64 bytenr)
>  	return ret;
>  }
> =20
> -static int find_first_block_group(struct btrfs_fs_info *fs_info,
> -				  struct btrfs_path *path,
> -				  struct btrfs_key *key)
> -{
> -	struct btrfs_root *root =3D fs_info->extent_root;
> -	int ret =3D 0;
> -	struct btrfs_key found_key;
> -	struct extent_buffer *leaf;
> -	int slot;
> -
> -	ret =3D btrfs_search_slot(NULL, root, key, path, 0, 0);
> -	if (ret < 0)
> -		goto out;
> -
> -	while (1) {
> -		slot =3D path->slots[0];
> -		leaf =3D path->nodes[0];
> -		if (slot >=3D btrfs_header_nritems(leaf)) {
> -			ret =3D btrfs_next_leaf(root, path);
> -			if (ret =3D=3D 0)
> -				continue;
> -			if (ret < 0)
> -				goto out;
> -			break;
> -		}
> -		btrfs_item_key_to_cpu(leaf, &found_key, slot);
> -
> -		if (found_key.objectid >=3D key->objectid &&
> -		    found_key.type =3D=3D BTRFS_BLOCK_GROUP_ITEM_KEY) {
> -			struct extent_map_tree *em_tree;
> -			struct extent_map *em;
> -
> -			em_tree =3D &root->fs_info->mapping_tree.map_tree;
> -			read_lock(&em_tree->lock);
> -			em =3D lookup_extent_mapping(em_tree, found_key.objectid,
> -						   found_key.offset);
> -			read_unlock(&em_tree->lock);
> -			if (!em) {
> -				btrfs_err(fs_info,
> -			"logical %llu len %llu found bg but no related chunk",
> -					  found_key.objectid, found_key.offset);
> -				ret =3D -ENOENT;
> -			} else {
> -				ret =3D 0;
> -			}
> -			free_extent_map(em);
> -			goto out;
> -		}
> -		path->slots[0]++;
> -	}
> -out:
> -	return ret;
> -}
> -
>  void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
>  {
>  	struct btrfs_block_group_cache *block_group;
> @@ -9988,12 +9934,15 @@ int btrfs_read_block_groups(struct btrfs_fs_inf=
o *info)
>  {
>  	struct btrfs_path *path;
>  	int ret;
> +	struct btrfs_mapping_tree *map_tree =3D &info->mapping_tree;
> +	struct btrfs_root *extent_root =3D info->extent_root;
>  	struct btrfs_block_group_cache *cache;
>  	struct btrfs_space_info *space_info;
>  	struct btrfs_key key;
>  	struct btrfs_key found_key;
>  	struct extent_buffer *leaf;
>  	int need_clear =3D 0;
> +	u64 cur =3D 0;
>  	u64 cache_gen;
>  	u64 feature;
>  	int mixed;
> @@ -10001,13 +9950,9 @@ int btrfs_read_block_groups(struct btrfs_fs_inf=
o *info)
>  	feature =3D btrfs_super_incompat_flags(info->super_copy);
>  	mixed =3D !!(feature & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS);
> =20
> -	key.objectid =3D 0;
> -	key.offset =3D 0;
> -	key.type =3D BTRFS_BLOCK_GROUP_ITEM_KEY;
>  	path =3D btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
> -	path->reada =3D READA_FORWARD;
> =20
>  	cache_gen =3D btrfs_super_cache_generation(info->super_copy);
>  	if (btrfs_test_opt(info, SPACE_CACHE) &&
> @@ -10017,10 +9962,30 @@ int btrfs_read_block_groups(struct btrfs_fs_in=
fo *info)
>  		need_clear =3D 1;
> =20
>  	while (1) {
> -		ret =3D find_first_block_group(info, path, &key);
> -		if (ret > 0)
> +		struct extent_map *em;
> +
> +		read_lock(&map_tree->map_tree.lock);
> +		em =3D lookup_extent_mapping(&map_tree->map_tree, cur,
> +					   ((u64)-1) - cur);
> +		read_unlock(&map_tree->map_tree.lock);
> +		if (!em)
>  			break;
> -		if (ret !=3D 0)
> +
> +		key.objectid =3D em->start;
> +		key.offset =3D em->len;
> +		key.type =3D BTRFS_BLOCK_GROUP_ITEM_KEY;
> +		cur =3D em->start + em->len;
> +		free_extent_map(em);
> +
> +		ret =3D btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
> +		if (ret > 0) {
> +			WARN(1, KERN_ERR
> +			"chunk [%llu %llu) doesn't has its block group item\n",
> +			     key.objectid, key.objectid + key.offset);
> +			ret =3D -ENOENT;
> +			goto error;
> +		}
> +		if (ret < 0)
>  			goto error;
> =20
>  		leaf =3D path->nodes[0];
> @@ -10062,7 +10027,6 @@ int btrfs_read_block_groups(struct btrfs_fs_inf=
o *info)
>  			goto error;
>  		}
> =20
> -		key.objectid =3D found_key.objectid + found_key.offset;
>  		btrfs_release_path(path);
> =20
>  		/*
>=20


--anC2QohiE3p585bp0RA6cq171xaso6Idd--

--6W6CFJl0ryPyRkmRNUVG29QaekM6XlzrB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqOTWIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgGkAf9EF7+IJ6JrLUg+ndo5gfVZYqj
oNDXxpfsZ2PCkc5dB82WEzVUqueRjMov9HGjqyYjLoltLMgL2ewSRd7Y+fjCw5ee
no5qrO380hdfjC2XCzNGrqP7Bq9i0AD3xvN6w82ksSksHUVWCrGGxtoWrLPXqt2y
tcy1jFXelk0ck43NAHGP0mCLVJILUuzx2rJiVbBT4ARkyWvj6pcbuHdloSLgjYc+
oGDmUAo72hJPmZuy5wwrp/G/4yGi9oV0Jl/I+dsEh7HoQm2P+He028PEK7vezbO8
nmZuVpFrhYVbPhVRcG+xOEMUtuPLzXeqLZZ2Gv99iRqY2x7nElwSuov2gXAiSA==
=s58s
-----END PGP SIGNATURE-----

--6W6CFJl0ryPyRkmRNUVG29QaekM6XlzrB--
