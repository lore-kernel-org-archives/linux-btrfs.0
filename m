Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5654FECF3
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 17:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788541256; cv=none; b=rUihb3AXLBvjIQX1xBo9n7uxlrgDWr4bfNvn2+c2s9OFQM5NZTO0EtKncO4JSZxnD632jz/Wdi4nFJuBvl03fBsidJT6hN4lchVeCmhtf1Gb/Ite4qg+tSFE5pMB4FpB8Wd5vVOgkk4noWu9Ajl5xmxKYbn0DcyEy+uxfz3pXJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788541256; c=relaxed/simple;
	bh=BrAut/BCA+1lD+NNCpzp2hJ6Q99XryZYOg0KiBCPM3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0IyxsuUQWf1g6UjkICnAqXjIggUjoRcF1nlav4stUiZY35zxHtj/8mkbNdma3rxs3U4vHzp8EJ31ebtqXH+p4v2i5hA178PGU/pDvubiCupjKYNDpc9VXS/Bs8Ceo4ShmkGaYnUUQiYlvM93/zgS1mcztJOqBvwc61ED6R2Ab4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wEZdA7LA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=m10m2glt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pn8wBIxR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+oDZwi4n; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wEZdA7LA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="m10m2glt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pn8wBIxR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+oDZwi4n"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D617622C92;
	Fri,  4 Sep 2026 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788541249;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fZmGKxj5x1J7s2jaieuwKwgXfZlbiHZNfDUmlFTxld0=;
	b=wEZdA7LAKWvUAl44STHWh+UO1d+WorkDh6va0NcTTdRpkyGGVPWtXyYAqiJdlDzBlImEay
	rNe2vZrVI2COnS+3+Mni3/4lv8reYA+HQxCjHw7Dnm6uRMiljlW9MvNan/KFtsGd+N2JVH
	EAS/QR2C4m/hyxpBUgZTW+UQG5WvXpo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788541249;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fZmGKxj5x1J7s2jaieuwKwgXfZlbiHZNfDUmlFTxld0=;
	b=m10m2gltQB6LprCvw16rgCl8gRY7SLzgVg1yxGzquCvvaldiHKW93IGQLJHV3+0Q38vwSk
	+sRmLWyIRM+UZQAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pn8wBIxR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+oDZwi4n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788541244;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fZmGKxj5x1J7s2jaieuwKwgXfZlbiHZNfDUmlFTxld0=;
	b=pn8wBIxR8HFoQWgxE90I39TCy0QRR783dJk7s37NLSndeaaZ5OgKiQ05QVkIip/S2uIu2V
	0ku7Lwn8t7s5F6JLUuZMpM9z8WuDRZbvBBRSa6Hh6mJj+UemnbXQk94zfpU/uCNDT8gUPo
	Xt3wejyaIQW0yGDyZ5Eb+wuXcbxIWjs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788541244;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fZmGKxj5x1J7s2jaieuwKwgXfZlbiHZNfDUmlFTxld0=;
	b=+oDZwi4n+G3X52Uavo0SFMMtvJNvYfY/9czdxT7oXY+yObo7t07tLyVBTN8YrLeOu9G6Tu
	oIgdE8rfQFEFXGAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2A3A13726;
	Fri,  4 Sep 2026 17:00:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v3pfKzz5mmpsYwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 04 Sep 2026 17:00:44 +0000
Date: Fri, 4 Sep 2026 19:00:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Daniel Vacek <neelx@suse.com>
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental
 features
Message-ID: <20260904170035.GN9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D617622C92
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Thu, Sep 03, 2026 at 06:09:41PM +0930, Qu Wenruo wrote:
> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>  	 */
>  	btrfs_flush_workqueue(fs_info->delalloc_workers);
>  
> -	/*
> -	 * We can have ordered extents getting their last reference dropped from
> -	 * the fs_info->workers queue because for async writes for data bios we
> -	 * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
> -	 * run_one_async_done() which calls btrfs_bio_end_io() in case the bio
> -	 * has an error, and that later function can do the final
> -	 * btrfs_put_ordered_extent() on the ordered extent attached to the bio,
> -	 * which adds a delayed iput for the inode. So we must flush the queue
> -	 * so that we don't have delayed iputs after committing the current
> -	 * transaction below and stopping the cleaner and transaction kthreads.
> -	 */
> -	btrfs_flush_workqueue(fs_info->workers);

In the final fs closing sequence there's always some possible
interaction between the workers, but I don't think we need an explicit
flush anymore. The work offloaded to the system workers will be done
before we get here.
