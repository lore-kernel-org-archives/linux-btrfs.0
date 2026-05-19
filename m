Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB5926C385
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 23:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779233100; cv=none; b=sd/sbj98LTFzActMbrcnilG7b7G81jeXeqkzf/+BVBlmQcVTfiyvP9rjyJY9tYhJVCyf5Gp72aQjlp1waN1v3MroKO7jzx/qo02JHbP2LY85aZHCvuJ/DoMCanEgDoYR0eSAYPl5d34m1ey6DDpV2ElhjBYO+xY3fzwTJnfDQMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779233100; c=relaxed/simple;
	bh=Nor1GnBYh9UdJR+BkQSR0JME5TUlVjhLo182pq/rLlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAg3mOuJ2l/fJfWQPs5i2Mq2l9gZo1q2BHO79HAMXh17EyvomEmQ0uyro47CSrFw6rDDuv1qQJ7UEZNfz/f5h6hVQVBLi3mmF1zMXvJGd+nTAGl+IBKQLbctQH2mIMJ3yBqVjtVrtNAWgj82z/qC+WoY+APzfJaOTsOwYcvtiTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Fa0EtS5C; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gOO9DVF8; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Fa0EtS5C";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gOO9DVF8"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 0D6AD1D00118;
	Tue, 19 May 2026 19:24:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 19 May 2026 19:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779233097; x=1779319497; bh=YMGyknLujX
	PJ+98XBVXFIoW94w3hw9BoA3cLZsSPVrY=; b=Fa0EtS5CY4esVg1NMPZ3LZjbby
	Pa++k9xuvDRR/7zQZNLtrvnZPRKWpEd+xu8b+ya3jnTJgfmTCEW3vznBRGDN1dzz
	abnqrXxjLpIoTlxtKiMdmig8PrL96feRYN+v9fisq5HAKsfKx9vh9kTrmGOIvOyB
	9BWIAz6Y3XbGR/oD2/nqGvQjjvq6Ovj945zKTYUoKkaEyGjN7a8Kk0ZhLaZ6tzao
	ssWNJVAk8QMQlw1NEOOHEmTjvVILKlk90iTRTMITWCDZmA2ShEwOH42H+gGe/hc+
	S/cJFTH1Ov/4pNuUODn4GxLhuGC5WbK2nvwEh7hgsNwr1cHwkIRT2PfCOabw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779233097; x=1779319497; bh=YMGyknLujXPJ+98XBVXFIoW94w3hw9BoA3c
	LZsSPVrY=; b=gOO9DVF8hXwCbN3g3ISHtvnY98Jzlddc4oZckAIa00e2UmT5KMg
	fPzDe/G6D3yo6zYjYpTUJEIPOIuB/vD7M6V8b9l8ubJRaSk6SL2JIg47AY+EY5JO
	Q29saI9+31WUVOqOIFuU5RJpOhMsbFJ41V5M3rh4NOzb6GV+GqRO/9AkLsbOT76u
	7Y2TNGCaLOucbWCy58heFHkwHFoGRoguRNTjAhkIGVacntJmIUd/w2PoNJsTkfqy
	fguKv8N979mAhwT/Uoi7tS9MU9NOUU7u7LXGONHDJZOstrg5BZOKUtUWMin9nGxd
	vvWUz444CFdSbkz0hRCkn0uz0G5kCt/HEsQ==
X-ME-Sender: <xms:SfEMavi2MIW4SmxC-U39IMpDm3gdNepATZu3LywFdPNzTRgMfU5ouQ>
    <xme:SfEMarGyKcX-mtT7oCmHXKGCm85kwcG8qrsMVq1QnXd9W24ErM6Gdl1Z1b8vOAxJK
    JQ9dDRWK_xF-tNtxqUH_Nf0XeTTNUTROoiyEpj5OQhgXVOV5kUQnno>
X-ME-Received: <xmr:SfEMalTZBDY6E4IQiRVXC7DvK4Nw7rf7jHdnp9NK-w-im7MaALiYZo6bCidcos8SvGQaJc5zRdHkp8Z0j9lR0qLjQLQ>
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
X-ME-Proxy: <xmx:SfEMaoweqwFHHOUv_wkB12FeXbYVO_QFVggKNF9d1p4xS_2PkX50OQ>
    <xmx:SfEMahdYnCxUkA7Taq1iSwKCd-oXPryXw4a0_p3u0NFjzdasOJ4a2Q>
    <xmx:SfEMarMpon13bfMULMPufanJp6DhbJVyNNhkR9WCwSnB8PWq3ZpAgA>
    <xmx:SfEMasvjSV1bajcqTXWSTAkx7ZpUMZ5hkAmUxVqSDclIQcQF0WfCBg>
    <xmx:SfEMahfaUTDAlpHYe1Tr6IiRHw0fU4wLXf2NQw2_POp7I3IkCz-gcglN>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 May 2026 19:24:57 -0400 (EDT)
Date: Tue, 19 May 2026 16:24:57 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 5/5] btrfs: zoned: fix deadlock waiting for ticket
 during data relocation
Message-ID: <20260519232457.GB718937@zen.localdomain>
References: <20260519154902.223445-1-johannes.thumshirn@wdc.com>
 <20260519154902.223445-6-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519154902.223445-6-johannes.thumshirn@wdc.com>

On Tue, May 19, 2026 at 05:49:02PM +0200, Johannes Thumshirn wrote:
> When performing data relocation on a zoned filesystem, BTRFS can deadlock
> in handle_reserve_tickets(). The relocation process is waiting on a space
> reservation ticket that can never be fulfilled, because the relocation
> itself is the operation responsible for freeing up that space.
> 
> Fix this by introducing a new flush state,
> BTRFS_RESERVE_FLUSH_ZONED_RELOCATION, specifically for data chunk
> allocation during zoned relocation. Like
> BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE, this state uses
> priority_reclaim_data_space() instead of the normal flushing path, which
> avoids re-entering the relocation code and breaking the deadlock cycle.
> 
> In btrfs_alloc_data_chunk_ondemand(), select this new flush state when the
> inode belongs to a data relocation root on a zoned filesystem.
> 
> Fixes: e2a7fd22378f ("btrfs: zoned: add zone reclaim flush state for DATA space_info")

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/delalloc-space.c |  2 ++
>  fs/btrfs/space-info.c     |  2 ++
>  fs/btrfs/space-info.h     | 11 +++++++++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 0970799d0aa4..4293a6383433 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -134,6 +134,8 @@ int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes)
>  
>  	if (btrfs_is_free_space_inode(inode))
>  		flush = BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
> +	else if (btrfs_is_zoned(fs_info) && btrfs_is_data_reloc_root(root))
> +		flush = BTRFS_RESERVE_FLUSH_ZONED_RELOCATION;
>  
>  	return btrfs_reserve_data_bytes(data_sinfo_for_inode(inode), bytes, flush);
>  }
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index 739984462677..e6641597b321 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -1705,6 +1705,7 @@ static int handle_reserve_ticket(struct btrfs_space_info *space_info,
>  						ARRAY_SIZE(evict_flush_states));
>  		break;
>  	case BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE:
> +	case BTRFS_RESERVE_FLUSH_ZONED_RELOCATION:
>  		priority_reclaim_data_space(space_info, ticket);
>  		break;
>  	default:
> @@ -1968,6 +1969,7 @@ int btrfs_reserve_data_bytes(struct btrfs_space_info *space_info, u64 bytes,
>  
>  	ASSERT(flush == BTRFS_RESERVE_FLUSH_DATA ||
>  	       flush == BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE ||
> +	       flush == BTRFS_RESERVE_FLUSH_ZONED_RELOCATION ||
>  	       flush == BTRFS_RESERVE_NO_FLUSH, "flush=%d", flush);
>  	ASSERT(!current->journal_info || flush != BTRFS_RESERVE_FLUSH_DATA,
>  	       "current->journal_info=0x%lx flush=%d",
> diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
> index 24f45072ca4b..aa836e8a9d4a 100644
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
> +	BTRFS_RESERVE_FLUSH_ZONED_RELOCATION,
> +
>  	/*
>  	 * This is for btrfs_use_block_rsv only.  We have exhausted our block
>  	 * rsv and our global block rsv.  This can happen for things like
> -- 
> 2.54.0
> 
