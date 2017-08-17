Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43158 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751149AbdHQOYk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 10:24:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 01DAFAC78
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 14:24:39 +0000 (UTC)
Subject: Re: [PATCH] btrfs: pass fs_info to routines that always take
 tree_root
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
References: <20170802195453.32471-1-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <2ae81133-9c6e-27c5-50d1-2393f2d77c88@suse.com>
Date: Thu, 17 Aug 2017 10:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <20170802195453.32471-1-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="exDL6cupNmMHsBVogtUGD5O6foo1qE60M"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--exDL6cupNmMHsBVogtUGD5O6foo1qE60M
Content-Type: multipart/mixed; boundary="39coRhGFAAOlmGrf6wHcqX9CwVVAGq8Vl";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Message-ID: <2ae81133-9c6e-27c5-50d1-2393f2d77c88@suse.com>
Subject: Re: [PATCH] btrfs: pass fs_info to routines that always take
 tree_root
References: <20170802195453.32471-1-jeffm@suse.com>
In-Reply-To: <20170802195453.32471-1-jeffm@suse.com>

--39coRhGFAAOlmGrf6wHcqX9CwVVAGq8Vl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/2/17 3:54 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> btrfs_find_root and btrfs_del_root always use the tree_root.  Let's pas=
s
> fs_info instead.

This one is broken.  btrfs_read_fs_root is called during log tree
recovery with the log_root_tree.  I'll send an updated patch.

-Jeff

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/ctree.h           |  7 ++++---
>  fs/btrfs/disk-io.c         |  2 +-
>  fs/btrfs/extent-tree.c     |  4 ++--
>  fs/btrfs/free-space-tree.c |  2 +-
>  fs/btrfs/qgroup.c          |  3 +--
>  fs/btrfs/root-tree.c       | 15 +++++++++------
>  6 files changed, 18 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 3f3eb7b17cac..eed7cc991a80 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2973,8 +2973,8 @@ int btrfs_del_root_ref(struct btrfs_trans_handle =
*trans,
>  		       struct btrfs_fs_info *fs_info,
>  		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
>  		       const char *name, int name_len);
> -int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root=
 *root,
> -		   const struct btrfs_key *key);
> +int btrfs_del_root(struct btrfs_trans_handle *trans,
> +		   struct btrfs_fs_info *fs_info, const struct btrfs_key *key);
>  int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_r=
oot *root,
>  		      const struct btrfs_key *key,
>  		      struct btrfs_root_item *item);
> @@ -2982,7 +2982,8 @@ int __must_check btrfs_update_root(struct btrfs_t=
rans_handle *trans,
>  				   struct btrfs_root *root,
>  				   struct btrfs_key *key,
>  				   struct btrfs_root_item *item);
> -int btrfs_find_root(struct btrfs_root *root, const struct btrfs_key *s=
earch_key,
> +int btrfs_find_root(struct btrfs_fs_info *fs_info,
> +		    const struct btrfs_key *search_key,
>  		    struct btrfs_path *path, struct btrfs_root_item *root_item,
>  		    struct btrfs_key *root_key);
>  int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info);
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 080e2ebb8aa0..ea1959937875 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1581,7 +1581,7 @@ static struct btrfs_root *btrfs_read_tree_root(st=
ruct btrfs_root *tree_root,
> =20
>  	__setup_root(root, fs_info, key->objectid);
> =20
> -	ret =3D btrfs_find_root(tree_root, key, path,
> +	ret =3D btrfs_find_root(fs_info, key, path,
>  			      &root->root_item, &root->root_key);
>  	if (ret) {
>  		if (ret > 0)
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 82d53a7b6652..12fa33accdcc 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9192,14 +9192,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root=
,
>  	if (err)
>  		goto out_end_trans;
> =20
> -	ret =3D btrfs_del_root(trans, tree_root, &root->root_key);
> +	ret =3D btrfs_del_root(trans, fs_info, &root->root_key);
>  	if (ret) {
>  		btrfs_abort_transaction(trans, ret);
>  		goto out_end_trans;
>  	}
> =20
>  	if (root->root_key.objectid !=3D BTRFS_TREE_RELOC_OBJECTID) {
> -		ret =3D btrfs_find_root(tree_root, &root->root_key, path,
> +		ret =3D btrfs_find_root(fs_info, &root->root_key, path,
>  				      NULL, NULL);
>  		if (ret < 0) {
>  			btrfs_abort_transaction(trans, ret);
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index a5e34de06c2f..684f12247db7 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1257,7 +1257,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_i=
nfo *fs_info)
>  	if (ret)
>  		goto abort;
> =20
> -	ret =3D btrfs_del_root(trans, tree_root, &free_space_root->root_key);=

> +	ret =3D btrfs_del_root(trans, fs_info, &free_space_root->root_key);
>  	if (ret)
>  		goto abort;
> =20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 4ce351efe281..ba60523a443c 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -946,7 +946,6 @@ int btrfs_quota_enable(struct btrfs_trans_handle *t=
rans,
>  int btrfs_quota_disable(struct btrfs_trans_handle *trans,
>  			struct btrfs_fs_info *fs_info)
>  {
> -	struct btrfs_root *tree_root =3D fs_info->tree_root;
>  	struct btrfs_root *quota_root;
>  	int ret =3D 0;
> =20
> @@ -968,7 +967,7 @@ int btrfs_quota_disable(struct btrfs_trans_handle *=
trans,
>  	if (ret)
>  		goto out;
> =20
> -	ret =3D btrfs_del_root(trans, tree_root, &quota_root->root_key);
> +	ret =3D btrfs_del_root(trans, fs_info, &quota_root->root_key);
>  	if (ret)
>  		goto out;
> =20
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 460db0cb2d07..31c0e7265f44 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -62,7 +62,7 @@ static void btrfs_read_root_item(struct extent_buffer=
 *eb, int slot,
> =20
>  /*
>   * btrfs_find_root - lookup the root by the key.
> - * root: the root of the root tree
> + * fs_info: the fs_info for the file system to search
>   * search_key: the key to search
>   * path: the path we search
>   * root_item: the root item of the tree we look for
> @@ -74,7 +74,8 @@ static void btrfs_read_root_item(struct extent_buffer=
 *eb, int slot,
>   *
>   * If we find something return 0, otherwise > 0, < 0 on error.
>   */
> -int btrfs_find_root(struct btrfs_root *root, const struct btrfs_key *s=
earch_key,
> +int btrfs_find_root(struct btrfs_fs_info *fs_info,
> +		    const struct btrfs_key *search_key,
>  		    struct btrfs_path *path, struct btrfs_root_item *root_item,
>  		    struct btrfs_key *root_key)
>  {
> @@ -83,7 +84,8 @@ int btrfs_find_root(struct btrfs_root *root, const st=
ruct btrfs_key *search_key,
>  	int ret;
>  	int slot;
> =20
> -	ret =3D btrfs_search_slot(NULL, root, search_key, path, 0, 0);
> +	ret =3D btrfs_search_slot(NULL, fs_info->tree_root, search_key,
> +				path, 0, 0);
>  	if (ret < 0)
>  		return ret;
> =20
> @@ -335,10 +337,11 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info =
*fs_info)
>  	return err;
>  }
> =20
> -/* drop the root item for 'key' from 'root' */
> -int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root=
 *root,
> -		   const struct btrfs_key *key)
> +/* drop the root item for 'key' from the tree root */
> +int btrfs_del_root(struct btrfs_trans_handle *trans,
> +		   struct btrfs_fs_info *fs_info, const struct btrfs_key *key)
>  {
> +	struct btrfs_root *root =3D fs_info->tree_root;
>  	struct btrfs_path *path;
>  	int ret;
> =20
>=20


--=20
Jeff Mahoney
SUSE Labs


--39coRhGFAAOlmGrf6wHcqX9CwVVAGq8Vl--

--exDL6cupNmMHsBVogtUGD5O6foo1qE60M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWZWnJB57S2MheeWyAQirVw/+JM6GWQiEt+yj5pS26A1BOBL7466SaRXN
Vc9OtsWFa59O8qazczcgqJzvvAvHS0J3OMyij/7Bh/OyrMi02nvrdxhkJve3ebv6
lafEIeJP4t8VQLCp/sGzf0371CDQR4Ub+3v1oVHuPeL6AaJRWnaK0prhBYZdAC+1
fn0WbXW3dLVQMMLsBcqMusWUzDpXQ+WrYY3c07QIL8s5Kx/gudnoVlBLRcvUWUAR
vrtMhNmnjZlJQjZ3QNq0RV3dhSsswxk+6Gw1+3wfz+9qAnFN6gGqex2bLZES7eZF
orX1nJl0RYWfMOFseaezLUR6l4AXR0FM/ywyoFDEr+lAl52HxqdUn3UmvQV3zhZJ
IjWU+DtBcYlBtFPNaZI2vn9al9fc0ezDryMTKnELFVDLRxxc+SmP5C9HLMBp3naR
HoeS4Xl61zYvCZnwDRNXk6GOuTvh3Bd7fbBpelFouVs7Sa4sbC7TM5cousAfQ66s
Kvf6fw1iIN4QDOyjVRK1opZF+lPl6ZlissjwKOtSZTio6rFbt8Ep/rGzBzfyRQ0z
IGgNMeMOE6147du1oQ6PeDfNjT5OdHlrmSrt6s68c22t81HTKwB70S7tOvzpBlcS
T2spkOfPqe3CcPx1c3K3usqa924es42+PKd8W08C9NuG47KBBqhA5dvCVsbopVxz
hoedwakPiJ0=
=Zkxi
-----END PGP SIGNATURE-----

--exDL6cupNmMHsBVogtUGD5O6foo1qE60M--
