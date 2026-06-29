Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815C3358360
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 22:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782771968; cv=none; b=O8iIz8uhp7QwAzhxf5TIkMh9QAkl4dinyEIaYgDJ5HyBLrv46NhlVY4dqwQaJdll7KAR4/9X/ZA95WDtZOFCXZchj29kBomRHaMfNIKd0U9gwoTZfEd01JaAGRtFU/j0NNmzqFNRtrfDUOtumJjlRbZ73kNmCd9ZUrMaXZyKp7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782771968; c=relaxed/simple;
	bh=+AgsFPAkXIscn9GVUAcp5lKyD53+QaJs/gPi/KN97ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1/LihYWET9YhBD5qxYDmWEe0DSfZ/OPiD9+VlstDnRALhYadw6kJt0T2mZ0hvy00/8vA3LbnFQeRc2X8BUkkBKGbyW0un+2pURCfgjBsXaSu6IXPh/yoZRMOUvjST4qsC4US4NSfjDWW9BMqJnbLCtx4rPLSC5gU1CgWCbbpqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qvfW1qia; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YjNwr/5i; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qvfW1qia; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YjNwr/5i; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qvfW1qia";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YjNwr/5i";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qvfW1qia";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YjNwr/5i"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 16857732EB;
	Mon, 29 Jun 2026 22:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782771965;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BpoGAzmVYCUn8LD3p4HT8NPbbSSUhRWnXFqvVxExjPA=;
	b=qvfW1qiaHklFMLbIYcoeKjE4koo5Uo71jtCL1Qe2vtzwkpZRMv//CF+D2jhqDV4sBmGgUc
	u8M3FyPY25WNc2xLc1u2AQKw4nMVMguzGO+L5/gv9KdQxira1V3bvjMkFuWTLEfaiFEQo6
	e9+nYHPOQ+Fq4UcjnLrTArQSSI/BesI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782771965;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BpoGAzmVYCUn8LD3p4HT8NPbbSSUhRWnXFqvVxExjPA=;
	b=YjNwr/5ilxEJKOHjSZzwoNG+U5gQ16R47YrmWqCJ1rIS2gorFdOnzneuK2A2G+xG8rZfCo
	YOv705Cx+sF9H1BQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qvfW1qia;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="YjNwr/5i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782771965;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BpoGAzmVYCUn8LD3p4HT8NPbbSSUhRWnXFqvVxExjPA=;
	b=qvfW1qiaHklFMLbIYcoeKjE4koo5Uo71jtCL1Qe2vtzwkpZRMv//CF+D2jhqDV4sBmGgUc
	u8M3FyPY25WNc2xLc1u2AQKw4nMVMguzGO+L5/gv9KdQxira1V3bvjMkFuWTLEfaiFEQo6
	e9+nYHPOQ+Fq4UcjnLrTArQSSI/BesI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782771965;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BpoGAzmVYCUn8LD3p4HT8NPbbSSUhRWnXFqvVxExjPA=;
	b=YjNwr/5ilxEJKOHjSZzwoNG+U5gQ16R47YrmWqCJ1rIS2gorFdOnzneuK2A2G+xG8rZfCo
	YOv705Cx+sF9H1BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08C3A779A8;
	Mon, 29 Jun 2026 22:26:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vttnAf3wQmoOWAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 29 Jun 2026 22:26:05 +0000
Date: Tue, 30 Jun 2026 00:25:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use correct type for sectorsize/nodesize/blocksize
Message-ID: <20260629222559.GA2018520@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <f12af6d49a5b04bd7ff537bcdabee176b54416f6.1782274357.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f12af6d49a5b04bd7ff537bcdabee176b54416f6.1782274357.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 16857732EB
X-Spam-Score: -4.21

On Wed, Jun 24, 2026 at 01:42:42PM +0930, Qu Wenruo wrote:
> Btrfs' nodesize and sectorsize are all u32 values, there is no need to
> use u64 for local usage.
> 
> Furthermore some call sites also use "blocksize" or "bs" for sectorsize,
> also change them to use the minimal type u32 instead.
> 
> Since we're here, also reorder those local variables so that they won't
> cause extra holes for stack memory, and consitify the
> sectorsize/nodesize/blocksize/bs usage.

The placement of local variables on stack may be different from the
order in the source file (unlike for structures). Some variables are in
registers and the same memory can be reused for multiple variables if
their live range does not overlap. We don't need to optimize that.
