Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACE533993;
	Tue, 24 Mar 2026 20:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774385399; cv=none; b=M2AuYZZcC2Q+07xSlA1fpedFOvNINRgd7AUrRPGpocQQMk60vkwmVUPD6Z830dY2jgplVp6HU07CVwKMhPuV5DjmZZ5extTaol1/+ol9XCuSYbrIA4GLjqphOysV3RjAx2f5C7Z9035ldvWrmxXCCAIGfkVpPEOUccQ2MtSBD0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774385399; c=relaxed/simple;
	bh=UESoM1y/6Tp3mZhO3f0SYsRXBydhN1gjkqTOMDzhPbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmLyZ6qBGWpOYh/+NEyZesqK07ss8b9EcZCfRREJUnS4rwlQB+YhfR3nTF9VJUAUPxiLD5FY42zwMwSdTBSpc2Ld+xbaMcF6fBi58oaExKuqCyuKWwZaB3wBdnYOch+RDjSuen+NRTvzRmq6xDygpPgEmrKeA81Asz3SQMTHYo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lq6irA5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lq6irA5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A4EC19424;
	Tue, 24 Mar 2026 20:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774385399;
	bh=UESoM1y/6Tp3mZhO3f0SYsRXBydhN1gjkqTOMDzhPbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lq6irA5gZcMAXo2pru7kmWFxh06kKMRHJ0WTxlusA7KnIY5i8kIDEZ9jIB3+hpyda
	 x4QbqxUXEkVKF/FQNlublHdSyEfGvZ2mkoJxt3AUCjgVI7WYwqHpSA74guKrCE5i0p
	 Z8ms02rHJ1eJ6KVuQwXrg5rE99yIy5VBG+ajdGiXh/NK7FHofxXaiVvTAVmt78VOWO
	 0t1p3uKGPLI53EVfhQia1F1EDb+144Bl5cTOjdudWfnuwLzVckmo0yjnRhlC8xg+Cl
	 dGv83+3/x35CpJ6BmaShqazq8ZzH9OMOOav6Yf7johq0+9QDjW3RbWT+tM+CF69hqx
	 omxLjRVMJ7z3Q==
Date: Tue, 24 Mar 2026 13:49:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Leo Martins <loemra.dev@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
	fstests@vger.kernel.org
Subject: Re: [PATCH] generic/301: skip extent count check on btrfs
Message-ID: <20260324204958.GD6212@frogsfrogsfrogs>
References: <c56960b514baf810f2929b5e955a966d9955c468.1774383226.git.loemra.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c56960b514baf810f2929b5e955a966d9955c468.1774383226.git.loemra.dev@gmail.com>

On Tue, Mar 24, 2026 at 01:40:00PM -0700, Leo Martins wrote:
> The 2/3 fragmentation threshold was designed for XFS's cowextsize
> mechanism and is not applicable to btrfs. After commit 0dc118b3c327
> ("btrfs: be less aggressive with metadata overcommit when we can do
> full flushing"), btrfs commits transactions more frequently during
> writeback, reducing the extent allocator's opportunity to coalesce
> adjacent CoW extents. This causes the extent count to sometimes cross
> the threshold, making the test flaky on btrfs.
> 
> Skip only the extent count assertion for btrfs while keeping the CoW
> write + remount + md5sum data integrity checks, which remain useful.
> 
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>

Seems reasonable to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/generic/301 | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/generic/301 b/tests/generic/301
> index 0303f25d..985d943a 100755
> --- a/tests/generic/301
> +++ b/tests/generic/301
> @@ -62,7 +62,12 @@ new_extents=$(_count_extents $testdir/file2)
>  echo "old extents: $old_extents" >> $seqres.full
>  echo "new extents: $new_extents" >> $seqres.full
>  echo "maximum extents: $internal_blks" >> $seqres.full
> -test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"
> +# btrfs CoW extent allocation depends on transaction commit frequency and
> +# metadata reservation behavior, so the 2/3 fragmentation threshold (designed
> +# for XFS cowextsize) is not applicable.
> +if [ "$FSTYP" != "btrfs" ]; then
> +	test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"
> +fi
>  
>  # success, all done
>  status=0
> -- 
> 2.52.0
> 
> 
