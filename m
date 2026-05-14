Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9282B18AE2;
	Thu, 14 May 2026 03:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778729646; cv=none; b=aaWZKV3EXn+H4kzIwiTscG/z6RI8vAu+6nBoanhZVdLhdhEOpd5x5bB3O5eYtPYuDJ3EJ9Rdo/STZIXiKwEs84SQ9Ftt9kK8CmQfVi2PLEwwGiEKuuwldXfRor5lqMlAjedcgeXELryARJ+yK5BfzsMkAPRGHwcBKdRZ6gHCuKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778729646; c=relaxed/simple;
	bh=bcLFVpIzcU+gZWmvv+bBkbPDwqqNJf749D7HwWyWftg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E+fiy4axvz2M9S5SsGHVDbP9495V4ngG96Grit2Fp7MbOam5KgC4KaTgXcWoHs7lu6tzFDZ8mYWayAlugP7GLi8io1E5721LxzCNl1GnJus1eFZUJumnb8pxU6UeCclswnOoYG5uL6pW6Dc8aBANq5efyvyU2ZljGM6wgbw0kNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKXIdmjp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKXIdmjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26C7C19425;
	Thu, 14 May 2026 03:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778729646;
	bh=bcLFVpIzcU+gZWmvv+bBkbPDwqqNJf749D7HwWyWftg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fKXIdmjpFH22ZHcnxOSpQKotIW0ESWvWuOA2IdRLaxUCR4w2o12pngiRsHAzFXBgV
	 JuAl5Cd7pyswO1uM9OrA1BWFEgkuX/rS8PQ52DKbRv4oQbBczj/sG6lsZ9uVm4BBG7
	 XWjfW07RuywG9UjM8anqhd98DBHK2TllHjLxQ6DSQQ3M0gT7AxOeXQ4uMTz+v65ggl
	 5bODUwEfa9sGyqfNXnOR1BcBCx5GK7SyvvhYT1BYDl3L0Dtyb6+bQ0zlOqykeScyg3
	 wP922Tsv+KxeAz4GWeHnTElGoMdLHTFEeg0D6K7IoL41xy3jkeWokxIlNtaD0Qo+v5
	 ff+5u+URSMQeg==
Date: Thu, 14 May 2026 11:34:00 +0800
From: Zorro Lang <zlang@kernel.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, 
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: inline enable_quota helper in test 301
Message-ID: <agU-k5OnlkvcLiFB@zlang-mailbox>
Mail-Followup-To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org, 
	kernel-team@fb.com, fstests@vger.kernel.org
References: <cover.1778632843.git.boris@bur.io>
 <3234af372b0f16511aa5856aa7a3a0ca28397fcb.1778632843.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3234af372b0f16511aa5856aa7a3a0ca28397fcb.1778632843.git.boris@bur.io>

On Tue, May 12, 2026 at 05:43:33PM -0700, Boris Burkov wrote:
> The enable_quota helper in btrfs/301 takes a mode argument ('n', 's',
> or anything else) to switch between "no quota", "simple quota", and
> "full quota" enable.  Only the simple-quota path is ever exercised by
> this test, so the dispatch is dead weight and the indirection just
> obscures the actual btrfs command being run.
> 
> Inline the two call sites to call 'btrfs quota enable --simple'
> directly and drop the helper.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---

Hahah, to be honest, the title '[PATCH 0/2] squota delete fstests' gave me
a minor heart attack. I thought it was a critical bug report about fstests
accidentally deleting itself while running :-D

>  tests/btrfs/301 | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/tests/btrfs/301 b/tests/btrfs/301
> index 1f72a97b..31243aab 100755
> --- a/tests/btrfs/301
> +++ b/tests/btrfs/301
> @@ -169,16 +169,6 @@ do_enospc_falloc()
>  	do_falloc $file $sz
>  }
>  
> -enable_quota()
> -{
> -	local mode=$1
> -
> -	[ $mode == "n" ] && return
> -	arg=$([ $mode == "s" ] && echo "--simple")
> -
> -	$BTRFS_UTIL_PROG quota enable $arg $SCRATCH_MNT
> -}
> -
>  get_subvid()
>  {
>  	_btrfs_get_subvolid $SCRATCH_MNT subv
> @@ -198,7 +188,7 @@ prepare()
>  {
>  	_scratch_mkfs >> $seqres.full
>  	_scratch_mount
> -	enable_quota "s"
> +	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT
>  	$BTRFS_UTIL_PROG subvolume create $subv >> $seqres.full
>  	local subvid=$(get_subvid)
>  	set_subvol_limit $subvid $limit
> @@ -421,7 +411,7 @@ enable_mature()
>  	# Sync before enabling squotas to reliably *not* count the writes
>  	# we did before enabling.
>  	sync
> -	enable_quota "s"
> +	$BTRFS_UTIL_PROG quota enable --simple $SCRATCH_MNT

This change doesn't seem related to patch 2/2. I think we can review
these 2 patches separately.

For this patch, I'm fine with or without it. If the btrfs list prefers
to have it, or move it to be a common helper, I'm good with that.

Thanks,
Zorro

>  	set_subvol_limit $subvid $limit
>  	_scratch_cycle_mount
>  	usage=$(get_subvol_usage $subvid)
> -- 
> 2.54.0
> 
> 
