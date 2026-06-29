Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4A73CB2DC
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 23:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782774557; cv=none; b=s86C5dd5fhQpuOo1LGmaeaAPBM4GEn63t1LJjGLjxuHB5Ty7GciT/kqRtzsvgZRhcZPD5GWrBR5V6MpkkJtDWhn8tr/XA+bABlJhgfykfwJrXSxoQkjlr0AkxeEoS80n3VB+slh6msp9cb/SSoI1hmvWh5FkR/xpK5IPeImr8zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782774557; c=relaxed/simple;
	bh=u7Gn9AVTuAVy5mwBsj6JFKqOVwb2MxZ+F41/aKVX6E4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtMd8qhmNm0y0OK0m/mfcjgT1rBC+gpH3xS1rva0wHNx+jK5AeQ8NqxlNGbNYdII0df/OWdWEUMNdzFNEiPgnEnk08/6u1csdZNWruUaCedzjmdo9ifrsGE8ACevt++wldkoLfavyR717AUkXnCUoWjD9c+2E8eL1HuSDR6lags=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xJlqwt5o; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jG4E3gct; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xJlqwt5o; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jG4E3gct; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xJlqwt5o";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jG4E3gct";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xJlqwt5o";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jG4E3gct"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 223CE73313;
	Mon, 29 Jun 2026 23:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782774554;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8l1p9G6nzGdfWV0Pe5qguJQO+PEovMtTXN+A9aHQ4A=;
	b=xJlqwt5okSVqsRfhzSfVCwpAYhSj7lE3CyrkZMRuDq+C3t3t/RqDBhp/jQjo0z/vnQ32DU
	sOLqVTwxShxIQ46RrnfJDvCh2l0pxHHB4zb4ZmACNEDQnJqJ+6MfK4cDwGrvO5coDRJT45
	I8nbXpxxEnZtmPNiosN/YyGwE/9S15U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782774554;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8l1p9G6nzGdfWV0Pe5qguJQO+PEovMtTXN+A9aHQ4A=;
	b=jG4E3gct0mcLZqg5Kpr9fbeCjvhKmOi6gAJpYmkZDYeC2UUnVhn3hX3symJ2lWdjovJ0un
	UxAog7epG8jZu/Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782774554;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8l1p9G6nzGdfWV0Pe5qguJQO+PEovMtTXN+A9aHQ4A=;
	b=xJlqwt5okSVqsRfhzSfVCwpAYhSj7lE3CyrkZMRuDq+C3t3t/RqDBhp/jQjo0z/vnQ32DU
	sOLqVTwxShxIQ46RrnfJDvCh2l0pxHHB4zb4ZmACNEDQnJqJ+6MfK4cDwGrvO5coDRJT45
	I8nbXpxxEnZtmPNiosN/YyGwE/9S15U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782774554;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8l1p9G6nzGdfWV0Pe5qguJQO+PEovMtTXN+A9aHQ4A=;
	b=jG4E3gct0mcLZqg5Kpr9fbeCjvhKmOi6gAJpYmkZDYeC2UUnVhn3hX3symJ2lWdjovJ0un
	UxAog7epG8jZu/Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02FA8779A8;
	Mon, 29 Jun 2026 23:09:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lt0GOxn7Qmp7fwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 29 Jun 2026 23:09:13 +0000
Date: Tue, 30 Jun 2026 01:09:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Sun YangKai <sunk67188@gmail.com>
Cc: Rosen Penev <rosenp@gmail.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: compression: allocate buckets with workspace
Message-ID: <20260629230908.GB2398896@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260629002505.1552238-1-rosenp@gmail.com>
 <c6f9a5f5-0aaf-4f89-9e88-fb7eaf6aa3d2@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6f9a5f5-0aaf-4f89-9e88-fb7eaf6aa3d2@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,fb.com,suse.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Score: -4.00

On Mon, Jun 29, 2026 at 09:54:11AM +0800, Sun YangKai wrote:
> > -	ws = kzalloc_obj(*ws);
> > +	ws = kzalloc(struct_size(ws, bucket, BUCKET_SIZE * 2), GFP_KERNEL);
> 
> It seems that size is fixed and known at compile time, and since we want 
> to inline the buckets in the struct, I think we can have something like 
> this to save one pointer:
> 
> struct heuristic_ws {
> 	...
> 	struct bucket_item bucket[BUCKET_SIZE];
> 	struct bucket_item bucket_b[BUCKET_SIZE];

I like this idea, given that we know the size at compile time.

> }
> 
> However, each bucket array takes exactly 1024B memory. Currently we have 
> a 48B allocation for the struct it self, 2 * 1024B allocation for bucket 
> array, and 8192B allocation for sample. With these 2 arrays inlined, the 
> struct will need 32 + 2048B allocation if my calculation is correct, 
> which will goes into kmalloc-4k. Seems not good.

SLUB merges same/similar sized structures for the named caches, I'm not
sure if this also works for the generic slabs. We can add the kmem cache
and so we can utilize the merging.

The sharing can be seen in /sys/kernel/slab, "ls -l | grep <SIZE>". The
size is rounded up to hw cacheline, so for the heuristic workspace it'll
end up in size 2112. I see at least one existing named slab on my
system, 'dmaengine-unmap-256'. This may not matter, but a named cache
can fix the slack space in the 4k slab.
