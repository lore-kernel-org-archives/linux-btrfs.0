Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49960 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752828AbeAZJeB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 04:34:01 -0500
Subject: Re: [PATCH 04/15] btrfs-progs: lowmem check: repair complex cases in
 repair_dir_item()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-5-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <aae3aa94-d331-aada-9956-57f88ca8649e@gmx.com>
Date: Fri, 26 Jan 2018 17:33:53 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-5-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zZ8Owv1xNXSoZdwUSwP05BDKgvxxwl4j9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zZ8Owv1xNXSoZdwUSwP05BDKgvxxwl4j9
Content-Type: multipart/mixed; boundary="zgeQdksTo1u6SxXaz8jpfMoeTADLA82vT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <aae3aa94-d331-aada-9956-57f88ca8649e@gmx.com>
Subject: Re: [PATCH 04/15] btrfs-progs: lowmem check: repair complex cases in
 repair_dir_item()
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-5-suy.fnst@cn.fujitsu.com>

--zgeQdksTo1u6SxXaz8jpfMoeTADLA82vT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> If inode item is missing or filetype is corrupted maybe, and filetypes
> of dir_item and dir_index are corrupted too, lowmem repair may insert
> wrong inode item and dir_item/index.
>=20
> First, find and guess filetype of inode item, if failed, use
> BTRFS_REG_FILE as fallback for insertion.
> If filetype is not available, just delete current dir_item/index.
>=20
> And repair_dir_item also calls repair_inode_item_mismatch() now.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>  cmds-check.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++---=
--------
>  1 file changed, 78 insertions(+), 17 deletions(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index 08a2662e603c..e33dd7db0048 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -2811,7 +2811,7 @@ static int walk_down_tree_v2(struct btrfs_trans_h=
andle *trans,
> =20
>  		ret =3D check_child_node(cur, path->slots[*level], next);
>  		err |=3D ret;
> -		if (ret < 0)=20
> +		if (ret < 0)
>  			break;
> =20
>  		if (btrfs_is_leaf(next))
> @@ -5697,29 +5697,91 @@ static void print_dir_item_err(struct btrfs_roo=
t *root, struct btrfs_key *key,
>  /*
>   * Call repair_inode_item_missing and repair_ternary_lowmem to repair
>   *
> + * @filetype:	filetype of the dir_item/index
> + *
>   * Returns error after repair
>   */
> -static int repair_dir_item(struct btrfs_root *root, u64 dirid, u64 ino=
,
> -			   u64 index, u8 filetype, char *namebuf, u32 name_len,
> -			   int err)
> +static int repair_dir_item(struct btrfs_root *root, struct btrfs_key *=
key,
> +			   u64 ino, u64 index, u8 filetype, char *namebuf,
> +			   u32 name_len, int err)
>  {
>  	int ret;
> +	u64 dirid =3D key->objectid;
> +	u8 true_filetype;
> =20
> -	if (err & INODE_ITEM_MISSING) {
> -		ret =3D repair_inode_item_missing(root, ino, filetype);
> -		if (!ret)
> -			err &=3D ~(INODE_ITEM_MISMATCH | INODE_ITEM_MISSING);
> +	if (err & (INODE_ITEM_MISMATCH | INODE_ITEM_MISSING)) {
> +		ret =3D find_file_type_lowmem(root, ino, &true_filetype);
> +		if (ret) {
> +			ret =3D guess_file_type_lowmem(root, ino,
> +						     &true_filetype);
> +			if (ret) {
> +				true_filetype =3D BTRFS_FT_REG_FILE;
> +				error(
> +		"can't get file type for inode %llu, using FILE as fallback",
> +				      ino);
> +			}
> +		}
>  	}
> =20
> -	if (err & ~(INODE_ITEM_MISMATCH | INODE_ITEM_MISSING)) {
> -		ret =3D repair_ternary_lowmem(root, dirid, ino, index, namebuf,
> -					    name_len, filetype, err);
> +	/*
> +	 * Case: the dir_item has corresponding inode_ref but
> +	 * mismatch/missed inode_item and mismatch/missed another
> +	 * dir_item/index.
> +	 * repair_ternary_lowmem prefer to change another dir_item/index with=

> +	 * wrong filetype. So delete the item here.
> +	 */
> +	if (filetype !=3D true_filetype &&
> +	    (err & (DIR_ITEM_MISMATCH | DIR_ITEM_MISSING) ||
> +	     err & (DIR_INDEX_MISMATCH | DIR_INDEX_MISSING))) {
> +		struct btrfs_trans_handle *trans;
> +		struct btrfs_path *path;
> +
> +		path =3D btrfs_alloc_path();
> +		if (!path)
> +			goto out;
> +		trans =3D btrfs_start_transaction(root, 0);
> +		ret =3D btrfs_search_slot(trans, root, key, path, -1, 1);
> +		if (ret) {
> +			btrfs_commit_transaction(trans, root);
> +			btrfs_release_path(path);
> +			goto out;
> +		}
> +		ret =3D btrfs_del_item(trans, root, path);
>  		if (!ret) {
> -			err &=3D ~(DIR_INDEX_MISMATCH | DIR_INDEX_MISSING);
> -			err &=3D ~(DIR_ITEM_MISMATCH | DIR_ITEM_MISSING);
> -			err &=3D ~(INODE_REF_MISSING);
> +			err =3D 0;
> +			printf(
> +		"Deleted dir_item[%llu %u %llu]root %llu name %s filetype %u\n",
> +			       key->objectid, key->type, key->offset,
> +			       root->objectid, namebuf, filetype);
>  		}
> +		btrfs_commit_transaction(trans, root);
> +		btrfs_release_path(path);
> +		/*
> +		 * Leave remains to check_inode_item() and check_inode_ref().
> +		 */
> +		goto out;
> +	}
> +
> +	ret =3D repair_ternary_lowmem(root, dirid, ino, index, namebuf,
> +				    name_len, true_filetype, err);
> +	if (!ret) {
> +		err &=3D ~(DIR_INDEX_MISMATCH | DIR_INDEX_MISSING);
> +		err &=3D ~(DIR_ITEM_MISMATCH | DIR_ITEM_MISSING);
> +		err &=3D ~(INODE_REF_MISSING);
> +	}
> +
> +	if (err & INODE_ITEM_MISSING) {
> +		ret =3D repair_inode_item_missing(root, ino, true_filetype);
> +		if (!ret || ret =3D=3D -EEXIST)
> +			err &=3D ~INODE_ITEM_MISSING;
>  	}
> +
> +	if (err & INODE_ITEM_MISMATCH) {
> +		ret =3D repair_inode_item_mismatch(root, ino, true_filetype);
> +		if (!ret)
> +			err &=3D ~INODE_ITEM_MISMATCH;
> +	}
> +out:
>  	return err;
>  }
> =20
> @@ -5958,9 +6020,8 @@ begin:
>  next:
> =20
>  		if (tmp_err && repair) {
> -			ret =3D repair_dir_item(root, di_key->objectid,
> -					      location.objectid, index,
> -					      imode_to_type(mode), namebuf,
> +			ret =3D repair_dir_item(root, di_key, location.objectid,
> +					      index, filetype, namebuf,
>  					      name_len, tmp_err);
>  			if (ret !=3D tmp_err) {
>  				need_research =3D 1;
>=20


--zgeQdksTo1u6SxXaz8jpfMoeTADLA82vT--

--zZ8Owv1xNXSoZdwUSwP05BDKgvxxwl4j9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq9gEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg5vAf/aPnc4pG4zXJgZWdG8y12ygnl
IdM3k7jpLp5DIAw8svsbuyPzgP9Mc4S74r6ry5aQd3+xxDAbsLGYQEbDwjpF75sM
VzK8A/g3ByemQiYgPd87qU5s9h155UjOE8iiGk5SMipaZXWtZg6I1XOHJOldtbv1
vhf+qsP/jpqiUOgfi3cxIABwQKxCuZI6gdCryThvYT9AwwvZ3OF0N5m3K/TNxP30
ouADTOjeSZd/+0xluQg5ns2CS5NNhdwo7wtsSUZeRylS/IEzKZrqM6qZSdcGLwna
ISTKEA/ME1ZPzp0tITl6cYc5OAFQIFW5GSp4e1Hx/kTKfsSU8emM8SFnzUDNbw==
=0f7Z
-----END PGP SIGNATURE-----

--zZ8Owv1xNXSoZdwUSwP05BDKgvxxwl4j9--
