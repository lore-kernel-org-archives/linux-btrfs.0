Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59469 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752391AbeEQGjg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 02:39:36 -0400
Subject: Re: [PATCH v5 1/3] btrfs: Add unprivileged ioctl which returns
 subvolume information
To: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
 <41f073796dcc50cb99eb325f6a224eaf2f37d449.1526446338.git.misono.tomohiro@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4fb1ec99-fa59-c1f9-7a86-5e79c02b14e0@gmx.com>
Date: Thu, 17 May 2018 14:39:25 +0800
MIME-Version: 1.0
In-Reply-To: <41f073796dcc50cb99eb325f6a224eaf2f37d449.1526446338.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZKfI3EEgpnq5cOiWxcepNGAML5lTxvpEJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZKfI3EEgpnq5cOiWxcepNGAML5lTxvpEJ
Content-Type: multipart/mixed; boundary="0UCkbjQC3v60wXDuuNcBzj5ZAc16IMuJd";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <4fb1ec99-fa59-c1f9-7a86-5e79c02b14e0@gmx.com>
Subject: Re: [PATCH v5 1/3] btrfs: Add unprivileged ioctl which returns
 subvolume information
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
 <41f073796dcc50cb99eb325f6a224eaf2f37d449.1526446338.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <41f073796dcc50cb99eb325f6a224eaf2f37d449.1526446338.git.misono.tomohiro@jp.fujitsu.com>

--0UCkbjQC3v60wXDuuNcBzj5ZAc16IMuJd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8816=E6=97=A5 13:49, Tomohiro Misono wrote:
> Add new unprivileged ioctl BTRFS_IOC_GET_SUBVOL_INFO which returns
> the information of subvolume containing this inode.
> (i.e. returns the information in ROOT_ITEM and ROOT_BACKREF.)
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  v4 -> v5
>     - Update error handling of btrfs_next_leaf() to cover all cases
>     - Return error if ROOT_BACKREF is not found (except top-level)
>=20
>  fs/btrfs/ioctl.c           | 146 +++++++++++++++++++++++++++++++++++++=
++++++++
>  include/uapi/linux/btrfs.h |  51 ++++++++++++++++
>  2 files changed, 197 insertions(+)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 48e2ddff32bd..c1c9ae9a937d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2242,6 +2242,150 @@ static noinline int btrfs_ioctl_ino_lookup(stru=
ct file *file,
>  	return ret;
>  }
> =20
> +/* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BAC=
KREF */
> +static noinline int btrfs_ioctl_get_subvol_info(struct file *file,
> +					   void __user *argp)
> +{
> +	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
> +	struct btrfs_root *root;
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +
> +	struct btrfs_root_item root_item;
> +	struct btrfs_root_ref *rref;
> +	struct extent_buffer *l;
> +	int slot;
> +
> +	unsigned long item_off;
> +	unsigned long item_len;
> +
> +	struct inode *inode;
> +	int ret;
> +
> +	path =3D btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	subvol_info =3D kzalloc(sizeof(*subvol_info), GFP_KERNEL);
> +	if (!subvol_info) {
> +		btrfs_free_path(path);
> +		return -ENOMEM;
> +	}
> +
> +	inode =3D file_inode(file);
> +	root =3D BTRFS_I(inode)->root->fs_info->tree_root;
> +
> +	key.objectid =3D BTRFS_I(inode)->root->root_key.objectid;
> +	key.type =3D BTRFS_ROOT_ITEM_KEY;
> +	key.offset =3D 0;
> +
> +	ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);

What about just using btrfs_get_fs_root()?

It would save several lines, and have better error handling along with
better tree cache.

Thanks,
Qu

> +	if (ret < 0) {
> +		goto out;
> +	} else if (ret > 0) {
> +		u64 objectid =3D key.objectid;
> +
> +		if (path->slots[0] >=3D btrfs_header_nritems(path->nodes[0])) {
> +			ret =3D btrfs_next_leaf(root, path);
> +			if (ret < 0) {
> +				goto out;
> +			} else if (ret > 0) {
> +				ret =3D -ENOENT;
> +				goto out;
> +			}
> +		}
> +
> +		/* If the subvolume is a snapshot, offset is not zero */
> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> +		if (key.objectid !=3D objectid ||
> +		    key.type !=3D BTRFS_ROOT_ITEM_KEY) {
> +			ret =3D -ENOENT;
> +			goto out;
> +		}
> +	}
> +
> +	l =3D path->nodes[0];
> +	slot =3D path->slots[0];
> +	item_off =3D btrfs_item_ptr_offset(l, slot);
> +	item_len =3D btrfs_item_size_nr(l, slot);
> +	read_extent_buffer(l, &root_item, item_off, item_len);
> +
> +	subvol_info->id =3D key.objectid;
> +
> +	subvol_info->generation =3D btrfs_root_generation(&root_item);
> +	subvol_info->flags =3D btrfs_root_flags(&root_item);
> +
> +	memcpy(subvol_info->uuid, root_item.uuid, BTRFS_UUID_SIZE);
> +	memcpy(subvol_info->parent_uuid, root_item.parent_uuid,
> +						    BTRFS_UUID_SIZE);
> +	memcpy(subvol_info->received_uuid, root_item.received_uuid,
> +						    BTRFS_UUID_SIZE);
> +
> +	subvol_info->ctransid =3D btrfs_root_ctransid(&root_item);
> +	subvol_info->ctime.sec =3D btrfs_stack_timespec_sec(&root_item.ctime)=
;
> +	subvol_info->ctime.nsec =3D btrfs_stack_timespec_nsec(&root_item.ctim=
e);
> +
> +	subvol_info->otransid =3D btrfs_root_otransid(&root_item);
> +	subvol_info->otime.sec =3D btrfs_stack_timespec_sec(&root_item.otime)=
;
> +	subvol_info->otime.nsec =3D btrfs_stack_timespec_nsec(&root_item.otim=
e);
> +
> +	subvol_info->stransid =3D btrfs_root_stransid(&root_item);
> +	subvol_info->stime.sec =3D btrfs_stack_timespec_sec(&root_item.stime)=
;
> +	subvol_info->stime.nsec =3D btrfs_stack_timespec_nsec(&root_item.stim=
e);
> +
> +	subvol_info->rtransid =3D btrfs_root_rtransid(&root_item);
> +	subvol_info->rtime.sec =3D btrfs_stack_timespec_sec(&root_item.rtime)=
;
> +	subvol_info->rtime.nsec =3D btrfs_stack_timespec_nsec(&root_item.rtim=
e);
> +
> +	btrfs_release_path(path);
> +	if (key.objectid !=3D BTRFS_FS_TREE_OBJECTID) {
> +		key.type =3D BTRFS_ROOT_BACKREF_KEY;
> +		key.offset =3D 0;
> +		ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +		if (ret < 0) {
> +			goto out;
> +		} else if (path->slots[0] >=3D
> +				btrfs_header_nritems(path->nodes[0])) {
> +			ret =3D btrfs_next_leaf(root, path);
> +			if (ret < 0) {
> +				goto out;
> +			} else if (ret > 0) {
> +				ret =3D -ENOENT;
> +				goto out;
> +			}
> +		}
> +
> +		l =3D path->nodes[0];
> +		slot =3D path->slots[0];
> +		btrfs_item_key_to_cpu(l, &key, slot);
> +		if (key.objectid =3D=3D subvol_info->id &&
> +		    key.type =3D=3D BTRFS_ROOT_BACKREF_KEY) {
> +			subvol_info->parent_id =3D key.offset;
> +
> +			rref =3D btrfs_item_ptr(l, slot, struct btrfs_root_ref);
> +			subvol_info->dirid =3D btrfs_root_ref_dirid(l, rref);
> +
> +			item_off =3D btrfs_item_ptr_offset(l, slot)
> +					+ sizeof(struct btrfs_root_ref);
> +			item_len =3D btrfs_item_size_nr(l, slot)
> +					- sizeof(struct btrfs_root_ref);
> +			read_extent_buffer(l, subvol_info->name,
> +					   item_off, item_len);
> +		} else {
> +			ret =3D -ENOENT;
> +			goto out;
> +		}
> +	}
> +
> +	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
> +		ret =3D -EFAULT;
> +
> +out:
> +	kzfree(subvol_info);
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
>  static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  					     void __user *arg)
>  {
> @@ -5374,6 +5518,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_get_features(file, argp);
>  	case BTRFS_IOC_SET_FEATURES:
>  		return btrfs_ioctl_set_features(file, argp);
> +	case BTRFS_IOC_GET_SUBVOL_INFO:
> +		return btrfs_ioctl_get_subvol_info(file, argp);
>  	}
> =20
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index c8d99b9ca550..02cd1f1994e8 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -725,6 +725,55 @@ struct btrfs_ioctl_send_args {
>  	__u64 reserved[4];		/* in */
>  };
> =20
> +struct btrfs_ioctl_get_subvol_info_args {
> +	/* All field is out */
> +	/* Id of this subvolume */
> +	__u64 id;
> +	/* Name of this subvolume, used to get the real name at mount point *=
/
> +	char name[BTRFS_VOL_NAME_MAX + 1];
> +	/*
> +	 * Id of the subvolume which contains this subvolume.
> +	 * Zero for top-level subvolume or deleted subvolume
> +	 */
> +	__u64 parent_id;
> +	/*
> +	 * Inode number of the directory which contains this subvolume.
> +	 * Zero for top-level subvolume or deleted subvolume
> +	 */
> +	__u64 dirid;
> +
> +	/* Latest transaction id of this subvolume */
> +	__u64 generation;
> +	/* Flags of this subvolume */
> +	__u64 flags;
> +
> +	/* uuid of this subvolume */
> +	__u8 uuid[BTRFS_UUID_SIZE];
> +	/*
> +	 * uuid of the subvolume of which this subvolume is a snapshot.
> +	 * All zero for non-snapshot subvolume
> +	 */
> +	__u8 parent_uuid[BTRFS_UUID_SIZE];
> +	/*
> +	 * uuid of the subvolume from which this subvolume is received.
> +	 * All zero for non-received subvolume
> +	 */
> +	__u8 received_uuid[BTRFS_UUID_SIZE];
> +
> +	/* Transaction id indicates when change/create/send/receive happens *=
/
> +	__u64 ctransid;
> +	__u64 otransid;
> +	__u64 stransid;
> +	__u64 rtransid;
> +	/* Time corresponds to c/o/s/rtransid */
> +	struct btrfs_ioctl_timespec ctime;
> +	struct btrfs_ioctl_timespec otime;
> +	struct btrfs_ioctl_timespec stime;
> +	struct btrfs_ioctl_timespec rtime;
> +
> +	__u64 reserved[8];
> +};
> +
>  /* Error codes as returned by the kernel */
>  enum btrfs_err_code {
>  	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET =3D 1,
> @@ -843,5 +892,7 @@ enum btrfs_err_code {
>  				   struct btrfs_ioctl_vol_args_v2)
>  #define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
>  					struct btrfs_ioctl_logical_ino_args)
> +#define BTRFS_IOC_GET_SUBVOL_INFO _IOR(BTRFS_IOCTL_MAGIC, 60, \
> +				struct btrfs_ioctl_get_subvol_info_args)
> =20
>  #endif /* _UAPI_LINUX_BTRFS_H */
>=20


--0UCkbjQC3v60wXDuuNcBzj5ZAc16IMuJd--

--ZKfI3EEgpnq5cOiWxcepNGAML5lTxvpEJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr9I50ACgkQwj2R86El
/qjfGwf5Ab+S3PnU6+CN5SOOBYs4bi2DSLhMJgNwmfjvY4yvzHIczUEgS/Lt8bci
ax/sWOzOixYpykwE3a2Zw/mEIU233Jwt6VYDpqtl74Uxz3MQ8J7Y5OkjU1GRvpzN
1qgJ6dM7jiFdbYjwWlM4R7FZHKeu4tGLALOFbkBpMo7mI3aS/592sWWgras+GF03
YS+OJ6xSXyAYzXc3dd72MNxKAubx5Kz0lA4HqSGdy0GX8Ya1yVq2w9aAKpZEsdc2
SNHRw0fNG7R1eHGulYW0U3qnq3+wXh7Zm4X3GZNwGA0O+5EZpIRS6rTgUVGBRVmB
PIZo/Wo8R+QVg/LCA2OHtobfOGcpbg==
=/JTZ
-----END PGP SIGNATURE-----

--ZKfI3EEgpnq5cOiWxcepNGAML5lTxvpEJ--
