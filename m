Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC30926C385
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 23:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779233206; cv=none; b=PppYLiHGfTWYPGMTDc5T+ZRAOuA02hFLigPFhx3hcLlJroVPi9cBGrG5j4Cz6znHsWh6p4em606TOfxKWNAsqIfzxorztVBTI3zLdRii1ARrRlnbscrhMlnou74QZDdLRBNXtPprDmNhgO6Novugq1ETxypdyYu1EdllR0kZSag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779233206; c=relaxed/simple;
	bh=uY1euLsgw7alC6lljXFxKdrc0vQ97DqEDdKHu3nBe/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3P+SDsdhWZfrw/ftjd1loZ6TeomtLVKrD+JomnTVjfVx3ge0CibCCz2mANoXdhKRdhjSynA+TqTX8ZZcNBk8oVfTYI22wNWrhsUN+hwa0y1v2vD8IYRjTvjrQ0OjUG/2cuKUsi3fmnmyZAlCkCyTMvWe9sxU837fL+x7tqIjmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Iq7D0H3o; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=IU4YbcCh; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Iq7D0H3o";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="IU4YbcCh"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 04C9E1D00129;
	Tue, 19 May 2026 19:26:43 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 19 May 2026 19:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779233203; x=1779319603; bh=FWvZouhgf5
	EthZB/LMPFZtft0yjsdpqG16M8WPn5n00=; b=Iq7D0H3oOanyYUhpesRHHJQcrA
	dKHJto9wHpIotWg7J4pUiYjkUxU7oGd70xuvDZ4PtoRPNB1M1h8Ly5CLdNsRmxZz
	L0Vys9Okk0mmDTq/tGHR1zjRi2FgtLa4pxRAT26sYFtmTILCJr/pVFGTBKkpzUGQ
	SlDBKWYNtj8312IsUVdpcnsa2Tt47flWkMpAq8BmdGUZgxiFyEV2wwrr7vTPg9Mj
	AW5m4YqB/9Ai06uuD9+9u8Pomv+nf8dpyEgy/AvLCR0p1mx3rhkTYnEscjlHuDPG
	7762dBbHp9KoSp90V7ffZyJzd3wCMM5nTdosnenVusmTMHYkz4bVmIyJ3T+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779233203; x=1779319603; bh=FWvZouhgf5EthZB/LMPFZtft0yjsdpqG16M
	8WPn5n00=; b=IU4YbcChklkIa8Owi+toXs30uQCnXS5P5MB1KSNErEK+laWnpFL
	tyqn5szWCutrWIZ+dDYyMTTiI+plfnvbgGcQ6mEIDgdf3FMjQCESgkvJeoXBktHR
	FBan5Qz5xu8X510Ax7kzhhkDiWMsiU0x+p60UJEZku2tEAQih95C+ZbyBPUABzvo
	mlTAL5EyN9Ri8Vl5k3wefSfUn5pV6HosSJM4gTaCfeFHAduWvKq+dC4gcs8Miv/N
	DbZNmW/umEuegbdz/JSG5XmsJWD2fZh4Ln+ql5OM1+5VjP5PttHgr39CGOZY8VrE
	WjwoLs2VRyMA5xhDxb04lY9/gPE+D++mpdg==
X-ME-Sender: <xms:s_EMajetbSnNYkN8kCTEubhGeUYdQTeEAnuDFeFFRSftVN86kdw1pw>
    <xme:s_EMaoQlbxy9RrfhXkJBhgFOt9A4yaByDMYdkk5is3bQ6ixXU2mjjMxcUd08lpaUO
    7HyLAFQNaW26USMa17GG9FElTqd5gCxLmAtbxdxLxF92EKJL7pcWqI>
X-ME-Received: <xmr:s_EMaitPRJj1TK0Jb5TxoKS3dpc-cg_QTkofGC7EzWTSkJ-OHbk7r-4m81uDXc2F0H3INDUbzolJsjadggs1CGiscVU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeeftdeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:s_EMahd1w-7WWwcdjiHPEboaSYy-BUzIuvXU7tvKjVy8KDnTEmj17w>
    <xmx:s_EMakYT3k_GC5z62uir0GAOx23Ze4jjwFUjA0-sy4Sf9hEJdrf91A>
    <xmx:s_EMarYWH-A9FmVTT6sWzlOT_tVGWQvEyC9B3_T86s1uoB5nlpY3GQ>
    <xmx:s_EMahKAL6KSSrcvrlQPQNAYkPFfoT2iHxnMUmrmgKIjE1bI2Wq1DQ>
    <xmx:s_EMaj4X7i3ABjMhuZS0etqK6Awh2ldUn9AkAmyVTN0b4mkU9aruXgwJ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 May 2026 19:26:43 -0400 (EDT)
Date: Tue, 19 May 2026 16:26:43 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/5] btrfs: zoned: document RECLAIM_ZONES flush state
Message-ID: <20260519232643.GD718937@zen.localdomain>
References: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
 <20260519154902.223445-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519154902.223445-2-johannes.thumshirn@wdc.com>

On Tue, May 19, 2026 at 05:48:58PM +0200, Johannes Thumshirn wrote:
> Document the purpose of the RECLAIM_ZONES flush state.
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/space-info.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index f0436eea1544..739984462677 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -1411,6 +1411,13 @@ static void btrfs_preempt_reclaim_metadata_space(struct work_struct *work)
>   *   This is where we reclaim all of the pinned space generated by running the
>   *   iputs
>   *
> + * RECLAIM_ZONES
> + *   This state only works for the zoned mode. We scan the block groups in the
> + *   reclaim_bgs_list and check if we can relocate them. If yes perform the
> + *   relocation to garbage collect the zone. On each of these runs
> + *   BTRFS_ZONED_SYNC_RECLAIM_BATCH (5) block-groups will be reclaimed, after all
> + *   unused block-groups have been deleted.
> + *
>   * RESET_ZONES
>   *   This state works only for the zoned mode. We scan the unused block group
>   *   list and reset the zones and reuse the block group.
> -- 
> 2.54.0
> 
