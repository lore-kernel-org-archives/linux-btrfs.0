Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0358248C3FA
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 12:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784635799; cv=none; b=BvyjBHDDfx+u1nhcK2Di2NdquFYQ1piTHUJQafERt/oSzwT3rG5Cv2LtyIlX89tfAAXk7aKXhbz1hljDbE3bva4+4W/TU0yTYSH08i3UuZBdqs/C9qB4ESd+g+Fnki8eMre56/EvM+ucENAulKoCUz0IRfsnW5dITjXf7hNhBZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784635799; c=relaxed/simple;
	bh=AikEuQvoMpcWm7yghTq/t9YYpmbRR4vS6J4LCKQsPWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SK0b9x+qqqU2r5DoVhhYZrZr5CGzZmde7q475bNSotaHB4NTEi7BUl36S+Y8LyhgTGWWFu+lbmOurK9ZksU1gL30m/DHsp8gaG5exEHcWzHz3Zwm2KGgqPutXOso0t2niOyArREdXqakHdegriuWvNXI/2a/OCr+/At+grZx0tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tVMclxgS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8e5SpmuE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xmbbE1k0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Clky3rWb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tVMclxgS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8e5SpmuE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xmbbE1k0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Clky3rWb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F15037A4E9;
	Tue, 21 Jul 2026 12:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784635790;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BVztUU7Fpi1O73vtK/+Piw7sdAEwhaIljjrYb7JIeEc=;
	b=tVMclxgS5pz4auoTVeBdN08CmdDIKW8QzKbiyPJU0GTVS52gJbFxWUVhLo9UTcYBqAzTyy
	A6XmqoaXAr7N/letENc2hfJ1S/Y1/c7sfTHnDS+wk9I5RLU88i1eB2QZWOz6C/qde1qabQ
	AMSPCesgB2Hgoqxc9LVrIH8RT0H3E6Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784635790;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BVztUU7Fpi1O73vtK/+Piw7sdAEwhaIljjrYb7JIeEc=;
	b=8e5SpmuEBKWJp40HoyzwOnF40X+S2QXPaUPxRP9k/Jj1Oiorp2/cbz3uQ1A0lvpuchP0Qt
	BXv4vOC5XVDHjeAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784635789;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BVztUU7Fpi1O73vtK/+Piw7sdAEwhaIljjrYb7JIeEc=;
	b=xmbbE1k0V9Js6bfICm+FPTFm7V5c0ePW0QYtdWIJ9qiSX5P+8ICIGdn503qIh2MfaRMZMs
	HkoGNSzV4ODc1SOX4BvlPdUE6OP2fvUVFUa+cZWOo5L47DmLkTidGu1mGdiv1CUFku+Ddn
	BmeMPvzxAZyknIcFNXgdQu28ooaO1m4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784635789;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BVztUU7Fpi1O73vtK/+Piw7sdAEwhaIljjrYb7JIeEc=;
	b=Clky3rWb8RxSopjYyGiejbpGn3SoJfLQX9jpJL5lLlE15NxdFDvC52xXgSBDr/L79yzJoQ
	3KDKsj4Cbiuh1CCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2986779AA;
	Tue, 21 Jul 2026 12:09:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OTYBO4phX2ozOwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Jul 2026 12:09:46 +0000
Date: Tue, 21 Jul 2026 14:09:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] btrfs: compression: allocate buckets with workspace
Message-ID: <20260721120941.GI10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260703224557.488297-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703224557.488297-1-rosenp@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Fri, Jul 03, 2026 at 03:45:57PM -0700, Rosen Penev wrote:
> Convert 3 allocations into one. Simplifies code slightly by removing
> extra kfree calls.
> 
> SLUB merges same/similar sized structures for the named caches, so not
> a huge size concern:
> 
> grep 2112 /proc/slabinfo
> sighand_cache        593   1335   2112   15   8
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

With slightly updated changelog merged to for-next, thanks.
