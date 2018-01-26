Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60320 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751446AbeAZDhm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 22:37:42 -0500
Subject: Re: [PATCH 1/6] btrfs-progs: Use fs_info instead of root for
 BTRFS_LEAF_DATA_SIZE
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <faa1a976-f8da-cae8-ec60-9c0f68b59a30@gmx.com>
Date: Fri, 26 Jan 2018 11:37:23 +0800
MIME-Version: 1.0
In-Reply-To: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QcbuMfrx76eYfL86rWtxasBLwITFl8FCU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QcbuMfrx76eYfL86rWtxasBLwITFl8FCU
Content-Type: multipart/mixed; boundary="XQvPK4vDTRAhSh2HCx6taxm4hVCUkG7Dl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <faa1a976-f8da-cae8-ec60-9c0f68b59a30@gmx.com>
Subject: Re: [PATCH 1/6] btrfs-progs: Use fs_info instead of root for
 BTRFS_LEAF_DATA_SIZE
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>

--XQvPK4vDTRAhSh2HCx6taxm4hVCUkG7Dl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 11:22, Gu Jinxiang wrote:
> Do a cleanup. Also make it consistent with kernel.
> Use fs_info instead of root for BTRFS_LEAF_DATA_SIZE, since
> maybe in some situation we do not know root, but just know fs_info.
>=20
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  cmds-check.c              |  6 +++---
>  convert/source-ext2.c     |  2 +-
>  convert/source-reiserfs.c |  4 ++--
>  ctree.c                   | 49 +++++++++++++++++++++++++++------------=
--------
>  ctree.h                   | 10 ++++++----
>  file-item.c               |  2 +-
>  volumes.c                 |  2 +-
>  7 files changed, 42 insertions(+), 33 deletions(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index 7d6bbb07..b118ea71 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -7255,9 +7255,9 @@ again:
>  		unsigned int shift =3D 0, offset;
> =20
>  		if (i =3D=3D 0 && btrfs_item_end_nr(buf, i) !=3D
> -		    BTRFS_LEAF_DATA_SIZE(root)) {
> +		    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
>  			if (btrfs_item_end_nr(buf, i) >
> -			    BTRFS_LEAF_DATA_SIZE(root)) {
> +			    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
>  				ret =3D delete_bogus_item(root, path, buf, i);
>  				if (!ret)
>  					goto again;
> @@ -7266,7 +7266,7 @@ again:
>  				ret =3D -EIO;
>  				break;
>  			}
> -			shift =3D BTRFS_LEAF_DATA_SIZE(root) -
> +			shift =3D BTRFS_LEAF_DATA_SIZE(root->fs_info) -
>  				btrfs_item_end_nr(buf, i);
>  		} else if (i > 0 && btrfs_item_end_nr(buf, i) !=3D
>  			   btrfs_item_offset_nr(buf, i - 1)) {
> diff --git a/convert/source-ext2.c b/convert/source-ext2.c
> index e9277213..e5c2a943 100644
> --- a/convert/source-ext2.c
> +++ b/convert/source-ext2.c
> @@ -520,7 +520,7 @@ static int ext2_copy_single_xattr(struct btrfs_tran=
s_handle *trans,
>  	}
>  	strncpy(namebuf, xattr_prefix_table[name_index], XATTR_NAME_MAX);
>  	strncat(namebuf, EXT2_EXT_ATTR_NAME(entry), entry->e_name_len);
> -	if (name_len + datalen > BTRFS_LEAF_DATA_SIZE(root) -
> +	if (name_len + datalen > BTRFS_LEAF_DATA_SIZE(root->fs_info) -
>  	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
>  		fprintf(stderr, "skip large xattr on inode %Lu name %.*s\n",
>  			objectid - INO_OFFSET, name_len, namebuf);
> diff --git a/convert/source-reiserfs.c b/convert/source-reiserfs.c
> index be79d8e2..e3582bda 100644
> --- a/convert/source-reiserfs.c
> +++ b/convert/source-reiserfs.c
> @@ -676,7 +676,7 @@ static int reiserfs_xattr_indirect_fn(reiserfs_fils=
ys_t fs, u64 position,
>  	size_t alloc =3D min(position + num_blocks * fs->fs_blocksize, size);=

>  	char *body;
> =20
> -	if (size > BTRFS_LEAF_DATA_SIZE(xa_data->root) -
> +	if (size > BTRFS_LEAF_DATA_SIZE(xa_data->root->fs_info) -
>  	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
>  		fprintf(stderr, "skip large xattr on objectid %llu name %.*s\n",
>  			xa_data->target_oid, (int)xa_data->namelen,
> @@ -714,7 +714,7 @@ static int reiserfs_xattr_direct_fn(reiserfs_filsys=
_t fs, __u64 position,
>  	struct reiserfs_xattr_data *xa_data =3D data;
>  	char *newbody;
> =20
> -	if (size > BTRFS_LEAF_DATA_SIZE(xa_data->root) -
> +	if (size > BTRFS_LEAF_DATA_SIZE(xa_data->root->fs_info) -
>  	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
>  		fprintf(stderr, "skip large xattr on objectid %llu name %.*s\n",
>  			xa_data->target_oid, (int)xa_data->namelen,
> diff --git a/ctree.c b/ctree.c
> index f4cf006b..cb16c42c 100644
> --- a/ctree.c
> +++ b/ctree.c
> @@ -415,7 +415,7 @@ static inline unsigned int leaf_data_end(struct btr=
fs_root *root,

Why not make this function to follow the parameters of kernel one?

Thanks,
Qu

>  {
>  	u32 nr =3D btrfs_header_nritems(leaf);
>  	if (nr =3D=3D 0)
> -		return BTRFS_LEAF_DATA_SIZE(root);
> +		return BTRFS_LEAF_DATA_SIZE(root->fs_info);
>  	return btrfs_item_offset_nr(leaf, nr - 1);
>  }
> =20
> @@ -517,24 +517,26 @@ btrfs_check_leaf(struct btrfs_root *root, struct =
btrfs_disk_key *parent_key,
>  			goto fail;
>  		}
>  		if (i =3D=3D 0 && btrfs_item_end_nr(buf, i) !=3D
> -		    BTRFS_LEAF_DATA_SIZE(root)) {
> +		    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
>  			ret =3D BTRFS_TREE_BLOCK_INVALID_OFFSETS;
>  			fprintf(stderr, "bad item end %u wanted %u\n",
>  				btrfs_item_end_nr(buf, i),
> -				(unsigned)BTRFS_LEAF_DATA_SIZE(root));
> +				(unsigned)BTRFS_LEAF_DATA_SIZE(root->fs_info));
>  			goto fail;
>  		}
>  	}
> =20
>  	for (i =3D 0; i < nritems; i++) {
> -		if (btrfs_item_end_nr(buf, i) > BTRFS_LEAF_DATA_SIZE(root)) {
> +		if (btrfs_item_end_nr(buf, i) >
> +				BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
>  			btrfs_item_key(buf, &key, 0);
>  			btrfs_print_key(&key);
>  			fflush(stdout);
>  			ret =3D BTRFS_TREE_BLOCK_INVALID_OFFSETS;
>  			fprintf(stderr, "slot end outside of leaf %llu > %llu\n",
>  				(unsigned long long)btrfs_item_end_nr(buf, i),
> -				(unsigned long long)BTRFS_LEAF_DATA_SIZE(root));
> +				(unsigned long long)BTRFS_LEAF_DATA_SIZE(
> +					root->fs_info));
>  			goto fail;
>  		}
>  	}
> @@ -1621,7 +1623,7 @@ static int leaf_space_used(struct extent_buffer *=
l, int start, int nr)
>   */
>  int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffe=
r *leaf)
>  {
> -	u32 nodesize =3D (root ? BTRFS_LEAF_DATA_SIZE(root) : leaf->len);
> +	u32 nodesize =3D (root ? BTRFS_LEAF_DATA_SIZE(root->fs_info) : leaf->=
len);
>  	int nritems =3D btrfs_header_nritems(leaf);
>  	int ret;
>  	ret =3D nodesize - leaf_space_used(leaf, 0, nritems);
> @@ -1742,11 +1744,11 @@ static int push_leaf_right(struct btrfs_trans_h=
andle *trans, struct btrfs_root
>  	memmove_extent_buffer(right,
>  			      btrfs_leaf_data(right) + data_end - push_space,
>  			      btrfs_leaf_data(right) + data_end,
> -			      BTRFS_LEAF_DATA_SIZE(root) - data_end);
> +			      BTRFS_LEAF_DATA_SIZE(root->fs_info) - data_end);
> =20
>  	/* copy from the left data area */
>  	copy_extent_buffer(right, left, btrfs_leaf_data(right) +
> -		     BTRFS_LEAF_DATA_SIZE(root) - push_space,
> +		     BTRFS_LEAF_DATA_SIZE(root->fs_info) - push_space,
>  		     btrfs_leaf_data(left) + leaf_data_end(root, left),
>  		     push_space);
> =20
> @@ -1762,7 +1764,7 @@ static int push_leaf_right(struct btrfs_trans_han=
dle *trans, struct btrfs_root
>  	/* update the item pointers */
>  	right_nritems +=3D push_items;
>  	btrfs_set_header_nritems(right, right_nritems);
> -	push_space =3D BTRFS_LEAF_DATA_SIZE(root);
> +	push_space =3D BTRFS_LEAF_DATA_SIZE(root->fs_info);
>  	for (i =3D 0; i < right_nritems; i++) {
>  		item =3D btrfs_item_nr(i);
>  		push_space -=3D btrfs_item_size(right, item);
> @@ -1881,7 +1883,7 @@ static int push_leaf_left(struct btrfs_trans_hand=
le *trans, struct btrfs_root
>  			   btrfs_item_nr_offset(0),
>  			   push_items * sizeof(struct btrfs_item));
> =20
> -	push_space =3D BTRFS_LEAF_DATA_SIZE(root) -
> +	push_space =3D BTRFS_LEAF_DATA_SIZE(root->fs_info) -
>  		     btrfs_item_offset_nr(right, push_items -1);
> =20
>  	copy_extent_buffer(left, right, btrfs_leaf_data(left) +
> @@ -1899,7 +1901,8 @@ static int push_leaf_left(struct btrfs_trans_hand=
le *trans, struct btrfs_root
>  		item =3D btrfs_item_nr(i);
>  		ioff =3D btrfs_item_offset(left, item);
>  		btrfs_set_item_offset(left, item,
> -		      ioff - (BTRFS_LEAF_DATA_SIZE(root) - old_left_item_size));
> +		      ioff - (BTRFS_LEAF_DATA_SIZE(root->fs_info) -
> +			      old_left_item_size));
>  	}
>  	btrfs_set_header_nritems(left, old_left_nritems + push_items);
> =20
> @@ -1913,7 +1916,8 @@ static int push_leaf_left(struct btrfs_trans_hand=
le *trans, struct btrfs_root
>  		push_space =3D btrfs_item_offset_nr(right, push_items - 1) -
>  						  leaf_data_end(root, right);
>  		memmove_extent_buffer(right, btrfs_leaf_data(right) +
> -				      BTRFS_LEAF_DATA_SIZE(root) - push_space,
> +				      BTRFS_LEAF_DATA_SIZE(root->fs_info) -
> +				      push_space,
>  				      btrfs_leaf_data(right) +
>  				      leaf_data_end(root, right), push_space);
> =20
> @@ -1924,7 +1928,7 @@ static int push_leaf_left(struct btrfs_trans_hand=
le *trans, struct btrfs_root
>  	}
>  	right_nritems -=3D push_items;
>  	btrfs_set_header_nritems(right, right_nritems);
> -	push_space =3D BTRFS_LEAF_DATA_SIZE(root);
> +	push_space =3D BTRFS_LEAF_DATA_SIZE(root->fs_info);
>  	for (i =3D 0; i < right_nritems; i++) {
>  		item =3D btrfs_item_nr(i);
>  		push_space =3D push_space - btrfs_item_size(right, item);
> @@ -1981,11 +1985,12 @@ static noinline int copy_for_split(struct btrfs=
_trans_handle *trans,
>  			   nritems * sizeof(struct btrfs_item));
> =20
>  	copy_extent_buffer(right, l,
> -		     btrfs_leaf_data(right) + BTRFS_LEAF_DATA_SIZE(root) -
> +		     btrfs_leaf_data(right) +
> +		     BTRFS_LEAF_DATA_SIZE(root->fs_info) -
>  		     data_copy_size, btrfs_leaf_data(l) +
>  		     leaf_data_end(root, l), data_copy_size);
> =20
> -	rt_data_off =3D BTRFS_LEAF_DATA_SIZE(root) -
> +	rt_data_off =3D BTRFS_LEAF_DATA_SIZE(root->fs_info) -
>  		      btrfs_item_end_nr(l, mid);
> =20
>  	for (i =3D 0; i < nritems; i++) {
> @@ -2046,7 +2051,7 @@ static noinline int split_leaf(struct btrfs_trans=
_handle *trans,
>  	l =3D path->nodes[0];
>  	slot =3D path->slots[0];
>  	if (extend && data_size + btrfs_item_size_nr(l, slot) +
> -	    sizeof(struct btrfs_item) > BTRFS_LEAF_DATA_SIZE(root))
> +	    sizeof(struct btrfs_item) > BTRFS_LEAF_DATA_SIZE(root->fs_info))
>  		return -EOVERFLOW;
> =20
>  	/* first try to make some room by pushing left and right */
> @@ -2081,21 +2086,22 @@ again:
>  	if (mid <=3D slot) {
>  		if (nritems =3D=3D 1 ||
>  		    leaf_space_used(l, mid, nritems - mid) + data_size >
> -			BTRFS_LEAF_DATA_SIZE(root)) {
> +			BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
>  			if (slot >=3D nritems) {
>  				split =3D 0;
>  			} else {
>  				mid =3D slot;
>  				if (mid !=3D nritems &&
>  				    leaf_space_used(l, mid, nritems - mid) +
> -				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
> +				    data_size >
> +				    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
>  					split =3D 2;
>  				}
>  			}
>  		}
>  	} else {
>  		if (leaf_space_used(l, 0, mid) + data_size >
> -			BTRFS_LEAF_DATA_SIZE(root)) {
> +			BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
>  			if (!extend && data_size && slot =3D=3D 0) {
>  				split =3D 0;
>  			} else if ((extend || !data_size) && slot =3D=3D 0) {
> @@ -2104,7 +2110,8 @@ again:
>  				mid =3D slot;
>  				if (mid !=3D nritems &&
>  				    leaf_space_used(l, mid, nritems - mid) +
> -				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
> +				    data_size >
> +				    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
>  					split =3D 2 ;
>  				}
>  			}
> @@ -2729,7 +2736,7 @@ int btrfs_del_items(struct btrfs_trans_handle *tr=
ans, struct btrfs_root *root,
>  		}
> =20
>  		/* delete the leaf if it is mostly empty */
> -		if (used < BTRFS_LEAF_DATA_SIZE(root) / 4) {
> +		if (used < BTRFS_LEAF_DATA_SIZE(root->fs_info) / 4) {
>  			/* push_leaf_left fixes the path.
>  			 * make sure the path still points to our leaf
>  			 * for possible call to del_ptr below
> diff --git a/ctree.h b/ctree.h
> index ef422ea6..11913efa 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -360,11 +360,12 @@ struct btrfs_header {
>  			        sizeof(struct btrfs_header)) / \
>  			        sizeof(struct btrfs_key_ptr))
>  #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header)=
)
> -#define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->fs_info->no=
desize))
> -#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r) - \
> +#define BTRFS_LEAF_DATA_SIZE(fs_info) \
> +				(__BTRFS_LEAF_DATA_SIZE(fs_info->nodesize))
> +#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r->fs_info=
) - \
>  					sizeof(struct btrfs_item) - \
>  					sizeof(struct btrfs_file_extent_item))
> -#define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r) - \
> +#define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
>  				 sizeof(struct btrfs_item) -\
>  				 sizeof(struct btrfs_dir_item))
> =20
> @@ -599,7 +600,8 @@ struct btrfs_extent_item_v0 {
>  	__le32 refs;
>  } __attribute__ ((__packed__));
> =20
> -#define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r) >> 4) =
- \
> +#define BTRFS_MAX_EXTENT_ITEM_SIZE(r) \
> +			((BTRFS_LEAF_DATA_SIZE(r->fs_info) >> 4) - \
>  					sizeof(struct btrfs_item))
>  #define BTRFS_MAX_EXTENT_SIZE		SZ_128M
> =20
> diff --git a/file-item.c b/file-item.c
> index 8e169e18..7b0ff358 100644
> --- a/file-item.c
> +++ b/file-item.c
> @@ -27,7 +27,7 @@
>  #include "crc32c.h"
>  #include "internal.h"
> =20
> -#define MAX_CSUM_ITEMS(r,size) ((((BTRFS_LEAF_DATA_SIZE(r) - \
> +#define MAX_CSUM_ITEMS(r, size) ((((BTRFS_LEAF_DATA_SIZE(r->fs_info) -=
 \
>  			       sizeof(struct btrfs_item) * 2) / \
>  			       size) - 1))
>  int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
> diff --git a/volumes.c b/volumes.c
> index ce3a5405..034f5d45 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -837,7 +837,7 @@ error:
>  	return ret;
>  }
> =20
> -#define BTRFS_MAX_DEVS(r) ((BTRFS_LEAF_DATA_SIZE(r)		\
> +#define BTRFS_MAX_DEVS(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info)	\
>  			- sizeof(struct btrfs_item)		\
>  			- sizeof(struct btrfs_chunk))		\
>  			/ sizeof(struct btrfs_stripe) + 1)
>=20


--XQvPK4vDTRAhSh2HCx6taxm4hVCUkG7Dl--

--QcbuMfrx76eYfL86rWtxasBLwITFl8FCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpqonMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjwOQgArOFFaxPkGOdylYZ0JISVy6fG
SFQ+MmV4GxNQfSbMXU+Hmhd/nmf8aQ1WgKa11ywdEALXryd/C8Wg+OQrx1ycxWeY
Gn55ffFgVxC5Yip94Rjd3y2qhlTzTcfeWFfAm5UgyxKEbQx8GNmeaaxo1h/rhn+h
FhbLKleHThqUJjcwSjmiVw30ZuojzvG4/Xz4ixEtQKVrY6OGW+tX12WxDy2yStjF
IrElKL27WHU5B9Y3QfTF3MzO/nUQJMjupgMDRH2Ek9F5hkl0wjbTozmIdgurZ3uw
OW+eD7Yxbx4p4CCF5aoClsTV6+ksjLBLVsHrUgjQw4NwyEYTluwNKWpR4hoelQ==
=E8vA
-----END PGP SIGNATURE-----

--QcbuMfrx76eYfL86rWtxasBLwITFl8FCU--
