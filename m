Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD0B38330E
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 12:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779713534; cv=none; b=ayVFZKu7pXHwfcKt55X5G6+GjK75QsB4cG/zjT2n4GUYKV/rdDRA/w8p8MUzEVx58kuufRZ7yx502BeFQsOX9K1XrqVEOXZ3w4JFe+pGJdIjyLY7qBUP32vIAACwQ05r+oFxBUhbbNFOGe40A8F8WEuWivAeebJiE95U2bWN6hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779713534; c=relaxed/simple;
	bh=3qbJDd+MxzsBLVL/5inZyvd6QpdRrhLqPiUFtoAghnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nMCUs2kIetec4650KyFD9QHDH76/AE2mkiVKd9zGtvzfFZbB5QpK+AV9czHqhyg8s/M0m1PUc875OLrKSoOSkC+bUTXtvwW5iguCctP6MNA02dyEE8xUDjq63i9NaKx8jjgoWeCsRhwPS/hQsDSaF7n3ARe2gsvqbk1GfN4SSgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xA0VIv3J; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Aao+vWhr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IvkKa5U/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8r2XEoVp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xA0VIv3J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Aao+vWhr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IvkKa5U/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8r2XEoVp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C7837758D1;
	Mon, 25 May 2026 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779713531;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iCd3UhfgsDJLGlrJgkutz0tH05oobOjLzCUrlJkdrvM=;
	b=xA0VIv3JiCFsyy47lF7aCOBJqSYpvVG3mQRbA3lSccB+NjNmqdXNBUDESxV4cxCyRdlEGA
	+oQjB+KDukCfr6cCAVUgJxWZCesqC4OFZsDPT16aJlp7eyBJyecwZlDx2Mw5mXoyP0OEQi
	UinY1aaMx2RaEdp1NfZ7t5++S+p0u0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779713531;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iCd3UhfgsDJLGlrJgkutz0tH05oobOjLzCUrlJkdrvM=;
	b=Aao+vWhrGIiR0c27fgBc65aaEAGi3SeRbgY+N2iGo8aPl/HJXotn/mW1OhPzUQu1FEyXqY
	5QbOa/XonoLCkeCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779713529;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iCd3UhfgsDJLGlrJgkutz0tH05oobOjLzCUrlJkdrvM=;
	b=IvkKa5U/YOYAmkBY1a9+JNp9w5V1rwIRzB9zUQGYU+GH0JGmMq4z5aiL8x+XsWZ537xa8R
	WIQZ+D+isE3/joAERQGqXVEO/vltHeAwDDyFPj9XJtirK00OZ/5tXGSL/K89WUuH5Yh5oP
	tDMf9SIQhclnkzwbaoBbcI44nqif93w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779713529;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iCd3UhfgsDJLGlrJgkutz0tH05oobOjLzCUrlJkdrvM=;
	b=8r2XEoVp0i9/z/NDtV7rym27DLmkv7QXzRGX12Ebff7afxpzYlZbBzMFooFZRS0MiAYrns
	3V6bZLsu9Sokh/Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A26DC59C57;
	Mon, 25 May 2026 12:52:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u/5qJ/lFFGrZUQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 12:52:09 +0000
Date: Mon, 25 May 2026 14:52:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] btrfs: delay compression to bbio submission time
Message-ID: <20260525125204.GB12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1778902677.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1778902677.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Sat, May 16, 2026 at 01:15:13PM +0930, Qu Wenruo wrote:
> [CHANGELOG]
> v2:
> - Rebased to the latest for-next branch
>   Several minor conflicts:
>   * The removal of folio ordered flag
>   * The refactor of btrfs_mod_oustanding_extents()
> 
> - Fix a random failure in btrfs/260
>   It turns out that the original filemap_flush() only triggers writeback
>   of dirty pages, but since our new compression happens after the bios
>   are submitted, there can be a race between inode->defrag_compression
>   clearing and compression path reading inode->defrag_compression.
> 
>   This can cause btrfs to use the mount option other than the specified
>   defrag compression algo to do the compression.
> 
>   Fix it by using filemap_write_and_wait_range(), which also avoids the
>   quirky double flush behavior.
>   
> - Fix a use-after-free bug where bio->bi_status is accessed after
>   bio_put()
> 
> - Remove a mapping_set_error() call when try_submit_compressed() failed
>   As we still have uncompressed fallback, we should not set the mapping
>   as error.
> 
> - Drop all allocated OEs along with the extent maps when
>   run_delalloc_delayed() failed
>   
> - Slightly reword the cover letter
> 
> PoC->v1:
> - Fix the ordered extent leak caused by incorrect ref count of child OEs
> - Fix the reserved space leakage in ranges without a real OE
> - Fix the hang caused by incorrect extent lock/unlock pair
>   All exposed by fsstress runs
> 
> - Fix the OE range check in btrfs_wait_ordered_extents() that affects
>   snapshot creation
>   All exposed by fstests runs
> 
> [BACKGROUND]
> Btrfs currently goes with async submission for compressed write, I'll go
> the following example to explain the async submission:
> 
> The page and fs block sizes are all 4K, no large folio involved.
> The dirty range is [0, 4K), [8K, 128K).
> 
>     0  4K  8K                                        128K
>     |//|   |/////////////////////////////////////////|
> 
> - Write back folio 0
>   No compression.
>   * New OE for [0, 4K)
>   * Submit bbio for [0, 4K)
> 
> - Write back folio 8K
>   * Delayed compression/OE creation into a workqueue
>     All folios in range [8K, 128K) is still locked.
>   * Skip submission
> 
> - Write back folios at range [12K, 128K)
>   * Wait for the folio to be unlocked.
>     As the folio is only unlocked after the compression is done.
>   * Skip submission
>     As the folio is no longer dirty.
> 
> [PROBLEMS]
> The async submission has the following problems:
> 
> - Non-sequential writeback
>   Especially when large folios are involved, we can have some blocks
>   submitted immediately (uncompressed), and some submitted later
>   (compressed).
> 
>   That breaks the assumption of iomap and DONTCACHE writes, which
>   requires all blocks inside a folio to be submitted in one go.
> 
> - Not really async
>   As the example given above, we keep the whole range locked during
>   compression.
>   This means if we want to read a cached folio in that range, we still
>   need to wait for the compression.
> 
> [DELAYED COMPRESSION]
> The new idea is to delay the compression at bbio submission time.

This is a big change so we'd have postpone it to 7.3 development cycle.
