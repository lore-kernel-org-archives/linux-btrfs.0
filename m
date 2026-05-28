Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3853B7763
	for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 11:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779967879; cv=none; b=iHkJuGdrYAUtEppGtG1/CI8K2mEbQoLgo36zJHsMNyas5zAKRlL1iSPmEzK4s6DB/PnZfh23ACVJward1OHLr6Pc7H6V7aFTJNCZhr58nCJsm96kuD9zu+4JLXUu+RH1yOzTuSSEXxMa6/gXFuU/zUoVACuShKZf9+krB18Pf8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779967879; c=relaxed/simple;
	bh=lXRwUibaixZ04dknzbmpynJGxvM8Ng09hjadvQ3OcE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MVkbD43qYEIaHxGQD7eLQ+4TIFy4RFqfpIkMSVb266108O0pp1ctB+F+q+64bgPE97h+rx0k6ttv/Xzofq5Vj4WA/HqfB5IICnCb6yNSSRBIueT79tEloMmeSwdJh0Qslhdqm1l2iTcmTkZzVz+vJM5gkmoI5QiC3xaMpdNKas0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9tXhk/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9tXhk/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558791F00A3A
	for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 11:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779967878;
	bh=Efks/I89hcEG86IYjQdkKm7jS2iXGDq3+U6eCfpK8eg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A9tXhk/6zRzAzZ3ZlYPI6NfH7r/tLEjyA6DIh5g0fee70LayAE9redwtk8MXRLKpd
	 iZzII7MCTq2H9i80YZfEfhtz14rUE6A7If9bWjoTsX8tb8oUHfvKuQ87ekfJohOHST
	 CQJ44syXAMsxPrbDksPAUT6KO5lNd+sqixhnpTDF64VCrwU7DeqR/+g7w5Dnzal1bA
	 ZpruWSF32pkV/cUdtjt+j11zhrHOwKm9qYk3pHjv8jC4Zq7TFXp3CqjHLVDaZ0wnbY
	 dTuPv9ZCNTnjdS/iz8p6ohJDuOPVgGkG2KwrBBdAaBbH7nGYg2bIngCb7PIKA7tJrU
	 EesGnZ33GtOtw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-be4344dde59so206311566b.3
        for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 04:31:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8YhgdaGifcol7fvjvIa6Mf1qfkQkgOYRShqHOzJx7OKCtUG0KGNcQKbU8RsF/B5u+8UBnErImoKLtzZw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxAXh4WCkMWD8TklDPDiKa2nv4bW3i+XjqSvIK/Ek2iTSbQRq7w
	Row92Mt+02jkF0s3SijOoZNfPuTaBts1hBH1pM+iiFy3p67RqjaNwEG/qryrrk3GU9T2hcmY540
	T77KJMrBF3Vn+dvzrJ7KQnbpjd7JOEzA=
X-Received: by 2002:a17:907:266d:b0:bd9:23c:8ca9 with SMTP id
 a640c23a62f3a-bdd25ce18d4mr1189097066b.28.1779967876916; Thu, 28 May 2026
 04:31:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4b84813ed94332ccf8bb46848ed91f699d75794a.1779964012.git.fdmanana@suse.com>
 <c4b59c1c-1f2f-4d93-b710-eb44a8c5943f@gmx.com>
In-Reply-To: <c4b59c1c-1f2f-4d93-b710-eb44a8c5943f@gmx.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 28 May 2026 12:30:39 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4V8mcisQRkxAro1_w0h+WxqAkapnp9AbKed1geGw6gDQ@mail.gmail.com>
X-Gm-Features: AVHnY4JcH2pgRIANkwIb3hstKuv1vs7zd_Zrv2K427e_RHYBCnGmA2yZocnokMk
Message-ID: <CAL3q7H4V8mcisQRkxAro1_w0h+WxqAkapnp9AbKed1geGw6gDQ@mail.gmail.com>
Subject: Re: [PATCH] generic: add a test case for writes with prealloc extents
 beyond i_size
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2026 at 12:23=E2=80=AFPM Qu Wenruo <quwenruo.btrfs@gmx.com>=
 wrote:
>
>
>
> =E5=9C=A8 2026/5/28 19:57, fdmanana@kernel.org =E5=86=99=E9=81=93:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Test writing into a file range containing prealloc extents beyond the c=
urrent
> > i_size, with an unmount and mount after fallocate and the write, to ver=
ify
> > that the file data, size and extent layout were not lost.
> >
> > This used to fail on btrfs when not using the no-holes feature (which i=
s
> > a default since btrfs-progs 5.15) before this recent kernel fix:
> >
> >     080ecbd05432 ("btrfs: mark file extent range dirty after converting=
 prealloc extents")
> >
> > So in order to reproduce the failure when using an unpatched kernel and
> > a btrfs-progs >=3D 5.15, one must run the test with:
> >
> >     MKFS_OPTIONS=3D"-O ^no-holes"
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
>
>
> Just one question related to the specified mkfs option.
>
> As you mentioned, this bug is only affecting ^no-holes, thus default
> mount option runs won't trigger it.
>
> This makes me wondering, should we have a dedicated btrfs test case just
> exercising the ^no-holes path.
>
> I know this will cause duplication, thus will not be a good idea to
> maintain, but we also have dedicated test cases utilizing specified
> mount option/mkfs options already.
>
> So what is the prefer method here?

So in the past I attempted tests like that, making them btrfs specific
and forcing a mount option.
Some people (non-btrfs people, I don't recall exactly who, to be
honest) disagreed with the claims that the test was actually generic,
and that exercising the bug should be done by setting MKFS_OPTIONS in
the command line.

I'm assuming people and our automations run tests with -O ^no-holes. I
do it frequently in my test vms.

>
> Thanks,
> Qu
> > ---
> >   tests/generic/796     | 54 ++++++++++++++++++++++++++++++++++++++++++=
+
> >   tests/generic/796.out | 10 ++++++++
> >   2 files changed, 64 insertions(+)
> >   create mode 100755 tests/generic/796
> >   create mode 100644 tests/generic/796.out
> >
> > diff --git a/tests/generic/796 b/tests/generic/796
> > new file mode 100755
> > index 00000000..c42a4722
> > --- /dev/null
> > +++ b/tests/generic/796
> > @@ -0,0 +1,54 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> > +#
> > +# FS QA Test 796
> > +#
> > +# Test writing into a file range containing prealloc extents beyond th=
e current
> > +# i_size, with an unmount and mount after fallocate and the write, to =
verify
> > +# that the file data, size and extent layout were not lost.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick prealloc preallocrw fiemap
> > +
> > +. ./common/filter
> > +. ./common/punch # for _filter_fiemap
> > +
> > +_require_scratch
> > +_require_xfs_io_command "falloc" "-k"
> > +_require_xfs_io_command "fiemap"
> > +
> > +_fixed_by_fs_commit btrfs 080ecbd05432 \
> > +     "btrfs: mark file extent range dirty after converting prealloc ex=
tents"
> > +
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +_scratch_mount
> > +
> > +# The fiemap results in the golden output requires file allocations to=
 align to
> > +# 1M boundaries.
> > +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> > +
> > +# Create our file with a size of 0 and a prealloc extent in the range =
[0, 2M].
> > +$XFS_IO_PROG -f -c "falloc -k 0 2M" $SCRATCH_MNT/foo
> > +
> > +# Unmount and mount again to remove any in memory state of the inode. =
We will
> > +# verify later that neither metadata nor extents were lost during unmo=
unt.
> > +_scratch_cycle_mount
> > +
> > +# Write into the [0, 1M] range, which increases the inode's i_size.
> > +$XFS_IO_PROG -c "pwrite -S 0xab -b 1M 0 1M" $SCRATCH_MNT/foo | _filter=
_xfs_io
> > +
> > +# Unmount and mount again to remove any in memory state of the inode. =
We will
> > +# verify later that neither metadata nor extents were lost during unmo=
unt.
> > +_scratch_cycle_mount
> > +
> > +# Check file data (and size).
> > +echo "File data:"
> > +_hexdump $SCRATCH_MNT/foo
> > +
> > +# Check we have unwritten extents in range [1M, 2M].
> > +echo "Fiemap output:"
> > +$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foo | _filter_fiemap
> > +
> > +# Success, all done.
> > +_exit 0
> > diff --git a/tests/generic/796.out b/tests/generic/796.out
> > new file mode 100644
> > index 00000000..c6c6e6a8
> > --- /dev/null
> > +++ b/tests/generic/796.out
> > @@ -0,0 +1,10 @@
> > +QA output created by 796
> > +wrote 1048576/1048576 bytes at offset 0
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +File data:
> > +000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab  >.............=
...<
> > +*
> > +100000
> > +Fiemap output:
> > +0: [0..2047]: data
> > +1: [2048..4095]: unwritten
>
