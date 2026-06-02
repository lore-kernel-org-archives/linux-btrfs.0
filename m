Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEDE2441B8
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 13:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780406205; cv=none; b=GjI2Zm3fmbrIPykIfCcAjNl0Dd0EKww/iXC7SHJ7jKG2rQx18w9uHbstBCMbg1A580Ll5kAjLzzvN3oSAxab+1lhhNqvt0hfWB9iYA3zTrdkSQ0Qv0qi8oYE7I1ekN6/w8S94D2oUq2og4bowwJ8uNQiHZfl6sFnoVIDG0gVeFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780406205; c=relaxed/simple;
	bh=YZwIaAsEu5uomPCur462t6SbAD+DOoZ2+CoOdTRU3KY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6i6HVLYhuFxPiV7ATPTT9391r4yPwHhkFyrx2tiT0RNm3qDcdM/W9MTwOczLRiP/WGth3zeRV51yThIojKRhGCpx4IXO+e3AhmVY1lnl7La4XFtg35AV7FufUMVUQPQxz8FtwojB836ufAaNaJh8MYuLDtJx3Uyel9O8FAVzW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0B/tLDmK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CFqJMdoh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0B/tLDmK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CFqJMdoh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0B/tLDmK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CFqJMdoh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0B/tLDmK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CFqJMdoh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 416B16BB7D;
	Tue,  2 Jun 2026 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780406202;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8CJ6u+PMilYkRCog0le0GElXEnI9s2ABzdUDapClwfM=;
	b=0B/tLDmKk3MbOkpvaiawjjYEtThd20GUts94qdw35yw/eocMyIzrrol0RnQoIOgZ7ZvcEN
	fNHhDUsMj7ImT977hFDJZgHYwVwD7uTcWtlG2fhtUhi9xwKZ2t76VVpxCICt7gW6TSxG13
	0gfytZgJzZwWfFuRqL3l0eoHwrB9CeE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780406202;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8CJ6u+PMilYkRCog0le0GElXEnI9s2ABzdUDapClwfM=;
	b=CFqJMdohBZXyJ16D87lLcSHFwxMA9yMrMW+/l7zY0rwJfOvabQ3BdplXz5JLNFWOL4BVzw
	mTDisYcY2jvyBwAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780406202;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8CJ6u+PMilYkRCog0le0GElXEnI9s2ABzdUDapClwfM=;
	b=0B/tLDmKk3MbOkpvaiawjjYEtThd20GUts94qdw35yw/eocMyIzrrol0RnQoIOgZ7ZvcEN
	fNHhDUsMj7ImT977hFDJZgHYwVwD7uTcWtlG2fhtUhi9xwKZ2t76VVpxCICt7gW6TSxG13
	0gfytZgJzZwWfFuRqL3l0eoHwrB9CeE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780406202;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8CJ6u+PMilYkRCog0le0GElXEnI9s2ABzdUDapClwfM=;
	b=CFqJMdohBZXyJ16D87lLcSHFwxMA9yMrMW+/l7zY0rwJfOvabQ3BdplXz5JLNFWOL4BVzw
	mTDisYcY2jvyBwAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 28247779A7;
	Tue,  2 Jun 2026 13:16:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BY2aCbrXHmpFLgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 02 Jun 2026 13:16:42 +0000
Date: Tue, 2 Jun 2026 15:16:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Drop WQ_PERCPU from ordered_flags in
 btrfs_init_workqueues()
Message-ID: <20260602131640.GA1297960@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.982];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Score: -4.00

On Mon, Jun 01, 2026 at 07:46:26PM -0700, Nathan Chancellor wrote:
> After commit 21c05ca88a54 ("workqueue: Add warnings and ensure one among
> WQ_PERCPU or WQ_UNBOUND is present"), there is a warning from the
> btrfs-qgroup-rescan workqueue at run time:
> 
>   workqueue: btrfs-qgroup-rescan uses both WQ_PERCPU and WQ_UNBOUND. Dropped WQ_PERCPU, keeping WQ_UNBOUND.
> 
> WQ_PERCPU is included in ordered_flags after commit 69635d7f4b34 ("fs:
> WQ_PERCPU added to alloc_workqueue users") and WQ_UNBOUND is set in
> alloc_ordered_workqueue(), which btrfs_alloc_ordered_workqueue() calls.
> 
> Drop WQ_PERCPU from ordered_flags, as alloc_ordered_workqueue() notes
> that only WQ_FREEZABLE and WQ_MEM_RECLAIM are meaningful.
> 
> Fixes: 69635d7f4b34 ("fs: WQ_PERCPU added to alloc_workqueue users")
> Fixes: 21c05ca88a54 ("workqueue: Add warnings and ensure one among WQ_PERCPU or WQ_UNBOUND is present")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> This should go in via the workqueue tree that adds the warning.

Acked-by: David Sterba <dsterba@suse.com>
