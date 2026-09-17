Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E778959B695
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 14:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789655879; cv=none; b=sYVXGV+hrQu2xjsZi/pMmZSvEXjrU33Xqs5TY5YEAh2lcV5TNZ/OkGP3YLaUqX69zxbivuLlgX5+QldLHXyUKTiLIJ+HJtOjrF/Lbzh1/ti3d+Vl+RgiOv7rtL87IGFBoxotNcrocEnASLUqNpNgbtVr2LEkkIK4kdcOwJfIlSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789655879; c=relaxed/simple;
	bh=oCTSCFST3cO3z3RPrrm6UR0q5rdqaIaRvqDbyA73jno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k+3gfwaO8+uiQMlx3y/oevBUiR976diP1DYQQfcuTyZQqnD8LyJINNk/kii9ovSThgHSHzldb4ecqei0AgbV9FZ2jdw1irnv7+bBGDabqM3DV+8Njgq+hkXlOISNOge9wdQWrKXwcUaoU20OSUuwIR5nc8iaq2TYIEkGEWyNngc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cdi3kap/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cdi3kap/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4DC1F00893
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 14:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789655877;
	bh=o3xpc6dR0Tsk4ue/AkZDWV3SAKY+RVB27mfF/D3KBYg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cdi3kap/pUz2JgjcUZT4gAbAsrFkXKXdx9cBdY8b45sbGXPa62wxpC1unlUiK0Cc5
	 Fup0rXWIl4PmO0U92iH6sA6N/FJf3oImwLjnSfnw7KaKk8McnGMmh0wQVxhSiuOm4C
	 HMabATm774L9Yc/5pj4rwAw6UXsIdvRbKzAuH/SkGRHTU21H26ZOB2Vmop2Pp/8N3j
	 2TGyU2OEzBFgBa9SLipj7TUMmUoo+66nGOJ/KGDbqQzsQNTkcuqZT2eIzOoaMxpzBJ
	 owsCRgwtXy/2d1j33VATJlculrA80lr5As9/UGewwGTi2KVp7wn7iLG/So47vWfaBE
	 XFuwZ5YH6f2yw==
Received: by mail-vs2-f40.google.com with SMTP id 71dfb90a1353d-5c9b0bdf5b5so125223e0c.0
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 07:37:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwxQj6648rvXjAu4SzpvNYiu6AkSzr2Qaeh/QTlVi+Nmuu3vQQ0G5nMgaatEEsglJP2OVMTrCifpmOYyg==@vger.kernel.org
X-Gm-Message-State: AFuF++nCSLqRVQOnSaDhrgQRA8ij1ZCpKIdnjMJe7N4WAum65m57JWaG
	uKXil0lDKel36wjUPnJwz7AVweJqdSe9DIxJ9HIUNIXwKmQmggI93WcqgXkUfY+I51HANrgB+kj
	CsjDnRv8IHEjmX0BGgM/AxWc48nts0AA=
X-Received: by 2002:a05:6102:5345:b0:7a4:85a8:fbc5 with SMTP id
 ada2fe7eead31-7a485a936d7mr425390137.16.1789655876709; Thu, 17 Sep 2026
 07:37:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917-btrfs-enomem-v2-1-0ccc4271ad64@kernel.org>
In-Reply-To: <20260917-btrfs-enomem-v2-1-0ccc4271ad64@kernel.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 17 Sep 2026 15:37:20 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5Q6-PyDZPL78t1UobVh8=6EZgDKkNy9Z5PBk09o=xRXA@mail.gmail.com>
X-Gm-Features: AcwNN1U3qe4PsFckZNr_x-NzXQtdvYPMnG4LiDuZk_psv23aN6oBvLXhR9ZJbiI
Message-ID: <CAL3q7H5Q6-PyDZPL78t1UobVh8=6EZgDKkNy9Z5PBk09o=xRXA@mail.gmail.com>
Subject: Re: [PATCH fstests v2] btrfs: test graceful ENOMEM handling in
 synchronous dirops
To: Jeff Layton <jlayton@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>, 
	linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 12:47=E2=80=AFPM Jeff Layton <jlayton@kernel.org> w=
rote:
>
> Recently, we added some patches to allow btrfs to handle -ENOMEM errors
> in dir-morphing codepaths [1]. As part of that, we added fault injection
> knobs to a few functions so we could test that error handling.
>
> Add a test case that uses the fail_function facility to inject -ENOMEM
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

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good Jeff, thanks.

> ---
> Changes in v2:
> - Add _fixed_by_kernel_commit line
> - Clean up changelog
> - Link to v1: https://lore.kernel.org/r/20260915-btrfs-enomem-v1-1-ca0761=
0ebcad@kernel.org
> ---
>  common/inject       | 50 +++++++++++++++++++++++++++++++
>  tests/btrfs/354     | 86 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/btrfs/354.out |  2 ++
>  3 files changed, 138 insertions(+)
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
> index 000000000000..e5365b21059a
> --- /dev/null
> +++ b/tests/btrfs/354
> @@ -0,0 +1,86 @@
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
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +       "btrfs: handle ENOMEM from btrfs_insert_dir_item() without aborti=
ng"
> +
> +_require_scratch
> +# For the automatic fsck at unmount, which confirms the orphaned inode l=
eft by
> +# the failed operation is cleaned up and the fs is consistent.
> +_require_check_dmesg
> +_require_function_error_injection btrfs_prealloc_delayed_dir_index
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
