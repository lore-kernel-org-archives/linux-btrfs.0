Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D6B3A9633
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 21:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774043028; cv=none; b=NNSO7ZSmUag0yW1+I8Og/vU+je2nPUWsfIt1/IUoeCtAlZ58MMIe1c7RH8N+ZKWHALmHaxsDQdjMJsdvGCXUVQ4+pH+JwvlsF8A/Oh7bY+jjp6pNlxkgi46AGorWxFPVWdRQAXQGoW5SYdF/HgBFMATbtMmzU/Pyrv5Knf/hVeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774043028; c=relaxed/simple;
	bh=2eQrntHqbvIkJ8IA5EDBQnB1jPHySQCGoYQQp0tnQTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=otmGdyoV1eSZknriXkwjLDWZsz1ygWFmc0BkOgB47+FXqOFqELM4k3IWwe5i+InbmRoppAzBzb1cpkSoyjdL+O85H63BSHoonWGfpEmiDT3L1tVFuqYMZODP7hs7JlZZTIdBVNlHIGwlzCSm2kYcGEbqo47Ury/JbM2VSYHXIeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aquxMOoF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hqi3QI4M; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aquxMOoF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hqi3QI4M; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aquxMOoF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hqi3QI4M";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aquxMOoF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hqi3QI4M"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 144EC5BE2B;
	Fri, 20 Mar 2026 21:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774043025;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g/hQs7HAokqv2ew1iSlw8X1EiIZ2dZAg/K9cgoiSy10=;
	b=aquxMOoFWARKX+/r2m+JQas9QBmcUPfjaZTZkDCIwHtZ5/NAJLI9HaHlZBNksWHm5nis4k
	wIbTbbYmsiiDyR4PG8aVsoR3z8YN/Xp9KL9J1BseZ2q1SYyzuUhyA+6ZfWDHZsGUooe+lh
	pI+FP8oMzfZJ2lOjjHta+NAApjVnLTY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774043025;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g/hQs7HAokqv2ew1iSlw8X1EiIZ2dZAg/K9cgoiSy10=;
	b=hqi3QI4MBjVZj8X+OccE/LsBprrqPpzrvwggNb5Vani59NYuHAm/CKP1yK8eLGw4+GHMkb
	TZgLnPN3OtGYuVAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aquxMOoF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hqi3QI4M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774043025;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g/hQs7HAokqv2ew1iSlw8X1EiIZ2dZAg/K9cgoiSy10=;
	b=aquxMOoFWARKX+/r2m+JQas9QBmcUPfjaZTZkDCIwHtZ5/NAJLI9HaHlZBNksWHm5nis4k
	wIbTbbYmsiiDyR4PG8aVsoR3z8YN/Xp9KL9J1BseZ2q1SYyzuUhyA+6ZfWDHZsGUooe+lh
	pI+FP8oMzfZJ2lOjjHta+NAApjVnLTY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774043025;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g/hQs7HAokqv2ew1iSlw8X1EiIZ2dZAg/K9cgoiSy10=;
	b=hqi3QI4MBjVZj8X+OccE/LsBprrqPpzrvwggNb5Vani59NYuHAm/CKP1yK8eLGw4+GHMkb
	TZgLnPN3OtGYuVAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0E40429F9;
	Fri, 20 Mar 2026 21:43:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /rmcOpC/vWnXdQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 20 Mar 2026 21:43:44 +0000
Date: Fri, 20 Mar 2026 22:43:35 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix lost error when running device stats on
 multiple devices fs
Message-ID: <20260320214335.GH5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <9d308e7cc667be86e3a24bdd34f1cf24f02bfb5d.1773850534.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d308e7cc667be86e3a24bdd34f1cf24f02bfb5d.1773850534.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 144EC5BE2B
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Wed, Mar 18, 2026 at 04:17:59PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Whenever we get an error updating the device stats item for a device in
> btrfs_run_dev_stats() we allow the loop to go to the next device, and if
> updating the stats item for the next device succeeds, we end up losing
> the error we had from the previous device.
> 
> Fix this by breaking out of the loop once we get an error and make sure
> it's returned to the caller. Since we are in the transaction commit path
> (and in the critical section actually), returning the error will result
> in a transaction abort.
> 
> Fixes: 733f4fbbc108 ("Btrfs: read device stats on mount, write modified ones during commit")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
