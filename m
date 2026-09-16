Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE8A4A2E2E
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789574657; cv=none; b=U9gKSlxZXODn5gRxLw3XDQJ7xo7bGjmU1pvoRBAZ8VuLqgKFu4dDo9QOz4lhG04z3PFemYoRBrGPZ0l4yaW0lXsJey/Z7ot5vVBtJ9nePna5O/JohHoxdTnWM1kZtzp9Vt933KEErsxhDKiUM9KjXddml5LIb2oFZpqr0KWjtgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789574657; c=relaxed/simple;
	bh=7f7pgDb3cVbwNL/undFad2w+7ywuk1GF4onbwjuLpcs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ErJedujcZiLMpLHr1DUb7+EokU3AjLBNqQxWpT//1yUL09ztNce9F2B9nlRS4xxyKLGltxqURu87mCGpZdqYKRfxTSG5YcKeMusEh60sLFz1CYXexGDkF0ejKR3eEjEnXMiV+QY900pUJrRlsvufdfHQy1WItJ9GXas5QtJRWa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvxYFmkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvxYFmkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C2B1F00898
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 16:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789574655;
	bh=ny026t7rUNJsTan8gmG/Ss10INArhWWwB4LVmZPvaso=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KvxYFmkOu/BDKyXX/YWcfdJOWMJ2URFSk5+/y8pDcL4p/SXafBSccXPla9oJfy+AA
	 /coI39y+qCKXm5lUFbvomOEucqfMG3DhEzfap0SLq6jRCzJ+XXclEnetNKTB9LwwPJ
	 gWOQBumStk+fziBptTFA3ZcQ57xBJoIsqz8/JslEEHTRrjU1QBUjQLFZWDtwqO8ZfZ
	 KvvXZnugtCeLD4TTd+Pgm7ypdFXLAxH8FFYs+wCgYcDuUb0wmm1F9julV9Qa2kkpJ3
	 l8Eq60pUdta/AZrVPQS19DdyEHLr94sZAXi8jaMwesHsN8iZj+nmH6r2WzXsrlWF40
	 L1wNQPpsptguw==
Received: by mail-vs2-f12.google.com with SMTP id 71dfb90a1353d-5c7e8a176c1so425900e0c.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 09:04:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz8z4VB6Ql1vNREX06j29ave8bO0kzaPPduILJNpyO4frSkeLIx1g4/a6SFrLZrvyfhT6jbfQiDHzQcLA==@vger.kernel.org
X-Gm-Message-State: AFuF++mrgJTQNvSU6qVwFHqRoiq1SjfTZJMKWWxZKBjdVRqWPz6pHtKg
	+lMS9d0NtDctn9/4ndfNEmtDPsPv7P1v5Lqs6HpUIU2N38FZe3nstfXPIw1uzRCFHWc2BNRGI6C
	bu1P3cbq8pulceSVRjiBFZ1/SQKtAu3U=
X-Received: by 2002:a05:6122:6612:b0:5c8:4409:602a with SMTP id
 71dfb90a1353d-5c99ad237fdmr4719846e0c.8.1789574654513; Wed, 16 Sep 2026
 09:04:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915-btrfs-enomem-v1-1-ca07610ebcad@kernel.org>
In-Reply-To: <20260915-btrfs-enomem-v1-1-ca07610ebcad@kernel.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 16 Sep 2026 17:03:38 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4P32sBFHoUkD6NhxhJs=aLGMFKqB9ZGO0716Vx3r5vag@mail.gmail.com>
X-Gm-Features: AcwNN1UcqSIE1NJnSo0_XXvgzE8A29mzmeswawqQP-vFLyZIOfupe3-gIeBLyM0
Message-ID: <CAL3q7H4P32sBFHoUkD6NhxhJs=aLGMFKqB9ZGO0716Vx3r5vag@mail.gmail.com>
Subject: Re: [PATCH fstests] btrfs: test graceful ENOMEM handling in
 synchronous dirops
To: Jeff Layton <jlayton@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>, 
	linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 5:33=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Recently, we added some patches to allow btrfs to handle -ENOMEM errors
> in dir-morphing codepaths [1]. As part of that, we added fault injection
> knobs to a few functions so we could test that error handling.
>
> Add btrfs/354, which uses the fail_function facility to inject -ENOMEM

Please don't add here the test number, as this is very likely to be
changed at commit time as we have already 2 other pending test cases
with that number.
Just say "Add a test case...".

> into btrfs_prealloc_delayed_dir_index() and confirms that a
> dir-modifying operation returns ENOMEM to userspace without aborting the
> filesystem:
>
> - mkdir fails with ENOMEM (not EROFS),
> - a subsequent create succeeds (fs is not read-only/aborted),
> - a mount cycle runs orphan cleanup and the automatic fsck confirms
>   consistency.
>
> The injection is global, so any other btrfs dir-entry creation can
> consume it first -- including the test's own $tmp redirection when /tmp
> is itself on btrfs. Pre-create that file and retry until the mkdir takes
> the error.
>
> Add generic _require_function_error_injection / _inject_function_error /
> _uninject_function_error helpers to common/inject for driving the kernel
> fail_function interface.
>
> [1]: https://lore.kernel.org/linux-btrfs/20260825-btrfs-enomem-v4-0-b9363=
fa8714a@kernel.org/
>
> Assisted-by: LLM
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  common/inject       | 50 ++++++++++++++++++++++++++++++++
>  tests/btrfs/354     | 83 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/btrfs/354.out |  2 ++
>  3 files changed, 135 insertions(+)
>
> diff --git a/common/inject b/common/inject
> index 6b590804d1ea..da78c1931135 100644
> --- a/common/inject
> +++ b/common/inject
> @@ -111,3 +111,53 @@ _scratch_inject_error()
>                 _fail "Cannot inject error ${type} value ${value}."
>         fi
>  }
> +
> +# Requires the kernel fail_function facility (CONFIG_FUNCTION_ERROR_INJE=
CTION
> +# and CONFIG_FAIL_FUNCTION) and, if a function name is given, that the f=
unction
> +# is annotated with ALLOW_ERROR_INJECTION().
> +_require_function_error_injection()
> +{
> +       local func=3D"$1"
> +
> +       test -d "$DEBUGFS_MNT/fail_function" || \
> +               _notrun "$DEBUGFS_MNT/fail_function not found; CONFIG_FAI=
L_FUNCTION not enabled"
> +
> +       if [ -n "$func" ]; then
> +               grep -qw "$func" "$DEBUGFS_MNT/error_injection/list" 2>/d=
ev/null || \
> +                       _notrun "$func is not registered for error inject=
ion"
> +       fi
> +}
> +
> +# Inject a fixed return value into a kernel function via fail_function.
> +#   $1 - function name (must be ALLOW_ERROR_INJECTION annotated)
> +#   $2 - return value to inject (e.g. -12 for -ENOMEM)
> +#   $3 - number of times to fail (default 1)
> +_inject_function_error()
> +{
> +       local func=3D"$1"
> +       local retval=3D"$2"
> +       local times=3D"${3:-1}"
> +
> +       # Writing the function name to "inject" creates its per-function =
dir.
> +       echo "$func" > "$DEBUGFS_MNT/fail_function/inject"
> +       # The retval file is an unsigned hex attribute (DEFINE_DEBUGFS_AT=
TRIBUTE
> +       # "%llx"), so a negative errno like -12 must be written as its un=
signed
> +       # 64-bit (two's-complement) hex form; a bare "-12" is rejected wi=
th EINVAL.
> +       printf '%#x\n' "$retval" > "$DEBUGFS_MNT/fail_function/$func/retv=
al"
> +       echo 100 > "$DEBUGFS_MNT/fail_function/probability"
> +       echo 0 > "$DEBUGFS_MNT/fail_function/interval"
> +       echo 0 > "$DEBUGFS_MNT/fail_function/space"
> +       echo 0 > "$DEBUGFS_MNT/fail_function/verbose"
> +       echo "$times" > "$DEBUGFS_MNT/fail_function/times"
> +}
> +
> +# Stop injecting errors into a kernel function set up by
> +# _inject_function_error().
> +_uninject_function_error()
> +{
> +       local func=3D"$1"
> +
> +       echo 0 > "$DEBUGFS_MNT/fail_function/times" 2>/dev/null
> +       echo 0 > "$DEBUGFS_MNT/fail_function/probability" 2>/dev/null
> +       echo "!$func" > "$DEBUGFS_MNT/fail_function/inject" 2>/dev/null
> +}
> diff --git a/tests/btrfs/354 b/tests/btrfs/354
> new file mode 100755
> index 000000000000..9b9e601d6405
> --- /dev/null
> +++ b/tests/btrfs/354
> @@ -0,0 +1,83 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Jeff Layton.  All Rights Reserved.
> +#
> +# FS QA Test No. 354
> +#
> +# Verify that an -ENOMEM in the synchronous directory entry insertion pa=
th is
> +# returned to userspace without aborting the filesystem.
> +#
> +# btrfs pre-allocates the delayed dir index before modifying the btree, =
so a
> +# failure in btrfs_prealloc_delayed_dir_index() must surface as -ENOMEM =
from
> +# mkdir()/create()/etc. rather than a transaction abort. Use the fail_fu=
nction
> +# facility to force that allocation to fail and confirm the fs survives.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +. ./common/inject
> +. ./common/filter
> +
> +_require_scratch
> +# For the automatic fsck at unmount, which confirms the orphaned inode l=
eft by
> +# the failed operation is cleaned up and the fs is consistent.
> +_require_check_dmesg
> +_require_function_error_injection btrfs_prealloc_delayed_dir_index

Please add here somewhere a call to  _fixed_by_kernel_commit so that
when test case fails on an unpatched kernel we get an informative
message.

Otherwise it looks good, thanks.

> +
> +func=3Dbtrfs_prealloc_delayed_dir_index
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +# Pre-create the stderr file. fail_function has no usable task filter, s=
o the
> +# injection is global, and $tmp may well live on a btrfs filesystem itse=
lf. If
> +# the shell had to create this file it would insert a dir entry and swal=
low the
> +# injected failure before mkdir() ever ran.
> +touch $tmp.err
> +
> +# For the same reason any other btrfs dir-entry creation on the system c=
an
> +# consume the one-shot failure, so retry until our mkdir is the operatio=
n that
> +# takes it.
> +err=3D""
> +for i in $(seq 1 20); do
> +       rm -rf "$SCRATCH_MNT/dir"
> +
> +       # Force a single -ENOMEM (-12) into the prealloc path.
> +       _inject_function_error $func -12 1
> +       mkdir "$SCRATCH_MNT/dir" 2>$tmp.err
> +       res=3D$?
> +       _uninject_function_error $func
> +
> +       # mkdir succeeded, so something else consumed the injected failur=
e.
> +       # Note we must not leave the directory behind, or the next attemp=
t
> +       # would fail with EEXIST rather than the injected error.
> +       if [ $res -eq 0 ]; then
> +               continue
> +       fi
> +
> +       err=3D$(cat $tmp.err)
> +       break
> +done
> +
> +if [ -z "$err" ]; then
> +       _notrun "injected error did not reach mkdir"
> +fi
> +
> +# The error returned to userspace must be ENOMEM, not EROFS (which would=
 mean
> +# the transaction was aborted and the fs went read-only).
> +echo "$err" | grep -qi "cannot allocate memory" || \
> +       { echo "unexpected error from mkdir:"; echo "$err" | _filter_scra=
tch; }
> +
> +# The filesystem must still be usable: a create with injection disabled =
must
> +# succeed. On an aborted (read-only) fs this would fail with EROFS.
> +mkdir "$SCRATCH_MNT/dir2" || _fail "filesystem unusable after injected E=
NOMEM"
> +
> +# Cycle the mount to run orphan cleanup for the inode left behind by the=
 failed
> +# mkdir, then keep using the fs to be sure it is healthy.
> +_scratch_cycle_mount
> +touch "$SCRATCH_MNT/dir2/file"
> +
> +echo "silence is golden"
> +
> +status=3D0
> +exit
> diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
> new file mode 100644
> index 000000000000..afe30ed36fea
> --- /dev/null
> +++ b/tests/btrfs/354.out
> @@ -0,0 +1,2 @@
> +QA output created by 354
> +silence is golden
>
> ---
> base-commit: a370dcbed43563f0462801e889e0eceb93c7cfad
> change-id: 20260915-btrfs-enomem-e70077862117
>
> Best regards,
> --
> Jeff Layton <jlayton@kernel.org>
>
>
