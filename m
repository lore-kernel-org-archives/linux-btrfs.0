Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249EC3CB2D7
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 22:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782773713; cv=none; b=laysoCyRQcbkwVjikVM0Fic5vt2dnejxvFjRxLkLZvYyQ7mCzrZ9AdRm6V96oUSQ75fn/olqtF8nUTbNaJLn2bFJxjqi6vDFbCDvzJxaD+h1FYubcYpc8xQ5IcFwLNUlTdG949NNj7YK33BJOZzT3+sBruF8mKwRXuKulfCY0yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782773713; c=relaxed/simple;
	bh=YBM9uDjOWIFtnxNGyUj9WMw+mNzkjpkuegd0IQHvVSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYAk4+pALGwq8iMoUXIHUcyKsgev7JwMNWkEnhXt/jQYimW6Q4d3DqrOwE1nwA8y16Ex+qHean4/fydUPxN97hpuYd5ZphvdV5tlbNPoy7vhEbRdXjDhP5S+Y8Pxq0lJhjRo9Jgb9li/Bc1kY07i5vAHW8H3Iv/zDAocu87TMmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2souxq37; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6OE/zhn1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2souxq37; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6OE/zhn1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2souxq37";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6OE/zhn1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2souxq37";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6OE/zhn1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1113C75DF8;
	Mon, 29 Jun 2026 22:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782773710;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s0RzJylcoKjAX4DOUJhjDjT1Nj6f2aoyXxs4T+SHV2g=;
	b=2souxq37Siwvr3+z5iyarH0b5xYEfVcecZUyF18K+lVcDon7ZRnIx8RmXOX0G/s2mxjEv1
	owehiKLEKz8GmBSEmWgqdVYGASIUM+EpFE7cZvSvNZw+Hke76vGsDObiUphBQ+IrV3E/OO
	afWrQKj55mYfft8qLpv5WVNYvEAEnyU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782773710;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s0RzJylcoKjAX4DOUJhjDjT1Nj6f2aoyXxs4T+SHV2g=;
	b=6OE/zhn1TO5ElkO8Rkd5RzdU2CGSWY1Q1UstsFKTyj++SJePxbRq5QtAzjJ/70KrDNTJYm
	hhr84erCehTnNMAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2souxq37;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="6OE/zhn1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782773710;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s0RzJylcoKjAX4DOUJhjDjT1Nj6f2aoyXxs4T+SHV2g=;
	b=2souxq37Siwvr3+z5iyarH0b5xYEfVcecZUyF18K+lVcDon7ZRnIx8RmXOX0G/s2mxjEv1
	owehiKLEKz8GmBSEmWgqdVYGASIUM+EpFE7cZvSvNZw+Hke76vGsDObiUphBQ+IrV3E/OO
	afWrQKj55mYfft8qLpv5WVNYvEAEnyU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782773710;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s0RzJylcoKjAX4DOUJhjDjT1Nj6f2aoyXxs4T+SHV2g=;
	b=6OE/zhn1TO5ElkO8Rkd5RzdU2CGSWY1Q1UstsFKTyj++SJePxbRq5QtAzjJ/70KrDNTJYm
	hhr84erCehTnNMAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9EF4779A8;
	Mon, 29 Jun 2026 22:55:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LlyFOM33QmrjcgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 29 Jun 2026 22:55:09 +0000
Date: Tue, 30 Jun 2026 00:55:08 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs: defrag: use auto kfree in defrag_one_range()
 for folios array
Message-ID: <20260629225508.GA2398896@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1782321584.git.fdmanana@suse.com>
 <b3c3ddd783250773e264ebc76a0984d0276bc664.1782321584.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3c3ddd783250773e264ebc76a0984d0276bc664.1782321584.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1113C75DF8
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Thu, Jun 25, 2026 at 08:20:14PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Use AUTO_KFREE() for the folios array, avoiding two kfree() calls, one of
> them in a very specific error path.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/defrag.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index ad1d04d8f165..e454b59d6477 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -1169,7 +1169,7 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
>  	struct defrag_target_range *entry;
>  	struct defrag_target_range *tmp;
>  	LIST_HEAD(target_list);
> -	struct folio **folios;
> +	struct folio AUTO_KFREE(*folios);
>  	const u32 sectorsize = inode->root->fs_info->sectorsize;
>  	u64 cur = start;
>  	const unsigned int nr_pages = ((start + len - 1) >> PAGE_SHIFT) -
> @@ -1196,10 +1196,8 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
>  	 * range or the extent lock.
>  	 */
>  	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, start, len);
> -	if (ret < 0) {
> -		kfree(folios);
> +	if (ret < 0)
>  		return ret;
> -	}
>  
>  	/* Prepare all pages */
>  	for (int i = 0; cur < start + len && i < nr_pages; i++) {
> @@ -1251,7 +1249,6 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
>  		folio_unlock(folios[i]);
>  		folio_put(folios[i]);
>  	}
> -	kfree(folios);

There's non-trivial work following this freeing, down from
btrfs_delalloc_release_space(). I consider using auto freeing in such
cases as anti-pattern and have skipped converting them.

In this function there's only one early exit from the function so the
auto freeing is underused, I'd rather not do it.

>  	btrfs_delalloc_release_extents(inode, len);
>  	if (last_defrag_end < start + len)
>  		btrfs_delalloc_release_space(inode, data_reserved, last_defrag_end,
> -- 
> 2.47.2
> 
