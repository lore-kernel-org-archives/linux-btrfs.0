Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426E84ABBB2
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 09:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845390; cv=none; b=JkqqD95BN1TZKLEJzFgdgHNP6N7epuVsrqW3LW4QBSKAjQ/V0/449yrJFiTNUQGG2ZQPRENDg+73SoElMqkCWWTWgwjbalkfFG0G8Gg9sHK2ZSN/IYhaJ8jzbXW66SGAAw4mJmDJEQL/2TckM4yE7t9HQJoX0h/h1Ul8fHc7bLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845390; c=relaxed/simple;
	bh=WIxDIG4TyiPEF8cCXYtoM5quoKhAafLriJwrav1T4ao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KXGZtb2KB+xuJWBo+l8eTqGqZOtcBC6djpZ6WpDX9j5SiBMqMathIM2/UqCF/h5YLKLKWFxSrAdMK3IBxYRYFAZn5NJ13Dkm+Za5odxtZgShjqfWS+IIvOLnDlv2QSiL3kJgotNhPOkmYssaJnItyxCBOiur5EktqC/lWPUeNn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHgVpZYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHgVpZYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB85A1F000FF
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 09:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790845387;
	bh=6ZiS/EF6u2m2ExrKmxU/pR7BGQvwAGmRySaGgDNgJ+c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EHgVpZYHFBnAkvDunaxwG233mppGdtvve9m0uVEWTkq8xIN/QXXcwWWpFUr1B73bj
	 RAAeWlfeen32LO6VVVZ58vFt0+J+Eyn4y1FAj0jJIwtCJ/AhyFnJ/CZtRNQBDDiIjh
	 rSpcXZbNCSpYqIJA0xUKfB1jRHKHFQnod9FBpoxgEKAQMV0VQgGRTVLsNFJnn1K6d/
	 xDSXOsh0xrfPhmzSS8OzhHHLhLVQMN4a5xFbE51/CDHGmI+44DngaKda0skghRcueJ
	 6HNJlgCi8KSzCr5CeXkOwF8HMkCdTaXhufNzPVXKvmugvrNGF6pL9FGWnOtAYRYgDn
	 Ho7M4pMWPrBtw==
Received: by mail-vs2-f36.google.com with SMTP id ada2fe7eead31-7bf5b0e3d13so604106137.0
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2026 02:03:07 -0700 (PDT)
X-Gm-Message-State: AFq9FYITjDeWNEhJ6m+GXwO5k+RmJWOzuRIA09Vme92VmZWPdiuTPCBf
	7v8Np0BTG5TdAm4fmCNHfnIBUEP46BSw1OQumX4Re1xyPC+k2ftZVZofc5ZgkCmjKwfb8x+8D7b
	NFnIjpvx3E/sd6cgKmqdmZO91UblXccc=
X-Received: by 2002:a05:6102:c10:b0:7a7:19aa:8a83 with SMTP id
 ada2fe7eead31-7be73e9aae5mr1261470137.30.1790845387082; Thu, 01 Oct 2026
 02:03:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261001041008.39697-1-wqu@suse.com>
In-Reply-To: <20261001041008.39697-1-wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 1 Oct 2026 10:02:30 +0100
X-Gmail-Original-Message-ID: <CAL3q7H43RxYEF-Ye5B_Qc1VpiG+L06eP27xcg7gnmvF-_7KagA@mail.gmail.com>
X-Gm-Features: AclHuK_YyTZlMPPP1pxj257QODloX2gIwyUO-RNVpJY34F1j4suTsrKArk3kZbQ
Message-ID: <CAL3q7H43RxYEF-Ye5B_Qc1VpiG+L06eP27xcg7gnmvF-_7KagA@mail.gmail.com>
Subject: Re: [PATCH] fstests: btrfs: add a new test case to verify degraded
 RMW writes
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 1, 2026 at 5:10=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> This is a regression test for a recent reported bug.
>
> The test workload is pretty straightforward:
>
> - Create a 4 disks RAID5 or RAID6 btrfs
>
> - Destroy one disk and mount the btrfs degraded
>
> - Use fio to do a workload meeting all the following conditions
>   * Triggering a RMW write
>     This is done by using buffered write with 8 4K writes.
>     The total write will not fulfill a full stripe, thus it will
>     always go through RMW.
>
>   * Some blocks of the full stripe have csum and some do not
>     This is done by pre-allocating the target file before testing, so
>     every full stripe does not have any csum by default.
>
>     Then after some writes, there will be checksum for those new writes,
>     resulting blocks with mixed data checksum.
>
>   * Detect RMW failure
>     This is done through fdatasync.
>
> For unpatched kernels, the fio will always fail pretty early, meanwhile
> patched kernels can finish the full 15 seconds runs on both RAID5 and
> RAID6 profiles.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/btrfs/357     | 65 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/357.out |  2 ++
>  2 files changed, 67 insertions(+)
>  create mode 100755 tests/btrfs/357
>  create mode 100644 tests/btrfs/357.out
>
> diff --git a/tests/btrfs/357 b/tests/btrfs/357
> new file mode 100755
> index 00000000..f2c04285
> --- /dev/null
> +++ b/tests/btrfs/357
> @@ -0,0 +1,65 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 357
> +#
> +# Make sure on degraded RAID5/6, RMW writes won't return false errors
> +# when some blocks do not have checksums.
> +#
> +. ./common/preamble
> +
> +_begin_fstest auto raid volume
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +       "btrfs: raid56: do not verify the content if there is no data che=
cksum"
> +
> +_require_command "$WIPEFS_PROG" wipefs
> +_require_scratch_dev_pool 4
> +_scratch_dev_pool_get 4
> +
> +fio_job_file=3D$tmp.fio
> +cat > $fio_job_file << EOF
> +[sync_randwrite]
> +directory=3D$SCRATCH_MNT
> +rw=3Drandwrite
> +filesize=3D512M
> +bs=3D4K
> +fdatasync=3D8

There's no need for fdatasync, a regular fsync would trigger the issue.
On btrfs fdatasync does the same as a regular fsync.

Anyway:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +time_based
> +fallocate=3Dposix
> +runtime=3D15
> +EOF
> +
> +_require_fio "$fio_job_file"
> +
> +# The target to remove for degraded mount.
> +dev2=3D"${SCRATCH_DEV_NAME[1]}"
> +
> +workload()
> +{
> +       local profile=3D$1
> +       _scratch_pool_mkfs "-m raid1 -d $profile" >> $seqres.full 2>&1
> +       $WIPEFS_PROG -fa "$dev2" >> $seqres.full 2>&1
> +       _scratch_mount -o degraded
> +
> +       # The fio job will do fsync after 8 4K writes, which is not enoug=
h to
> +       # fill a full stripe and always trigger RMW.
> +       # And the target file is preallocated, after some writes a full s=
tripe
> +       # can have blocks with csum and some blocks without csum.
> +       #
> +       # Unpatched kernels will try to verify the checksum even if there=
 is no
> +       # csum and fail the RMW, causing fio to fail.
> +       $FIO_PROG $fio_job_file >> $seqres.full 2>&1
> +       if [ $? -ne 0 ]; then
> +               echo "fio failed on degraded $profile"
> +       fi
> +       _scratch_unmount
> +}
> +
> +workload raid5
> +workload raid6
> +
> +_scratch_dev_pool_put
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/btrfs/357.out b/tests/btrfs/357.out
> new file mode 100644
> index 00000000..25875c6d
> --- /dev/null
> +++ b/tests/btrfs/357.out
> @@ -0,0 +1,2 @@
> +QA output created by 357
> +Silence is golden
> --
> 2.51.2
>
>
