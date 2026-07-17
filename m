Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38783890EF;
	Fri, 17 Jul 2026 20:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784319565; cv=none; b=bBPlxRKdBGj6n71QnXf+jCqXdQpoVhY24ZfVbGMugp4gMAyue5728twv2eqT5kaiay5hn2Hu7J8s85Po3X6Cvdj1LYrY/gg9zdx8hJdU9+7BTcsrNicTo6vgJFR7q0mu4QOyzLDtL+A5sVxA9VGOd4xkB77d8VRxKgjx8+8dojk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784319565; c=relaxed/simple;
	bh=nQSzkIaSW8QzyrsLMgKcH7jhsBlah+NRAkip2KcthAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fi7FB6BIRhQ9gOyFn8hxmekNO2rTAciptFxKb5afygcWdp0ODT7D1kP+pJji6YFt7r77J5Wdv3c2T87w1GzcpfHo9m/nfk+vMPJtg+ljLSGjjc9dYYIXXq7blJCwAjc0T5BCVepc+tNlY+YqAFD2a73QKcEerdDmDYKlOJBt4mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=FEwwJ5J/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OO/iPXsw; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="FEwwJ5J/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OO/iPXsw"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 5356F1D0011A;
	Fri, 17 Jul 2026 16:19:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 17 Jul 2026 16:19:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784319558; x=1784405958; bh=XwWhpKe+zg
	oCPc+X2dDWX0mC4YEUiVRkJqlgHL92Ub4=; b=FEwwJ5J/eK4+rkG8ttDrnvDl69
	0wW+VngOCC3NSGovdv9ipqd0Vygamnx2KdjUKFnr59OFjOm86NjFvYD2uW7R3Bit
	SmOAQ0653DgTy+G6NHwvo7zUkelIl1SaowjTMVg+znO/TV9Fo3T8X4KsCA73bLt5
	pI2CfiYsjclJLbfXuX3Azkj3HXqtM4s1dkzwFzApsMrZ2ewn/b0RdulwKqv5zJnP
	TKCoFKefMwgMAU1UJLTwOE/5PqlpZxzjS/uAdFiimuO/GK5e7SyLUJManLanst5R
	z5SLCnmN35d3d8FYMBFDY4apHpb8Ni+kw6NIVtbuAcFgR3diB3eyXIX895VA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784319558; x=1784405958; bh=XwWhpKe+zgoCPc+X2dDWX0mC4YEUiVRkJql
	gHL92Ub4=; b=OO/iPXswkwX0QnYyewJnfM4T2U+KRcPE2Wl5ouObqRTSflV8DW3
	olivurzwQ6z79jfT4HecCsvLTuySw+AjRlcMqidG0GCd9kCK42dWUlF7ke5Fcn7k
	dvhMNZJGizL8CN93xImZCq5yc47+01kt/Re/QZ6695Pth9sHvBP249kD+e9km9K1
	XiI6DyilH/DmGe4wcQtqH6XqT/SqknGTJbtyIP0PmaPA4loVHURCfzPNR3sOMQq/
	ke9pkWFJlHkZusiUnXCSSErjzc8k9QhqtAcG7z/jWtlq8hC9EtGinxCpLM9pLvVh
	azwXMRUpv0fBLuejpmOgQLC99N61ZjYevKw==
X-ME-Sender: <xms:Ro5aap0-ptsfpitivo3Utolob7_UVkNcQIXm3piarn2o4qjPiYAOZg>
    <xme:Ro5aan06kKlkx-GDuzRNE4pAleI67cMAYPDF_pzG721Ylav3Th-UgSwcQZxu54HAW
    zELJ1-a9KZYaNbF6FCnL78QVtXqEupgBcIoocFLdEZLtQSh_etKC20>
X-ME-Received: <xmr:Ro5aas-wkoLx5DCnI_EZLKZXHnhRQw4iOzbl9Lug9-iaIaQ4m8oYCohL4dP1ciILGVEmpYjW-C0_WjjpP9Ar8F7FyBw>
X-ME-Proxy-Cause: dmFkZTEp4VLN8UNatxjtjNlXDw615hXCDJXjEmAyUzet/LRA+2UxfLLbcFMZlLIepOi46m
    vQd+o3RLDS7L0SabDxla/wPUb+OgzyjwAvO+CHOjK0oAvpnGKN/0Wlnx3xG1UhpAsXqtv5
    TIc/soGpVwrMq+wH7OhndGU54lHK8AJ8UUW/iM0lmrf0GlVTwZPnKRnvOcqpB0Jko69BCq
    eJrvOrABlZDAm+IzgUtHACR6QVIs2IDG5LsefZULpsyGvSLhTf6o1s93MMkse01CwhFCgE
    kRpMvqZE+o6FOZ8jvJxGI+q1Y2TYoS+TRpGs3PJTH8L05gJNikKijJGfJu4S1ViFZVpWNA
    RTHVIEG6Yv79AisuFGKZE66cdk7kgZ+u9dJ/Q2zbgJEQxsCBEPvMiqVcULZLU5ffFiCaKI
    kGY5cBRQbcSikh9AewgWllgYhriSDxV73rk/xucju78MI8ra+Y3uskThwmTJ5FuZ+lOKfw
    xfI4RDWlkRMMgyQSsz4gDzAV4+P6Y1MSDYA/vC0EfR7j3rlR339uiYrh7afVe09NDbQgMj
    86xYLTXbzBME5r6/Fr4QHhhjTBi6OgLEC9QwJnGV8CMh08GzXqST1Hetiqqk45fBVGmDoa
    e+1ks72rsZRMZEDKig2w4T5+7i08/icvZZHKK9yhppSfKxQ2K5+p8HniTu3Q
X-ME-Proxy: <xmx:Ro5aak3DtO6k80vfKRW0heXi2IEvJ7U1AsX8U4lipLm0CpErcAq72A>
    <xmx:Ro5aap9fPUljNvGZAH9uHuMszN8YzHNXItv5Mu_CGCXHMO91A053hg>
    <xmx:Ro5aaktRzb4hLRJ0fQK9JPcsmr_HupRXLUx5pZaHTk2PehNYYaVlnA>
    <xmx:Ro5aasAMgx3cVp29JJ3wRe4sbCfVmbaaWnTAWZfzVd5qzzOm9Q4Ibw>
    <xmx:Ro5aatknAwKoQ9c0wH5BvpXtz-FhFmSla7bA4J7naBXUHwUF0eUzPrGn>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Jul 2026 16:19:17 -0400 (EDT)
Date: Fri, 17 Jul 2026 13:19:16 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: vfstest: skip rejected tmpfile creation
Message-ID: <20260717201916.GC142812@zen.localdomain>
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
Reviewed-by: Boris Burkov <boris@bur.io>
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
>  			errno = 0; /* Don't report misleading errno. */
>  			return false;
>  		} else {
> -- 
> 2.51.2
> 
