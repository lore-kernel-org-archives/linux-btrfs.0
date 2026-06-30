Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D671A3793C2
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 20:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782850940; cv=none; b=YuWLnhUYSlVWLvKo5xt+AvKpi2O7UAM7fU+8aDvEyZe3Gp8X6rYb2l2xWA8bRUhPeYLVmkf34UjmOCWXdrGBLPdWA43EFi/4mB/z/b2Jc/FUkhoNBRGnijMZzh4KYXNeeKzYlqifk3erF0hyd4papOaInyWDTbmjRdIhnwnltBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782850940; c=relaxed/simple;
	bh=VkkaiXHof4QX9LVEC0w/XNM1nr7CJwjR3FyMsdxUXeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtW2jyDazKQo12e5w8YCXl8BJTDyyjdlAEKthLrA/pwBf5+c+K96M2cuCiuGRVkCi4e2GonddPQjJKkjpe0/4uExEBaYaJituMDMWtNZwnX5cAmAP63iX3SKl+kWWSHQ5z2lGuxIdEn34jEqJtYKnmWoJGkRvSpk3c+aBY7ljR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ts3Ogjmq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EsNIF7w9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=M6aCn3Ds; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QKeVUIMF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ts3Ogjmq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EsNIF7w9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="M6aCn3Ds";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QKeVUIMF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 091F073852;
	Tue, 30 Jun 2026 20:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782850937;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TxZkJM+HVITqN9psZ21i88y795G+HzyYaYrE/MEJ5fU=;
	b=ts3OgjmqLxsUBLW0ND8A2s7k9U8UdCFbbXlUVkhfWbBohTimB4tViVE2jPcJtSaEk1Wfea
	0fGry+AAfbIy953U2cJTpoAJ0G4q0/1GIJfxcOK0TJzyFZR/eh18j2TFawM4+I5PQ+YjcI
	2m9n2jmyMXMcZVFyPfcz8QPppKdugrk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782850937;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TxZkJM+HVITqN9psZ21i88y795G+HzyYaYrE/MEJ5fU=;
	b=EsNIF7w9O4WxKcJDlCWCruDM4ieZ3sfe77am9YZ5fGhIHsbzD+fh+cbT827xDAwyXYeFl1
	TGiJRJPrVc/542Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M6aCn3Ds;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QKeVUIMF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782850934;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TxZkJM+HVITqN9psZ21i88y795G+HzyYaYrE/MEJ5fU=;
	b=M6aCn3Dsze+AOixSYCKMUDHzxrPauIs2eHGpvWTBg9SA8AALFLcCxU8vpMLTwAtrT56x/B
	iWOVV2NHANG47qZldPweWwCgO1+EcW4yhyG6qAgKYc3XHBa7MYKr9KEgwUGHsVJ44NJ8JV
	L1x7dpQ6UYPi2hmThMIFd4YQ6fR6D5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782850934;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TxZkJM+HVITqN9psZ21i88y795G+HzyYaYrE/MEJ5fU=;
	b=QKeVUIMFdQDFQE7TW7JKxLtm2H9PoZQDKu4f6X8uNYJmS2KVLk+vPgh4aqesOVeP5D+FJJ
	JU55IpsjCJMzupCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DEA0A779A8;
	Tue, 30 Jun 2026 20:22:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YjceNnUlRGp8WwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 30 Jun 2026 20:22:13 +0000
Date: Tue, 30 Jun 2026 22:22:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Yue Sun <samsun1006219@gmail.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	mark@harmstone.com
Subject: Re: [BUG REPORT] btrfs/io_uring: GPF in tctx_task_work_run after
 encoded read error completion
Message-ID: <20260630202212.GC2907432@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260630091609.3414-1-samsun1006219@gmail.com>
 <8c8b9ace-dc84-46bf-8495-44bf2f2b0680@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c8b9ace-dc84-46bf-8495-44bf2f2b0680@kernel.dk>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,fb.com,suse.com,vger.kernel.org,harmstone.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 091F073852
X-Spam-Score: -4.21

Adding Mark to CC

On Tue, Jun 30, 2026 at 01:00:06PM -0600, Jens Axboe wrote:
> >   # Later, the same task waits for io_uring completions and runs task_work.
> >   io_uring_enter()
> >     io_cqring_wait()
> >       io_run_task_work()
> >         task_work_run()
> >           tctx_task_work()
> >             tctx_task_work_run()
> >               req = container_of(node, struct io_kiocb, io_task_work.node)
> >               ctx = req->ctx
> >               mutex_lock(&ctx->uring_lock)
> >               # Crash: req->ctx appears poisoned/stale before
> >               # btrfs_uring_read_finished() is reached.
> 
> If the work is passed to task_work, then btrfs must return -EIOCBQUEUED.
> Looks like a basic bug in btrfs, see below. Caveat - entirely
> untested/compiled/whatever. On vacation, btrfs guys can figure this out.

Thanks for the hint.

> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 272598f6ae77..51c06618c733 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9460,7 +9460,6 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
>  			ret = blk_status_to_errno(READ_ONCE(priv->status));
>  			btrfs_uring_read_extent_endio(uring_ctx, ret);
>  			kfree(priv);
> -			return ret;
>  		}
>  
>  		return -EIOCBQUEUED;

Initial commit 34310c442e175f ("btrfs: add io_uring command for encoded
reads (ENCODED_READ ioctl)").

The ret is initialized from priv->status and is needed for
btrfs_uring_read_extent_endio() but it's apparently not meant as return
due to the task handover. I've checked other locations, this seems
to be the only not following the expected -EIOCBQUEUED.
