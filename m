Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750714AbeEJXEQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 19:04:16 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 42BDDACA3
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 23:04:15 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
References: <20180502211156.9460-1-jeffm@suse.com>
 <20180502211156.9460-2-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a3bb4d77-3783-219a-fad2-3c31ec0c8b38@suse.com>
Date: Thu, 10 May 2018 19:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <20180502211156.9460-2-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EPrW4CyC8Kb5mYbaQiQA9PBRu1sFvK6Mk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EPrW4CyC8Kb5mYbaQiQA9PBRu1sFvK6Mk
Content-Type: multipart/mixed; boundary="gwKQhz7crP900ruAy9EGIPAF8oYk8au3L";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <a3bb4d77-3783-219a-fad2-3c31ec0c8b38@suse.com>
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
References: <20180502211156.9460-1-jeffm@suse.com>
 <20180502211156.9460-2-jeffm@suse.com>
In-Reply-To: <20180502211156.9460-2-jeffm@suse.com>

--gwKQhz7crP900ruAy9EGIPAF8oYk8au3L
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/2/18 5:11 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> Commit 8d9eddad194 (Btrfs: fix qgroup rescan worker initialization)
> fixed the issue with BTRFS_IOC_QUOTA_RESCAN_WAIT being racy, but
> ended up reintroducing the hang-on-unmount bug that the commit it
> intended to fix addressed.
>=20
> The race this time is between qgroup_rescan_init setting
> ->qgroup_rescan_running =3D true and the worker starting.  There are
> many scenarios where we initialize the worker and never start it.  The
> completion btrfs_ioctl_quota_rescan_wait waits for will never come.
> This can happen even without involving error handling, since mounting
> the file system read-only returns between initializing the worker and
> queueing it.
>=20
> The right place to do it is when we're queuing the worker.  The flag
> really just means that btrfs_ioctl_quota_rescan_wait should wait for
> a completion.
>=20
> Since the BTRFS_QGROUP_STATUS_FLAG_RESCAN flag is overloaded to
> refer to both runtime behavior and on-disk state, we introduce a new
> fs_info->qgroup_rescan_ready to indicate that we're initialized and
> waiting to start.
>=20
> This patch introduces a new helper, queue_rescan_worker, that handles
> most of the initialization, the two flags, and queuing the worker,
> including races with unmount.
>=20
> While we're at it, ->qgroup_rescan_running is protected only by the
> ->qgroup_rescan_mutex.  btrfs_ioctl_quota_rescan_wait doesn't need
> to take the spinlock too.
>=20
> Fixes: 8d9eddad194 (Btrfs: fix qgroup rescan worker initialization)
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/ctree.h  |  2 ++
>  fs/btrfs/qgroup.c | 94 +++++++++++++++++++++++++++++++++--------------=
--------
>  2 files changed, 58 insertions(+), 38 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index da308774b8a4..4003498bb714 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1045,6 +1045,8 @@ struct btrfs_fs_info {
>  	struct btrfs_workqueue *qgroup_rescan_workers;
>  	struct completion qgroup_rescan_completion;
>  	struct btrfs_work qgroup_rescan_work;
> +	/* qgroup rescan worker is running or queued to run */
> +	bool qgroup_rescan_ready;
>  	bool qgroup_rescan_running;	/* protected by qgroup_rescan_lock */
> =20
>  	/* filesystem state */
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index aa259d6986e1..466744741873 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -101,6 +101,7 @@ static int
>  qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objecti=
d,
>  		   int init_flags);
>  static void qgroup_rescan_zero_tracking(struct btrfs_fs_info *fs_info)=
;
> +static void btrfs_qgroup_rescan_worker(struct btrfs_work *work);
> =20
>  /* must be called with qgroup_ioctl_lock held */
>  static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_in=
fo,
> @@ -2072,6 +2073,46 @@ int btrfs_qgroup_account_extents(struct btrfs_tr=
ans_handle *trans,
>  	return ret;
>  }
> =20
> +static void queue_rescan_worker(struct btrfs_fs_info *fs_info)
> +{
> +	mutex_lock(&fs_info->qgroup_rescan_lock);
> +	if (btrfs_fs_closing(fs_info)) {
> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
> +		return;
> +	}
> +
> +	if (WARN_ON(!fs_info->qgroup_rescan_ready)) {
> +		btrfs_warn(fs_info, "rescan worker not ready");
> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
> +		return;
> +	}
> +	fs_info->qgroup_rescan_ready =3D false;
> +
> +	if (WARN_ON(fs_info->qgroup_rescan_running)) {
> +		btrfs_warn(fs_info, "rescan worker already queued");
> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
> +		return;
> +	}
> +
> +	/*
> +	 * Being queued is enough for btrfs_qgroup_wait_for_completion
> +	 * to need to wait.
> +	 */
> +	fs_info->qgroup_rescan_running =3D true;
> +	init_completion(&fs_info->qgroup_rescan_completion);
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
> +
> +	memset(&fs_info->qgroup_rescan_work, 0,
> +	       sizeof(fs_info->qgroup_rescan_work));
> +
> +	btrfs_init_work(&fs_info->qgroup_rescan_work,
> +			btrfs_qgroup_rescan_helper,
> +			btrfs_qgroup_rescan_worker, NULL, NULL);
> +
> +	btrfs_queue_work(fs_info->qgroup_rescan_workers,
> +			 &fs_info->qgroup_rescan_work);
> +}
> +
>  /*
>   * called from commit_transaction. Writes all changed qgroups to disk.=

>   */
> @@ -2123,8 +2164,7 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *=
trans,
>  		ret =3D qgroup_rescan_init(fs_info, 0, 1);
>  		if (!ret) {
>  			qgroup_rescan_zero_tracking(fs_info);
> -			btrfs_queue_work(fs_info->qgroup_rescan_workers,
> -					 &fs_info->qgroup_rescan_work);
> +			queue_rescan_worker(fs_info);
>  		}
>  		ret =3D 0;
>  	}
> @@ -2607,6 +2647,10 @@ static void btrfs_qgroup_rescan_worker(struct bt=
rfs_work *work)
>  	if (!path)
>  		goto out;
> =20
> +	mutex_lock(&fs_info->qgroup_rescan_lock);
> +	fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_RESCAN;
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
> +
>  	err =3D 0;
>  	while (!err && !btrfs_fs_closing(fs_info)) {
>  		trans =3D btrfs_start_transaction(fs_info->fs_root, 0);
> @@ -2685,47 +2729,27 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_inf=
o, u64 progress_objectid,
>  {
>  	int ret =3D 0;
> =20
> -	if (!init_flags &&
> -	    (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) ||
> -	     !(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))) {
> +	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
>  		ret =3D -EINVAL;
>  		goto err;
>  	}
> =20
>  	mutex_lock(&fs_info->qgroup_rescan_lock);
> -	spin_lock(&fs_info->qgroup_lock);
> -
> -	if (init_flags) {
> -		if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
> -			ret =3D -EINPROGRESS;
> -		else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
> -			ret =3D -EINVAL;
> -
> -		if (ret) {
> -			spin_unlock(&fs_info->qgroup_lock);
> -			mutex_unlock(&fs_info->qgroup_rescan_lock);
> -			goto err;
> -		}
> -		fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_RESCAN;
> +	if (fs_info->qgroup_rescan_ready || fs_info->qgroup_rescan_running) {=

> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
> +		ret =3D -EINPROGRESS;
> +		goto err;
>  	}

Without checking for these flags when deciding whether we want to do
accounting, we'll end up doing the accounting until we start the rescan
thread.  This may not matter normally, but I'm working on a patch as a
workaround to 824d8dff8846533c9f1f9b1eabb0c03959e989ca doing all qgroup
accounting for entire trees in single transactions.

-Jeff

>  	memset(&fs_info->qgroup_rescan_progress, 0,
>  		sizeof(fs_info->qgroup_rescan_progress));
>  	fs_info->qgroup_rescan_progress.objectid =3D progress_objectid;
> -	init_completion(&fs_info->qgroup_rescan_completion);
> -	fs_info->qgroup_rescan_running =3D true;
> +	fs_info->qgroup_rescan_ready =3D true;
> =20
> -	spin_unlock(&fs_info->qgroup_lock);
>  	mutex_unlock(&fs_info->qgroup_rescan_lock);
> =20
> -	memset(&fs_info->qgroup_rescan_work, 0,
> -	       sizeof(fs_info->qgroup_rescan_work));
> -	btrfs_init_work(&fs_info->qgroup_rescan_work,
> -			btrfs_qgroup_rescan_helper,
> -			btrfs_qgroup_rescan_worker, NULL, NULL);
> -
> -	if (ret) {
>  err:
> +	if (ret) {
>  		btrfs_info(fs_info, "qgroup_rescan_init failed with %d", ret);
>  		return ret;
>  	}
> @@ -2785,9 +2809,7 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info=
)
> =20
>  	qgroup_rescan_zero_tracking(fs_info);
> =20
> -	btrfs_queue_work(fs_info->qgroup_rescan_workers,
> -			 &fs_info->qgroup_rescan_work);
> -
> +	queue_rescan_worker(fs_info);
>  	return 0;
>  }
> =20
> @@ -2798,9 +2820,7 @@ int btrfs_qgroup_wait_for_completion(struct btrfs=
_fs_info *fs_info,
>  	int ret =3D 0;
> =20
>  	mutex_lock(&fs_info->qgroup_rescan_lock);
> -	spin_lock(&fs_info->qgroup_lock);
>  	running =3D fs_info->qgroup_rescan_running;
> -	spin_unlock(&fs_info->qgroup_lock);
>  	mutex_unlock(&fs_info->qgroup_rescan_lock);
> =20
>  	if (!running)
> @@ -2819,12 +2839,10 @@ int btrfs_qgroup_wait_for_completion(struct btr=
fs_fs_info *fs_info,
>   * this is only called from open_ctree where we're still single thread=
ed, thus
>   * locking is omitted here.
>   */
> -void
> -btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
> +void btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
>  {
>  	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
> -		btrfs_queue_work(fs_info->qgroup_rescan_workers,
> -				 &fs_info->qgroup_rescan_work);
> +		queue_rescan_worker(fs_info);
>  }
> =20
>  /*
>=20


--=20
Jeff Mahoney
SUSE Labs


--gwKQhz7crP900ruAy9EGIPAF8oYk8au3L--

--EPrW4CyC8Kb5mYbaQiQA9PBRu1sFvK6Mk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlr0z+wACgkQHntLYyF5
5bKv4hAAoHhJV5R6VdDURV4uT6pbS7zH+MigCfNv82ZFm13lJ5RhOey6rirCJ5zE
V8Lm2VvxNtmRI3dBYQd7OPsGiAx4/8Vn2H5xL3S0n0xIiiXx6wK5iSk2q20wRWQH
VcN+H4gf7CQ3rW6k0HVZMONdBqMkqDYwZfC6PlD+4kCetzKTq1ih59VlcN6Td2T4
sy1EIdZxmUCiaBncfWQOIMubB2tGkfv6jNlxlT7iT5J3/TdsIhi8GvfTvGK6UQrb
sr6KAaWXSHruU2RWUb1nM59GqyojqaIS2YLBTFT3ccjMOYoMI+ikk0bdWtFZUK0U
WjuYzDK+uWQJ3XPLegPYdJwGNI9YIEG5KcX2I1M5OYHTI9VWDCaCp9DPmBUKD1qZ
bF4+R3IUI0vBbRq//AWLI4uriVI2VOQRxn+55EU82Li31iRkiK66bRUOohL7cYJs
aKVQp7hLfuOZ/LmHDLesxkDWfBTafirEkl3Mep4NfvETeCg7zY5PcMXVY1QP+vyI
7vV3ptONqv+rWYiibo6HP1HaQjrczmiqKwct0T20mn32oTqCxcgjljH7MDgO05dk
u4+2YtjiZiYL+N2HLhjCBEILOrC0OUDv9isns7ZRf99yyW0hgRDxrrXfA8C6yd0C
FsQ0OsekmgUIW+NW+mb2S4afMx3fy+ofA05x5ZdUdVtND7r/+t8=
=uuxJ
-----END PGP SIGNATURE-----

--EPrW4CyC8Kb5mYbaQiQA9PBRu1sFvK6Mk--
