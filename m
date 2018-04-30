Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58665 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751583AbeD3GU2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 02:20:28 -0400
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180426192351.473-1-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6652a2fc-ff03-77d5-3811-5a138543a3d2@gmx.com>
Date: Mon, 30 Apr 2018 14:20:14 +0800
MIME-Version: 1.0
In-Reply-To: <20180426192351.473-1-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wAg1hKkPUISIwjXCknKK8FQZqZUjkljn9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wAg1hKkPUISIwjXCknKK8FQZqZUjkljn9
Content-Type: multipart/mixed; boundary="HZ80PXmmEooaoEPSaKugQU2gm2RlERcNP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Message-ID: <6652a2fc-ff03-77d5-3811-5a138543a3d2@gmx.com>
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
References: <20180426192351.473-1-jeffm@suse.com>
In-Reply-To: <20180426192351.473-1-jeffm@suse.com>

--HZ80PXmmEooaoEPSaKugQU2gm2RlERcNP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8827=E6=97=A5 03:23, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> Commit d2c609b834d6 (Btrfs: fix qgroup rescan worker initialization)
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
> This patch introduces a new helper, queue_rescan_worker, that handles
> the ->qgroup_rescan_running flag, including any races with umount.
>=20
> While we're at it, ->qgroup_rescan_running is protected only by the
> ->qgroup_rescan_mutex.  btrfs_ioctl_quota_rescan_wait doesn't need
> to take the spinlock too.
>=20
> Fixes: d2c609b834d6 (Btrfs: fix qgroup rescan worker initialization)
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

A little off-topic, (thanks Nikolay for reporting this) sometimes
btrfs/017 could report qgroup corruption, and it turns out it's related
to rescan racy, which double account existing tree blocks twice.
(One by btrfs quota enable, another by btrfs quota rescan -w)

Would this patch help in such case?

Thanks,
Qu

> ---
>  fs/btrfs/ctree.h  |  1 +
>  fs/btrfs/qgroup.c | 40 ++++++++++++++++++++++++++++------------
>  2 files changed, 29 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index da308774b8a4..dbba615f4d0f 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1045,6 +1045,7 @@ struct btrfs_fs_info {
>  	struct btrfs_workqueue *qgroup_rescan_workers;
>  	struct completion qgroup_rescan_completion;
>  	struct btrfs_work qgroup_rescan_work;
> +	/* qgroup rescan worker is running or queued to run */
>  	bool qgroup_rescan_running;	/* protected by qgroup_rescan_lock */
> =20
>  	/* filesystem state */
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index aa259d6986e1..be491b6c020a 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2072,6 +2072,30 @@ int btrfs_qgroup_account_extents(struct btrfs_tr=
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
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
> +
> +	btrfs_queue_work(fs_info->qgroup_rescan_workers,
> +			 &fs_info->qgroup_rescan_work);
> +}
> +
>  /*
>   * called from commit_transaction. Writes all changed qgroups to disk.=

>   */
> @@ -2123,8 +2147,7 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *=
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
> @@ -2713,7 +2736,6 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info,=
 u64 progress_objectid,
>  		sizeof(fs_info->qgroup_rescan_progress));
>  	fs_info->qgroup_rescan_progress.objectid =3D progress_objectid;
>  	init_completion(&fs_info->qgroup_rescan_completion);
> -	fs_info->qgroup_rescan_running =3D true;
> =20
>  	spin_unlock(&fs_info->qgroup_lock);
>  	mutex_unlock(&fs_info->qgroup_rescan_lock);
> @@ -2785,9 +2807,7 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info=
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
> @@ -2798,9 +2818,7 @@ int btrfs_qgroup_wait_for_completion(struct btrfs=
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
> @@ -2819,12 +2837,10 @@ int btrfs_qgroup_wait_for_completion(struct btr=
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


--HZ80PXmmEooaoEPSaKugQU2gm2RlERcNP--

--wAg1hKkPUISIwjXCknKK8FQZqZUjkljn9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrmtZ4ACgkQwj2R86El
/qhxqwf/W02vaAPOWATKqXkvdxDiKgiEQ2RqLtFyOr7aY2V1Z9xbQZXwi5qEhYl+
TYtF3/awzhr/iCA1GNTDkCqHbHjvabLwvdsrKimLgBkXs8Pu8Cz01hjSs4LKMWe7
+3rTmubC8KlIalZaHQ1nKyQSHaNks+Vtrgohd9El39gx8QzKuJV6PWORB1oLDee0
FdVPu3KgGiZ+V0sPIxG6sL1btcFc/cQAWc5i2lrMKc/qYrXodH1YgAYiEcwL4U4L
RKEbQ6ii8jL6TiXMJBc5DESAo9rdZAgMBeFbQZhDCWUUwHSr3dZ64BIN2xwfD1g8
owJnsbGJpbWh4FtrY3c+1RxByrBwWA==
=8Tam
-----END PGP SIGNATURE-----

--wAg1hKkPUISIwjXCknKK8FQZqZUjkljn9--
