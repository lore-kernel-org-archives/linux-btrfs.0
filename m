Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E14F10785;
	Wed,  9 Sep 2026 01:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788917204; cv=none; b=g7gSt1c7IIqO53Kq7OHf/nmPHLzOS1nL0Zr1CwV/i+d74cusUAJ3S9tut9bd1pm2RB7rVoM9QNCeonPpJTnb1K1W46pRc1B7PrqrgzIW849U5g8ltJsGZ8A+5EuetHtKDir2QN+M+DqPpJQd7TsRvi0FV5jFdbkGzinwQPogVfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788917204; c=relaxed/simple;
	bh=TdUKSG7SsrE/DEqDLI5cKMO96BLd8pma7nzupDSV+A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYVz75Uh3FxLfPoAVM1VjyJYYgQk5/fM/yPl4kY58d35IrjkNEiCE5W4SzcrswbSENtxwUg83jhXMW5xdjZ6q3E0KMdFduz5mgD4wg+8K5X0G7DoAY31/oDfnLCPzAmNJUnYCj/DhR6eLJt+lKj2+lNe+77HXJaGx11kCEE9y20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nU9yCU7+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ufbL1J+J; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gEkI0IAC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PzeKBIfJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nU9yCU7+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ufbL1J+J";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gEkI0IAC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PzeKBIfJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5CA6921A1F;
	Wed,  9 Sep 2026 01:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788917200;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I2Vqjon6wigWZz0HSaSgjgezA9FjjNrLKtTCfWO1/zA=;
	b=nU9yCU7+uYerhSVH2i7BpFnohqFjP4u/UlxRq5pcyHfe8u2a7XfBeZRCGuolVAmu5aGdZW
	TKNvasI5r6jKxORdzrvRkssSRlPXasiGq7RfwBca/PEqWXUzonYfb6T/UsHkRnArOxmgc0
	8wFfwOawy9TathoYVtCtiuo39Mc1TF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788917200;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I2Vqjon6wigWZz0HSaSgjgezA9FjjNrLKtTCfWO1/zA=;
	b=ufbL1J+JPUmwhhmiLJCZRTah3zMyjeNuAMQym3QmxBik7j0SsmznkkR/3mhenBZikNKypy
	KFUBuKPgj6aH5qDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788917199;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I2Vqjon6wigWZz0HSaSgjgezA9FjjNrLKtTCfWO1/zA=;
	b=gEkI0IACBz/3KN0TB4pIBHrNka8Q9izc0cearD4XyV+qVhH8dJRIq57uh7Ai28macGau1o
	9rRc6NRJjzhrwIOX17oOmT2cKHeWtOhMp77jnBaERBVjvN+TJbdGKaqhDrNM3rs6JvjIlB
	+KU+rorlvfND4ylplsB1DnUbF5lE3cI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788917199;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I2Vqjon6wigWZz0HSaSgjgezA9FjjNrLKtTCfWO1/zA=;
	b=PzeKBIfJ26Xygclq3l9vRC3IBV6oU/aVe+OdpseMjCXbU29BhNd+T+fff1fzNsPdgwBTQ+
	Io7d9UMbR8RhzLCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 10F501347F;
	Wed,  9 Sep 2026 01:26:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HMiLA8+1oGqGewAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 09 Sep 2026 01:26:39 +0000
Date: Wed, 9 Sep 2026 03:26:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] btrfs: convert heuristic_collect_sample() to use
 folios
Message-ID: <20260909012633.GI9053@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
 <20260907-btrfs-folio-conversions-v2-5-b5fe79f7607b@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907-btrfs-folio-conversions-v2-5-b5fe79f7607b@columbia.edu>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,columbia.edu:email,suse.cz:replyto,suse.cz:mid];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Mon, Sep 07, 2026 at 04:19:59PM -0400, Tal Zussman wrote:
> Convert the sampling loop to folios. This removes the last caller of
> find_get_page() in btrfs and saves a call to compound_head() per sampled
> page. Document that the lookup is not supposed to fail with an ASSERT().
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/btrfs/compression.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 979b2ffbd8fc..fa8b92592321 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1488,7 +1488,7 @@ static bool sample_repeated_patterns(struct heuristic_ws *ws)
>  static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
>  				     struct heuristic_ws *ws)
>  {
> -	struct page *page;
> +	struct folio *folio;
>  	pgoff_t index, index_end;
>  	u32 i, curr_sample_pos;
>  	u8 *in_data;
> @@ -1514,8 +1514,10 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
>  
>  	curr_sample_pos = 0;
>  	while (index < index_end) {
> -		page = find_get_page(inode->i_mapping, index);
> -		in_data = kmap_local_page(page);
> +		folio = filemap_get_folio(inode->i_mapping, index);
> +		ASSERT(!IS_ERR(folio));
> +		in_data = kmap_local_folio(folio,
> +				offset_in_folio(folio, (u64)index << PAGE_SHIFT));

It would be better to avoid the cast, this is source of subtle errors so
we try to avoid that. With demise of 32bit architectures it's less of a
problem because index (pgoff_t) is 64 bit type but still.

Please insert a patch that changes the type of index and index_end to
u64, we initialize them from a u64 type anyway and we know the value
fits to pgoff_t (as argument to filemap_get_folio()).
