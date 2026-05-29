Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FFD3BCD28;
	Fri, 29 May 2026 09:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780045833; cv=none; b=rXEBk3ddDIYdPLCDYjIEwnskgBTX3nzT3I7ys9HGirbPpNTiRbnlirI0bm2IUU4+4YThk9oEMMxh1bQbiDoie8+hNRgU/Ppx+kz/gAm3WsQZrakHYdsAJOTERzqJzAkrEpSo9jk5jGmnEJR0nQzpqXL7+CKmysTRrFi3Mzndi4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780045833; c=relaxed/simple;
	bh=aonlMLEVfcBpn4g/N1sjkROWm1yRsK4BfsZH2Y3X7ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hm2MeX59c9PUwwA6jsgtKqubALLpshzCC/B4JV6+8edyKDu6Qh2yDG1Mr8vo8Oa+E1JklM9KH7EaGFJwcqydn7YRAAKw4l/2qC+HoalGc2wZZ8dtCPu0yUn3oYbgOJFrU2zTyGlv8HzmYdivKyPUv+pjcpZNaTp2p8wt9v0qpS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHE32YUx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHE32YUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0CB1F00893;
	Fri, 29 May 2026 09:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780045830;
	bh=/Pz9iZO0lS1+ATvYXXbmcZ/4TYwA9EwI/hL63xMvjpc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MHE32YUxrZB5mQCbymiE7u8bFLjK2BcWM7Rl2ia6mWU6O9ewOPGdNuilAZ+fDSP+b
	 m4F1Gh7PcYd518YQZxczRQ0ZwfyPE/PFw+YlpMehg/mnHb/XH2cmeYxwQHRtzRnXmY
	 0UDLJfYT9Tk4ePUDa3UNu6HXU9sjgFvEGpRIMKQLRUO/+9kdXd8lVvr/yUWQYSVNvK
	 Ba7iGKUYI1wvYwhrXDjInkNRMph4C7q6cAkpUjAmtOiJtKWSYbLdDdWS0j621cTmMA
	 W5Ck9+BvQN54J+oIcEhIgxyStXOoiJqNztHu0XZOnYfICxOoIgUQ5id2l+9Yz08DY9
	 vD/fhBCipRI2A==
Date: Fri, 29 May 2026 17:10:24 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] fstests: remove dio related target file to respect
 mount options that only affecst new inodes
Message-ID: <ahlXBkOh3TF-3mRG@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <20260528111659.87113-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528111659.87113-1-wqu@suse.com>

On Thu, May 28, 2026 at 08:46:59PM +0930, Qu Wenruo wrote:
> [BUG]
> Test case generic/362 and generic/365 will fail with nodatasum, but
> that's only when TEST_DEV is newly formatted.
> 
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMPT_DYNAMIC Tue May 26 10:47:14 ACST 2026
>  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
> 
>   generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
>     --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
>     +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-28 16:18:33.866141979 +0930
>     @@ -1,2 +1,3 @@
>      QA output created by 362
>     +First write failed: Input/output error
>      Silence is golden
>     ...
>     (Run 'diff -u /home/adam/xfstests/tests/generic/362.out /home/adam/xfstests/results//generic/362.out.bad'  to see the entire diff)
> 
>   generic/364  11s ... - output mismatch (see /home/adam/xfstests/results//generic/364.out.bad)
>     --- tests/generic/364.out	2024-09-30 09:09:51.216666681 +0930
>     +++ /home/adam/xfstests/results//generic/364.out.bad	2026-05-28 16:18:34.318532257 +0930
>     @@ -1,2 +1,3 @@
>      QA output created by 364
>     +Fsync failed: Input/output error
>      Silence is golden
>     ...
>     (Run 'diff -u /home/adam/xfstests/tests/generic/364.out /home/adam/xfstests/results//generic/364.out.bad'  to see the entire diff)
> 
> But if one has formated TEST_DEV, run test with default mount option,
> then change the mount option to "nodatasum", the test will not fail
> anymore:
> 
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMPT_DYNAMIC Tue May 26 10:47:14 ACST 2026
>  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- /dev/mapper/test-scratch1 /mnt/scratch
> 
>  generic/362  0s ...  1s
>  generic/364  11s ...  10s
>  Ran: generic/362 generic/364
>  Passed all 2 tests
> 
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #381 SMP PREEMPT_DYNAMIC Tue May 26 10:47:14 ACST 2026
>  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
> 
>  generic/362  1s ...  0s
>  generic/364  10s ...  11s
>  Ran: generic/362 generic/364
>  Passed all 2 tests
> 
> [CAUSE]
> Btrfs' nodatasum mount option only affects new files, but the test cases
> are using TEST_DEV, and never delete the target files
> "$TEST_DIR/dio-append-buf-fault" for generic/362 and
> "$TEST_DIR/dio-write-fsync-same-fd" for generic/364.
> 
> So if the files are created with default mount options, then all later
> "nodatasum" mount options will not affect those files, thus hide the test
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

This patch is good to me,

Reviewed-by: Zorro Lang <zlang@kernel.org>

If you still hope to have a specific test case to uncover this known btrfs
bug, feel free to add a new one (to use SCRATCH_DEV and "nodatasum").

Thanks,
Zorro

> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Fix several grammar errors
> - Remove temporary files in _cleanup()
> ---
>  tests/generic/362 | 7 +++++++
>  tests/generic/364 | 8 ++++++++
>  tests/generic/418 | 7 +++++++
>  tests/generic/708 | 7 +++++++
>  4 files changed, 29 insertions(+)
> 
> diff --git a/tests/generic/362 b/tests/generic/362
> index 0cfaa726..e54d44b0 100755
> --- a/tests/generic/362
> +++ b/tests/generic/362
> @@ -10,6 +10,13 @@
>  . ./common/preamble
>  _begin_fstest auto quick
>  
> +_cleanup()
> +{
> +	cd /
> +	rm -f "$tmp.*"
> +	rm -f "$TEST_DIR/dio-append-buf-fault"
> +}
> +
>  # NFS forbade open with O_APPEND|O_DIRECT
>  _exclude_fs nfs
>  
> diff --git a/tests/generic/364 b/tests/generic/364
> index f7fb002f..8f13061f 100755
> --- a/tests/generic/364
> +++ b/tests/generic/364
> @@ -11,6 +11,14 @@
>  . ./common/preamble
>  _begin_fstest auto quick
>  
> +_cleanup()
> +{
> +	cd /
> +	rm -f "$tmp.*"
> +	rm -f "$TEST_DIR/dio-write-fsync-same-fd"
> +}
> +
> +
>  _require_test
>  _require_odirect
>  _require_test_program dio-write-fsync-same-fd
> diff --git a/tests/generic/418 b/tests/generic/418
> index 36789198..7ef1ef9f 100755
> --- a/tests/generic/418
> +++ b/tests/generic/418
> @@ -26,6 +26,13 @@ _require_block_device $TEST_DEV
>  _require_test_program "dio-invalidate-cache"
>  _require_test_program "feature"
>  
> +_cleanup()
> +{
> +	cd /
> +	rm -f "$tmp.*"
> +	rm -f "$testfile"
> +}
> +
>  diotest=$here/src/dio-invalidate-cache
>  testfile=$TEST_DIR/$seq-diotest
>  sectorsize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
> diff --git a/tests/generic/708 b/tests/generic/708
> index 827dac13..f504ca57 100755
> --- a/tests/generic/708
> +++ b/tests/generic/708
> @@ -14,6 +14,13 @@
>  . ./common/preamble
>  _begin_fstest quick auto mmap
>  
> +_cleanup()
> +{
> +	cd /
> +	rm -f "$tmp.*"
> +	rm -f "$src" "$dst"
> +}
> +
>  _fixed_by_fs_commit btrfs b73a6fd1b1ef \
>  		"btrfs: split partial dio bios before submit"
>  
> -- 
> 2.51.2
> 
> 
