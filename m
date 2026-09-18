Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24924415F25
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 19:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789758757; cv=none; b=INvGIJiH76Pb8bFGUHOHyJBfFuuq8VbJs/H6G7kXD/EU4euaRrg38dyQc1VSPZnYF+dgiw/XLpZIBGapkCkct/+wE1/rzmg10Nhkahawb/71Zv7EA1niwMTaXwEa3cL32UgMInhoPGQqawKpxIZFKcL5p6RuliIZ45Bj3p8T+0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789758757; c=relaxed/simple;
	bh=oWTC349Q8OFJ+J8MzfjFE4guBEfavZLGPDVyY04Wgw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z04MfpoTB19/0nrVyU0kih+rvTmxlTUbl2eagoQTz+HQwPMFCW0F/L0lCRUE9Rp3yfw6q43Kofx5dockYrMcOENYO8KnRhtjpUSsBrqIoG9Nn+0SSua86XSf1RSnZIkKtLXa60Cso3trIGKAumImvnx3yV5ZPWmAE8ibQpmK9lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=JeYbe1Vt; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=lqqcD9ln; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="JeYbe1Vt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lqqcD9ln"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 434DD1D000EC;
	Fri, 18 Sep 2026 15:12:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 15:12:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789758752; x=1789845152; bh=tgg4/9a9wd
	I5qgRJQXOamsp7082v0pu6awO3VtP0qWQ=; b=JeYbe1Vtj6EgpJNaVkYDwbchYg
	+fCFfZDtiXQmUKtLyTOZaDeDVn2ILwQ2f91P4u8t6doqn8t+DcOv0VvrjfAH2kve
	6fM1TFXXIQksdktvxsMalIq2PQzEeWI9mg0ncLl8h9OzkcFFu4jeYhb3eSI77tOP
	B8rM51ZmLFksz8cQuZG8JpoQwMiGhtwhs+FirTEubzbSe4iwwxNXYagiMQmChDs0
	j0YbPaGpwIC+4WwwMxjTn2t0azcawGyjYLkrkIn+xqS1rYM2apbdIU9YWuSU8OFB
	Uva8TbrluisM0wrZBC2IcAwgBdsMAyU7pr0aQ0xkxT1Aa+fz2HoIoa/zcWQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789758752; x=1789845152; bh=tgg4/9a9wdI5qgRJQXOamsp7082v0pu6awO
	3VtP0qWQ=; b=lqqcD9lnUPHEwRkgh3C66f1AGibEsQk/z93tZ4XTXXO6LOliQbv
	7VjT5pSyOpuPCOZ5WGXs/gRc0KajjbCZBU05yyHWN9hzxuiFj2QPMvfYeI4cpQG4
	VgzmDD5B2hoQBdS5FsCyGqBb/RIHJXY7RIbYdgZHidNM7m5VH/iJWz9t4Kc1FGhM
	zWng7lrVLjEwB/LlpMcS+o8C+wQMxGAGPQ6TSbG6FhXrw+RxhDv3C+uetopo/yli
	SeQj46x9FH569UlCQJ1/YkTxdvbQQregbeiZQRyFfoTt5PwoPYRnUMxFPw4OBL94
	5FxECCT6cOaZoGKpeKtB4+F3JRHA74jbBXg==
X-ME-Sender: <xms:H42tah1K5YyK5o1GWrscbZ7CPn3LAqU4n7hrzy-fBWAgFbOnZ5NT3A>
    <xme:H42tauE7hk8u2feH1Q3wbhWvGkYu-jcSGHFFK3xCsfep5qO5jfIxmUvxwWavW-G9L
    zGPSt-kO16rOH4WidJKpEHBDem7KR8gASG_Wpfr36sADKRwiOIIYuw>
X-ME-Received: <xmr:H42taviaqPtrz7YTo77WgD5zLcJktw1hiTWtX0rpi_rMi0UsEmTAJaY>
X-ME-Proxy-Cause: dmFkZTGyB97ULRpjOiBdQGEvFiTQnMGmbUZChQ6vgbAvxvbHG+J5OXwjDooMF35o6ZFxNT
    QSFHpJ5V4gbx3r0G+Vo3Qhw+cdSCX7PaS4/fM8dfjZQhUxCpG2WhL6DC4K91tZgvQybdcU
    DQzRjxCnWx0fwIdifwByQKk7MRXeGHg1H0c0DujMF7zNHdbAItmnw5Pz+nwLW84ETnUpWz
    Wian9zACmQEx9EMfNbWwtEvZbonoVUWRXnUQ5gGXqwziumqWrPCWIX6nlM4z5alyJpWhE5
    r5wB6UH9CFtQp2R7aOjdY+QF6O3r11OBmWxzzO164VaQ6qwLIu2vWLKPzxJEq40Yz33DPV
    ba2yzL4L0Ft+59ugn/OPW3P0CvZb3GV/OHq8prgPI2zTNlKsBZkAGKnYyCy/X1nbSZ1Y1D
    wkAdfuyOiQrxZO0533pfEJIJ4WUL1SwTesYwKk6oMMvaEaQMHh4aPwq6MA2oC1DbIqHzta
    B2D8wbXZC8QAoJOzp6YBspCgiVT158VvB7tN3jTFCA6gzh2NILa9n8FP2v/dIj8zUh0F81
    l9O7eOScgEQ+5u9NL4BB+JqdbcdVGX8hr1eBRIh9GjWBhlRdFXuVu4P+8D/QmKAibzsj2i
    MK9vrBpUvevOFSbyxr/i7eW8Db6m0ZsFG1kxtw/ZF2vmIEQwSay6eNfwixmw
X-ME-Proxy: <xmx:H42tap8Uf7bmYDBKibjV51sjcoNZc4A_xensOyd3e0xrYc5_LByuSw>
    <xmx:H42tamof_a6I8ZQNWdQ13Deihau3fRlSlkmrogoyii-E9b978OmOWA>
    <xmx:H42tao-HT2t56dUnOAxcy-13vm9ZSwMEc0U2iQxeUQK9bTAAEFOfVQ>
    <xmx:H42taqXkD_rltVzQTrjPS5tKOsx5-HEyxQcy-PxgP0w-BzMASDP_3g>
    <xmx:II2takKInUBK_lvN_u3Q-pWPSMxKfh7wRmuVIOfg-2pU_AeQsXhD4slH>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 15:12:31 -0400 (EDT)
Date: Fri, 18 Sep 2026 12:12:43 -0700
From: Boris Burkov <boris@bur.io>
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: use specific errors for simple quota
 rescan
Message-ID: <20260918191243.GA2956775@zen.localdomain>
References: <20260916031104.2390777-1-zhudongjiang@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916031104.2390777-1-zhudongjiang@fygo.io>

On Wed, Sep 16, 2026 at 11:11:04AM +0800, Dongjiang Zhu wrote:
> With simple quotas enabled, running:
> 
>   btrfs quota rescan /mnt
> 
> fails with:
> 
>   ERROR: quota rescan failed: Invalid argument
> 
> Starting a qgroup rescan is not supported in simple quota mode.
> Return -EOPNOTSUPP for new rescan requests so userspace can report
> "Operation not supported" instead.
> 
> qgroup_rescan_init() is also called during mount to resume a rescan
> recorded in the qgroup status item. A RESCAN flag in simple quota mode
> represents an inconsistent persisted state, so return -EUCLEAN for this
> case and retain the warning for diagnostics.
> 

Change looks good, these error values make more sense to me.

Reviewed-by: Boris Burkov <boris@bur.io>

With that said, I think Fixes: for this is kind of a stretch, as this
isn't really a bug, it's a reporting improvement. I don't think anyone
should rush to backport this to their "affected" kernels, for example.

Thanks,
Boris

> Fixes: 182940f4f4db ("btrfs: qgroup: add new quota mode for simple quotas")
> Assisted-by: LLM
> Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
> ---
>  fs/btrfs/qgroup.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 05e35eb126dc..0e4de33e4f28 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3991,8 +3991,11 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
>  	int ret = 0;
>  
>  	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE) {
> +		if (init_flags)
> +			return -EOPNOTSUPP;
> +
>  		btrfs_warn(fs_info, "qgroup rescan init failed, running in simple mode");
> -		return -EINVAL;
> +		return -EUCLEAN;
>  	}
>  
>  	if (!init_flags) {
> -- 
> 2.39.5
