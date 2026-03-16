Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC96EEBA
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 09:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773652766; cv=none; b=ByIvg0HWJPsu10+LVoVIv7DnBJDw9h64n/T0MlKYaUnrk2kiy9nte2bsp9M5aDzLXYmbhcnW8li//fHnyMSR6LDygFlzo4EhtDnG3GI2JJrIGgvTmFkQBtc5M0bs+D8OcRodhduv9MgXUpIyBoWhuVSAQqdcSER9loBW2X++fOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773652766; c=relaxed/simple;
	bh=bGhxkczWiKXgu9L7rfS7x2psZtOGwGAcPn2TeK8b+h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjA2XK79wi5l7pW3OSEZW9W+OBaPmoVGybYmSJkf49qpfGrh8tYXSarRR0EziuhQdKIH4TyKMVssWYGXwGIK6XtY7hTFWzpJ/yqk2mo9U4bZEqUY2CR00rYw0KQ7ep42Gma5abd2SIgmwJMELMI+GGRPTHOkzeGQ19VKq0ew584=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=U98O59bW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=a7iciME5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=U98O59bW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=a7iciME5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="U98O59bW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="a7iciME5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="U98O59bW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="a7iciME5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 983544D202;
	Mon, 16 Mar 2026 09:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773652763;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WZEIpn8P81PwBZ2GAWB0TLT24rGWeb9cgOAQHYQVIo8=;
	b=U98O59bWVYcCQ+REeyoeKPXPXUVJNtM1Tj+g3s5RREzspzjxy1D+IIWIK6qC1htsC+Y/lZ
	Sud4dfFC8jQ66WwCX25cK/WxPe5eTKWyy5ZIafrQEyJ6o7GFOwrggqt4jV6nCrJlNz/qWp
	e5n1L7wNIXNCM30p0rznRfBKzT6eBic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773652763;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WZEIpn8P81PwBZ2GAWB0TLT24rGWeb9cgOAQHYQVIo8=;
	b=a7iciME5T+fYfPYYD4kzcKC4cxR2rYh9mhWNC5bQMqJHRkvd8KeoDStpmniw2/TaJTzhrT
	QUMiG2s1k2/u29AA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=U98O59bW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a7iciME5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773652763;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WZEIpn8P81PwBZ2GAWB0TLT24rGWeb9cgOAQHYQVIo8=;
	b=U98O59bWVYcCQ+REeyoeKPXPXUVJNtM1Tj+g3s5RREzspzjxy1D+IIWIK6qC1htsC+Y/lZ
	Sud4dfFC8jQ66WwCX25cK/WxPe5eTKWyy5ZIafrQEyJ6o7GFOwrggqt4jV6nCrJlNz/qWp
	e5n1L7wNIXNCM30p0rznRfBKzT6eBic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773652763;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WZEIpn8P81PwBZ2GAWB0TLT24rGWeb9cgOAQHYQVIo8=;
	b=a7iciME5T+fYfPYYD4kzcKC4cxR2rYh9mhWNC5bQMqJHRkvd8KeoDStpmniw2/TaJTzhrT
	QUMiG2s1k2/u29AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A5444273B;
	Mon, 16 Mar 2026 09:19:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tP+vHRvLt2mlEwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 16 Mar 2026 09:19:23 +0000
Date: Mon, 16 Mar 2026 10:19:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, Johannes.Thumshirn@wdc.com,
	Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2] btrfs: fix potential segfault in
 balance_remap_chunks()
Message-ID: <20260316091922.GQ5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260309185050.5895-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309185050.5895-1-mark@harmstone.com>
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 983544D202

Subject changed to "btrfs: check block group before marking it unused in
balance_remap_chunks()"

On Mon, Mar 09, 2026 at 06:50:37PM +0000, Mark Harmstone wrote:
> Fix a potential segfault in balance_remap_chunks(): if we quit early
> because btrfs_inc_block_group_ro() fails, all the remaining items in the
> chunks list will still have their bg value set to NULL. It's thus not
> safe to dereference this pointer without checking first.
> 
> Link: https://lore.kernel.org/linux-btrfs/20260125120717.1578828-1-clm@meta.com/
> Reported-by: Chris Mason <clm@fb.com>
> Fixes: 81e5a4551c32 ("btrfs: allow balancing remap tree")
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> ---
>  fs/btrfs/volumes.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 95accc9361bd26..aff286d9df4aa0 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4285,20 +4285,24 @@ static int balance_remap_chunks(struct btrfs_fs_info *fs_info, struct btrfs_path
>  end:
>  	while (!list_empty(chunks)) {
>  		bool is_unused;
> +		struct btrfs_block_group *bg;
>  
>  		rci = list_first_entry(chunks, struct remap_chunk_info, list);
>  
> -		spin_lock(&rci->bg->lock);
> -		is_unused = !btrfs_is_block_group_used(rci->bg);
> -		spin_unlock(&rci->bg->lock);
> +		bg = rci->bg;
> +		if (bg) {
> +			spin_lock(&bg->lock);
> +			is_unused = !btrfs_is_block_group_used(bg);
> +			spin_unlock(&bg->lock);
>  
> -		if (is_unused)
> -			btrfs_mark_bg_unused(rci->bg);
> +			if (is_unused)
> +				btrfs_mark_bg_unused(bg);
>  
> -		if (rci->made_ro)
> -			btrfs_dec_block_group_ro(rci->bg);
> +			if (rci->made_ro)
> +				btrfs_dec_block_group_ro(bg);
>  
> -		btrfs_put_block_group(rci->bg);
> +			btrfs_put_block_group(bg);
> +		}
>  
>  		list_del(&rci->list);
>  		kfree(rci);
> -- 
> 2.52.0
> 
