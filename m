Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59073 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752402AbeAZJOf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 04:14:35 -0500
Subject: Re: [PATCH 02/15] btrfs-progs: lowmem check: find and guess inode
 filetype
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-3-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cafbed34-4b59-7cc3-3cf9-f52d9e74ba4f@gmx.com>
Date: Fri, 26 Jan 2018 17:14:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-3-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FeyARhADAfVhK22SL5Za55B2yLqlWzn5A"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FeyARhADAfVhK22SL5Za55B2yLqlWzn5A
Content-Type: multipart/mixed; boundary="Ta1r4DFfFOHeEboUWnf9AnuNNqXDhVqbU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <cafbed34-4b59-7cc3-3cf9-f52d9e74ba4f@gmx.com>
Subject: Re: [PATCH 02/15] btrfs-progs: lowmem check: find and guess inode
 filetype
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-3-suy.fnst@cn.fujitsu.com>

--Ta1r4DFfFOHeEboUWnf9AnuNNqXDhVqbU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> Introduce find_file_type_lowmem() and guess_file_type_lowmem().
>=20
> find_file_type_lowmem() gets filetypes from inode_item, dir_item and
> dir_index. If two of three's filetype are same and valid, it thinks
> the value is correct.
>=20
> guess_file_type_lowmem() searches file_extent and dir_item/index then
> returns with filetype.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 193 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 193 insertions(+)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index e3505a7f9d6b..b200fdccf0e5 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -3306,6 +3306,199 @@ static int find_file_type(struct inode_record *=
rec, u8 *type)
>  	return -ENOENT;
>  }
> =20
> +/*
> + * Fetch filetype from exited completed dir_item, dir_index and inode_=
item.
                          ^^^^^^
                          existing?
> + * If two of tree items'filetype are same, we think the type is truste=
d.
> + *
> + * Return 0 if file type is found and BTRFS_FT_* is stored into type.
> + * Return <0 if file type is not found.

This also includes extra error like -EIO from btrfs_search_slot().

> + */
> +static int find_file_type_lowmem(struct btrfs_root *root, u64 ino, u8 =
*type)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	struct btrfs_path path2;
> +	struct btrfs_inode_ref *iref;
> +	struct btrfs_dir_item *dir_item;
> +	struct btrfs_dir_item *dir_index;
> +	struct extent_buffer *eb;
> +	u64 dir;
> +	u64 index;
> +	char namebuf[BTRFS_NAME_LEN] =3D {0};
> +	u32 namelen;
> +	u8 inode_filetype =3D BTRFS_FT_UNKNOWN;
> +	u8 dir_item_filetype;
> +	u8 dir_index_filetype;
> +	u8 true_file_type;
> +	int slot;
> +	int ret;
> +
> +	key.objectid =3D ino;
> +	key.type =3D BTRFS_INODE_ITEM_KEY;
> +	key.offset =3D 0;
> +
> +	btrfs_init_path(&path);
> +	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +	if (!ret) {
> +		struct btrfs_inode_item *ii;
> +
> +		ii =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
> +				    struct btrfs_inode_item);
> +		inode_filetype =3D imode_to_type(btrfs_inode_mode(path.nodes[0],
> +								ii));
> +	}
> +
> +	key.objectid =3D ino;
> +	key.type =3D BTRFS_INODE_REF_KEY;
> +	key.offset =3D (u64)-1;
> +
> +	btrfs_release_path(&path);
> +	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +	if (!ret) {
> +		ret =3D -EIO;
> +		goto out;
> +	}
> +
> +	btrfs_init_path(&path2);
> +next:
> +	btrfs_release_path(&path2)> +	ret =3D btrfs_previous_item(root, &path=
, ino, BTRFS_INODE_REF_KEY);
> +	if (ret) {
> +		ret =3D -ENOENT;

For ret < 0 case, return value is overwritten.


> +		goto out;
> +	}
> +
> +	eb =3D path.nodes[0];
> +	slot =3D path.slots[0];
> +	btrfs_item_key_to_cpu(eb, &key, slot);
> +	dir =3D key.offset;
> +	iref =3D btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
> +	index =3D btrfs_inode_ref_index(eb, iref);
> +	namelen =3D btrfs_inode_ref_name_len(eb, iref);
> +	read_extent_buffer(eb, namebuf, (unsigned long)(iref + 1), namelen);
> +
> +	dir_index =3D btrfs_lookup_dir_index(NULL, root, &path2, dir, namebuf=
,
> +					   namelen, index, 0);
> +	if (!dir_index)
> +		goto next;
> +	dir_index_filetype =3D btrfs_dir_type(path2.nodes[0], dir_index);
> +	btrfs_release_path(&path2);
> +	if (dir_index_filetype =3D=3D inode_filetype) {
> +		true_file_type =3D inode_filetype;
> +		goto found;
> +	}
> +
> +	dir_item =3D btrfs_lookup_dir_item(NULL, root, &path2, dir, namebuf,
> +					 namelen, 0);
> +	if (!dir_item)
> +		goto next;
> +	dir_item_filetype =3D btrfs_dir_type(path2.nodes[0], dir_item);
> +	btrfs_release_path(&path2);
> +	if (dir_item_filetype =3D=3D inode_filetype) {
> +		true_file_type =3D inode_filetype;
> +		goto found;
> +	}
> +
> +	if (dir_index_filetype =3D=3D dir_item_filetype) {
> +		true_file_type =3D dir_index_filetype;
> +		goto found;
> +	}
> +	goto next;
> +found:
> +	/* rare case, two of three items are both corrupted */
> +	if (true_file_type =3D=3D BTRFS_FT_UNKNOWN ||
> +	    true_file_type >=3D BTRFS_FT_MAX)
> +		goto next;
> +	*type =3D true_file_type;
> +	ret =3D 0;
> +out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
> +static int find_normal_file_extent(struct btrfs_root *root, u64 ino);
> +/*
> + * Try to determine inode type if type not found.
> + *
> + * For found regular file extent, it must be FILE.
> + * For found dir_item/index, it must be DIR.
> + *
> + * Return 0 if file type is confirmed and BTRFS_FT_* is stored into ty=
pe.
> + * Return <0 if file type is unknown.
> + */
> +static int guess_file_type_lowmem(struct btrfs_root *root, u64 ino, u8=
 *type)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_path *path =3D NULL;
> +	bool is_dir =3D false;
> +	bool is_file =3D false;
> +	int ret;
> +
> +	if (find_normal_file_extent(root, ino)) {

Nice reusing the existing code.

> +		is_file =3D true;
> +		goto out;
> +	}
> +
> +	key.objectid =3D ino;
> +	key.type =3D BTRFS_DIR_ITEM_KEY;

You could merge the code together, using just one loop instead of using
two search separately for DIR_ITEM and DIR_INDEX.

Search for key (ino, DIR_INDEX, -1), as DIR_INDEX is larger than DIR_ITEM=
=2E

And search backward, not using btrfs_previous_item() but manually
checking the type (and do prev_leaf() manually).
It should save you several lines.

Thanks,
Qu

> +	key.offset =3D (u64)-1;
> +
> +	path =3D btrfs_alloc_path();
> +	if (!path)
> +		goto out;
> +	ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +	/*
> +	 * (u64)-1 may hit the hashed value in offset.
> +	 */
> +	if (!ret) {
> +		is_dir =3D true;
> +		goto out;
> +	}
> +
> +	ret =3D btrfs_previous_item(root, path, ino, BTRFS_DIR_ITEM_KEY);> +	=
if (!ret) {
> +		is_dir =3D true;
> +		goto out;
> +	}
> +
> +	key.type =3D BTRFS_DIR_INDEX_KEY;
> +	key.offset =3D (u64)-1;
> +
> +	btrfs_release_path(path);
> +	ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +	if (!ret) {
> +		is_dir =3D true;
> +		goto out;
> +	}
> +	ret =3D btrfs_previous_item(root, path, ino, BTRFS_DIR_INDEX_KEY);
> +	if (!ret) {
> +		is_dir =3D true;
> +		goto out;
> +	}
> +out:
> +	if (path)
> +		btrfs_release_path(path);
> +
> +	if (is_dir) {
> +		*type =3D BTRFS_FT_DIR;
> +		ret =3D 0;
> +	} else if (is_file) {
> +		*type =3D BTRFS_FT_REG_FILE;
> +		ret =3D 0;
> +	} else {
> +		ret =3D -ENOENT;
> +	}
> +	return ret;
> +}
> +
>  /*
>   * To determine the file name for nlink repair
>   *
>=20


--Ta1r4DFfFOHeEboUWnf9AnuNNqXDhVqbU--

--FeyARhADAfVhK22SL5Za55B2yLqlWzn5A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq8XMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgwBggAlE9LdQtgS0nTHVlBx4tDmcZU
c5z8P/fOhVjSISP0VhCIIdVo4c0n1gBDFAWp4et0cxiSYo3nMBBOvPtcJxcmDeCM
sDvbzcZabcl81hEEf0nYF/rUSyZA2ebDn5evuDbl8qbxRmXrCG5D+Fgf2shO71ys
bvqBdBxRpfGK8hmmtmU0uMhyN1/1V+eunxsRSrv7hFe3SQt5eSQVTBWvC2/sWoCu
Kb/8JYGdO2uO87IsfZuSfHgrjFEQatCjvwkZQ8kDjOz/JVkpBoK5b9/Rg3b6dpil
bYiB5idwMfxji7Ywtrzy2XCSeUrWxkWU9zaF9H++IAHlqrii0PD1yEiyhn57KQ==
=P5Sj
-----END PGP SIGNATURE-----

--FeyARhADAfVhK22SL5Za55B2yLqlWzn5A--
