Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56784 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbeBCDaz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 22:30:55 -0500
Subject: Re: [PATCH] btrfs: Move qgroup rescan on quota enable to
 btrfs_quota_enable
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <1517388724-1483-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fd3a625b-cc65-b032-911a-e9154ddd99d5@gmx.com>
Date: Sat, 3 Feb 2018 11:30:42 +0800
MIME-Version: 1.0
In-Reply-To: <1517388724-1483-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S1zSdgdmvbCupyF10nqZNqG5cUMQ9I9xa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S1zSdgdmvbCupyF10nqZNqG5cUMQ9I9xa
Content-Type: multipart/mixed; boundary="fy0lBlq3MaIfBx3LuVXY5ZUYvfNJr4pEr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Message-ID: <fd3a625b-cc65-b032-911a-e9154ddd99d5@gmx.com>
Subject: Re: [PATCH] btrfs: Move qgroup rescan on quota enable to
 btrfs_quota_enable
References: <1517388724-1483-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1517388724-1483-1-git-send-email-nborisov@suse.com>

--fy0lBlq3MaIfBx3LuVXY5ZUYvfNJr4pEr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8831=E6=97=A5 16:52, Nikolay Borisov wrote:
> Currently btrfs_run_qgroups is doing a bit too much. Not only is it
> responsible for synchronizing in-memory state of qgroups to disk but
> it also contains code to trigger the initial qgroup rescan when
> quota is enabled initially. This condition is detected by checking that=

> BTRFS_FS_QUOTA_ENABLED is not set and BTRFS_FS_QUOTA_ENABLING is set.
> Nothing really requires fro the code to be structured (and scattered)
> the way it is so let's streamline things. First move the quota rescan
> code into btrfs_quota_enable, where its invocation is closer to the
> user. This also makes the FS_QUOTA_ENABLING flag redundant so let's
> remove it as well.i
>=20
> This has been tested with a full xfstest run with qgroups enabled on
> the scratch device of every xfstest and no regressions were observed.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Looks good.

Since rescan work is async, initializing it at enable looks pretty
reasonable.

No delaying makes it easier to read.

> ---
>  fs/btrfs/ctree.h  |  1 -
>  fs/btrfs/qgroup.c | 35 ++++++++++-------------------------
>  2 files changed, 10 insertions(+), 26 deletions(-)

And indeed reduces codes.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 1a462ab85c49..83b645920aba 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -707,7 +707,6 @@ struct btrfs_delayed_root;
>  #define BTRFS_FS_LOG_RECOVERING			4
>  #define BTRFS_FS_OPEN				5
>  #define BTRFS_FS_QUOTA_ENABLED			6
> -#define BTRFS_FS_QUOTA_ENABLING			7
>  #define BTRFS_FS_UPDATE_UUID_TREE_GEN		9
>  #define BTRFS_FS_CREATING_FREE_SPACE_TREE	10
>  #define BTRFS_FS_BTREE_ERR			11
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index f822152693a4..5b446d1bb22d 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -826,10 +826,8 @@ int btrfs_quota_enable(struct btrfs_trans_handle *=
trans,
>  	int slot;
> =20
>  	mutex_lock(&fs_info->qgroup_ioctl_lock);
> -	if (fs_info->quota_root) {
> -		set_bit(BTRFS_FS_QUOTA_ENABLING, &fs_info->flags);
> +	if (fs_info->quota_root)
>  		goto out;
> -	}
> =20
>  	fs_info->qgroup_ulist =3D ulist_alloc(GFP_KERNEL);
>  	if (!fs_info->qgroup_ulist) {
> @@ -923,8 +921,15 @@ int btrfs_quota_enable(struct btrfs_trans_handle *=
trans,
>  	}
>  	spin_lock(&fs_info->qgroup_lock);
>  	fs_info->quota_root =3D quota_root;
> -	set_bit(BTRFS_FS_QUOTA_ENABLING, &fs_info->flags);
> +	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
>  	spin_unlock(&fs_info->qgroup_lock);
> +	ret =3D qgroup_rescan_init(fs_info, 0, 1);
> +	if (!ret) {
> +	        qgroup_rescan_zero_tracking(fs_info);
> +	        btrfs_queue_work(fs_info->qgroup_rescan_workers,
> +	                         &fs_info->qgroup_rescan_work);
> +	}
> +
>  out_free_path:
>  	btrfs_free_path(path);
>  out_free_root:
> @@ -2077,17 +2082,9 @@ int btrfs_run_qgroups(struct btrfs_trans_handle =
*trans,
>  {
>  	struct btrfs_root *quota_root =3D fs_info->quota_root;
>  	int ret =3D 0;
> -	int start_rescan_worker =3D 0;
> =20
>  	if (!quota_root)
> -		goto out;
> -
> -	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
> -	    test_bit(BTRFS_FS_QUOTA_ENABLING, &fs_info->flags))
> -		start_rescan_worker =3D 1;
> -
> -	if (test_and_clear_bit(BTRFS_FS_QUOTA_ENABLING, &fs_info->flags))
> -		set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
> +		return ret;
> =20
>  	spin_lock(&fs_info->qgroup_lock);
>  	while (!list_empty(&fs_info->dirty_qgroups)) {
> @@ -2116,18 +2113,6 @@ int btrfs_run_qgroups(struct btrfs_trans_handle =
*trans,
>  	if (ret)
>  		fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> =20
> -	if (!ret && start_rescan_worker) {
> -		ret =3D qgroup_rescan_init(fs_info, 0, 1);
> -		if (!ret) {
> -			qgroup_rescan_zero_tracking(fs_info);
> -			btrfs_queue_work(fs_info->qgroup_rescan_workers,
> -					 &fs_info->qgroup_rescan_work);
> -		}
> -		ret =3D 0;
> -	}
> -
> -out:
> -
>  	return ret;
>  }
> =20
>=20


--fy0lBlq3MaIfBx3LuVXY5ZUYvfNJr4pEr--

--S1zSdgdmvbCupyF10nqZNqG5cUMQ9I9xa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp1LOMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj7Vgf7B6Q4XfaDeL6LRfscTyerFhQ9
BXMx4cZDouGKyh0hM1LSbZ6IcFSFNXtA3blbBAGX0IQClS491EdNnZ8hWk8Pvw25
TaMDhcy3PjV5AuKE7pyrxWNJBuUG4vGOle/xzXJwpfRIVQ7P3708rKeHhJ+3X9jX
Z2deDC8EXAusAwNIw3MGBWa5L+X3URKoAchDFkSvbdBC2i70dV60UwqbeM+QyQPT
qBEWkbhFpTZU6liHEsKuoEwdIah3FNFEWcSXXrWEIRCqj/1nxImxEfV9upkuunv9
fMFEmGTzHZ6YgSrAXhanEIyIQnNzzJjr902cGVH+EFogsoHJLLFZAYJ5Ays7YQ==
=wEde
-----END PGP SIGNATURE-----

--S1zSdgdmvbCupyF10nqZNqG5cUMQ9I9xa--
