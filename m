Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9772367D9
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 02:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784775547; cv=none; b=F3623dO8+ljw5lYBu6DapvSJD8jZV0Gnk1w/srm0eKfCmLR03DbC5IxzeAYfKcb18HksQO7WEAUU3VPCdNhv3lEzpSHqPM6A/6/5xVg5icgb1YX1illUs7yEQKjTlHzc+wyRQ8OBwOCSQ2dibajPjfxz2OVfxNT2JEwBj1704LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784775547; c=relaxed/simple;
	bh=Yz2+/hWDXei4ZiKRMIMOi48+c71BDOUnkvaEEnlDbcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e4n/KW3IgkD+Iw3LKqWCK1ANxsr6dOeuL53FJymyputnVBnrPggu9wXrc2gCqYqyMqXW9Eu396h3No6pldSQWPGjCcGw3MNF01udu2liZv6AwF05fWKqvzsbPOHMdcmU0EB5cuIBOxQZutNZq/pn7ZjMm86XtkFjm0KCzox46bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Vr0pU+h/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+0XiIgmT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kftTRdRH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0GG9Lve/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Vr0pU+h/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+0XiIgmT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kftTRdRH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0GG9Lve/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8C2A3E38;
	Thu, 23 Jul 2026 02:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784775543;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SpfwQS2RDf5ECs9gPFhiiaQnYgWKsC+2O35gLnDfE3A=;
	b=Vr0pU+h/RWVDKOmq1H1x0yuQheI2xgP0rpsL9XsKF73TF/mVja3qp4F2lfVJW8OjEnpK+J
	1QB1B+D69xUHdHvVzC6KkzjuC5v2pD08Qqbog8fCleQ6FFrtt+obqDmzLbhAd3yHAxgEgg
	Xo8XfKyyNhGVbz1qPfDTj1Wx5GXtE+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784775543;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SpfwQS2RDf5ECs9gPFhiiaQnYgWKsC+2O35gLnDfE3A=;
	b=+0XiIgmTNHLS4LyU5rYIby45bA9L7qY7eYWZdNoeqIWbHp6+pfbepIgXyk7LJw3TorxbyR
	ObDBFj/C9/XpDCDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784775542;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SpfwQS2RDf5ECs9gPFhiiaQnYgWKsC+2O35gLnDfE3A=;
	b=kftTRdRHVsL/YGU8pR6H/5Ktz8+81OMKL779hD8LES9Gb+6qLRcQGm9ieXExCURQmhH4u9
	riXwCJJERDmf+hXuEe23iMwUP+5DZaL/7jkelEjBntvBQUhM96oAAtl6OLI7dWFXjO/3bM
	vY2s8pGZTJ+xZir20Ewk/0EugeGMo2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784775542;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SpfwQS2RDf5ECs9gPFhiiaQnYgWKsC+2O35gLnDfE3A=;
	b=0GG9Lve/+kXsi0r7yLn51dtasccpEPjH4cap3DE/ZCqVNztDIjq4MIgcgng4dNMZSgDcmO
	0smgOt85o3XDEdDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D4105779B5;
	Thu, 23 Jul 2026 02:59:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M+mYM3aDYWoTRQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 23 Jul 2026 02:59:02 +0000
Date: Thu, 23 Jul 2026 04:58:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 0/4] allocate extent_buffer GFP_NOFAIL with unlocked
 retry
Message-ID: <20260723025857.GO10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1784673567.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1784673567.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid]

On Tue, Jul 21, 2026 at 03:42:11PM -0700, Boris Burkov wrote:
> >From sampled fleet data measuring lock holders that go into direct
> reclaim with a waiter present when they eventually unlock, we have
> observed ~15% of those are btrfs extent_buffer allocations in
> btrfs_search_slot() done while holding btree locks. This is the single
> largest category. Additionally, a large source of hung_task timeouts is
> both btree waiters and direct reclaiming btree allocations, which
> further motivates the desire to drive down this source of stalls and
> contention.
> 
> The aim of this series is to allow us to allocate the extent_buffer,
> btrfs_folio_state, and the extent_buffer folios with GFP_NOWAIT then
> fallback with EAGAIN to outside the critical section to retry with
> GFP_NOFS | GFP_NOFAIL without any locks held.
> 
> This is analogous to how we must drop locks to read an extent_buffer and
> then EAGAIN.
> 
> The series does not manage to completely eliminate allocations from this
> lock holding path, as we also allocate inside xarray functions for the
> extent_buffer xarray and the btree_inode mapping xarray, the latter of
> which is done via filemap_add_folio() with no reserve type API. Luckily,
> those particular allocations are small cached slab allocations and have
> nearly no contribution to the production reclaim fueled contention.
> 
> Changelog:
> v2: 
> - rebase
> - dropped the inhibit array allocation patch

Reviewed-by: David Sterba <dsterba@suse.com>

The logic makes sense to avoid the stalls. There's no sashiko review
because the patches did not apply. You may want to resend a rebased
version to see if I have missed something, there are minor typos or
style things but that can be fixed during merge.
