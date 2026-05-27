Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7117640759D
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 13:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887373; cv=none; b=Y+h6Ful4emDA30BgINXURoJ0uVyvQlDip+gGYMbP7YwZR8OkVU0B/Fbon0zDRF10gMWD91wCeIrJYyog1Z0KEGNHlemCojbzsG2vostk6nEdXZIyYtPfbJ+8kWneSi4LEZ/hSlui3zCg0wYQyw/8I3Opu9swbyr4Wp+dpeapR2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887373; c=relaxed/simple;
	bh=7MH8Uui+HOgq+vhCxdhwalHaM9gRXOm3IunjgEeuV+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmBY0jS8Ofs8ZReTUAPJPvYR5P/w826KEnaggS06CPW0kEW3Ls4R8DLMK83nbBFWADprgi9FknBteoX87XKrKVwiRCr5Nez9KSb8qnb76bb57PiHriRwae78jdfApslehGXtiAMrIVNQR68CPC04DfTkQ1nZIaUUUrIvj9sLX2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T/6mRyyl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z+rATZIS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T/6mRyyl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z+rATZIS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T/6mRyyl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z+rATZIS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T/6mRyyl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z+rATZIS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B7022675B4;
	Wed, 27 May 2026 13:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779887369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F/dUjVPd9bNoc4PxH5IFmnNS9c/QvaShmaLkkAK3/RA=;
	b=T/6mRyylK4sCo+844DHB4XZ2p+QB6Dii1tb4MYoTtIxgGe6XlS9c8aSHUxfLO+nW8nG3DA
	kQ7oEsyD2rTtXMGcPEZ05HMHgNA+jGKYhVIxn1SlRnXq4XlLbONbkkggUwaXXuyOkNyyCi
	J01vEasd+2PhgMMoZbqGgm0I311BsT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779887369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F/dUjVPd9bNoc4PxH5IFmnNS9c/QvaShmaLkkAK3/RA=;
	b=z+rATZISS/Bd005h0zfp1pXWMWOAI1rxa/+D7yGgXC0ZP7iiLeD2wJNzrAQoJyN6p3NVEe
	38g4nx1oLKwB3jDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="T/6mRyyl";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z+rATZIS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779887369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F/dUjVPd9bNoc4PxH5IFmnNS9c/QvaShmaLkkAK3/RA=;
	b=T/6mRyylK4sCo+844DHB4XZ2p+QB6Dii1tb4MYoTtIxgGe6XlS9c8aSHUxfLO+nW8nG3DA
	kQ7oEsyD2rTtXMGcPEZ05HMHgNA+jGKYhVIxn1SlRnXq4XlLbONbkkggUwaXXuyOkNyyCi
	J01vEasd+2PhgMMoZbqGgm0I311BsT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779887369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F/dUjVPd9bNoc4PxH5IFmnNS9c/QvaShmaLkkAK3/RA=;
	b=z+rATZISS/Bd005h0zfp1pXWMWOAI1rxa/+D7yGgXC0ZP7iiLeD2wJNzrAQoJyN6p3NVEe
	38g4nx1oLKwB3jDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C9FE5A7D6;
	Wed, 27 May 2026 13:09:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H3cIJgntFmqoEwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 27 May 2026 13:09:29 +0000
Date: Wed, 27 May 2026 15:09:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Rik van Riel <riel@surriel.com>
Cc: David Sterba <dsterba@suse.cz>, Boris Burkov <boris@bur.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, Chris Mason <clm@meta.com>,
	hannes@cmpxchg.org, usama.arif@linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: allocate eb-attached btree pages as movable
Message-ID: <20260527130928.GB880787@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260526183739.270a5387@fangorn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526183739.270a5387@fangorn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B7022675B4
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Tue, May 26, 2026 at 06:37:39PM -0400, Rik van Riel wrote:
> Extent buffer pages allocated by alloc_extent_buffer() are attached to
> btree_inode->i_mapping (the buffer_tree path), reach the LRU, and are
> served by the btree_migrate_folio aops in fs/btrfs/disk-io.c. They are
> migratable in practice once their owning extent buffer hits refs == 1,
> which happens naturally. The buddy allocator classifies them by GFP, 
> however, and bare GFP_NOFS lands them in MIGRATE_UNMOVABLE pageblocks. 
> The result: every btree_inode page we read in pins an unmovable pageblock 
> from the page-superblock allocator's perspective, even though the page 
> itself can be moved.
> 
> Have each caller of btrfs_alloc_page_array, btrfs_alloc_folio_array,
> and alloc_eb_folio_array pass in the full GFP mask directly, instead
> of having the functions calculate it from boolean flags.
> 
> The alloc_extent_buffer call site passes GFP_NOFS | __GFP_NOFAIL |
> __GFP_MOVABLE. All other call sites pass plain GFP_NOFS.
> 
> Three categories of caller stay on bare GFP_NOFS, deliberately:
> 
>   - alloc_dummy_extent_buffer / btrfs_clone_extent_buffer: the
>     resulting eb is EXTENT_BUFFER_UNMAPPED, folio->mapping stays NULL,
>     the folios never enter LRU, never get migrate_folio aops. Tagging
>     them __GFP_MOVABLE would violate the page allocator's migrability
>     contract and they would defeat compaction in MOVABLE pageblocks
>     where isolate_migratepages_block skips non-LRU non-movable_ops
>     pages outright.
> 
>   - btrfs_alloc_page_array callers in fs/btrfs/raid56.c (stripe
>     pages), fs/btrfs/inode.c (encoded reads), fs/btrfs/ioctl.c (uring
>     encoded reads), fs/btrfs/relocation.c (relocation buffers): same
>     contract violation. raid56 stripe_pages additionally persist in
>     the stripe cache (RBIO_CACHE_SIZE=1024) well beyond a single I/O,
>     so they are not transient enough to hand-wave the contract.
> 
>   - btrfs_alloc_folio_array caller in fs/btrfs/scrub.c (stripe
>     folios): same -- stripe->folios[] are private buffers freed via
>     folio_put in release_scrub_stripe.
> 
> This change targets the dominant fragmentation source observed on the
> page-superblock series: ~28 GB of btree_inode pages parked across
> many tainted superpageblocks on a 250 GB test system with btrfs root,
> preventing 1 GiB hugepage allocation from those regions. With the
> movable hint, those pages now land in MOVABLE pageblocks where the
> existing background defragger drains them through the standard
> PB_has_movable gate, no LRU-sample fallback needed.
> 
> Cc: Chris Mason <clm@meta.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: Boris Burkov <boris@bur.io>
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
> v2: pass the gfp mask directly to each function from the callers (thanks Boris)

Added to for-next, thanks.
