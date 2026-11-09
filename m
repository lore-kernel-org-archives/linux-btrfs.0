Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794258147;
	b=yOjvY+vbxABC3cQmvrH+14MAlGm0p4D23eum+oC7ZbtNhVH41xyZmB1iJh6cNsauzP4f
	 xggfYl3NUc/mNZ8eVBAOPeOuss9sUyzYOyvsksx9W7je8/hc7AGxl3+C59+3ePajCGMZt
	 dqc4pFsXjo+9uNYXzQ6JGtPMZbSPS2M99K+wpQ70I73VYMOQtrx0d+KnaHQuHenA4gsQx
	 d93GiW5lITy1pV5ovZ4Ps7jZmJofrTv52K6lmH1c9KO4OhF9X7klbp6wF0qk3JLSUUlG5
	 uYRKHiQ/o48qhBTSlt2XPobKl5orDDJooifNGv1SJwpswJRRh4gYxYKAekroqGpwiBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794258147;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=vMePAli5N8d45M5tsXKHvqZNGEVaq2NnVMDk8OLiCE4=;
	b=NBh28IzWuqBpooPisFHIovzV4eEh78JWSgaYAL+7JBp+HHAuJ6TIBS11gEVHKMtW2wSP
	 UZqUZMnPCCyeC3oJa27I/NAt5ntHcNzKr/TJl6yXHdp9q7wCj1clunJ/Bk9zOqHkQAmRT
	 9QCv7tDz5F+HMhdvHmy+KLwOESuQEnUOLwphims0NaV8LgOhn+wLuK3ksWQXBTFh+EspJ
	 ilCD/qVLUldPOUiXhsWuYLs/FQTB4Ey1Ly4QpRooXRr7grw7CJUh800l1WupaeoHkrO9M
	 MCbAQRn5OB8Xb/Yr6L88AVXq34oc+oP1kqEmdlUSsKRkXOZJL7vpVvm7zGtZ+SPXyYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=MIkICBff;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=v1r6MUvi;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609BC606A326
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 21:02:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 609BC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=MIkICBff;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=v1r6MUvi
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5A8D81400124
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 16:02:25 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 09 Nov 2026 16:02:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1794258145; x=1794344545; bh=vMePAli5N8
	d45M5tsXKHvqZNGEVaq2NnVMDk8OLiCE4=; b=MIkICBff5hGvt8CFpzHxEmIr+g
	wadLPTuow6OGbEBJ0uCEf+s6wxNCBBTs/uNSDxfKVqUa7qfJIXX6GjoPN+TPKqnS
	rU0WVr8XTcknjb39NYHKbMudhq8MaYXT5D/NgavZagyYqa3HSVglbaWqEaV2Fy3A
	5ZKKkK6ijUejjjWYJY25jqQCzerql4VLmTzutFXanpJBKG8Whb2lCnpUOJEpU6w1
	oLvhF03Rb5S77/unrxxMCYPmJWKEJGeM5Omh9FXPY2/Scr008CJLYlQDOBmL9D8H
	4Yv54ztnErGtgf4xjtl1cAQ96xZUgArYsfhN/Rk+deFeJV5esy5dBHfSwflg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794258145; x=1794344545; bh=vMePAli5N8d45M5tsXKHvqZNGEVaq2NnVMD
	k8OLiCE4=; b=v1r6MUvibnvqwgWRZw08xe1YXbUeEiGcIn/ZcKzWgRTEmp5UWh8
	gz+pwoD1s001XWnT7/h6mD9rMybrEhKF23VUx0V2dwnXr9jXVEyUf1B6+zFy8CwY
	tg34eK0vsehBeIDLRyF01Tz/LZtqv2a1LgaS3Pkl+DBS6YMmh6A48Y4NQE1MIP/0
	4c0OAUL30GKjRsEgLH+TepbJk9KoP2HZWG1pFkKyChPdchLn0pl4zgn3DQrkqS63
	1P1aCCUiiUegeHR+vo/g1UPZXqzneLXmAXS9uj+/AFdYlxG/F7DWKgc4rKaP2IlA
	Zxb5y41432rdomxjZEufjAqnym9MxvK+C3A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794258145; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:Gq60Ndtpd7hCybWVr5b5odAS6FbzRUzJTuzUVU8jnLfuY40
	yJctdX3U0z28jgaPpUX7xgBOLkaFM1gTs2PxTKpmZCeFqq488GHjJiHomPK/QjOy
	lV8a/qVCowFSN5g0sPC+0hb0MVRQS+zD03R0kfM+T76tGW61/k27A0/D3lrVo5tR
	9qUES9GsqKJNW7nX912eh0QRsai/WBldu5mNIlhAaPFLSqBTODooRxlXAW0po0ag
	kirjPVLUQIoq+Cdu6PcTHKxT0Wp5kfPAT4bovleCcu6vQmqFuK6MhIyaz/8kPRrz
	hWtsH4yv3pqteAEqyrbUqmzL+vekfxOHbcGFKKw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:VCr/dmiUfbC12mr7JMfbeSFiR+ZzZjpbczTeqcSzWUY=:ybZcKTelcP87LPCbJIq4FoVBqfISIKTb6Sv3Zwu6VK4=;
X-ME-Sender: <xms:4DTyalZKsLbvBDtcMPqD__3LnyzVTunKQprCpdwfR5tb1PMOzsXWJw>
    <xme:4DTyaj3i8vj6mAcH2lrzcZrfpyfHcddeLsnBG0jrYKPV6nX7gD7kcA4naAmt5XtoP
    lPBvrV8isZNmQniMfuqc42wkovXWrqa9QWpT754LJv30YAMN_Wszmk>
X-ME-Received: <xmr:4DTyalUqZ-FfAW_VgksAq-7f39KtB9A5ucPhFOk0iWFVdoc_ZGJgBpPQ>
X-ME-Proxy-Cause: dmFkZTExTZNvOMMGJgpNFd0vE/g1HWSTjFtSNl3YP/Hc8zGXUW/YsEvzvLUenNSyzn1Qmg
    LxYslVlm+71+K18GlFGR4wEDWKfWo92Drgw54767PQ94PnouQDehsVWVuVacTo+vuK6yMb
    5bj6rL5A73s8zmiMkTkP/G832VRJmqNd17bTTACiNZmwHsKxO9kQ4f8IVh/WOUhV7zW0uf
    guA/B5Z/uBRNweIvdtlpF9XmE8iY9c6OeYkYARSE4i9pjyMT2mnaoJRE8GAYik6VlrAI7N
    L/5Q3wlMsOJokv2sp3MVxLseUxBzB14ibQ0z236KGGi3sIZb6OyDIcTz77Fu7M4MY9cltn
    r5hX3X6IghsZJ4PsVIGwtJoxlCWfdUJvnrTA2RaEWMG5h5iATmvgThddtN3cdLKbcWMRhk
    Vt+Ybd2T3583+2D3AXsSWYeLwUcMelvv8TgZ1R5H4Zm2r72og0VKfzHXU/sNnkrufP7Tte
    lXtEEP5AX1si6mLBAmo7DZnUmNXEKQ2UfrHXg8/zax9mMId2PK4Hx2lYfPZJ3UUSCSj/Z7
    GfIik72eSzwVHvuMyY3UPo0wrOT+rETCRLz+v0RKl2xWyBZE8i7CsdZxHaiZpk6i3tNgUX
    13H9+FIXyhQo9RMS24+2JbqY//WSmzgL+ZZeyr2pCJzuil1X+wJmiqxU3I1Q
X-ME-Proxy: <xmx:4TTyatXnG06wRuHhm4gcuzRL7Lu64sFQIcqZWi3P9dDOgYjHEcfylA>
    <xmx:4TTyakeP6CynOPw8GkAjgnSFkpyIm1aLUx-A2tqriWZLqh_g1E2EqA>
    <xmx:4TTyamVMxMFQM4PsN38lT5kplvu9Y-Qd64ZzDyY6hy3lpW4UjEP_ZA>
    <xmx:4TTyatdOJk6jeC0lSGjGq_6rITEBXcxXu3NVg1zNNCh_xD71FASDjA>
    <xmx:4TTyaiOE9AZsgIZifMsohCa-vTtfqAS0BtFPsCWf0kjMUg5tMpRFK4i->
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 16:02:24 -0500 (EST)
Date: Mon, 9 Nov 2026 13:02:29 -0800
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v6 05/25] btrfs: zoned: use the regular allocator for
 conventional metadata block groups
Message-ID: <20261109210229.GA2405023@zen.localdomain>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
 <20261028182111.160492-6-johannes.thumshirn@wdc.com>
 <20261106200156.GD401465@zen.localdomain>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106200156.GD401465@zen.localdomain>

On Fri, Nov 06, 2026 at 12:01:56PM -0800, Boris Burkov wrote:
> On Wed, Oct 28, 2026 at 07:20:51PM +0100, Johannes Thumshirn wrote:
> > The zoned allocator hands out space strictly sequentially from
> > block_group::alloc_offset and accounts everything freed below it as
> > zone_unusable, so freed tree blocks can only be reclaimed by relocating
> > the whole block group.
> > 
> > A metadata or system block group backed by conventional zones only can
> > be overwritten in place, so it can use the regular free space cache and
> > the free space cache based (unclustered) allocator instead, and freed
> > tree blocks become immediately reusable.
> > 
> > Pick the allocation scheme per block group rather than per filesystem,
> > replace the filesystem wide zoned tests in the free space tracking, the
> > space accounting and the extent allocator with a check if the
> > block-group is append only.
> > 
> > Such block groups no longer need an allocation pointer either, so skip
> > calculate_alloc_pointer() for them when loading the zone info. As a
> > consequence they are no longer marked active and put on
> > fs_info::zone_active_bgs.
> 
> I guess my million dollar question on this patch (and I suppose the
> previous one..) is what happens if you are in a raid profile and add
> a sequential device to the fs? Or some similar operation like that
> which could theoretically change the zoned-only state of a bg live.
> Is this possible at all? I was tracing the device add code and don't
> really see it, so I am leaning no.

I followed up on this question with an AI a bit and I believe that dev
replace is currently dangerous (with or without your patch set) w.r.t
BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE. You can create a block group on a dev
with conventional zones then do a replace to a device with sequential
zones and not update the field. In my AI-made reproducer this hanged the
system. In your patch set I imagine it could also lead to illegal
allocations.

So I don't think it's a problem with your patches per-se, but probably
something worth hardening / addressing as well.

> 
> If it is a static property of the bg, then I think it would probably
> make sense to just store it as a variable at the time it is computed
> once. If it is indeed a dynamic property, then I am suddenly a lot more
> scared of how everything works when the result of the test can change
> inconsistently in some larger computation. Like we allocate some
> resource in "zoned bg is append only mode" then don't free it because by
> the end it is now not in append only mode.
> 
> > 
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > ---
> >  fs/btrfs/block-group.c      | 16 ++++++++--------
> >  fs/btrfs/extent-tree.c      | 38 +++++++++++++++++++++++++++++--------
> >  fs/btrfs/free-space-cache.c | 23 +++++++++++-----------
> >  fs/btrfs/zoned.c            |  6 ++++++
> >  4 files changed, 56 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> > index b29070b51b92..772b6cfecaa5 100644
> > --- a/fs/btrfs/block-group.c
> > +++ b/fs/btrfs/block-group.c
> > @@ -953,8 +953,8 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait)
> >  	struct btrfs_caching_control *caching_ctl = NULL;
> >  	int ret = 0;
> >  
> > -	/* Allocator for zoned filesystems does not use the cache at all */
> > -	if (btrfs_is_zoned(fs_info))
> > +	/* The append only allocator does not use the cache at all */
> > +	if (btrfs_zoned_bg_is_append_only(cache))
> >  		return 0;
> >  
> >  	/*
> > @@ -1455,7 +1455,7 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
> >  
> >  	if (!ret) {
> >  		sinfo->bytes_readonly += num_bytes;
> > -		if (btrfs_is_zoned(cache->fs_info)) {
> > +		if (btrfs_zoned_bg_is_append_only(cache)) {
> >  			/* Migrate zone_unusable bytes to readonly */
> >  			sinfo->bytes_readonly += cache->zone_unusable;
> >  			btrfs_space_info_update_bytes_zone_unusable(sinfo, -cache->zone_unusable);
> > @@ -2553,8 +2553,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
> >  	}
> >  
> >  	/*
> > -	 * For zoned filesystem, space after the allocation offset is the only
> > -	 * free space for a block group. So, we don't need any caching work.
> > +	 * For an append only block group, space after the allocation offset is
> > +	 * the only free space. So, we don't need any caching work.
> >  	 * btrfs_calc_zone_unusable() will set the amount of free space and
> >  	 * zone_unusable space.
> >  	 *
> > @@ -2564,7 +2564,7 @@ static int read_one_block_group(struct btrfs_fs_info *info,
> >  	 * in and be done with it.  This saves us _a_lot_ of time, particularly
> >  	 * in the full case.
> >  	 */
> > -	if (btrfs_is_zoned(info)) {
> > +	if (btrfs_zoned_bg_is_append_only(cache)) {
> >  		btrfs_calc_zone_unusable(cache);
> >  		/* Should not have any excluded extents. Just in case, though. */
> >  		btrfs_free_excluded_extents(cache);
> > @@ -3246,7 +3246,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
> >  	spin_lock(&sinfo->lock);
> >  	spin_lock(&cache->lock);
> >  	if (!--cache->ro) {
> > -		if (btrfs_is_zoned(cache->fs_info)) {
> > +		if (btrfs_zoned_bg_is_append_only(cache)) {
> >  			/* Migrate zone_unusable bytes back */
> >  			cache->zone_unusable =
> >  				(cache->alloc_offset - cache->used - cache->pinned -
> > @@ -3728,7 +3728,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
> >  
> >  	if (bg_ro)
> >  		space_info->bytes_readonly += num_bytes;
> > -	else if (btrfs_is_zoned(cache->fs_info))
> > +	else if (btrfs_zoned_bg_is_append_only(cache))
> >  		btrfs_space_info_update_bytes_zone_unusable(space_info, num_bytes);
> >  
> >  	space_info->bytes_reserved -= num_bytes;
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 9b0a5c6b96f3..c33f724fc04a 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2896,7 +2896,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
> >  
> >  		if (readonly) {
> >  			space_info->bytes_readonly += len;
> > -		} else if (btrfs_is_zoned(fs_info)) {
> > +		} else if (btrfs_zoned_bg_is_append_only(cache)) {
> >  			/* Need reset before reusing in a zoned block group */
> >  			btrfs_space_info_update_bytes_zone_unusable(space_info, len);
> >  		} else if (return_free_space) {
> > @@ -3685,8 +3685,8 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
> >  	 * contend with.
> >  	 */
> >  
> > -	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags)
> > -		     || btrfs_is_zoned(fs_info)) {
> > +	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags) ||
> > +	    btrfs_zoned_bg_is_append_only(bg)) {
> >  		pin_down_extent(trans, bg, buf->start, buf->len, true);
> >  		btrfs_put_block_group(bg);
> >  		return 0;
> > @@ -4037,7 +4037,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
> >  	int ret = 0;
> >  	bool skip = false;
> >  
> > -	ASSERT(btrfs_is_zoned(block_group->fs_info));
> > +	ASSERT(btrfs_zoned_bg_is_append_only(block_group));
> >  
> >  	/*
> >  	 * Do not allow non-tree-log blocks in the dedicated tree-log block
> > @@ -4191,11 +4191,28 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
> >  	return ret;
> >  }
> >  
> > +/*
> > + * On a zoned filesystem ffe_ctl->policy is BTRFS_EXTENT_ALLOC_ZONED, but block
> > + * groups that are not append only are allocated from with the regular free
> > + * space cache. As prepare_allocation_zoned() does not set up a cluster, this
> > + * always ends up in find_free_extent_unclustered().
> > + */
> > +static enum btrfs_extent_allocation_policy
> > +bg_alloc_policy(const struct find_free_extent_ctl *ffe_ctl,
> > +		const struct btrfs_block_group *block_group)
> > +{
> > +	if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED &&
> > +	    !btrfs_zoned_bg_is_append_only(block_group))
> > +		return BTRFS_EXTENT_ALLOC_CLUSTERED;
> > +
> > +	return ffe_ctl->policy;
> > +}
> > +
> >  static int do_allocation(struct btrfs_block_group *block_group,
> >  			 struct find_free_extent_ctl *ffe_ctl,
> >  			 struct btrfs_block_group **bg_ret)
> >  {
> > -	switch (ffe_ctl->policy) {
> > +	switch (bg_alloc_policy(ffe_ctl, block_group)) {
> >  	case BTRFS_EXTENT_ALLOC_CLUSTERED:
> >  		return do_allocation_clustered(block_group, ffe_ctl, bg_ret);
> >  	case BTRFS_EXTENT_ALLOC_ZONED:
> > @@ -4209,7 +4226,7 @@ static void release_block_group(struct btrfs_block_group *block_group,
> >  				struct find_free_extent_ctl *ffe_ctl,
> >  				bool delalloc)
> >  {
> > -	switch (ffe_ctl->policy) {
> > +	switch (bg_alloc_policy(ffe_ctl, block_group)) {
> >  	case BTRFS_EXTENT_ALLOC_CLUSTERED:
> >  		ffe_ctl->retry_uncached = false;
> >  		break;
> > @@ -4349,8 +4366,13 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
> >  		return 1;
> >  
> >  	/* See the comments for btrfs_loop_type for an explanation of the phases. */
> > -	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE)
> > -		return -ENOSPC;
> > +	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
> > +		if (ffe_ctl->empty_size == 0 && ffe_ctl->empty_cluster == 0)
> > +			return -ENOSPC;
> > +
> > +		ffe_ctl->empty_size = 0;
> > +		ffe_ctl->empty_cluster = 0;
> > +	}
> >  
> >  	ffe_ctl->index = 0;
> >  	/*
> > diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> > index bff6e5b372d6..5d830a827cda 100644
> > --- a/fs/btrfs/free-space-cache.c
> > +++ b/fs/btrfs/free-space-cache.c
> > @@ -26,6 +26,7 @@
> >  #include "accessors.h"
> >  #include "file-item.h"
> >  #include "file.h"
> > +#include "zoned.h"
> >  #include "super.h"
> >  #include "relocation.h"
> >  
> > @@ -1370,7 +1371,7 @@ static int __btrfs_add_free_space(struct btrfs_block_group *block_group,
> >  	int ret = 0;
> >  	u64 filter_bytes = bytes;
> >  
> > -	ASSERT(!btrfs_is_zoned(fs_info));
> > +	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
> >  
> >  	info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
> >  	if (!info)
> > @@ -1499,7 +1500,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
> >  	if (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)
> >  		return 0;
> >  
> > -	if (btrfs_is_zoned(block_group->fs_info))
> > +	if (btrfs_zoned_bg_is_append_only(block_group))
> >  		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
> >  						    true);
> >  
> > @@ -1512,7 +1513,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
> >  int btrfs_add_free_space_unused(struct btrfs_block_group *block_group,
> >  				u64 bytenr, u64 size)
> >  {
> > -	if (btrfs_is_zoned(block_group->fs_info))
> > +	if (btrfs_zoned_bg_is_append_only(block_group))
> >  		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
> >  						    false);
> >  
> > @@ -1529,7 +1530,7 @@ int btrfs_add_free_space_async_trimmed(struct btrfs_block_group *block_group,
> >  {
> >  	enum btrfs_trim_state trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
> >  
> > -	if (btrfs_is_zoned(block_group->fs_info))
> > +	if (btrfs_zoned_bg_is_append_only(block_group))
> >  		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
> >  						    true);
> >  
> > @@ -1548,7 +1549,7 @@ int btrfs_remove_free_space(struct btrfs_block_group *block_group,
> >  	int ret;
> >  	bool re_search = false;
> >  
> > -	if (btrfs_is_zoned(block_group->fs_info)) {
> > +	if (btrfs_zoned_bg_is_append_only(block_group)) {
> >  		/*
> >  		 * This can happen with conventional zones when replaying log.
> >  		 * Since the allocation info of tree-log nodes are not recorded
> > @@ -1663,10 +1664,10 @@ void btrfs_dump_free_space(struct btrfs_block_group *block_group,
> >  	int count = 0;
> >  
> >  	/*
> > -	 * Zoned btrfs does not use free space tree and cluster. Just print
> > -	 * out the free space after the allocation offset.
> > +	 * Append only block groups do not use free space tree and cluster.
> > +	 * Just print out the free space after the allocation offset.
> >  	 */
> > -	if (btrfs_is_zoned(fs_info)) {
> > +	if (btrfs_zoned_bg_is_append_only(block_group)) {
> >  		btrfs_info(fs_info, "free space %llu active %d",
> >  			   block_group->zone_capacity - block_group->alloc_offset,
> >  			   test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
> > @@ -1838,7 +1839,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group *block_group,
> >  	enum btrfs_trim_state align_gap_trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
> >  	bool use_bytes_index = (offset == block_group->start);
> >  
> > -	ASSERT(!btrfs_is_zoned(block_group->fs_info));
> > +	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
> >  
> >  	spin_lock(&ctl->tree_lock);
> >  	entry = find_free_space(ctl, &offset, &bytes_search,
> > @@ -1971,7 +1972,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
> >  	struct rb_node *node;
> >  	u64 ret = 0;
> >  
> > -	ASSERT(!btrfs_is_zoned(block_group->fs_info));
> > +	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
> >  
> >  	spin_lock(&cluster->lock);
> >  	if (bytes > cluster->max_size)
> > @@ -2789,7 +2790,7 @@ int btrfs_trim_block_group(struct btrfs_block_group *block_group,
> >  	int ret;
> >  	u64 rem = 0;
> >  
> > -	ASSERT(!btrfs_is_zoned(block_group->fs_info));
> > +	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
> >  
> >  	*trimmed = 0;
> >  
> > diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> > index 554688fc7030..1235acda375d 100644
> > --- a/fs/btrfs/zoned.c
> > +++ b/fs/btrfs/zoned.c
> > @@ -1964,6 +1964,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
> >  	}
> >  
> >  	if (num_conventional > 0) {
> > +		if (map->num_stripes == num_conventional &&
> > +		    !btrfs_zoned_bg_is_append_only(cache)) {
> > +			cache->zone_capacity = cache->length;
> > +			goto out;
> > +		}
> > +
> >  		ret = calculate_alloc_pointer(cache, &last_alloc, new);
> >  		if (ret) {
> >  			btrfs_err(fs_info,
> > -- 
> > 2.56.0
> > 
