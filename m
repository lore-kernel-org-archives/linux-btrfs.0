Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB943F7873
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 11:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783423098; cv=none; b=hcvqddPF6gKZ08Ae830qP7KMdufoKyC29JdE/OrYp9ZfV/qkYgut36QYviDl9IiFwn/ep8Y6SPM+wutrGN54SE2MZHC2wpeuF37X4NyiC7AFsjL0dvIM1QwIzFRuJm/Jwn1J2lwEy2zV3rHM6Rj8apV6DVefQtWBayGaoj4mNd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783423098; c=relaxed/simple;
	bh=1JGzI55ucxt67EibmbfV65jnonsLKezSijN7FNwUQpY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fJmZzraPVsn9ksDfUlbVuT0JLN1KzghxmxKCsM6IlfUczxG4W7hSVOh+KfThdoZmQti5InAzIZ8W4l+bfBbzZC6yE47BoT3RUU2/i96FXyu8Dl58JNA98uvRgVoxXcShnCUHaJo/a4TbWyCUnXpU8KPO4iN7mzdOaTol5D01sFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgdWlyhW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgdWlyhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500BB1F00A3D
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 11:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783423097;
	bh=jy7ezTspCIw3pJ9UrimstwZTAZPJ1WzNBwosqkTwSyM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mgdWlyhWLmizHda9jkDc9rUu1oZh1yFb2nTaguo/IBaZZ4UYPoNCNeUPTWZZE5JwX
	 8ASQBhDb870GSm5WtkrF1WPaq5ftNo+N5bFhCxBG4K6z5iL8FcqzpmgBVN+whbchbk
	 6KxawQi9QYTqzVXr369/v7YbS0OOG12TX+mVkg0GDSbt1MzWdF2hfSr5d/5BQiyt7k
	 oK1inmOSOPG0+hCyvNtksky1PJIiU91OmT+pr9GOUytxcFKigT83lMD77fWYTq8ruy
	 Afq6wxlh+JBuFjhd7bByboVfmemgYH2Pb0kBlvpZt5NR/oKt7EEnugadnKQ1nezZVf
	 S6et0nmi9MxNA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c12a1a3cdb9so402742466b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2026 04:18:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/iyeAdUW09Km1yN/UWmU3wrMgPgwBtrhWf4yjCzVWBduCiws0y3ZqhXj+5wW3XC7oFIVuDaI8Z0usLaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAoFV6UV2Ozx100M9VQW/TY/ON8zBwqdRHxuapa9rqo/T3tRdt
	EW2XEtNS6+dH7Ewu8yJXQoERGrlNhfD6eRlHDs7Y5BjPAPuT2ZW0Q3yBTWA5+APphhsWRwaxtLU
	TkTJ/rso7n/rD5Mzj3AQIKzN0JSgfSu0=
X-Received: by 2002:a17:906:7f81:b0:c12:4f19:fad5 with SMTP id
 a640c23a62f3a-c15a691b8admr168503166b.59.1783423095872; Tue, 07 Jul 2026
 04:18:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707001807.31931-1-wqu@suse.com>
In-Reply-To: <20260707001807.31931-1-wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 7 Jul 2026 12:17:38 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4FtJAQ88VfgWsh11DGV1V7gFN1cAvfqoLxTEmg+d2FJg@mail.gmail.com>
X-Gm-Features: AVVi8CcTOXuCH8t-wpDsnrYcnThjQpXRB7eCH2lA45s1dpuvEa_cU-FiTZia7Yk
Message-ID: <CAL3q7H4FtJAQ88VfgWsh11DGV1V7gFN1cAvfqoLxTEmg+d2FJg@mail.gmail.com>
Subject: Re: [PATCH] fstests: generic: add a basic cachestat test case
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 7, 2026 at 1:20=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
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
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/generic/798     | 57 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/798.out |  2 ++
>  2 files changed, 59 insertions(+)
>  create mode 100755 tests/generic/798
>  create mode 100644 tests/generic/798.out
>
> diff --git a/tests/generic/798 b/tests/generic/798
> new file mode 100755
> index 00000000..4328475e
> --- /dev/null
> +++ b/tests/generic/798
> @@ -0,0 +1,57 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 798
> +#
> +# Basic tests for cachestate()
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +_require_xfs_io_command "cachestat"
> +_require_scratch
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
> +       cached=3D$(cat $tmp.output | cut -f1 -d, | awk '{print $2}')

Use $AWK_PROG everywhere.

> +       dirtied=3D$(cat $tmp.output | cut -f2 -d, | awk '{print $2}')
> +
> +       if [ "$cached" -ne "$num_page" ]; then
> +               _fail "cached not matching the page number"
> +       fi
> +
> +       if [ "$cached" -ne "$dirtied" ]; then
> +               _fail "dirited not matching the page number"
> +       fi
> +       $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar >> $seqres.full

The redirection isn't needed; on success the fsync command sends
nothing to stdout.

Thanks.

> +
> +       # Test dirty page number reporting after a fsync.
> +       $XFS_IO_PROG -c "cachestat 0 $size" $SCRATCH_MNT/foobar > $tmp.ou=
tput
> +       cat $tmp.output >> $seqres.full
> +       _scratch_unmount
> +       cached=3D$(cat $tmp.output | cut -f1 -d, | awk '{print $2}')
> +       dirtied=3D$(cat $tmp.output | cut -f2 -d, | awk '{print $2}')
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
