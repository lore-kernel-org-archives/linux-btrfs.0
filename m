Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FDA2571C7
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 00:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775091072; cv=none; b=Ee74R9Dtp77jBj4WZGfGrqaf30SUlakEcCRq6cIsBfumcsa3pLm0xh/FnpdS1QhlKn1eB0XpxZC/9mJ6opIUc8oO8L07/3AfWQbhj5/G8qFWQ2Sbb1xQNsOsDc2ZmJwfcIZDBtCPxFW4PAsGVmOhbg95Wz/DMOj7SY+GdrfBO8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775091072; c=relaxed/simple;
	bh=Kpx7mtjKkWp7B9uBoZ717gzS6PO7Bff+huzgttvGSTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qetcwbRKaai4egfvlfulfC9WwpO3c6f1CHqvSO3WJ6ZYVoMaONG9nyoO+uZ6n1SxQ6uKx/7gTE35C/fgzM/fzc4M8P7ol+Ko/ErNOHVWhrjtglQKDuzIsa3BWmE+sOasYywd+71/Y9NPBPCnBl4YI8BzX717OfN1VY4v8Va+tKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=qSrMSldn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TxsNGnKT; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="qSrMSldn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TxsNGnKT"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 3D22EEC0221;
	Wed,  1 Apr 2026 20:51:08 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 01 Apr 2026 20:51:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1775091068;
	 x=1775177468; bh=GqnQYUewJaKl0V8k4lXBj7+YieLup0fkmrl/UTubCDA=; b=
	qSrMSldnwa+ycNzSBv9UrqDUmffOeUhM60lFvyC4xBO2TIn3JNyy0Nv4eg0OkcTJ
	vTEOEKCRvIT1HFSgch2uVKxtpY5y/L1vhH8m9X59MhLd811x/Z/+nTLCh5ssobGo
	39OFGAJ2nttchBjlGVeLMQlrzNcNzK1HTVuq46OdnAzeBmDxjsszQcQQxLWHCexu
	TbHdOZrMwYT2L90w8EhpRocEL+8kOhkUMThITL93k9FBcHymcCGgWBsnyoqZyDlO
	NlE8YCFb20NzKJrYE2mcgZD+hhh/XKvb++ICpaU0AIjd61lkH2suGzCVUIsvXYH1
	j8AO4DptEbX8omtiSjD1oA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775091068; x=
	1775177468; bh=GqnQYUewJaKl0V8k4lXBj7+YieLup0fkmrl/UTubCDA=; b=T
	xsNGnKTJC6Hzkwyze+yDCVTXykKKBaqaJnUQxweM7tVKYzmxTJ+9gLst2uOHiNzI
	iMOcuPQ0SVTjbue6sqSwdhjGnJExT02ZbxUpHdZSYNjVwViyLTlEMPwTGAeA5b6h
	jitQgKhcIu2BYjHT2/I32SWJS0fQjYVRdKKoNAp8sbyB5eBKYB3E+HQ+LWyFuAg6
	y8Oiy+gq/RbrdZnI5ceVPqX3DIipu1W9dSJxmMPnh0mcqvQ/kl1+7EhSScdzq7hP
	5LUONDfEcAI/xzLE+uegyr85lgQrNdOrZT7fMJNY3dfmPXtC3T7vP1zb8TZaxp5y
	Q3vYUW52s0QOALgS6zLlQ==
X-ME-Sender: <xms:fL3Nac_xFAK1wIDQQaOAUYv_NV3gHCuuVrfVYCsPdUshd6PNZTfjwQ>
    <xme:fL3NaauOkvnD2bBZ9h4QMwWuW4WAtrl-SIiUh3kqsPV0aYOvjWyglbNLJ4tNkFPMN
    ir-vjbiQSLUEidmRLP97KsvPiD3WBSsJIzuJgHrmrDthIlcZymx6i8>
X-ME-Received: <xmr:fL3NafpWgfPzgIztyhzr1vQa3Qf5CULszjwdRf2D-1_5P5l8Lv66WHXjqfQoeKE_im9Rd_YBOSgJR18YPV-FUeuk6LI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepudelhf
    dthfetuddvtefhfedtiedtteehvddtkedvledtvdevgedtuedutdeitdeinecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihhopdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    peifqhhusehsuhhsvgdrtghomhdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvgh
    gvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:fL3NaXntiASgi8FdnTl7chcUH9rWgTxDQecNk7sredW6jhji7fjmVA>
    <xmx:fL3NaTxQ-raQJnjq85Ijd4_nmbwVKvlq7VGC7OFkYAN3Xk_7tuF1yQ>
    <xmx:fL3Nafn8kWm1tVETpJZu_yM4871tMuRicB8YPFHWGCRkfRNt-Yms4Q>
    <xmx:fL3NaccekRvxlDVC7WtDyeXM6DI8dFiLNdxZxzFkz5ukxJ7wxq-tAA>
    <xmx:fL3NaSoprZ51TT3HifpqVjtNesQEm4xbxOnthD0gl4OYkW0ivuRAynod>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Apr 2026 20:51:07 -0400 (EDT)
Date: Wed, 1 Apr 2026 17:51:08 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs: delay compression to bbio submission time
Message-ID: <20260402005108.GA916963@zen.localdomain>
References: <cover.1773953307.git.wqu@suse.com>
 <20260401225257.GA826348@zen.localdomain>
 <987d1e01-50d7-4877-b55c-62191b12754d@suse.com>
 <5f86e25a-00f9-4d48-b046-8ae93965f07d@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f86e25a-00f9-4d48-b046-8ae93965f07d@suse.com>

On Thu, Apr 02, 2026 at 10:45:14AM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/4/2 09:59, Qu Wenruo 写道:
> [...]
> > > So
> > > we are breaking the contract "OE <=> allocated space" to allow this. I
> > > think making the absolute core of the improvement more apparent in the
> > > descriptions would be helpful.
> > > 
> > > I think one thing I still don't understand is the desire for the layered
> > > bios/OEs instead of creating the same delayed OE, but then as we do
> > > the real
> > > allocation/compression and discover the actual ranges doing
> > > btrfs_split_ordered_extent() like short DIO writes, which seems quite
> > > similar. Splitting/joining feels like a much more natural model for
> > > ranges like OEs than layering into a tree. As we discover the sub ranges
> > > we actually use, we split off the real OE.
> > 
> > I can definitely work towards that direction. Although my concern is the
> > OE waiting/start part and error handling.
> > 
> > But so far those are only concerns, I need to implement the code to see
> > what can go wrong.
> > 
> > And if no major problem is hit, you can see a v2 with the split solution.
> 
> Finally I recall the challenge using btrfs_split_ordered_extent(), that we
> can not split the OE in the middle.
> 
> E.g. we have a delayed OE for range [0, 32K), then due to whatever reasons
> (e.g. memory pressure), we are forced to submit range [0, 16K) first, then
> range [16K, 32K).
> 
> Both go through delayed compression, but the range [16K, 32K) win the race
> by failing the compression (bad ratio), and fallback to uncompressed
> submission first, before range [0, 16K) even finishes its compression.
> 
> Furthermore, for the range [16K, 32K) we do not have a large enough free
> space to fill it in one go, but can only allocate several 8K sized extents.
> 
> So we need to split the [16K, 32K) into two ranges, [16K, 24K) and [24K,
> 32K).
> 
> This means we have to split the original [0, 32K) extent into [0, 16K),
> [16K, 24K) and [24K, 32K) ranges.
> This is not supported by the current btrfs_split_ordered_extent(), which can
> only split range from the beginning of an OE.
> 
> 
> I'll try to implement a version of btrfs_split_ordered_extent() that can
> split the range at any offset to see how things will work then.

This was kinda buggy before with the extent maps, and I think Naohiro
Christoph and I ended up doing a good amount of refactoring to get rid
of it. I am confident you can implement it correctly, just a fair warning.

Also, you could consider doing an iterative split? Like if you need 16k,
then split [0,128k) into [0,16k)[16k,128k) then split [16k,128k) into
[16k,24k)[24k,128k).

Not sure if that is easier than the "true" 3 (or K) way split.

If all this becomes a huge headache please feel don't feel obliged to
carry on forever, I am happy to discuss again.

Thanks,
Boris

> 
> Thanks,
> Qu
