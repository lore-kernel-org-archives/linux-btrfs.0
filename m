Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732E6347BAF
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 14:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784730098; cv=none; b=Aoo7WvPl2EUYHYQVUXXIpO368T5G8KSe8pCh2wR00ZVOpB6ZTBJehf5XBey2Y9eEwXvFWmhMfcN5RBV/Fu4I3gYATvdO/GRNHDrbm5k6tkF5KTZl1uWL0L+Eef5iNhH9kfVrGVVu6bKvP/laYbu6S7jjch5uYnysDvWCBxJIMWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784730098; c=relaxed/simple;
	bh=+oRcrmu0Gy6hOiu6KMA+PZfL5elq58XLCuL8aO6HROQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/+dA8CH2b6s+B7N1ccnf4MpACeSf/JlLWarxjGnl6QlGEKGFqMdR5d5UcvJfCSWk5TTPIhKwKfy76D3SNEVXbvkTZ5pGsg0/GMwV0Mm/ZWIt1i/nc5xSih7NsWJCsOtgDr6mX3KlYsBDbndHq4uKNjgpmQBSqRKSZNrGBygZzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QkJ3pFB7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PAp6MqWD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QkJ3pFB7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PAp6MqWD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QkJ3pFB7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PAp6MqWD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QkJ3pFB7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PAp6MqWD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 908C73E33;
	Wed, 22 Jul 2026 14:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784730095;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpQ+wnCieLdcpafcfqAb5igjL1lfPQ6SoI1kWRe/Ozs=;
	b=QkJ3pFB7y0B5UG4ul9cNAK1jeC7AwuJffFOLyzqUQaFgIMdiXm5e95QQC8JyeBXgh9Xvr8
	biomtT0l07eJnskfbGMIM2ql1ehWe9GSSBZmRi0EOi1DxsID1UNqpNg7IL17FYW6Bi/gI0
	3yogPOg0QKHFvz/Sb9iIYloaIuei/Rk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784730095;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpQ+wnCieLdcpafcfqAb5igjL1lfPQ6SoI1kWRe/Ozs=;
	b=PAp6MqWDgMuyKsHMbiCy4zzw8iYCUEron23P0nLvz63LVQ4oB+qMG5tccwoWjB7HV9Gy1S
	oyAhUTauuiREEXCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QkJ3pFB7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PAp6MqWD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784730095;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpQ+wnCieLdcpafcfqAb5igjL1lfPQ6SoI1kWRe/Ozs=;
	b=QkJ3pFB7y0B5UG4ul9cNAK1jeC7AwuJffFOLyzqUQaFgIMdiXm5e95QQC8JyeBXgh9Xvr8
	biomtT0l07eJnskfbGMIM2ql1ehWe9GSSBZmRi0EOi1DxsID1UNqpNg7IL17FYW6Bi/gI0
	3yogPOg0QKHFvz/Sb9iIYloaIuei/Rk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784730095;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpQ+wnCieLdcpafcfqAb5igjL1lfPQ6SoI1kWRe/Ozs=;
	b=PAp6MqWDgMuyKsHMbiCy4zzw8iYCUEron23P0nLvz63LVQ4oB+qMG5tccwoWjB7HV9Gy1S
	oyAhUTauuiREEXCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81D1E779B0;
	Wed, 22 Jul 2026 14:21:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fWF5H+/RYGqOYgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 22 Jul 2026 14:21:35 +0000
Date: Wed, 22 Jul 2026 16:21:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Mykola Lysenko <nickolay.lysenko@gmail.com>,
	linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com,
	dsterba@suse.com, wqu@suse.com, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: fix inverted bio-list check in scrub read
 assembly
Message-ID: <20260722142130.GN10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260716174511.8738-1-nickolay.lysenko@gmail.com>
 <79884bc0-1a2c-4e34-b8c7-75292f3466f6@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79884bc0-1a2c-4e34-b8c7-75292f3466f6@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.71
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 908C73E33
X-Spamd-Result: default: False [-2.71 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmx.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.com];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,fb.com,toxicpanda.com,suse.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:replyto,suse.cz:dkim,twin.jikos.cz:mid]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Fri, Jul 17, 2026 at 07:59:26AM +0930, Qu Wenruo wrote:
> > finish_parity_scrub() then compares the parity it computes from
> > the (cached, correct) data stripes against whatever happens to be in
> > the freshly allocated, uninitialized stripe pages:
> > 
> >    - if the garbage differs from the computed parity, the sector is
> >      "repaired" and written back -- accidentally producing the correct
> >      on-disk result;
> >    - if a recycled page happens to still hold the old (correct) parity
> >      content, the sector is deemed clean, dropped from dbitmap, and the
> >      actually-corrupt on-disk parity is left in place -- silently, with
> >      every scrub error counter reading zero.
> 
> Unfortunately that's by design, as scrub never reports P/Q corruptions 
> since there is no counter for them, and there is no space left for 
> expansion either.

Right, unfortunately scrub was not designed with future extensions of
the stats. We can add v2 of the scrub progress ioctl as this does the
reporting part, and not the main scrub ioctl.
