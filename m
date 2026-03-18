Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269623ACEFB
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 11:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773831768; cv=none; b=eua3S6xjngpuFcI4YW7UkNW2EJUpYheqREJKL2MJczxaC9if/C44WboHGyENtJyvINjDr4rjsmH5RpCNi2HbDKe5WjVJiPhP3Oy3OblnGZgC26B2W31EhqThZBjAqF8137THcN37V0uoK+NOrQQme+Dx7nlgIjy0jx0K9H7DzhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773831768; c=relaxed/simple;
	bh=A+lYqfdXUpzBKuiShoZDd3IJlRhWitB2k3mo0wHefgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=riWrU0HSQ9ox0fA8T1EgBNJ/vsj5iXc4T04nUVKQfOL/7ragj7vruTAio7DejQ0br5VqZKAfrHFH2QMR6dE/PHJjWe5tKbcBTDO/eU3ctCKi5mqxTHVz1ZmId6le1ZI88uk6TDdlr/kt74Od4YmPzk0bBMBl8dpV+jFpJK0JqHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hnTN08pZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NSJbZD8+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lsnDj4jJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dv1PLoFl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hnTN08pZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NSJbZD8+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lsnDj4jJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dv1PLoFl"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3131D5BD54;
	Wed, 18 Mar 2026 11:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773831764;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v4yCU5BVP04yN6ywWg7CBVeBm7eqp2FKJ0YWf1Dca1s=;
	b=hnTN08pZChAUxRuWA1qXFzBhOaZipvRJeBqCM7gi8HgjmvJzzGQ8WtiPjNsqkRO8WlLDU7
	k2HaEX0OO+d4pwmD/ag2rc1jxp69nv41Z11lHyemt7j0AfurWypa9HGQ6Nr/4JToDXqpkj
	rTqHhz0Rp9ZDW6phaNJhw7n+mOtXqhU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773831764;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v4yCU5BVP04yN6ywWg7CBVeBm7eqp2FKJ0YWf1Dca1s=;
	b=NSJbZD8+zPRrvee1vVIfKVS+FLEBK0/pfgVITXKqA159KLbSjMgEF6OYmksZXpKnM7dmYQ
	k1pu275Va+kkxDAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773831763;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v4yCU5BVP04yN6ywWg7CBVeBm7eqp2FKJ0YWf1Dca1s=;
	b=lsnDj4jJCQlrN7LNDK8B8unotbswf5JPJV1Ya7zGv9COSlr528J5ZDTaUSwS83R9+MhV7W
	Zhf6vnmeNRJU/yOyZ3Vdqg1VX05uov+OePiQGW964dticrJ31h3nxociDB3hJtVf7bVAaU
	rYlQS2d9NSNr1DA66kQ/lMhjngGegRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773831763;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v4yCU5BVP04yN6ywWg7CBVeBm7eqp2FKJ0YWf1Dca1s=;
	b=dv1PLoFlDawPN0tOju2Ih6sj0qqFRxROIbdqG16srOPg4c4nwv/TnVVJnZNvjJQHFcjzjt
	Qrg/asvgWLmbgaDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 197A34273B;
	Wed, 18 Mar 2026 11:02:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q6gQBlOGumkXDAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 18 Mar 2026 11:02:43 +0000
Date: Wed, 18 Mar 2026 12:02:41 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/11] btrfs: some optimizations and cleanups for io trees
Message-ID: <20260318110241.GC5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1773676775.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1773676775.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Mon, Mar 16, 2026 at 04:14:03PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> An assorted set of optimizations and cleanups for io trees. The last patch
> contains some benchmark results after applying the whole patchset.
> 
> Filipe Manana (11):
>   btrfs: optimize clearing all bits from the last extent record in an io tree
>   btrfs: turn extent_io_tree_panic() into a macro for better error reporting
>   btrfs: tag as unlikely branches that call extent_io_tree_panic()
>   btrfs: make add_extent_changeset() only return errors or success
>   btrfs: use extent_io_tree_panic() instead of BUG_ON()
>   btrfs: change last argument of add_extent_changeset() to boolean
>   btrfs: remove wake parameter from clear_state_bit()
>   btrfs: avoid unnecessary wake ups on io trees when there are no waiters
>   btrfs: free cached state outside critical section in wait_extent_bit()
>   btrfs: panic instead of warn when splitting extent state not in the tree
>   btrfs: optimize clearing all bits from first extent record in an io tree

Reviewed-by: David Sterba <dsterba@suse.com>
