Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4A236EA8D
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 07:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412157; cv=none; b=KKBYoiGCtdtGPQkAxaZN5jKcYLqpe8GWhsxQ7YbVOs5ki+fk8u+iV5b8fzBg2Vaqc9vHV1cyIlkE1GXllEHsYJOJuWABYklr9cKS54qD5RTxVxO4oqHWKFIk7DzGmijQ4HnvKQuqTRYPB+vvdrtVB73eKt/Mmucq8CGMkZ5Yb0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412157; c=relaxed/simple;
	bh=IDQHJDvwgJujgFPu8RgNv48pLfvY7uMuxR9l9eObccw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T38vGWHtSq7fLdPSKlr6KQjnTdXWDM+9ytoVRA/2aMMrc8xtv85ZTMAAy8C2iW8H56fvXgp/VjgHGxytIkf6YdOVgcFA1yOKvte1Qob2vB1Xdx9WHcn0Tu90sSTXAfIG+X/9BgbwBOaegpOWBPfF+jDUquHDYjMscqFF6dBFdGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lWiGKeqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lWiGKeqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3266C2BCB6
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 07:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776412156;
	bh=IDQHJDvwgJujgFPu8RgNv48pLfvY7uMuxR9l9eObccw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lWiGKeqYCMuDljwwhlTgSu/Us6W8kzpWOKiEQd2/nNyNZOebLLfwD82t5p7e5XNA2
	 NIEW4A/G7u7oDReYriOs1PLNwS/eiuohnPEAhToJW6OB5Fe/bc6U98RoaJM4JrxBp/
	 Daii9/BM5PUufmJRxFHZ2tPbX/msYGIHID3RMvHfFti0RPDsdTIB1JX8l0Ctf3fQak
	 +0KHXEY0uItlSC2RepLxpOg3mK3J65/p9/+Alqnj4wNLRwAw8/SCeH6ULcN+MVAqgp
	 oEfUPYh5tZd2Q8QxdpO5Ij2spK9l2vbOSp5BqgAMi0g4heP3ixC8XT7gaufPcXSzMx
	 MqcVPYwe8wYAQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b9910707d82so61426766b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 00:49:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ80Qn1CwWqNEH3m4vbGQg/Iv1F4nQTYw+B0fx4o83TiW8KGvF7iT7moV1LFemATZgUDMsKsGf13u82E/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxRjqLS3ORbXmICvAOaSWs1v0TTXOsJ0/ps+ISITuDG6MzOPPsb
	llmix6TxFAoK+egIbpKISJP8zRsZyBtozU0BiegGTvYuU55QRSimD+7akhcFfnkZ8lmyFwiN3uN
	B8MewJ209IUThPoYxBPCxTkMuqDml1SE=
X-Received: by 2002:a17:907:9622:b0:b96:996c:8605 with SMTP id
 a640c23a62f3a-ba41aa16456mr84136266b.23.1776412155221; Fri, 17 Apr 2026
 00:49:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417070737.1318926-1-tchou@synology.com>
In-Reply-To: <20260417070737.1318926-1-tchou@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 17 Apr 2026 08:48:37 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7CmQahCU9enFrM4bhTLmdEYrWn0EhXKBUxriMcKdJR0A@mail.gmail.com>
X-Gm-Features: AQROBzAzMPwuyhVwc_EKpSfZZBaTswEikwiQJ_xZBb1j3w0bKeJ55g3aU2uOH68
Message-ID: <CAL3q7H7CmQahCU9enFrM4bhTLmdEYrWn0EhXKBUxriMcKdJR0A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: regression test for duplicated rmdir in
 incremental send with extrefs
To: tchou <tchou@synology.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 8:08=E2=80=AFAM tchou <tchou@synology.com> wrote:
>
> From: Ting-Chang Hou <tchou@synology.com>
>
> Regression test for btrfs incremental send issue where duplicated rmdir
> instructions were sent when using INODE_EXTREF. This happens when there
> are many hardlinks to the same file across two directories, causing the
> INODE_EXTREF items to interleave between directories.
>
> This issue is fixed by the following linux kernel btrfs patch:
>
> commit 1fabe43b4e1a ("btrfs: send: fix duplicated rmdir operations when u=
sing extrefs")
>
> Signed-off-by: Ting-Chang Hou <tchou@synology.com>
> ---
>  tests/btrfs/348     | 99 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/348.out |  1 +
>  2 files changed, 100 insertions(+)
>  create mode 100755 tests/btrfs/348
>  create mode 100644 tests/btrfs/348.out
>
> diff --git a/tests/btrfs/348 b/tests/btrfs/348
> new file mode 100755
> index 00000000..6e887e77
> --- /dev/null
> +++ b/tests/btrfs/348
> @@ -0,0 +1,99 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Synology Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. btrfs/348
> +#
> +# Regression test for btrfs incremental send issue where duplicated rmdi=
r
> +# instructions were sent when using INODE_EXTREF. This happens when ther=
e
> +# are many hardlinks to the same file across two directories, causing th=
e
> +# INODE_EXTREF items to interleave between directories. The original fix
> +# in commit 29d6d30f5c8a ("Btrfs: send, don't send rmdir for same target
> +# multiple times") only handled consecutive rmdir operations for the sam=
e
> +# directory, but failed when rmdir operations were not consecutive due t=
o
> +# the interleaved INODE_EXTREF ordering.
> +#
> +# This issue is fixed by the following linux kernel btrfs patch:
> +#
> +#   commit 1fabe43b4e1a ("btrfs: send: fix duplicated rmdir operations w=
hen using extrefs")

We already have a test case for this since October 2025: btrfs/338

Also in the future, please specify the commit like this:

_fixed_by_kernel_commit 1fabe43b4e1a \
        "btrfs: send: fix duplicated rmdir operations when using extrefs"

Thanks.

> +#
> +. ./common/preamble
> +_begin_fstest auto quick send
> +
> +tmp=3D`mktemp -d`
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +       rm -fr $tmp
> +}
> +
> +. ./common/filter
> +
> +_require_scratch
> +_require_fssum
> +
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +mkdir $SCRATCH_MNT/a $SCRATCH_MNT/b
> +
> +echo 123 > $SCRATCH_MNT/a/foo
> +
> +# Create enough hardlinks to trigger INODE_EXTREF usage.
> +# When hardlinks exceed what a single INODE_REF item can hold,
> +# INODE_EXTREF is used. The key of INODE_EXTREF includes a hash
> +# of the name and parent inode, causing items from different
> +# directories to interleave.
> +for ((i =3D 1; i <=3D 1000; i++)); do
> +       ln $SCRATCH_MNT/a/foo $SCRATCH_MNT/a/foo.$i
> +       ln $SCRATCH_MNT/a/foo $SCRATCH_MNT/b/foo.$i
> +done
> +
> +# Filesystem looks like:
> +#
> +# .                              (ino 256)
> +# |-- a/                         (ino 257)
> +# |   |-- foo                    (ino 259)
> +# |   |-- foo.1 ... foo.1000     (ino 259, hardlinks)
> +# |
> +# |-- b/                         (ino 258)
> +#     |-- foo.1 ... foo.1000     (ino 259, hardlinks)
> +
> +_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1
> +
> +rm -r $SCRATCH_MNT/a $SCRATCH_MNT/b
> +
> +# Filesystem now looks like:
> +#
> +# .                              (ino 256)
> +# |-- snap1/                     (read-only snapshot)
> +
> +_btrfs subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap2
> +
> +run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/snap1
> +run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/snap2/snap1 =
\
> +       $SCRATCH_MNT/snap2
> +
> +_btrfs send -f $tmp/1.snap $SCRATCH_MNT/snap1
> +_btrfs send -p $SCRATCH_MNT/snap1 -f $tmp/2.snap $SCRATCH_MNT/snap2
> +
> +_scratch_unmount
> +_check_btrfs_filesystem $SCRATCH_DEV
> +
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +_btrfs receive -f $tmp/1.snap $SCRATCH_MNT
> +run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/snap1
> +
> +# This used to fail with:
> +# ERROR: rmdir o<ino>-<gen>-0 failed: No such file or directory
> +_btrfs receive -f $tmp/2.snap $SCRATCH_MNT
> +run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/snap2
> +
> +_scratch_unmount
> +_check_btrfs_filesystem $SCRATCH_DEV
> +
> +status=3D0
> +exit
> diff --git a/tests/btrfs/348.out b/tests/btrfs/348.out
> new file mode 100644
> index 00000000..f5e0b75a
> --- /dev/null
> +++ b/tests/btrfs/348.out
> @@ -0,0 +1 @@
> +QA output created by 348
> --
> 2.34.1
>
>
> Disclaimer: The contents of this e-mail message and any attachments are c=
onfidential and are intended solely for addressee. The information may also=
 be legally privileged. This transmission is sent in trust, for the sole pu=
rpose of delivery to the intended recipient. If you have received this tran=
smission in error, any use, reproduction or dissemination of this transmiss=
ion is strictly prohibited. If you are not the intended recipient, please i=
mmediately notify the sender by reply e-mail or phone and delete this messa=
ge and its attachments, if any.
>
