Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776C9335067
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773678574; cv=none; b=Q8QXpkMB2JgHlpimwa8/hNSLgHHH2ikjNPJ/BKasowjjqclUgPqLFtXhmoi/ZZ8OE3ZXLIsmBweg5LMAZF9DX9JL6S2k3Y2hhWP3ruolHmc66jO01f1k3HysBs138sGNAP/X3/5mbD/DG27IUcVeVRngT2yVsOl7jZqjLGEm5nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773678574; c=relaxed/simple;
	bh=cpe0S1DkUrpa4uh++vv2fb+WOjKMKuZJAJXS3odpW3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2Yy6rIjZ0sD0fhaX1A93dpI4Shnx71dckvAziQkQiX6Z14RU5/GOjZaIseMIwcnZ1ARSG5XKRjGLhvkr8ywB03BKYwkDOiC8fE4jP2UsQKw9AKptbSo+rifkkz2dFeB4RnlPcycc0I/L2Xp3hXvfdpqWjOG+Lef+iVPKfnCa88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Eqn/qOQx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TS7nWMH/; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Eqn/qOQx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TS7nWMH/"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 76630140019A;
	Mon, 16 Mar 2026 12:29:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Mon, 16 Mar 2026 12:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1773678571; x=1773764971; bh=4CmReVQka9
	ECufCaWRmOvv+q73koGBgUYuib7fPG7Rk=; b=Eqn/qOQxBWgph7flOUwY4EcAmo
	3D7r/q6oPrZFwKht/Odm0znaDHH2jkFBojM2iGyIAkM+QwYpMWOt0kX5KyYnnG9t
	mNklkwFkbvWwekmV6EMixfTo8RUlF4SvjHdvrIYCWVLGHDIsmr39BjfDgr7OdRCO
	9wbldoz+S6HuOTtYGygJB375KlyAIWOwy1BxAfiIPeSU/M3NYaF4jp36vN+0CdU4
	tOSuYqLsMyNBNZlTJB8PpUQ4CbmEm0fhRqXLsgGCawUmeydIWlRUhGiFRpLQCnfE
	xdAtSInusGBppHwbzyPpltDr4EU9JWiIXveHLEbzzmNnSpPkPw/SuG1fMLZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1773678571; x=1773764971; bh=4CmReVQka9ECufCaWRmOvv+q73koGBgUYui
	b7fPG7Rk=; b=TS7nWMH/BXY/J3awMslCqNQkbh6uPKJoA1FPHlnO96SaT3wnnic
	f/YuoD2wxFXz5L6mvyMFbrel16CCWMViutaMBr0IljP2HImBMrLZIgFdHv5klD8m
	TnrEmcM1d1jgtmoGhY52wPyb+Nk91f3aLxO2h9wSHjfg867U1rwDM4i6w02osuDq
	LV7cH9UfhX2KJ5wd61/C1su3I9tiXWzonOXlCsR5smRSjJvfWu/z67RDp3FpvNr7
	Rr4ggAQewFgpcpUdWLMDBGk+ZnFLFBAAcz9Pt/M+y/gDkaMvhVfS2cy9p5yKXE5e
	cRt1Ei18zwxFEB42JGDPnZmd8bS+iBHIBtQ==
X-ME-Sender: <xms:6y-4aTR2KGafoFOLefLRKZhNRDk2UjgFnJCrfGr8ZJUUJ43KklS79w>
    <xme:6y-4abzMi0yb59biy_xrnuMaHqLHZoNeNlAQHhmFcM1yOOHxRoyEFEFM7tjK81BbZ
    uyrqlBU0XzcrY6itRAYGUO7RUh61YltjHiwF4y7vHIAuEvgHSvCx90>
X-ME-Received: <xmr:6y-4ad0hsWR1EPRbtch9mFq7CHvOj-DuCVTXsUpzwD6c0yNUB4h1PkIe3UOOuo_xXIjtokXHqftrop-HCW1DnK1CZo8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvleekkeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeekvd
    ekffejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohephhgthheslhhsthdruggvpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdr
    tghomhdprhgtphhtthhopehssggvhhhrvghnshesghhirghnthguihhsrghsthgvrhdrug
    gv
X-ME-Proxy: <xmx:6y-4aR4HtLoMaVcYNp1hxtSKD9MQeUQKznyqHYjnnQwR7xVhuhrAAg>
    <xmx:6y-4aYUx9X1wgE4pGEmnCERdX5QQUXB9Qmb_MUx29Sq_nAUC6B3eFQ>
    <xmx:6y-4aYDhFTf1JGcUfSsb4kUHx0rvvN3ZT2ZlnYODhAw2y4FfwJe28g>
    <xmx:6y-4af4W1YbJJbkcgFxi8iY57R1iz1RxI_7e3RuScEIRN9NAg-kRQA>
    <xmx:6y-4aa8JHeHbvm9Mw28fkzHePlHGlrrfTgrVCYHHBm20Pm7blzVSux-n>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Mar 2026 12:29:30 -0400 (EDT)
Date: Mon, 16 Mar 2026 09:29:51 -0700
From: Boris Burkov <boris@bur.io>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
	sbehrens@giantdisaster.de
Subject: Re: [PATCH] btrfs: btrfs_log_dev_io_error() on all bio errors
Message-ID: <20260316162951.GA1074179@zen.localdomain>
References: <d2edb3eda4038ef4f2dbd7b76a33a84e3b4ba32c.1773429838.git.boris@bur.io>
 <20260316162020.GA21157@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316162020.GA21157@lst.de>

On Mon, Mar 16, 2026 at 05:20:20PM +0100, Christoph Hellwig wrote:
> On Fri, Mar 13, 2026 at 12:26:05PM -0700, Boris Burkov wrote:
> > As far as I can tell, we never intentionally constrained ourselves to
> > these status codes, and it is misleading and surprising to lack the
> > bdev error logging when we get a different error code from the block
> > layer. This can lead to jumping to a wrong conclusion like "this
> > system didn't see any bio failures but aborted with EIO".
> > 
> > For example on nvme devices, I observe many failures coming back as
> > BLK_STS_MEDIUM. It is apparent that the nvme driver returns a variety of
> > BLK_STS_* status values in nvme_error_status().
> 
> This goes all the way back to adding the error counts in commit
> 442a4f6308e69.  The block error values are a bit of a mess and it's
> on my todo list to sort them out - only a small number of them should
> even be seen here.  I'd suggest to leave things as-is for now, and
> I'll make sure you're included in the discussion when I get around
> to attack the block status vs file system issues, which will hopefully
> be very soon.
> 

Is there a reason not to properly log the errors we are definitely
already seeing? I have thousands of instances with swallowed
BLK_STS_MEDIUM errors that really confused me and messed up my data
while investigating a possible regression.

If you think this will confuse/upset users who aren't watching a giant
fleet with distributed logging and make them throw out good drives
prematurely or something, then I can just carry this patch internally.

If you are just worried about having to aim at a moving target, I am
happy to offer to be available to make sure btrfs does what you want
when you do find time to work on this. It's hard for me to judge since I
don't really know what is wrong with the error signalling as-is.

Put another way, if we are in a situation with technical debt, which is
what I think you are saying, then I would rather have more visibility
rather than less.

Thanks,
Boris
