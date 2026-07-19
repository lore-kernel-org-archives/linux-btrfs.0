Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A454A23392B;
	Sun, 19 Jul 2026 07:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784445622; cv=none; b=tF/8j1FfuPGO+89YuZ6OGciM0zEjHjK+E+7pwKFnCV/WFzaWfsCtrkj9WNm+0Qw6Xa40kLC/THpgcJt6mrCwB9YYrfZSwpRiv0y1IYhEHVfvpFw+tXraJu065m43lnyMc1xhiuTe4AlhB1sL7J25+3hmWD2QiSHjTY40p/Ba0ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784445622; c=relaxed/simple;
	bh=ihqCwc5lF10ZMzVZDDjIcmYOUA0c0wRWsEGQyDu/+yI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szqNqIe5f7JnHvtCBSJ3h6ttgxmLHBvaoxKyicxBdu+5eqHLL/6eCYgy85ZLsQaKLCkqUxBZilv4spjwyXNwB5qCsSQGAwf0c4ZKljViuH32FKc/N/7qNGzWeMYX6Ce3iFbtEjT4OH6Mp3xwo/MJ64PoeiNYEMca0hUYQqMvMCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BVbElCXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVbElCXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75881F000E9;
	Sun, 19 Jul 2026 07:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784445621;
	bh=DyEISnD4tl7ul1ilAyDrv7bm2CbkvMboXiZsF44xkSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BVbElCXIUXcTTR/2A2RDmUn+FTPPOGBi2utUQ37TzaPJCfV8U+ltj8OZ7SxfCo8Zm
	 QViesd8tmxKW4lgzWe6us2V1jCEBpvBMG5WHf75yramq8hoNXSpvNf/FM45T+5dUfa
	 rsAUTJEflruy20t+UN4dgFfW9HZNroDJHzckZysCoDmzyE60FXpyWEqm4RDp+1RLpv
	 0Lq24wZoPQSxXdcx41h9W1TQwY5DT10lEdPZfdbIdLdLsD8kZLeV1PsKain1AKAzo4
	 TyThSccGJLtCtUYVxzD23HvZ7eCdEAuwEuM4twA4YHOfIxR+th9PpDR/KA15xS0Tgh
	 dROjiTvXb5tHA==
Date: Sun, 19 Jul 2026 15:20:16 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: vfstest: skip rejected tmpfile creation
Message-ID: <alx6ksEGK_-FhFVM@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org
References: <20260717070717.113517-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717070717.113517-1-wqu@suse.com>

On Fri, Jul 17, 2026 at 04:37:17PM +0930, Qu Wenruo wrote:
> Since kernel commit 539dce114465 ("fs: refuse O_TMPFILE creation with an
> unmapped fsuid or fsgid"), tmpfile creation can be rejected with
> EOVERFLOW, so also skip that error number to avoid false alerts like the
> following:
> 
>  FSTYP         -- ext4
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.2.0-rc3-custom+ #411 SMP PREEMPT_DYNAMIC Fri Jul 17 16:24:34 ACST 2026
>  MKFS_OPTIONS  -- -F /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-scratch1 /mnt/scratch
> 
>  generic/633  1s ... - output mismatch (see /home/adam/xfstests/results//generic/633.out.bad)
>     --- tests/generic/633.out	2022-05-11 11:25:30.816666664 +0930
>     +++ /home/adam/xfstests/results//generic/633.out.bad	2026-07-17 16:25:45.033967541 +0930
>     @@ -1,2 +1,4 @@
>      QA output created by 633
>      Silence is golden
>     +utils.c: 948: openat_tmpfile_supported - Value too large for defined data type - failure: create
>     +utils.c: 948: openat_tmpfile_supported - Value too large for defined data type - failure: create
>     ...
>     (Run 'diff -u /home/adam/xfstests/tests/generic/633.out /home/adam/xfstests/results//generic/633.out.bad'  to see the entire diff)
>  Ran: generic/633
>  Failures: generic/633
>  Failed 1 of 1 tests
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  src/vfs/utils.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/src/vfs/utils.c b/src/vfs/utils.c
> index 0b435afe..d2922cc3 100644
> --- a/src/vfs/utils.c
> +++ b/src/vfs/utils.c
> @@ -941,7 +941,11 @@ bool openat_tmpfile_supported(int dirfd)
>  
>  	fd = openat(dirfd, ".", O_TMPFILE | O_RDWR, S_IXGRP | S_ISGID);
>  	if (fd == -1) {
> -		if (errno == ENOTSUP) {
> +		/*
> +		 * Kernel commit 539dce114465 ("fs: refuse O_TMPFILE creation
> +		 * with an unmapped fsuid or fsgid") will reject such operation.
> +		 */
> +		if (errno == ENOTSUP || errno == EOVERFLOW) {

Makes sense to me,

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  			errno = 0; /* Don't report misleading errno. */
>  			return false;
>  		} else {
> -- 
> 2.51.2
> 
> 
