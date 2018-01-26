Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51282 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751429AbeAZFQf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 00:16:35 -0500
Subject: Re: [PATCH 2/6] btrfs-progs: Use fs_info instead of root for
 BTRFS_NODEPTRS_PER_BLOCK
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
 <1516936926-18707-2-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <61c11ba9-d746-9d0d-be4b-9c783666ab5a@gmx.com>
Date: Fri, 26 Jan 2018 13:16:27 +0800
MIME-Version: 1.0
In-Reply-To: <1516936926-18707-2-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="khANbDTmfN1737oRYc6XTNx7WqnrpWdBn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--khANbDTmfN1737oRYc6XTNx7WqnrpWdBn
Content-Type: multipart/mixed; boundary="Y2K4xIu7m7B3aYYUK5afdS2fy2KVOLDOx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <61c11ba9-d746-9d0d-be4b-9c783666ab5a@gmx.com>
Subject: Re: [PATCH 2/6] btrfs-progs: Use fs_info instead of root for
 BTRFS_NODEPTRS_PER_BLOCK
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
 <1516936926-18707-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516936926-18707-2-git-send-email-gujx@cn.fujitsu.com>

--Y2K4xIu7m7B3aYYUK5afdS2fy2KVOLDOx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 11:22, Gu Jinxiang wrote:
> Do a cleanup. Also make it consistent with kernel.
> Use fs_info instead of root for BTRFS_NODEPTRS_PER_BLOCK, since
> maybe in some situation we do not know root, but just know fs_info.
>=20
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  cmds-check.c |  4 ++--
>  ctree.c      | 18 +++++++++---------
>  ctree.h      |  3 +--
>  print-tree.c |  2 +-
>  quick-test.c |  2 +-
>  5 files changed, 14 insertions(+), 15 deletions(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index b118ea71..b94fab4f 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -2529,7 +2529,7 @@ static void account_bytes(struct btrfs_root *root=
, struct btrfs_path *path,
>  	if (level =3D=3D 0) {
>  		btree_space_waste +=3D btrfs_leaf_free_space(root, eb);
>  	} else {
> -		free_nrs =3D (BTRFS_NODEPTRS_PER_BLOCK(root) -
> +		free_nrs =3D (BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) -
>  			    btrfs_header_nritems(eb));
>  		btree_space_waste +=3D free_nrs * sizeof(struct btrfs_key_ptr);
>  	}
> @@ -9504,7 +9504,7 @@ static int run_next_block(struct btrfs_root *root=
,
>  				add_pending(pending, seen, ptr, size);
>  			}
>  		}
> -		btree_space_waste +=3D (BTRFS_NODEPTRS_PER_BLOCK(root) -
> +		btree_space_waste +=3D (BTRFS_NODEPTRS_PER_BLOCK(fs_info) -
>  				      nritems) * sizeof(struct btrfs_key_ptr);
>  	}
>  	total_btree_bytes +=3D buf->len;
> diff --git a/ctree.c b/ctree.c
> index cb16c42c..11d207e7 100644
> --- a/ctree.c
> +++ b/ctree.c
> @@ -429,7 +429,7 @@ btrfs_check_node(struct btrfs_root *root, struct bt=
rfs_disk_key *parent_key,
>  	u32 nritems =3D btrfs_header_nritems(buf);
>  	enum btrfs_tree_block_status ret =3D BTRFS_TREE_BLOCK_INVALID_NRITEMS=
;
> =20
> -	if (nritems =3D=3D 0 || nritems > BTRFS_NODEPTRS_PER_BLOCK(root))
> +	if (nritems =3D=3D 0 || nritems > BTRFS_NODEPTRS_PER_BLOCK(root->fs_i=
nfo))
>  		goto fail;
> =20
>  	ret =3D BTRFS_TREE_BLOCK_INVALID_PARENT_KEY;
> @@ -716,7 +716,7 @@ static int balance_level(struct btrfs_trans_handle =
*trans,
>  		return ret;
>  	}
>  	if (btrfs_header_nritems(mid) >
> -	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
> +	    BTRFS_NODEPTRS_PER_BLOCK(fs_info) / 4)
>  		return 0;
> =20
>  	left =3D read_node_slot(fs_info, parent, pslot - 1);
> @@ -884,7 +884,7 @@ static int noinline push_nodes_for_insert(struct bt=
rfs_trans_handle *trans,
>  	if (extent_buffer_uptodate(left)) {
>  		u32 left_nr;
>  		left_nr =3D btrfs_header_nritems(left);
> -		if (left_nr >=3D BTRFS_NODEPTRS_PER_BLOCK(root) - 1) {
> +		if (left_nr >=3D BTRFS_NODEPTRS_PER_BLOCK(fs_info) - 1) {
>  			wret =3D 1;
>  		} else {
>  			ret =3D btrfs_cow_block(trans, root, left, parent,
> @@ -927,7 +927,7 @@ static int noinline push_nodes_for_insert(struct bt=
rfs_trans_handle *trans,
>  	if (extent_buffer_uptodate(right)) {
>  		u32 right_nr;
>  		right_nr =3D btrfs_header_nritems(right);
> -		if (right_nr >=3D BTRFS_NODEPTRS_PER_BLOCK(root) - 1) {
> +		if (right_nr >=3D BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - 1) {
>  			wret =3D 1;
>  		} else {
>  			ret =3D btrfs_cow_block(trans, root, right,
> @@ -1146,7 +1146,7 @@ again:
>  			p->slots[level] =3D slot;
>  			if ((p->search_for_split || ins_len > 0) &&
>  			    btrfs_header_nritems(b) >=3D
> -			    BTRFS_NODEPTRS_PER_BLOCK(root) - 3) {
> +			    BTRFS_NODEPTRS_PER_BLOCK(fs_info) - 3) {
>  				int sret =3D split_node(trans, root, p, level);
>  				BUG_ON(sret > 0);
>  				if (sret)
> @@ -1292,7 +1292,7 @@ static int push_node_left(struct btrfs_trans_hand=
le *trans,
> =20
>  	src_nritems =3D btrfs_header_nritems(src);
>  	dst_nritems =3D btrfs_header_nritems(dst);
> -	push_items =3D BTRFS_NODEPTRS_PER_BLOCK(root) - dst_nritems;
> +	push_items =3D BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - dst_nritems;=

>  	WARN_ON(btrfs_header_generation(src) !=3D trans->transid);
>  	WARN_ON(btrfs_header_generation(dst) !=3D trans->transid);
> =20
> @@ -1362,7 +1362,7 @@ static int balance_node_right(struct btrfs_trans_=
handle *trans,
> =20
>  	src_nritems =3D btrfs_header_nritems(src);
>  	dst_nritems =3D btrfs_header_nritems(dst);
> -	push_items =3D BTRFS_NODEPTRS_PER_BLOCK(root) - dst_nritems;
> +	push_items =3D BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - dst_nritems;=

>  	if (push_items <=3D 0) {
>  		return 1;
>  	}
> @@ -1490,7 +1490,7 @@ static int insert_ptr(struct btrfs_trans_handle *=
trans, struct btrfs_root
>  	nritems =3D btrfs_header_nritems(lower);
>  	if (slot > nritems)
>  		BUG();
> -	if (nritems =3D=3D BTRFS_NODEPTRS_PER_BLOCK(root))
> +	if (nritems =3D=3D BTRFS_NODEPTRS_PER_BLOCK(root->fs_info))
>  		BUG();
>  	if (slot < nritems) {
>  		/* shift the items */
> @@ -1539,7 +1539,7 @@ static int split_node(struct btrfs_trans_handle *=
trans, struct btrfs_root
>  		ret =3D push_nodes_for_insert(trans, root, path, level);
>  		c =3D path->nodes[level];
>  		if (!ret && btrfs_header_nritems(c) <
> -		    BTRFS_NODEPTRS_PER_BLOCK(root) - 3)
> +		    BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - 3)
>  			return 0;
>  		if (ret < 0)
>  			return ret;
> diff --git a/ctree.h b/ctree.h
> index 11913efa..9e9d3d22 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -356,8 +356,7 @@ struct btrfs_header {
>  	u8 level;
>  } __attribute__ ((__packed__));
> =20
> -#define BTRFS_NODEPTRS_PER_BLOCK(r) (((r)->fs_info->nodesize - \
> -			        sizeof(struct btrfs_header)) / \
> +#define BTRFS_NODEPTRS_PER_BLOCK(fs_info) (BTRFS_LEAF_DATA_SIZE(fs_inf=
o) / \
>  			        sizeof(struct btrfs_key_ptr))

Why not declare it as inline function?
Since kernel code is using inline function.

Thanks,
Qu

>  #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header)=
)
>  #define BTRFS_LEAF_DATA_SIZE(fs_info) \
> diff --git a/print-tree.c b/print-tree.c
> index d3fa8621..5f37ef3e 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -1359,7 +1359,7 @@ void btrfs_print_tree(struct btrfs_root *root, st=
ruct extent_buffer *eb, int fol
>  	printf("node %llu level %d items %d free %u generation %llu owner %ll=
u\n",
>  	       (unsigned long long)eb->start,
>  	        btrfs_header_level(eb), nr,
> -		(u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr,
> +		(u32)BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - nr,
>  		(unsigned long long)btrfs_header_generation(eb),
>  		(unsigned long long)btrfs_header_owner(eb));
>  	print_uuids(eb);
> diff --git a/quick-test.c b/quick-test.c
> index b1e7999d..5da47c32 100644
> --- a/quick-test.c
> +++ b/quick-test.c
> @@ -110,7 +110,7 @@ int main(int ac, char **av) {
>  	printf("node %p level %d total ptrs %d free spc %lu\n", root->node,
>  	        btrfs_header_level(root->node),
>  		btrfs_header_nritems(root->node),
> -		(unsigned long)BTRFS_NODEPTRS_PER_BLOCK(root) -
> +		(unsigned long)BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) -
>  		btrfs_header_nritems(root->node));
>  	printf("all searches good, deleting some items\n");
>  	i =3D 0;
>=20


--Y2K4xIu7m7B3aYYUK5afdS2fy2KVOLDOx--

--khANbDTmfN1737oRYc6XTNx7WqnrpWdBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpquasXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhUmAgAgDhROGGsnBgRnqQevoFr9k1H
hu+2Sj51oSwE8pb2EuODWIB4Zq9y6m6Ufb7ivwobiUE9fjBKPagakC6lkikXJRSB
q+tFydBHvGuzSFEOYltyZPN6VD80Yjho0B6vRM2KxkAdnCHyuxMlrq7MLVrhIKjz
ILmOKLxx3EfpEgj/CZpBFRBXp2ehlsigUCPxqojuottGgwUJBro1CuVy28MGmNgo
XkboMgWAAhR0YzQ22I5J0mzmNCjRqqvER58NTTmb6vTNrbHa1p+3+6Zh7eAPztMJ
EubneNibnlpKsErkJFYbgAkli55lgrhmwkTTusaUNTZjTMm6oe2Md7aiQGWlcA==
=jZfD
-----END PGP SIGNATURE-----

--khANbDTmfN1737oRYc6XTNx7WqnrpWdBn--
