Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9487C43C07C
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 10:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789985671; cv=none; b=MHEroNCkCrZ7TCkpe5NGj9+umqSHNDmVxrBAly0yKDYDoCRBZYH6eFuOvvp2YFtKTxFRMYuZVWA5ZD4WOEz3gztgC4kXaoQq8cAh6rTpmSPV62hCvi3JgLBBS2wtBtBVH0dcYxQSNDUzCHxynBxGh94Om05yGBhsQcSbRTAU08k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789985671; c=relaxed/simple;
	bh=WSJN2SwA+A3GcklkxVT7iI1uNMZnlR9yxVZ2g6nxdQc=;
	h=From:Message-Id:Date:Mime-Version:References:In-Reply-To:
	 Content-Type:To:Subject; b=WBmAcWF61x/0eUedXQupLuC3OECihjgfZCjqAjUIZrZA/EhRZEOB3QtUiq7OGM+oKYDZe5CcvlmUKLHFMyJjL6jhD5Fjlvp8nqu/zZbQMYzmEYnvaVwtUf7Ql22Q9mnxQC0SzC5EJV5elPhnNoFWRwasITWFZcgDNG+RKit7tCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=B1HrLI2L; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="B1HrLI2L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789985657;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Pqqd8mgUHgG+j/CZBMe26cyxKyLROiHp/bBx4hf24/c=;
 b=B1HrLI2LI404W9AJHv6vjvd84Mf5al/IZSAeRZ2xqUjIPLBQUCq/rAiPjAA6gtV87ktsRv
 QJqNtN1bjyanYUTlWKugrpVrhpwBS5E0zfhSnssnYoti7+F+LfGpu1P7b5EKyHYt1Wcy0q
 nIirEJtkJddPxX9to8iMjCBRdjij5cIWKu1dYD/VWqCuu4fzC7FnIhET4UbAIMUSOMhrfN
 kUF6DtuhKjKVwJSXASpFsYdJ0JwjHL40MW86CQkXIqFsyIXzJMicT6JLks57BqTnIBX9oe
 ycpq3Fvkt0m1WFbRd8bUZtOnd34Vd2a9TykcfbRHAOyQyi/cotdk87dN6b6D3g==
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Message-Id: <e6a0a484-c404-4f52-a30d-2c112efe493e@fygo.io>
Received: from [192.168.8.64] ([183.34.169.232]) by smtp.larksuite.com with ESMTPS; Mon, 21 Sep 2026 10:14:16 +0000
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 18:14:10 +0800
X-Lms-Return-Path: <lba+26ab10379+02f3d8+vger.kernel.org+zhudongjiang@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1789981860.git.wqu@suse.com> <b0f743a5d512c45d5184086c1b7f26af65cc261e.1789981860.git.wqu@suse.com>
In-Reply-To: <b0f743a5d512c45d5184086c1b7f26af65cc261e.1789981860.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] btrfs: let rescan_should_stop() decide if the rescan flag is cleared
User-Agent: Mozilla Thunderbird

=E5=9C=A8 2026/9/21 17:16, Qu Wenruo =E5=86=99=E9=81=93:
> Currently if rescan_should_stop() returned true, aka the rescan should
> be stopped, then we won't clear the BTRFS_QGROUP_STATUS_BIT_RESCAN
> unless the BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN is set.
>=20
> However the reason why we should stop rescan is also affecting whether
> we should clear the rescan flag:
>=20
> - fs closing
>   Should not clear RESCAN flag, as the next mount will resume the rescan
>=20
> - fs remounting (from RW to RO)
>   The next RW mount will resume qgroup rescan, so we should not clear
>   the RESCAN flag.
>=20
> - quota already disabled
>   We should clear the RESCAN flag.
>=20
> - CANCEL_RESCAN bit set
>   We should clear the RESCAN flag, for now it's a special case and
>   checked manually later.
>=20
> So it's better to let rescan_should_stop() to determine whether the
> RESCAN flag should also be cleared.
>=20
> Since we're here, also slightly change the message, the CANCEL_RESCAN
> bit is already cleared before outputting the message, so that
> corresponding branch is dead.
>=20
> Save whether we still have the RESCAN bit set when still holding the
> qgroup_rescan_lock instead, and use that saved result to determine if
> the rescan is properly paused or canceled.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 41 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 30 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 05e35eb126dc..eb71f5d7c1a5 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3862,16 +3862,31 @@ static int qgroup_rescan_leaf(struct btrfs_trans_=
handle *trans,
>  	return ret;
>  }
> =20
> -static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
> +/*
> + * Return true if the rescan should be stopped.
> + * If returning true, update @clear_rescan_ret to indicate whether the r=
escan
> + * flag should be cleared.
> + *
> + * Return false if the rescan should continue.
> + */
> +static bool rescan_should_stop(struct btrfs_fs_info *fs_info, bool *clea=
r_rescan_ret)
>  {
> -	if (btrfs_fs_closing(fs_info))
> +	if (btrfs_fs_closing(fs_info)) {
> +		*clear_rescan_ret =3D false;
>  		return true;
> -	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
> +	}
> +	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state)) {
> +		*clear_rescan_ret =3D false;
>  		return true;

What about an RW-to-RW remount, such as:  mount -o remount,compress=3Dzstd =
/mnt

If the rescan worker observes REMOUNTING, wouldn't it stop with RESCAN stil=
l set, but without a corresponding resume call after the remount?

Thanks,
Dongjiang

> -	if (!btrfs_qgroup_enabled(fs_info))
> +	}
> +	if (!btrfs_qgroup_enabled(fs_info)) {
> +		*clear_rescan_ret =3D true;
>  		return true;
> -	if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_f=
lags))
> +	}
> +	if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_f=
lags)) {
> +		*clear_rescan_ret =3D true;
>  		return true;
> +	}
>  	return false;
>  }
> =20
> @@ -3883,7 +3898,9 @@ static void btrfs_qgroup_rescan_worker(struct btrfs=
_work *work)
>  	struct btrfs_trans_handle *trans =3D NULL;
>  	int ret =3D 0;
>  	bool stopped =3D false;
> +	bool clear_rescan =3D false;
>  	bool did_leaf_rescans =3D false;
> +	bool canceled;
> =20
>  	if (btrfs_qgroup_mode(fs_info) =3D=3D BTRFS_QGROUP_MODE_SIMPLE)
>  		return;
> @@ -3900,7 +3917,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs=
_work *work)
>  	path->search_commit_root =3D true;
>  	path->skip_locking =3D true;
> =20
> -	while (!ret && !(stopped =3D rescan_should_stop(fs_info))) {
> +	while (!ret && !(stopped =3D rescan_should_stop(fs_info, &clear_rescan)=
)) {
>  		trans =3D btrfs_start_transaction(fs_info->fs_root, 0);
>  		if (IS_ERR(trans)) {
>  			ret =3D PTR_ERR(trans);
> @@ -3947,8 +3964,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs=
_work *work)
>  	}
> =20
>  	mutex_lock(&fs_info->qgroup_rescan_lock);
> -	if (!stopped || test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
> -				 &fs_info->qgroup_flags))
> +	if (!stopped || clear_rescan ||
> +	    test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_f=
lags))
>  		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
>  	if (trans) {
>  		int ret2 =3D update_qgroup_status_item(trans);
> @@ -3960,6 +3977,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs=
_work *work)
>  	}
>  	fs_info->qgroup_rescan_running =3D false;
>  	clear_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flag=
s);
> +	canceled =3D !test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup=
_flags);
>  	complete_all(&fs_info->qgroup_rescan_completion);
>  	mutex_unlock(&fs_info->qgroup_rescan_lock);
> =20
> @@ -3969,9 +3987,10 @@ static void btrfs_qgroup_rescan_worker(struct btrf=
s_work *work)
>  	btrfs_end_transaction(trans);
> =20
>  	if (stopped) {
> -		btrfs_info(fs_info, "qgroup scan paused");
> -	} else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->q=
group_flags)) {
> -		btrfs_info(fs_info, "qgroup scan cancelled");
> +		if (canceled)
> +			btrfs_info(fs_info, "qgroup scan cancelled");
> +		else
> +			btrfs_info(fs_info, "qgroup scan paused");
>  	} else if (ret >=3D 0) {
>  		btrfs_info(fs_info, "qgroup scan completed%s",
>  			ret > 0 ? " (inconsistency flag cleared)" : "");
