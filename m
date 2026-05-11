Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD83A1624D5;
	Mon, 11 May 2026 00:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778460479; cv=none; b=HNi9gFX5FGQVUikEGhAJOhYRwn4eQsbUrGr/UUeaM5s1aZAQ0g49Bu3Kohw8287ebGT3DOsvDaYXCEM6G5Eb2qohz8kLTvFQwp4hvLpERLjwlNHSSPpw+kLKf6E2pnw16elmSwuRfMHvp1zRdHrAsU+JM3NCe8kCeDfcFSEcpps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778460479; c=relaxed/simple;
	bh=6IdC639V1/YoZSJDa8M4QfeT0oFxAaEfW2S6jZLbpEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RrTKOGITkXd9rSjBLY8r1/KhEshDnC8hD0BMfkzfWTUHgISDPHt9h4r1T8x09rUiM64aBLnaK0wgxdW6wdL4TCoBJ0hqKQjmALViif952etnxCThW6f8igluewM2howfSpfTaGUkf6wsYaCGGvkhMYw0vsCaSaTyWt0HAiEFElE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dq0DrKjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dq0DrKjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28385C2BCB8;
	Mon, 11 May 2026 00:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778460479;
	bh=6IdC639V1/YoZSJDa8M4QfeT0oFxAaEfW2S6jZLbpEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dq0DrKjNkRHm5F3mXdSwWuQImUC6Ku2Bq2c6O64PttJc63007m1V4UMNGdHhT/U69
	 4ZSnzFu93umSIMeMX1mF3+iBzJw1h7eOW8cVmCv1DmyoRVeOUmqoYhfK6RkN+GhCOI
	 HCUvipTo9zyjB3D24n0UFkxHjSMA+W/TvJsTqvkEMkZOYBjLEYGQ3nHAZtfbN39vbk
	 VwqnYbgkiGjCvTwpwK7RoR1E/IIftEWJManx4eDT64kI7Glm3eYVhDgn2BK/kwPhCN
	 Tc/rnjACcMEjHcgYCOt4jIT9ieYHZnRxbat9VIA+7Yo5lQ1vX3fEfQWDX9PAjcEhM5
	 awJsh/9hoLvhw==
Date: Mon, 11 May 2026 08:47:53 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] fstests: support new mkfs.btrfs help string
Message-ID: <agEmk7jbaoKi179R@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <quwenruo.btrfs@gmx.com>, 
	Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20260510001704.68396-1-wqu@suse.com>
 <agDVg6UXhP4DoKK_@zlang-mailbox>
 <b66eb427-bc17-4463-ba3b-a5ef3fa4a317@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b66eb427-bc17-4463-ba3b-a5ef3fa4a317@gmx.com>

On Mon, May 11, 2026 at 07:18:44AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/5/11 04:39, Zorro Lang 写道:
> > On Sun, May 10, 2026 at 09:47:04AM +0930, Qu Wenruo wrote:
> > > [BUG]
> > > The latest btrfs-progs release v7.0 breaks a lot of tests, e.g.
> > > btrfs/003:
> > > 
> > > btrfs/003    55s ... [failed, exit status 1]- output mismatch (see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad)
> > >      --- tests/btrfs/003.out     2026-05-09 03:07:52.952213772 +0900
> > >      +++ /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad     2026-05-09 23:32:17.595751435 +0900
> > >      @@ -1,2 +1,3 @@
> > >       QA output created by 003
> > >      -Silence is golden
> > >      +mkfs failed
> > >      +(see /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.full for details)
> > >      ...
> > >      (Run 'diff -u /home/kts/kernel-test-suite/src/xfstests/tests/btrfs/003.out /home/kts/kernel-test-suite/src/xfstests/results//btrfs/003.out.bad'  to see the entire diff)
> > > 
> > > [CAUSE]
> > > Commit ec8324cc4b8b ("btrfs-progs: help: adjust alignment of text") from
> > > btrfs-progs changed the helpe string output format, the previous help
> > > string for "-f" option of mkfs.btrfs looks like this:
> > > 
> > >      -f|--force                force overwrite of existing filesystem
> > > 
> > > There were 4 spaces before the "-f", thus can be matched by
> > > "[[:space:]]-f[[:space]|,]".
> > > 
> > > But now the help string looks like:
> > > 
> > > -f, --force               force overwrite of existing filesystem
> > > 
> > > Which removed the spaces at the beginning.
> > > 
> > > The existing regex to catch "-f" requires at least one space before
> > > "-f", now it doesn't match the new btrfs help string, and cause mkfs
> > > failure because we can not overwrite an existing scratch device without
> > > "-f" option.
> > > 
> > > [FIX]
> > > Change the regex to allow no space before "-f".
> > > 
> > > Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > > Link: https://lore.kernel.org/linux-btrfs/af9EHC5b-aBdr1zn@shinmob/
> > > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > > ---
> > >   common/config | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/common/config b/common/config
> > > index 1420e35d..339f7767 100644
> > > --- a/common/config
> > > +++ b/common/config
> > > @@ -103,7 +103,7 @@ set_mkfs_prog_path_with_opts()
> > >   	# Note: mkfs.f2fs doesn't support the --help option yet, but it doesn't
> > >   	# matter since it also prints the help when an invalid option is given.
> > >   	if [ "$p" != "" ] && \
> > > -		$p --help |& grep -q "[[:space:]]-f[[:space:]|,]"; then
> > > +		$p --help |& grep -q "[[:space:]]*-f[[:space:]|,]"; then
> > 
> > Hi Qu,
> > 
> > This change looks good to me. But to be a bit nitpicky, the original
> > "[[:space:]]-f" required *a* mandatory [space] before the -f, whereas
> > "[[:space:]]*-f" allows for *zero* or more spaces. This changes the
> > semantics slightly, but it makes sense if you're trying to match cases
> > where -f appears at the very beginning of a line.
> 
> That's exactly my intention.
> Also explained in the commit message:
> 
>    The existing regex to catch "-f" requires at least one space before
>    "-f", now it doesn't match the new btrfs help string,
> 
> And
> 
>    Change the regex to allow no space before "-f".

Great! I agree that's a proper change.

> 
> Thanks,
> Qu
> 
> > 
> > If that wasn't your intention or if you find this behavior unexpected, let me
> > know :) Otherwise, I'd like to:
> > 
> > Reviewed-by: Zorro Lang <zlang@kernel.org>

Merged.

> > 
> > >   		echo "$p -f"
> > >   	else
> > >   		echo $p
> > > -- 
> > > 2.51.2
> > > 
> > > 
> > 
> 
> 
