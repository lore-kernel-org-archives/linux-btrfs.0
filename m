Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9682857C7
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782315202; cv=none; b=fv4aEUGQfCLudaz2fPj4HfeHnPGZVVoTeJ3Y+U+gDauUcVj8iu61cRX/JpVowow/3JG3eWiv7kHpRYDGTk/wuKJCFKcydhaJETM6Tzi0LpfuHcgpxJjz9p93MccNosGDaceirpH0cqSDKKkPIizKid7g3p1OD30zJQZCd9TBTAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782315202; c=relaxed/simple;
	bh=yXfkXzIZ0GZZdMpLqUJzIB3dE94eT6o4jTSfn3baf9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/HYQ284FOnF9uN/86VwIqmg9oA/kvgKG3Sfd/8y0y1GyACT/1Pr2t/OmtYi4qYeVV8ijrxI3LxLqsSP+tSpxcJaCBMhmcwImp9Tsuwec7zBj+ySOw9Qt9FMrpUVEc5oOJOULcN8kx4hhvJL89E/LegsuGsSQNwFfkElL/Jg3Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yIQGitou; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=d/CE+oB/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yIQGitou; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=d/CE+oB/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yIQGitou";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="d/CE+oB/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yIQGitou";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="d/CE+oB/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3F4F26DB61;
	Wed, 24 Jun 2026 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782315199;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MSE4rkk2Upul+S7U9xRhL47pZrwLb+quP4b+I+wl5iE=;
	b=yIQGitou4Df4FFuuW0bO2OkqoGq5fC8EZ3U5Yp3XbhhKeC4/cfngKQsqcLTnjF1jrLfu+n
	IJdva6jI4ZwSYCOgwzz0xDfxOs62Arsg+FY4JJgBLFPxcN4bsQjmujxhYHk8UoqqbKpRS5
	GhvAbNKSNcdnjYezkk/mpz/duTh4qR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782315199;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MSE4rkk2Upul+S7U9xRhL47pZrwLb+quP4b+I+wl5iE=;
	b=d/CE+oB/j21oQOaarg8mi9Z2rPpYzhuaIa6JDLvX8rKOT0ENRUWIBOg3z+Pb1K6x80RaIC
	55TSomJMZs3o+sCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yIQGitou;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="d/CE+oB/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782315199;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MSE4rkk2Upul+S7U9xRhL47pZrwLb+quP4b+I+wl5iE=;
	b=yIQGitou4Df4FFuuW0bO2OkqoGq5fC8EZ3U5Yp3XbhhKeC4/cfngKQsqcLTnjF1jrLfu+n
	IJdva6jI4ZwSYCOgwzz0xDfxOs62Arsg+FY4JJgBLFPxcN4bsQjmujxhYHk8UoqqbKpRS5
	GhvAbNKSNcdnjYezkk/mpz/duTh4qR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782315199;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MSE4rkk2Upul+S7U9xRhL47pZrwLb+quP4b+I+wl5iE=;
	b=d/CE+oB/j21oQOaarg8mi9Z2rPpYzhuaIa6JDLvX8rKOT0ENRUWIBOg3z+Pb1K6x80RaIC
	55TSomJMZs3o+sCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 26913779A8;
	Wed, 24 Jun 2026 15:33:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OoYrCb/4O2o/BAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 24 Jun 2026 15:33:19 +0000
Date: Wed, 24 Jun 2026 17:33:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove btrfs_fs_info::stripesize
Message-ID: <20260624153309.GB150664@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8a10be3992b88b143585dd1736998b4479c48b46.1782275006.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a10be3992b88b143585dd1736998b4479c48b46.1782275006.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 3F4F26DB61
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:dkim,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Wed, Jun 24, 2026 at 01:53:28PM +0930, Qu Wenruo wrote:
> Btrfs does not support variable stripe length yet, all RAID0/5/6/10
> chunks have the fixed stripe length 64K for now.

The question is if the 'for now' will turn into configurable stripe size
in the future. This was the plan, but long time ago. I think we can
remove it anyway, the code is no-op and adding proper support would need
more changes that just that.

> Furthermore, btrfs_fs_info::stripesize is not the real chunk stripe
> length, it's always the same value as sectorsize.
> 
> Remove btrfs_fs_info::stripesize, and for the only callsite utilizing
> that member, replace it with fs_info->sectorsize instead.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4757,7 +4757,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
>  
>  		/* Checks */
>  		ffe_ctl->search_start = round_up(ffe_ctl->found_offset,
> -						 fs_info->stripesize);
> +						 fs_info->sectorsize);

This seems to be the only relevant use in case the stripe size would not
be equal to sector size.
