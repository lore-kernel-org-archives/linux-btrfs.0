Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525A2282F00;
	Tue,  3 Mar 2026 18:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772560881; cv=none; b=YFT/IXOJeyxW+x5dOPua/RB57le08Ur2a1zLT0+iQVAAUgM6V0Lrz5B2yCeOYX6FjGUr4LilGnuM8EBGOCwUDX271UL+2fxQjidXX0h77WCDlU+VnRGSld4aXUIsVRDpnB7KXyE/imptTvhIwQsdZcOpGD0glYZwnuBe/pxhx/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772560881; c=relaxed/simple;
	bh=qYnqoXxXOg6JaTgMCBUjttFbtUJ8Qnw29IsPtVRNK6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0zJ1rUmb/c3M26XjFcZ4fh49PuhOJ/Oxs778hLNtHGtsKPwJ7fQSTdk0IaemtHHZkKmBkesokVkqj4gZqxF03I+evabzEb23mpKZK4pL0ttoUaDqIkjeP75nZ3D5WneAQlV9WgIjs1m7K/7oBRm8394cCeIJkFc2sYYDRvvzs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Im4MK2Fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Im4MK2Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04C0C116C6;
	Tue,  3 Mar 2026 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772560881;
	bh=qYnqoXxXOg6JaTgMCBUjttFbtUJ8Qnw29IsPtVRNK6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Im4MK2Fvkd7QkoH/2D9lFTVxpr/SpcXsbvnJRn7pQD1TyGs0Kq65kZEszUariLZ0d
	 oZbljJ6G965IItSR/VILFQk1ogO4kpXibvnkUOIkaq2X4l2QW2pEouW28/VCXUlnvd
	 lkZ7h5wP3Rzf607Dg+ie8LMLuZKAK8yBmgKtFEzpr7NKrYuOGTRNOYVJIiScD89Tjg
	 dClJ7E2RnFATtHkQPWcC8ZklRrqg2AMMc813YpleWuTa58Askol/he2ymqNFuZ1RlD
	 3e6UfZf6U4S5K79DMfJY5hGiBjVmsjLQJ6z60i/0t06mQBWN8jg3f/c8MRcmz62yND
	 o1Qo46Vis1RTw==
Date: Tue, 3 Mar 2026 10:01:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: test a directory fsync scenaro after replacing a
 subdir with a file
Message-ID: <20260303180120.GF13843@frogsfrogsfrogs>
References: <8e3c1626b6e49678976db67a861cb5dcfdb532c0.1772558357.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e3c1626b6e49678976db67a861cb5dcfdb532c0.1772558357.git.fdmanana@suse.com>

On Tue, Mar 03, 2026 at 05:20:10PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test a scenario where we remove a directory previously persisted, create
> a file with the same name and parent directory, create two directories in
> the same parent directory, create a hard link for the new file in one of
> the new directories, fsync the directory with the hard link and fsync the
> parent directory. After a power failure we expect both directories to be
> persisted as well as the new file and its hard link.
> 
> This exercises a bug on btrfs fixed by the following kernel patch:
> 
>   "btrfs: log new dentries when logging parent dir of a conflicting inode"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/generic/790     | 69 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/790.out | 12 ++++++++
>  2 files changed, 81 insertions(+)
>  create mode 100755 tests/generic/790
>  create mode 100644 tests/generic/790.out
> 
> diff --git a/tests/generic/790 b/tests/generic/790
> new file mode 100755
> index 00000000..a25203a1
> --- /dev/null
> +++ b/tests/generic/790
> @@ -0,0 +1,69 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 790
> +#
> +# Test a scenario where we remove a directory previously persisted, create a
> +# file with the same name and parent directory, create two directories in the
> +# same parent directory, create a hard link for the new file in one of the
> +# new directories, fsync the directory with the hard link and fsync the parent
> +# directory. After a power failure we expect both directories to be persisted
> +# as well as the new file and its hard link.
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
> +. ./common/dmflakey
> +
> +_require_scratch
> +_require_dm_target flakey
> +
> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: log new dentries when logging parent dir of a conflicting inode"
> +
> +_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> +_require_metadata_journaling $SCRATCH_DEV
> +_init_flakey
> +_scratch_mount
> +
> +mkdir $SCRATCH_MNT/foo
> +
> +_scratch_sync
> +
> +rmdir $SCRATCH_MNT/foo
> +
> +# Create two new directories in the same parent directory as the new file.
> +mkdir $SCRATCH_MNT/dir1
> +mkdir $SCRATCH_MNT/dir2
> +
> +# Create a file with the name of the directly we deleted and was persisted
> +# before.
> +touch $SCRATCH_MNT/foo
> +
> +# Create a hard link for the new file inside one of the new directories.
> +ln $SCRATCH_MNT/foo $SCRATCH_MNT/dir2/link
> +
> +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/dir2
> +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/
> +
> +# Simulate a power failure and then mount again the filesystem to replay the
> +# journal/log.
> +_flakey_drop_and_remount
> +
> +# We expect to see dir1, dir2, file foo and its hard link, since dir2 was
> +# explicitly fsynced as well as the parent directory.
> +echo -e "Filesystem content after power failure:\n"
> +# Exclude 'lost+found' dir from ext4 and last line if it's blank (due to removal
> +# of 'lost+found').
> +ls -R $SCRATCH_MNT/ | grep -v 'lost+found' | sed -e '${/^$/d;}'
> +
> +# success, all done
> +_exit 0

This all looks good to me, except that...

> diff --git a/tests/generic/790.out b/tests/generic/790.out
> new file mode 100644
> index 00000000..d2232a19
> --- /dev/null
> +++ b/tests/generic/790.out
> @@ -0,0 +1,12 @@
> +QA output created by 790
> +Filesystem content after power failure:
> +
> +/home/fdmanana/btrfs-tests/scratch_1/:
> +dir1
> +dir2
> +foo
> +
> +/home/fdmanana/btrfs-tests/scratch_1/dir1:
> +
> +/home/fdmanana/btrfs-tests/scratch_1/dir2:

...^^^^^^^^^^^^^^ you might want a _filter_scratch for that.

--D

> +link
> -- 
> 2.47.2
> 
> 
