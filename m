Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A5A3B0AF8
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 17:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774288344; cv=none; b=rBAJV0bDWp85adtGZky5zVTOVKgjbLPZANB1FVkRIS7gfgXKCpEJ7P1qH0NzJ0Aa8uaItggyTRFxMs2HdYXr91NSg7NuYsvZI3rdCgljRHC3Kz6UAoFW5HPUjMvsXAcqUgMV+2s83wDmwYBU9x4kCa1h8n77yg7PME6VT5Oovxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774288344; c=relaxed/simple;
	bh=lf6EJJHjXjg2UOeaLrIhbgiejF5hFrO45HhGaBtr9A4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRxKQpPtzCrao2hgOhIWZF/GBUGQx8FE0ouJpNEhNSJ5lkhyO7lODg3xUAnBVZUrybk43ng1pXYZQ44gZtPxC6hyV3J/cMgGxp7eRqWWIFBb7zBJiGKQhSdDAoMElCyub7oC01wazHosVP2rzWTTC+iBu82y5zGv8/0+flATkEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=q5UsvYWi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N42mWDxD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=q5UsvYWi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N42mWDxD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="q5UsvYWi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N42mWDxD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="q5UsvYWi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N42mWDxD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A685E5BD63;
	Mon, 23 Mar 2026 17:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774288341;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=poZf3nXNzwPMHETr6zvX076CwE7Drw33L9cvscj2xqA=;
	b=q5UsvYWiGY/5HfpMsWGMEtgJwM9DdhQbwibjk4N5Hv1dNWbgOSLLq9TxrVx/qdWWc4UR24
	h9XzM3MPYb0tDx6ldpaGXfTaOFa8GoKOf9dFcPaIbf6vO2Pa7/9gCEWlD8vCNLjr7IxR+W
	PvA0TPJJ4KKNFH0APyjlgGMm+vTRGwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774288341;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=poZf3nXNzwPMHETr6zvX076CwE7Drw33L9cvscj2xqA=;
	b=N42mWDxDV3gJOSVlfSPeAyEFexJNQ8ILDQk60cwjI9jf4IiAGdNUt0C/garhPbs9MxrBZV
	M73eAYC7sAo5reDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q5UsvYWi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N42mWDxD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774288341;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=poZf3nXNzwPMHETr6zvX076CwE7Drw33L9cvscj2xqA=;
	b=q5UsvYWiGY/5HfpMsWGMEtgJwM9DdhQbwibjk4N5Hv1dNWbgOSLLq9TxrVx/qdWWc4UR24
	h9XzM3MPYb0tDx6ldpaGXfTaOFa8GoKOf9dFcPaIbf6vO2Pa7/9gCEWlD8vCNLjr7IxR+W
	PvA0TPJJ4KKNFH0APyjlgGMm+vTRGwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774288341;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=poZf3nXNzwPMHETr6zvX076CwE7Drw33L9cvscj2xqA=;
	b=N42mWDxDV3gJOSVlfSPeAyEFexJNQ8ILDQk60cwjI9jf4IiAGdNUt0C/garhPbs9MxrBZV
	M73eAYC7sAo5reDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D4DD439D4;
	Mon, 23 Mar 2026 17:52:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7V3nGdV9wWmWdQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 17:52:21 +0000
Date: Mon, 23 Mar 2026 18:52:12 +0100
From: David Sterba <dsterba@suse.cz>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: dsterba@suse.com, clm@fb.com, idryomov@gmail.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH v2 3/3] btrfs: fix check_chunk_block_group_mappings() to
 actually iterate all chunks
Message-ID: <20260323175212.GO5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260314123741.1439792-1-gality369@gmail.com>
 <20260314123741.1439792-4-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314123741.1439792-4-gality369@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
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
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A685E5BD63

On Sat, Mar 14, 2026 at 08:37:41PM +0800, ZhengYuan Huang wrote:
> [BUG]
> A corrupted image with a chunk present in the chunk tree but whose
> corresponding block group item is missing from the extent tree can be
> mounted successfully, even though check_chunk_block_group_mappings()
> is supposed to catch exactly this corruption at mount time.  Once
> mounted, running btrfs balance with a usage filter (-dusage=N or
> -dusage=min..max) triggers a null-ptr-deref:
> 
>   KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
>     RIP: 0010:chunk_usage_filter fs/btrfs/volumes.c:3874 [inline]
>     RIP: 0010:should_balance_chunk fs/btrfs/volumes.c:4018 [inline]
>     RIP: 0010:__btrfs_balance fs/btrfs/volumes.c:4172 [inline]
>     RIP: 0010:btrfs_balance+0x2024/0x42b0 fs/btrfs/volumes.c:4604
> 
> The crash occurs because __btrfs_balance() iterates the on-disk chunk
> tree, finds the orphaned chunk, calls chunk_usage_filter() (or
> chunk_usage_range_filter()), which queries the in-memory block group
> cache via btrfs_lookup_block_group().  Since no block group was ever
> inserted for this chunk, the lookup returns NULL, and the subsequent
> dereference of cache->used crashes.
> 
> [CAUSE]
> check_chunk_block_group_mappings() uses btrfs_find_chunk_map() to
> iterate the in-memory chunk map (fs_info->mapping_tree):
> 
>   map = btrfs_find_chunk_map(fs_info, start, 1);
> 
> With @start = 0 and @length = 1, btrfs_find_chunk_map() looks for a
> chunk map that *contains* the logical address 0. If no chunk contains
> logical address 0, btrfs_find_chunk_map(fs_info, 0, 1) returns NULL
> immediately and the loop breaks after the very first iteration,
> having checked zero chunks. The entire verification function is therefore
> a no-op, and the corrupted image passes the mount-time check undetected.
> 
> [FIX]
> Replace the btrfs_find_chunk_map() based loop with a direct in-order
> walk of fs_info->mapping_tree using rb_first_cached() + rb_next(),
> protected by mapping_tree_lock. This guarantees that every chunk map
> in the tree is visited regardless of the logical addresses involved.
> Since the mapping_tree itself is accessed under read_lock, no refcount
> manipulation of each map entry is needed inside the loop, so the
> btrfs_free_chunk_map() calls on the map are also removed.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/btrfs/block-group.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 5322ef2ae015..25bd0d058be6 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -2319,29 +2319,22 @@ static struct btrfs_block_group *btrfs_create_block_group_cache(
>   */
>  static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
>  {
> -	u64 start = 0;
> +	struct rb_node *node;
>  	int ret = 0;
>  
> -	while (1) {
> +	read_lock(&fs_info->mapping_tree_lock);

This is called during mount indirectly from open_ctree() and this is
single threaded (partially), so the lock may not be needed. It would be
needed if there's eg. caching thread possibly accessing the same
structures, I haven't looked closely.

> +	for (node = rb_first_cached(&fs_info->mapping_tree); node;
> +	     node = rb_next(node)) {
>  		struct btrfs_chunk_map *map;
>  		struct btrfs_block_group *bg;
>  
> -		/*
> -		 * btrfs_find_chunk_map() will return the first chunk map
> -		 * intersecting the range, so setting @length to 1 is enough to
> -		 * get the first chunk.
> -		 */
> -		map = btrfs_find_chunk_map(fs_info, start, 1);
> -		if (!map)
> -			break;
> -
> +		map = rb_entry(node, struct btrfs_chunk_map, rb_node);
>  		bg = btrfs_lookup_block_group(fs_info, map->start);

What concerns me is this lookup. Previously the references avoided
taking the big lock. The time the lock is held may add up significanly
for all block groups but as said before it might not be necessary due to
the mount context.

>  		if (unlikely(!bg)) {
>  			btrfs_err(fs_info,
>  	"chunk start=%llu len=%llu doesn't have corresponding block group",
>  				     map->start, map->chunk_len);
>  			ret = -EUCLEAN;
> -			btrfs_free_chunk_map(map);
>  			break;
>  		}
>  		if (unlikely(bg->start != map->start || bg->length != map->chunk_len ||
> @@ -2354,14 +2347,12 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
>  				bg->start, bg->length,
>  				bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
>  			ret = -EUCLEAN;
> -			btrfs_free_chunk_map(map);
>  			btrfs_put_block_group(bg);
>  			break;
>  		}
> -		start = map->start + map->chunk_len;
> -		btrfs_free_chunk_map(map);
>  		btrfs_put_block_group(bg);
>  	}
> +	read_unlock(&fs_info->mapping_tree_lock);
>  	return ret;
>  }
>  
> -- 
> 2.43.0
> 
