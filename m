Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7759332EC8
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 12:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781613347; cv=none; b=peF4ALebbjNK2bl4Ns9w7MnCHJtt0CqbCMY122SG1SXl8hAPHF+rQiwVBTSseY1RzYw433kY5XsFdcjSjmdJUNZwZeUW4TybcN0Y/SLitV6ezcT+TfIzI5LFAYEhV25tcBlKk/eZJaOqfJnnxDqYw3bGUhUcjRW4TIiD8EFzhPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781613347; c=relaxed/simple;
	bh=1kt7OI38JgGsWU05H8B7Ac5gFbZngmQptboLFtcne3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pI4P2AT4eKaMJLc4DTB0rezUwF8xafB5KoLAY1LA7WZb6UOIo4wpl5+V9glV1eGA9xTm2KjbHLXs+0C2fM9iGeTP9bVOCynvQBNyLb4CA3P+1CZtzMg0rQ20n3OfC0LZ72xt7IutwsXKFFsDAoiOBGNC2OanAye1HFQc9u1eqy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=O4nAu7gX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xj2hkj8V; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mNNSCkOR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QiMYkO4X; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="O4nAu7gX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xj2hkj8V";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mNNSCkOR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QiMYkO4X"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1755F758BC;
	Tue, 16 Jun 2026 12:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781613343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hzcEeP56jCkAFyEQj80eGVotXsJwbErFXunXyembSqs=;
	b=O4nAu7gXo3PGokScyBo+/26587gbhOFEjuQYfZif9Z7UPL+UyB9w8/yImUkJj6nKxkZvIF
	ACNDfxbqv2S/jKbPSzYnGS04tp/bnFIRPC2rgFpBQlVUj4q/1dJtbq1kQ1pzkNM8RUw5i7
	edN4OgbxZoKg3DEOyNFMvD29Yfsqi90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781613343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hzcEeP56jCkAFyEQj80eGVotXsJwbErFXunXyembSqs=;
	b=xj2hkj8VPJM94XvadsACdEX4DvBMdxwPOtG01yHy19RtorvaDNZ3XASI5AxsJdl4y4pdoe
	fiBrjb02abIazUAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781613342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hzcEeP56jCkAFyEQj80eGVotXsJwbErFXunXyembSqs=;
	b=mNNSCkORAExBvf9aB+tsKn6sNxaOD0/AoqFMvNzFoNg6eBIkgVP47YpePYI8Q+QAta10iP
	Zqx1XIfYgx4GnXtuGP5LsShk3JNXKW2YKaUDxYJfutRHsfFhpRVeVU+8As1qza+ZhFAv+T
	LGBDSEUjEL/jp/T1nKZUcrq+AXC/4ao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781613342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hzcEeP56jCkAFyEQj80eGVotXsJwbErFXunXyembSqs=;
	b=QiMYkO4XgJZYhAk7caL660bvBuhrXc9zzaUNXC1t8aNqAIz1iloYN1niN6CDdldptvvt18
	4M/D6No11mpbQtBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0DAE4779A8;
	Tue, 16 Jun 2026 12:35:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id s1RTAx5DMWpkdQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 12:35:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8F798A12D3; Tue, 16 Jun 2026 14:35:41 +0200 (CEST)
Date: Tue, 16 Jun 2026 14:35:41 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] block: split bdev_yield_claim() out of bdev_fput()
Message-ID: <vy7piht2etjon6kadhd6ti7qrqkt3lrp3ziw7pngmyukfahtq6@6nnmfvheah2e>
References: <20260616-work-super-freeze_deny_upstream-v2-0-b3567c7f994b@kernel.org>
 <20260616-work-super-freeze_deny_upstream-v2-2-b3567c7f994b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-freeze_deny_upstream-v2-2-b3567c7f994b@kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Level: 

On Tue 16-06-26 13:58:15, Christian Brauner wrote:
> bdev_fput() yields the holder claim and then closes the file, which is a
> deferred operation.  Split the yield half into bdev_yield_claim() so a caller
> can give up the holder while the file - and therefore the block device - is
> still open, act on the device, and only then bdev_fput().
> 
> A filesystem that made a device unfreezable for a membership change with
> bdev_deny_freeze() undoes the deny on release with
> 
> 	bdev_yield_claim(bdev_file);
> 	bdev_allow_freeze(file_bdev(bdev_file));
> 	bdev_fput(bdev_file);
> 
> Re-allowing only after the holder is yielded avoids stranding the filesystem
> on a racing freeze, and doing it while the file is still open avoids touching
> the block device after bdev_fput().  bdev_fput() yields again, which is a
> no-op once the claim has already been given up.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bdev.c           | 50 ++++++++++++++++++++++++++++++++++----------------
>  include/linux/blkdev.h |  1 +
>  2 files changed, 35 insertions(+), 16 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index a83a3809380c..54b35a084c36 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -1200,6 +1200,39 @@ void bdev_release(struct file *bdev_file)
>  	blkdev_put_no_open(bdev);
>  }
>  
> +/**
> + * bdev_yield_claim - give up the holder claim on an open block device
> + * @bdev_file: open block device
> + *
> + * Yield the holder and any write access for @bdev_file without closing it, so
> + * the caller can still act on the device - e.g. bdev_allow_freeze() it - before
> + * the final bdev_fput().  bdev_fput() yields too, so calling it afterwards is
> + * safe.
> + */
> +void bdev_yield_claim(struct file *bdev_file)
> +{
> +	struct block_device *bdev;
> +	struct gendisk *disk;
> +
> +	if (!bdev_file->private_data)
> +		return;
> +
> +	bdev = file_bdev(bdev_file);
> +	disk = bdev->bd_disk;
> +
> +	mutex_lock(&disk->open_mutex);
> +	bdev_yield_write_access(bdev_file);
> +	bd_yield_claim(bdev_file);
> +	/*
> +	 * Tell release we already gave up our hold on the
> +	 * device and if write restrictions are available that
> +	 * we already gave up write access to the device.
> +	 */
> +	bdev_file->private_data = BDEV_I(bdev_file->f_mapping->host);
> +	mutex_unlock(&disk->open_mutex);
> +}
> +EXPORT_SYMBOL_GPL(bdev_yield_claim);
> +
>  /**
>   * bdev_fput - yield claim to the block device and put the file
>   * @bdev_file: open block device
> @@ -1213,22 +1246,7 @@ void bdev_fput(struct file *bdev_file)
>  	if (WARN_ON_ONCE(bdev_file->f_op != &def_blk_fops))
>  		return;
>  
> -	if (bdev_file->private_data) {
> -		struct block_device *bdev = file_bdev(bdev_file);
> -		struct gendisk *disk = bdev->bd_disk;
> -
> -		mutex_lock(&disk->open_mutex);
> -		bdev_yield_write_access(bdev_file);
> -		bd_yield_claim(bdev_file);
> -		/*
> -		 * Tell release we already gave up our hold on the
> -		 * device and if write restrictions are available that
> -		 * we already gave up write access to the device.
> -		 */
> -		bdev_file->private_data = BDEV_I(bdev_file->f_mapping->host);
> -		mutex_unlock(&disk->open_mutex);
> -	}
> -
> +	bdev_yield_claim(bdev_file);
>  	fput(bdev_file);
>  }
>  EXPORT_SYMBOL(bdev_fput);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index cf1951caadb2..9fc16e3c8075 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1832,6 +1832,7 @@ int bdev_thaw(struct block_device *bdev);
>  int bdev_deny_freeze(struct block_device *bdev);
>  void bdev_allow_freeze(struct block_device *bdev);
>  void bdev_fput(struct file *bdev_file);
> +void bdev_yield_claim(struct file *bdev_file);
>  
>  struct io_comp_batch {
>  	struct rq_list req_list;
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
