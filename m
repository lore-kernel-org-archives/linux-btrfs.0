Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490F626B2DA
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 01:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782784176; cv=none; b=uXcMIIlKvqxhz1QUFGV6kp8ikTXu9JqDMVKJwWm/AJJVUc/L660xI+rKrJkf8AtCP9aqZeBW1lr38LKL1iLByLX96OnOsymSSyVBDL1jtlatosNqZcbqylm+xSa6kfLOkPrwHbv002NLZCVP1rC7BXaFURSu7jkDMiTA9lU5wsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782784176; c=relaxed/simple;
	bh=rrKUKEWz87DvNZUEsQmt2bUhikzcKHBpEdmn2J72uOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUnwkkYhO5fsXCTaypJtGLdtZNnlOPphdxhFDerXnpX1pzJDgX/6IL6KkWF+WruTeffUt8mwwokpjgM+mkjIUgIZvm1yP53fHu7RzHxa9baSd/53l8sfygrL0/EwhCj+Qs0/3DSFmqwm9wCF6UiNVVaRLuLlVZunkNQmWkmVuB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v1pVR/2E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qrridmv+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=irzAT0wV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HqAJxIRR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v1pVR/2E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qrridmv+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="irzAT0wV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HqAJxIRR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 469A7733B7;
	Tue, 30 Jun 2026 01:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782784173;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MVNjDJjOwM6WUVFjaMR6oo8Bkl83MeY92x3/qQkvQUQ=;
	b=v1pVR/2Et7+qJp0p688ue7eAEVWSt1ineLFC4p31s4XElSWpUBlLvqIl+hvhXjouiEgpa0
	qpyzht5SYwnyG3BUTEU7T1qd6iMYd2hsLD6lY//bp6IS2FwwCh8uroEgE+UYc+KaN+3HRY
	Ko54fYnRdvz4s2l6PKFpwD7uzXC47nk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782784173;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MVNjDJjOwM6WUVFjaMR6oo8Bkl83MeY92x3/qQkvQUQ=;
	b=qrridmv+2oyPtT8XhAY5ItdF+S8/sDCDk9F7gp/6p8BlCzgQpiG2ZQia7ZlSbGGe0LX0Si
	oxeOuVCW/b2zNVAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782784172;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MVNjDJjOwM6WUVFjaMR6oo8Bkl83MeY92x3/qQkvQUQ=;
	b=irzAT0wV1enUhlKfdbdGi6i892Qtm5HR5Wl0jlaMSOjmVtf0FK2CqGumFrza68gR5TmFK7
	DqGETX4eyV0sHgV5uQzJsS1vdGOKmqO3fCpv5Yf0zlPEZI+FPkuLh5Hj/au/awLMd/oDa/
	O84nDotzJGRbgvaMnhg/+6XgH8ZciDI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782784172;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MVNjDJjOwM6WUVFjaMR6oo8Bkl83MeY92x3/qQkvQUQ=;
	b=HqAJxIRRyPHApGFgLp9BB7BT+fuuaSCJkOP/Pt/Acjy7UF/TaNga/pmR3UsDpiQ/zEOhjl
	m7G9PdolytjFz+CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1CAC5779A8;
	Tue, 30 Jun 2026 01:49:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q0QaBqwgQ2rNGQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 30 Jun 2026 01:49:32 +0000
Date: Tue, 30 Jun 2026 03:49:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Sun YangKai <sunk67188@gmail.com>
Cc: Leo Martins <loemra.dev@gmail.com>, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>, Boris Burkov <boris@bur.io>,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] btrfs: replace writeback inhibition xarray with a fixed
 inline buffer
Message-ID: <20260630014930.GF2398896@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e0d3d3ac7c585b023c2e14cec7e2b995b247b68e.1781728340.git.loemra.dev@gmail.com>
 <7407611d-83cc-4a97-a5b2-acff7781e811@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7407611d-83cc-4a97-a5b2-acff7781e811@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,fb.com,suse.com,bur.io,intel.com];
	FREEMAIL_TO(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.50

On Thu, Jun 25, 2026 at 10:25:17AM +0800, Sun YangKai wrote:
> > -	/* Handle replacement of different eb at same index. */
> > -	if (old && old != eb) {
> > -		struct extent_buffer *old_eb = old;
> > +	if (trans->nr_inhibited_ebs < BTRFS_INHIBITED_EBS_SLOTS) {
> > +		slot = trans->nr_inhibited_ebs++;
> > +	} else {
> > +		/*
> > +		 * Full: advance the CLOCK hand, clearing reference bits until a
> > +		 * slot without one is found and evicted. Clearing a bit per step
> > +		 * bounds this to BTRFS_INHIBITED_EBS_SLOTS iterations.
> > +		 */
> > +		while (trans->inhibited_ebs_referenced &
> > +		       (1U << trans->inhibited_ebs_hand)) {
> > +			trans->inhibited_ebs_referenced &=
> > +				~(1U << trans->inhibited_ebs_hand);
> > +			trans->inhibited_ebs_hand =
> > +				(trans->inhibited_ebs_hand + 1) %
> > +				BTRFS_INHIBITED_EBS_SLOTS;
> 
> I think we can using overflowing add with ` & (SLOTS - 1)` as the index 
> as long as SLOTS is power of 2, instead of `% SLOTS`.

For immediate constants the compiler does various transformations that
utilize the power of two abilities to reduce the operations (I think
it's called 'strength reduce', e.g. mod -> bitwise and). You can check
the assembly if there's a division or and.

> And the higher 
> bits can parsed as number of "rounds" if we keep them, and I'm not sure 
> if the extra info is useful for any purpose.
> 
> > +		}
> > +		slot = trans->inhibited_ebs_hand;
> > +		trans->inhibited_ebs_hand =
> > +			(trans->inhibited_ebs_hand + 1) % BTRFS_INHIBITED_EBS_SLOTS;
> 
> the same math here.
> 
> >   
> > -		atomic_dec(&old_eb->writeback_inhibitors);
> > -		free_extent_buffer(old_eb);
> > +		atomic_dec(&trans->inhibited_ebs[slot]->writeback_inhibitors);
> > +		free_extent_buffer(trans->inhibited_ebs[slot]);
> >   	}
> 
> And personally I'd love to wrap this part of logic into a helper 
> function like
> 
> static inline u8 btrfs_inhibit_prepare_slot(struct btrfs_trans_handle 
> *trans) {...}
> 
> Or something with a better name.
> 
> >   
> > +	/*
> > +	 * Pin the eb while the array holds a raw pointer to it; the counter is
> > +	 * what lock_extent_buffer_for_io() checks.
> > +	 */
> > +	refcount_inc(&eb->refs);
> >   	atomic_inc(&eb->writeback_inhibitors);
> > +	trans->inhibited_ebs[slot] = eb;
> > +	trans->inhibited_ebs_referenced |= 1U << slot;
> >   }
> >   
> >   /*

> >   struct btrfs_trans_handle {
> >   	u64 transid;
> >   	u64 bytes_reserved;
> > @@ -163,8 +169,11 @@ struct btrfs_trans_handle {
> >   	struct btrfs_fs_info *fs_info;
> >   	struct list_head new_bgs;
> >   	struct btrfs_block_rsv delayed_rsv;
> > -	/* Extent buffers with writeback inhibited by this handle. */
> > -	struct xarray writeback_inhibited_ebs;
> > +	/* Extent buffers this handle has inhibited writeback on. */
> > +	struct extent_buffer *inhibited_ebs[BTRFS_INHIBITED_EBS_SLOTS];
> 
> This takes 64 bytes, which is necessary, fine.
> 
> > +	u32 inhibited_ebs_referenced;	/* CLOCK reference bit per slot */
> > +	u32 nr_inhibited_ebs;
> 
> Given the 8-slot limit for inhibited_ebs (4 bits (8) for capacity, 8 
> bits for bitmap), using u8 for these two fields is a clear and 
> straightforward choice IMO. Even if we later extend the limit to 16, 
> only the bitmap field (inhibited_ebs_referenced) would need to be 
> widened to u16.

The u32 is a bit more convenient on the instruction level, we can
consider u8 in case the transaction handle size grows more than what
fits to common slabs.

The xarray version has 184 bytes and quick estimate of this patch is
about 240 so we're in the 256 bucket anyway.
