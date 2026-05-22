Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB6F357CFB
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779474454; cv=none; b=q3UrBhXvJEmQucykvhZab7orD5uW72OpNtmgoK2cBNk2IVRCVBnj40HOqZzD/IYSTwJvd2wbjEh+yMSow+0wgMRkP01Zig/teXSpqI7z98Q9eTfU1dqXXedZLdnTXNUOIgOh18grMjJROMFZkh1kICN88GNU3p0+vbXs6DFsLyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779474454; c=relaxed/simple;
	bh=JmvrPnJC3Q/hn2/zlYmRrjm58EYRUOamyYv4vbWr4Bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p4M3XYMhDCrLaFk4n6tnodzOYPwAjXVHQmQ98dbjc/LZK7s+qnO4CQwphprWA7uZkZjX/jwDEp+H6N+5U40VSsfeyrV93pZBxcsDt1HRQat5RBIlCh2n0j5S3frtB6EPQp7WcMwPJn6xtwZOYGdC1lmSr77bYvq0yXdXK48bInU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Mgnh12KW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NZxalkNN; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Mgnh12KW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NZxalkNN"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 91C0A1D0005C;
	Fri, 22 May 2026 14:27:31 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 22 May 2026 14:27:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779474451; x=1779560851; bh=sXuF1Cz3Oe
	uWtER8neLcjmv4xNKk+OHyIP1VcIaoqTE=; b=Mgnh12KWXpcKRqT7rZ96ZxSy+H
	P6DPmfVuNgA98KMvXwMwSJzAAM7NiJ73Z3MieTspLsN4upI2oXAzfOEAydb8iFxU
	JimgBSwt5ld+L0cyJoOXF8WAj3SCLKNzzFc7sA2uCYKlm9EWLwYykJyH4srWuaK7
	4agWi/qzJGhDOB5h3avsYSmOh8h94nk03n256dIYLgKx/ecT0woGth4c3SAycEJl
	zMf6NxSpUF7vTxrdUNcR4vFf8Qc/fbDxb9DcTOdfNzu/pxiISNiLShu77bGqsGTt
	qcLg3l740ekStOnhe2XS1zSI65J0AsQy6GNyj1zhLEPFCh5AAfUAYVJQQJyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779474451; x=1779560851; bh=sXuF1Cz3OeuWtER8neLcjmv4xNKk+OHyIP1
	VcIaoqTE=; b=NZxalkNNDUcg408+MOgkdVFK5tW9QOunqhMqupA4lSUrW64j5hZ
	LqCYKKCwZ4Jn+lPNBs9VfhqWchUXY1vHYQbgaB1AK9gGOUO/2UPvlxG1gLxVjX73
	sLP0JVuzpcY0Hs6iY/SAFD3NEag/V39M5V5fJ9OyobLLTEd0XE+2IvZ254exG9fP
	lWAc9dGh8T4/o9Tm6ESngFNmUreRgVRgKhjcaj2rkgAT6EbnmD5ESGW2oT+GaBuq
	irMI/wVCkCD488kpQ9cab56xhY7EwVqdgvLOpaKADu+w7gmWSNvgiMZdaCrs7PqA
	18ecd5ERzXUhR1qY3OKQ9dmhQY5TV+il1nw==
X-ME-Sender: <xms:EqAQapBrK9HiHiIEypQbCD7-4TzfRb_W7PzbBBSBJd3j_sYhIIhXGQ>
    <xme:EqAQamknSalQINS0HeX9_KsN0wR5W0ixcBSJ43B5Mrzot3GA6x8IE0RVilg1E7rVN
    px-REtCn1PdmFy3QI1gX6qTsnmU3eaP9_Tyt1dg7IEPy6mYL-vd_CH9>
X-ME-Received: <xmr:EqAQaqzb5sMDDdgSrbTkRWxFuigcG526zjReFH6Rpqdi_1IwfjgoJkrw28_-U4Syb9h4VUZxpJkrEd-24q6cNpjC40s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtkeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:EqAQagQuIfKikL6Q2iUK1Ykht_PhRMmStfwoHQowWRIVvvzHhAlRkQ>
    <xmx:EqAQai--ZvP0TeflckSsXO0jFTRmU_wzsPDS7EntG5OtSNe5nvnK5Q>
    <xmx:EqAQausxqee0-XDGFTrnR3S2MObQFoT9CZzsPJiXMJEnDvlS-UUw3g>
    <xmx:EqAQaqOzSvdbnDjy06lwQYyOfDevYtdpM_5xYpzr51t8rxs1T_ArKw>
    <xmx:E6AQau9kptiLMUeglWRq3BKUQPqsRk3QkvQY7eObCXO3SY-mrib593PK>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 14:27:30 -0400 (EDT)
Date: Fri, 22 May 2026 11:27:25 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 3/5] btrfs: zoned: always set data_relocation_bg
Message-ID: <20260522182659.GA3065517@zen.localdomain>
References: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
 <20260522090247.27445-4-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522090247.27445-4-johannes.thumshirn@wdc.com>

On Fri, May 22, 2026 at 11:02:45AM +0200, Johannes Thumshirn wrote:
> When searching for a data relocation block-group on mount,
> btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
> block-group. But it first checks if the block-group is empty and if yes
> continues the search, and then checks if it is the first DATA block-group.
> 
> There is actually no point in looking for the second empty DATA block
> group as new DATA allocations will just allocate a new chunk for it. Pick
> the first DATA block-group without any allocations done and set it as
> relocation block-group.
> 

Looks good, thanks.
Reviewed-by: Boris Burkov <boris@bur.io>

> Singed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 16dd87aa06f2..a4d2fb774f72 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2763,7 +2763,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
>  	struct btrfs_block_group *bg;
>  	struct list_head *bg_list;
>  	u64 alloc_flags;
> -	bool first = true;
>  	bool did_chunk_alloc = false;
>  	int index;
>  	int ret;
> @@ -2784,13 +2783,9 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
>  again:
>  	bg_list = &space_info->block_groups[index];
>  	list_for_each_entry(bg, bg_list, list) {
> -		if (bg->alloc_offset != 0)
> -			continue;
>  
> -		if (first) {
> -			first = false;
> +		if (bg->alloc_offset != 0)
>  			continue;
> -		}
>  
>  		if (space_info == data_sinfo) {
>  			/* Migrate the block group to the data relocation space_info. */
> @@ -2849,7 +2844,6 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
>  		 * We allocated a new block group in the data relocation space_info. We
>  		 * can take that one.
>  		 */
> -		first = false;
>  		did_chunk_alloc = true;
>  		goto again;
>  	}
> -- 
> 2.54.0
> 
