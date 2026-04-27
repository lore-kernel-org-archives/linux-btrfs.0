Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE4C3BA241
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 13:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777297074; cv=none; b=CMAZKyUUFZGeOXBwHmiEEzOM1eSo4Kn8HYiuvV+sFCtCSgmf4UWYESKgOomhCCpCeymzcSJfeM7lkoSiodhg7ZSNQBdcJ3LDoFvNLPcOWUAWk88Eim7FfOo5+b+bd1748+jOjXJZCqqbEVHHyjTYRzjsADTypjnFWOhVGy7ncGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777297074; c=relaxed/simple;
	bh=NN9edBbQDBbu6muQ4aQrWILrO7WU5IJE4D2dNKhYY38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVjOHo2CO4afUmY4fvrb8JX/TEff1Cr1gXUYCaOduxwd7UDn7qm1dOV4W5k6RqhgAdwHkrsx3jBwOtAVNEc20rh2oRfWsq8rkrlvVMnpcM6fOFV/swiq1ui7QeN3YFjlFIAH+SDJhHq2zWCsPaGfcTRnXHUM197+bM8rYDIceqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=myZd2axz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=le8knjIm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=myZd2axz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=le8knjIm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="myZd2axz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="le8knjIm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="myZd2axz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="le8knjIm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4FC756A82D;
	Mon, 27 Apr 2026 13:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777297071;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IL000W2uocBvrJtckoYixJwEkL61/V4ApXiC24hUpMg=;
	b=myZd2axzXz0ZEjDVfoSizDUoC4hTa8m+9vMzRcLzEVWTTYibrDMY+ztLe98Ge3c48Lt8Wv
	UeQ9kyqOJHXGrsfI+qvZdKurv1FAqS1nNs6Q/DUi6ysX3dNiBCjtXkrswQl0pLqzVUvz0w
	dqCADK70jldRne/BTLFROckwJBUWx/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777297071;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IL000W2uocBvrJtckoYixJwEkL61/V4ApXiC24hUpMg=;
	b=le8knjImr/RQDGBoAADXkZUmoqhSL7ERtGKu5eRIu8QluwhlgSumYmQ29KV7f86AMvBuzw
	bWIac4mREHRKVFBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=myZd2axz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=le8knjIm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777297071;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IL000W2uocBvrJtckoYixJwEkL61/V4ApXiC24hUpMg=;
	b=myZd2axzXz0ZEjDVfoSizDUoC4hTa8m+9vMzRcLzEVWTTYibrDMY+ztLe98Ge3c48Lt8Wv
	UeQ9kyqOJHXGrsfI+qvZdKurv1FAqS1nNs6Q/DUi6ysX3dNiBCjtXkrswQl0pLqzVUvz0w
	dqCADK70jldRne/BTLFROckwJBUWx/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777297071;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IL000W2uocBvrJtckoYixJwEkL61/V4ApXiC24hUpMg=;
	b=le8knjImr/RQDGBoAADXkZUmoqhSL7ERtGKu5eRIu8QluwhlgSumYmQ29KV7f86AMvBuzw
	bWIac4mREHRKVFBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E9C0593B0;
	Mon, 27 Apr 2026 13:37:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7bckC69m72n+YAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 27 Apr 2026 13:37:51 +0000
Date: Mon, 27 Apr 2026 15:37:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: refresh add_ra_bio_pages() to indicate it's
 using folios
Message-ID: <20260427133741.GK12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1777189624.git.wqu@suse.com>
 <4a5a1581ed3ecad6df8fd35a5e56f7fe460a5867.1777189624.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a5a1581ed3ecad6df8fd35a5e56f7fe460a5867.1777189624.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 4FC756A82D
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Sun, Apr 26, 2026 at 05:21:04PM +0930, Qu Wenruo wrote:
> The function add_ra_bio_folios() has been utilizing folio interfaces
> since c808c1dcb1b2 ("btrfs: convert add_ra_bio_pages() to use only
> folios"), but we are still referring to "pages" inside the function name
> and all comments.
> 
> Furthermore, such folio/page mixing can even be confusing, e.g. the
> variable @page_end is very confusing as we're not really referring to
> the end of the page, but the end of the folio, especially when we
> already have large folio support.

There are still too many mentions of 'page' so it will take time to
clean them up.

> Enhance that function by:
> 
> - Rename "page" to "folio" to avoid confusion
> 
> - Skip to the folio end if there is already a folio in the page cache
>   The existing skip is:
> 
>   	cur += folio_size(folio);
> 
>   This is incorrect if @cur is not folio size aligned, and can be
>   common with large folio support.
> 
>   Thankfully this is not going to cause any real bugs, but at most will
>   skip some blocks that can be added to readahead.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/compression.c | 40 ++++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 09729728624b..8ee0a4117d62 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -355,18 +355,18 @@ struct compressed_bio *btrfs_alloc_compressed_write(struct btrfs_inode *inode,
>  }
>  
>  /*
> - * Add extra pages in the same compressed file extent so that we don't need to
> + * Add extra folios in the same compressed file extent so that we don't need to
>   * re-read the same extent again and again.
>   *
> - * If we have several sectors in the same page points to the same
> + * If we have several blocks in the same folio pointing to the same
>   * on-disk compressed data, we will re-read the same extent many times and
> - * this function can only help for the next page.
> + * this function can only help for the next folio(s).
>   */
> -static noinline int add_ra_bio_pages(struct inode *inode,
> -				     u64 compressed_end,
> -				     struct compressed_bio *cb,
> -				     int *memstall, unsigned long *pflags,
> -				     bool direct_reclaim)
> +static noinline int add_ra_bio_folios(struct inode *inode,
> +				      u64 compressed_end,
> +				      struct compressed_bio *cb,
> +				      int *memstall, unsigned long *pflags,

the pflags are not for a 'page' but for the psi_memstall, this got me
confused for a second if it's not remant to be renamed as well.

>  		if (filemap_add_folio(mapping, folio, pg_index, cache_gfp)) {
> -			/* There is already a folio, skip to folio end */
> -			cur += folio_size(folio);
> +			/* There is already a folio, skip to the folio end */
> +			cur += folio_size(folio) - offset_in_folio(folio, cur);
>  			folio_put(folio);
>  			continue;
>  		}
