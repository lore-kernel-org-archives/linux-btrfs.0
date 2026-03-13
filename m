Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B6B3E1CEF
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 19:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773430604; cv=none; b=Vj3keJE10aOPwo3eBjUPwxgJBZW6GMBeuyG2RiyQr1BmcyJgJrIcaCUKouv5EoksuIZKdDS1ie9VLEvBZvoS3NtVlAYQX2ZVRLa2//9ZszLtR2+t2Lr3q0E9SyEJlfo4vmbw+6p3yaTxZplw9uA1mlfitOIzkJR/d9n+idEIInI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773430604; c=relaxed/simple;
	bh=REVeX7RcfgoOd4yrpLhKBt1II5/0Td5NOlbYlWbGFLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRQj35kygw+r3QkgriqTz+xBhR2EnzKQ/OyUYXreOlTeR1GMLnTFObOJ8QP+0Vo+LrVF1hj8BJqxmgaHt2PNPY4AOMDrpnziGRDyQyoY0tyIUvvu3mY0NpXb+gg9PddBYnXakaOosEs2l64Emv5/5ynGiNdn0LakOTJOYPXBwyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XKN2hEoL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mMz1/5Ng; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XKN2hEoL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mMz1/5Ng; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XKN2hEoL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mMz1/5Ng";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XKN2hEoL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mMz1/5Ng"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C40FC5C566;
	Fri, 13 Mar 2026 19:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773430593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nyXeZfcU/RHl2mRmieXtW55hbhLNkX+U2avv7EYo1u0=;
	b=XKN2hEoLEvdMVgtESMI4vcxtPMfDxy6+up/X5K4fnSCkqpQE+odJjgjVqJBNuL0nxtD2qG
	9nwcWCvxmy1hBAdvPefUyIspeg3znF65Iu1CMZQmEOIQMCk2r5CZYFAIFxARJREg4a7bUY
	STHo/Krn632bEPZTxfO0hHuUp4hRCjI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773430593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nyXeZfcU/RHl2mRmieXtW55hbhLNkX+U2avv7EYo1u0=;
	b=mMz1/5NgyYLRYIwFwnTLpcnMyRDyCxqt9naX+jlB0mPKq7eMeLMZWttEKZbVS83Mhq+MVR
	5rMoeerbB3zqfiBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XKN2hEoL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="mMz1/5Ng"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773430593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nyXeZfcU/RHl2mRmieXtW55hbhLNkX+U2avv7EYo1u0=;
	b=XKN2hEoLEvdMVgtESMI4vcxtPMfDxy6+up/X5K4fnSCkqpQE+odJjgjVqJBNuL0nxtD2qG
	9nwcWCvxmy1hBAdvPefUyIspeg3znF65Iu1CMZQmEOIQMCk2r5CZYFAIFxARJREg4a7bUY
	STHo/Krn632bEPZTxfO0hHuUp4hRCjI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773430593;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nyXeZfcU/RHl2mRmieXtW55hbhLNkX+U2avv7EYo1u0=;
	b=mMz1/5NgyYLRYIwFwnTLpcnMyRDyCxqt9naX+jlB0mPKq7eMeLMZWttEKZbVS83Mhq+MVR
	5rMoeerbB3zqfiBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 938CF406BA;
	Fri, 13 Mar 2026 19:36:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GHPdI0FntGnEcQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 13 Mar 2026 19:36:33 +0000
Date: Fri, 13 Mar 2026 20:36:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: check type flags in alloc_ordered_extent()
Message-ID: <20260313193628.GI5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1772874800.git.wqu@suse.com>
 <64098387a91f8ad825699f318f9980c0c8f7caa3.1772874800.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64098387a91f8ad825699f318f9980c0c8f7caa3.1772874800.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C40FC5C566

On Sat, Mar 07, 2026 at 07:43:36PM +1030, Qu Wenruo wrote:
> Unlike other flags used in btrfs, BTRFS_ORDERED_* macros are different as
> they can not be directly used as flags.
> 
> They are defined as bit numbers, thus they should be utilized with
> bit operations, not directly with logical operations.
> 
> Unfortunately sometimes I forgot this and can pass the incorrect flags
> to alloc_ordered_extent() and hit weird bugs.
> 
> Enhance the type checks in alloc_ordered_extent() by:
> 
> - Make sure there is one and only one bit set for exclusive type flags
>   There are four exclusive type flags, REGULAR, NOCOW, PREALLOC and
>   COMPRESSED.
>   So introduce a new macro, BTRFS_ORDERED_EXCLUSIVE_FLAGS, to cover
>   above flags.
> 
>   And add an ASSERT() to check one and only one of those exclusive flags
>   can be set for alloc_ordered_extent().
> 
> - Re-order the type bit numbers to the end of the enum
>   This is make it much harder to get a valid false negative.
> 
>   E.g, with the old BTRFS_ORDERED_REGULAR starts at zero, we can have
>   the following flags passing the weight check:
> 
>   * BTRFS_ORDERED_NOCOW
>     Be treated as BTRFS_ORDERED_REGULAR (1 == 1UL << 0).
> 
>   * BTRFS_ORDERED_PREALLOC
>     Be treated as BTRFS_ORDERED_NOCOW (2 == 1UL << 1).
> 
>   * BTRFS_ORDERED_DIRECT
>     Be treated as BTRFS_ORDERED_PREALLOC (4 == 1UL << 2).
> 
>   Now all those types starts at 8, passing any of those bit numbers as
>   flags directly will not pass the ASSERT().

Reordering the extra bits to the beginning looks a bit strange but the
functional reasons make more sense.

> 
> - Add a static assert to avoid overflow
>   To make sure all BTRFS_ORDERED_* flags can fit into an unsigned long.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ordered-data.c | 13 ++++++++++
>  fs/btrfs/ordered-data.h | 55 +++++++++++++++++++++++------------------
>  2 files changed, 44 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 8405d07b49cd..b34a0df282f3 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -156,6 +156,19 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
>  	const bool is_nocow = (flags &
>  	       ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)));
>  
> +	/* Only one type flag can be set. */
> +	ASSERT(hweight_long(flags & BTRFS_ORDERED_EXCLUSIVE_FLAGS) == 1);

We have has_single_bit_set() for that

> +
> +	/* DIRECT can not be set with COMPRESSED nor ENCODED. */

                  cannot

> +	if (test_bit(BTRFS_ORDERED_DIRECT, &flags)) {
> +		ASSERT(!test_bit(BTRFS_ORDERED_COMPRESSED, &flags));
> +		ASSERT(!test_bit(BTRFS_ORDERED_ENCODED, &flags));
> +	}
> +
> +	/* ENCODED must be set with COMPRESSED. */
> +	if (test_bit(BTRFS_ORDERED_ENCODED, &flags))
> +		ASSERT(test_bit(BTRFS_ORDERED_COMPRESSED, &flags));
> +
>  	/*
>  	 * For a NOCOW write we can free the qgroup reserve right now. For a COW
>  	 * one we transfer the reserved space from the inode's iotree into the
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index cd74c5ecfd67..2664ea455229 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -47,8 +47,25 @@ struct btrfs_ordered_sum {
>   * IO is done and any metadata is inserted into the tree.
>   */
>  enum {
> +	/* Extra status bits for ordered extents */
> +
> +	/* Set when all the pages are written */
> +	BTRFS_ORDERED_IO_DONE,
> +	/* Set when removed from the tree */
> +	BTRFS_ORDERED_COMPLETE,
> +	/* We had an io error when writing this out */
> +	BTRFS_ORDERED_IOERR,
> +	/* Set when we have to truncate an extent */
> +	BTRFS_ORDERED_TRUNCATED,
> +	/* Used during fsync to track already logged extents */
> +	BTRFS_ORDERED_LOGGED,
> +	/* We have already logged all the csums of the ordered extent */
> +	BTRFS_ORDERED_LOGGED_CSUM,
> +	/* We wait for this extent to complete in the current transaction */
> +	BTRFS_ORDERED_PENDING,
> +
>  	/*
> -	 * Different types for ordered extents, one and only one of the 4 types
> +	 * Different types for ordered extents, one and only one of those types
>  	 * need to be set when creating ordered extent.
>  	 *
>  	 * REGULAR:	For regular non-compressed COW write
> @@ -61,37 +78,27 @@ enum {
>  	BTRFS_ORDERED_PREALLOC,
>  	BTRFS_ORDERED_COMPRESSED,
>  
> +	/* Extra bit for encoded write, must be set with COMPRESSED. */
> +	BTRFS_ORDERED_ENCODED,
> +
>  	/*
>  	 * Extra bit for direct io, can only be set for
> -	 * REGULAR/NOCOW/PREALLOC. No direct io for compressed extent.
> +	 * REGULAR/NOCOW/PREALLOC. Can not be set for COMPRESSED nor ENCODED.

                                   Cannot

or maybe "Must not ..."

>  	 */
>  	BTRFS_ORDERED_DIRECT,
>  
> -	/* Extra status bits for ordered extents */
> -
> -	/* set when all the pages are written */
> -	BTRFS_ORDERED_IO_DONE,
> -	/* set when removed from the tree */
> -	BTRFS_ORDERED_COMPLETE,
> -	/* We had an io error when writing this out */
> -	BTRFS_ORDERED_IOERR,
> -	/* Set when we have to truncate an extent */
> -	BTRFS_ORDERED_TRUNCATED,
> -	/* Used during fsync to track already logged extents */
> -	BTRFS_ORDERED_LOGGED,
> -	/* We have already logged all the csums of the ordered extent */
> -	BTRFS_ORDERED_LOGGED_CSUM,
> -	/* We wait for this extent to complete in the current transaction */
> -	BTRFS_ORDERED_PENDING,
> -	/* BTRFS_IOC_ENCODED_WRITE */
> -	BTRFS_ORDERED_ENCODED,
> +	BTRFS_ORDERED_NR_FLAGS,
>  };
> +static_assert(BTRFS_ORDERED_NR_FLAGS <= BITS_PER_LONG);
> +
> +/* One and only one flag can be set. */
> +#define BTRFS_ORDERED_EXCLUSIVE_FLAGS ((1UL << BTRFS_ORDERED_REGULAR) |	\
> +				       (1UL << BTRFS_ORDERED_NOCOW) |	\
> +				       (1UL << BTRFS_ORDERED_PREALLOC) |\
> +				       (1UL << BTRFS_ORDERED_COMPRESSED))
>  
>  /* BTRFS_ORDERED_* flags that specify the type of the extent. */
> -#define BTRFS_ORDERED_TYPE_FLAGS ((1UL << BTRFS_ORDERED_REGULAR) |	\
> -				  (1UL << BTRFS_ORDERED_NOCOW) |	\
> -				  (1UL << BTRFS_ORDERED_PREALLOC) |	\
> -				  (1UL << BTRFS_ORDERED_COMPRESSED) |	\
> +#define BTRFS_ORDERED_TYPE_FLAGS (BTRFS_ORDERED_EXCLUSIVE_FLAGS |	\
>  				  (1UL << BTRFS_ORDERED_DIRECT) |	\
>  				  (1UL << BTRFS_ORDERED_ENCODED))
>  
> -- 
> 2.53.0
> 
