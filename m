Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD130246BCD
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 16:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764189; cv=none; b=cnDtk/77C8hTHX+X0MtnlUWjcq5bUf7HPtblitP6bkbyNByR5Z+da0G6r1owKI8D5Z1UyhnwZWVaGBnfucNdZSKnNDmHa0ATmrYQBfY9MTOek9HNxmFMrEIVfFA47oAZMC3x4NIaNhfqYiB217LXhawPv/GhxTZ6ByHtM6DpGzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764189; c=relaxed/simple;
	bh=/tQ1G1SaC4xfIAUc+Yxi1bNz66aI67bDRhRwiY9ObI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUOMpRFhQGQOFbOxS8WhNXTMpM1VIJo/IO+13BJipRov9f3K5mmyyG/8p6lapIF+EgYRtKvN1K6P9tmNeBQjRAYtO3ygBBsJqXwOL5gtX4DZ5wNy8XX7X6nURdPlUY1wSB2fVf7NIrXjxXQ3LuvzoeNE7P18p7Nb5jZKRiM4uSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CJ3fIN3Z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5wFSpa+g; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=14efWrH2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JBX+5Qux; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CJ3fIN3Z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5wFSpa+g";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="14efWrH2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JBX+5Qux"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 25C2C5BD36;
	Tue, 17 Mar 2026 16:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773764186;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kAkyk/XM1/frr1lwwaLqHnZ5vT3yWWLOONtEhEA4NPM=;
	b=CJ3fIN3Zj+kK1LmfokVJDjpGGDbOopOQ5Du/212j01c0gzI5UG2ZCPZkOcjymdwArod43V
	5EMSEcZyZ3w8kvDQWOr3k0MfgvcCyb3r5H11kko3cPbpu0pX7EyPG5x0oYT6MXpj8E6dZU
	GtJNt1Dm3eooLCuwBW/UgOhw7XJf/xI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773764186;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kAkyk/XM1/frr1lwwaLqHnZ5vT3yWWLOONtEhEA4NPM=;
	b=5wFSpa+gp+09kG+XFnHst3eOIPasZ0h1ygZoTqpOAhyPVsTcNziu8gLjnzdZTEzo/s+SW7
	99qIc2TmSRuUI3AQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773764185;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kAkyk/XM1/frr1lwwaLqHnZ5vT3yWWLOONtEhEA4NPM=;
	b=14efWrH2h1c2rZJYY7QYUSg5Kzq9vivHYX/yMNzTd0eEjTexUoYcyaeZ+82F2Ac9Wn/8HE
	nqDgzsXjYHhe7Uz90iNTv+XY012OJ6c1kTlzr5Smwm6aHeCGPag1GuVvn8Nwg/zQqTrz+6
	Ec5dkay4T0532jGwEjJn4v73umvTrmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773764185;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kAkyk/XM1/frr1lwwaLqHnZ5vT3yWWLOONtEhEA4NPM=;
	b=JBX+5QuxLzedBOHXd+/SajOf471SOdpLjBheKsMqZKFyG8ZVnlJhtdOFzzyjmlheDDd2lH
	vV+ScGzIgR583EDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D1AB4273B;
	Tue, 17 Mar 2026 16:16:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 83YFA1l+uWkccgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 17 Mar 2026 16:16:25 +0000
Date: Tue, 17 Mar 2026 17:16:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, sbehrens@giantdisaster.de
Subject: Re: [PATCH] btrfs: btrfs_log_dev_io_error() on all bio errors
Message-ID: <20260317161623.GT5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d2edb3eda4038ef4f2dbd7b76a33a84e3b4ba32c.1773429838.git.boris@bur.io>
 <20260316162020.GA21157@lst.de>
 <20260316162951.GA1074179@zen.localdomain>
 <20260317135942.GA2670@lst.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317135942.GA2670@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Tue, Mar 17, 2026 at 02:59:42PM +0100, Christoph Hellwig wrote:
> On Mon, Mar 16, 2026 at 09:29:51AM -0700, Boris Burkov wrote:
> > Is there a reason not to properly log the errors we are definitely
> > already seeing?
> 
> For example if you get a BLK_STS_AGAIN which is not actually an
> error.
> 
> > Put another way, if we are in a situation with technical debt, which is
> > what I think you are saying, then I would rather have more visibility
> > rather than less.
> 
> Can you give me a week to give this thing a stab?  If not please just
> add STS_MEDIUM to the whitelist for now.

Boris has some trouble sending mail, I'm replying on his behalf. The
patch has been removed from for-next and we'll wait for the BLK_STS_*
changes.
