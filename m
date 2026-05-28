Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53B739A81E
	for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 10:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779964654; cv=none; b=fVzhGeCrMlrxD71MDDLslBheH+xV2BgrwBunsGAY8EfHdaUFvhDQ5R2Grb8f5mE7ywFNUOO62z0iKr4+coMjRTN7k3cxcvz8+juygHKENzGOIoD9rfmLwFvHzV+WFkkJuX0nMlNuMFzHJ9w4Y2zS3vM1KOavY5bl/1Wohcn8NHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779964654; c=relaxed/simple;
	bh=Z43/6I+5Y7W1mKgjFZFTQSqWTyoWXoBZxlMPtlaXLGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sxERLA4zBwehs89WSjGZ04VwpNFSU7iDdXHXsiHFn8VQEBar/paHysgTU+i1q2FvYX5fhDgxo0uWthsIAfBAc6vfo6eI6jXi7a4Tg3ElqGru8EdiU/9UGKeSMheCraCMTKJ4rvwMgW8dG9kkis8Bpfl/mDmQ/t+ybGHe8KSqQvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGzh0puT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGzh0puT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2A91F00A3C
	for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 10:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779964652;
	bh=RJFpEg3jXJPB1zy0GJfALWTJ8P5doHV9GZL7EeMK/jo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BGzh0puTyqbBazOATuTnuvRTJisa0zvWQgP9dA9VpEQNCujmucU3bKR0HQ0NAbIbV
	 bp5bnxQ6+q1mbPA/y/J3Zt3keT6P6pey5NPX2yuQagZUL60od++PSLwbmB+WJmqeVa
	 r7TE03dcTVVuoCnbRl/rz+kv3qsIDpXLDQccDLbq9Eoqm59rnYK9ynX0jd0YnihXqt
	 OXp28oxL67Pvn6Rse54LYE0OuNMlaB97sxNymsNRdfi0L56yp5MkaHGCaAGtp6x5lJ
	 1PMfQJINME7d7K56bSohqTmwgKSooABzudvACoo5V9z3ptzpMo8rVU9flOIAHaA8oA
	 Aleg2NB34HiIg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bcd0111ea98so1753400366b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 03:37:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+MgwuUKWkoASrC99Mpaxb4gUELuXiP7PW/r1fCVEJT/5KJUX5cK1OY/EiyzPRIDXjHT/jI6RLklUA92A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwX/BgIjo4P2OIBarJdiZGgezIlMCyW+a0nJb9n1tRfWJTs2wF7
	v1y2bCHAOt86ZhcpVmTdEVFC1pRRDJnxw478yeJECax+reYAr9qx7zSCj9snAkDe2wDMO1oYd4m
	TzE4AnbYkOsfW1qMEFmCOkQdz0WyfajQ=
X-Received: by 2002:a17:906:3187:b0:bde:190:bc4c with SMTP id
 a640c23a62f3a-bde01aff836mr1116221966b.38.1779964650895; Thu, 28 May 2026
 03:37:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260528065844.71952-1-wqu@suse.com>
In-Reply-To: <20260528065844.71952-1-wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 28 May 2026 11:36:53 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5pnnY2D0n2CjRU62e329ysE616D6ahVVFVhw2iGTLW2w@mail.gmail.com>
X-Gm-Features: AVHnY4JNZHBxJUtQOP74ZGFmOhWctmFNPi_Eoul7dMTp0lAM7upezqAnfX0Orbc
Message-ID: <CAL3q7H5pnnY2D0n2CjRU62e329ysE616D6ahVVFVhw2iGTLW2w@mail.gmail.com>
Subject: Re: [PATCH] fstests: remove dio related target file to respect mount
 options that only affecst new inodes
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2026 at 8:02=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG]
> Test case generic/362 and generic/365 will fail with nodatasum, but
> that's only when TEST_DEV is newly formated.

formated -> formatted

>
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMP=
T_DYNAMIC Tue May 26 10:47:14 ACST 2026
>  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
>
>   generic/362  0s ... - output mismatch (see /home/adam/xfstests/results/=
/generic/362.out.bad)
>     --- tests/generic/362.out   2024-08-24 15:31:37.200000000 +0930
>     +++ /home/adam/xfstests/results//generic/362.out.bad        2026-05-2=
8 16:18:33.866141979 +0930
>     @@ -1,2 +1,3 @@
>      QA output created by 362
>     +First write failed: Input/output error
>      Silence is golden
>     ...
>     (Run 'diff -u /home/adam/xfstests/tests/generic/362.out /home/adam/xf=
stests/results//generic/362.out.bad'  to see the entire diff)
>
>   generic/364  11s ... - output mismatch (see /home/adam/xfstests/results=
//generic/364.out.bad)
>     --- tests/generic/364.out   2024-09-30 09:09:51.216666681 +0930
>     +++ /home/adam/xfstests/results//generic/364.out.bad        2026-05-2=
8 16:18:34.318532257 +0930
>     @@ -1,2 +1,3 @@
>      QA output created by 364
>     +Fsync failed: Input/output error
>      Silence is golden
>     ...
>     (Run 'diff -u /home/adam/xfstests/tests/generic/364.out /home/adam/xf=
stests/results//generic/364.out.bad'  to see the entire diff)
>
> But if one has formated TEST_DEV, run test with default mount option,
> then change the mount option to "nodatasum", the test will not fail
> anymore:
>
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMP=
T_DYNAMIC Tue May 26 10:47:14 ACST 2026
>  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- /dev/mapper/test-scratch1 /mnt/scratch
>
>  generic/362  0s ...  1s
>  generic/364  11s ...  10s
>  Ran: generic/362 generic/364
>  Passed all 2 tests
>
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMP=
T_DYNAMIC Tue May 26 10:47:14 ACST 2026
>  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
>
>  generic/362  1s ...  0s
>  generic/364  10s ...  11s
>  Ran: generic/362 generic/364
>  Passed all 2 tests
>
> [CAUSE]
> Btrfs' nodatasum mount option only affect new files, but the test cases

affect -> affects

> are using TEST_DEV, and never delete the target files
> "$TEST_DIR/dio-append-buf-fault" for generic/362 and
> "$TEST_DIR/dio-write-fsync-same-fd" for generic/364.
>
> So if the files are created with default mount option, then all later

option -> options

> "nodatasum" mount option will not affect those files, thus hide the test
> failure.
>
> [FIX]
> For all test cases utilizing "$here/src/dio*", add a _cleanup()
> function, to remove target files, so that for mount options that only
> affect new inodes, the mount options will be respected, and expose
> failures.
>
> Now generic/36[24] will properly fail for "nodatasum" mount option on
> btrfs.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/generic/362 | 6 ++++++
>  tests/generic/364 | 7 +++++++
>  tests/generic/418 | 7 +++++++
>  tests/generic/708 | 6 ++++++
>  4 files changed, 26 insertions(+)
>
> diff --git a/tests/generic/362 b/tests/generic/362
> index 0cfaa726..5e8fd534 100755
> --- a/tests/generic/362
> +++ b/tests/generic/362
> @@ -10,6 +10,12 @@
>  . ./common/preamble
>  _begin_fstest auto quick
>
> +_cleanup()
> +{
> +       cd /

I think we need to have here:

 rm -f $tmp.*

It's standard practice to paste the code from the default _cleanup function=
.
I don't bother much with it though, just to be consistent.

> +       rm -f "$TEST_DIR/dio-append-buf-fault"
> +}
> +
>  # NFS forbade open with O_APPEND|O_DIRECT
>  _exclude_fs nfs
>
> diff --git a/tests/generic/364 b/tests/generic/364
> index f7fb002f..6587cf02 100755
> --- a/tests/generic/364
> +++ b/tests/generic/364
> @@ -11,6 +11,13 @@
>  . ./common/preamble
>  _begin_fstest auto quick
>
> +_cleanup()
> +{
> +       cd /
> +       rm -f "$TEST_DIR/dio-write-fsync-same-fd"
> +}
> +
> +
>  _require_test
>  _require_odirect
>  _require_test_program dio-write-fsync-same-fd
> diff --git a/tests/generic/418 b/tests/generic/418
> index 36789198..024c4682 100755
> --- a/tests/generic/418
> +++ b/tests/generic/418
> @@ -26,6 +26,13 @@ _require_block_device $TEST_DEV
>  _require_test_program "dio-invalidate-cache"
>  _require_test_program "feature"
>
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*

Here you added it.

> +       rm -f "$testfile"
> +}
> +
>  diotest=3D$here/src/dio-invalidate-cache
>  testfile=3D$TEST_DIR/$seq-diotest
>  sectorsize=3D`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
> diff --git a/tests/generic/708 b/tests/generic/708
> index 827dac13..cdaad811 100755
> --- a/tests/generic/708
> +++ b/tests/generic/708
> @@ -14,6 +14,12 @@
>  . ./common/preamble
>  _begin_fstest quick auto mmap
>
> +_cleanup()
> +{
> +       cd /

Missing again.

Though those are small things that can be fixed when applying the patch.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +       rm -f "$src" "$dst"
> +}
> +
>  _fixed_by_fs_commit btrfs b73a6fd1b1ef \
>                 "btrfs: split partial dio bios before submit"
>
> --
> 2.51.2
>
>
