Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF6F345CDD
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 10:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779703965; cv=none; b=Bzm0G3ArSJslCiQxAUoERWpItKRKXI/lEwMAjkLxKVu3bkClWcZLWbV2hNq3mcan0gwnGvckQLdDfBVwWx0p91n0XjS74DldJPk15EKxX8jeErmBlcsjVJUaYoaMjJIZDG9ev5e30QBFexSrZxer5vZpTLUVYMQo3BNCqXmWMDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779703965; c=relaxed/simple;
	bh=JaL8Wvt55d+KJ/2LKf7yE/CaJCbO7w5zlfEWPxdQQ68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJ4FaQmAzf6Z1iryJ2DBag/BqVRYo2erP+UVWlHQDY181Z+YK5moB+CY82c5T2yS3U+ZGz4vvKhKE+RRXwI2zl27j0KPhx8X7Qj9HR8uCA6K20UvlK5o7Rm+UuPbOfUmVL92LnOrBW3wSMSrU/O83sDb0hl+U2O4fAry4dnzKbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HpqIglO8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=J+Fcje0q; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HpqIglO8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=J+Fcje0q; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HpqIglO8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="J+Fcje0q";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HpqIglO8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="J+Fcje0q"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E7ADF5D93C;
	Mon, 25 May 2026 10:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779703961;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F0D3QRq6nfWRTLO9n5cpghnwh0s48piacMk1SI7W3I0=;
	b=HpqIglO8dm2cSPwITbmQ4wMloCmLP1Hq/115v6wkQ7VXbga6c/EGSJGa2dIoQWp/w0nN/o
	1oCReEQlCg/rspLAmyVejB3kxBkNkL7hNTMdvFwoEQ+rdWRWqqs0NUBxzR1IVQyyir4RTN
	XvEpot30IEAKcNyH3GXFiBgQsWJ4Sy0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779703961;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F0D3QRq6nfWRTLO9n5cpghnwh0s48piacMk1SI7W3I0=;
	b=J+Fcje0qfZxosTABigme8K21MqsAIE62PSYfdU9ONAPs88F/iwUV7jaHBzUbfiF/emgikD
	xzcjuL8QDD15D+DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779703961;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F0D3QRq6nfWRTLO9n5cpghnwh0s48piacMk1SI7W3I0=;
	b=HpqIglO8dm2cSPwITbmQ4wMloCmLP1Hq/115v6wkQ7VXbga6c/EGSJGa2dIoQWp/w0nN/o
	1oCReEQlCg/rspLAmyVejB3kxBkNkL7hNTMdvFwoEQ+rdWRWqqs0NUBxzR1IVQyyir4RTN
	XvEpot30IEAKcNyH3GXFiBgQsWJ4Sy0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779703961;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F0D3QRq6nfWRTLO9n5cpghnwh0s48piacMk1SI7W3I0=;
	b=J+Fcje0qfZxosTABigme8K21MqsAIE62PSYfdU9ONAPs88F/iwUV7jaHBzUbfiF/emgikD
	xzcjuL8QDD15D+DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF4CD59BB7;
	Mon, 25 May 2026 10:12:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /hcbLpkgFGqbNgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 10:12:41 +0000
Date: Mon, 25 May 2026 12:12:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, hch@lst.de, linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Message-ID: <20260525101236.GU12792@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1779412152.git.wqu@suse.com>
 <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
 <20260523142344.GC183694@twin.jikos.cz>
 <e1961351-d563-4d73-b9f3-30063bbe7c4d@suse.com>
 <1b5c39fe-df28-4a21-bace-fc742498945e@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b5c39fe-df28-4a21-bace-fc742498945e@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
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
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Sun, May 24, 2026 at 01:43:54PM +0930, Qu Wenruo wrote:
> I tried the idea, and it doesn't look elegant at all, we need a lot of 
> if () checks around every xor_gen()/raid6_call.
> 
> Sure the end result is not that huge (and I have only compile tested 
> it), but if we had some parameters passed wrongly, or some corner case 
> missed, it can be very hard to notice.
> 
> Just paste the adhoc fix for reference:

I ended up with something similar, but replaced the open coded ifs with
a helper so there's not that much churn at the call sites.

> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 08ee8f316d96..50fefe33bbe3 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1410,11 +1410,17 @@ static void generate_pq_vertical_step(struct 
> btrfs_raid_bio *rbio, unsigned int
>   				rbio_qstripe_paddr(rbio, sector_nr, step_nr));
> 
>   		assert_rbio(rbio);
> -		raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
> +		if (rbio->nr_data > 1) {
> +			raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
> +		} else {
> +			memcpy(pointers[1], pointers[0], step);
> +			memcpy(pointers[2], pointers[0], step);
> +		}
>   	} else {
>   		/* raid5 */
>   		memcpy(pointers[rbio->nr_data], pointers[0], step);
> -		xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
> +		if (rbio->nr_data > 1)
> +			xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
>   				step);
>   	}
>   	for (stripe = stripe - 1; stripe >= 0; stripe--)
> @@ -1987,11 +1993,17 @@ static void recover_vertical_step(struct 
> btrfs_raid_bio *rbio,
>   		}
> 
>   		if (failb == rbio->real_stripes - 2) {
> -			raid6_datap_recov(rbio->real_stripes, step,
> -					  faila, pointers);
> +			if (unlikely(rbio->nr_data == 1))
> +				memcpy(pointers[0], pointers[rbio->real_stripes - 1], step);
> +			else
> +				raid6_datap_recov(rbio->real_stripes, step,
> +						  faila, pointers);
>   		} else {
> -			raid6_2data_recov(rbio->real_stripes, step,
> -					  faila, failb, pointers);
> +			if (unlikely(rbio->nr_data == 1))
> +				memcpy(pointers[0], pointers[rbio->real_stripes - 2], step);

The 2data recovery needs to do 2 memcpy

> +			else
> +				raid6_2data_recov(rbio->real_stripes, step,
> +						  faila, failb, pointers);
>   		}
>   	} else {
>   		void *p;
> @@ -2002,6 +2014,9 @@ static void recover_vertical_step(struct 
> btrfs_raid_bio *rbio,
>   		/* Copy parity block into failed block to start with */
>   		memcpy(pointers[faila], pointers[rbio->nr_data], step);
> 
> +		if (rbio->nr_data == 1)
> +			goto cleanup;
> +
>   		/* Rearrange the pointer array */
>   		p = pointers[faila];
>   		for (stripe_nr = faila; stripe_nr < rbio->nr_data - 1;
> @@ -2644,11 +2659,17 @@ static bool verify_one_parity_step(struct 
> btrfs_raid_bio *rbio,
>   	if (has_qstripe) {
>   		assert_rbio(rbio);
>   		/* RAID6, call the library function to fill in our P/Q. */
> -		raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
> +		if (rbio->nr_data > 1) {
> +			raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
> +		} else {
> +			memcpy(pointers[1], pointers[0], step);
> +			memcpy(pointers[2], pointers[0], step);
> +		}
>   	} else {
>   		/* RAID5. */
>   		memcpy(pointers[nr_data], pointers[0], step);
> -		xor_gen(pointers[nr_data], pointers + 1, nr_data - 1, step);
> +		if (rbio->nr_data > 1)
> +			xor_gen(pointers[nr_data], pointers + 1, nr_data - 1, step);
>   	}
> 
>   	/* Check scrubbing parity and repair it. */
> --
> 2.54.0
