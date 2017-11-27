Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52731 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbdK0KhT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 05:37:19 -0500
Subject: Re: [PATCH 3/3] btrfs-progs: check: exclude extents of tree blocks
 and extent items
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-4-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dffaee0f-6b98-b834-75b9-7d79a7ef3e08@gmx.com>
Date: Mon, 27 Nov 2017 18:37:11 +0800
MIME-Version: 1.0
In-Reply-To: <20171127031353.9338-4-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NS7njgnWtiNPvhISB04mq8BHLP2HBC55x"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NS7njgnWtiNPvhISB04mq8BHLP2HBC55x
Content-Type: multipart/mixed; boundary="WC8OjNus9JCH2L4fRva24D8dbIoass1Tv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <dffaee0f-6b98-b834-75b9-7d79a7ef3e08@gmx.com>
Subject: Re: [PATCH 3/3] btrfs-progs: check: exclude extents of tree blocks
 and extent items
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171127031353.9338-4-suy.fnst@cn.fujitsu.com>

--WC8OjNus9JCH2L4fRva24D8dbIoass1Tv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8827=E6=97=A5 11:13, Su Yue wrote:
> Commit d17d6663c99c ("btrfs-progs: lowmem check: Fix regression which
> screws up extent allocator") removes pin_metadata_blocks() from
> lowmem repair.
> So we have to find another way to exclude extents which should be
> occupied by tree blocks.

First thing first, any tree block which is referred by will not be freed.=


Unless some special case, like extent tree initialization which clears
the whole extent tree so we can't check if one tree block should be
freed using extent tree, there is no need to explicitly pin existing
tree blocks.

Their creation/freeing is already handled well.

Please explain the reason why you need to pin extents first.

Thanks,
Qu

>=20
> Modify pin_down_tree_blocks() only for code reuse.
> So behavior of pin_metadata_blocks() which works with option
> 'init-extent-tree' is not influenced.
>=20
> Introduce exclude_blocks_and_extent_items() to mark extents of all tree=

> blocks dirty in fs_info->excluded_extents. It also calls
> exclude_extent_items() to exclude extent_items in extent tree.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++++=
+++-----
>  1 file changed, 112 insertions(+), 10 deletions(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index c7b570bef9c3..f39285c5a3c2 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -13351,6 +13351,7 @@ out:
>  	return err;
>  }
> =20
> +static int exclude_blocks_and_extent_items(struct btrfs_fs_info *fs_in=
fo);
>  /*
>   * Low memory usage version check_chunks_and_extents.
>   */
> @@ -13363,12 +13364,22 @@ static int check_chunks_and_extents_v2(struct=
 btrfs_fs_info *fs_info)
>  	struct btrfs_root *root1;
>  	struct btrfs_root *root;
>  	struct btrfs_root *cur_root;
> +	struct extent_io_tree excluded_extents;
>  	int err =3D 0;
>  	int ret;
> =20
>  	root =3D fs_info->fs_root;
> =20
>  	if (repair) {
> +		extent_io_tree_init(&excluded_extents);
> +		fs_info->excluded_extents =3D &excluded_extents;
> +		ret =3D exclude_blocks_and_extent_items(fs_info);
> +		if (ret) {
> +			error("failed to exclude tree blocks and extent items");
> +			return ret;
> +		}
> +		reset_cached_block_groups(fs_info);
> +
>  		trans =3D btrfs_start_transaction(fs_info->extent_root, 1);
>  		if (IS_ERR(trans)) {
>  			error("failed to start transaction before check");
> @@ -13437,6 +13448,8 @@ out:
>  			err |=3D ret;
>  		else
>  			err &=3D ~BG_ACCOUNTING_ERROR;
> +		extent_io_tree_cleanup(&excluded_extents);
> +		fs_info->excluded_extents =3D NULL;
>  	}
> =20
>  	if (trans)
> @@ -13534,40 +13547,106 @@ init:
>  	return 0;
>  }
> =20
> -static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
> -				struct extent_buffer *eb, int tree_root)
> +static int exclude_extent_items(struct btrfs_fs_info *fs_info,
> +				struct extent_io_tree *tree)
> +{
> +	struct btrfs_root *root =3D fs_info->extent_root;
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	struct extent_buffer *eb;
> +	int slot;
> +	int ret;
> +	u64 start;
> +	u64 end;
> +
> +	ASSERT(tree);
> +	btrfs_init_path(&path);
> +	key.objectid =3D 0;
> +	key.type =3D 0;
> +	key.offset =3D 0;
> +
> +	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +
> +	while (1) {
> +		eb =3D path.nodes[0];
> +		slot =3D path.slots[0];
> +		btrfs_item_key_to_cpu(eb, &key, slot);
> +		if (key.type !=3D BTRFS_EXTENT_ITEM_KEY &&
> +		    key.type !=3D BTRFS_METADATA_ITEM_KEY)
> +			goto next;
> +		start =3D key.objectid;
> +		if (key.type =3D=3D BTRFS_EXTENT_ITEM_KEY)
> +			end =3D start + key.offset;
> +		else
> +			end =3D start + fs_info->nodesize;
> +
> +		set_extent_dirty(tree, start, end - 1);
> +next:
> +		ret =3D btrfs_next_item(root, &path);
> +		if (ret > 0) {
> +			ret =3D 0;
> +			goto out;
> +		}
> +		if (ret < 0)
> +			goto out;
> +	}
> +out:
> +	if (ret)
> +		error("failed to exclude extent items");
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
> +static int traverse_tree_blocks(struct btrfs_fs_info *fs_info,
> +				struct extent_buffer *eb, int tree_root,
> +				int pin)
>  {
>  	struct extent_buffer *tmp;
>  	struct btrfs_root_item *ri;
>  	struct btrfs_key key;
> +	struct extent_io_tree *tree;
>  	u64 bytenr;
>  	int level =3D btrfs_header_level(eb);
>  	int nritems;
>  	int ret;
>  	int i;
> +	u64 end =3D eb->start + eb->len;
> =20
> +	if (pin)
> +		tree =3D &fs_info->pinned_extents;
> +	else
> +		tree =3D fs_info->excluded_extents;
>  	/*
> -	 * If we have pinned this block before, don't pin it again.
> +	 * If we have pinned/excluded this block before, don't do it again.
>  	 * This can not only avoid forever loop with broken filesystem
>  	 * but also give us some speedups.
>  	 */
> -	if (test_range_bit(&fs_info->pinned_extents, eb->start,
> -			   eb->start + eb->len - 1, EXTENT_DIRTY, 0))
> +	if (test_range_bit(tree, eb->start, end - 1, EXTENT_DIRTY, 0))
>  		return 0;
> =20
> -	btrfs_pin_extent(fs_info, eb->start, eb->len);
> +	if (pin)
> +		btrfs_pin_extent(fs_info, eb->start, eb->len);
> +	else
> +		set_extent_dirty(tree, eb->start, end - 1);
> =20
>  	nritems =3D btrfs_header_nritems(eb);
>  	for (i =3D 0; i < nritems; i++) {
>  		if (level =3D=3D 0) {
> +			bool is_extent_root;
>  			btrfs_item_key_to_cpu(eb, &key, i);
>  			if (key.type !=3D BTRFS_ROOT_ITEM_KEY)
>  				continue;
>  			/* Skip the extent root and reloc roots */
> -			if (key.objectid =3D=3D BTRFS_EXTENT_TREE_OBJECTID ||
> -			    key.objectid =3D=3D BTRFS_TREE_RELOC_OBJECTID ||
> +			if (key.objectid =3D=3D BTRFS_TREE_RELOC_OBJECTID ||
>  			    key.objectid =3D=3D BTRFS_DATA_RELOC_TREE_OBJECTID)
>  				continue;
> +			is_extent_root =3D
> +				key.objectid =3D=3D BTRFS_EXTENT_TREE_OBJECTID;
> +			/* If pin, skip the extent root */
> +			if (pin && is_extent_root)
> +				continue;
>  			ri =3D btrfs_item_ptr(eb, i, struct btrfs_root_item);
>  			bytenr =3D btrfs_disk_root_bytenr(eb, ri);
> =20
> @@ -13582,7 +13661,7 @@ static int pin_down_tree_blocks(struct btrfs_fs=
_info *fs_info,
>  				fprintf(stderr, "Error reading root block\n");
>  				return -EIO;
>  			}
> -			ret =3D pin_down_tree_blocks(fs_info, tmp, 0);
> +			ret =3D traverse_tree_blocks(fs_info, tmp, 0, pin);
>  			free_extent_buffer(tmp);
>  			if (ret)
>  				return ret;
> @@ -13601,7 +13680,8 @@ static int pin_down_tree_blocks(struct btrfs_fs=
_info *fs_info,
>  				fprintf(stderr, "Error reading tree block\n");
>  				return -EIO;
>  			}
> -			ret =3D pin_down_tree_blocks(fs_info, tmp, tree_root);
> +			ret =3D traverse_tree_blocks(fs_info, tmp, tree_root,
> +						   pin);
>  			free_extent_buffer(tmp);
>  			if (ret)
>  				return ret;
> @@ -13611,6 +13691,12 @@ static int pin_down_tree_blocks(struct btrfs_f=
s_info *fs_info,
>  	return 0;
>  }
> =20
> +static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
> +				struct extent_buffer *eb, int tree_root)
> +{
> +	return traverse_tree_blocks(fs_info, eb, tree_root, 1);
> +}
> +
>  static int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
>  {
>  	int ret;
> @@ -13622,6 +13708,22 @@ static int pin_metadata_blocks(struct btrfs_fs=
_info *fs_info)
>  	return pin_down_tree_blocks(fs_info, fs_info->tree_root->node, 1);
>  }
> =20
> +static int exclude_tree_blocks(struct btrfs_fs_info *fs_info,
> +				struct extent_buffer *eb, int tree_root)
> +{
> +	return traverse_tree_blocks(fs_info, fs_info->tree_root->node, 1, 0);=

> +}
> +
> +static int exclude_blocks_and_extent_items(struct btrfs_fs_info *fs_in=
fo)
> +{
> +	int ret;
> +
> +	ret =3D exclude_extent_items(fs_info, fs_info->excluded_extents);
> +	if (ret)
> +		return ret;
> +	return exclude_tree_blocks(fs_info, fs_info->tree_root->node, 1);
> +}
> +
>  static int reset_block_groups(struct btrfs_fs_info *fs_info)
>  {
>  	struct btrfs_block_group_cache *cache;
>=20


--WC8OjNus9JCH2L4fRva24D8dbIoass1Tv--

--NS7njgnWtiNPvhISB04mq8BHLP2HBC55x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlob6tcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjkFQf8DrXE6GsaFEoZJbBHmmNXw6AG
k/jlnf+yoHUaQSLpD4C1Ntm4aPSRAdOIXbVLizS2GRng6wN41SB6eoW7gqoUCLKf
n95tBrdN/PxejLLNmLkSKQjcjzVGwopg1PYOOqjpuYIjKi/YHRy5p+sET5cVUMXx
cmO7xDccxpx+uLjmvAvur7YyiJjF6NiScpOeiarvM9uMru7TFTKJL2sMQ9IFMOcz
ggwJclALjTAQ3ph8Aie1MlC3yM+idt2DhYK72PcnJxNt7tbN5/UKr30XNaW/D9H1
mZm+DRlNYYYPdVbDYRX8bvzQ/d7OpGlh3G9E/NLucxYhfpnNwn9wUNSBbDE6AA==
=zMWE
-----END PGP SIGNATURE-----

--NS7njgnWtiNPvhISB04mq8BHLP2HBC55x--
