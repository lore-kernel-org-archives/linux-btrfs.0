Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F0F41D207
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 12:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786536219; cv=none; b=jUtJiqKg9/FYz7d2N+VlBpZYC4zs7+Xogo9M2g/d17Qvz9I6IX2apGKzYzadhytIfDMEbdiChqMem/GsduQgfqdO7qKWG1UnnsBwUtBD1JRChSCRtmLNr9UAjLc2FpD6aSgI3kaoK12C7d4G6C0gtzXUnnm753DdNKWCed1HVbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786536219; c=relaxed/simple;
	bh=edDoKM45KLWwlNcR52glB6yuDgHUmghX3x1kqN99VdM=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q868z7YiGorEqd2MPdTM01016vMTGaewrEcC0Y+hPU8MmCWWaxfq3QcdrdmoAqfKPHHhBJH/VD2GT0QYLcZgdInL5pMGMD0QEbLyJXDN9YVGHc43PNHEU7p30FMjSShI1NZ+RqOlRAzItGEC6m9aCbt1To8JPmztF0sQu1c+BCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvrBVKCi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvrBVKCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F961F000E9;
	Wed, 12 Aug 2026 12:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786536217;
	bh=Fo7Im+sChCx/nIGsGJWw+R97ERMk0xyOUMSORynpeoo=;
	h=Subject:From:To:Date:In-Reply-To:References;
	b=hvrBVKCiH5qvclwPAeQs8zdpqxRGS7VM46SPvbDS1QoAH0vQmSZdlB+Qs8BCKSpfB
	 p7nhYUaydyFY4DpT7B78JvfJcpzGxIyMYtygrcKkXgPMXSyjYzTnT6R0q5qkz8+AcY
	 S81YwQHIOkaGAqdATH/CsuJxfFvhmejB0QR2LePifSTipuMDwTyp4uv6o/giRhTvyX
	 XiyU5xlU0OfexXK2tFzijgg6iV8tj3sh3jgQwcsZpDSHy7qZOGmYiDqEhs3QgZLZ2n
	 idzMSDvz7ezpdXhLfgpweoRdETugYtQ8BLzP7c1jpTuijw7ST2CcIuCMR2/FCGdO/p
	 3t++tXnYR1/NQ==
Message-ID: <5f0a52c918ba270886df4e5479370f286aee1adf.camel@kernel.org>
Subject: Re: [PATCH] btrfs: properly cleanup replace_task when the replace
 failed to start
From: Jeff Layton <jlayton@kernel.org>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Date: Wed, 12 Aug 2026 08:03:36 -0400
In-Reply-To: <2bb108e8d3204506a80562fec03d0d365583631f.1786348282.git.wqu@suse.com>
References: 
	<2bb108e8d3204506a80562fec03d0d365583631f.1786348282.git.wqu@suse.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

I ran this through some LLM review and it seems to think that this fix
isn't complete. Pasting the review comments verbatim below:

On Mon, 2026-08-10 at 17:21 +0930, Qu Wenruo wrote:

> In the function btrfs_dev_replace_start(), we have several error paths
> that assigns replace_start without reverting it back to NULL.

This isn't a bug, but should replace_start be replace_task here?

> But since dev_replace->rwsem is incorrectly updated, a process
> triggering the update will no longer be protected from dev-replace's
> device list modification, thus later IO can get stale device info,
> triggering things like use-after-free.

The thing left incorrectly updated is dev_replace->replace_task, not
dev_replace->rwsem, right?

> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 72cba7fed942..5fc1dec88fb2 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -633,7 +633,6 @@ static int btrfs_dev_replace_start(struct btrfs_fs_in=
fo *fs_info,
>  		goto leave;
>
>  	down_write(&dev_replace->rwsem);
> -	dev_replace->replace_task =3D current;
>  	switch (dev_replace->replace_state) {
>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
> @@ -647,6 +646,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_in=
fo *fs_info,
>  		goto leave;
>  	}
>
> +	dev_replace->replace_task =3D current;
>  	dev_replace->cont_reading_from_srcdev_mode =3D read_src;
>  	dev_replace->srcdev =3D src_device;
>  	dev_replace->tgtdev =3D tgt_device;
> @@ -693,6 +693,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_in=
fo *fs_info,
>  			BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED;
>  		dev_replace->srcdev =3D NULL;
>  		dev_replace->tgtdev =3D NULL;
> +		dev_replace->replace_task =3D NULL;
>  		up_write(&dev_replace->rwsem);
>  		goto leave;
>  	}

Both of the paths handled here are inside btrfs_dev_replace_start().  Is
the same reset needed in btrfs_dev_replace_finishing()?  That function
only clears replace_task on the path that completes the swap:

fs/btrfs/dev-replace.c:btrfs_dev_replace_finishing() {
	...
	list_add(&tgt_device->dev_alloc_list, &fs_devices->alloc_list);
	fs_devices->rw_devices++;

	dev_replace->replace_task =3D NULL;
	up_write(&dev_replace->rwsem);
	...
}

The scrub_ret error path returns earlier.  It clears srcdev and tgtdev and
moves the state to canceled, but leaves replace_task pointing at the task
that started the replace:

fs/btrfs/dev-replace.c:btrfs_dev_replace_finishing() {
	...
	down_write(&dev_replace->rwsem);
	dev_replace->replace_state =3D
		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
	dev_replace->tgtdev =3D NULL;
	dev_replace->srcdev =3D NULL;
	...
	} else {
		if (scrub_ret !=3D -ECANCELED)
			btrfs_err(fs_info, ...);
error:
		up_write(&dev_replace->rwsem);
		...
		return scrub_ret;
	}
	...
}

An ordinary "btrfs replace cancel" ends up there:

btrfs_dev_replace_cancel()
    btrfs_scrub_cancel()

btrfs_dev_replace_start()
    ret =3D btrfs_scrub_dev()			-> -ECANCELED
    ret =3D btrfs_dev_replace_finishing(fs_info, ret)
	-> error: ... return scrub_ret

The ioctl then returns to userspace with dev_replace->replace_task still
set to the task that ran the ioctl.  Isn't that the same stale pointer the
commit message describes for the already-started case, only reachable
without a second replace or an allocation failure?

The two other early returns in btrfs_dev_replace_finishing(), the
btrfs_start_delalloc_roots() failure and the btrfs_start_transaction()
failure in the commit loop, leave it set as well.

There is a second effect once replace_task is stale but still compares
equal to a live task.  btrfs_map_block() reads it twice:

fs/btrfs/volumes.c:btrfs_map_block() {
	...
	if (dev_replace->replace_task !=3D current)
		down_read(&dev_replace->rwsem);

	dev_replace_is_ongoing =3D btrfs_dev_replace_is_ongoing(dev_replace);
	/*
	 * Hold the semaphore for read during the whole operation, write is
	 * requested at commit time but must wait.
	 */
	if (!dev_replace_is_ongoing && dev_replace->replace_task !=3D current)
		up_read(&dev_replace->rwsem);
	...
}

If a later btrfs_dev_replace_start() assigns replace_task between those
two reads, the first test skips down_read() while the second one runs
up_read().  Can that release an rwsem this task never acquired?

--=20
Jeff Layton <jlayton@kernel.org>
