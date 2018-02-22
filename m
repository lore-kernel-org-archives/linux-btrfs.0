Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51141 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751738AbeBVBgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 20:36:38 -0500
Subject: Re: [PATCH] btrfs: qgroups, properly handle no reservations
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180221201921.17944-1-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2030c88e-328a-8021-3dfd-0631e7429eac@gmx.com>
Date: Thu, 22 Feb 2018 09:36:25 +0800
MIME-Version: 1.0
In-Reply-To: <20180221201921.17944-1-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dzJ7xEFQBRAm2qu2FdZyZVVqFCg8y9jfe"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dzJ7xEFQBRAm2qu2FdZyZVVqFCg8y9jfe
Content-Type: multipart/mixed; boundary="6JtO3CC93coBhBg95tbXecMYtkJ2twdiQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <2030c88e-328a-8021-3dfd-0631e7429eac@gmx.com>
Subject: Re: [PATCH] btrfs: qgroups, properly handle no reservations
References: <20180221201921.17944-1-jeffm@suse.com>
In-Reply-To: <20180221201921.17944-1-jeffm@suse.com>

--6JtO3CC93coBhBg95tbXecMYtkJ2twdiQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8822=E6=97=A5 04:19, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> There are several places where we call btrfs_qgroup_reserve_meta and
> assume that a return value of 0 means that the reservation was successf=
ul.
>=20
> Later, we use the original bytes value passed to that call to free
> bytes during error handling or to pass the number of bytes reserved to
> the caller.
>=20
> This patch returns -ENODATA when we don't perform a reservation so that=

> callers can make the distinction.  This also lets call sites not
> necessarily care whether qgroups are enabled.

IMHO if we don't need to reserve, returning 0 seems good enough.
Caller doesn't really need to care if it has reserved some bytes.

Or is there any special case where we need to distinguish such case?

Thanks,
Qu

>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 33 ++++++++++++++++-----------------
>  fs/btrfs/qgroup.c      |  4 ++--
>  fs/btrfs/transaction.c |  5 ++++-
>  3 files changed, 22 insertions(+), 20 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index c1618ab9fecf..2d5e963fae88 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5988,20 +5988,18 @@ int btrfs_subvolume_reserve_metadata(struct btr=
fs_root *root,
>  				     u64 *qgroup_reserved,
>  				     bool use_global_rsv)
>  {
> -	u64 num_bytes;
>  	int ret;
>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
>  	struct btrfs_block_rsv *global_rsv =3D &fs_info->global_block_rsv;
> +	/* One for parent inode, two for dir entries */
> +	u64 num_bytes =3D 3 * fs_info->nodesize;
> =20
> -	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
> -		/* One for parent inode, two for dir entries */
> -		num_bytes =3D 3 * fs_info->nodesize;
> -		ret =3D btrfs_qgroup_reserve_meta(root, num_bytes, true);
> -		if (ret)
> -			return ret;
> -	} else {
> +	ret =3D btrfs_qgroup_reserve_meta(root, num_bytes, true);
> +	if (ret =3D=3D -ENODATA) {
>  		num_bytes =3D 0;
> -	}
> +		ret =3D 0;
> +	} else if (ret)
> +		return ret;
> =20
>  	*qgroup_reserved =3D num_bytes;
> =20
> @@ -6057,6 +6055,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_=
inode *inode, u64 num_bytes)
>  	enum btrfs_reserve_flush_enum flush =3D BTRFS_RESERVE_FLUSH_ALL;
>  	int ret =3D 0;
>  	bool delalloc_lock =3D true;
> +	u64 qgroup_reserved;
> =20
>  	/* If we are a free space inode we need to not flush since we will be=
 in
>  	 * the middle of a transaction commit.  We also don't need the delall=
oc
> @@ -6090,17 +6089,17 @@ int btrfs_delalloc_reserve_metadata(struct btrf=
s_inode *inode, u64 num_bytes)
>  	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
>  	spin_unlock(&inode->lock);
> =20
> -	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
> -		ret =3D btrfs_qgroup_reserve_meta(root,
> -				nr_extents * fs_info->nodesize, true);
> -		if (ret)
> -			goto out_fail;
> -	}
> +	qgroup_reserved =3D nr_extents * fs_info->nodesize;
> +	ret =3D btrfs_qgroup_reserve_meta(root, qgroup_reserved, true);
> +	if (ret =3D=3D -ENODATA) {
> +		ret =3D 0;
> +		qgroup_reserved =3D 0;
> +	} if (ret)
> +		goto out_fail;
> =20
>  	ret =3D btrfs_inode_rsv_refill(inode, flush);
>  	if (unlikely(ret)) {
> -		btrfs_qgroup_free_meta(root,
> -				       nr_extents * fs_info->nodesize);
> +		btrfs_qgroup_free_meta(root, qgroup_reserved);
>  		goto out_fail;
>  	}
> =20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index aa259d6986e1..5d9e011243c6 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3025,7 +3025,7 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *=
root, int num_bytes,
> =20
>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
>  	    !is_fstree(root->objectid) || num_bytes =3D=3D 0)
> -		return 0;
> +		return -ENODATA;
> =20
>  	BUG_ON(num_bytes !=3D round_down(num_bytes, fs_info->nodesize));
>  	trace_qgroup_meta_reserve(root, (s64)num_bytes);
> @@ -3057,7 +3057,7 @@ void btrfs_qgroup_free_meta(struct btrfs_root *ro=
ot, int num_bytes)
>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
> =20
>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
> -	    !is_fstree(root->objectid))
> +	    !is_fstree(root->objectid) || num_bytes =3D=3D 0)
>  		return;
> =20
>  	BUG_ON(num_bytes !=3D round_down(num_bytes, fs_info->nodesize));
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 04f07144b45c..ab67b73bd7fa 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -510,7 +510,10 @@ start_transaction(struct btrfs_root *root, unsigne=
d int num_items,
>  		qgroup_reserved =3D num_items * fs_info->nodesize;
>  		ret =3D btrfs_qgroup_reserve_meta(root, qgroup_reserved,
>  						enforce_qgroups);
> -		if (ret)
> +		if (ret =3D=3D -ENODATA) {
> +			ret =3D 0;
> +			qgroup_reserved =3D 0;
> +		} else if (ret)
>  			return ERR_PTR(ret);
> =20
>  		num_bytes =3D btrfs_calc_trans_metadata_size(fs_info, num_items);
>=20


--6JtO3CC93coBhBg95tbXecMYtkJ2twdiQ--

--dzJ7xEFQBRAm2qu2FdZyZVVqFCg8y9jfe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqOHpkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhVGggAn3I3hBqwQpJEpwPO80YRDpCX
RiwVBqFnVblG2lm+c4rYvGWPM0b1CgAc7JevcLHW63f1jdS8cedIlHjC6CjgdTdK
BwFOZWgVuWZdkP3dc+0UGVZ3WuHRTfq/kqH5Hg3BEtaDy67zRmueQFsws+QkiRBv
BuQtXHqzhsMjSYZSypKQKubw/d+YHA7HMpc6mt6QMgUjKxUgq4fzHA5Pui6ZUunG
7cbNO7OtmCepufARilKZRl8tHyFF5LxZrAjBWKQNdsmF6S5r5Ntz4ilc/WE2ZJXM
ExjBGuEmZNiytsNqUEJAObNg5DjS3LO7nZ+cSf+dqxmJERqBrd5bDVrkh3l0Nw==
=IiDk
-----END PGP SIGNATURE-----

--dzJ7xEFQBRAm2qu2FdZyZVVqFCg8y9jfe--
