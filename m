Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B8B175A85
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790960578; cv=none; b=uTwiQj29QNU+jR9rW5FYbLKl4BSkKoq/76xfigDReu0XKCJ8JLPfBLJF0p5cK1acnqBvb4lcX4NPMEVFuWlnLBtnRwwPkdObSBfMnvDeiTvQJrIGmN+iBCliASZ+KpPakGhtDCXuskb5Dcwwkiv2q3RxBNIDYCbE/+7kAWd+rvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790960578; c=relaxed/simple;
	bh=SeuODVxii6BGg/LzYo10gyrYWLsIETEwxlp35cr5+LY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dyOF/gXTUTKEA3/jX5XvZHGx09jI5o5XkRe3yxK+1n3EWxFD9+BZZJzbm/8GcksCWH6h2BNx7MaAuXWxYRK0j7jlueRVTu/YgCmpiTljvdWpew3XaUcK69DZYxiB1AYSQ8BI/8+NUPZP9wxsweUvceKRzoeMfZHRTTtPmLTJWas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jyTC6X/z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jyTC6X/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5706C1F00898
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790960576;
	bh=MzSaG+p+mr4UutLyn465t4zOL2I7kXVooV9kImmieu8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jyTC6X/z72Btnncc1sQ+dF8VAmB9zEYMlRku+GHv59uRsa87ptmxdul9wrhyxIRvy
	 P478tDxStieBQ5VQQD26SpW8kDQCLFhbfgw6dqAEa9RrP4rifYVxpAJRhgCPAR+OH5
	 v7RPNrKBVYBWkkz9YKphIP9OJgBr8B+MXg83RTn9bDCv8bnDGZ0jrSg3ajTWTu4PfW
	 qtOY4/H9b8uESWaXo8q8J2ytV7mtU3KwH9v4fpYJxG0R0+XM55mK1YolMnXgWEkVmk
	 cOsjAjsuhqPH50QyRlAETPl3d62F0DALuN7fQ/gUUGJQCUOzMkx49wNyYVfSOzjcwj
	 FFQ9ilyzNOfSw==
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7bac8c70e78so565060137.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2026 10:02:56 -0700 (PDT)
X-Gm-Message-State: AFq9FYI2SxI5kPDLec/EFPy/4Vi6oEVqrb/+ZCw060kW0bpR6bgEJhbR
	DL29BuLBnxTvDOT4zZRB7TVvw48WncFU6CAw8DI6ldreDEY03tI2xz55IfabeRD5AV2DM8OyqR2
	6Ib7vjnqaRflIqQt14KOwXG2Ja2sddGA=
X-Received: by 2002:a05:6102:3c95:b0:7b9:fbff:6f9b with SMTP id
 ada2fe7eead31-7c245ce69e1mr23508137.28.1790960575533; Fri, 02 Oct 2026
 10:02:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261002115959.7011-1-wqu@suse.com>
In-Reply-To: <20261002115959.7011-1-wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 2 Oct 2026 18:02:18 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4Vnn_-5=KiqC=hoPmF+O-vwQVPC8QW9HSW8wXELUB11g@mail.gmail.com>
X-Gm-Features: AclHuK-2s7fRfztsnH_6-8R0yhmrAmki1_p3F-XWSaYiHAMan8RR_2LgGxV4Aig
Message-ID: <CAL3q7H4Vnn_-5=KiqC=hoPmF+O-vwQVPC8QW9HSW8wXELUB11g@mail.gmail.com>
Subject: Re: [PATCH] fstests: btrfs: add a test case for deleting partially
 owned qgroup
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 2, 2026 at 1:06=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> There is a bug report that, when deleting a partially owned qgroup,
> btrfs will delete the on-disk items but leave the in-memory rb-tree and
> sysfs entries untouched.
>
> Introduce a regression test for it, verifying the behavior by:
>
> - Create a btrfs with a specific qgroup layout
>
>               2/1
>                |
>               1/1
>                |
>    0/subv1  0/snap1
>
>    All involved qgroups will have "1M + nodesize" as reference number,
>    and "nodesize" as exclusive number.
>
>    For the remaining example I'll use 16K as nodesize.
>
> - Remove the qgroup relationship between 0/snap1 and 1/1
>   This will mark qgroup inconsistent, but leave the old numbers.
>
>               2/1 (rfer: 1M+16K, excl: 16K)
>                |
>               1/1 (rfer: 1M+16K, excl: 16K)
>
> - Remove qgroup 1/1
>   Which will automatically remove the relationship between 1/1 and 2/1.
>
>   And since qgroup 1/1 is not fully owned (rfer > excl), this will mark
>   qgroup inconsistent and return 1.
>
>   For unpatched kernels, that positive return value is treated as an
>   error, causing on-disk metadata items removed but still leave
>   the rb-tree and sysfs entries untouched.
>
> - Check if /sys/fs/btrfs/<fsid>/qgroups/1_1/ still exists
>   If exists, the kernel is not yet patched.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/btrfs/358     | 79 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/358.out |  2 ++
>  2 files changed, 81 insertions(+)
>  create mode 100755 tests/btrfs/358
>  create mode 100644 tests/btrfs/358.out
>
> diff --git a/tests/btrfs/358 b/tests/btrfs/358
> new file mode 100755
> index 00000000..642b0808
> --- /dev/null
> +++ b/tests/btrfs/358
> @@ -0,0 +1,79 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 358
> +#
> +# Verify that when deleting a partially owned qgroup (excl !=3D rfer),
> +# the sysfs and in-memory rb-tree entries are also properly removed.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick qgroup
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +       "btrfs: qgroup: do not treat \"ret > 0\" as error when deleting a=
 qgroup"
> +
> +_require_btrfs_sysfs_fsid
> +_require_btrfs_command qgroup remove --no-rescan
> +_require_scratch
> +_require_btrfs_qgroup_report
> +
> +# This implies making a btrfs and enables full qgroup mode.
> +_require_scratch_qgroup
> +_scratch_mount
> +
> +fsid=3D$(_btrfs_get_fsid "$SCRATCH_MNT")
> +
> +# We require /sys/fs/btrfs/<fsid>/qgroups/ directory
> +if [ ! -d "/sys/fs/btrfs/$fsid/qgroups/0_5" ]; then
> +       _scratch_unmount

We shouldn't need to unmount explicitly, the fstests framework should do th=
at.

> +       _notrun "No sysfs qgroups directory"
> +fi
> +
> +_btrfs subvolume create "$SCRATCH_MNT/subv1"
> +_pwrite_byte 0x00 0 1M "$SCRATCH_MNT/subv1/data1" &> /dev/null

We should redirect only stdout so that if an error occurs, we
immediately know the test failed because the write failed, not for
another reason.

Anyway:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +_btrfs subvolume snapshot "$SCRATCH_MNT/subv1" "$SCRATCH_MNT/snap1"
> +snap1id=3D$(_btrfs_get_subvolid $SCRATCH_MNT snap1)
> +
> +# Create the following qgroup layout and rescan.
> +#                    2/1
> +#                     |
> +#                    1/1
> +#                     |
> +#  0/subv1           0/snap1
> +#
> +# Since snap1 is a snapshot of subv1, both will have 1M shared data
> +# plus nodesize as exclusive metadata.
> +# This means neither of them is fully exclusive (rfer > excl).
> +_btrfs qgroup create 1/1 "$SCRATCH_MNT"
> +_btrfs qgroup create 2/1 "$SCRATCH_MNT"
> +_btrfs qgroup assign 1/1 2/1 "$SCRATCH_MNT"
> +_btrfs qgroup assign 0/$snap1id 1/1 "$SCRATCH_MNT"
> +
> +# Do a rescan, as the above assign will mark the qgroup inconsistent.
> +_btrfs quota rescan -w "$SCRATCH_MNT"
> +
> +# Now remove the qgroup relationship between 0/snap1 and 1/1
> +# This will mark qgroup inconsistent but we do not want to trigger a res=
can
> +# automatically.
> +# This will leave the old numbers (rfer > excl) for 1/1.
> +_btrfs qgroup remove --no-rescan "0/$snap1id" 1/1 "$SCRATCH_MNT"
> +
> +# Now delete qgroup 1/1, which will automatically remove the relationshi=
p
> +# between 1/1 and 2/1.
> +# Since qgroup 1/1 still has stale values where rfer doesn't match excl,
> +# the kernel marks the qgroups inconsistent and returns 1 to indicate a
> +# rescan is needed.
> +_btrfs qgroup destroy 1/1 "$SCRATCH_MNT"
> +
> +# For unpatched kernels, that positive return value is treated as an err=
or,
> +# causing btrfs to delete on-disk items for qgroup 1/1, but leaving the
> +# in-memory rb-tree and sysfs entries untouched.
> +# Check if the sysfs qgroup directory still has a directory for qgroup 1=
/1.
> +if [ -d "/sys/fs/btrfs/$fsid/qgroups/1_1" ]; then
> +       echo "Qgroup 1/1 still exists in sysfs qgroups directory"
> +fi
> +
> +echo "Silence is golden"
> +_scratch_unmount
> +_exit 0
> diff --git a/tests/btrfs/358.out b/tests/btrfs/358.out
> new file mode 100644
> index 00000000..8bcf2699
> --- /dev/null
> +++ b/tests/btrfs/358.out
> @@ -0,0 +1,2 @@
> +QA output created by 358
> +Silence is golden
> --
> 2.51.2
>
>
