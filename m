Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2255B3E8C5E
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776176674; cv=none; b=I7Skl45ABddn4NusvIx25MDxH0BqUN8DUDVKo4/GBTeTxKmRMLpnOSoMAK3YAj6JDI2/O3Vuc+BKJmcM4F/KhMZs10LGPAx9wj7vU+22KZGkeflkKkURhwDPbPcjUA5ArHc3y0N7fc2eyct3GPrhaA95dGCd2hDgG4cLYx6rANQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776176674; c=relaxed/simple;
	bh=Jv1EMQSP3azEaz/DpMGVKaea5Ai+TN1fi+5OpvOAOhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hxHIyYOkafYDqXuwodBCHLk0Ms6v1d4+kGfXMhQkAIh6z7IXtyCnNonmxPHVWl07GUWxVfOPL6ePdMsIpHFaLuwFlvYe9Iwf8wGLzuPjL5BM4Z9KDWzwYKhPSt39EYhv2sGZ969lbp//U6bWWphvN1qQ9a2/QLQkl1Xic7S3QHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmZS/gI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmZS/gI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072CBC2BCB7
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176674;
	bh=Jv1EMQSP3azEaz/DpMGVKaea5Ai+TN1fi+5OpvOAOhM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cmZS/gI8vQKT4d1pQgGJRuyKKGjwClmGMAM+F/1HPguYOIolzE+oF2IA008DVJJ2T
	 wR2iARZOgghUrbn6BfqbcsXscPQ7V+lDVR76Ghhqb7Vg0YUdvrH2/appcY8IU6Fqlw
	 mC4DH0Ka0ODgKhgdd+79puPiRhqI1KBwFMtETAKAcRJeoQSjWxRTTK0Mb6sC8Gymbl
	 geagxypWo8XT1NBvn/i9qpKRSmaGupoVVq84eEVxoeg/4Kf7Op8QDi1Vky0l3pIobL
	 XzFMhAGmZevYjUi7PBUeGBARECpkOTVnUYyVNINv04DFQRUZy6Skdlc4CjOXvzRGVw
	 aFCC+3zy9Ng/Q==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6634bb959a2so8081044a12.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 07:24:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/9B9hALFvSB7b9Vr5aTXzxvnkYmEvlEQ9f2H4JFDPuvZAkHCD52/oHu9T44mhHScTbXsaYorWRNQlTww==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuWYnUn3LFc2bhJ4Ear5aQb4s5IvWv8c7mBrpCXxiHpfHEyeON
	h1twyqQhXkYdjivnpIivW7VoNETfanOz0CKOzMOtJRpnblUheRZxbKIsxVGJpvSH2pNvgPMxRLy
	7NYz+wweaBX0LzSKvAby7VTvdykgL/fY=
X-Received: by 2002:a17:906:f5aa:b0:b9d:4301:be37 with SMTP id
 a640c23a62f3a-b9d72440275mr816075166b.5.1776176672519; Tue, 14 Apr 2026
 07:24:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260414134458.153318-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260414134458.153318-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 14 Apr 2026 15:23:53 +0100
X-Gmail-Original-Message-ID: <CAL3q7H42ddA_HtL9yuO4rWuLhtFht_UjUy3jDr+FgjOQQTcJ8A@mail.gmail.com>
X-Gm-Features: AQROBzBKHzTpYK2Ey8FazuyYeqWY57hBa93cxhquI7LgqUF4VyYXOeW0CTTiOL8
Message-ID: <CAL3q7H42ddA_HtL9yuO4rWuLhtFht_UjUy3jDr+FgjOQQTcJ8A@mail.gmail.com>
Subject: Re: [PATCH v2] fstests: test premature ENOSPC in zoned garbage collection
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 14, 2026 at 2:50=E2=80=AFPM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> This test stresses garbage collection in zoned file systems by
> constantly overwriting the same file. It is inspired by a reproducer for
> a btrfs bugifx.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes to v1:
> - Rebased onto patches-in-queue
> - Use "generic/999" to avoid any conflicts
> - Change the number of loops to number of seq zones
> - Remove bogus "2>&1"
>
> Link to v1:
> https://lore.kernel.org/all/20260210111103.265664-1-johannes.thumshirn@wd=
c.com/
>
>
>  tests/generic/999     | 48 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  2 ++
>  2 files changed, 50 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
>
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 000000000000..4ac6c0ff935c
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,48 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 999
> +#
> +# This test stresses garbage collection in zoned file systems by constan=
tly
> +# overwriting the same file. It is inspired by a reproducer for a btrfs =
bugifx.
> +
> +. ./common/preamble
> +_begin_fstest auto quick zone
> +
> +. ./common/filter
> +
> +_require_scratch_size $((16 * 1024 * 1024))
> +_require_zoned_device "$SCRATCH_DEV"
> +
> +# This test requires specific data space usage, skip if we have compress=
ion
> +# enabled.
> +_require_no_compress
> +
> +
> +_fixed_by_fs_commit XXXXXXXXXXXX \
> +       "btrfs: zoned: cap delayed refs metadata reservation to avoid ove=
rcommit"
> +_fixed_by_fs_commit XXXXXXXXXXXX \
> +       "btrfs: zoned: move partially zone_unusable block groups to recla=
im list"

Already in Linus' tree, commit hash 258e46a6385c.

> +_fixed_by_fs_commit XXXXXXXXXXXX \
> +       "btrfs: zoned: add zone reclaim flush state for DATA space_info"

Also in Linus' tree, commit hash e2a7fd22378f.

> +
> +
> +_scratch_mkfs_sized $((16 * 1024 * 1024 * 1024)) &>>$seqres.full
> +_scratch_mount
> +
> +blocks=3D"$(df -TB 1G $SCRATCH_DEV |\
> +       $AWK_PROG -v fstyp=3D"$FSTYP" 'match($2, fstyp) {print $3}')"
> +
> +loops=3D$(echo "$blocks * 4 - 2" | bc)

nit: why pipe to bc? Wouldn't a simple bash expression like the following w=
ork?

loops=3D$(( blocks * 4 - 2 ))

Otherwise it looks fine to me, thanks.

> +
> +for (( i =3D 0; i < $loops; i++)); do
> +       dd if=3D/dev/zero of=3D$SCRATCH_MNT/test bs=3D1M count=3D1024 sta=
tus=3Dnone
> +       if [ $? -ne 0 ]; then
> +               _fail "Failed writing on iteration $i"
> +       fi
> +done
> +
> +echo "Silence is golden"
> +# success, all done
> +_exit 0
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 000000000000..3b276ca804fc
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden
> --
> 2.53.0
>
>
