Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434282F83CB
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 16:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764514; cv=none; b=QfjMhpT4Wb2VQZwZjqSB3KzSNMf0jadXcMkH7HKZbfgjgv7NYrUE14Bwmpb1DVAQEeCAnFbLuCba5tWQpwM3fPH7k3MHkVqGD+5QIdW3FV1ZGe8J/iw8kmYCnqBfliAbEQwvoU8jFnE1M0VHhznX/e0Bv0igjjdW9nzL/UFFhlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764514; c=relaxed/simple;
	bh=nIg9eMz13GfnQ51ZB43G7hMswVw9hwYGm1RvXlGFVEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2Q7q4KQEJHV1oMoEILUcjkxDOL1Ae7XVBZn9GZDD6y00QGa3k+ap7fkX4oyDZe1D9DJv/sTP9bX4VRM3MIrbShpS3bAuvmek2aUweROUMZN9RgFzQwlIqY+A+k6JfG8C5EDByEQFq+mKI50KVpVyvMTncfgE4RT7OxXktCOAlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jb5C5SAL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uVdv8Lm9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J3tZF/Lw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/gwmwDNy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jb5C5SAL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uVdv8Lm9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J3tZF/Lw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/gwmwDNy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 699184D336;
	Tue, 17 Mar 2026 16:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773764511;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K2DqWhzmSpIc3a/LBfMfz1g8pajA2LxzPO+dj6Mg0/s=;
	b=Jb5C5SALaqNf/pjXGXcsBInFeNpeG+B8DBTO8f069jtmqXOExIF/trVdsHU9upyb7sG4fM
	94+p2dYrbX+2YcaQTFBtAXJFdPDCOIdGfFUK0kuSZbG3f69Z98mYv6Lu/DCjNFfaJVkyNj
	aKkyNfMcO5LsqnAhgNRx2TuAL9PFiEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773764511;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K2DqWhzmSpIc3a/LBfMfz1g8pajA2LxzPO+dj6Mg0/s=;
	b=uVdv8Lm9BNhAe7YjiGLvH43ScxPNH/hP5I3FIiCMKeUkk175u6Y7g/qyjNkoW6ezl84LoZ
	wNjciUP5PqR7D5Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="J3tZF/Lw";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/gwmwDNy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773764510;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K2DqWhzmSpIc3a/LBfMfz1g8pajA2LxzPO+dj6Mg0/s=;
	b=J3tZF/Lw23ZRaECHPW6TEkyWKSRqUROhw4aeI7fnmg6dV+8Sr6sWCuO79wN2C2EGTNwbgM
	5lldOI7eRDZ8j9BL52TK1Q94n5XezQnEpbQjpAbFxYiFXvqp84wEcta6lBgs0nz2Mn+IVW
	xmLrNFUt5MoHe8Jk+dfPS/7S3zk8BtQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773764510;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K2DqWhzmSpIc3a/LBfMfz1g8pajA2LxzPO+dj6Mg0/s=;
	b=/gwmwDNy5AQBk9mLwVYXiVknZfM9H5PfzPFAA6HlVLZCO5y78C4gEJG/dJZnRvWclByobq
	vlu8v3mEDq/uuJAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 574414273B;
	Tue, 17 Mar 2026 16:21:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w08rFZ5/uWkReAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 17 Mar 2026 16:21:50 +0000
Date: Tue, 17 Mar 2026 17:21:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Illia Bobyr <illia.bobyr@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: balance: refactor parse_filters()
Message-ID: <20260317162144.GW5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260218073908.3927870-1-illia.bobyr@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218073908.3927870-1-illia.bobyr@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Queue-Id: 699184D336
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Tue, Feb 17, 2026 at 11:39:07PM -0800, Illia Bobyr wrote:
> Almost all of the parse_filters() function body is wrapped in a loop. By
> moving parsing of a single filter into a separate function we reduce
> indentation, and makes it a bit easier to follow the top level parsing
> logic.
> 
> Signed-off-by: Illia Bobyr <illia.bobyr@gmail.com>

Makes sense, thanks. Added to devel.
