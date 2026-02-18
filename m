Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0252E33507C;
	Wed, 18 Feb 2026 23:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771458166; cv=none; b=r+yqfK6J1ruhWRAGD9C4ZvSRxdYmGbd5rXl+Hz3e+ZFAt/HbOGCPkEbAkqyI1aG2Y++zXiQe2nCn69abrwXF0yTPs2Y/sUZd9X3QRWHdYFoY6cxazYB2K8DylQj2ZNwlBP8DvwcbBH++Xv6DqYXMsrIir9lRk6go8b2xSVAjyaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771458166; c=relaxed/simple;
	bh=sY3YmrSBCh2cBIKybV2DwaPMK5e0yyXedmmzqN2y4LA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iW0nPf+vv20o38nU1IbosudKHCbOB3zpcXiJP78Zl/DhW2wD1026rTcb2Kcv1TReNRdrfPPS3Th1X2v3wonhTHkMGI4rbWBFqfXHPQKOQiemqiFIzl4yJRo6q+KKJ8KkUvexbz3MBoAZ8x3O6PD6HgnDxtNLRhXK0bZRyS7l8zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kaM9h3mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kaM9h3mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D73BC116D0;
	Wed, 18 Feb 2026 23:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771458165;
	bh=sY3YmrSBCh2cBIKybV2DwaPMK5e0yyXedmmzqN2y4LA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kaM9h3mhQnFeiXem7+U9F2vtUGQ1DKO9+Pg4+2TIWkZMp0fFe3NvLiUXjOmhkq/c7
	 1Vvz2C7hANvnYflvPwX2J6uSahHqP2Z4PMLl5rnj4DwiWsM2hj6svBHufzLVKhgR0N
	 HfY/iDwoSshvnI2Olcj7VzaEJPnanwbvD/PEkG6JRzkEUTu5mpIrQ7tocvJzDENgBg
	 KbUBHv8HVHuFQcJnaN1h3qIG1YtGAnB/JjBfxRupUGDxDXRbiS5YVfRgaMASvPNIn0
	 0ir8seWNs3zQAVjhjsb1xUYADjU+/NDLbBM8lGp8GONkF6NNMTMOene7fa6M43wBoE
	 Itjp8f+dCmHZA==
Date: Wed, 18 Feb 2026 15:42:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] generic: test fsync of a file truncated to a length of
 zero
Message-ID: <20260218234244.GA6478@frogsfrogsfrogs>
References: <f4a25aa2a17255493a9887e0ba6610a307a4961a.1771352543.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4a25aa2a17255493a9887e0ba6610a307a4961a.1771352543.git.fdmanana@suse.com>

On Tue, Feb 17, 2026 at 06:33:30PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we truncate a file to 0, fsync it, add a hard link to the
> file and then fsync the parent directory, after a power failure the file
> has a size of 0 (and the hardlink exists too).
> 
> This exercises a bug fixed by the following kernel patch for btrfs:
> 
>   "btrfs: fix zero size inode with non-zero size after log replay"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

This looks ok to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/generic/788     | 59 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/788.out |  5 ++++
>  2 files changed, 64 insertions(+)
>  create mode 100755 tests/generic/788
>  create mode 100644 tests/generic/788.out
> 
> diff --git a/tests/generic/788 b/tests/generic/788
> new file mode 100755
> index 00000000..0234cc7f
> --- /dev/null
> +++ b/tests/generic/788
> @@ -0,0 +1,59 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 788
> +#
> +# Test that if we truncate a file to 0, fsync it, add a hard link to the file
> +# and then fsync the parent directory, after a power failure the file has a
> +# size of 0 (and the hardlink exists too).
> +#
> +. ./common/preamble
> +_begin_fstest auto quick log
> +
> +_cleanup()
> +{
> +	_cleanup_flakey
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +. ./common/filter
> +. ./common/dmflakey
> +
> +_require_scratch
> +_require_dm_target flakey
> +
> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: fix zero size inode with non-zero size after log replay"
> +
> +_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> +_require_metadata_journaling $SCRATCH_DEV
> +_init_flakey
> +_scratch_mount
> +
> +mkdir $SCRATCH_MNT/dir
> +$XFS_IO_PROG -f -c "pwrite -S 0xab 0 64K" $SCRATCH_MNT/dir/foo | _filter_xfs_io
> +
> +# Persist the file and directory.
> +_scratch_sync
> +
> +# Truncate the file to 0 and fsync it.
> +$XFS_IO_PROG -c "truncate 0" -c "fsync" $SCRATCH_MNT/dir/foo
> +
> +# Create a link to foo in the same dir.
> +ln $SCRATCH_MNT/dir/foo $SCRATCH_MNT/dir/bar
> +
> +# Fsync the directory.
> +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/dir
> +
> +# Simulate a power failure and then mount again the filesystem to replay the
> +# journal/log.
> +_flakey_drop_and_remount
> +
> +echo "file size after power failure: $(stat -c %s $SCRATCH_MNT/dir/foo)"
> +echo "file link count after power failure: $(stat -c %h $SCRATCH_MNT/dir/foo)"
> +[ -f $SCRATCH_MNT/dir/bar ] || echo "link dir/bar is missing"
> +
> +# success, all done
> +_exit 0
> diff --git a/tests/generic/788.out b/tests/generic/788.out
> new file mode 100644
> index 00000000..37f3f36a
> --- /dev/null
> +++ b/tests/generic/788.out
> @@ -0,0 +1,5 @@
> +QA output created by 788
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +file size after power failure: 0
> +file link count after power failure: 2
> -- 
> 2.47.2
> 
> 
