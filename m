Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30B021FF49
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Jan 2026 02:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769739145; cv=none; b=T0Dv2SG7CS+8H8/z2RWlJ6T2U2zKdDpBCq0cZUDIqTbRm/VRvPyTy1HnwoLl+ldBEaGvGhaRGP+lTcFh/4hhLRjAN7ZDk7RSmRnvqQIKZkLDKTr8iummJ1jX4dgKaM9WZLQLAuT0AJwWACeNeZVDh79wQF4mXu94N2P//5272XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769739145; c=relaxed/simple;
	bh=EEXIUzGjRR99wNpywjy4hkDIlMbMWv9HAVQ/XvALG9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUbWYRLs3EFXSs9UU0VFn0s9BCC+FG7xgcQyGWIguMiyXbkFzDxQeOP4Bd/FgQ/qZvxO72VjIR7pqT08jv0H3j3OoXPgCmWLCG7mFfJG5IuykAgBQw0NUnpiwTO5Dw9oDXVUUPg14AanET17ePsvEGjXSFc8oObCDOcu8GebB08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NXGWnqX0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LG+QtwGI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NXGWnqX0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LG+QtwGI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NXGWnqX0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LG+QtwGI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NXGWnqX0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LG+QtwGI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 641BF34469;
	Fri, 30 Jan 2026 02:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769739141;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uQROE/xUldi7jhYa9hbopwo8SZPRCEH6YCW6ZPAPaxY=;
	b=NXGWnqX0aDbQBPY+AR775Hunw6iFIvt6ASDfXsdVQRlJREOlSDkPcJz40iGFQgwlZTSxTC
	uDBHL7Wm8bmPAgCpuqUrrr82jx7bqG2c7Ru8x8YHP7P1kyi3GDm10Hb0QjRDjsWvr+qe3S
	uqOqOsaK9aU39kmvU5Ke9aVeAZbZQYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769739141;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uQROE/xUldi7jhYa9hbopwo8SZPRCEH6YCW6ZPAPaxY=;
	b=LG+QtwGI6WRiw4K0Wc7O8DBFR2Vb8PViONVqxZAz+qq/eMoTghdKxXzrlYMVMm60l1si+e
	/NqVl8ADWNUIoyAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NXGWnqX0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LG+QtwGI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769739141;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uQROE/xUldi7jhYa9hbopwo8SZPRCEH6YCW6ZPAPaxY=;
	b=NXGWnqX0aDbQBPY+AR775Hunw6iFIvt6ASDfXsdVQRlJREOlSDkPcJz40iGFQgwlZTSxTC
	uDBHL7Wm8bmPAgCpuqUrrr82jx7bqG2c7Ru8x8YHP7P1kyi3GDm10Hb0QjRDjsWvr+qe3S
	uqOqOsaK9aU39kmvU5Ke9aVeAZbZQYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769739141;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uQROE/xUldi7jhYa9hbopwo8SZPRCEH6YCW6ZPAPaxY=;
	b=LG+QtwGI6WRiw4K0Wc7O8DBFR2Vb8PViONVqxZAz+qq/eMoTghdKxXzrlYMVMm60l1si+e
	/NqVl8ADWNUIoyAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 433A63EA61;
	Fri, 30 Jan 2026 02:12:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ztyiD4UTfGlOZQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 30 Jan 2026 02:12:21 +0000
Date: Fri, 30 Jan 2026 03:12:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 0/2] pending chunk allocation EEXIST fix
Message-ID: <20260130021216.GJ26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1769731508.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1769731508.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 641BF34469
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Thu, Jan 29, 2026 at 04:11:20PM -0800, Boris Burkov wrote:
> Fix a somewhat convoluted bug in chunk allocation with non consecutive
> pending extents. Also, add unit tests covering the new search functions
> and fix a build warning
> 
> Changelog:
> v4:
> - fold the build warning fix into the unit test patch
> - clean up subtle and not-so-subtle coding style issues I missed in the
>   AI generated test boilerplate.

Thanks, I did one more pass and added the patches to for-next.
