Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DB0377ED4;
	Mon, 23 Mar 2026 22:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774306282; cv=none; b=MfKs8I8IIKqi9SpMasGihNt9T7qlCKKP3NclUzo7YE/0jQ6iGEZfQgq0s4lhbjNcFm5uh+lyN/O3afryEEjPwo3DO0H/ctAjAid5BsVAJOyUugXhMflE82eGqgtCxDcbfFzG2xhEHuYEEgztBuGNPpMfW5h5MOi2CiZUl34aP2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774306282; c=relaxed/simple;
	bh=hhZfqB+tDajyqOXd1zYqSaKTiKZ6dVwnBGEXGxxbygw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=panndpmbkXBa/BfMdX9x6VmY05mCVs77Z5elGk8tso8AAS2s3YjcdYyGbS3nVZT18r7v2a7BdGhYUcDhZOLPwy7zAAax4TjVgVnIe7PBGCL9+R0rvn3p6eDoPzLeGLfYGkqIfhm6VzPm5ZqLKEUH9kOumX6QP9Y15pc6hny8hWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iq9feWKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iq9feWKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D430EC4CEF7;
	Mon, 23 Mar 2026 22:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774306281;
	bh=hhZfqB+tDajyqOXd1zYqSaKTiKZ6dVwnBGEXGxxbygw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iq9feWKsZ5/u4Xe7PxCq+qawSI/ZQVBvR8mybACYfKaDblycy5MaSVJ4r/lXaSTYk
	 8Qkfv4zwQ/undV4Wv53oyG/FUN7Era3skw49QevrXv+Nr9CLB0XXLNlcbeWL+NNb4l
	 zRM8pIc38ZS4f0B5+EUGybgzwTBzhncY6djFDkzt/2z5BN7ajXxzQ7aI3aRLfeOh17
	 ZkMMnLKR+9XkqYe9Fe9KpLm2R0eMFSKztg51tb/eB2jt4IbH2f4m8Gv5A3aiZF0p3L
	 1/CMiK3cPiO6z3UDE2LOhDdXmxPV0EXk+wrdrh4cCXe1Wo+Et8ht94+ga4WdETE6Vt
	 CRwDHnjZXFAqw==
Date: Mon, 23 Mar 2026 15:51:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Leo Martins <loemra.dev@gmail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [RFC] generic/301: flaky failure on btrfs after metadata
 overcommit change
Message-ID: <20260323225121.GC6212@frogsfrogsfrogs>
References: <20260323201533.2648753-1-loemra.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260323201533.2648753-1-loemra.dev@gmail.com>

On Mon, Mar 23, 2026 at 01:15:29PM -0700, Leo Martins wrote:
> Hi,
> 
> generic/301 has become flaky on btrfs after commit 0dc118b3c327 ("btrfs:
> be less aggressive with metadata overcommit when we can do full
> flushing") which landed in btrfs/for-next. Out of 30 runs, 8 fail with:
> 
>     +file2 badly fragmented
> 
> I bisected this to the above commit, which reduces the metadata
> overcommit limit from 1/8th to 1/64th of available space for
> full-flushing contexts. This is a legitimate fix for -ENOSPC transaction
> aborts on small filesystems, but as a side effect it causes more
> frequent transaction commits during writeback. The reduced batching
> means the extent allocator has less opportunity to coalesce adjacent CoW
> extents, resulting in higher extent counts that sometimes cross the
> test's threshold.
> 
> The fragmentation check in question is:
> 
>     test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"
> 
> The 2/3 threshold was introduced in 9184ca155d7c ("xfs: test
> fragmentation characteristics of copy-on-write") as part of a series
> testing XFS's CoW extent size hint (cowextsize) mechanism. For btrfs,
> this threshold is arbitrary — btrfs doesn't have XFS's cowextsize hint,
> and its CoW extent allocation depends on factors like transaction commit
> frequency and metadata reservation behavior, which is exactly what the
> overcommit commit changed.
> 
> I see two possible fixes and would appreciate input on which is
> preferred:
> 
> Option A: _notrun for btrfs
> ----------------------------
> 
> Skip the entire test since the fragmentation threshold is not applicable
> to btrfs:
> 
>     test $FSTYP = "btrfs" && \
>         _notrun "CoW fragmentation threshold not applicable to btrfs"
> 
> Option B: Skip only the extent count assertion for btrfs
> ---------------------------------------------------------
> 
> Keep the CoW + data integrity portion of the test (the md5sum checks
> after random CoW writes and remount are still useful) and only skip the
> fragmentation assertion:
> 
>     if [ "$FSTYP" != "btrfs" ]; then
>         test $new_extents -lt $((internal_blks * 2 / 3)) || \
>             echo "file2 badly fragmented"
>     fi
> 
> I lean towards option B since the CoW write + remount + md5sum
> verification is still a reasonable smoke test, but option A is cleaner
> if the consensus is that this test isn't adding value for btrfs.
> 
> Thoughts?

B, since it's checking data integrity across a mount cycle.

--D

> Thanks,
> Leo Martins
> 
