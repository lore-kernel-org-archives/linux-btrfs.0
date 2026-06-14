Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6811C84D0
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Jun 2026 10:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781434700; cv=none; b=IIyAnbAVfvvbh0T5nFzKZyAoKyIzrqC66mYaiQvb6lO3YsyBtWygpPrwJbkzDfdFEgDBzhtyMvkLRmYprZcTIzRJI/nFqx+OPvTSVsimQN0Cl4OdDldbg4QPVQvVDjDPJsgAYAw53F1XlU4uOAdPEiBkcvIGKhdMisExEFr6c14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781434700; c=relaxed/simple;
	bh=9RuJ3aW+baz3lM1s7JjFLEeEtehRP1Q39jDwz9C5X6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SA3mH01lRpDfkaUkVkj6mgvSiQJV1rpdnuJYv/sMllcub0c1RjxZQi9+DCD3SUG3h88m6R/8e9ccCn4SsD8gtXF4FTO6ut9h/T4b/47GBSzEr5nuW+gDdAv3BHHWpGnqDlHdFXSU0Bjt33d+01y5N/yfkItK2axVjpBr+iLoors=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/vgrMKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/vgrMKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A8B1F000E9
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Jun 2026 10:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781434698;
	bh=3qmyst4ntC9A7xlTKZ12oZe9Hlbh/N7A2sfKRP0KYkY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=J/vgrMKKIaSqFVJnSnHHMgsv3DhzxaXxCeerWYxarLLENfcUODNm3OEc/G+B2X2BJ
	 AGGQIWPkG2DrF4havmxOO8oSGbivWyvROmoZaLzQjGc/zaljUMHmE4hp7GAnPz4ye9
	 Qyxn+JYv4cHhFfIEFXp3Y9wcH8IQhkt9ltzjDr/5U2qRUa0BepLeu45ZOjsc6vao+M
	 eF5pU9pTWReFsvkiMatpjdHVhPMbC4KrtfEraGpg9jOVOQYa6/8MpzK+6g6jSLXa5E
	 HJ+qdC/3pGuecT0GZIjwo+y/YfQIJ+qbw6ZimpnTHvZPWUzifAmoZHtNTt/wByAfVV
	 iPHPELFDuyNsA==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-becfa735b9aso296697566b.1
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jun 2026 03:58:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YxzRAKuSMu4ZjeZOdnBySkvlF+PPjyFb4fBcgFBoFR94WorlzI+
	t4u/ejx9NFrDdERTT0MXpqUSd5RZ8I05Hl8Re1v1Fls0E5+M3sidwRNsN01IS7muCTivt/xgcoA
	8nVHTB8ossH51SuQunlvru/JZNST1mFw=
X-Received: by 2002:a17:906:8a75:b0:beb:2de3:1bac with SMTP id
 a640c23a62f3a-bff4720dc59mr196242766b.0.1781434697306; Sun, 14 Jun 2026
 03:58:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4b84813ed94332ccf8bb46848ed91f699d75794a.1779964012.git.fdmanana@suse.com>
In-Reply-To: <4b84813ed94332ccf8bb46848ed91f699d75794a.1779964012.git.fdmanana@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Sun, 14 Jun 2026 11:57:39 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7hCDQJxk1an8mk7030fb=qVdCeHaqza=H4DbCvWxtvrQ@mail.gmail.com>
X-Gm-Features: AVVi8CcrVkzGW1Liql7s_ICKuSYCq4y6ROAX0VkYgUWC9womcAyinlerC-Idpyo
Message-ID: <CAL3q7H7hCDQJxk1an8mk7030fb=qVdCeHaqza=H4DbCvWxtvrQ@mail.gmail.com>
Subject: Re: [PATCH] generic: add a test case for writes with prealloc extents
 beyond i_size
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, 
	Zorro Lang <zlang@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2026 at 11:27=E2=80=AFAM <fdmanana@kernel.org> wrote:
>
> From: Filipe Manana <fdmanana@suse.com>
>
> Test writing into a file range containing prealloc extents beyond the cur=
rent
> i_size, with an unmount and mount after fallocate and the write, to verif=
y
> that the file data, size and extent layout were not lost.
>
> This used to fail on btrfs when not using the no-holes feature (which is
> a default since btrfs-progs 5.15) before this recent kernel fix:
>
>    080ecbd05432 ("btrfs: mark file extent range dirty after converting pr=
ealloc extents")
>
> So in order to reproduce the failure when using an unpatched kernel and
> a btrfs-progs >=3D 5.15, one must run the test with:
>
>    MKFS_OPTIONS=3D"-O ^no-holes"
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Zorro, this is missing in the patches-in-queue branch (and for-next).
Did you miss this?

Thanks.

> ---
>  tests/generic/796     | 54 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/796.out | 10 ++++++++
>  2 files changed, 64 insertions(+)
>  create mode 100755 tests/generic/796
>  create mode 100644 tests/generic/796.out
>
> diff --git a/tests/generic/796 b/tests/generic/796
> new file mode 100755
> index 00000000..c42a4722
> --- /dev/null
> +++ b/tests/generic/796
> @@ -0,0 +1,54 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 796
> +#
> +# Test writing into a file range containing prealloc extents beyond the =
current
> +# i_size, with an unmount and mount after fallocate and the write, to ve=
rify
> +# that the file data, size and extent layout were not lost.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick prealloc preallocrw fiemap
> +
> +. ./common/filter
> +. ./common/punch # for _filter_fiemap
> +
> +_require_scratch
> +_require_xfs_io_command "falloc" "-k"
> +_require_xfs_io_command "fiemap"
> +
> +_fixed_by_fs_commit btrfs 080ecbd05432 \
> +       "btrfs: mark file extent range dirty after converting prealloc ex=
tents"
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +# The fiemap results in the golden output requires file allocations to a=
lign to
> +# 1M boundaries.
> +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> +
> +# Create our file with a size of 0 and a prealloc extent in the range [0=
, 2M].
> +$XFS_IO_PROG -f -c "falloc -k 0 2M" $SCRATCH_MNT/foo
> +
> +# Unmount and mount again to remove any in memory state of the inode. We=
 will
> +# verify later that neither metadata nor extents were lost during unmoun=
t.
> +_scratch_cycle_mount
> +
> +# Write into the [0, 1M] range, which increases the inode's i_size.
> +$XFS_IO_PROG -c "pwrite -S 0xab -b 1M 0 1M" $SCRATCH_MNT/foo | _filter_x=
fs_io
> +
> +# Unmount and mount again to remove any in memory state of the inode. We=
 will
> +# verify later that neither metadata nor extents were lost during unmoun=
t.
> +_scratch_cycle_mount
> +
> +# Check file data (and size).
> +echo "File data:"
> +_hexdump $SCRATCH_MNT/foo
> +
> +# Check we have unwritten extents in range [1M, 2M].
> +echo "Fiemap output:"
> +$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foo | _filter_fiemap
> +
> +# Success, all done.
> +_exit 0
> diff --git a/tests/generic/796.out b/tests/generic/796.out
> new file mode 100644
> index 00000000..c6c6e6a8
> --- /dev/null
> +++ b/tests/generic/796.out
> @@ -0,0 +1,10 @@
> +QA output created by 796
> +wrote 1048576/1048576 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +File data:
> +000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab  >...............=
.<
> +*
> +100000
> +Fiemap output:
> +0: [0..2047]: data
> +1: [2048..4095]: unwritten
> --
> 2.47.2
>
>
