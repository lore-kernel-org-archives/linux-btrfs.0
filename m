Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFC2486BA9
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2026 16:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787329381; cv=none; b=UkueN4jkuRxY8gIW1xqUIQTxT8w7DnaRNWVhFE/eLNjfaYXUUX6c8Zcb8e0+Z5I6myZB8NbSRX4tp35qNhC9Fg29Plmhfo0mKcJsOGQXvHV5fs7FYMAfAEj5WC8TikZ9oKiFC05fX0do4p9a1Vjh18pPL17JgMBxd9QVr1cN75k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787329381; c=relaxed/simple;
	bh=N30TWhPM9UynnITncVtyyWSz5PwPa7N30yn4jz7bHU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AtKWQmsHO4a9UVUXOKNHBEy1xgT7dKSuO7YOmRnfVfFi7RifRzhBAWad1ipv2Dx0x2v2Y2X49er74t7IX8BdjTF9Qk8wPwz8oeso3tUZC6nHvWeBcZ8KtPvU6poQYfOayWBRvxtkn0ej8rqMLUnFUV3/Cbh6aBw/xzRsaXCZmfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1NNGdCOz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dgW8sDX9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xvsKyTkT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/sKL4s4I; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1NNGdCOz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dgW8sDX9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xvsKyTkT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/sKL4s4I"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E5B4E857B2;
	Fri, 21 Aug 2026 16:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787329374;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x0YdIc2/gyV7Xn/jLVR2OUyagE86b2Gr0SUYaV1m5iE=;
	b=1NNGdCOzb9iB5FqkCQVUrhib7XvkZ+1n3kXZDEa4nD1OXr9+8JM4n8RU6Pxe9wVnp3+1X7
	hFeOmqGhwtXI4qCnjGFbPqlXKa/XcpMDEOb8epHLiB7R4lHstfDtJCXxhOGEsZljG6oDf/
	JRWNKsWe/YkEPQNYkmMLr9Ei9ptlKuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787329374;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x0YdIc2/gyV7Xn/jLVR2OUyagE86b2Gr0SUYaV1m5iE=;
	b=dgW8sDX9GGptT9RV7JKrhaBXYTQyfCYG1jBZQI2hE0NF+xW4Wb7Z75hjBeDP9J9Rc5gZvU
	oUyoqhuHZjQmE3Bw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787329369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x0YdIc2/gyV7Xn/jLVR2OUyagE86b2Gr0SUYaV1m5iE=;
	b=xvsKyTkTdUVUfTedPuvmBA3QPMK3CNQRWmpPvytauTJ8Ufu1J/yTEOOuSu9/CqM/Vn8ro+
	iRMct3Z3zKZegzH6Pla06a/EUw8OrBUUskBtacVGzNLaeb/No1gtHET/vCPIsULnz17w9e
	ss71UFy6OYH5/30FQ7jECnLCs1GydRU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787329369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x0YdIc2/gyV7Xn/jLVR2OUyagE86b2Gr0SUYaV1m5iE=;
	b=/sKL4s4IAMGBn9CJ9XNbvIfzEt9i28Faq1y0mSckVeHBS2O2DOEZpShinoQ0JvM2/ZsfcW
	ST99JU7Lx9u0c6AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DBEC23329;
	Fri, 21 Aug 2026 16:22:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qTOBNVl7iGqgPgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 21 Aug 2026 16:22:49 +0000
Date: Fri, 21 Aug 2026 18:22:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Hongling Zeng <zenghongling@kylinos.cn>
Subject: Re: [PATCH] btrfs: refactor read_key_bytes() to remove the
 dest_folio parameter
Message-ID: <20260821162244.GD9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <9dbe80bc5b11556619603748db55424cb75a4407.1786951820.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dbe80bc5b11556619603748db55424cb75a4407.1786951820.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-3.94 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.14)[-0.723];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,kylinos.cn:email,suse.cz:replyto,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -3.94
X-Spam-Level: 

On Mon, Aug 17, 2026 at 05:00:43PM +0930, Qu Wenruo wrote:
> The function read_key_bytes() have 3 call sites:
> 
> - For BTRFS_VERITY_DESC_ITEM_KEY offset 0 inside btrfs_get_verity_descriptor()
> - For BTRFS_VERITY_DESC_ITEM_KEY offset 1 inside btrfs_get_verity_descriptor()
>   Those are to read the description items, which are pretty small with
>   fixed item size.
> 
>   Those call sites do not utilize the @dest_folio parameter.
> 
> - For btrfs_read_merkle_tree_page()
>   This is to read the BTRFS_VERITY_MERKLE_ITEM_KEY, which can be pretty
>   large and split into multiple items.
> 
>   This is the only call site utilizing the @dest_folio parameter.
> 
> Just for the only btrfs_read_merkle_tree_page() call site, we have a
> complex scheme for @dest and @dest_folio parameters.
> Since @dest can be NULL, it means if we pass @dest as NULL, then no
> matter if @dest_folio is provided, the merkle data will not be loaded
> into that @dest_folio.
> 
> This can lead to a bug where a highmem folio is not mapped, then we pass
> folio_address(folio), which is NULL, into read_key_bytes(), causing no
> data to be written into @dest_folio.
> 
> To address the complex scheme between @dest and @dest_folio, remove the
> @dest_folio parameter completely, and let the only caller to map the
> folio and pass the mapped kernel address into read_key_bytes() instead.
> 
> This not only reduces the parameter list, but also make it much clear on
> the @dest parameter handling.
> The only downside is a longer duration of locally mapped page, but this
> should still be fine, as kmap_local_folio() can survive context switch.
> 
> Reported-by: Hongling Zeng <zenghongling@kylinos.cn>
> Link: https://lore.kernel.org/linux-btrfs/20260817022012.19658-1-zenghongling@kylinos.cn/
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
