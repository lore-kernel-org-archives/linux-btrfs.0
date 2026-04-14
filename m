Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBD11DCB24
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 02:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776132862; cv=none; b=l1eJ9GqXcP4lvFli/xGvx9EU+tUcLyaidGd0lX0xeh/McLhU0UKPy1dEBCxcognimgGQo+HAdK4nGpGFKJyBFJpBTH/uIoyXGTIGsLKWiJaNI8+wEWaRWhkIwe8F5U42rG9sXN9YSjcnM940zk/GqLami1a4IwtfwsYs0ri/05I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776132862; c=relaxed/simple;
	bh=Szvp2ahbB2yBOcDLPCHijhXpQA8rbtkokVGPGU9R0XI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1soHsz6Wh6GkiOrFkaVVZc6ND7FiMeEjp00/jUFxGg5aFjTuVUj52V7O7KvNF5GZ2wL3/ytbkflxE6bRDMHj3rQEWQfLOe4eHjWrwy2P6b1mT3baj/QXgs8Me1tUNHU+sG/nJjGJdgiIKZn459r0bdLpOEBwyXEhLFUinRDtaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iOGFTeNF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zxzx238z; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iOGFTeNF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zxzx238z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iOGFTeNF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zxzx238z";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iOGFTeNF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zxzx238z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 469DF5BCE0;
	Tue, 14 Apr 2026 02:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776132859;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eMdADuzeJlIO95etKvR0WJw10fkBv7SvEGSaqKhWgo=;
	b=iOGFTeNFbtmO2Rgd/Z5djU4Bd2+VAYdHbtTkyJPwTl+n8A3TRerkVuvMK+b6sOyZRImHeA
	RgLCyMLZyy09fUwPg8Hd8pgtw0DiK8iVqSnZzaMOZIw9gRDbITVF/u0ws5NqL6QUD3S40t
	cN1TnW7IaVHD6JPWH2TpaExWnKt+nFI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776132859;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eMdADuzeJlIO95etKvR0WJw10fkBv7SvEGSaqKhWgo=;
	b=zxzx238zqbk6s0onpSuhNPPz4GndcJYw2BdYoRRYL/OKQEBF4us4wSlfIT6JkgsvsbZ3z9
	8rMykq9GbUaYhuDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iOGFTeNF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zxzx238z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776132859;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eMdADuzeJlIO95etKvR0WJw10fkBv7SvEGSaqKhWgo=;
	b=iOGFTeNFbtmO2Rgd/Z5djU4Bd2+VAYdHbtTkyJPwTl+n8A3TRerkVuvMK+b6sOyZRImHeA
	RgLCyMLZyy09fUwPg8Hd8pgtw0DiK8iVqSnZzaMOZIw9gRDbITVF/u0ws5NqL6QUD3S40t
	cN1TnW7IaVHD6JPWH2TpaExWnKt+nFI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776132859;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eMdADuzeJlIO95etKvR0WJw10fkBv7SvEGSaqKhWgo=;
	b=zxzx238zqbk6s0onpSuhNPPz4GndcJYw2BdYoRRYL/OKQEBF4us4wSlfIT6JkgsvsbZ3z9
	8rMykq9GbUaYhuDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 288044B1DC;
	Tue, 14 Apr 2026 02:14:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TJ85Cfui3WmqJgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 14 Apr 2026 02:14:19 +0000
Date: Tue, 14 Apr 2026 04:14:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: remove the COW fixup mechanism
Message-ID: <20260414021413.GL12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1776129347.git.wqu@suse.com>
 <5f9c367ba3f2c32972d0bc2844858bfb1fd47061.1776129347.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f9c367ba3f2c32972d0bc2844858bfb1fd47061.1776129347.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 469DF5BCE0

On Tue, Apr 14, 2026 at 10:46:41AM +0930, Qu Wenruo wrote:
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1739,12 +1739,6 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
>  	       start, len, folio_start, folio_size(folio));
>  
>  	ret = btrfs_writepage_cow_fixup(folio);

The btrfs_writepage_cow_fixup() is left to do the check but now the name
does not match what it's doing, it basically verifies the ordered bit is
set or return EUCLEAN.

Either here or in a separate patch please rename it, to something like
"verify ordered" or something describing what we expect here so we can
forget about what 'fixup' meant.

> -	if (ret == -EAGAIN) {
> -		/* Fixup worker will requeue */
> -		folio_redirty_for_writepage(bio_ctrl->wbc, folio);
> -		folio_unlock(folio);
> -		return 1;
> -	}
>  	if (ret < 0) {
>  		btrfs_folio_clear_dirty(fs_info, folio, start, len);
>  		btrfs_folio_set_writeback(fs_info, folio, start, len);
