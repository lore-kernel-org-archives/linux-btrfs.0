Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECA639E6C7
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 19:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774900203; cv=none; b=TdvdaL4POEG/s5WBf+I5NVgVL/tlSkSvw1TQjFTTcxGW+DZPfnromsaWI5b18OoyP2EFdR89NIDmzJLcDK7ul/cPv+rMWvr8aHk1CHv0MmPZ1ry8/+YtUS1vHrXjJOPmw+7vMsY9QGqDTsx8q5zajbxcztILOf17z+vqpa9cNpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774900203; c=relaxed/simple;
	bh=xnZNzc27S4Fc9DImMtU1tHH4AfCnkHQTGEWMQ8Jrnr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qx7K7C0JHLDSCi2xmOk3/obYwaMozMUeVeRYnvd843E3vQmqFoh6kLygPwK/K3uNJLN1GOB2QOyfSY6C+8j6bOak8T3S2dmgpyfn2DyHZBm8JGd8khNVgBVsaUzAupZRnrLPzZsJVvbBECg47iv0w+XYzOJ6gwCmFbQx5LTA2vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rzn1Hx+K; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8DxMPmEs; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qGAs0+mb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GMt/jkcT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rzn1Hx+K";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8DxMPmEs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qGAs0+mb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GMt/jkcT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D81434D24E;
	Mon, 30 Mar 2026 19:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774900193;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hpHeRgs/IrsqsovcXA8igL5ksioS8NyLk2mGpIsXogU=;
	b=rzn1Hx+Kw3AD543URYIeK9+rEsRpMooCLym49Sj7/8rWZ8np5uudeQdGsprao/q4CJZvje
	bJvqQ5/tRUwMjzt/C6PVEUjFyU3Ms/nk0q7As/kQG2z5ncs9HDmfpLeLGYKQQAjAWPqR8k
	I/qodVVPGjDNiRTnoEBuTkoyW1nQI5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774900193;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hpHeRgs/IrsqsovcXA8igL5ksioS8NyLk2mGpIsXogU=;
	b=8DxMPmEsaZ2hIgP58mQHgONlj9+lhOt7UrgzlUg8Ly5EiqX7EHLUD1Sc1Dd5cMRulcI//V
	mNV2MWgjO8VMhGCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774900192;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hpHeRgs/IrsqsovcXA8igL5ksioS8NyLk2mGpIsXogU=;
	b=qGAs0+mb5Yko/il/Zq1w72K5WLXhDRUgU8q/2ampaOIUt6A9RuftmUetElNqS8HHwSFtoq
	gveomwcsPniArWlNf/KZ5blItcihGLy+8BJDyHmYZ9Rpfo9kdVjF1g1E+ohUeUBnd6msip
	xWvP3zONdlxxWvQowGUgZ+uDpkmZGbE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774900192;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hpHeRgs/IrsqsovcXA8igL5ksioS8NyLk2mGpIsXogU=;
	b=GMt/jkcTgSYgSCjpqr3gsmVmItHOppSUYXOpORsBSMiRTR+gxAA1r//6M+wROU6KRcu1Q7
	J4qFf9b0pC5MSVBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B12384A0A2;
	Mon, 30 Mar 2026 19:49:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XMsOK+DTymmOIgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 30 Mar 2026 19:49:52 +0000
Date: Mon, 30 Mar 2026 21:49:47 +0200
From: David Sterba <dsterba@suse.cz>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: mark@harmstone.com, boris@bur.io, wqu@suse.com, dsterba@suse.com,
	clm@fb.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-team@meta.com
Subject: Re: [RESEND PATCH v2] btrfs: prevent direct reclaim during
 compressed readahead
Message-ID: <20260330194947.GA5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260328214619.114790-1-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328214619.114790-1-jp.kobryn@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Sat, Mar 28, 2026 at 02:46:19PM -0700, JP Kobryn (Meta) wrote:
> Under memory pressure, direct reclaim can kick in during compressed
> readahead. This puts the associated task into D-state. Then shrink_lruvec()
> disables interrupts when acquiring the LRU lock. Under heavy pressure,
> we've observed reclaim can run long enough that the CPU becomes prone to
> CSD lock stalls since it cannot service incoming IPIs. Although the CSD
> lock stalls are the worst case scenario, we have found many more subtle
> occurrences of this latency on the order of seconds, over a minute in some
> cases.
> 
> Prevent direct reclaim during compressed readahead. This is achieved by
> using different GFP flags at key points when the bio is marked for
> readahead.
> 
> There are two functions that allocate during compressed readahead:
> btrfs_alloc_compr_folio() and add_ra_bio_pages(). Both currently use
> GFP_NOFS which includes __GFP_DIRECT_RECLAIM.
> 
> For the internal API call btrfs_alloc_compr_folio(), the signature changes
> to accept an additional gfp_t parameter. At the readahead call site, it
> gets flags similar to GFP_NOFS but stripped of __GFP_DIRECT_RECLAIM.
> __GFP_NOWARN is added since these allocations are allowed to fail. Demand
> reads still use full GFP_NOFS and will enter reclaim if needed. All other
> existing call sites of btrfs_alloc_compr_folio() now explicitly pass
> GFP_NOFS to retain their current behavior.
> 
> add_ra_bio_pages() gains a bool parameter which allows callers to specify
> if they want to allow direct reclaim or not. In either case, the
> __GFP_NOWARN flag was added unconditionally since the allocations are
> speculative.
> 
> There has been some previous work done on calling add_ra_bio_pages() [0].
> This patch is complementary: where that patch reduces call frequency, this
> patch reduces the latency associated with those calls.
> 
> [0] https://lore.kernel.org/linux-btrfs/656838ec1232314a2657716e59f4f15a8eadba64.1751492111.git.boris@bur.io/
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> Reviewed-by: Mark Harmstone <mark@harmstone.com>
> ---
> v2:
>  - dropped patch 1/2, squashed into single patch based on David's feedback
>  - changed btrfs_alloc_compr_folio() signature instead of new _gfp variant
>  - update other existing callers to pass GFP_NOFS explicitly
> 
> v1: https://lore.kernel.org/linux-btrfs/20260320073445.80218-1-jp.kobryn@linux.dev/
> 
>  fs/btrfs/compression.c | 42 +++++++++++++++++++++++++++++++++++-------
>  fs/btrfs/compression.h |  2 +-
>  fs/btrfs/inode.c       |  2 +-
>  fs/btrfs/lzo.c         |  6 +++---
>  fs/btrfs/zlib.c        |  6 +++---
>  fs/btrfs/zstd.c        |  6 +++---
>  6 files changed, 46 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index e897342bece1f..8f33ef48b501e 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -180,7 +180,7 @@ static unsigned long btrfs_compr_pool_scan(struct shrinker *sh, struct shrink_co
>  /*
>   * Common wrappers for page allocation from compression wrappers
>   */
> -struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
> +struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info, gfp_t gfp)
>  {
>  	struct folio *folio = NULL;
>  
> @@ -200,7 +200,7 @@ struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
>  		return folio;
>  
>  alloc:
> -	return folio_alloc(GFP_NOFS, fs_info->block_min_order);
> +	return folio_alloc(gfp, fs_info->block_min_order);
>  }
>  
>  void btrfs_free_compr_folio(struct folio *folio)
> @@ -368,7 +368,8 @@ struct compressed_bio *btrfs_alloc_compressed_write(struct btrfs_inode *inode,
>  static noinline int add_ra_bio_pages(struct inode *inode,
>  				     u64 compressed_end,
>  				     struct compressed_bio *cb,
> -				     int *memstall, unsigned long *pflags)
> +				     int *memstall, unsigned long *pflags,
> +				     bool direct_reclaim)
>  {
>  	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
>  	pgoff_t end_index;
> @@ -376,6 +377,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>  	u64 cur = cb->orig_bbio->file_offset + orig_bio->bi_iter.bi_size;
>  	u64 isize = i_size_read(inode);
>  	int ret;
> +	gfp_t constraint_gfp, cache_gfp;
>  	struct folio *folio;
>  	struct extent_map *em;
>  	struct address_space *mapping = inode->i_mapping;
> @@ -405,6 +407,19 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>  
>  	end_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
>  
> +	/*
> +	 * Avoid direct reclaim when the caller does not allow it.
> +	 * Since add_ra_bio_pages is always speculative, suppress
> +	 * allocation warnings in either case.
> +	 */
> +	if (!direct_reclaim) {
> +		constraint_gfp = ~(__GFP_FS | __GFP_DIRECT_RECLAIM);
> +		cache_gfp = (GFP_NOFS & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> +	} else {
> +		constraint_gfp = ~__GFP_FS;
> +		cache_gfp = GFP_NOFS | __GFP_NOWARN;
> +	}
> +
>  	while (cur < compressed_end) {
>  		pgoff_t page_end;
>  		pgoff_t pg_index = cur >> PAGE_SHIFT;
> @@ -434,12 +449,13 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>  			continue;
>  		}
>  
> -		folio = filemap_alloc_folio(mapping_gfp_constraint(mapping, ~__GFP_FS),
> +		folio = filemap_alloc_folio(mapping_gfp_constraint(mapping,
> +					    constraint_gfp) | __GFP_NOWARN,

It would be IMHO better to put the __GFP_NOWARN to the definition of
constraint_gfp so it's all done in one go.
