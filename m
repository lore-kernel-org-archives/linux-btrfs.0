Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D9541BA81;
	Sun, 20 Sep 2026 11:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904894; cv=none; b=plhl3L02kkg0gzpv1ibwI/3BbNRUH4AvSzauCSbL3qji7RcWnDmYcDVRj/wh3fhX83vwXawPWsRj3TkTWG3lRFvKU2ZY73fNsIkqRiDpW2fGkJPWQrZDQptxo71ENJBhejcq2IHqzZWI04MCbIX34TYvL+7/dt4yYIUr+YD6e6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904894; c=relaxed/simple;
	bh=2sFes0Fit8NlQzyHT4Ddf1eFgMfP+4t0R027QTVibok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGfVdiKMWZJD46S0VnK//fA/hlYmw7A9nQ3Z99TOyAxSBncYyjJlCKOsGrwnz8uyeZpTwuCHgqcA+Gn8W1wt5nzOXSpz6saQZ584DmHrO4F619suhG4XACKDakaJlf/8ZBC9gwdt42/Y2/Ji50pP6CEb178rgA6XUIMasel59v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEemUm96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEemUm96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89AA1F000FF;
	Sun, 20 Sep 2026 11:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904892;
	bh=8hioq+s63WBfqFjTyJOeOcqGxZ8zCkdeuDPIcPPCS5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AEemUm962xPt6u6K2fa3N3CH3/EPK1ctDZ9FjUQYAQ5A0IVDjkXsLYxJ0VFfpyP9b
	 /ge1W6zK5RTToQQyvS+pR3SD/2kTIkd4GMOnyUXSnyINBOAdL7PXy6glnjLog1PbpQ
	 9CzZoXXICgCd/Go45pfVIb5ppoRcFe4SCwb358zZnwqamW9xn7VizkpRiQWMWQcwVX
	 zv4QtlzxK9PxxJ0ujACZL/6VMOf13fB20bqgSj2mZBE5/6YKR0o4Dyn3q2f6oLkr9I
	 rPI2PUmj+6J1qhWN0ooukgkQPtr+D7Je8wpO8RRWwtenAUaN8e3COHjqbX8mPmLX86
	 tP4u3EB5awYcg==
Date: Sun, 20 Sep 2026 19:48:06 +0800
From: Zorro Lang <zlang@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>, 
	linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH fstests v2] btrfs: test graceful ENOMEM handling in
 synchronous dirops
Message-ID: <aq-5KF5bfK9QFnBW@zlang-mailbox>
Mail-Followup-To: Jeff Layton <jlayton@kernel.org>, 
	Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org, 
	fstests@vger.kernel.org
References: <20260917-btrfs-enomem-v2-1-0ccc4271ad64@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-btrfs-enomem-v2-1-0ccc4271ad64@kernel.org>

On Thu, Sep 17, 2026 at 07:38:23AM -0400, Jeff Layton wrote:
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
> [1]: https://lore.kernel.org/linux-btrfs/20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org/
> 
> Assisted-by: LLM
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> Changes in v2:
> - Add _fixed_by_kernel_commit line
> - Clean up changelog
> - Link to v1: https://lore.kernel.org/r/20260915-btrfs-enomem-v1-1-ca07610ebcad@kernel.org

Hi Jeff,

Thanks for the patch! It's great to see fail_function error injection being
introduced into fstests for this.

Just a couple of minor review pointers below ...

> ---
>  common/inject       | 50 +++++++++++++++++++++++++++++++
>  tests/btrfs/354     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/354.out |  2 ++
>  3 files changed, 138 insertions(+)
> 
> diff --git a/common/inject b/common/inject
> index 6b590804d1ea..da78c1931135 100644
> --- a/common/inject
> +++ b/common/inject
> @@ -111,3 +111,53 @@ _scratch_inject_error()
>  		_fail "Cannot inject error ${type} value ${value}."
>  	fi
>  }
> +
> +# Requires the kernel fail_function facility (CONFIG_FUNCTION_ERROR_INJECTION
> +# and CONFIG_FAIL_FUNCTION) and, if a function name is given, that the function
> +# is annotated with ALLOW_ERROR_INJECTION().
> +_require_function_error_injection()
> +{
> +	local func="$1"
> +

Better to call `_require_debugfs` at here.

> +	test -d "$DEBUGFS_MNT/fail_function" || \
> +		_notrun "$DEBUGFS_MNT/fail_function not found; CONFIG_FAIL_FUNCTION not enabled"
> +
> +	if [ -n "$func" ]; then
> +		grep -qw "$func" "$DEBUGFS_MNT/error_injection/list" 2>/dev/null || \
> +			_notrun "$func is not registered for error injection"
> +	fi
> +}
> +
> +# Inject a fixed return value into a kernel function via fail_function.
> +#   $1 - function name (must be ALLOW_ERROR_INJECTION annotated)
> +#   $2 - return value to inject (e.g. -12 for -ENOMEM)
> +#   $3 - number of times to fail (default 1)
> +_inject_function_error()
> +{
> +	local func="$1"
> +	local retval="$2"
> +	local times="${3:-1}"
> +
> +	# Writing the function name to "inject" creates its per-function dir.
> +	echo "$func" > "$DEBUGFS_MNT/fail_function/inject"
> +	# The retval file is an unsigned hex attribute (DEFINE_DEBUGFS_ATTRIBUTE
> +	# "%llx"), so a negative errno like -12 must be written as its unsigned
> +	# 64-bit (two's-complement) hex form; a bare "-12" is rejected with EINVAL.
> +	printf '%#x\n' "$retval" > "$DEBUGFS_MNT/fail_function/$func/retval"
> +	echo 100 > "$DEBUGFS_MNT/fail_function/probability"
> +	echo 0 > "$DEBUGFS_MNT/fail_function/interval"
> +	echo 0 > "$DEBUGFS_MNT/fail_function/space"
> +	echo 0 > "$DEBUGFS_MNT/fail_function/verbose"
> +	echo "$times" > "$DEBUGFS_MNT/fail_function/times"
> +}
> +
> +# Stop injecting errors into a kernel function set up by
> +# _inject_function_error().
> +_uninject_function_error()
> +{
> +	local func="$1"
> +
> +	echo 0 > "$DEBUGFS_MNT/fail_function/times" 2>/dev/null
> +	echo 0 > "$DEBUGFS_MNT/fail_function/probability" 2>/dev/null
> +	echo "!$func" > "$DEBUGFS_MNT/fail_function/inject" 2>/dev/null
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
> +# Verify that an -ENOMEM in the synchronous directory entry insertion path is
> +# returned to userspace without aborting the filesystem.
> +#
> +# btrfs pre-allocates the delayed dir index before modifying the btree, so a
> +# failure in btrfs_prealloc_delayed_dir_index() must surface as -ENOMEM from
> +# mkdir()/create()/etc. rather than a transaction abort. Use the fail_function
> +# facility to force that allocation to fail and confirm the fs survives.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
                            ^^^
Perhaps this should be added to the "dir" group as well?

> +
> +. ./common/inject
> +. ./common/filter
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: handle ENOMEM from btrfs_insert_dir_item() without aborting"
> +
> +_require_scratch
> +# For the automatic fsck at unmount, which confirms the orphaned inode left by
> +# the failed operation is cleaned up and the fs is consistent.
> +_require_check_dmesg
> +_require_function_error_injection btrfs_prealloc_delayed_dir_index
> +
> +func=btrfs_prealloc_delayed_dir_index
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +# Pre-create the stderr file. fail_function has no usable task filter, so the
> +# injection is global, and $tmp may well live on a btrfs filesystem itself. If
> +# the shell had to create this file it would insert a dir entry and swallow the
> +# injected failure before mkdir() ever ran.
> +touch $tmp.err
> +
> +# For the same reason any other btrfs dir-entry creation on the system can
> +# consume the one-shot failure, so retry until our mkdir is the operation that
> +# takes it.
> +err=""
> +for i in $(seq 1 20); do
> +	rm -rf "$SCRATCH_MNT/dir"
> +
> +	# Force a single -ENOMEM (-12) into the prealloc path.
> +	_inject_function_error $func -12 1
> +	mkdir "$SCRATCH_MNT/dir" 2>$tmp.err
> +	res=$?
> +	_uninject_function_error $func

I think we should also invoke _uninject_function_error in _cleanup(). E.g.

  _cleanup()
  {
      [ -n "$func" ] && _uninject_function_error $func
      cd /
      rm -rf $tmp.*
  }

This guarantees that if the test is interrupted (e.g. Ctrl+C) while an injection
is active, the stale injection won't leak into debugfs and affect subsequent
tests.

> +
> +	# mkdir succeeded, so something else consumed the injected failure.
> +	# Note we must not leave the directory behind, or the next attempt
> +	# would fail with EEXIST rather than the injected error.
> +	if [ $res -eq 0 ]; then
> +		continue
> +	fi
> +
> +	err=$(cat $tmp.err)
> +	break
> +done
> +
> +if [ -z "$err" ]; then
> +	_notrun "injected error did not reach mkdir"
> +fi
> +
> +# The error returned to userspace must be ENOMEM, not EROFS (which would mean
> +# the transaction was aborted and the fs went read-only).
> +echo "$err" | grep -qi "cannot allocate memory" || \
> +	{ echo "unexpected error from mkdir:"; echo "$err" | _filter_scratch; }
> +
> +# The filesystem must still be usable: a create with injection disabled must
> +# succeed. On an aborted (read-only) fs this would fail with EROFS.
> +mkdir "$SCRATCH_MNT/dir2" || _fail "filesystem unusable after injected ENOMEM"
> +
> +# Cycle the mount to run orphan cleanup for the inode left behind by the failed
> +# mkdir, then keep using the fs to be sure it is healthy.
> +_scratch_cycle_mount
> +touch "$SCRATCH_MNT/dir2/file"
> +
> +echo "silence is golden"
> +
> +status=0
> +exit

_exit 0

Others looks good to me, with above changes, feel free to add:

Reviewed-by: Zorro Lang <zlang@kernel.org>

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
