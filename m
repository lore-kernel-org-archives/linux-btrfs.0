Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55679 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932680AbeCNBc7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 21:32:59 -0400
Subject: Re: [PATCH 1/2] Btrfs-progs: check, fix false error reports for
 shared prealloc extents
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20180313184700.30173-1-fdmanana@kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4287f45b-cfac-7188-51b2-1647b230f584@gmx.com>
Date: Wed, 14 Mar 2018 09:32:50 +0800
MIME-Version: 1.0
In-Reply-To: <20180313184700.30173-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="W1Qzl2WWURQWQW0VKFdzjFf2ljIT0ODKj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W1Qzl2WWURQWQW0VKFdzjFf2ljIT0ODKj
Content-Type: multipart/mixed; boundary="HukoTjXDzb2zue2AhoF8chebvH9ytR3ia";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <4287f45b-cfac-7188-51b2-1647b230f584@gmx.com>
Subject: Re: [PATCH 1/2] Btrfs-progs: check, fix false error reports for
 shared prealloc extents
References: <20180313184700.30173-1-fdmanana@kernel.org>
In-Reply-To: <20180313184700.30173-1-fdmanana@kernel.org>

--HukoTjXDzb2zue2AhoF8chebvH9ytR3ia
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8814=E6=97=A5 02:47, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Under some cases the filesystem checker reports an error when it finds
> checksum items for an extent that is referenced by an inode as a preall=
oc
> extent. Such cases are not an error when the extent is actually shared
> (was cloned/reflinked) with other inodes and was written through one of=

> those other inodes.
>=20
> Example:
>=20
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
>=20
>   $ touch /mnt/foo
>   $ xfs_io -c "falloc 0 256K" /mnt/foo
>   $ sync
>=20
>   $ xfs_io -c "pwrite -S 0xab -b 0 256K" /mnt/foo
>   $ touch /mnt/bar
>   $ xfs_io -c "reflink /mnt/foo 0 0 256K" /mnt/bar
>   $ xfs_io -c "fsync" /mnt/bar
>=20
>   <power fail>
>   $ mount /dev/sdb /mnt
>   $ umount /mnt
>=20
>   $ btrfs check /dev/sdc
>   Checking filesystem on /dev/sdb
>   UUID: 52d3006e-ee3b-40eb-aa21-e56253a03d39
>   checking extents
>   checking free space cache
>   checking fs roots
>   root 5 inode 257 errors 800, odd csum item
>   ERROR: errors found in fs roots
>   found 688128 bytes used, error(s) found
>   total csum bytes: 256
>   total tree bytes: 163840
>   total fs tree bytes: 65536
>   total extent tree bytes: 16384
>   btree space waste bytes: 138819
>   file data blocks allocated: 10747904
>    referenced 10747904
>   $ echo $?
>   1
>=20
> So tech check to not report such cases as errors by checking if the
> extent is shared with other inodes and if so, consider it an error the
> existence of checksum items only if all those other inodes are referenc=
ing
> the extent as a prealloc extent.
> This case can be hit often when running the generic/475 testcase from
> fstests.
>=20
> A test case will follow in a separate patch.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good overall, but still some small nitpicks.

One is, the fix is only for original mode, while the fix itself has
nothing mode dependent, so it's better to put the check into
check/mode-original.[ch] so lowmem mode can also benefit from it.

> ---
>  check/main.c | 270 +++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++-
>  1 file changed, 268 insertions(+), 2 deletions(-)
>=20
> diff --git a/check/main.c b/check/main.c
> index 392195ca..bb816311 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1424,6 +1424,264 @@ static int process_inode_extref(struct extent_b=
uffer *eb,
> =20
>  }
> =20
> +/*
> + * Check if the inode referenced by the given data reference uses the =
extent
> + * at disk_bytenr as a non-prealloc extent.
> + *
> + * Returns 1 if true, 0 if false and < 0 on error.
> + */

The check itself (along with check_prealloc_shared_data_ref) is good
enough to detect any regular file extents inside the prealloc extent.

But when it finds any regular extents, it doesn't check if it's covered
by csum correctly.

For example:

|<-------------- prealloc extent range -------------------------->|
|<- the *only* regular extent ->|
|<-------- range covered by csum -------->|
                                |<- ODD ->|

Or
|<-------------- prealloc extent range -------------------------->|
|<- the *only* regular extent ->|
|<- csum ->|
           |<------ ODD ------->|

So at least in theory, the best solution is not to just check if there
is any regular extents inside the large prealloc extent, but also check
how many csum bytes the regular extents contribute, and then compare it
to the result of count_csum_range().

Thanks,
Qu

> +static int check_prealloc_data_ref(struct btrfs_fs_info *fs_info,
> +				   u64 ino,
> +				   u64 disk_bytenr,
> +				   struct btrfs_extent_data_ref *dref,
> +				   struct extent_buffer *eb)
> +{
> +	u64 rootid =3D btrfs_extent_data_ref_root(eb, dref);
> +	u64 objectid =3D btrfs_extent_data_ref_objectid(eb, dref);
> +	u64 offset =3D btrfs_extent_data_ref_offset(eb, dref);
> +	struct btrfs_root *root;
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	int ret;
> +
> +	if (objectid =3D=3D ino)
> +		return 0;
> +
> +	btrfs_init_path(&path);
> +	key.objectid =3D rootid;
> +	key.type =3D BTRFS_ROOT_ITEM_KEY;
> +	key.offset =3D (u64)-1;
> +	root =3D btrfs_read_fs_root(fs_info, &key);
> +	if (IS_ERR(root)) {
> +		ret =3D PTR_ERR(root);
> +		goto out;
> +	}
> +
> +	key.objectid =3D objectid;
> +	key.type =3D BTRFS_EXTENT_DATA_KEY;
> +	key.offset =3D offset;
> +	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret > 0) {
> +		fprintf(stderr,
> +			"Missing file extent item for inode %llu, root %llu, offset %llu",
> +			objectid, rootid, offset);
> +		ret =3D -ENOENT;
> +	}
> +	if (ret < 0)
> +		goto out;
> +
> +	while (true) {
> +		struct btrfs_file_extent_item *fi;
> +		int extent_type;
> +
> +		if (path.slots[0] >=3D btrfs_header_nritems(path.nodes[0])) {
> +			ret =3D btrfs_next_leaf(fs_info->extent_root, &path);
> +			if (ret < 0)
> +				goto out;
> +			if (ret > 0)
> +				break;
> +		}
> +
> +		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +		if (key.objectid !=3D objectid ||
> +		    key.type !=3D BTRFS_EXTENT_DATA_KEY)
> +			break;
> +
> +		fi =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
> +				    struct btrfs_file_extent_item);
> +		extent_type =3D btrfs_file_extent_type(path.nodes[0], fi);
> +		if (extent_type !=3D BTRFS_FILE_EXTENT_REG &&
> +		    extent_type !=3D BTRFS_FILE_EXTENT_PREALLOC)
> +			goto next;
> +
> +		if (btrfs_file_extent_disk_bytenr(path.nodes[0], fi) !=3D
> +		    disk_bytenr)
> +			break;
> +
> +		if (extent_type =3D=3D BTRFS_FILE_EXTENT_REG) {
> +			ret =3D 1;
> +			goto out;
> +		}
> +next:
> +		path.slots[0]++;
> +	}
> +	ret =3D 0;
> + out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
> +/*
> + * Check if a shared data reference points to a node that has a file e=
xtent item
> + * pointing to the extent at disk_bytenr that is not of type prealloc =
and is
> + * associated to an inode with a number different from ino.
> + *
> + * Returns 1 if true, 0 if false and < 0 on error.
> + */
> +static int check_prealloc_shared_data_ref(struct btrfs_fs_info *fs_inf=
o,
> +					  u64 ino,
> +					  u64 parent,
> +					  u64 disk_bytenr)
> +{
> +	struct extent_buffer *eb;
> +	u32 nr;
> +	int i;
> +	int ret =3D 0;
> +
> +	eb =3D read_tree_block(fs_info, parent, 0);
> +	if (!extent_buffer_uptodate(eb)) {
> +		ret =3D -EIO;
> +		goto out;
> +	}
> +
> +	nr =3D btrfs_header_nritems(eb);
> +	for (i =3D 0; i < nr; i++) {
> +		struct btrfs_key key;
> +		struct btrfs_file_extent_item *fi;
> +		int extent_type;
> +
> +		btrfs_item_key_to_cpu(eb, &key, i);
> +		if (key.type !=3D BTRFS_EXTENT_DATA_KEY)
> +			continue;
> +		if (key.objectid =3D=3D ino)
> +			continue;
> +
> +		fi =3D btrfs_item_ptr(eb, i, struct btrfs_file_extent_item);
> +
> +		extent_type =3D btrfs_file_extent_type(eb, fi);
> +		if (extent_type !=3D BTRFS_FILE_EXTENT_REG &&
> +		    extent_type !=3D BTRFS_FILE_EXTENT_PREALLOC)
> +			continue;
> +
> +		if (btrfs_file_extent_disk_bytenr(eb, fi) =3D=3D disk_bytenr &&
> +		    extent_type =3D=3D BTRFS_FILE_EXTENT_REG) {
> +			ret =3D 1;
> +			break;
> +		}
> +	}
> + out:
> +	free_extent_buffer(eb);
> +	return ret;
> +}
> +
> +/*
> + * Check if a prealloc extent is shared by other inodes and if any ino=
de has
> + * already written to that extent. This is to avoid emitting invalid w=
arnings
> + * about odd csum items (a inode has an extent entirely marked as prea=
lloc
> + * but another inode shares it and has already written to it).
> + *
> + * Returns 0 if the prealloc extent was not written yet by any inode, =
1 if
> + * at least one other inode has written to it, and < 0 on error.
> + */
> +static int check_prealloc_extent_written(struct btrfs_fs_info *fs_info=
,
> +					 u64 ino,
> +					 u64 disk_bytenr,
> +					 u64 num_bytes)
> +{
> +	struct btrfs_path path;
> +	struct btrfs_key key;
> +	int ret;
> +	struct btrfs_extent_item *ei;
> +	u32 item_size;
> +	unsigned long ptr;
> +	unsigned long end;
> +
> +	key.objectid =3D disk_bytenr;
> +	key.type =3D BTRFS_EXTENT_ITEM_KEY;
> +	key.offset =3D num_bytes;
> +
> +	btrfs_init_path(&path);
> +	ret =3D btrfs_search_slot(NULL, fs_info->extent_root, &key, &path, 0,=
 0);
> +	if (ret > 0) {
> +		fprintf(stderr,
> +			"Missing extent item in extent tree for disk_bytenr %llu, num_bytes=
 %llu\n",
> +			disk_bytenr, num_bytes);
> +		ret =3D -ENOENT;
> +	}
> +	if (ret < 0)
> +		goto out;
> +
> +	/* First check all inline refs. */
> +	ei =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
> +			    struct btrfs_extent_item);
> +	item_size =3D btrfs_item_size_nr(path.nodes[0], path.slots[0]);
> +	ptr =3D (unsigned long)(ei + 1);
> +	end =3D (unsigned long)ei + item_size;
> +	while (ptr < end) {
> +		struct btrfs_extent_inline_ref *iref;
> +		int type;
> +
> +		iref =3D (struct btrfs_extent_inline_ref *)ptr;
> +		type =3D btrfs_extent_inline_ref_type(path.nodes[0], iref);
> +		ASSERT(type =3D=3D BTRFS_EXTENT_DATA_REF_KEY ||
> +		       type =3D=3D BTRFS_SHARED_DATA_REF_KEY);
> +
> +		if (type =3D=3D BTRFS_EXTENT_DATA_REF_KEY) {
> +			struct btrfs_extent_data_ref *dref;
> +
> +			dref =3D (struct btrfs_extent_data_ref *)(&iref->offset);
> +			ret =3D check_prealloc_data_ref(fs_info, ino, disk_bytenr,
> +						      dref, path.nodes[0]);
> +			if (ret !=3D 0)
> +				goto out;
> +		} else if (type =3D=3D BTRFS_SHARED_DATA_REF_KEY) {
> +			u64 parent;
> +
> +			parent =3D btrfs_extent_inline_ref_offset(path.nodes[0],
> +								iref);
> +			ret =3D check_prealloc_shared_data_ref(fs_info,
> +							     ino,
> +							     parent,
> +							     disk_bytenr);
> +			if (ret !=3D 0)
> +				goto out;
> +		}
> +
> +		ptr +=3D btrfs_extent_inline_ref_size(type);
> +	}
> +
> +	/* Now check if there are any non-inlined refs. */
> +	path.slots[0]++;
> +	while (true) {
> +		if (path.slots[0] >=3D btrfs_header_nritems(path.nodes[0])) {
> +			ret =3D btrfs_next_leaf(fs_info->extent_root, &path);
> +			if (ret < 0)
> +				goto out;
> +			if (ret > 0) {
> +				ret =3D 0;
> +				break;
> +			}
> +		}
> +
> +		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +		if (key.objectid !=3D disk_bytenr)
> +			break;
> +
> +		if (key.type =3D=3D BTRFS_EXTENT_DATA_REF_KEY) {
> +			struct btrfs_extent_data_ref *dref;
> +
> +			dref =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
> +					      struct btrfs_extent_data_ref);
> +			ret =3D check_prealloc_data_ref(fs_info, ino, disk_bytenr,
> +						      dref, path.nodes[0]);
> +			if (ret !=3D 0)
> +				goto out;
> +		} else if (key.type =3D=3D BTRFS_SHARED_DATA_REF_KEY) {
> +			ret =3D check_prealloc_shared_data_ref(fs_info,
> +							     ino,
> +							     key.offset,
> +							     disk_bytenr);
> +			if (ret !=3D 0)
> +				goto out;
> +		}
> +
> +		path.slots[0]++;
> +	}
> +out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
>  static int process_file_extent(struct btrfs_root *root,
>  				struct extent_buffer *eb,
>  				int slot, struct btrfs_key *key,
> @@ -1515,8 +1773,16 @@ static int process_file_extent(struct btrfs_root=
 *root,
>  			if (found < num_bytes)
>  				rec->some_csum_missing =3D 1;
>  		} else if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
> -			if (found > 0)
> -				rec->errors |=3D I_ERR_ODD_CSUM_ITEM;
> +			if (found > 0) {
> +				ret =3D check_prealloc_extent_written(root->fs_info,
> +								    rec->ino,
> +								    disk_bytenr,
> +								    num_bytes);
> +				if (ret < 0)
> +					return ret;
> +				if (ret =3D=3D 0)
> +					rec->errors |=3D I_ERR_ODD_CSUM_ITEM;
> +			}
>  		}
>  	}
>  	return 0;
>=20


--HukoTjXDzb2zue2AhoF8chebvH9ytR3ia--

--W1Qzl2WWURQWQW0VKFdzjFf2ljIT0ODKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqoe8IXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgDLAf+LJ7lcLyajcw7/Y3lI1mYvO2d
QWlZYtlE/NCkjD277IVUpUWAuewt8w7pLIdIam7s5pnzHtnx6Y/TtPFSt4uTaarE
nbrcZ4X7OfbccIy6cSrrmBZgzqSYAbZeDSyzcfduwwlfm39rqpjB0GbZNh39DGqK
FhOjCGy3CvQy5wZIWEnca/4FtHs4thUC7Nb90l8cL/uinpnYV+HcWyYMgCpQjnXw
Ijc9xzzAeBF93SDXCrhDKjamNpilxL+smd2gUmXsVKu4o5GbIY+VqvmUvzylq8tx
ZZFKxvIlqMrlqKIj1KFMk1vIUlG8dphWOnaDWNgrgt2xL7tB7flKOWgknjXi3g==
=19Gx
-----END PGP SIGNATURE-----

--W1Qzl2WWURQWQW0VKFdzjFf2ljIT0ODKj--
