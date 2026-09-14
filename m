Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0058948E0DB
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789403996; cv=none; b=W15MUMHJ98Bg5nW8EWaAdqjEiaiBJiXKszrW2zjLW9B1RY1jJKpO+7GZRcKXGOP9sW3R7DkiNBbr0V0YXEQmcOfLT1Tf9j1fNtqr9MFZeUy71tYvbn88ZPQFnw/6U/6XdW5x25zB5ETtibFv7BFTTMaLMZjXVoJn8Y+Rmg7sRFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789403996; c=relaxed/simple;
	bh=+2BIXuDLmDvgSbrySZ4ssDHkAb3UtHs/SlbZyXg7mPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CD74zekraDJK0wlw/ay6FJCIohLt90eZ3dbCRxG8i/NX/uF9jsBu54q0WLLkI0Ut5o6h2q7qupVpCIgt+3Yavxy/xD8dQafvPpyyDolRHPOL47CGqaou7wqYbU5URB++EgCXzU0fkvvEnzdNeAGgIQinPp818xBx47w8BItWPk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=huIeP8U/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=h9AoUHy+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OCXxZLqv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jgjycC8R; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="huIeP8U/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="h9AoUHy+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OCXxZLqv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jgjycC8R"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EE071FAA3;
	Mon, 14 Sep 2026 16:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789403971;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fUIsfdFSIQzjITF1zs+UjXNsHK/xBrZZGj3oxfGXqcg=;
	b=huIeP8U//rc0YG0DG5VtAKFFrNWp6PmUxW7lQnxMpAmMHc+X9pbfWHIL7YsviLtozW2qTk
	onQxOKHqksI5FXCB8XylKSYeXy7PjeAPyTsxwAtLlx26h+mt1W+WNBHqLUVT6Zl1m6RepD
	97p87FwrGwBHtat2gkTXNEy0lDrvdHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789403971;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fUIsfdFSIQzjITF1zs+UjXNsHK/xBrZZGj3oxfGXqcg=;
	b=h9AoUHy+2jnHj5+m+h4rwll8Fn14Y/05jSv8wMs/qP1pjXIEFOd8Uv6mdMMAuNEWO59bhN
	Nhowwj9kkfoOPkDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OCXxZLqv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jgjycC8R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789403967;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fUIsfdFSIQzjITF1zs+UjXNsHK/xBrZZGj3oxfGXqcg=;
	b=OCXxZLqvlzY4mop0+JjpzcVkWFDDm1QXmqTyDIP5Oa2SjlfdjDd8MVkNhiNDhrh6dOTWIk
	83sN3ERdd3ZEOcFlMAM73WRSqe5/YCw4neO2QAh2SjmfKD2S+VbQVzjTSQNomSKhP8+nw3
	DyXbpbsVvFk254L9xQr74SYej53K+0s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789403967;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fUIsfdFSIQzjITF1zs+UjXNsHK/xBrZZGj3oxfGXqcg=;
	b=jgjycC8RjOIvf1hAJo8wwmBYYMhL2uWaS4nA0Ei1+ts4xt2c9oqJ6EGmF4VuSzMOlLtn4h
	krccUa24iovIcWBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3935B13515;
	Mon, 14 Sep 2026 16:39:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oVm8DT8jqGqsNgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 16:39:27 +0000
Date: Mon, 14 Sep 2026 18:39:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Suveer Jain <asj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, dsterba@suse.cz,
	linux-btrfs@vger.kernel.org, thiago.macieira@intel.com,
	dave.hansen@intel.com
Subject: Re: [PATCH] btrfs: derive f_fsid with dev_t only when temp_fsid is
 active
Message-ID: <20260914163925.GL54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org>
 <0691a903-cc82-4ad7-8264-cddbf146d00e@kernel.org>
 <91E0EA5B-BFD2-4B8A-8408-4F561D5E0777@infradead.org>
 <c04f73b1-cf55-40ef-bb47-d518603bcd8c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c04f73b1-cf55-40ef-bb47-d518603bcd8c@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 6EE071FAA3
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Mon, Sep 14, 2026 at 04:28:25PM +0800, Anand Suveer Jain wrote:
> 
> 
> >> . For stable kernels, this flag will keep the new f_fsid derivation
> >> disabled by default.
> 
> 
> > No. That still gives you a broken fsid on upgrading to the next major kernel, doesn't it?
> 
> Upgrading to a _major_ kernel would require an extra step to re-encrypt
> with the new FSID _for some configs_.
> A one-time operational overhead.

It's fairly common to boot different kernel versions on the same system,
so the upgrade is perhaps installing it but the assumptions about what's
working do not change. I have mixed results upgrading kernel and Nvidia
drivers and imagining that I'd have to re-encrypt anything just between
reboots sounds like usability antipattern.

> > Maybe a new flag on the file system itself to indicate that its
> > stable FSID is computed using the new scheme.
> 
> A mkfs-time or runtime switch, something like:
>   /sys/fs/btrfs/<UUID>/enable_collision_free_fsid
> (just as an example) is an option.

Even as a conceptual idea this does not improve things, users do not
care about this level of detail. We already have enough problems
defining correct behaviour with fsid, metadata uuid in combination with
the temp_fsid and seeding.
