Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3C72C0303
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 12:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783429051; cv=none; b=a3T/uQ4BsCZECH5/6tVfmWxz/rQ2/wm8XFnzy3+dwCF5hfgwFWsPbIuJpUgvmuiQFr8PEvYf+XnBY+/9ael10othdk8UbsD08E+OglQUONchBo01Wz33v9GkaeGbm9952jZoVby7iXTsedN8i6iXuW3kWsk1ty8xyZiVjA4JAX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783429051; c=relaxed/simple;
	bh=rwYo8UksAkUOnS7jdSuHBmF7RvT5rT9WII8zvJ9ZOcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CwEEMatjnmyAVAzPbSYZaHzJfTfrMlQ3euMlwF2YzHT3dcgisDlGpkhuhEkszvF5b1Gdv7AH9orOHUaoNRvCNj7g3YOIS3Lg8wcT382i0bogfTyT5BffrPaLR0aroYY02eVSUCrW+x0qBRB5aq7ohOACVi3q77r24EQFXJMgnG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IaSyfAVN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IaSyfAVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141731F000E9
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 12:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783429050;
	bh=gdTJH1ViqmD9A46o3b2Qf/GPeJ0L3oIWC1rvpkkUz/A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IaSyfAVNhD8B8uuUUGYPzzllWGAOsBLVpC/kNCJwESYgzCxw6Gl7IN6WO8+PTTTiU
	 aajR4TyDQ+IWBv4fAFEJYzCUgky3Of8izLNc8U9HaQI0NiFDv3b0aEHU0IxgnBiZbM
	 PSNnK7F5jCx5LkyAEvy/zXPautpS2eHghuMawPrJi8801uVaNzrP4hvIzpwHhh9net
	 JoihPHjbGfcqcqTNZ36vmJVuzAxAb+8QFENlLmsXpnhEr6hnsIA7GeYABsrUHw9J9Y
	 OkBLq1slQz6xlYRSiXdYL0CE7JoOkAqepvx/cMdx9UwInUI5VHN3FfT9fMglljS1g4
	 w4Sz4Uyaq1/DQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c125c082ee2so402202966b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2026 05:57:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/J1Write78juZMqHfkM0yTfv+6a6jPPZ0naiStLAnNk0OJ/DPiWF9aJU+PO702dRmMH0h3FTR7qTQDBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0dl9wCNgV5CJa27btLS3xN14+BTNca0SAUkzmlFJzTCVwHumq
	mgqYSjQNMn+ffHdXhTwIGo24VBjZohcpYwsZprZ1WzZx0EvUnkxpzpmJ2212E+nfZ3wT5jPcHdq
	2iTenRo5g9fwZgj21CbH4uOsnfuWfp7k=
X-Received: by 2002:a17:906:e5a:b0:c08:417e:3696 with SMTP id
 a640c23a62f3a-c15a66ede78mr201782666b.20.1783429048678; Tue, 07 Jul 2026
 05:57:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707113454.120001-1-wqu@suse.com>
In-Reply-To: <20260707113454.120001-1-wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 7 Jul 2026 13:56:51 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5zxHQ5rKT8ZW==8eCVezDu9Fb0=O36ujWMO-kP2FwgNg@mail.gmail.com>
X-Gm-Features: AVVi8Cc-fmKuQaGfCV_adHnn7RyRu_fOS-6M0gl0KCWnzOqF-u3L11qQhpCq7mQ
Message-ID: <CAL3q7H5zxHQ5rKT8ZW==8eCVezDu9Fb0=O36ujWMO-kP2FwgNg@mail.gmail.com>
Subject: Re: [PATCH v2] fstests: generic: add a basic cachestat test case
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Anand Jain <asj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 7, 2026 at 12:42=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> The test case is inspired by LTP, where there is a regression on 64K
> page size systems with btrfs, that after a fsync, cachestat() still
> report dirty pages.
>
> The test case itself is pretty simple, fill the file with a buffered writ=
e that is
> 1/2/4/8/16 page sized, call cachestat() to make sure the cached/dirtied
> number match the page number.
>
> Then do a fsync(), and make sure the dirty page number reduced to 0
> meanwhile cached is still the same.
>
> Link: https://bugzilla.suse.com/show_bug.cgi?id=3D1270397
> Reviewed-by: Anand Jain <asj@kernel.org>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
> Changelog:
> v2:
> - Reject "sync" and "dax" mount options
>   Those mount options write back data synchronously, will screw up the
>   buffered write dirtied page reporting.
>
> - Use AWK_PROG everywhere.
>
> - Remove the unnecessary redirection for fsync
> ---
>  tests/generic/798     | 61 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/798.out |  2 ++
>  2 files changed, 63 insertions(+)
>  create mode 100755 tests/generic/798
>  create mode 100644 tests/generic/798.out
>
> diff --git a/tests/generic/798 b/tests/generic/798
> new file mode 100755
> index 00000000..8888f6a3
> --- /dev/null
> +++ b/tests/generic/798
> @@ -0,0 +1,61 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 798
> +#
> +# Basic tests for cachestat()
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +_require_xfs_io_command "cachestat"
> +_require_scratch
> +# Any mount option that writes data back synchronously should be rejecte=
d.
> +# Or it will screw up the dirtied page reporting for buffered writes.
> +_exclude_scratch_mount_option "dax"
> +_exclude_scratch_mount_option "sync"
> +
> +pagesize=3D$(_get_page_size)
> +
> +for num_page in 1 2 4 8 16; do
> +       size=3D$(($pagesize * $num_page))
> +
> +       echo "=3D=3D=3D Test with $num_page pages =3D=3D=3D" >> $seqres.f=
ull
> +       _scratch_mkfs > /dev/null
> +       _scratch_mount
> +
> +       # Basic cached number reporting
> +       $XFS_IO_PROG -f -c "pwrite -b $pagesize 0 $size" \
> +               $SCRATCH_MNT/foobar >> $seqres.full
> +       $XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.ou=
tput
> +       cat $tmp.output >> $seqres.full
> +       cached=3D$(cat $tmp.output | cut -f1 -d, | $AWK_PROG '{print $2}'=
)
> +       dirtied=3D$(cat $tmp.output | cut -f2 -d, | $AWK_PROG '{print $2}=
')
> +
> +       if [ "$cached" -ne "$num_page" ]; then
> +               _fail "cached not matching the page number"
> +       fi
> +
> +       if [ "$cached" -ne "$dirtied" ]; then
> +               _fail "dirtied not matching the page number"
> +       fi
> +       $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar
> +
> +       # Test dirty page number reporting after a fsync.
> +       $XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.ou=
tput
> +       cat $tmp.output >> $seqres.full
> +       _scratch_unmount
> +       cached=3D$(cat $tmp.output | cut -f1 -d, | $AWK_PROG '{print $2}'=
)
> +       dirtied=3D$(cat $tmp.output | cut -f2 -d, | $AWK_PROG '{print $2}=
')
> +
> +       if [ "$cached" -ne "$num_page" ]; then
> +               _fail "cached not matching the page number"
> +       fi
> +       if [ "$dirtied" -ne 0 ]; then
> +               _fail "dirtied pages not zero"
> +       fi
> +done
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/generic/798.out b/tests/generic/798.out
> new file mode 100644
> index 00000000..216d6e93
> --- /dev/null
> +++ b/tests/generic/798.out
> @@ -0,0 +1,2 @@
> +QA output created by 798
> +Silence is golden
> --
> 2.51.2
>
>
