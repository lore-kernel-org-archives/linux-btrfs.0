Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A4B3ACA62
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 21:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774041899; cv=none; b=OUwAO+Es9OE3xoTRALF2LXS/Sfu/ZD1kg0GtEvTrGP671mN0f7nxaOFAxNepXj++61rguM3oIrYJA181BUKohS729lyY+0bg4JRpl0FrUC7SA0IBeByRHkuzhKwOQhPZIVqsWZk7z3lm8Xqqwh49975cuFgGc5hKQt/+zqnl4rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774041899; c=relaxed/simple;
	bh=dh2XI7grnQvdLjasHy028jiSSez8QznvnxiFWMMODps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QxN9Vc2QKKU0TJGeqv+eEFuVAwxc/6fDMph3HtzG8TILz9O2/dcZsoB7fr6YbZojOQ5ZeW/FaY1S9YMSRorhyiUlF1BE1k0mVyoL5Q0UUehRGydjjRfm3E9Ih56lAovMWNKBMN9aZfnt8P2ihkw83NSJmPMGFJm78PCd/asehWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=abGDScwC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WXHGAF4/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bK/7Q6JN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YpjcLGha; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="abGDScwC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WXHGAF4/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bK/7Q6JN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YpjcLGha"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B17A5BE37;
	Fri, 20 Mar 2026 21:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774041892;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O+leESMfL9OkPb0pg/3I2PIPEof3VC4snffRFSEtiVo=;
	b=abGDScwC8ThVT8E7N6bj0ImlB4/iIIA7T/SJkyRoicKL1M6vnunVsgCJniFcUAGEatLn79
	NPXYPIK46NKvrCrwef8wx+4Bb7xzjU8dkxPVTejwmQvJRjGoEc4ea/cxe3xGM2viHX3FzS
	mKs4negJ77/LWfJuS22zEzIy5LJFevA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774041892;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O+leESMfL9OkPb0pg/3I2PIPEof3VC4snffRFSEtiVo=;
	b=WXHGAF4/jEHoR53wq9LQnvgdauIYZPy6dDdudEIgyTcvjrwEjfaMbI9tmSAlMWUVYvdvq5
	TQ9t6TUiBxIiOxDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774041891;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O+leESMfL9OkPb0pg/3I2PIPEof3VC4snffRFSEtiVo=;
	b=bK/7Q6JNFS8vPmAYI+2wBXB1tE6qSSFHt7tN+iTOK54jCneI+/aL0TsatDVPPCSuOSQnel
	bWZdTI6rc5UXeXT95a6iewcLtQ3ltLdN1mRKCjj0KA+yi9kihRSeljUzO2vJSVYtEziI4y
	oMCB9V801Z20IuG48LZim9SqPT1eid8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774041891;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O+leESMfL9OkPb0pg/3I2PIPEof3VC4snffRFSEtiVo=;
	b=YpjcLGhaaP/SktzlajrY5+fyRaBjZLQqcbuyDUd6gwNq5szmDabwpkelB3GY2k6Pb1dRY9
	rtJMbmyv+hHsdSAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43437429E6;
	Fri, 20 Mar 2026 21:24:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xik7ECO7vWnpYgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 20 Mar 2026 21:24:51 +0000
Date: Fri, 20 Mar 2026 22:24:35 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: avoid taking the device_list_mutex in
 btrfs_run_dev_stats()
Message-ID: <20260320212435.GG5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <bf7c901abdf8279207fed149f76ce0ccc4718159.1773840032.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf7c901abdf8279207fed149f76ce0ccc4718159.1773840032.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:replyto]
X-Spam-Flag: NO

On Wed, Mar 18, 2026 at 01:39:51PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> btrfs_run_dev_stats() is called during the critical section of a
> transaction commit and it takes the device_list_mutex, which is also
> acquired by fitrim, which does discard operations while holding that
> mutex. Most of the time, if we are on a healthy filesystem, we don't have
> new stat updates to persist in the device tree, so blocking on the
> device_list_mutex is just wasting time and making any tasks that need to
> start a new transaction wait longer that necessary.
> 
> Since the device list is RCU safe/protected, make btrfs_run_dev_stats()
> do an initial check for device stat updates using RCU and quit without
> taking the device_list_mutex in case there are no new device stats that
> need to be persisted in the device tree.
> 
> Also note that adding/removing devices also requires starting a
> transaction, and since btrfs_run_dev_stats() is called from the critical
> section of a transaction commit, no one can be concurrently adding or
> removing a device while btrfs_run_dev_stats() is called.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
