Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124103C3433
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 14:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777299059; cv=none; b=jpgZ+HGyWHPTDGXAWKfQ3zhqyc9qFa97onCAcpBgh63wQQ98DGruqFuZMxqNFI1XC1/5Y2D1FxzOcHrYA6eZ8bcJE2wynVf1RcwvFpAPIVBf1D7ONkyQfAEjsu/IH1UM3sPRX0U/VQzJeoHSyOS5G1yMKk75TxUN7Xoe4HbYvfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777299059; c=relaxed/simple;
	bh=mtVVwe3acClY0UHySsoUSujAjYyDxPGkeHLGnXxUzJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8M18QTYywUbJicQP1YRJ0vx3tQbPM0aLQLPDsGHkWSqETN4/uuJCc6OQqinx15DVEIyvQFqIPDHx8LeYauq6bZdY9Rjo0rhEBzqWRu4cmnD27oFt2jbfY7xHrCRHmNYOlQLB/9ZI5OefMuJL6ZbRfvgDojpzmtRHxx5cNhYToA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bk6+Y2Xm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=o3EPjRXp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bk6+Y2Xm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=o3EPjRXp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bk6+Y2Xm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="o3EPjRXp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bk6+Y2Xm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="o3EPjRXp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4004E6A82D;
	Mon, 27 Apr 2026 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777299056;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zm2D4sEuX95LtyOH35adtMhor2Jl/W3tE9V7H4ak34A=;
	b=bk6+Y2Xm5dBjkZKU6STwFMCeRTTQG3XpQbQ9H2ONC7nTzfH1pnf84rLxSAbOekiwULOSy6
	MFbqc7rLZDTuGKVId2aV74D3pWCzx9BikOB2LGc9Cpi5biaCl2PiZxSLw8PVvOUjEUSqNR
	gj8jOSGHOzPjwom7+ksDX1tJ9TKptYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777299056;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zm2D4sEuX95LtyOH35adtMhor2Jl/W3tE9V7H4ak34A=;
	b=o3EPjRXp/0Gl5eFH5L86ZHX6fvRS2f9KooRlbMKnx+L9U2aGTY01mITRk4f198n93KnOIQ
	BS3M3+53wUgOHrDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777299056;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zm2D4sEuX95LtyOH35adtMhor2Jl/W3tE9V7H4ak34A=;
	b=bk6+Y2Xm5dBjkZKU6STwFMCeRTTQG3XpQbQ9H2ONC7nTzfH1pnf84rLxSAbOekiwULOSy6
	MFbqc7rLZDTuGKVId2aV74D3pWCzx9BikOB2LGc9Cpi5biaCl2PiZxSLw8PVvOUjEUSqNR
	gj8jOSGHOzPjwom7+ksDX1tJ9TKptYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777299056;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zm2D4sEuX95LtyOH35adtMhor2Jl/W3tE9V7H4ak34A=;
	b=o3EPjRXp/0Gl5eFH5L86ZHX6fvRS2f9KooRlbMKnx+L9U2aGTY01mITRk4f198n93KnOIQ
	BS3M3+53wUgOHrDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2368C593B0;
	Mon, 27 Apr 2026 14:10:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Lg9sCHBu72mEBAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 27 Apr 2026 14:10:56 +0000
Date: Mon, 27 Apr 2026 16:10:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] btrfs: support huge data folios for 4K page size
Message-ID: <20260427141054.GN12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1777019132.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1777019132.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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

On Fri, Apr 24, 2026 at 06:21:29PM +0930, Qu Wenruo wrote:
> [REASON FOR RFC]
> 
> - Unstable baseline for-next branch
>   The current for-next branch has a known regression where
>   btrfs_async_reclaim_metadata_space() kworker can fall into a dead loop
>   and fail several ENOSPC test cases.
>   Although the regression is pinned down, I'm still waiting for a good
>   baseline to rebase the series.

This has been resolved, patch removed from for-next.

> 
> - Extra on-stack memory usage
>   Currently we have two bitmaps that are using extra on-stack memory.
>   Each of them uses 64 bytes on-stack memory, so in total we can have
>   128 bytes just for the bitmaps.
> 
>   Not sure if it's a concern.

This will probably end up in the io path so it can be noticeable but as
we've been saving the stack bytes for some time I hope we can afford to
use as much as 128 bytes.

Allocation on IO path is worse problem in case we have to write data to
free more memory.

> - Uncertainty related to v7.2 large folio support
>   I'm planning to move large data folio support out of experimental.
>   So when that support is no longer experimental, this huge folio support
>   would need to start as experimental

I'd rather enable them separately. The large folios will affect
everything so we should minimize potential problems with another
feature.

>   Depends on which patch(set) is merged first, there needs to be some
>   modification to ensure end users won't suddenly get not only large but
>   also huge folios.

As rc1 is out we can start enabling fetures for 7.2, so please add the
large folios by default and the THP support as experimental.
