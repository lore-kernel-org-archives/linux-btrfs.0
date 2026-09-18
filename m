Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BD151C079
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753096; cv=none; b=hVD2M2rjwg7bSdtJhi1WUH3x7Nshp1DpZcmU03CI1eVICnC6IR4yZWVsqE89IXW6xWbSOGHRjCCglP9VIN/65j1jfKvRyG136OYe5muJZXKFtpdllpJdoFUSvwntczNFUb0Bij4H/wzIvTQaniRFQzhQXjWheBE8eAh/dA2DUyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753096; c=relaxed/simple;
	bh=ZxW2sL9j/GhSldRRf7T4Z4s18HXqv4XAdWB+xWmYYaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJIyTTJKZLJn4SbmH1A07i22BKOQFsAU73T1bXqbfTAvoTgHFGCw5Zdukxvr2G5zHX4dthOg7aPY03swsZ3BQx4e+u7P/ur2FeNpYdcmgZCZVXChwx1/5C0i4wQGNGwzCGiGbDLm823tlLAfEbVkcLI6LW3xEJswv+ARCW4Wi4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ZNvKcTP9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VMMS5p6f; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ZNvKcTP9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VMMS5p6f"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 0FFD51D000BB;
	Fri, 18 Sep 2026 13:38:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 18 Sep 2026 13:38:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789753088; x=1789839488; bh=dc0S63ZFmv
	QxH8qzgSsEMpvR00wtGiCWRDgL8sWNcwQ=; b=ZNvKcTP95FNb3INr7GqXs98F3c
	kw8XOZBetT3j3xJW8LqSo/NuLLznHLTYHdiH1oIA0H6vQw87llEmufFe5nHBQDQs
	hTtmaColYeIcBIoWgdk9ZYWcJzeYaxqL143ylvJUdDWhpOdmLxnu7JrLY1gLT98Z
	mXRYegnoyK13+vV2xhJjJCPnb1pDOfZPi6UXQwLOHtqngPCEYPfCy5kkQ4LNQfZb
	mkTa1tlNJrWJyniMPq0eLqk94lcPAE2FgyGrGPBzZM9TsjCP1K1Ru7t6I2q2ov/8
	vtLOklfSjQsh4M34KpJdYatv+HtCCI6GMAq6eEgDvuEHDPYifDqVTgM1hoOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789753088; x=1789839488; bh=dc0S63ZFmvQxH8qzgSsEMpvR00wtGiCWRDg
	L8sWNcwQ=; b=VMMS5p6fc/mp+41HeOb8ZsrJ8akJlJvxfizOvlIwfoOWZ9IkvIz
	cYA+eMNWrZeleP/1teY5qUw3zhm/9+x9fboqAcOpVGwb6dYdCni1oEfV343251IX
	Q92I4NLVnFiufia8FOSJqh6XAyhA8UkJM2FbQS7ZBTBBVgjR1o1u8Qay0EGUKXZQ
	eKxGY1L0jKJRWXnrNNBfywN9TzK8rL1dPVpVkJBiJAJ9REIBNMX0sYVy3ebL+dNk
	i8SryisTySZbogXjFT+V0fwz1DvLuoUfH0E0m51cTh4LkuCRHpr7sawTwSo4faMy
	jNRCTOcurtjAcnSj9fR9sfFm/RGbzxEGe4Q==
X-ME-Sender: <xms:AHetagf0oDA_uojxez203OsCm4ITqM3_PHC7CNcGpzXwvbofIERKWg>
    <xme:AHetaoPQzTCxGM7RXHK5MLP2VabRta9YfaR2W4qcAupb0mYB7gbyN__uAyeZtzGh7
    Geq2yzOVN1uIxoTx4TUVio3-p_efPeXujaLWWk8Pxk9x6Zm8Ba2LRSW>
X-ME-Received: <xmr:AHetavJvBLgiVa1xqQ7s22gZhiH5iljgf26y_z9Vme2YQxVgsFzJe64>
X-ME-Proxy-Cause: dmFkZTFOOwOki6yrQm88hlXsrKVeCwH41OLnQVBNE4F2myfqWjgN84SAHIR7o7obLz47DV
    eVTyPLURn4EMZqQNdg3d88GFQtano5bIl/EFUT1BP12/XbNmp7fv/z0HPoTFrX5ZEauYZF
    gH94qfms2CI/JEhUDdyX3Jb3dxmB2qD2TIQzCcJezcglf2AhkxaGiX60mwWYZcBYkn536G
    rU9SsAQzGwdDKN2uENYh/9lLH3Q2TdF68FCIkxWAYi6u2J9d19ULcU7mkTKpyRTpEkp4uT
    G3L0NdK4cYayUvUCgJdXUdPh9eU0zTXSBqoMMNxBtN2MRl6PnC3DE4pYR2yU48ckPXo1qG
    7WJBNAag4y9/r1G6a+bg7Vyb/W8k9wvr8UI7gB1G3OhkGTov8+imnasRn+cHaSXeNhNV2/
    bUKaiSCJQtLAJO4/6k/WYQX3DozdJpL1E//ghlL/Lm051JIGKp8/O+Qup4Zn3dlQZPKMsR
    PqmyNRvw5kUei+eh/LAiZwkC78YBrxS2o5a7e2OML/Jxxvmelm83cCXbv7e/Hsbgf0fLPQ
    wtWOXWSnqk7+0WKIChtS1gWDNVGPbZgOJWTxIxR1inLd+YiYZeY139Yhfd+2HEa2jsDJGU
    3YdY6KUdZFCZrmgifCvAEHnFj47X+IzpLNGaYCBuKn2oY9EGKNy39fYKm6NQ
X-ME-Proxy: <xmx:AHetahFfaY1K0uuXQ8BXiRUnfZO2W1VbyGROsf3P4FbIeScMlHvIWA>
    <xmx:AHetavQ9uSzrLXwjTqAvyPkS8r_KD3YSng7WIaeBKmY-hW-D0TWb2Q>
    <xmx:AHetalGEEMsL913UtU4-UAd5z681gtjq4XuBTcr6fTYcAw2-73J3vQ>
    <xmx:AHetaj_PKWEeymcPQL8MEgawtTJ5pi8wEXvFizoIQqyiHsq3bpcPPA>
    <xmx:AHetatzHku8rA6uBIpi3uGjdoTwCnH_v_4HmnCIupo669KG-xEBJvHHi>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 13:38:08 -0400 (EDT)
Date: Fri, 18 Sep 2026 10:38:20 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: a couple fixes for record_root_in_trans()
Message-ID: <20260918173820.GD2900089@zen.localdomain>
References: <cover.1789734239.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1789734239.git.fdmanana@suse.com>

On Fri, Sep 18, 2026 at 01:28:08PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Fix a couple issues in record_root_in_trans / btrfs_record_root_in_trans()
> detected by Gemini, plus add a lockdep assertion.

Some simple nits/questions on the patches but this LGTM, please feel free to add
Reviewed-by: Boris Burkov <boris@bur.io>

Thanks,
Boris

> 
> Filipe Manana (3):
>   btrfs: clear BTRFS_ROOT_IN_TRANS_SETUP on early exit from record_root_in_trans()
>   btrfs: fix barrier usage in btrfs_record_root_in_trans()
>   btrfs: assert reloc mutex is held in record_root_in_trans()
> 
>  fs/btrfs/transaction.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> -- 
> 2.47.2
> 
