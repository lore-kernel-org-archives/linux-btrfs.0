Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49113 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751642AbeEQGtB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 02:49:01 -0400
Subject: Re: [PATCH v5 2/3] btrfs: Add unprivileged ioctl which returns
 subvolume's ROOT_REF
To: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
 <af4638e0d17097f4270e9fea655ca6488ad3a2c6.1526446338.git.misono.tomohiro@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a2278ef4-ae33-3d1d-d04e-36bb3d6fa71c@gmx.com>
Date: Thu, 17 May 2018 14:48:51 +0800
MIME-Version: 1.0
In-Reply-To: <af4638e0d17097f4270e9fea655ca6488ad3a2c6.1526446338.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xgAAgCNypCXz5H7s9C6DUHuxZZ9JXJB8i"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xgAAgCNypCXz5H7s9C6DUHuxZZ9JXJB8i
Content-Type: multipart/mixed; boundary="rNTt2xoYygZUlEyRKIAWcDNh6zTWXWjFs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <a2278ef4-ae33-3d1d-d04e-36bb3d6fa71c@gmx.com>
Subject: Re: [PATCH v5 2/3] btrfs: Add unprivileged ioctl which returns
 subvolume's ROOT_REF
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
 <af4638e0d17097f4270e9fea655ca6488ad3a2c6.1526446338.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <af4638e0d17097f4270e9fea655ca6488ad3a2c6.1526446338.git.misono.tomohiro@jp.fujitsu.com>

--rNTt2xoYygZUlEyRKIAWcDNh6zTWXWjFs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8816=E6=97=A5 13:49, Tomohiro Misono wrote:
> Add unprivileged ioctl BTRFS_IOC_GET_SUBVOL_ROOTREF which
> returns ROOT_REF information of the subvolume containing this inode
> except the subvolume name (this is because to prevent potential name
> leak). The subvolume name will be gained by user version of ino_lookup
> ioctl (BTRFS_IOC_INO_LOOKUP_USER) which also performs permission check.=

>=20
> The min id of root ref's subvolume to be searched is specified by
> @min_id in struct btrfs_ioctl_get_subvol_rootref_args. After the search=

> ends, @min_id is set to the last searched root ref's subvolid + 1. Also=
,
> if there are more root refs than BTRFS_MAX_ROOTREF_BUFFER_NUM, -EOVERFL=
OW
> is returned. Therefore the caller can just call this ioctl again withou=
t
> changing the argument to continue search.
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Just a little off-topic nitpick below, no need to address in this patch.

> ---
>  v4 -> v5
>     - Update error handling of btrfs_next_leaf() to cover all cases
>     - Use btrfs_next_item() to reduce the call of btrfs_search_slot()
>=20
>  fs/btrfs/ioctl.c           | 102 +++++++++++++++++++++++++++++++++++++=
++++++++
>  include/uapi/linux/btrfs.h |  16 +++++++
>  2 files changed, 118 insertions(+)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index c1c9ae9a937d..db5de77540e1 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2386,6 +2386,106 @@ static noinline int btrfs_ioctl_get_subvol_info=
(struct file *file,
>  	return ret;
>  }
> =20
> +/*
> + * Return ROOT_REF information of the subvolume containing this inode
> + * except the subvolume name.
> + */
> +static noinline int btrfs_ioctl_get_subvol_rootref(struct file *file,
> +					   void __user *argp)
> +{
> +	struct btrfs_ioctl_get_subvol_rootref_args *rootrefs;
> +	struct btrfs_root_ref *rref;
> +	struct btrfs_root *root;
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +
> +	struct extent_buffer *l;
> +	int slot;
> +
> +	struct inode *inode;
> +	int ret;
> +	u64 objectid;
> +	u8 found;
> +
> +	path =3D btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	rootrefs =3D memdup_user(argp, sizeof(*rootrefs));
> +	if (!rootrefs) {
> +		btrfs_free_path(path);
> +		return -ENOMEM;
> +	}
> +
> +	inode =3D file_inode(file);
> +	root =3D BTRFS_I(inode)->root->fs_info->tree_root;
> +	objectid =3D BTRFS_I(inode)->root->root_key.objectid;
> +
> +	key.objectid =3D objectid;
> +	key.type =3D BTRFS_ROOT_REF_KEY;
> +	key.offset =3D rootrefs->min_id;
> +	found =3D 0;
> +
> +	ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0) {
> +		goto out;
> +	} else if (path->slots[0] >=3D
> +			btrfs_header_nritems(path->nodes[0])) {
> +		ret =3D btrfs_next_leaf(root, path);
> +		if (ret < 0) {
> +			goto out;
> +		} else if (ret > 0) {
> +			ret =3D -ENOENT;
> +			goto out;
> +		}
> +	}
> +	while (1) {
> +		l =3D path->nodes[0];
> +		slot =3D path->slots[0];
> +
> +		btrfs_item_key_to_cpu(l, &key, slot);
> +		if (key.objectid !=3D objectid ||
> +		    key.type !=3D BTRFS_ROOT_REF_KEY) {
> +			ret =3D 0;
> +			goto out;
> +		}
> +
> +		if (found =3D=3D BTRFS_MAX_ROOTREF_BUFFER_NUM) {
> +			ret =3D -EOVERFLOW;
> +			goto out;
> +		}
> +
> +		rref =3D btrfs_item_ptr(l, slot, struct btrfs_root_ref);
> +		rootrefs->rootref[found].subvolid =3D key.offset;
> +		rootrefs->rootref[found].dirid =3D
> +				  btrfs_root_ref_dirid(l, rref);
> +		found++;
> +
> +		ret =3D btrfs_next_item(root, path);
> +		if (ret < 0) {
> +			goto out;
> +		} else if (ret > 0) {
> +			ret =3D -ENOENT;
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	if (!ret || ret =3D=3D -EOVERFLOW) {
> +		rootrefs->num_items =3D found;
> +		/* update min_id for next search */
> +		if (found)
> +			rootrefs->min_id =3D
> +				rootrefs->rootref[found - 1].subvolid + 1;
> +		if (copy_to_user(argp, rootrefs, sizeof(*rootrefs)))
> +			ret =3D -EFAULT;
> +	}
> +
> +	btrfs_free_path(path);
> +	kfree(rootrefs);
> +	return ret;
> +}
> +
>  static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  					     void __user *arg)
>  {
> @@ -5520,6 +5620,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_set_features(file, argp);
>  	case BTRFS_IOC_GET_SUBVOL_INFO:
>  		return btrfs_ioctl_get_subvol_info(file, argp);
> +	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
> +		return btrfs_ioctl_get_subvol_rootref(file, argp);
>  	}
> =20
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 02cd1f1994e8..b6633f5d4847 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -774,6 +774,20 @@ struct btrfs_ioctl_get_subvol_info_args {
>  	__u64 reserved[8];
>  };
> =20
> +#define BTRFS_MAX_ROOTREF_BUFFER_NUM 255
> +struct btrfs_ioctl_get_subvol_rootref_args {
> +		/* in/out, min id of rootref's subvolid to be searched */
> +		__u64 min_id;
> +		/* out */
> +		struct {
> +			__u64 subvolid;
> +			__u64 dirid;
> +		} rootref[BTRFS_MAX_ROOTREF_BUFFER_NUM];
> +		/* out, number of found items */
> +		__u8 num_items;
> +		__u8 align[7];
> +};
> +

What about some BUILD_BUG_ON() to verify the structure size?

Thanks,
Qu

>  /* Error codes as returned by the kernel */
>  enum btrfs_err_code {
>  	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET =3D 1,
> @@ -894,5 +908,7 @@ enum btrfs_err_code {
>  					struct btrfs_ioctl_logical_ino_args)
>  #define BTRFS_IOC_GET_SUBVOL_INFO _IOR(BTRFS_IOCTL_MAGIC, 60, \
>  				struct btrfs_ioctl_get_subvol_info_args)
> +#define BTRFS_IOC_GET_SUBVOL_ROOTREF _IOWR(BTRFS_IOCTL_MAGIC, 61, \
> +				struct btrfs_ioctl_get_subvol_rootref_args)
> =20
>  #endif /* _UAPI_LINUX_BTRFS_H */
>=20


--rNTt2xoYygZUlEyRKIAWcDNh6zTWXWjFs--

--xgAAgCNypCXz5H7s9C6DUHuxZZ9JXJB8i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr9JdMACgkQwj2R86El
/qj59wgApNNubsBA+rsI/2n/O8kmOlvNZkAr0PSeeFcUzRmj2mp3fEM9zNqce9Yf
1OGvqho0V7stwsIIOCtyMLV6nB3cm5ZD4Yy0cjko/66T9yLeEogPraVDbHdJ0C8/
T0p07a6oLSVnvmfOlbXjmW1tgBR5uMRVFgysAeyH6W78uIayySehNi0O0mB+W4Ws
PJLSv2hOf1yFjriNQdfPEDl0ZQSEgMnvv9ctQTCckwy3rPBWhehv5lfYD8pqi8cq
8n1I62/ir0NLeq7uozu6XmEsgoSJ/9S6IqSgyNLJs+5Ctp+TGo32zzB/qBZm6hbD
7DlEnILtoD1c56rsZTB1W7yFSwpHPQ==
=CnV9
-----END PGP SIGNATURE-----

--xgAAgCNypCXz5H7s9C6DUHuxZZ9JXJB8i--
