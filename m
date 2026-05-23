Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C3230C60D
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 15:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779551944; cv=none; b=qEVMEn/toHKki+Xmut8S4QF7Aa4xxdeKi9rpm7G+0ckJCNOP9nSSJG1fgMmskmY+WFm5wSjmBK8Z6BcbZgat51cqUQzbxaH1sMqGonfiiYkFJnD4mJwMqHWUKEmsde5O+TEHVHNxwPQ9nsmZuxpqHFfC08n/HeT38TKPh+iPPyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779551944; c=relaxed/simple;
	bh=+g0NMMGxlRdQxYzM63EFuxUzQGzzNW3AUIMGdfqIpkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/41Nw9zLij8VA4k7shCYefCwuJHMiCANmboaeK3FSCcJt7+g4hrzh1iHFo1vGk6K7uNrXWE9TMDd+ht/RfclG2zrqizP3Q9hCrm9xOX8+/pPMUsvcXH88oGq3ytK9HDSSUlI8h24ex5fpNEAkPCKVXrxoHUad+9StwHToTCEes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VqSMot8F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8/5BOhYp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VqSMot8F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8/5BOhYp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VqSMot8F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8/5BOhYp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VqSMot8F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8/5BOhYp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 270C263D11;
	Sat, 23 May 2026 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779551941;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PigY/OTtyoBC4PQKUyB3Djq6TUmlWcS3lHedpovsxTw=;
	b=VqSMot8FWslhseKH1A+sIF3BbIxYNYt94oQ7WVTyRiUtQ15WedK6fV7bu/pEw1zaK2CKH1
	rfwx+NuvlHwIYdXIhq3d+eWjSqWBanX0vnC7Yr6PDJ8Z+5S94b4Dck3Je61cK/xqWkpPoW
	V//SGAH2mXtwsHK7lpXCDmpShHRDEcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779551941;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PigY/OTtyoBC4PQKUyB3Djq6TUmlWcS3lHedpovsxTw=;
	b=8/5BOhYpfPHPajToZ0KL2xeaFcYVOXWI9Ma2QR57SfqR71qS926ZF8GIevcAFyTRczH08+
	sZ0ceYtd0ChorCAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VqSMot8F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/5BOhYp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779551941;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PigY/OTtyoBC4PQKUyB3Djq6TUmlWcS3lHedpovsxTw=;
	b=VqSMot8FWslhseKH1A+sIF3BbIxYNYt94oQ7WVTyRiUtQ15WedK6fV7bu/pEw1zaK2CKH1
	rfwx+NuvlHwIYdXIhq3d+eWjSqWBanX0vnC7Yr6PDJ8Z+5S94b4Dck3Je61cK/xqWkpPoW
	V//SGAH2mXtwsHK7lpXCDmpShHRDEcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779551941;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PigY/OTtyoBC4PQKUyB3Djq6TUmlWcS3lHedpovsxTw=;
	b=8/5BOhYpfPHPajToZ0KL2xeaFcYVOXWI9Ma2QR57SfqR71qS926ZF8GIevcAFyTRczH08+
	sZ0ceYtd0ChorCAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3642593A8;
	Sat, 23 May 2026 15:59:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DyMxOsTOEWowBgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 23 May 2026 15:59:00 +0000
Date: Sat, 23 May 2026 17:58:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, linux-mm@kvack.org, david@kernel.org,
	willy@infradead.org, surenb@google.com, hannes@cmpxchg.org,
	ljs@kernel.org, ziy@nvidia.com, usama.arif@linux.dev,
	fvdl@google.com, Chris Mason <clm@meta.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as
 movable
Message-ID: <20260523155859.GF183694@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260520150018.2491267-1-riel@surriel.com>
 <20260520150018.2491267-35-riel@surriel.com>
 <20260520174749.GA1458531@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520174749.GA1458531@zen.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 270C263D11
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On Wed, May 20, 2026 at 10:47:49AM -0700, Boris Burkov wrote:
> > @@ -689,14 +704,23 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
> >   * Populate needed folios for the extent buffer.
> >   *
> >   * For now, the folios populated are always in order 0 (aka, single page).
> > + *
> > + * @movable: pass true only when the resulting pages will be attached to
> > + *           btree_inode->i_mapping (the alloc_extent_buffer real path).
> > + *           Cloned/dummy extent buffers (EXTENT_BUFFER_UNMAPPED) leave
> > + *           folio->mapping NULL, never enter the LRU, and never get the
> > + *           btree_migrate_folio aops, so __GFP_MOVABLE would violate the
> > + *           page-allocator's migrability contract for them.
> >   */
> 
> My gut says it is nicer to just transparently pass along a gfp flag
> rather than a carefully documented movable boolean and let the callers
> do the right thing. Just a nit, I don't care strongly about it.

Agreed, the GFP flags would be better and also a bit more self
documenting where the functions are called. The patch is not standalone
so I don't mind having the booleans, we can clean it up later to let the
40-patch series proceed.
