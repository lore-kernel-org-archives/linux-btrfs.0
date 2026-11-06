Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793995304;
	b=q0ppVk/9CXnhXrXjoKcko7T512rf1KwsBZh2zV0NIXgcMkt/JVIhX7cqQC4JomUPBaHK
	 4xYC3qugxLFxA2mwkE0ff37cr/uC3GC1KMdjAG6JXYhcyC8fH7Hp74yp/UdV5TPRz6i7x
	 EyGhqlfJEpINRpgawj+gemXc/VnV2/lsyiNNUgHSAUKmUL8O3eDJ2AhhT+C7AkxyhLkFs
	 UcIAPvivXTSEL5rtPYv4w4aq4TetRLicuQgLzW+plwFQUThdX2nupPvI9AAy9Z31m9y+B
	 aaFsjbQjvsKZqs3AxK3OIp2+oVGGPat5PmGgxPu4r5UBbBbYCOSovou00/e3QIFkg0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793995304;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=6Ejd/t4Qtp7so18BvwHUKhvJINB+HB2w1LmnbNHqqOI=;
	b=YH4Y9y+m9Ma4QvwHtMzDOD/HUB6BAijqfxyqTxqtT4MDNH+V1Mqvj1lNZ26wOlRDEbkl
	 lMWc0rhyASGFCKCkY1o3UV8qLRtLnHbWFBQ6P3Fd3DNmpzbvwD5Cc/ID7T0wfhk2x1+7/
	 BOZFJ+9E7k38ZVxiJ9kNmPyLWBc8pcr1l1w+RErfrt2Fxqww6eq6Ya1UySYdRXs5vNGfL
	 oyOzjSPNJVwl5j2pCsPnZsopVZbMmEatZ12eoWCbp0MbIJAqydXUzCDlfjOwrMA3+kt1W
	 BgqEhi8SLftWGkCVhT84O87By7X9Y9M4u4qxpsH95VamnmX2oRBPrTyBgYQ30u3igKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=SWEEP6Vw;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=RQ4zvUKk;
	arc=none smtp.remote-ip=202.12.124.159
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14C2606A329
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 20:01:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C14C2606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=SWEEP6Vw;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=RQ4zvUKk
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id DAEDE7A019E
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 15:01:42 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 06 Nov 2026 15:01:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793995302; x=1794081702; bh=6Ejd/t4Qtp
	7so18BvwHUKhvJINB+HB2w1LmnbNHqqOI=; b=SWEEP6VwHSlQHduROdWn8wupyj
	+TLwrcV3V4DQVUC63Jhigleakz7bore97e7G5uvDrxh46rn7Nx4DKP5mdn8NK26p
	PiBJ+abPuGBdsFAOEa2gupNyiJ62AtIiPqULAks4kz2JE6CyhFNss+NhHTVXPt2C
	slP2AeArK1MuiVxd7GKVelwmfMMSHMyRaQDJCuweP06Yg6HVcXE8NEiIzdijbzB3
	ERI9it/cdnXfMAyBJgZmIgf9m4/aZ/cnO5LDNCGHQafp7hQ5coHfF7iSt88BT4UO
	UJwnz3eYjVxElaNg9XaheREybI7jtLqOn2+jkm843WZBv3m+nENqkpUYF56A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793995302; x=1794081702; bh=6Ejd/t4Qtp7so18BvwHUKhvJINB+HB2w1Lm
	nbNHqqOI=; b=RQ4zvUKkhzOMEieFTBCq/A1rNh0IFxWi3KHN8pSjUC9BjBTmJVa
	yOC2lzZzvM+UQ3suy/4gVgrJZZ0B+gnbgHkEClHsS2O/2tWgkZv6bgG2WIgovYRF
	TKY4w9be68B6+7AGySNGermDqG1o8XfdXjHoi9qq0jKWpaFKa3gQ4fJXd7xJHvZV
	6zCWSNDBrXkKsMbF8RLBYSv+4sCYI3wgYgjZM9U+Vj9dq/9a4BJ8oVVTqPamts17
	c04RBGzck9fm3sgQD0etAownFQBOYpYSa9DfvuWwhu66MBVXhezUecYek38cehvZ
	KaiW5kR1uDJP9KfmJFdhnWD6dNaOBuXmdHw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793995302; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:bsxJVT3USVVKr8iljBU5MQ+22H4soef7oSCx7bKFVPAMZ/S
	SE0m9NPg9cSzXlm4QpwqyVZIbCN4vv4TeJEz/QeYPc0OJNxMmGJJ/zwWWwfxUJ7a
	HOUcjxog9rKzRXwIw145SElUIfeoeBcPxDc/aHSbp2jPkd0qaKXZ7FCM2r3Zlo30
	yes1bHp5JCG4z+/xhhy5gCs39Wc6TeQNxHuG65Gx3zN4IjflcT1dETjz1HYpO3ed
	BdFpyqPtBeH+4ApjCfh0MJ2jpnYJTEKkSBPKVgclscYYw+a/NpQ8zo/nq+wYMr3s
	ljz/D2nrQtv+y92ddY4FpZbotdcIBcX6Bqavaig==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:mVJp+kySwCya5icYJaJkLD5/cANTaWOhw7RuBDz8LaE=:EU03MR2OsHsUDx02a7YzvdQEM19ns0oY/GqlOp4HF8M=;
X-ME-Sender: <xms:JjLuauUDZ_kPOHH-O4muT0lnC_ruFoFCmepq-9mKOHps-ti2JTO-cA>
    <xme:JjLuaiBeSp2HLnlYw3YuVOD5eF-MueWuZNzXU0GTWSixlxyoQvu3sBXbFrlDNVyRU
    m6_sK8n9wjDFhcq2G5ipq6IoiQrCkBcE6h0GnxaMOy0PUSQLjjYhkAC>
X-ME-Received: <xmr:JjLuavzbOINtJaOaT2XgvON5tujh2DOBqlZT8z7yYqCNjbbbT3uasire>
X-ME-Proxy-Cause: dmFkZTFPIxfJRlnu5eheDyKNxhnbP3cfeokny6VdzzCGUXt+Mlbxp3+xXl4Mem5mYDYs7Q
    6Evfg4Oj2I/p4xNfYOq+XvxwrFDjZZGCZQGt58xA5jMz2X7nnPETDkI4ZoFQWhi7RHuSNm
    ezA+JneCm8x3pnpOYHcX0MxJplJYiajZAbZ490YXfaIbGr90h9FJ4R9uIcWWuv+p4ukE3b
    DALUO6SYA8Pq/uUlQM7hh9NWB0uxP21j7gcUBXzb99fO+lc01UpNY0ZpglBufJISsAr4tM
    zeA93ifkjuDWywKoy5NH4gEv8fgtGNLwZ8I1gIhFfxbieKQb6fAqBOi+QdAWcclHmkhfOA
    X1+b80qxOn/q+qrtS1Vg6+RPu3IK5tP7kBo2QeRPGHf1CJTcfPgi+8PjFvKBBANIARO3Rw
    gOjpHWKc6xkWAw2SomcFxYPNZWF7snkFjdMX97h4uDHXNRrwuASkZ/dqsRHNdLK6Rk2pXf
    unA5I09iISxCbq9UMXiUPTBGNB1GSPUTEB1dJQnxcpC5XJSG/foxSC7VM1nZOfUozNqTqr
    UKQUlSwa0CBC2X+qm9UiKE01cAP2Kg8q5UCJZ0Q3DGCOfjmoXIuEZ5Jr1pJEm4lskngavl
    Bad5Ibd2DhUqT6WyctWIK/6yJtyYAufM5JytpLuxYc8mbRFVC775qS6SraDA
X-ME-Proxy: <xmx:JjLuavCV9DFto7UYYC5m6H2teZW96jjLQ4FC9f_rG_zGMosBoaTg_w>
    <xmx:JjLuasbyesc3rfNH3gERiZdR0WSHtgaMteIIPU9p5HhwWivqjti92w>
    <xmx:JjLuanjDkPJCUvesSt1KafLgMgYhurTABr-S-aHCQFrSUd5h1n9xAw>
    <xmx:JjLuau4TtAd2eHIXMtXXVlAKzDVkfwO8P1KX9Nh3uZy2-6ysTMOq1Q>
    <xmx:JjLuarYA4dGd0eh8FOrpe5acXoINKtb26pcVn-UwaVbgXmk7RyVp7Lkh>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 15:01:42 -0500 (EST)
Date: Fri, 6 Nov 2026 12:01:56 -0800
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v6 05/25] btrfs: zoned: use the regular allocator for
 conventional metadata block groups
Message-ID: <20261106200156.GD401465@zen.localdomain>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
 <20261028182111.160492-6-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20261028182111.160492-6-johannes.thumshirn@wdc.com>

On Wed, Oct 28, 2026 at 07:20:51PM +0100, Johannes Thumshirn wrote:
> The zoned allocator hands out space strictly sequentially from
> block_group::alloc_offset and accounts everything freed below it as
> zone_unusable, so freed tree blocks can only be reclaimed by relocating
> the whole block group.
> 
> A metadata or system block group backed by conventional zones only can
> be overwritten in place, so it can use the regular free space cache and
> the free space cache based (unclustered) allocator instead, and freed
> tree blocks become immediately reusable.
> 
> Pick the allocation scheme per block group rather than per filesystem,
> replace the filesystem wide zoned tests in the free space tracking, the
> space accounting and the extent allocator with a check if the
> block-group is append only.
> 
> Such block groups no longer need an allocation pointer either, so skip
> calculate_alloc_pointer() for them when loading the zone info. As a
> consequence they are no longer marked active and put on
> fs_info::zone_active_bgs.

I guess my million dollar question on this patch (and I suppose the
previous one..) is what happens if you are in a raid profile and add
a sequential device to the fs? Or some similar operation like that
which could theoretically change the zoned-only state of a bg live.
Is this possible at all? I was tracing the device add code and don't
really see it, so I am leaning no.

If it is a static property of the bg, then I think it would probably
make sense to just store it as a variable at the time it is computed
once. If it is indeed a dynamic property, then I am suddenly a lot more
scared of how everything works when the result of the test can change
inconsistently in some larger computation. Like we allocate some
resource in "zoned bg is append only mode" then don't free it because by
the end it is now not in append only mode.

> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/block-group.c      | 16 ++++++++--------
>  fs/btrfs/extent-tree.c      | 38 +++++++++++++++++++++++++++++--------
>  fs/btrfs/free-space-cache.c | 23 +++++++++++-----------
>  fs/btrfs/zoned.c            |  6 ++++++
>  4 files changed, 56 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index b29070b51b92..772b6cfecaa5 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -953,8 +953,8 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait)
>  	struct btrfs_caching_control *caching_ctl = NULL;
>  	int ret = 0;
>  
> -	/* Allocator for zoned filesystems does not use the cache at all */
> -	if (btrfs_is_zoned(fs_info))
> +	/* The append only allocator does not use the cache at all */
> +	if (btrfs_zoned_bg_is_append_only(cache))
>  		return 0;
>  
>  	/*
> @@ -1455,7 +1455,7 @@ static int inc_block_group_ro(struct btrfs_block_group *cache, bool force)
>  
>  	if (!ret) {
>  		sinfo->bytes_readonly += num_bytes;
> -		if (btrfs_is_zoned(cache->fs_info)) {
> +		if (btrfs_zoned_bg_is_append_only(cache)) {
>  			/* Migrate zone_unusable bytes to readonly */
>  			sinfo->bytes_readonly += cache->zone_unusable;
>  			btrfs_space_info_update_bytes_zone_unusable(sinfo, -cache->zone_unusable);
> @@ -2553,8 +2553,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
>  	}
>  
>  	/*
> -	 * For zoned filesystem, space after the allocation offset is the only
> -	 * free space for a block group. So, we don't need any caching work.
> +	 * For an append only block group, space after the allocation offset is
> +	 * the only free space. So, we don't need any caching work.
>  	 * btrfs_calc_zone_unusable() will set the amount of free space and
>  	 * zone_unusable space.
>  	 *
> @@ -2564,7 +2564,7 @@ static int read_one_block_group(struct btrfs_fs_info *info,
>  	 * in and be done with it.  This saves us _a_lot_ of time, particularly
>  	 * in the full case.
>  	 */
> -	if (btrfs_is_zoned(info)) {
> +	if (btrfs_zoned_bg_is_append_only(cache)) {
>  		btrfs_calc_zone_unusable(cache);
>  		/* Should not have any excluded extents. Just in case, though. */
>  		btrfs_free_excluded_extents(cache);
> @@ -3246,7 +3246,7 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
>  	spin_lock(&sinfo->lock);
>  	spin_lock(&cache->lock);
>  	if (!--cache->ro) {
> -		if (btrfs_is_zoned(cache->fs_info)) {
> +		if (btrfs_zoned_bg_is_append_only(cache)) {
>  			/* Migrate zone_unusable bytes back */
>  			cache->zone_unusable =
>  				(cache->alloc_offset - cache->used - cache->pinned -
> @@ -3728,7 +3728,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
>  
>  	if (bg_ro)
>  		space_info->bytes_readonly += num_bytes;
> -	else if (btrfs_is_zoned(cache->fs_info))
> +	else if (btrfs_zoned_bg_is_append_only(cache))
>  		btrfs_space_info_update_bytes_zone_unusable(space_info, num_bytes);
>  
>  	space_info->bytes_reserved -= num_bytes;
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9b0a5c6b96f3..c33f724fc04a 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2896,7 +2896,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
>  
>  		if (readonly) {
>  			space_info->bytes_readonly += len;
> -		} else if (btrfs_is_zoned(fs_info)) {
> +		} else if (btrfs_zoned_bg_is_append_only(cache)) {
>  			/* Need reset before reusing in a zoned block group */
>  			btrfs_space_info_update_bytes_zone_unusable(space_info, len);
>  		} else if (return_free_space) {
> @@ -3685,8 +3685,8 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  	 * contend with.
>  	 */
>  
> -	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags)
> -		     || btrfs_is_zoned(fs_info)) {
> +	if (test_bit(BTRFS_FS_TREE_MOD_LOG_USERS, &fs_info->flags) ||
> +	    btrfs_zoned_bg_is_append_only(bg)) {
>  		pin_down_extent(trans, bg, buf->start, buf->len, true);
>  		btrfs_put_block_group(bg);
>  		return 0;
> @@ -4037,7 +4037,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
>  	int ret = 0;
>  	bool skip = false;
>  
> -	ASSERT(btrfs_is_zoned(block_group->fs_info));
> +	ASSERT(btrfs_zoned_bg_is_append_only(block_group));
>  
>  	/*
>  	 * Do not allow non-tree-log blocks in the dedicated tree-log block
> @@ -4191,11 +4191,28 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
>  	return ret;
>  }
>  
> +/*
> + * On a zoned filesystem ffe_ctl->policy is BTRFS_EXTENT_ALLOC_ZONED, but block
> + * groups that are not append only are allocated from with the regular free
> + * space cache. As prepare_allocation_zoned() does not set up a cluster, this
> + * always ends up in find_free_extent_unclustered().
> + */
> +static enum btrfs_extent_allocation_policy
> +bg_alloc_policy(const struct find_free_extent_ctl *ffe_ctl,
> +		const struct btrfs_block_group *block_group)
> +{
> +	if (ffe_ctl->policy == BTRFS_EXTENT_ALLOC_ZONED &&
> +	    !btrfs_zoned_bg_is_append_only(block_group))
> +		return BTRFS_EXTENT_ALLOC_CLUSTERED;
> +
> +	return ffe_ctl->policy;
> +}
> +
>  static int do_allocation(struct btrfs_block_group *block_group,
>  			 struct find_free_extent_ctl *ffe_ctl,
>  			 struct btrfs_block_group **bg_ret)
>  {
> -	switch (ffe_ctl->policy) {
> +	switch (bg_alloc_policy(ffe_ctl, block_group)) {
>  	case BTRFS_EXTENT_ALLOC_CLUSTERED:
>  		return do_allocation_clustered(block_group, ffe_ctl, bg_ret);
>  	case BTRFS_EXTENT_ALLOC_ZONED:
> @@ -4209,7 +4226,7 @@ static void release_block_group(struct btrfs_block_group *block_group,
>  				struct find_free_extent_ctl *ffe_ctl,
>  				bool delalloc)
>  {
> -	switch (ffe_ctl->policy) {
> +	switch (bg_alloc_policy(ffe_ctl, block_group)) {
>  	case BTRFS_EXTENT_ALLOC_CLUSTERED:
>  		ffe_ctl->retry_uncached = false;
>  		break;
> @@ -4349,8 +4366,13 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
>  		return 1;
>  
>  	/* See the comments for btrfs_loop_type for an explanation of the phases. */
> -	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE)
> -		return -ENOSPC;
> +	if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
> +		if (ffe_ctl->empty_size == 0 && ffe_ctl->empty_cluster == 0)
> +			return -ENOSPC;
> +
> +		ffe_ctl->empty_size = 0;
> +		ffe_ctl->empty_cluster = 0;
> +	}
>  
>  	ffe_ctl->index = 0;
>  	/*
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index bff6e5b372d6..5d830a827cda 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -26,6 +26,7 @@
>  #include "accessors.h"
>  #include "file-item.h"
>  #include "file.h"
> +#include "zoned.h"
>  #include "super.h"
>  #include "relocation.h"
>  
> @@ -1370,7 +1371,7 @@ static int __btrfs_add_free_space(struct btrfs_block_group *block_group,
>  	int ret = 0;
>  	u64 filter_bytes = bytes;
>  
> -	ASSERT(!btrfs_is_zoned(fs_info));
> +	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
>  
>  	info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
>  	if (!info)
> @@ -1499,7 +1500,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
>  	if (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)
>  		return 0;
>  
> -	if (btrfs_is_zoned(block_group->fs_info))
> +	if (btrfs_zoned_bg_is_append_only(block_group))
>  		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
>  						    true);
>  
> @@ -1512,7 +1513,7 @@ int btrfs_add_free_space(struct btrfs_block_group *block_group,
>  int btrfs_add_free_space_unused(struct btrfs_block_group *block_group,
>  				u64 bytenr, u64 size)
>  {
> -	if (btrfs_is_zoned(block_group->fs_info))
> +	if (btrfs_zoned_bg_is_append_only(block_group))
>  		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
>  						    false);
>  
> @@ -1529,7 +1530,7 @@ int btrfs_add_free_space_async_trimmed(struct btrfs_block_group *block_group,
>  {
>  	enum btrfs_trim_state trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
>  
> -	if (btrfs_is_zoned(block_group->fs_info))
> +	if (btrfs_zoned_bg_is_append_only(block_group))
>  		return __btrfs_add_free_space_zoned(block_group, bytenr, size,
>  						    true);
>  
> @@ -1548,7 +1549,7 @@ int btrfs_remove_free_space(struct btrfs_block_group *block_group,
>  	int ret;
>  	bool re_search = false;
>  
> -	if (btrfs_is_zoned(block_group->fs_info)) {
> +	if (btrfs_zoned_bg_is_append_only(block_group)) {
>  		/*
>  		 * This can happen with conventional zones when replaying log.
>  		 * Since the allocation info of tree-log nodes are not recorded
> @@ -1663,10 +1664,10 @@ void btrfs_dump_free_space(struct btrfs_block_group *block_group,
>  	int count = 0;
>  
>  	/*
> -	 * Zoned btrfs does not use free space tree and cluster. Just print
> -	 * out the free space after the allocation offset.
> +	 * Append only block groups do not use free space tree and cluster.
> +	 * Just print out the free space after the allocation offset.
>  	 */
> -	if (btrfs_is_zoned(fs_info)) {
> +	if (btrfs_zoned_bg_is_append_only(block_group)) {
>  		btrfs_info(fs_info, "free space %llu active %d",
>  			   block_group->zone_capacity - block_group->alloc_offset,
>  			   test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
> @@ -1838,7 +1839,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group *block_group,
>  	enum btrfs_trim_state align_gap_trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
>  	bool use_bytes_index = (offset == block_group->start);
>  
> -	ASSERT(!btrfs_is_zoned(block_group->fs_info));
> +	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
>  
>  	spin_lock(&ctl->tree_lock);
>  	entry = find_free_space(ctl, &offset, &bytes_search,
> @@ -1971,7 +1972,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
>  	struct rb_node *node;
>  	u64 ret = 0;
>  
> -	ASSERT(!btrfs_is_zoned(block_group->fs_info));
> +	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
>  
>  	spin_lock(&cluster->lock);
>  	if (bytes > cluster->max_size)
> @@ -2789,7 +2790,7 @@ int btrfs_trim_block_group(struct btrfs_block_group *block_group,
>  	int ret;
>  	u64 rem = 0;
>  
> -	ASSERT(!btrfs_is_zoned(block_group->fs_info));
> +	ASSERT(!btrfs_zoned_bg_is_append_only(block_group));
>  
>  	*trimmed = 0;
>  
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 554688fc7030..1235acda375d 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -1964,6 +1964,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
>  	}
>  
>  	if (num_conventional > 0) {
> +		if (map->num_stripes == num_conventional &&
> +		    !btrfs_zoned_bg_is_append_only(cache)) {
> +			cache->zone_capacity = cache->length;
> +			goto out;
> +		}
> +
>  		ret = calculate_alloc_pointer(cache, &last_alloc, new);
>  		if (ret) {
>  			btrfs_err(fs_info,
> -- 
> 2.56.0
> 
