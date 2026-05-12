Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C80D3D45D4
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 17:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778605357; cv=none; b=XxfHSEWqmw0FamatpkwPC+h2SI3APL9YlDWjFqrvOjc/xl325bEzg6EaFVq0FltYASSarNXDvUD5BCBKnytf4R++nv2wns24+O9R43oJe29ils0IRQ3yD+FAkG4l7qpPYj+IQLwayamtds8GVTLJIDi/P3mYb/UhAbB/NuUXQNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778605357; c=relaxed/simple;
	bh=6Z7QhECsoiT51A0LzveB/6lXSqsR5hRP+/itP8F6pCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a0tvdrKQ8k6suTlx5QjYDuY3T+JF3LLxeKE6ObbqOMWrqwaSiZtYsmQTEJymIfJNTxib2J2JXl3ujZowPeKafc5gjF0z9gpHnsyz2rc0STzIm2urQlHC07j1uwgjNPExE71Hgg/cG/4T1xTgStbdnpNasJ6EVbGXiy/EcWYnQP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fjw867DU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vHLS6L1G; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PlB72knN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LAZgmrPr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fjw867DU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vHLS6L1G";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PlB72knN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LAZgmrPr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 91B3C6B20F;
	Tue, 12 May 2026 17:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778605354;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qWmA/SU30iisUL8yDAmLEMsUHqmwJh+wy7NiCYQYZxo=;
	b=Fjw867DUfUe22dAKW6i5/cHfJ/vKFdJ0bbUuBompEyuv4fYGqzNpo7kHixRsP4/57kqXcZ
	xiHZSasoeiDKtw/Py8a4cf6ObP0fARKK7yrFgjLV4JQnQHGUYvso5pHl/ch9dcEpFqqbUZ
	bCoH8YQktKfjLaMpz4th3L6gnyDM8bM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778605354;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qWmA/SU30iisUL8yDAmLEMsUHqmwJh+wy7NiCYQYZxo=;
	b=vHLS6L1Gypf4IGvFSl4t4oOYdCv2Rql+vxFX6gf+K9bHBES8DAkApaLkhaARzvaSJBawm8
	lcgf0irt+DD2ozCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778605350;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qWmA/SU30iisUL8yDAmLEMsUHqmwJh+wy7NiCYQYZxo=;
	b=PlB72knNaSkwjjkHeOHT/gkqcvtF+QgLB+5lLZsKXmsQFWCugX7Wlj0pdEeum8hCr3wv/t
	cIR+5v6k/b8AkbvYg3It6eq8QyTuVVmbDsbdkbhcQNlwL2wlPYwl8KXSMT3Wi42L7oHw2K
	Pmzw2+pHt62RXLSEHTp1QL7NQOdshfk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778605350;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qWmA/SU30iisUL8yDAmLEMsUHqmwJh+wy7NiCYQYZxo=;
	b=LAZgmrPrhV6qz2WwSJ7+DhmTPfNS6qFuzeRyHyGdF+D/DwcSn57PaAPx/GWYYYDfFlkoJr
	qXFtTY1IwKJROCDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7BF55593A9;
	Tue, 12 May 2026 17:02:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zY0NHiZdA2qzLgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 12 May 2026 17:02:30 +0000
Date: Tue, 12 May 2026 19:02:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove locked subpage bitmap
Message-ID: <20260512170225.GK2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ce0d536ed12aa0e931a384654447ba183ff068f3.1778317565.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce0d536ed12aa0e931a384654447ba183ff068f3.1778317565.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.com:email,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00

On Sat, May 09, 2026 at 06:36:31PM +0930, Qu Wenruo wrote:
> Currently there are two members inside btrfs_folio_state that are related
> to locked bitmap:
> 
> - locked sub-bitmap inside btrfs_folio_state::bitmaps[]
>   The enum btrfs_bitmap_nr_locked determines the sub-bitmap.
> 
> - btrfs_folio_state::nr_locked
>   Which records how many blocks are locked inside the folio.
> 
> The locked sub-bitmap is a btrfs specific per-block tracking mechanism,
> which is mostly for async-submission, utilized by compressed writes.
> 
> The sub-bitmap itself is a super set of nr_locked, as it can provide a
> more reliable tracking.
> 
> But the sub-bitmap itself can be pretty large for the incoming huge
> folio, 2M sized folio for 4K page size, meaning 512 bits for one
> sub-bitmap.
> 
> Furthermore, in the long run compression will be reworked to get rid of
> async-submission completely, there is not much need for a full
> sub-bitmap to track the locked status.
> 
> This patch removes the locked sub-bitmap and only relies on @nr_locked
> atomic to do the tracking.
> This can also save 64 bytes from btrfs_folio_state::bitmaps[] for a huge
> folio.
> 
> This will reduce some safety checks, as previously if a block is not
> locked, btrfs_folio_end_lock()/btrfs_folio_end_lock_bitmap() will find
> out that, and skip reducing @nr_locked for that block, and avoid
> under-flow.
> 
> But this safety net itself shouldn't be necessary in the first place.
> If we're unlocking a block that is not locked, it's a bug in the logic,
> and we should catch it, not silently ignoring it.
> Thus I believe the removal of the extra safety net should not be a
> problem.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
> This will conflict with the huge folio patchset and the removal of
> ordered sub-bitmap.
> 
> Thus all three patchsets (including this one) will need some co-ordination
> and refresh, depending on which one got merged first.

Let's start with this single patch, then the ordered series. We have
enough time to test it soufficiently before the next merge window.
