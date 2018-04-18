Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57327 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753550AbeDRFVg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 01:21:36 -0400
Subject: Re: [PATCH v2 06/10] btrfs-progs: undelete-subvol: introduce
 link_subvol_to_lostfound
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-7-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <21596e4a-e198-8299-4af3-030ce72dc5ae@gmx.com>
Date: Wed, 18 Apr 2018 13:21:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180327070658.13064-7-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zu698z79MBU8bHXJWpmQrXTPkMSBAp6FC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zu698z79MBU8bHXJWpmQrXTPkMSBAp6FC
Content-Type: multipart/mixed; boundary="vDgfMl0KW4ZxlXKDJwxUbG1u2kaALFx5d";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <21596e4a-e198-8299-4af3-030ce72dc5ae@gmx.com>
Subject: Re: [PATCH v2 06/10] btrfs-progs: undelete-subvol: introduce
 link_subvol_to_lostfound
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-7-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-7-lufq.fnst@cn.fujitsu.com>

--vDgfMl0KW4ZxlXKDJwxUbG1u2kaALFx5d
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8827=E6=97=A5 15:06, Lu Fengqi wrote:
> The function will create lost+found directory, link the deleted
> subvolume specified by the subvol_id to the directory, update the
> information of root_item and cleanup the associated orphan item.
>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  undelete-subvol.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 76 insertions(+)
>=20
> diff --git a/undelete-subvol.c b/undelete-subvol.c
> index 781057df2b84..9243e35545c5 100644
> --- a/undelete-subvol.c
> +++ b/undelete-subvol.c
> @@ -106,3 +106,79 @@ out:
>  	btrfs_release_path(&path);
>  	return ret;
>  }
> +
> +/*
> + * Recover a subvolume specified by subvol_id, and link it to the lost=
+found
> + * directory.
> + *
> + * @root: the root of the root tree.

In that case, @fs_info would case less confusion.

Otherwise looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> + * @subvol_id: specify the subvolume which will be linked, and also be=
 the part
> + * of the subvolume name.
> + *
> + * Return 0 if no error occurred.
> + */
> +static int link_subvol_to_lostfound(struct btrfs_root *root, u64 subvo=
l_id)
> +{
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_fs_info *fs_info =3D root->fs_info;
> +	struct btrfs_root *fs_root =3D fs_info->fs_root;
> +	char buf[BTRFS_NAME_LEN + 1] =3D {0}; /* 1 for snprintf null */
> +	char *dir_name =3D "lost+found";
> +	u64 lost_found_ino =3D 0;
> +	u32 mode =3D 0700;
> +	int ret;
> +
> +	/*
> +	 * For link subvolume to lost+found,
> +	 * 2 for parent(256)'s dir_index and dir_item
> +	 * 2 for lost+found dir's inode_item and inode_ref
> +	 * 2 for lost+found dir's dir_index and dir_item for the subvolume
> +	 * 2 for the subvolume's root_ref and root_backref
> +	 */
> +	trans =3D btrfs_start_transaction(fs_root, 8);
> +	if (IS_ERR(trans)) {
> +		error("unable to start transaction");
> +		ret =3D PTR_ERR(trans);
> +		goto out;
> +	}
> +
> +	/* Create lost+found directory */
> +	ret =3D btrfs_mkdir(trans, fs_root, dir_name, strlen(dir_name),
> +			  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
> +			  mode);
> +	if (ret < 0) {
> +		error("failed to create '%s' dir: %d", dir_name, ret);
> +		goto out;
> +	}
> +
> +	/* Link the subvolume to lost+found directory */
> +	snprintf(buf, BTRFS_NAME_LEN + 1, "sub%llu", subvol_id);
> +	ret =3D btrfs_link_subvol(trans, fs_root, buf, subvol_id, lost_found_=
ino,
> +				false);
> +	if (ret) {
> +		error("failed to link the subvol %llu: %d", subvol_id, ret);
> +		goto out;
> +	}
> +
> +	/* Clear root flags BTRFS_ROOT_SUBVOL_DEAD and increase root refs */
> +	ret =3D recover_dead_root(trans, root, subvol_id);
> +	if (ret)
> +		goto out;
> +
> +	/* Delete the orphan item after undeletion is completed. */
> +	ret =3D btrfs_del_orphan_item(trans, root, subvol_id);
> +	if (ret) {
> +		error("failed to delete the orphan_item for %llu: %d",
> +				subvol_id, ret);
> +		goto out;
> +	}
> +
> +	ret =3D btrfs_commit_transaction(trans, fs_root);
> +	if (ret) {
> +		error("transaction commit failed: %d", ret);
> +		goto out;
> +	}
> +
> +out:
> +	return ret;
> +}
>=20


--vDgfMl0KW4ZxlXKDJwxUbG1u2kaALFx5d--

--zu698z79MBU8bHXJWpmQrXTPkMSBAp6FC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrW1dcACgkQwj2R86El
/qjO5gf/XIIjNA3pfVwxOV0fmjr7HF2SoADuyr4uoNrdrZd56zrSLT69DXRaVFmT
zjXAZnQIttPzR/NJ7DbgXm/5sL1DzmU+fyb5UVlcYHCdMbsz3wDKf6iML0/tVTHE
4xmFGyE9MFKlQTvq1ZdVFpdbRU+Eb4CVVQb5YCSTmJqw6nzMCMOUaiVK5jXCtskO
TDOW6BqlUIbIuhbkXElnYAQ4PHjatWkdwwmgYK/Ol8ZNT7djR6hMMs9QnEYFRw0k
pqPozleCYGTM0gtS3fLFBV6B63JHixZb82ocYrgCLBSeEDSKlYj5Nszg1d2ArHi4
Ry+qbUrtB76oc4ZUdVrjXyjGCm2xyg==
=w+oL
-----END PGP SIGNATURE-----

--zu698z79MBU8bHXJWpmQrXTPkMSBAp6FC--
