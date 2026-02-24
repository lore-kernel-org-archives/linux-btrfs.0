Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4883A0B19
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2026 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771942526; cv=none; b=cg7KoOD2f/IGlwfFtOrln12ZVS/Wjb7MfXVxQXfFU6t9JcpfdK7MvHLaNvU9dZMslcu572wQ4eGl5vc9v6GZSq3dRyrQKf6moe9IHGoN9Ou8lK5ip5qk9M77sjlNEIz0OhXw99n2cOhIWuVGmwONmYm3YohmGm5/m1g8uFLRrj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771942526; c=relaxed/simple;
	bh=YWzT27GS7htk4EN7GnRcNRL8iBhAzS6NUtJj60P+6ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KnaP/8IEyi8VphUe/CwV1Knw5hMXwI3G243XaNVZ/83/sOLKDO0oi7SDELWv8URPE4T1hpg+kOzSfXfo+6/Y3zud0UXeEkyWUNbTvUQHN6tOnkz5DRQV46yCcNrFEJKNnu28WXKXyXuzZrYh68gy67v4X0MTVRHruy6wUcHuE3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qTzF+9VM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oZkvMy3R; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qTzF+9VM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oZkvMy3R; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qTzF+9VM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oZkvMy3R";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qTzF+9VM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oZkvMy3R"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 633EF3F266;
	Tue, 24 Feb 2026 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771942523;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zxT3NvpIEQ8mtVSPt7WteBMlXyGfjfK3I8sXJgRTfGU=;
	b=qTzF+9VMSMv39W64NciVLM/yWQXFSGD7GCbu7POZqaB2H9DeskSQLAg68hm7qn4Y0f0QbA
	XYHs9B9QB9lNXfS0GLtvWwmzDaryALgUyYTxS4xoVVSUv9K0ynA7+TQ1AhCePGpjaeb/kA
	zRYYfxIPXDSnUo4Kw7tfFxcV9mpgSZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771942523;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zxT3NvpIEQ8mtVSPt7WteBMlXyGfjfK3I8sXJgRTfGU=;
	b=oZkvMy3RkzpNNZ2V7aju52DaHqUXVaShnPJG3xA75XUIxGmVCr1wpp0kShMPPdXKusi/YD
	y1bGbBf9JXRAUTDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771942523;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zxT3NvpIEQ8mtVSPt7WteBMlXyGfjfK3I8sXJgRTfGU=;
	b=qTzF+9VMSMv39W64NciVLM/yWQXFSGD7GCbu7POZqaB2H9DeskSQLAg68hm7qn4Y0f0QbA
	XYHs9B9QB9lNXfS0GLtvWwmzDaryALgUyYTxS4xoVVSUv9K0ynA7+TQ1AhCePGpjaeb/kA
	zRYYfxIPXDSnUo4Kw7tfFxcV9mpgSZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771942523;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zxT3NvpIEQ8mtVSPt7WteBMlXyGfjfK3I8sXJgRTfGU=;
	b=oZkvMy3RkzpNNZ2V7aju52DaHqUXVaShnPJG3xA75XUIxGmVCr1wpp0kShMPPdXKusi/YD
	y1bGbBf9JXRAUTDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45A1E3EA68;
	Tue, 24 Feb 2026 14:15:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Au/YEHuynWk8PAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 24 Feb 2026 14:15:23 +0000
Date: Tue, 24 Feb 2026 15:15:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: introduce a common helper to calculate the
 size of a bio
Message-ID: <20260224141518.GV26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1771558832.git.wqu@suse.com>
 <4392c94fea9644702e3985c30cf0a30c434aa3d5.1771558832.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4392c94fea9644702e3985c30cf0a30c434aa3d5.1771558832.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Fri, Feb 20, 2026 at 02:11:50PM +1030, Qu Wenruo wrote:
> We have several call sites doing the same work to calculate the size of
> a bio:
> 
> 	struct bio_vec *bvec;
> 	u32 bio_size = 0;
> 	int i;
> 
> 	bio_for_each_bvec_all(bvec, bio, i)
> 		bio_size += bvec->bv_len;
> 
> We can use a common helper instead of open-coding it everywhere.
> 
> This also allows us to constify the @bio_size variables used in all the
> call sites.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/misc.h   | 15 +++++++++++----
>  fs/btrfs/raid56.c |  9 ++-------
>  fs/btrfs/scrub.c  | 22 ++++------------------
>  3 files changed, 17 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/btrfs/misc.h b/fs/btrfs/misc.h
> index 12c5a9d6564f..189c25cc5eff 100644
> --- a/fs/btrfs/misc.h
> +++ b/fs/btrfs/misc.h
> @@ -52,15 +52,22 @@ static inline phys_addr_t bio_iter_phys(struct bio *bio, struct bvec_iter *iter)
>  	     (paddr = bio_iter_phys((bio), (iter)), 1);			\
>  	     bio_advance_iter_single((bio), (iter), (blocksize)))
>  
> -/* Initialize a bvec_iter to the size of the specified bio. */
> -static inline struct bvec_iter init_bvec_iter_for_bio(struct bio *bio)
> +/* Can only be called on a non-cloned bio. */

Please also add an ASSERT for that.

> +static inline u32 bio_get_size(struct bio *bio)

				  const ...

>  {
>  	struct bio_vec *bvec;
> -	u32 bio_size = 0;
> +	u32 ret = 0;
>  	int i;
>  
>  	bio_for_each_bvec_all(bvec, bio, i)
> -		bio_size += bvec->bv_len;
> +		ret += bvec->bv_len;
> +	return ret;
> +}

Reviewed-by: David Sterba <dsterba@suse.com>
