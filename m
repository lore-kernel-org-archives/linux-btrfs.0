Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FAF31F9B3;
	Sun, 10 May 2026 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778440170; cv=none; b=No4jY4FGUaqS/yaOzkWUdVJZlY0a7N2UFRVbSxcsgIgfpVUSe49jS9ZZKZRYhHZ7O6qDDIQgB/4oHNTB8md+XGzyie14Yw2PVfxtnaKP7/voYKK1HV4lISjG4mJzTBmMJizj5C8pM3dKZKWDub59CXQ/YIdhgMT2xQ/To2pL8pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778440170; c=relaxed/simple;
	bh=UJ/kxMV3flCtB3S3IeaRRcSBsHYHQnm9Zz/A2+yh5Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABdDLuQEBphrwZCNPA79s01bugD2kIvkRBMKQMX6Eai+RW+iMYe74aW2wpcpkZm9panzC2zeXzNAARn+vVDBi+Bty1wGOifv/qBL0Y9IDm1BSIAdlnRa3ZGGFsqRJF33KfnwRk8JyAAAJFhyo/l12nB/7lyLxq1fzpSS0G+wjc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMdlqbLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMdlqbLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99115C2BCFC;
	Sun, 10 May 2026 19:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778440169;
	bh=UJ/kxMV3flCtB3S3IeaRRcSBsHYHQnm9Zz/A2+yh5Ag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MMdlqbLXc/DynQjHxv3rGf6mPG7hrfRknZd6jStK/VTMJZHLIbPGt37bsuUBamRFw
	 2qHHkcnzpG8lGeB7p/c/Sqw2mH5udctJPueFDQFZ8lcDhYDODr5S7C4KEKY11xtRzx
	 UCvrx5VrYOmZ2k6ro90weiHtM7EyLkmPsGRcp9IFmrgKsl+5VNnc+tvfG0/iSoO7T4
	 ehYO4dMMtMcFuFHb9hldlnoKXI1zk5NWXq+boVCA3E5Axl0/SGJyCk+p36/t6x8/ru
	 IhwKoxLi2qKDAHnqBNAs+BMFFmY9ph5Z1a9hb8r3IRcD/KGYOiULP6eQJMujwKBJBe
	 0k87GtyGf2/6A==
Date: Mon, 11 May 2026 03:09:24 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] fstests: support new mkfs.btrfs help string
Message-ID: <agDVg6UXhP4DoKK_@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20260510001704.68396-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510001704.68396-1-wqu@suse.com>

On Sun, May 10, 2026 at 09:47:04AM +0930, Qu Wenruo wrote:
> [BUG]
> The latest btrfs-progs release v7.0 breaks a lot of tests, e.g.
> btrfs/003:
> 
> btrfs/003    55s ... [failed, exit status 1]- output mismatch (see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad)
>     --- tests/btrfs/003.out     2026-05-09 03:07:52.952213772 +0900
>     +++ /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad     2026-05-09 23:32:17.595751435 +0900
>     @@ -1,2 +1,3 @@
>      QA output created by 003
>     -Silence is golden
>     +mkfs failed
>     +(see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.full for details)
>     ...
>     (Run 'diff -u /home/kts/kernel-test-suite/src/xfstests/tests/btrfs/003.out /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad'  to see the entire diff)
> 
> [CAUSE]
> Commit ec8324cc4b8b ("btrfs-progs: help: adjust alignment of text") from
> btrfs-progs changed the helpe string output format, the previous help
> string for "-f" option of mkfs.btrfs looks like this:
> 
>     -f|--force                force overwrite of existing filesystem
> 
> There were 4 spaces before the "-f", thus can be matched by
> "[[:space:]]-f[[:space]|,]".
> 
> But now the help string looks like:
> 
> -f, --force               force overwrite of existing filesystem
> 
> Which removed the spaces at the beginning.
> 
> The existing regex to catch "-f" requires at least one space before
> "-f", now it doesn't match the new btrfs help string, and cause mkfs
> failure because we can not overwrite an existing scratch device without
> "-f" option.
> 
> [FIX]
> Change the regex to allow no space before "-f".
> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Link: https://lore.kernel.org/linux-btrfs/af9EHC5b-aBdr1zn@shinmob/
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  common/config | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/config b/common/config
> index 1420e35d..339f7767 100644
> --- a/common/config
> +++ b/common/config
> @@ -103,7 +103,7 @@ set_mkfs_prog_path_with_opts()
>  	# Note: mkfs.f2fs doesn't support the --help option yet, but it doesn't
>  	# matter since it also prints the help when an invalid option is given.
>  	if [ "$p" != "" ] && \
> -		$p --help |& grep -q "[[:space:]]-f[[:space:]|,]"; then
> +		$p --help |& grep -q "[[:space:]]*-f[[:space:]|,]"; then

Hi Qu,

This change looks good to me. But to be a bit nitpicky, the original
"[[:space:]]-f" required *a* mandatory [space] before the -f, whereas
"[[:space:]]*-f" allows for *zero* or more spaces. This changes the
semantics slightly, but it makes sense if you're trying to match cases
where -f appears at the very beginning of a line.

If that wasn't your intention or if you find this behavior unexpected, let me
know :) Otherwise, I'd like to:

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  		echo "$p -f"
>  	else
>  		echo $p
> -- 
> 2.51.2
> 
> 
