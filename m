Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792421959;
	b=V3gUolRbmE6LF9AKRkSNSMB5AmTArvY0u6opqGrmdZ5h6ytL6zjmRBqFBtTJTHVW/M+v
	 dOx223Q6LRbyTMjMeO52ZhhhykKUFkwDVNHAC/MVDb4rEljcU2V8sc2XVdOJWPMFnJ50A
	 31uQyQ1qob1avHJ2NTt1rDJtYX9wZGwnna0/ZXykkMqqknMZOWFVqYo6lao5USCLjUROe
	 PcKFWSECNcXKnP0pkrFP1Xs+lCsQYAVxihLw3jPKJ0yxS15exzDo21quASl5cCJ1XCvyy
	 inSlhWotUz2YIQxRQ1r4npOse6iGxvwb8/1zPKa2HbQadL3a7pZ/bLAJnbUwCUgqQXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792421959;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=n7i7rAGh/mw2TVWRxfuUk6u6pE/hRB3oclZY0gQNkSY=;
	b=VRwqTLszYx/QYJLRzHxq+DZ2a0zRWp/pUNmOg0Jg+XnLTZrll3erMMIHOzEtvpS+RDsB
	 4npbBnasp4eNNjcrA6FAZHyJVFRZyPlH2DhYjA9tWMDwoEwW6cW6HG0AVnpwAnhvzfce6
	 sVc1OzPjlUoUvJ9YVR1vlYzyAmTnExhFfcUFkCX8uT+r/1Qm8AvW/s1yuUi/UTsfOQ/it
	 7rYKBc+k8B4BGty273Wh9NFNvNXpBPb+TbTB9xRZJ0MCOXp2QqzLigYNknTK4+xhbQLAe
	 gextvZky4uzcjD6KZUkRYTlZBzTzaOdADLdSVc0tccVBfMNUHvplJuziJlAjng4y7SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=N8ks6qFW;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=S4ZOyZLb;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xHERwuuL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XnmEIHR2;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB2660774EE
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 14:59:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CB2660774EE
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=N8ks6qFW;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=S4ZOyZLb;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xHERwuuL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XnmEIHR2
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 849661F78A;
	Mon, 19 Oct 2026 14:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792421951;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n7i7rAGh/mw2TVWRxfuUk6u6pE/hRB3oclZY0gQNkSY=;
	b=N8ks6qFWEGmJQnyiiwdzQnb+PPvH02vJDXyL7mHjL0dMwV2W2jf495vpPIz8dAacT3Go4r
	m2xKU60mv0QaHkG8NbOu8c2jCxFdOERTL7Uh2x7wY7eiJ4WVXFAq0fQDkqyCoGAi8SMOOs
	RWrnW3exuPz6gmy394tBm315bywWC8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792421951;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n7i7rAGh/mw2TVWRxfuUk6u6pE/hRB3oclZY0gQNkSY=;
	b=S4ZOyZLb2Ofpv0h5mZWo2ZazEeWcF1VKtt+9X2TJHyZWUSY5ATgLecZGMDkj54+8z03Lj1
	tHonG0MlmXMOHXBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792421950;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n7i7rAGh/mw2TVWRxfuUk6u6pE/hRB3oclZY0gQNkSY=;
	b=xHERwuuL+8PikfwNM0nOwSnFHcqH4CMgSbF83F4G2cKYI4wA0Btn3/NYDjTx4c6ejztSr0
	Bx5ePG1pxDbkPCFnI19XuylCmXXZpyNi01EUZADefd4rWsGGXDKDqncQ4d2gnIrHFULu9C
	y3RL6PzznvPDWKLjCbNkhasacht9vjU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792421950;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n7i7rAGh/mw2TVWRxfuUk6u6pE/hRB3oclZY0gQNkSY=;
	b=XnmEIHR2t2yRw7P2hFRfC9YdhDlixsXaJFAF+MVklzkJ4YyLb0SPfumNLMihk0iboyBJhm
	0NX3u6qZuNKSEKAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59631136CC;
	Mon, 19 Oct 2026 14:59:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cOWODz4w1mrBCgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 19 Oct 2026 14:59:10 +0000
Date: Mon, 19 Oct 2026 16:59:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: make chunk size validation to be simpler
Message-ID: <20261019145909.GC1310987@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <bd4a247e970e35e3adc140c5417da14bfab2f4f8.1792296994.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4a247e970e35e3adc140c5417da14bfab2f4f8.1792296994.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO

On Sun, Oct 18, 2026 at 02:47:02PM +1030, Qu Wenruo wrote:
> Commit 6ded22c1bfe6 ("btrfs: reduce div64 calls by limiting the number
> of stripes of a chunk to u32") introduced a chunk size limit check, but
> it is using a wrong result in the comment:
> 
>   U32_MAX << BTRFS_STRIPE_LEN_SHIFT results 256T, not 256G.
> 
> Instead of calculating the size limit, using an immediate number
> (SZ_256G).
> 
> This has the following benefit:
> 
> - Still large enough for future expansion
>   Although the check is 1024 times more strict, I don't think we will
>   allow 256G chunk anytime soon.
> 
>   And we have higher chance (10 more bits) to catch a bitflip in the
>   high bits.
> 
> - Much harder to diverge from the comment
>   We don't need to calculate the number anymore.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
