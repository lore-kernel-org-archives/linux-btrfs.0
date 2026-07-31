Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BBE3E6DD2
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 11:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785496009; cv=none; b=hE0+MnJfYB8TJxUPi3iWfcgy22sYJpyocE4k+YTWaxUqcXgpLXVCWJbFC4pABJ03JA9Mbi1fRsHI+Xxdi0izYOasb93H1xREfhvGo0xd81E6rQVKtjsJeTUAD3aT2w+rbgNYBo7Qx0OeEFxlWq9OAMd4/Z3NkTnA6LumXx1y80k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785496009; c=relaxed/simple;
	bh=B89dV/fLvSddLIhUFEaegKdMBCz5p8CGMT7wOd8FDzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nHSXbXF9iFCj7v1qbkxpPcxhomfvcC+xghUwEWn/R4BKhCuCDtoDg8a4vl6kQpmwtBHXKaAFF561xugT5FwWa9pJKiLbZBKYlNWOyqnXJ0eTDJHOnBW+dtSC9cb76h8HhiIBSUAS9UxqYiSxghTzN1AR8hPEnI8KYOrECsrwOf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ll5RXdd4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XyOxXxlU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VEq7kZRs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=a6LiftFE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ll5RXdd4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XyOxXxlU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VEq7kZRs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="a6LiftFE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 63B3B7DEF6;
	Fri, 31 Jul 2026 11:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785496000;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WL8llijlTZ8DwVDHfUF3jb3pTPiP7r2UJ+AGG8p5ms8=;
	b=ll5RXdd4X0F4TdTHn4xezzxPUiY9osCzcEl4B5OtVwY069b5H/5Gf/7vE1uBsBwz3+sXG0
	Rou+pGJFf3UtwAyTE3fL4tsrSik5AXfAZUN1K7J3TejsDvDfT3mtIdDIqLWacXgCad+RDo
	D5dsFRsEtL2PwIgwcRJvw2tX2osOyDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785496000;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WL8llijlTZ8DwVDHfUF3jb3pTPiP7r2UJ+AGG8p5ms8=;
	b=XyOxXxlU71JJ3Kqa9rnNfP15WuBd1Ko4XsWeyEb5HLpOceWm4UIuQGL9F05I7G7Ow9FyxK
	0vNX5uP75ZgJn/Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VEq7kZRs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a6LiftFE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785495996;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WL8llijlTZ8DwVDHfUF3jb3pTPiP7r2UJ+AGG8p5ms8=;
	b=VEq7kZRshDZkDyDiPtFeAqDNMvMV/Ayy5ag6wUbI2jeXWxz4HBKGpR0RZGmwD8n0mbg81/
	DJEZuoHcOA2O6hNaBZr2XNGFNkMFkSElxPcUguC6vx76c3n4AUMk4v70nh2B4fxbtBF6Ua
	egm9lGu1rbaxIWXxor8Lt+iXpWPRrzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785495996;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WL8llijlTZ8DwVDHfUF3jb3pTPiP7r2UJ+AGG8p5ms8=;
	b=a6LiftFEOXW4AIT5QOeLRWY7gy5misU4RSkCPv3BfTTLJ4EGpoQYC1LULFv5AynYukaBj9
	1F7Pc5jZAkhyoUAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4EBC9779B0;
	Fri, 31 Jul 2026 11:06:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UPEOE7yBbGrUNQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 31 Jul 2026 11:06:36 +0000
Date: Fri, 31 Jul 2026 13:06:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2] btrfs: flush the fixup workers during close_ctree
Message-ID: <20260731110634.GV10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <97d1b25314a0006e8fa3be0c66cb850f6d08523f.1785428166.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97d1b25314a0006e8fa3be0c66cb850f6d08523f.1785428166.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Queue-Id: 63B3B7DEF6
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Thu, Jul 30, 2026 at 09:38:02AM -0700, Boris Burkov wrote:
> Reintroducing the COW fixup worker brought back the unmount race fixed
> by commit 41fd1e94066a ("btrfs: wait for fixup workers before stopping
> cleaner kthread during umount") without bringing back the fix.
> 
> A fixup work item queued by the final writeback pass can still be in flight
> when close_ctree() stops the cleaner kthread and frees the fs roots.
> While destroy_workqueue() drains the queue, that happens after the
> cleaner thread was freed, so btrfs_add_delayed_iput() called from the
> fixup worker is no longer safe (not to mention that we are already in
> BTRFS_FS_STATE_NO_DELAYED_IPUT when it runs).
> 
> Therefore we need to bring back explicitly flushing the fixup workqueue
> as in Filipe's original fix. The first flush will catch all the fixup
> writeback queued during the final sync before umount, but some of that
> might hit memory allocation errors and stay fixup in the blocks/folio,
> leading any subsequent writeback triggered *inside* umount (e.g. reclaim
> workers shutting down) to hit it and queue again. To fix that, and the
> possibility of any really long-lived pinned folios getting marked, deny
> queueing new fixup during umount. That allows us to flush twice (once
> before doing a real writeback pass to get the actual data, second time
> to clean up any rather unlikely stragglers right before declaring
> BTRFS_FS_STATE_NO_DELAYED_IPUT) and be certain nothing got re-queued.
> 
> Reproduced by injecting a one-shot 30s sleep at the head of
> btrfs_writepage_fixup_worker() on a KASAN kernel, running the normal
> reproducing read dio workload before unmount and then observing:
> 
>   BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x35/0x50
>   Read of size 1 at addr ffff88810b4b08f8 by task kworker/u32:5/219
>   Workqueue: btrfs-fixup btrfs_writepage_fixup_worker [btrfs]
>   Call Trace:
>    _raw_spin_lock_irqsave+0x35/0x50
>    try_to_wake_up+0xc0/0x18c0
>    btrfs_writepage_fixup_worker+0x7f3/0xf20 [btrfs]
>   ...
> 
> Fixes: 4be9c7da6860 ("btrfs: trigger cow fixup via dirty_folio()")

BTW the commit is not stable, so you can only use the subject for
reference.

As the new fixup worker commit is already big, please add this one
separately.
