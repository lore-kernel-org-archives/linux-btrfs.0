Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68F234F483
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784729105; cv=none; b=INN2FnWLHSv+zmXV8R2jOv3W8MXvVopYHRTPP+R5ZkiVwZdCoM55nV7f3PRsCy1KgPa0hN1cVgT+myZPXIDdoShmEXEwxmiPNA1F2oFBrTblS0hlWGJvlduAcxzis9z5T5WNPwTlbnqK7msHi/dbCawa10jlqH8alhBUMTfCz1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784729105; c=relaxed/simple;
	bh=+ZPUqgOukY17U9rfjXRV7uoJ777AD57ILPbL/Remsag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBUunUxSsQshGJmcUS6o7FBH6FBeoRfMFpfu607PPrM9ccOOqKTycm3tP4+yyYu/anOojuFJPovg5aRFDnKYulYmyl1X+mVgSRiLW27SRvhg33+jpRJkTtRluKkgIVhtrFy8vpIpW8EwYxOZZhAzWAKlbZW2C6Mbhh9YiK1uWh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AM1gBQFI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L/+vx3nn; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AM1gBQFI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L/+vx3nn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AM1gBQFI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L/+vx3nn";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AM1gBQFI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L/+vx3nn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B1A737AB0F;
	Wed, 22 Jul 2026 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784729101;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a6gO9FUqNdk/KyG/aqTxMiC8H7lJYNx4JLBSqmxIud0=;
	b=AM1gBQFIip7x8p6dgjm9IT5VrnTeIZw98Z11r4IzDEIoF1OhPuBWmc1GtmkgR0uWy1Rg/R
	zhkPeFe5hrEc4NgqTfmP4ciGqfP+vv4+zR2v74qqgd9T6GIC3X6w6Uhvy3zX4uWARIpCtP
	x50rTNtcTBwVuH7oZZ5JKU9yWDfafmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784729101;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a6gO9FUqNdk/KyG/aqTxMiC8H7lJYNx4JLBSqmxIud0=;
	b=L/+vx3nnwavu6ekl3v6oWX5U5K0TnyfWXX8Wve7mN76G/M4niHF8anTGiPZ6y1AwkmVqXJ
	0GxIs9ndxg3TaRAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AM1gBQFI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="L/+vx3nn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784729101;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a6gO9FUqNdk/KyG/aqTxMiC8H7lJYNx4JLBSqmxIud0=;
	b=AM1gBQFIip7x8p6dgjm9IT5VrnTeIZw98Z11r4IzDEIoF1OhPuBWmc1GtmkgR0uWy1Rg/R
	zhkPeFe5hrEc4NgqTfmP4ciGqfP+vv4+zR2v74qqgd9T6GIC3X6w6Uhvy3zX4uWARIpCtP
	x50rTNtcTBwVuH7oZZ5JKU9yWDfafmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784729101;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a6gO9FUqNdk/KyG/aqTxMiC8H7lJYNx4JLBSqmxIud0=;
	b=L/+vx3nnwavu6ekl3v6oWX5U5K0TnyfWXX8Wve7mN76G/M4niHF8anTGiPZ6y1AwkmVqXJ
	0GxIs9ndxg3TaRAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E1EC779B0;
	Wed, 22 Jul 2026 14:05:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a4RrJg3OYGq5UgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 22 Jul 2026 14:05:01 +0000
Date: Wed, 22 Jul 2026 16:04:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: use %pe for error code output
Message-ID: <20260722140456.GL10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4ada48c6c1ae4978d6e6be44008b0060a7edaeae.1784705640.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ada48c6c1ae4978d6e6be44008b0060a7edaeae.1784705640.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B1A737AB0F
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Wed, Jul 22, 2026 at 05:04:07PM +0930, Qu Wenruo wrote:
> During an interrupted mount, I got the following messages:
> 
>  workqueue: Failed to create a rescuer kthread for wq "btrfs-qgroup-rescan": -EINTR
>  BTRFS error (device dm-3): open_ctree failed: -12
> 
> Workqueue code is outputting a human readable error string, meanwhile
> we're still using a numeric error code.
> 
> So follow the workqueue code to use "%pe" format, which will
> automatically convert an error pointer to the human readable string.
> 
> However this is a minor pitfall, if the return value is not an error
> code, e.g. a positive number, "%pe" with "ERR_PTR(ret)" will output the
> pointer as a hash value, e.g.:
> 
>  ret=1 %pe out=0000000019414716
>  ret=-22 %pe out=-EINVAL
> 
> So we should not use this "%pe" output for callsites that are known to
> return positive values.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

We have btrfs_decode_error() with selected errors so the %pe is better
because it covers more of them. The good thing about our helper is that
we can adjust the wording, namely for EUCLEAN. This is "Structure needs
cleaning" and is quite confusing. The EFSCORRUPTED error code is only
alias of the value, otherwise the string is unchanged.
