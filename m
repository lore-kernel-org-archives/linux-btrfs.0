Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B7330C16D
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 18:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783968616; cv=none; b=pJ0tTSk03BDxOpUmftuNaC+weD2Yafg5vvGX02su+uOEsd76Qhf11ysBkv5RIQbiGW7jXz68nbpJQKamTg5x4gUMNzM0JKcAfYvj6SRfx2nvkzslhcoggKtOEtJROBHUltasx0u9vs6IxWClMQPvqm2ofNqpb1ZvSog6RQnfXgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783968616; c=relaxed/simple;
	bh=xJ0sUqkAZiHUSswYqOHEV5C2G8GewaERBTnaiTYr5b0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LwJ/ylQ0/HrbGvqpGcWNNt1GGi0s+Lcw8z0i2vckhN8OX6baowl4jeOBU5D+tb/FfUotCBoxp9IYWEOE5I5bP7Duz7jMV/yBw1vGR3KpCiLRK+P/DVR/KMMxZRCp+6VpxlvWVS2nzpJsU2iwA6fPwUNHKZVG9PTYVHkAtmg5av0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OYZi/KTX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SBe69RYw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OYZi/KTX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SBe69RYw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OYZi/KTX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SBe69RYw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OYZi/KTX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SBe69RYw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EED303E41;
	Mon, 13 Jul 2026 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783968613;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dt/bpt71GjhxgX49mcz8fiqlgMEE1ZH6azIQPo17irQ=;
	b=OYZi/KTXkleH9Ntq37KkYAsURtXaeapwCy2SP4BvXv9nxsq7KqVVnhoMtsn8CluswlojoW
	osLcOXtjaqxofPAOnwZS9CJ6CFc2vMpZEqqCYsEJ5YdvZsQX9fFb14cev9PZ223bul+LyE
	tpfgY5acDxZ0XmQgo+4tbko58mDxLOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783968613;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dt/bpt71GjhxgX49mcz8fiqlgMEE1ZH6azIQPo17irQ=;
	b=SBe69RYwam8P9IB3lf+ho7dmi3GODZNg8nGFYgYbwayMbNLS/czc9AXr0y2YCqVR3HyfAP
	ngt2DfmAonGgS3Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="OYZi/KTX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SBe69RYw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783968613;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dt/bpt71GjhxgX49mcz8fiqlgMEE1ZH6azIQPo17irQ=;
	b=OYZi/KTXkleH9Ntq37KkYAsURtXaeapwCy2SP4BvXv9nxsq7KqVVnhoMtsn8CluswlojoW
	osLcOXtjaqxofPAOnwZS9CJ6CFc2vMpZEqqCYsEJ5YdvZsQX9fFb14cev9PZ223bul+LyE
	tpfgY5acDxZ0XmQgo+4tbko58mDxLOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783968613;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dt/bpt71GjhxgX49mcz8fiqlgMEE1ZH6azIQPo17irQ=;
	b=SBe69RYwam8P9IB3lf+ho7dmi3GODZNg8nGFYgYbwayMbNLS/czc9AXr0y2YCqVR3HyfAP
	ngt2DfmAonGgS3Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2884779AE;
	Mon, 13 Jul 2026 18:50:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8ywON2QzVWqiLAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Jul 2026 18:50:12 +0000
Date: Mon, 13 Jul 2026 20:50:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Sun YangKai <sunk67188@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Boris Burkov <boris@bur.io>
Subject: Re: [PATCH] btrfs: change block group reclaim_mark to bool
Message-ID: <20260713185007.GB8426@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260624040232.30420-1-sunk67188@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624040232.30420-1-sunk67188@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EED303E41
X-Spam-Score: -4.21

On Wed, Jun 24, 2026 at 12:02:27PM +0800, Sun YangKai wrote:
> The reclaim_mark field in struct btrfs_block_group was a u64 that was
> incremented when marking block groups for reclaim during sweeping, but
> the actual counter value was never used - only the zero/non-zero state
> mattered for determining if a block group needed reclaim.
> 
> Convert it to a bool to properly reflect its usage and reduce memory
> footprint by 8 bytes. Update assignments to use true/false instead of
> increment and zero.
> 
> Signed-off-by: Sun YangKai <sunk67188@gmail.com>

Added to for-next, with updated comment. Thanks.
