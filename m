Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08F03D9DB3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778865981; cv=none; b=U3vQHkCsdtRFuBBlqm5Y8DKgxBu5wRssA9pPL1lmZrdGgSU03lTq+CYyzTnaSBcaFiQZLOxWt630xjLHX4U7/n8ApmfSn1IrIV6s8ZDgm0bwwsz6grqf6Oqp7e3pOv4szS7A/wLynt/fL21McYr65hdwXCvU1DHvaBaZsppKs/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778865981; c=relaxed/simple;
	bh=3IwAwThCl3VPXR2weERodI3k5FuKFqUjyZj0vWY25zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jv7+lo7cpghb82/Ba6zjlO2yaVRLJ9tAiE+/7qa7i/VsBVI2/F8Yjnjt1jNw7ydThmPKruvp4DKq5RGaOgACgailoRACarD/ml6LpStJ55S2wti+FKuZQ0D49miwfcpI62jfrTQJ9zB64kPIZ9XPjhRpMwwwJJEgEWqMbdBLjQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Ou6HU2rM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fjGAGuHb; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Ou6HU2rM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fjGAGuHb"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D354C14000E9;
	Fri, 15 May 2026 13:26:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 15 May 2026 13:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1778865978; x=1778952378; bh=iAcq4lMiYi
	2Iwye/z6Zqn+JR0Us+XRxurFQhVKUv7hk=; b=Ou6HU2rM7hTBsJjnyL7yUmYob3
	cBzGKFXUXJhdlrC8QyrsqNdKeVb4aJ0AePiCsJBJYlsAoypz+c5wXZnkcNKF5W0p
	Ey28zg9qCVBlp/9Yt5eKzbvqfsc89wEZa5/gLuN209yFf2KwbikQ7ztBloB1yIQF
	wKXSGGFPcezjaHsC8jw8anBpdbwgdMa1rzBRdH5LUHVR/FC390KS8BClyOhNocP/
	8s1cXxhV1yf0atLDgKWJThBrdmRW8T61ix4eQL7g5GDs/P1koEcbEab4/VztHsdM
	gQR8d936F8YUMAFNFueoanV+CgaCVuwrfO8kFVfjh+0qK3+LLWpT/P+czNcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778865978; x=1778952378; bh=iAcq4lMiYi2Iwye/z6Zqn+JR0Us+XRxurFQ
	hVKUv7hk=; b=fjGAGuHbOTj4vu2snudNF74xMyzIdOfqyOH0RJhBkTjC1sAy2pT
	P9zM/RxnOP12wYdGtfYjtnQGozTg/D70KV5pD4sHcC9/zMCxqecgbIsBnQvxaTtb
	oP5B7IPOWWi1dCJ1f6TDCKjru5xLPGmhuStE1GfYSRur0v8EIeo9WLqz7yT9fRwO
	6cY/JWbhb44VR5kLJuKEZYFbe5isYjL6vbxNq7wFOHu4Aq5yrMHE9mSl3/y1gKwR
	rmXfjfBVuy2UAWaKOD6WGKTkmU0+9WRK8I2EhoPkzkIjp3r80BUAIcpM1q9+Kkxu
	SXzAJgOOu4q50bigWYyQ3bywVjH76aB1fqA==
X-ME-Sender: <xms:OlcHanPFCLt2DJc7x_c6fz6siZMGhY_WyNpbI4pDET1B5BbPRurGyA>
    <xme:OlcHau4hstf_s2GW3A6d3LnbLzTXa4rGUF0G1VKX7AL0IsoacFQ94xyw5R5eaRaLL
    d2djYLApd9B_1Z_oRPdd8N0JTfUY8e0slPPVRl9k_z44trRU80SGTM>
X-ME-Received: <xmr:OlcHah5kpQF5VxGfxodtfqSoWVxMPCbyEzbsQ7aob4v3FHIu0GnF6odLuMp0WB5aSM7Q-qocVwn6fol4cdwSSiWemjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddufedtleelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:OlcHakEjRcMBCo5fdq9rqzFfGktPceEqwBeX6mFSregwNcXUr17cew>
    <xmx:OlcHapVmwAAeFmk48H-6Z1nwP9MAkjr4RSDeYQFwKXUy4_DnTzqBwA>
    <xmx:OlcHagXcNHjs3PvA2IfHI375m1Wpp-c_y6Uq5Wib1N_4OFeBcxV4CQ>
    <xmx:OlcHanIMfglf8-dF_NxLnr9CETbJ76ZndVeqNf1g2intI7B3sfrw3w>
    <xmx:OlcHaqMHT-6a1EkDVN6L6yZ-W641xyZl7IOkGaImLyYWEgq8kMy5C0q_>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 May 2026 13:26:17 -0400 (EDT)
Date: Fri, 15 May 2026 10:26:04 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/7] btrfs: zoned: fix deadlock waiting for ticket during
 data relocation
Message-ID: <20260515172604.GD1197064@zen.localdomain>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-7-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513123445.43197-7-johannes.thumshirn@wdc.com>

On Wed, May 13, 2026 at 02:34:44PM +0200, Johannes Thumshirn wrote:
> When performing data relocation on a zoned filesystem, BTRFS can deadlock
> in handle_reserve_tickets(). The relocation process is waiting on a space
> reservation ticket that can never be fulfilled, because the relocation
> itself is the operation responsible for freeing up that space.
> 
> Fix this by introducing a new flush state,
> BTRFS_RESERVE_FLUSH_DATA_RELOCATION, specifically for data chunk
> allocation during zoned relocation. Like
> BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE, this state uses
> priority_reclaim_data_space() instead of the normal flushing path, which
> avoids re-entering the relocation code and breaking the deadlock cycle.
> 
> In btrfs_alloc_data_chunk_ondemand(), select this new flush state when the
> inode belongs to a data relocation root on a zoned filesystem.

This looks good, but a general question: are any of the other data
flushers valid to run at this point or only chunk allocation?

> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/delalloc-space.c |  2 ++
>  fs/btrfs/space-info.c     |  2 ++
>  fs/btrfs/space-info.h     | 11 +++++++++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 0970799d0aa4..c9d3ec6bbc3c 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -134,6 +134,8 @@ int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes)
>  
>  	if (btrfs_is_free_space_inode(inode))
>  		flush = BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
> +	else if (btrfs_is_zoned(fs_info) && btrfs_is_data_reloc_root(root))
> +		flush = BTRFS_RESERVE_FLUSH_DATA_RELOCATION;
>  
>  	return btrfs_reserve_data_bytes(data_sinfo_for_inode(inode), bytes, flush);
>  }
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index 58256a9c056d..ec811a77ebb1 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -1703,6 +1703,7 @@ static int handle_reserve_ticket(struct btrfs_space_info *space_info,
>  						ARRAY_SIZE(evict_flush_states));
>  		break;
>  	case BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE:
> +	case BTRFS_RESERVE_FLUSH_DATA_RELOCATION:
>  		priority_reclaim_data_space(space_info, ticket);
>  		break;
>  	default:
> @@ -1966,6 +1967,7 @@ int btrfs_reserve_data_bytes(struct btrfs_space_info *space_info, u64 bytes,
>  
>  	ASSERT(flush == BTRFS_RESERVE_FLUSH_DATA ||
>  	       flush == BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE ||
> +	       flush == BTRFS_RESERVE_FLUSH_DATA_RELOCATION ||
>  	       flush == BTRFS_RESERVE_NO_FLUSH, "flush=%d", flush);
>  	ASSERT(!current->journal_info || flush != BTRFS_RESERVE_FLUSH_DATA,
>  	       "current->journal_info=0x%lx flush=%d",
> diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
> index 24f45072ca4b..f2b8be2af5c3 100644
> --- a/fs/btrfs/space-info.h
> +++ b/fs/btrfs/space-info.h
> @@ -77,6 +77,17 @@ enum btrfs_reserve_flush_enum {
>  	 */
>  	BTRFS_RESERVE_FLUSH_ALL_STEAL,
>  
> +	/*
> +	 * This is for relocation on zoned filesystems only. We need to use
> +	 * priority flushing for this, because otherwise we can deadlock on
> +	 * waiting for a ticket, that cannot be granted, because we cannot do
> +	 * any allocations.
> +	 *
> +	 * Apart from being specific to zoned relocation, it is equal to
> +	 * BTRFS_FLUSH_FREE_SPACE_INODE.
> +	 */

Should it be named ZONED_RELOCATION then?

> +	BTRFS_RESERVE_FLUSH_DATA_RELOCATION,
> +
>  	/*
>  	 * This is for btrfs_use_block_rsv only.  We have exhausted our block
>  	 * rsv and our global block rsv.  This can happen for things like
> -- 
> 2.54.0
> 
