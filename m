Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62648 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751511AbeA3Hgj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 02:36:39 -0500
Subject: Re: [PATCH v2 7/7] btrfs-progs: Cleanup use of root in leaf_data_end
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
 <1516951566-21777-8-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <532054be-f016-67e3-93b2-5adcc191bef3@gmx.com>
Date: Tue, 30 Jan 2018 15:36:28 +0800
MIME-Version: 1.0
In-Reply-To: <1516951566-21777-8-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OokbgRvaDPDNFFBSdEpvUTH1wr8iFvLf9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OokbgRvaDPDNFFBSdEpvUTH1wr8iFvLf9
Content-Type: multipart/mixed; boundary="WqrWun5Xa05Fs0niFzCqsbjExIDvvYc0M";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <532054be-f016-67e3-93b2-5adcc191bef3@gmx.com>
Subject: Re: [PATCH v2 7/7] btrfs-progs: Cleanup use of root in leaf_data_end
References: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
 <1516951566-21777-8-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516951566-21777-8-git-send-email-gujx@cn.fujitsu.com>

--WqrWun5Xa05Fs0niFzCqsbjExIDvvYc0M
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 15:26, Gu Jinxiang wrote:
> In function leaf_data_end, root is just used to get fs_info,
> so change the parameter of this function from btrfs_root to
> btrfs_fs_info.
> And also make it consistent with kernel.
>=20
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  ctree.c | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
>=20
> diff --git a/ctree.c b/ctree.c
> index 11d207e7..2417483d 100644
> --- a/ctree.c
> +++ b/ctree.c
> @@ -410,12 +410,12 @@ static int btrfs_comp_keys(struct btrfs_disk_key =
*disk, struct btrfs_key *k2)
>   * this returns the address of the start of the last item,
>   * which is the stop of the leaf data stack
>   */
> -static inline unsigned int leaf_data_end(struct btrfs_root *root,
> -					 struct extent_buffer *leaf)
> +static inline unsigned int leaf_data_end(const struct btrfs_fs_info *f=
s_info,
> +					 const struct extent_buffer *leaf)

Here leaf is const, which is fine.

>  {
>  	u32 nr =3D btrfs_header_nritems(leaf);
>  	if (nr =3D=3D 0)
> -		return BTRFS_LEAF_DATA_SIZE(root->fs_info);
> +		return BTRFS_LEAF_DATA_SIZE(fs_info);
>  	return btrfs_item_offset_nr(leaf, nr - 1);

But btrfs_item_offset_nr() doesn't have const prefix for leaf.
Leaving the following warning:

passing argument 1 of =E2=80=98btrfs_item_offset_nr=E2=80=99 discards =E2=
=80=98const=E2=80=99 qualifier
from pointer target type [-Wdiscarded-qualifiers]
  return btrfs_item_offset_nr(leaf, nr - 1);
                              ^~~~

Thanks,
Qu
>  }
> =20
> @@ -1737,10 +1737,10 @@ static int push_leaf_right(struct btrfs_trans_h=
andle *trans, struct btrfs_root
>  	right_nritems =3D btrfs_header_nritems(right);
> =20
>  	push_space =3D btrfs_item_end_nr(left, left_nritems - push_items);
> -	push_space -=3D leaf_data_end(root, left);
> +	push_space -=3D leaf_data_end(fs_info, left);
> =20
>  	/* make room in the right data area */
> -	data_end =3D leaf_data_end(root, right);
> +	data_end =3D leaf_data_end(fs_info, right);
>  	memmove_extent_buffer(right,
>  			      btrfs_leaf_data(right) + data_end - push_space,
>  			      btrfs_leaf_data(right) + data_end,
> @@ -1749,7 +1749,7 @@ static int push_leaf_right(struct btrfs_trans_han=
dle *trans, struct btrfs_root
>  	/* copy from the left data area */
>  	copy_extent_buffer(right, left, btrfs_leaf_data(right) +
>  		     BTRFS_LEAF_DATA_SIZE(root->fs_info) - push_space,
> -		     btrfs_leaf_data(left) + leaf_data_end(root, left),
> +		     btrfs_leaf_data(left) + leaf_data_end(fs_info, left),
>  		     push_space);
> =20
>  	memmove_extent_buffer(right, btrfs_item_nr_offset(push_items),
> @@ -1887,7 +1887,7 @@ static int push_leaf_left(struct btrfs_trans_hand=
le *trans, struct btrfs_root
>  		     btrfs_item_offset_nr(right, push_items -1);
> =20
>  	copy_extent_buffer(left, right, btrfs_leaf_data(left) +
> -		     leaf_data_end(root, left) - push_space,
> +		     leaf_data_end(fs_info, left) - push_space,
>  		     btrfs_leaf_data(right) +
>  		     btrfs_item_offset_nr(right, push_items - 1),
>  		     push_space);
> @@ -1914,12 +1914,13 @@ static int push_leaf_left(struct btrfs_trans_ha=
ndle *trans, struct btrfs_root
> =20
>  	if (push_items < right_nritems) {
>  		push_space =3D btrfs_item_offset_nr(right, push_items - 1) -
> -						  leaf_data_end(root, right);
> +						  leaf_data_end(fs_info, right);
>  		memmove_extent_buffer(right, btrfs_leaf_data(right) +
>  				      BTRFS_LEAF_DATA_SIZE(root->fs_info) -
>  				      push_space,
>  				      btrfs_leaf_data(right) +
> -				      leaf_data_end(root, right), push_space);
> +				      leaf_data_end(fs_info, right),
> +				      push_space);
> =20
>  		memmove_extent_buffer(right, btrfs_item_nr_offset(0),
>  			      btrfs_item_nr_offset(push_items),
> @@ -1978,7 +1979,8 @@ static noinline int copy_for_split(struct btrfs_t=
rans_handle *trans,
> =20
>  	nritems =3D nritems - mid;
>  	btrfs_set_header_nritems(right, nritems);
> -	data_copy_size =3D btrfs_item_end_nr(l, mid) - leaf_data_end(root, l)=
;
> +	data_copy_size =3D btrfs_item_end_nr(l, mid) -
> +		leaf_data_end(root->fs_info, l);
> =20
>  	copy_extent_buffer(right, l, btrfs_item_nr_offset(0),
>  			   btrfs_item_nr_offset(mid),
> @@ -1988,7 +1990,7 @@ static noinline int copy_for_split(struct btrfs_t=
rans_handle *trans,
>  		     btrfs_leaf_data(right) +
>  		     BTRFS_LEAF_DATA_SIZE(root->fs_info) -
>  		     data_copy_size, btrfs_leaf_data(l) +
> -		     leaf_data_end(root, l), data_copy_size);
> +		     leaf_data_end(root->fs_info, l), data_copy_size);
> =20
>  	rt_data_off =3D BTRFS_LEAF_DATA_SIZE(root->fs_info) -
>  		      btrfs_item_end_nr(l, mid);
> @@ -2326,7 +2328,7 @@ int btrfs_truncate_item(struct btrfs_root *root, =
struct btrfs_path *path,
>  		return 0;
> =20
>  	nritems =3D btrfs_header_nritems(leaf);
> -	data_end =3D leaf_data_end(root, leaf);
> +	data_end =3D leaf_data_end(root->fs_info, leaf);
> =20
>  	old_data_start =3D btrfs_item_offset_nr(leaf, slot);
> =20
> @@ -2415,7 +2417,7 @@ int btrfs_extend_item(struct btrfs_root *root, st=
ruct btrfs_path *path,
>  	leaf =3D path->nodes[0];
> =20
>  	nritems =3D btrfs_header_nritems(leaf);
> -	data_end =3D leaf_data_end(root, leaf);
> +	data_end =3D leaf_data_end(root->fs_info, leaf);
> =20
>  	if (btrfs_leaf_free_space(root, leaf) < data_size) {
>  		btrfs_print_leaf(root, leaf);
> @@ -2501,7 +2503,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_h=
andle *trans,
>  	leaf =3D path->nodes[0];
> =20
>  	nritems =3D btrfs_header_nritems(leaf);
> -	data_end =3D leaf_data_end(root, leaf);
> +	data_end =3D leaf_data_end(root->fs_info, leaf);
> =20
>  	if (btrfs_leaf_free_space(root, leaf) < total_size) {
>  		btrfs_print_leaf(root, leaf);
> @@ -2692,7 +2694,7 @@ int btrfs_del_items(struct btrfs_trans_handle *tr=
ans, struct btrfs_root *root,
>  	nritems =3D btrfs_header_nritems(leaf);
> =20
>  	if (slot + nr !=3D nritems) {
> -		int data_end =3D leaf_data_end(root, leaf);
> +		int data_end =3D leaf_data_end(root->fs_info, leaf);
> =20
>  		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
>  			      data_end + dsize,
>=20


--WqrWun5Xa05Fs0niFzCqsbjExIDvvYc0M--

--OokbgRvaDPDNFFBSdEpvUTH1wr8iFvLf9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpwIHwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjDdgf+PaVryRMB50j6jTUNObnxrSKv
dceV20aiIm/pOjGrLc/WGFXgQz6AfvWNg3toGqEthanZsHvvbLejAYMVLp/5VvYC
TEF7+MP6eolMjWLrfUQn4bSmOKF61JZJ47DwFxM81f++0xd8VuI0XLVgKzCVZGc8
FWFmoILbEByvdSIV/6e7NZVv3CZNMzzilFEuBmbOer4sezAwl1tAfs1ZYfoVYkWz
5+2HXU4eS3p985KV1MnHn+lwBCo6jJ7Iq26i//EQGkY5uqvxhcJgG/zc3M4cQXDs
lT6zYie5aHj6udP0cuXEG008WxJjFJu88dHlmZmmJ2useRsyqcbGf1JtkBQT5A==
=jOHD
-----END PGP SIGNATURE-----

--OokbgRvaDPDNFFBSdEpvUTH1wr8iFvLf9--
