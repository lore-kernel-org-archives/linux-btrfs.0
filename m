Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6BF40B6EE
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769843; cv=none; b=dv70i+Fkq5vQgHx5BByi2qIlzhIg3WCzrkSJKCJEyna2k7ZobOF/gc1zCCtAg4QSkwuLBiaMXkimMAwXEagjKwFatx5yxtr4TEQ9CGWU+gfpOtFnN6C7pfPgrIlaxmcZXjeLFuOpPCyiqjdkNYc0fYQjjdEjNPE/3LLSs+tai10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769843; c=relaxed/simple;
	bh=Rg7XAkWcm3HLEI+nmmdyBkmrLs+IGanaoT5MHkbseIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MT0DAEODWI44luxsthtaxXVZ3KS8fkl/md4wgeCRJXKk1VKaVPdcnWFJTTiUdgv3GkydlGOLJP++6loapJ8+JQPSc4522y66B8viLVI3RU1mEn06F+FI4H1tX4Vjv1hynsMsUkluGLwqoB9xmd9OKqcTeah6ICxqW5Xn02NL8Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ATVrGgMT; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=klGMDr0y; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ATVrGgMT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="klGMDr0y"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id C7A69EC021E;
	Thu, 14 May 2026 10:44:00 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 14 May 2026 10:44:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1778769840; x=1778856240; bh=F7WH+D72Kp
	iuVlSbU0OxlLR5G/Wd1oHmSiqfrhJa7BU=; b=ATVrGgMTPcf2mZb2MScQHmgI+Q
	w/P8rYJUN9d/9F007BWfF92dSEfdlLswedw6FDlV8S6dHVg2ySD2RBxq3FPAjpQ5
	FUTKAWLjIg8Bkm3AqkL64z1gfwYF05DbKWZ+BP1Hmz9Gnfuj8wgnQQOJipsrF3zn
	Lf1ZLffZfGepqRS4Metq2pmctmpr++y3rPVEaH6tZn0x889194zXadHq1bxt2m9T
	nCVsDNMxPuLLF154ey5kpv4yLTHnLGYjDfAUAFrXXZWC1pxBrKKqnSbwt4p1POfP
	u8df+vPw3W/XSKtAlKWNfdQXX34/W/EfYHCoWIprQo55RMpwzktSjALBdl5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778769840; x=1778856240; bh=F7WH+D72KpiuVlSbU0OxlLR5G/Wd1oHmSiq
	frhJa7BU=; b=klGMDr0y044wtWzFZV05juf9ZCsDcY2tsIMWfGPGohlkIqlZRjU
	z6oCptB38S9+7PimQUjvOmdv9cVq0iief+li4VzouCa0U2gXgOmpfFgcwJP/WYXf
	I3TqB2NpQ1kUHylfWmfda9X+RGVK5TcAX8zF14sX2oAGOKPetEgyGqTFDm1De4cJ
	BJNPAm0yl+TpY5KBmyMRQ1FqKzpXpGSZXP7ypHrPFEIn3FYFBoHQGFud/yOuNASp
	eTi4O6yoayqAB2YREFQGnnsIDbfaS9HxKSRhy4//LAe4A5hn3qdwpP/Ss+dJCEr0
	3TuBvDLn59pm5nEEiE02AWUzDp9IlvvSsNw==
X-ME-Sender: <xms:sN8FaowZfYM-d5x7cjkmZ74B5X64Cesy_lSi5eXxDdJWwXf5uLQG-w>
    <xme:sN8FarWjsOTr5hiXXA65whsRIKKzzsFnujb5wMEG5T9Tww7Tep1zXPgYwXaJOwExy
    VREJk_EFtJjvvuf9cfVXNPNbXIxr86G0F-i2LS3Q8_w6PjS-X_70lN1>
X-ME-Received: <xmr:sN8FaggQs4Z2jKQhlzJ62nBAglcFjNm2P1UseG1RRstrU1mt74-oWkzgcQUK02k97YRhzTlX2-9lYWSsvC1w-tNTxsc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdejjeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeekvd
    ekffejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepjhhohhgrnhhnvghsrdhthhhumhhshhhirhhnseifuggtrdgtohhmpdhrtghpthhtoh
    eplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehfughmrghnrghnrgesshhushgvrdgtohhmpdhrtghpthhtohepughsthgvrhgsrgessh
    hushgvrdgtohhmpdhrtghpthhtohephhgrnhhsrdhhohhlmhgsvghrghesfigutgdrtgho
    mhdprhgtphhtthhopegulhgvmhhorghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hnrghohhhirhhordgrohhtrgesfigutgdrtghomhdprhgtphhtthhopehhtghhsehlshht
    rdguvg
X-ME-Proxy: <xmx:sN8FajAh7mZw5pAoxP2-gNAORCUpf5zJQzX_-MvO-mUPyznP6QJryA>
    <xmx:sN8FauvPsyUvDXXt4s9MvOuI2r-ArxQDDZXppSIq78wWDJ4qQuiYJg>
    <xmx:sN8FavemuPGCU0ZBusMXX2oYjGMCDbMB1gIdrLB5yJMgxMcVcL9LyA>
    <xmx:sN8Far9RGHK5QInO6XU0LEjGZPDOE8E0oYHayH6TLSQJDnptCGilow>
    <xmx:sN8FaosmPESLUcIhJtkOqdhuz-Lq5RGOcwhyy5n73MQX4cPtUWVtZNCP>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 May 2026 10:43:59 -0400 (EDT)
Date: Thu, 14 May 2026 07:43:48 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/7] btrfs: fixes around generic/747 on zoned filesystems
Message-ID: <20260514144348.GA1197064@zen.localdomain>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513123445.43197-1-johannes.thumshirn@wdc.com>

On Wed, May 13, 2026 at 02:34:38PM +0200, Johannes Thumshirn wrote:
> This series fixes premature ENOSPC errors and starvation issues on zoned BTRFS
> filesystems when running xfstest generic/747, which tests garbage collection
> on zoned block devices using direct and buffered I/O.
> 
> The investigation revealed two distinct issues:
> 
> 1. Async reclaim starvation: On zoned filesystems, the flush state machine
>    only executes RECLAIM_ZONES and RESET_ZONES in later flush states
>    (FLUSH_DELALLOC and beyond). By the time these states are reached,
>    ticket waiters can starvation waiting for space that can only be freed

"can starvation" reads like a typo or lost sentence edit

>    by zone reset. The fix adds RECLAIM_ZONES and RESET_ZONES to the first
>    async reclaim loop (FLUSH_ALLOC) specifically for zoned filesystems,
>    ensuring zone reset happens early enough to free space for pending
>    allocation tickets.
> 
> 2. Inaccurate statfs reporting: On zoned filesystems, space in block
>    groups that has been freed but not yet reset is tracked in
>    bytes_zone_unusable. This space cannot be used for new allocations
>    until zone reclaim resets the zones, but it was being reported as
>    available space in statfs. This caused statfs to over-report free
>    space, leading to ENOSPC errors when applications tried to allocate
>    based on the reported free space. The fix subtracts bytes_zone_unusable
>    from total_free_data in the statfs calculation for zoned filesystems,
>    with proper RAID factor multiplication for unit conversion.
> 
> Additionally, the series fixes a bug in data relocation block group selection
> where the first block group was incorrectly skipped, and adds a new flush
> state (BTRFS_RESERVE_FLUSH_DATA_RELOCATION) to use priority reclaim for
> zoned data relocation operations.
> 
> 
> Johannes Thumshirn (7):
>   btrfs: zoned: document RECLAIM_ZONES flush state
>   btrfs: zoned: decode 'RECLAIM_ZONES' state in tracepoints
>   btrfs: zoned: always set data_relocation_bg
>   btrfs: zoned: don't account data relocation space-info in statfs free
>     space
>   btrfs: zoned: subtract zone_unusable space in statfs
>   btrfs: zoned: fix deadlock waiting for ticket during data relocation
>   btrfs: zoned: add RECLAIM_ZONES and RESET_ZONES to first async reclaim
>     loop
> 
>  fs/btrfs/delalloc-space.c    |  2 ++
>  fs/btrfs/space-info.c        | 18 ++++++++++++++++++
>  fs/btrfs/space-info.h        | 11 +++++++++++
>  fs/btrfs/super.c             |  5 ++++-
>  fs/btrfs/zoned.c             |  6 +++---
>  include/trace/events/btrfs.h |  1 +
>  6 files changed, 39 insertions(+), 4 deletions(-)
> 
> -- 
> 2.54.0
> 
