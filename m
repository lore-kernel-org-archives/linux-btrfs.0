Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE75D3783AE
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 11:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784635023; cv=none; b=X+D3qtH9F7A0eO6WULZnYq2UlyT+Z0S++8lQZ92wd68luz8lJL/kLP3t31/UMJKag9VQ0xH7mUuwD/AdzwNrG4edHxdgfQbcINfH8TlzPvZM8cqxOC1y6ShHarRUDf3tI/fTp3wL7KhjJzodynVB9t4EnS9TRcO8++7bVK0jcaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784635023; c=relaxed/simple;
	bh=95m5zNbO701FArg6wZUtp7cZ/8tk3tVsyJI1qEHgEjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uk3J3oMpEhprdvOKqf/WvFXa2bWWNlEup8q5q35EtszKGolbo4MZoO5V2Xi/CNB46znv4jg5O3PKuw08cEYksw9I53cdnD/g/URK5nC4llYvNPo1zsQrhHNio3XBTHOo4a4CqdvERR+6AX8+Dj8MIQU1YCclKTwlu1KvcyL9G3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qET9E/br; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=947RujLd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qET9E/br; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=947RujLd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qET9E/br";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="947RujLd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qET9E/br";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="947RujLd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9FEDB3DFE;
	Tue, 21 Jul 2026 11:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784635019;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DNrtsO35bYLHe6vF5C5JXWt9zObPLUzMcYzT9uVL6p8=;
	b=qET9E/brJybRHjaqZmuHcbwriNUa/u83ybEnPEC2/F2s7Eh1Jm2q9xy8qOXkNZGW4rg2qS
	Kn1dC0jAGMn4sBhXxmd5AQWjAykQ3DHT9hBnvhaSgw0UI9VfIX/gBoFDGs22CrYP0j8znD
	E/L9waqiON+Xy0LrSqcXftEeJZRTsOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784635019;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DNrtsO35bYLHe6vF5C5JXWt9zObPLUzMcYzT9uVL6p8=;
	b=947RujLdCWKuxA/Q13y4wqhxzaMt7NGDEGxhMuMeZ/GN10o4daWQYa7qUaPvoQpiaqu4AL
	5evwzaVvSzcvHFCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qET9E/br";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=947RujLd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784635019;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DNrtsO35bYLHe6vF5C5JXWt9zObPLUzMcYzT9uVL6p8=;
	b=qET9E/brJybRHjaqZmuHcbwriNUa/u83ybEnPEC2/F2s7Eh1Jm2q9xy8qOXkNZGW4rg2qS
	Kn1dC0jAGMn4sBhXxmd5AQWjAykQ3DHT9hBnvhaSgw0UI9VfIX/gBoFDGs22CrYP0j8znD
	E/L9waqiON+Xy0LrSqcXftEeJZRTsOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784635019;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DNrtsO35bYLHe6vF5C5JXWt9zObPLUzMcYzT9uVL6p8=;
	b=947RujLdCWKuxA/Q13y4wqhxzaMt7NGDEGxhMuMeZ/GN10o4daWQYa7qUaPvoQpiaqu4AL
	5evwzaVvSzcvHFCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96850779AA;
	Tue, 21 Jul 2026 11:56:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fIuLJIteX2pBLgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Jul 2026 11:56:59 +0000
Date: Tue, 21 Jul 2026 13:56:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: open-code BTRFS_BYTES_TO_BLKS()
Message-ID: <20260721115658.GH10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <df638c77eb7c4f39492c03722062f250fd6e72cf.1784537784.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df638c77eb7c4f39492c03722062f250fd6e72cf.1784537784.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9FEDB3DFE
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon, Jul 20, 2026 at 06:26:52PM +0930, Qu Wenruo wrote:
> That macro is only utilized 4 times, all inside file.c, meanwhile we
> have tons of open-coded usages.
> And since it's a macro, there is no proper type checks at all.
> 
> There isn't much need for such a rarely utilized macro.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

We do the direct sectorsize_bits calculations in other places too.

Reviewed-by: David Sterba <dsterba@suse.com>
