Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57509 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752102AbeAZJVK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 04:21:10 -0500
Subject: Re: [PATCH 02/15] btrfs-progs: lowmem check: find and guess inode
 filetype
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-3-suy.fnst@cn.fujitsu.com>
 <cafbed34-4b59-7cc3-3cf9-f52d9e74ba4f@gmx.com>
Message-ID: <a0d6c1f3-cb88-a27d-18ce-de6f5bf66452@gmx.com>
Date: Fri, 26 Jan 2018 17:21:02 +0800
MIME-Version: 1.0
In-Reply-To: <cafbed34-4b59-7cc3-3cf9-f52d9e74ba4f@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3DsqUmnvq0I1Ex9hySKfbZv4okl1Ofi8M"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3DsqUmnvq0I1Ex9hySKfbZv4okl1Ofi8M
Content-Type: multipart/mixed; boundary="wOZEGT0zAteEaHmcT1qtQ2XbrPEsQA9UY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <a0d6c1f3-cb88-a27d-18ce-de6f5bf66452@gmx.com>
Subject: Re: [PATCH 02/15] btrfs-progs: lowmem check: find and guess inode
 filetype
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-3-suy.fnst@cn.fujitsu.com>
 <cafbed34-4b59-7cc3-3cf9-f52d9e74ba4f@gmx.com>
In-Reply-To: <cafbed34-4b59-7cc3-3cf9-f52d9e74ba4f@gmx.com>

--wOZEGT0zAteEaHmcT1qtQ2XbrPEsQA9UY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 17:14, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
>> Introduce find_file_type_lowmem() and guess_file_type_lowmem().
>>
>> find_file_type_lowmem() gets filetypes from inode_item, dir_item and
>> dir_index. If two of three's filetype are same and valid, it thinks
>> the value is correct.
>>
>> guess_file_type_lowmem() searches file_extent and dir_item/index then
>> returns with filetype.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>  cmds-check.c | 193 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
>>  1 file changed, 193 insertions(+)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index e3505a7f9d6b..b200fdccf0e5 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -3306,6 +3306,199 @@ static int find_file_type(struct inode_record =
*rec, u8 *type)
>>  	return -ENOENT;
>>  }
>> =20
>> +/*
>> + * Fetch filetype from exited completed dir_item, dir_index and inode=
_item.
>                           ^^^^^^
>                           existing?
>> + * If two of tree items'filetype are same, we think the type is trust=
ed.
>> + *
>> + * Return 0 if file type is found and BTRFS_FT_* is stored into type.=

>> + * Return <0 if file type is not found.
>=20
> This also includes extra error like -EIO from btrfs_search_slot().
>=20
>> + */
>> +static int find_file_type_lowmem(struct btrfs_root *root, u64 ino, u8=
 *type)
>> +{
>> +	struct btrfs_key key;
>> +	struct btrfs_path path;
>> +	struct btrfs_path path2;
>> +	struct btrfs_inode_ref *iref;
>> +	struct btrfs_dir_item *dir_item;
>> +	struct btrfs_dir_item *dir_index;
>> +	struct extent_buffer *eb;
>> +	u64 dir;
>> +	u64 index;
>> +	char namebuf[BTRFS_NAME_LEN] =3D {0};
>> +	u32 namelen;
>> +	u8 inode_filetype =3D BTRFS_FT_UNKNOWN;
>> +	u8 dir_item_filetype;
>> +	u8 dir_index_filetype;
>> +	u8 true_file_type;
>> +	int slot;
>> +	int ret;
>> +
>> +	key.objectid =3D ino;
>> +	key.type =3D BTRFS_INODE_ITEM_KEY;
>> +	key.offset =3D 0;
>> +
>> +	btrfs_init_path(&path);
>> +	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +	if (!ret) {
>> +		struct btrfs_inode_item *ii;
>> +
>> +		ii =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
>> +				    struct btrfs_inode_item);
>> +		inode_filetype =3D imode_to_type(btrfs_inode_mode(path.nodes[0],
>> +								ii));
>> +	}
>> +
>> +	key.objectid =3D ino;
>> +	key.type =3D BTRFS_INODE_REF_KEY;
>> +	key.offset =3D (u64)-1;
>> +
>> +	btrfs_release_path(&path);
>> +	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +	if (!ret) {
>> +		ret =3D -EIO;
>> +		goto out;
>> +	}
>> +
>> +	btrfs_init_path(&path2);
>> +next:
>> +	btrfs_release_path(&path2)> +	ret =3D btrfs_previous_item(root, &pat=
h, ino, BTRFS_INODE_REF_KEY);
>> +	if (ret) {
>> +		ret =3D -ENOENT;
>=20
> For ret < 0 case, return value is overwritten.
>=20
>=20
>> +		goto out;
>> +	}
>> +
>> +	eb =3D path.nodes[0];
>> +	slot =3D path.slots[0];
>> +	btrfs_item_key_to_cpu(eb, &key, slot);
>> +	dir =3D key.offset;
>> +	iref =3D btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
>> +	index =3D btrfs_inode_ref_index(eb, iref);
>> +	namelen =3D btrfs_inode_ref_name_len(eb, iref);
>> +	read_extent_buffer(eb, namebuf, (unsigned long)(iref + 1), namelen);=

>> +
>> +	dir_index =3D btrfs_lookup_dir_index(NULL, root, &path2, dir, namebu=
f,
>> +					   namelen, index, 0);
>> +	if (!dir_index)
>> +		goto next;
>> +	dir_index_filetype =3D btrfs_dir_type(path2.nodes[0], dir_index);
>> +	btrfs_release_path(&path2);
>> +	if (dir_index_filetype =3D=3D inode_filetype) {
>> +		true_file_type =3D inode_filetype;
>> +		goto found;
>> +	}
>> +
>> +	dir_item =3D btrfs_lookup_dir_item(NULL, root, &path2, dir, namebuf,=

>> +					 namelen, 0);
>> +	if (!dir_item)
>> +		goto next;
>> +	dir_item_filetype =3D btrfs_dir_type(path2.nodes[0], dir_item);
>> +	btrfs_release_path(&path2);
>> +	if (dir_item_filetype =3D=3D inode_filetype) {
>> +		true_file_type =3D inode_filetype;
>> +		goto found;
>> +	}
>> +
>> +	if (dir_index_filetype =3D=3D dir_item_filetype) {
>> +		true_file_type =3D dir_index_filetype;
>> +		goto found;
>> +	}
>> +	goto next;
>> +found:
>> +	/* rare case, two of three items are both corrupted */
>> +	if (true_file_type =3D=3D BTRFS_FT_UNKNOWN ||
>> +	    true_file_type >=3D BTRFS_FT_MAX)
>> +		goto next;
>> +	*type =3D true_file_type;
>> +	ret =3D 0;
>> +out:
>> +	btrfs_release_path(&path);
>> +	return ret;
>> +}
>> +
>> +static int find_normal_file_extent(struct btrfs_root *root, u64 ino);=

>> +/*
>> + * Try to determine inode type if type not found.
>> + *
>> + * For found regular file extent, it must be FILE.
>> + * For found dir_item/index, it must be DIR.
>> + *
>> + * Return 0 if file type is confirmed and BTRFS_FT_* is stored into t=
ype.
>> + * Return <0 if file type is unknown.
>> + */
>> +static int guess_file_type_lowmem(struct btrfs_root *root, u64 ino, u=
8 *type)
>> +{
>> +	struct btrfs_key key;
>> +	struct btrfs_path *path =3D NULL;
>> +	bool is_dir =3D false;
>> +	bool is_file =3D false;
>> +	int ret;
>> +
>> +	if (find_normal_file_extent(root, ino)) {
>=20
> Nice reusing the existing code.
>=20
>> +		is_file =3D true;
>> +		goto out;
>> +	}
>> +
>> +	key.objectid =3D ino;
>> +	key.type =3D BTRFS_DIR_ITEM_KEY;
>=20
> You could merge the code together, using just one loop instead of using=

> two search separately for DIR_ITEM and DIR_INDEX.
>=20
> Search for key (ino, DIR_INDEX, -1), as DIR_INDEX is larger than DIR_IT=
EM.
>=20
> And search backward, not using btrfs_previous_item() but manually
> checking the type (and do prev_leaf() manually).
> It should save you several lines.

In fact you could use btrfs_previous_item() twice, to locate any
DIR_INDEX/DIR_ITEM.

btrfs_previous_item(DIR_INDEX) to locate any DIR_INDEX, and then
btrfs_previous_item(DIR_ITEM) again if DIR_INDEX not found.

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20
>> +	key.offset =3D (u64)-1;
>> +
>> +	path =3D btrfs_alloc_path();
>> +	if (!path)
>> +		goto out;
>> +	ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +	/*
>> +	 * (u64)-1 may hit the hashed value in offset.
>> +	 */
>> +	if (!ret) {
>> +		is_dir =3D true;
>> +		goto out;
>> +	}
>> +
>> +	ret =3D btrfs_previous_item(root, path, ino, BTRFS_DIR_ITEM_KEY);> +=
	if (!ret) {
>> +		is_dir =3D true;
>> +		goto out;
>> +	}
>> +
>> +	key.type =3D BTRFS_DIR_INDEX_KEY;
>> +	key.offset =3D (u64)-1;
>> +
>> +	btrfs_release_path(path);
>> +	ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +	if (!ret) {
>> +		is_dir =3D true;
>> +		goto out;
>> +	}
>> +	ret =3D btrfs_previous_item(root, path, ino, BTRFS_DIR_INDEX_KEY);
>> +	if (!ret) {
>> +		is_dir =3D true;
>> +		goto out;
>> +	}
>> +out:
>> +	if (path)
>> +		btrfs_release_path(path);
>> +
>> +	if (is_dir) {
>> +		*type =3D BTRFS_FT_DIR;
>> +		ret =3D 0;
>> +	} else if (is_file) {
>> +		*type =3D BTRFS_FT_REG_FILE;
>> +		ret =3D 0;
>> +	} else {
>> +		ret =3D -ENOENT;
>> +	}
>> +	return ret;
>> +}
>> +
>>  /*
>>   * To determine the file name for nlink repair
>>   *
>>
>=20


--wOZEGT0zAteEaHmcT1qtQ2XbrPEsQA9UY--

--3DsqUmnvq0I1Ex9hySKfbZv4okl1Ofi8M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq8v4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiuswf5AaDZ48gVp3BTwwzZRAYfBD5Z
qGKRBxoNDeOON0tt/Chwgm5pmSYXJLUCHuRFmE8finKMW80xMxJmcYsQT//ZJCuX
Q2F2dWOYjRHYj4AlCIH9CoUIDrC4J+u2c673ASe3tc/Ljmiug99DhCaRZRnDzWuV
bn0NHBG894DFSsgplSaHqqFnyhc0/PQZ0ZGhh+2VTKT3WsgniFP/rC6kFKCFePAd
ugl1Gyg27tKwe8zxtqWMUkBSziu8Vozitm6lbYxwgZjjAE/a0aYCFy/ozaTLe6wC
VvuRQUL2CqzGnlgDtIoZxMkk8KxurOvDrdVV2A8zUFAKfbEVVkqh8BtUEzTpXA==
=FUCr
-----END PGP SIGNATURE-----

--3DsqUmnvq0I1Ex9hySKfbZv4okl1Ofi8M--
