Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA74368277
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 22:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779487683; cv=none; b=DP7FR5ghMTitZIwia+7ckgvaadwODP9teORTySt5r4Hv6Y9mWpcsR4eeyVn7QHDu87CnOrfFiUBqpfntqM1VdQCVNyoQGJl9NN2qindA46Rt4/iaE8VYD2gLXd1dZ5ZpTNU8GoWHCho0CX66dSvmX+19TI67LgnRRP0yDDRiFHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779487683; c=relaxed/simple;
	bh=sZ1mmOlRnPi8RHCc9eCzPzhXf+8JA90DKatPTbyHNlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HheBwAM2qFz4hCwwNO8FX5fhpTG3plvlIPeIuffHchR3pTcsDKoz6rNBPXmCKWZ7OYrI/deno26DlNJV3r7HFIoq/vjkhLh0Iy7s3MwLCkL1uc91IuDsfi27M2BKNkfNgS0/V8pHos8CkLgSCIbPW99y7wB687JbzRjGO2t5lCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=YrQZPGeX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aCwuoTKs; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="YrQZPGeX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aCwuoTKs"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 8033D1D0007D;
	Fri, 22 May 2026 18:08:00 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 22 May 2026 18:08:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1779487680;
	 x=1779574080; bh=llo4bVFE0Qpz9yRevcDwPM0quHjx70/V1wTA3ymgL7I=; b=
	YrQZPGeX6jCxvKR71DVTMPnziiL+lDgClGlxwaM9N9zkr8ywMAAuOFZU0QiAqbCH
	n0TKjBRIuMp96Y4p15on1OUgNHrW/OEy9MWF83AlJR+PqPpL2kq2G4DzmrI3Nrco
	c+bSgU0HtV0V3tlTytUVoWl0r0dEPFFcbM7W/XZOAxtrCwVk/Lq8l/G8G1J061JC
	SZXFWcLqTFOtCf4Hezms0m5PDdqE/4Lv2rxZlmHfQYukrXO0rmXeqPOvKLuPPEad
	GmUSAFmJV1ZUYlYh+sLYAp/ZeLihKZZrOHu5lZuUL7juafKAL11c3g3CalHGoksa
	OMtMAtcGS2TdMTK411bwFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779487680; x=
	1779574080; bh=llo4bVFE0Qpz9yRevcDwPM0quHjx70/V1wTA3ymgL7I=; b=a
	CwuoTKs+BKCTOhwEcvA769RjHHhUpAGMjajV6oRPjkmPFv2PkdOJJDURLUKzZVwe
	NSR2ghD/6bYEHbQV+2/TcQB13yoqmKXvRvJ2QB5GWhjexuzG8ICL6HYXnmxJ7KTD
	Py1NfmujQPhtRE2rw1ky5Jp0xte554AxVyqY29n0wvpjlx3U5OmFDpdgCxGte131
	4wTXN/vm+X6vEBqJgb0fbKCCoklvF7mCnUv+kBefUiHgRx4z/dzcA75K22ARgr9G
	uR2FRZr2ijEyyjiFqMHIPaCapwI1ynXhb0DxypAs4aGA1x+VU9wuSHyQwx1zfyO4
	5JZzKhv125o2VKVbxRKtg==
X-ME-Sender: <xms:v9MQanpGvXHoj2hPNPAS4rMQ2wSD0sfA7015nJlPq_2DiIvqQxi7pA>
    <xme:v9MQaj6iLj4ElMWwluYyA4zZRVk1NnK334wbC290eQU3jlG9Vutygf1GqzXf0VIXz
    EElxBe1-iCT_wzFi4_OG6Uommy_f78ny91lgSA9g1TRu9wMgzt-XLE>
X-ME-Received: <xmr:v9MQamekCqBeYzD-ZXN0HmAPRQmhVgI_3wsD471NKQC4kDkVnv-GmZrx6KFAilzwDW61wOwX-6aJCiUjbUZcgGngWw0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedufeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepud
    elhfdthfetuddvtefhfedtiedtteehvddtkedvledtvdevgedtuedutdeitdeinecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihhopdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopeifqhhusehsuhhsvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgrug
    gvrggurdhorhhgpdhrtghpthhtoheptghlmhesfhgsrdgtohhmpdhrtghpthhtohepughs
    thgvrhgsrgesshhushgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehfughmrghnrghnrgesshhushgv
    rdgtohhmpdhrtghpthhtohepshifvggvthhtvggrqdhkvghrnhgvlhesughorhhmihhnhi
    drmhgv
X-ME-Proxy: <xmx:v9MQag743yNh6OQQpPUVNTq06nAT23T6UxTpVOoq9wmVdtPJJqKkuw>
    <xmx:v9MQalsG1pdnyUV7Y6P23H7M-7tuy-y9NM4BeunUmV59RUPZa20KBg>
    <xmx:v9MQaojWBwi_C3L1t8zF1Qkja2nFDUlhNnLkWvYjBb5yT-o73gYoVQ>
    <xmx:v9MQaorjTp_PVxLKEzQhxjw6sSm3wN0OKPSnQrPqmvLfE70wFv-sbQ>
    <xmx:wNMQauZEVInBmCeSv8p7-J9kNjxyWoJqSLdRf9PPHy4PYm1PJx0D9Q8i>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 18:07:58 -0400 (EDT)
Date: Fri, 22 May 2026 15:07:53 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
Message-ID: <20260522220753.GA3345651@zen.localdomain>
References: <20260522181411.2487732-1-willy@infradead.org>
 <20260522212020.GB3282973@zen.localdomain>
 <09b6756c-b750-4c73-9aaf-5eaf758c7a52@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09b6756c-b750-4c73-9aaf-5eaf758c7a52@suse.com>

On Sat, May 23, 2026 at 07:27:53AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/5/23 06:50, Boris Burkov 写道:
> > On Fri, May 22, 2026 at 07:14:06PM +0100, Matthew Wilcox (Oracle) wrote:
> > > All of these were discovered through auditing the (mis)uses of the folio
> > > API throughout the kernel; I haven't been specifically reviewing btrfs,
> > > nor testing.
> > 
> > I ran this through my btrfs fstests setup and observed no regressions.
> > However, that is on x86 systems with 4k blocksize so it was not exercising
> > subpage block size directly.
> 
> BTW, on x86_64 it's very common to go large folios thus going through
> subpage routine.
> 
> E.g. just doing something like "pwrite -b 64k 0 64k" will create a 64K large
> folio thus exercising subpage routing.
> 
> Although a 64K page size run would definitely help.

I must have missed this detail in your patch set that dropped
experimental for large folios. By default on for-next with no additional
config we get large folios now? Sweet! I'll do some tracing to get used
to it :)

> 
> Thanks,
> Qu
> 
> > Which means the revert is still relatively
> > untested. I'll try to get a proper subpage test done if Qu doesn't beat
> > me to it.
> > 
> > With that said,
> > Reviewed-by: Boris Burkov <boris@bur.io>
> > Tested-by: Boris Burkov <boris@bur.io>
> > 
> > > 
> > > Matthew Wilcox (Oracle) (3):
> > >    Revert "btrfs: fix the file offset calculation inside
> > >      btrfs_decompress_buf2page()"
> > >    btrfs: Use folio_put()
> > >    btrfs: Remove use of bv_page
> > > 
> > >   fs/btrfs/compression.c | 18 +-----------------
> > >   fs/btrfs/extent_io.c   |  6 +++---
> > >   fs/btrfs/inode.c       |  2 +-
> > >   3 files changed, 5 insertions(+), 21 deletions(-)
> > > 
> > > -- 
> > > 2.47.3
> > > 
> 
