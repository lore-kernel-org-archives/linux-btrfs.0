Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FCE86334
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 01:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781560; cv=none; b=fd6TUsJAxhZikF9qM3bNNe94T06sXxha+YpkHa9dYi6aFhIrz/PNgys5AspLsK/+d6ep4Br0GTeCvHyLP9+TZL2ANXD2dSgsqwrpk9oOamsn/PyBZR4cOJpeA6G08es1ajrXD+DCthpG5GUIXmwj2PbIGmhg7BVTxO+12XRcXew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781560; c=relaxed/simple;
	bh=YObpBVN2z8c925GqZo3P3oj1r3Z9zu0jSKnBIVkuYHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gRGUUEx9WNLxiXYaee57grRJ1idaaKuNsKg7ZeE6dearf1e+TA7wVbz3Na8w7RSd9vRLTK7rnHZXp7KVYPd42rS1hN0AGmYVdeXE19arRdBDMGvvdNZajIRUMRZyLxOTtO/PV6N0yhF8vCKTzAagTyh6Ptp93ItPxlxCfzmhX0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ABBCB75EB3;
	Tue, 30 Jun 2026 01:05:57 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9490E779AB;
	Tue, 30 Jun 2026 01:05:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SwcNJHUWQ2pncAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 30 Jun 2026 01:05:57 +0000
Date: Tue, 30 Jun 2026 03:05:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] btrfs: use kvmalloc() for stripe buffer of
 scrub_stripe
Message-ID: <20260630010556.GD2398896@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1782725129.git.wqu@suse.com>
 <8699b1f1eca9140ba234ece0fbf4e80148d914ba.1782725129.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8699b1f1eca9140ba234ece0fbf4e80148d914ba.1782725129.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: ABBCB75EB3
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

On Mon, Jun 29, 2026 at 06:55:53PM +0930, Qu Wenruo wrote:
> Currently we're using scrub_stripe::folios[] to store all contents of a
> stripe.
> 
> This means we need all the extra work to handle things like sub-page
> cases, and also require larger folios to handle bs > ps cases.
> 
> On the other hand, it's not hard to allocate a 64K large folio to cover
> the full stripe, getting rid of the cross-page handling.
> 
> Furthermore, even if that large folio allocation failed, we can still
> use vmalloc() to allocate a virtually contiguous space and still get rid
> of cross-page handling.
> 
> This patch will go with kvmalloc() to allocate 64K of memory for
> the stripe buffer, thus getting rid of all the complex cross-page
> handling.
> 
> The following aspects can be greatly simplified:

I think the trade off using the virtual mappings is justified, the code
is indeed simplified.

> @@ -332,13 +333,10 @@ static void release_scrub_stripe(struct scrub_stripe *stripe)
>  	if (!stripe)
>  		return;
>  
> -	for (int i = 0; i < SCRUB_STRIPE_MAX_FOLIOS; i++) {
> -		if (stripe->folios[i])
> -			folio_put(stripe->folios[i]);
> -		stripe->folios[i] = NULL;
> -	}
> +	kvfree(stripe->buffer);

The life time of the stripe->buffer matches the scrub life time so we
won't be allocating and freeing the page repeatedly.

>  	kfree(stripe->sectors);
>  	kfree(stripe->csums);
> +	stripe->buffer = NULL;
>  	stripe->sectors = NULL;
>  	stripe->csums = NULL;
>  	stripe->sctx = NULL;

> @@ -840,8 +805,10 @@ static void scrub_verify_one_sector(struct scrub_stripe *stripe, int sector_nr)
>  		return;
>  	}
>  
> -	ret = btrfs_check_block_csum(fs_info, paddr, csum_buf, sector->csum);
> -	if (ret < 0) {
> +	scrub_calc_vaddr_csum(fs_info,
> +			      stripe->buffer + (sector_nr << fs_info->sectorsize_bits),
> +			      fs_info->sectorsize, csum_buf);
> +	if (memcmp(csum_buf, sector->csum, fs_info->csum_size)) {

Please use the if (memcmp(...) != 0) form

> @@ -891,6 +868,10 @@ static void scrub_repair_read_endio(struct btrfs_bio *bbio)
>  
>  	ASSERT(sector_nr < stripe->nr_sectors);
>  
> +	if (is_vmalloc_addr(stripe->buffer))
> +		invalidate_kernel_vmap_range(
> +			stripe->buffer + (sector_nr << fs_info->sectorsize_bits),
> +			bio_size);

This is done twice so may not require a helper but it's quite important
for the virtual mappings, so a comment making it explicit that read side
must do the invalidation would be good.

Alternatively I was thinking about naming like "btrfs_invalidate_range_before_read"
but a comment would be more clear, also we'd need to pass 2 more
variables.

Otherwise, I went through this patch a few times and haven't spotted
anything suspicious.
