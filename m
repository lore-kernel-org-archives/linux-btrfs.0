Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6821F192E
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777297117; cv=none; b=krzNiojqGXcXnQz7aUzAeGib5P/zPcX5uWm8bgffIwSc5nZHd/q091tX6Xxz+z6VL5Kf6nusHHBT9KbRCTsVrBG+sl3m+WXvzVKr15pNAzHcBslN4/I8TyXV+C085IusJYAQltP6WIZhJKrDDDtxXt9cxE7Ar8HxNwkRHaRxQ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777297117; c=relaxed/simple;
	bh=jkGC2hbUEaDc644ZzryyFSgxmIepugGwxOodHwKnuY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oOyybqiU5hASUJIqSgC5UIZRPzjXpVPPKAfBkzHfdlyAkd5+z07CUnASSnXOjEiirPXd44qBQ5ArbA0zWfh6ceGdQtgTnSHR5u4QHgIKEhzEtJhd30WRj2daR6kN2LoVpSfDN6vkxEMmUAQ8RORTR3taICKuqiwtVXYUjkDDV6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vJyf3Lxu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3s7gNj+a; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vJyf3Lxu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3s7gNj+a; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vJyf3Lxu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3s7gNj+a";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vJyf3Lxu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3s7gNj+a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 14AB06A8EA;
	Mon, 27 Apr 2026 13:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777297114;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dIUYQWmUqWubV4d9yZTTxNEQrXa6X5pzbDInlBFtEYQ=;
	b=vJyf3Lxui1sooZLoi1IQ6NAiqYD1khc2XemCXPP3gnNVfthAyt27CZvYXg13xY5HnTo+g4
	fqiwnURR3TfyuDU0s8D9n4uQvHBwgGkJ3erBz8r4u1vVmQ6bKkfF5h5f9vpiRYJItXZONh
	7OKnwjek25QlNJkiO0O4fo7EdhNYtRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777297114;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dIUYQWmUqWubV4d9yZTTxNEQrXa6X5pzbDInlBFtEYQ=;
	b=3s7gNj+aBI5vKnnAFH4JKMlPu8V71ZeMSef6GTcJDC6KZNbVE5XcXRlzHib3awNordjgtp
	DCNEYJF9dCXnhwDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777297114;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dIUYQWmUqWubV4d9yZTTxNEQrXa6X5pzbDInlBFtEYQ=;
	b=vJyf3Lxui1sooZLoi1IQ6NAiqYD1khc2XemCXPP3gnNVfthAyt27CZvYXg13xY5HnTo+g4
	fqiwnURR3TfyuDU0s8D9n4uQvHBwgGkJ3erBz8r4u1vVmQ6bKkfF5h5f9vpiRYJItXZONh
	7OKnwjek25QlNJkiO0O4fo7EdhNYtRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777297114;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dIUYQWmUqWubV4d9yZTTxNEQrXa6X5pzbDInlBFtEYQ=;
	b=3s7gNj+aBI5vKnnAFH4JKMlPu8V71ZeMSef6GTcJDC6KZNbVE5XcXRlzHib3awNordjgtp
	DCNEYJF9dCXnhwDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF8B6593B0;
	Mon, 27 Apr 2026 13:38:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3dpAOtlm72lnYQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 27 Apr 2026 13:38:33 +0000
Date: Mon, 27 Apr 2026 15:38:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: properly enable compressed readahead for bs <
 ps and large folio cases
Message-ID: <20260427133832.GL12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1777189624.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1777189624.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Sun, Apr 26, 2026 at 05:21:02PM +0930, Qu Wenruo wrote:
> Compressed data readahead is disabled for bs < ps cases, but it has
> never taken large folios into the consideration.
> 
> And that unexpectedly enables compressed data readahead for large
> folios, which should go through the same subpage routine.
> 
> This means for real bs < ps cases compressed data read is disabled, but
> still enabled for bs == ps with large folios.
> 
> This small series will properly enable the compressed readahead for both
> bs < ps and large folios cases, mostly by simply remove the unnecessary
> checks.
> 
> Then since we're here, also update the function name and comments to
> reflect that we're already using folio interface, not the old page
> interface.
> 
> Qu Wenruo (2):
>   btrfs: enable cross-folio readahead for bs < ps and large folio cases
>   btrfs: refresh add_ra_bio_pages() to indicate it's using folios

Please add it to for-next, thanks.
