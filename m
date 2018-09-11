Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59153 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbeIKQ4M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 12:56:12 -0400
Subject: Re: [RFC PATCH v2 1/4] btrfs: factor out btrfs_link_subvol from
 create_subvol
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
 <20180911112903.25985-2-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5a15af8a-687b-3a16-867b-9d1e72d24a28@gmx.com>
Date: Tue, 11 Sep 2018 19:57:03 +0800
MIME-Version: 1.0
In-Reply-To: <20180911112903.25985-2-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HtVwDNOv4adW5AtuWow36fcfrWLumBOaI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HtVwDNOv4adW5AtuWow36fcfrWLumBOaI
Content-Type: multipart/mixed; boundary="NTMqqN04eKdspqaHWzQLOHF6s73SNvhfr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <5a15af8a-687b-3a16-867b-9d1e72d24a28@gmx.com>
Subject: Re: [RFC PATCH v2 1/4] btrfs: factor out btrfs_link_subvol from
 create_subvol
References: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
 <20180911112903.25985-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180911112903.25985-2-lufq.fnst@cn.fujitsu.com>

--NTMqqN04eKdspqaHWzQLOHF6s73SNvhfr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/11 =E4=B8=8B=E5=8D=887:29, Lu Fengqi wrote:
> The function btrfs_link_subvol is responsible to link the subvolume to
> the specified directory, which is the opposite of what
> btrfs_unlink_subvol does.
>=20
> No functional change.
>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

The patch itself is OK.

Just small nitpicks inlined below.

> ---
>  fs/btrfs/ioctl.c | 64 +++++++++++++++++++++++++++++++-----------------=

>  1 file changed, 41 insertions(+), 23 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 4905d13dee0a..1b03d07acde2 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -542,6 +542,45 @@ int btrfs_is_empty_uuid(u8 *uuid)
>  	return 1;
>  }
> =20
> +static int btrfs_link_subvol(struct btrfs_trans_handle *trans,
> +			     struct inode *dir, u64 objectid, const char *name,
> +			     int namelen)
> +{
> +	struct btrfs_root *root =3D BTRFS_I(dir)->root;
> +	struct btrfs_key key;
> +	u64 index =3D 0;
> +	int ret;
> +
> +	/*
> +	 * insert the directory item
> +	 */
> +	ret =3D btrfs_set_inode_index(BTRFS_I(dir), &index);
> +	if (ret) {
> +		btrfs_abort_transaction(trans, ret);
> +		return ret;
> +	}
> +
> +	key.objectid =3D objectid;
> +	key.type =3D BTRFS_ROOT_ITEM_KEY;
> +	key.offset =3D -1;
> +	ret =3D btrfs_insert_dir_item(trans, name, namelen, BTRFS_I(dir), &ke=
y,
> +				    BTRFS_FT_DIR, index);
> +	if (ret) {
> +		btrfs_abort_transaction(trans, ret);
> +		return ret;
> +	}
> +
> +	btrfs_i_size_write(BTRFS_I(dir), dir->i_size + namelen * 2);
> +	ret =3D btrfs_update_inode(trans, root, dir);
> +	BUG_ON(ret);

What about clean up this BUG_ON()?

> +
> +	ret =3D btrfs_add_root_ref(trans, objectid, root->root_key.objectid,
> +				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
> +	BUG_ON(ret);

And this one?

Thanks,
Qu

> +
> +	return ret;
> +}
> +
>  static noinline int create_subvol(struct inode *dir,
>  				  struct dentry *dentry,
>  				  const char *name, int namelen,
> @@ -563,7 +602,6 @@ static noinline int create_subvol(struct inode *dir=
,
>  	int err;
>  	u64 objectid;
>  	u64 new_dirid =3D BTRFS_FIRST_FREE_OBJECTID;
> -	u64 index =3D 0;
>  	uuid_le new_uuid;
> =20
>  	root_item =3D kzalloc(sizeof(*root_item), GFP_KERNEL);
> @@ -677,29 +715,9 @@ static noinline int create_subvol(struct inode *di=
r,
>  	new_root->highest_objectid =3D new_dirid;
>  	mutex_unlock(&new_root->objectid_mutex);
> =20
> -	/*
> -	 * insert the directory item
> -	 */
> -	ret =3D btrfs_set_inode_index(BTRFS_I(dir), &index);
> -	if (ret) {
> -		btrfs_abort_transaction(trans, ret);
> -		goto fail;
> -	}
> -
> -	ret =3D btrfs_insert_dir_item(trans, name, namelen, BTRFS_I(dir), &ke=
y,
> -				    BTRFS_FT_DIR, index);
> -	if (ret) {
> -		btrfs_abort_transaction(trans, ret);
> +	ret =3D btrfs_link_subvol(trans, dir, objectid, name, namelen);
> +	if (ret)
>  		goto fail;
> -	}
> -
> -	btrfs_i_size_write(BTRFS_I(dir), dir->i_size + namelen * 2);
> -	ret =3D btrfs_update_inode(trans, root, dir);
> -	BUG_ON(ret);
> -
> -	ret =3D btrfs_add_root_ref(trans, objectid, root->root_key.objectid,
> -				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
> -	BUG_ON(ret);
> =20
>  	ret =3D btrfs_uuid_tree_add(trans, root_item->uuid,
>  				  BTRFS_UUID_KEY_SUBVOL, objectid);
>=20


--NTMqqN04eKdspqaHWzQLOHF6s73SNvhfr--

--HtVwDNOv4adW5AtuWow36fcfrWLumBOaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluXrY8ACgkQwj2R86El
/qhjhAf/RjE/dcMJOE5RNAOjb8iZq0/+keLa4Q/5C6+O3af7SdX9uTwQhxfwne9S
zcqgS8Lgw20ya7GLZrpXD8xAN91mtXAYZTKUcTfKIj8SPzH5Vx5JA7l46+5vT70P
b18Y56loToSKq88tkt745GzXGmC3Sq3ZdksHtTDc6s/DlCkovYbUE04HKeMoCAX/
bzH7jPHGuHIV02+Awssm7l+5/w/sgrtezML8OGAeFVBh2Pv6fX3oPMd1bSyVy/wC
+zF+A/onLq2sXlp0x+nJjfXNBVlzUnyJMYPnDKfBFSBXgternvrFlMPE3YxHPsyp
XecV6ls2jeD8bi6g+/6x7oftN3bFPg==
=DZ41
-----END PGP SIGNATURE-----

--HtVwDNOv4adW5AtuWow36fcfrWLumBOaI--
