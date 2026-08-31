Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFE53B19A6
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 22:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214441; cv=none; b=cFEO6kUSlbp6AMvj0eIb5jcjMu6WttDq1sq2seZSJsCYoLNgTTHRVa825fy2GIxFGN1YqNo5W46isVnjfzM7JowN1/oXips/JuNMF7tn//8os2MlHBqwQL8fZb+ca6md+OO1oBuXdDxfd44FDwhJ9jp3NtcGjSPwAimn+ruR2Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214441; c=relaxed/simple;
	bh=/80LJ9UCHBwrGA2DvT0oQXV8T/IHrVLlzspP+qOVE8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hh1tNX04SHCtRJHXj/cRIDu/9O2k/jZTjKQp7Mtf1f3bSEIIRMjReyu1lux8XTdnbyABqbL5Cd85Jzdm3b7UbQNpooUMhAxpQNA8cn0/umO4kGOt9MxDlFrGJuHAEGxbR49EV3NXGOuZ4xLYFrutqkCl/M/iJLdgWe/pdaGqPNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ehfvbcXs; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LhFqcfgo; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ehfvbcXs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LhFqcfgo"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 7B2E2EC0207;
	Mon, 31 Aug 2026 18:13:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 31 Aug 2026 18:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1788214439; x=1788300839; bh=JtTzztHo3v
	j4NyYn+7HfXn01E0UUSx1uw6XZPT0Rtac=; b=ehfvbcXsrRgGfAWXOriMytv6DQ
	RxGl6c0zXcG9FFFkzRVO9/+9wTly3mZXeFt1Y6MoXL8iAWE4Fcv/wVRXFMTM3ngG
	BWPK4orH9zahYkx8Hm7fGth8+HkfJEcDuh4ZmUEsCyixV4nGO3zPTSnaSXTWxN4J
	Lh0X89BxtyCZK3qA13a4wnyJi//Ar+d5davwy9VrYIQCLYsC/bE5zLapEBSxsvHK
	8h+eYDZ0TZpfH9CO2+aMa5c9T+yoQUSycW9jsVmg5vWscQ7KSJHPyV4Pyg3qtbDg
	XDzuHCI+D6nzQ0DleCQ1fNy46Awr7q8EoUe3x0FFyo0YKC7JApBP4erOhifQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788214439; x=1788300839; bh=JtTzztHo3vj4NyYn+7HfXn01E0UUSx1uw6X
	ZPT0Rtac=; b=LhFqcfgo7rkK1iquN4lc4LmdEmsiCNOPkTwhXgnwSF06SU3WYMf
	hFzvzSIGTssXvNA8LPmVI+sE49c+WxdX/Dq34iQTaf8ugu8JufDrjVXdtZe66fWy
	CtYSSTQ29Xp8Gk1iQU24l6XTUNm2296+Vq55lRJtxXeumR8U9qtzS/8D+uwBllQg
	EI35Y1PeOkttJGZfNSphKjdHLRdLCULoXDy/AZEqiUSCJXwUKhlqVlmHVnXCEEWn
	8kZsR+EJMY/swrSCZz5rMdr9SBvbOLgE8FkFjvM/BMB6am0etB1037zWHkQDy431
	jL8N3mAp3LX82XfosqkIs48XXk9gS19F44g==
X-ME-Sender: <xms:p_yVaoXq0exBq6PTpHLNCmnXwYiMPfXYML4oKxriYbzmQaJ0c2KJYg>
    <xme:p_yVain4Q8-xRBYERb8hGN6ccKVv9g5CpZqkjJmrW98Xa-tyxLlO8NjXgk39mEdAg
    TuTdKnGSp0kIrDQCKBu_N1mbPOFiSz2wNxDOdK-dKzBZl7256wDC1I>
X-ME-Received: <xmr:p_yVaqB1-timEzhQpS2BqDhtncStf79EnH3aQsFTTuchpaLTBVkmkXtZk7pbFYawdWjjsfcMDfxL3Iwn-nnNG4IqBHo>
X-ME-Proxy-Cause: dmFkZTFGqmCbAM56InYYkPevsRfQWBqOD6q+SzNOx7BQLJSIOJl8cDICH4iEkfNQ6FSQPb
    pmL3mEVYVnd8wz2X4tFIk1Qlmc/fyVgswLWc9cQDAnHWVTKCtOXuC2RqdQTXFOtilnTNI7
    KfUFY4O6T2iPFYs/HoIgC94P3WtH7sAlwMz8z7JkGoI0mZo2+nQYaKnK/50qj7AxOG/nFn
    918Jwx057rjKFy70dMZjTo3tJlnSytF19LCtgwyqwcdeFxPIVF6vtjdO50yKcyzftKMH25
    oRLMsGszdXCe4ix4rVOHtOXZ6BCIG4gT0ZzypSgZZw0OgMDInSwgu1x2wJuRw63Ucbnps8
    w/YAgHZuGYAGO0947QtzKHAj+dXxIg7rc1yVsskxC5BUls5cUiJeHsfdULhNimppb9nwa1
    1OlsktpgtfJ2rVtAheAGmnThU/nuzSfuKr6hp6n0i5tNDCPcd6NTMKMtJyHFRVax0zDuvj
    nIBcDMnkwrWUmiSxAX7646y4JUuiKINalCGvL4mlHS/cHqm/gwEJZQUnHPEyFLfMbYoQai
    /rSZ8M1MgWzXfYZxEWqVjYOojYTszFk4gTK3dIm7pZ5LNATeNbHPbLhUUcxNmOHG60+Qo8
    bvqCpc1cHARbuzxx3WVyFx/HElNkaHepHzncbnKoQCXGZRtkAci0sup31WbQ
X-ME-Proxy: <xmx:p_yVaicerL81gAE5GWB6GRVYt5P0MjZgyTfitnGa5JBm3OBwSI_G4g>
    <xmx:p_yValJeGsfbkNYRF3tGyMJQIWxJ7CUapFYBl75Y7mGiRF3QAib2Hw>
    <xmx:p_yValfAJyQKtalaCSAengyiDhtcGiEsX0lfHSbuqmr0vBSLbza72A>
    <xmx:p_yVas3Bg7miAiPHCc4rqEu6eCa9uLZqy2T7YkDX6Ca5lTBrbo7giQ>
    <xmx:p_yVahBcpzg3PRBy-hUmCXk1gDuuaV69_XwqtFRHBgnlz7FHYoEWhgaS>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 18:13:59 -0400 (EDT)
Date: Mon, 31 Aug 2026 15:13:19 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: tests: do not touch page cache if root/inode
 allocation failed
Message-ID: <20260831221319.GG325502@zen.localdomain>
References: <cbfd9452186748c2f0a627a472df3e2948f99cfe.1786428096.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbfd9452186748c2f0a627a472df3e2948f99cfe.1786428096.git.wqu@suse.com>

On Tue, Aug 11, 2026 at 03:31:49PM +0930, Qu Wenruo wrote:
> Inside test_find_delalloc() of extent-io-tests.c, if we failed to
> allocate a dummy root or the test inode, we goto out label to clean up.
> 
> But at that stage, @inode is still NULL and we will call
> process_page_range() to access the page cache of the inode, this will
> cause NULL pointer dereference.
> 
> This is a very minor bug, as it only affects selftests which are not
> compiled in by default for most distros, and very hard to trigger.
> 
> Fix it by adding a new out_root_info label to handle root and inode
> allocation failure.
> 
> This is a pre-existing bug reported by Sashiko while reviewing another
> patch.
> 
> Link: https://sashiko.dev/#/patchset/cover.1786095309.git.wqu%40suse.com
> Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/tests/extent-io-tests.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
> index b2aacf846c8b..23459cd4e503 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -133,14 +133,14 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>  	if (IS_ERR(root)) {
>  		test_std_err(TEST_ALLOC_ROOT);
>  		ret = PTR_ERR(root);
> -		goto out;
> +		goto out_root_info;
>  	}
>  
>  	inode = btrfs_new_test_inode();
>  	if (!inode) {
>  		test_std_err(TEST_ALLOC_INODE);
>  		ret = -ENOMEM;
> -		goto out;
> +		goto out_root_info;
>  	}
>  	tmp = &BTRFS_I(inode)->io_tree;
>  	BTRFS_I(inode)->root = root;
> @@ -333,6 +333,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>  	process_page_range(inode, 0, total_dirty - 1,
>  			   PROCESS_UNLOCK | PROCESS_RELEASE);
>  	iput(inode);
> +out_root_info:
>  	btrfs_free_dummy_root(root);
>  	btrfs_free_dummy_fs_info(fs_info);
>  	return ret;
> -- 
> 2.54.0
> 
