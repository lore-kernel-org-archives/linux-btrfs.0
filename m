Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F0A3C5532
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774287641; cv=none; b=oBIR9drpGn+x0t+TCD12bv5+AMyMEVgrDxZ33vRhSJ5TnB7bCor0z2qOndiMcYf6VzfmneV8gXNpW+O3vOTIGXPuc8eADIxsxDV6Saym1gVi1Xp8BkjiCM3ZlW+JopriNpfoHmzVK0+utKOgzU1mhhidZExccgzUEexDAbM5SoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774287641; c=relaxed/simple;
	bh=V+5gMMib+vwH70Ky/BQ6Vzjf9BOimZGyZaqH9Yr25i8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/m9G2MphCIjMFPatrkkGeBz0umtftZWS9U/tLjDLQoh7qlLzJG5stVPSno13wmISK+EKEXFzymXIktrK/8KJfa5vwLALnLYfzLTg4YvMTQFx938PQ8np6njaSLsCH9cdIovwQ6q1Yx0KI8h3fwpTE+XrdwMyQNpxCjeon+GwAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GEFy+JW+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MXxblVdI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MUbPI0ms; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9TMTKZ8N; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GEFy+JW+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MXxblVdI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MUbPI0ms";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9TMTKZ8N"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DA0564D364;
	Mon, 23 Mar 2026 17:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774287638;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f2cOdjshFbEO3RlVXhiyX6r1OcbTLof5SPUthprWVjM=;
	b=GEFy+JW+yDUppL3H/z20mLEkqkqfP3OfFlcLoXYeS2k12dzMXhW+Rehw7gCOiW+ySrnhqF
	Uu6EzSesTOy030uA50FiAOEi9685/OToWKHRO83ZHGPAXR2odhrpdN9rgfGLhicSaxoUsH
	TBq5iHGTzG+FadlPFAXseDwPZFidn6g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774287638;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f2cOdjshFbEO3RlVXhiyX6r1OcbTLof5SPUthprWVjM=;
	b=MXxblVdIF88ehsDaa/zu3CDI5fvz1kjO9B7o5j+lf6/HVk6Q9mg7ObLi4KlKuyqEWbj6E9
	x/J90Epeqxc6eNAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MUbPI0ms;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9TMTKZ8N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774287636;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f2cOdjshFbEO3RlVXhiyX6r1OcbTLof5SPUthprWVjM=;
	b=MUbPI0msHXjpSeoAmLVt++run2fTPSp4kze78uFwXCBVDVZlqYVTE2Qyiv8UyFMWdr3b+k
	6BV2UIeX5RYcar4S8KlJCRrNM1F0/g4sDe3iO9vUoYtMam3pB/tlmC/c5BZrpxOoR6Eozc
	pO22k+VZy+n/EuhnMhE0LU03DKZaTbU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774287636;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f2cOdjshFbEO3RlVXhiyX6r1OcbTLof5SPUthprWVjM=;
	b=9TMTKZ8NR8YNYkgAdBlk2NKZoYrjq6/QqIlNafNJQi4Svy6FxdJSSufii9XVeKtt2wDs6q
	ByRnojG7Iebo3KCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6DD2439C8;
	Mon, 23 Mar 2026 17:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7VKWKBR7wWmTaQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 17:40:36 +0000
Date: Mon, 23 Mar 2026 18:40:27 +0100
From: David Sterba <dsterba@suse.cz>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: dsterba@suse.com, clm@fb.com, idryomov@gmail.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: balance: fix null-ptr-deref in
 chunk_usage_filter
Message-ID: <20260323174027.GN5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260314123741.1439792-1-gality369@gmail.com>
 <20260314123741.1439792-2-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314123741.1439792-2-gality369@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,fb.com,gmail.com,vger.kernel.org];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DA0564D364

On Sat, Mar 14, 2026 at 08:37:39PM +0800, ZhengYuan Huang wrote:
> [BUG]
> Running btrfs balance with a usage filter (-dusage=N) can trigger a
> null-ptr-deref when metadata corruption causes a chunk to have no
> corresponding block group in the in-memory cache:
> 
>   KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
>   RIP: 0010:chunk_usage_filter fs/btrfs/volumes.c:3874 [inline]
>   RIP: 0010:should_balance_chunk fs/btrfs/volumes.c:4018 [inline]
>   RIP: 0010:__btrfs_balance fs/btrfs/volumes.c:4172 [inline]
>   RIP: 0010:btrfs_balance+0x2024/0x42b0 fs/btrfs/volumes.c:4604
>   ...
>   Call Trace:
>     btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
>     btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
>     vfs_ioctl fs/ioctl.c:51 [inline]
>     ...
> 
> The bug is reproducible on next-20260312 with our dynamic metadata
> fuzzing tool, which corrupts btrfs metadata at runtime.

So, for example you let a filesystem create some structures, let it
continue, damage/destroy the structures and then let it access again?

If this is supposed to emulate a corruption, either on media or in the
IO path then OK.

> [CAUSE]
> Two separate data structures are involved:
> 
> 1. The on-disk chunk tree, which records every chunk (logical address
>    space region) and is iterated by __btrfs_balance().
> 2. The in-memory block group cache (fs_info->block_group_cache_tree),
>    which is built at mount time by btrfs_read_block_groups() and holds
>    a struct btrfs_block_group for each chunk. This cache is what the
>    usage filter queries.
> 
> On a well-formed filesystem, these two are kept in 1:1 correspondence.
> However, btrfs_read_block_groups() builds the cache from block group
> items in the extent tree, not directly from the chunk tree. A corrupted
> image can therefore contain a chunk item in the chunk tree whose
> corresponding block group item is absent from the extent tree; that
> chunk's block group is then never inserted into the in-memory cache.
> 
> When balance iterates the chunk tree and reaches such an orphaned chunk,
> should_balance_chunk() calls chunk_usage_filter(), which queries the block
> group cache:
> 
>   cache = btrfs_lookup_block_group(fs_info, chunk_offset);
>   chunk_used = cache->used;   /* cache may be NULL */
> 
> btrfs_lookup_block_group() returns NULL silently when no cached entry
> covers chunk_offset. chunk_usage_filter() does not check the return value,
> so the immediately following dereference of cache->used triggers the crash.
> 
> [FIX]
> Add a NULL check after btrfs_lookup_block_group() in chunk_usage_filter().
> When the lookup fails, emit a btrfs_err() message identifying the
> affected bytenr and return -EUCLEAN to indicate filesystem corruption.
> 
> Since the filter function now has an error return path, change its
> return type from bool to int (negative = error, 0 = do not balance,
> positive = balance). Update should_balance_chunk() accordingly (bool ->
> int, with the same convention) and add error propagation for the usage
> filter path. Finally, handle the new negative return in __btrfs_balance()
> by jumping to the existing error path, which aborts the balance
> operation and reports the error to userspace.
> 
> After the fix, the same corruption is correctly detected and reported
> by the filter, and the null-ptr-deref is no longer triggered.
> 
> Fixes: 5ce5b3c0916b ("Btrfs: usage filter")
> Cc: stable@vger.kernel.org
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/btrfs/volumes.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2bec544d8ba3..7c21ac249383 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3863,14 +3863,20 @@ static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_of
>  	return ret;
>  }
>  
> -static bool chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
> -			       struct btrfs_balance_args *bargs)
> +static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
> +			      struct btrfs_balance_args *bargs)
>  {
>  	struct btrfs_block_group *cache;
>  	u64 chunk_used, user_thresh;
>  	bool ret = true;

As this is bool it does not match the changed return type anymore

>  
>  	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
> +	if (!cache) {
> +		btrfs_err(fs_info,
> +			  "balance: chunk at bytenr %llu has no corresponding block group",
> +			  chunk_offset);
> +		return -EUCLEAN;
> +	}
>  	chunk_used = cache->used;
>  
>  	if (bargs->usage_min == 0)
> @@ -3986,8 +3992,8 @@ static bool chunk_soft_convert_filter(u64 chunk_type, struct btrfs_balance_args
>  	return false;
>  }
>  
> -static bool should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *chunk,
> -				 u64 chunk_offset)
> +static int should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *chunk,
> +				u64 chunk_offset)
>  {
>  	struct btrfs_fs_info *fs_info = leaf->fs_info;
>  	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
> @@ -4014,9 +4020,13 @@ static bool should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk
>  	}
>  
>  	/* usage filter */
> -	if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE) &&
> -	    chunk_usage_filter(fs_info, chunk_offset, bargs)) {
> -		return false;
> +	if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE) {
> +		int filter_ret = chunk_usage_filter(fs_info, chunk_offset, bargs);

Same problem here. Also please use ret2 for nested return values.

> +
> +		if (filter_ret < 0)
> +			return filter_ret;
> +		if (filter_ret)
> +			return false;
>  	} else if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
>  	    chunk_usage_range_filter(fs_info, chunk_offset, bargs)) {
>  		return false;
