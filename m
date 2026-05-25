Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D79B30BB80
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 11:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779708922; cv=none; b=sCYmAEYC+sfBulu7QExq9MCOCPfv8AtR3WkI86h+DyByF3f8FyFEdgTG/SDIMmIiRIMiyhpvPQgLY6X73UMgUq/EK3IcmkI/p8tn1EYsiNYR/nuzAKWY7gz3+IhtDRH/pNV6sI/VmZqCFog9dLepmd5H9XxUxesEeOfCVc4gfGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779708922; c=relaxed/simple;
	bh=nyR4R3AsC53gA72JI6F00St3ln3I/Q++yDxR86jX3yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fR+fE3JES5R3hF6FcFdRoOVGKJAt1VxNVBLlcSN5jhp+GKof2qFhtzMYOzyEVE1hr/j9V5VcYpQEDYVMnpD/Bl/8GfdkbE9vGkWsip1J5GZELbk6cyS7lziagRsgDgDS0hVcuGWEIbW1gi7X6Sgo4wVd8ZgedAaKZXqtfl9O+m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N8VwC3nm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pqy1LATQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N8VwC3nm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pqy1LATQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N8VwC3nm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pqy1LATQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N8VwC3nm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pqy1LATQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B66DF6BAF9;
	Mon, 25 May 2026 11:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779708918;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g0PgxhXVeEhGWjS2SNH8PG3aQlrWNR52y1yoRRpLp50=;
	b=N8VwC3nmXKQSkSl9wU5K0dQox7AgYRUi23bakCkUkb15synIFjK2RftTKydeWmaXHafUeF
	frEXXlfUL8aJcna+GsWc3wm5Ty+ats1XiV0Ef0/AqN2bPDigabyhkV8yfTUug7SCuX4poO
	mWLqxE82O8QWJ80ClXnlB/pfJl+2HOw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779708918;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g0PgxhXVeEhGWjS2SNH8PG3aQlrWNR52y1yoRRpLp50=;
	b=pqy1LATQVCpk1/ee/HnsieC7lvli4kzPZvxvXQnvgjARTOrsN2r9gDwkag6BtqPH2kbwOX
	6MiyNhkDchSPV9CQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779708918;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g0PgxhXVeEhGWjS2SNH8PG3aQlrWNR52y1yoRRpLp50=;
	b=N8VwC3nmXKQSkSl9wU5K0dQox7AgYRUi23bakCkUkb15synIFjK2RftTKydeWmaXHafUeF
	frEXXlfUL8aJcna+GsWc3wm5Ty+ats1XiV0Ef0/AqN2bPDigabyhkV8yfTUug7SCuX4poO
	mWLqxE82O8QWJ80ClXnlB/pfJl+2HOw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779708918;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g0PgxhXVeEhGWjS2SNH8PG3aQlrWNR52y1yoRRpLp50=;
	b=pqy1LATQVCpk1/ee/HnsieC7lvli4kzPZvxvXQnvgjARTOrsN2r9gDwkag6BtqPH2kbwOX
	6MiyNhkDchSPV9CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 94A0F59C0A;
	Mon, 25 May 2026 11:35:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jM8UJPYzFGpuBwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 11:35:18 +0000
Date: Mon, 25 May 2026 13:35:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>, Boris Burkov <boris@bur.io>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 0/5] btrfs: zoned: fix deadlock and space reporting
 issues for zoned filesystems
Message-ID: <20260525113517.GY12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522090247.27445-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Fri, May 22, 2026 at 11:02:42AM +0200, Johannes Thumshirn wrote:
> This series fixes premature ENOSPC errors and deadlock issues on zoned BTRFS
> filesystems when running xfstest generic/747, which tests garbage collection
> on zoned block devices using direct and buffered I/O.
> 
> There where two issues revealed in the investigation:
> 
> Async reclaim deadlock: On zoned filesystems, the flush state machine
> only executes RECLAIM_ZONES and RESET_ZONES in later flush states
> (FLUSH_DELALLOC and beyond). By the time these states are reached,
> ticket waiters can deadlock waiting for space that can only be freed by
> zone reset. The fix adds RECLAIM_ZONES and RESET_ZONES to the first
> async reclaim loop (FLUSH_ALLOC) specifically for zoned filesystems,
> ensuring zone reset happens early enough to free space for pending
> allocation tickets.
> 
> Additionally, the series fixes a bug in data relocation block group selection
> where the first block group was incorrectly skipped, and adds a new flush
> state (BTRFS_RESERVE_FLUSH_DATA_RELOCATION) to use priority reclaim for
> zoned data relocation operations.
> 
> Using this, generic/747 passes when lowering the fill_percent variable
> to 80% (from the 95%) that XFS uses. I'm still examining if this is due
> to XFS not having metadata on zoned or other statfs space estimation
> bugs or something else.
> 
> Changes to v2:
> - Re-do the data-relocation block-group selection algorithm
> 
> Changes to v1:
> - Removed the zone_unusable statfs patch
> - Removed the heavy handed flushing patch
> - Added fixes tags where needed
> - Added more comments
> 
> Johannes Thumshirn (5):
>   btrfs: zoned: document RECLAIM_ZONES flush state
>   btrfs: zoned: decode 'RECLAIM_ZONES' state in tracepoints
>   btrfs: zoned: always set data_relocation_bg
>   btrfs: zoned: don't account data relocation space-info in statfs free
>     space
>   btrfs: zoned: fix deadlock waiting for ticket during data relocation

Added to for-next, with updated changelog in patch 3 and deleted
comment. Thanks.
