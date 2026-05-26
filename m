Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADE2372ECC
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 16:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779814334; cv=none; b=bCfS3ZgyzJY3XyG8og/+4d88BH5PIopRi8uNR5Zzf20roqattulY1ri7ZRvPyNKLpfzCyVWaN6RQCSn0qhciJfAEHp2OfNUEPDpG/xt3T3/UuWCYfwrObd0GrrP4SmOeBHFLkdiCHxnIlllx3C/2S7CuCLKvl3thWb6SBJfTFsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779814334; c=relaxed/simple;
	bh=DsnCwfm8uRpKXOEK1J8Sh1+gTlpbH+u3vmzbVJwouHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQ7awMk5WcRF42Tiyp++MGuvyO2VWHctfXwg5RoTzmgbzsW6AfQpMKWuxk1PoFr37fB6nAhWlcmKPc4Ny1eVJpd1vPuToPFIFKZUpDCJ3DIqRKOGHbfOiwXQOYzsi8nZgw62S9bDFSzsQGAtppHFiMFliPOjH3TwD0+VCa4Mdqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=De2655Jf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+madzQQG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N375RV7s; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6y7v3yT2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="De2655Jf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+madzQQG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N375RV7s";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6y7v3yT2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DD44A66D21;
	Tue, 26 May 2026 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779814331;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ulxZaNwE5fHGgsQ6wkRw9s7pLCl0iqpZIt2pUpFK/jU=;
	b=De2655JfQ0LZUP94vTmnFMGeVbMZYgrM+UaKCb3f6oTl0ySg4tr7TRyCPyNySyJoerj+H1
	WOe0juK/GCZ4EUZbH/9ISrb/JNB1reZ1RYf2jYnzowQtsa4aG+Ndxp2frKNWWah7UANNA6
	JxOYqVKpfsxhZo6P1iSnLPh889JIscY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779814331;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ulxZaNwE5fHGgsQ6wkRw9s7pLCl0iqpZIt2pUpFK/jU=;
	b=+madzQQGziS5Q5QVYUttsn3hokTUgJ7EWSricvRJtDJxSK4YvG4Nxc03ZFvqxQdwwj9VLo
	8netZzjjtJaUFGCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N375RV7s;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6y7v3yT2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779814330;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ulxZaNwE5fHGgsQ6wkRw9s7pLCl0iqpZIt2pUpFK/jU=;
	b=N375RV7sxGWtTjY+HuOeJJy8RpCDyVTUbT/v7jF+xRVFmohjeJ+FSy+4zsdmexOB/vJyTt
	aIF/N1IDkxKjIal+nVTC2uFhXb+HPb+PpKk2IdhI8T8rGlGDCgoj2Vw5HdP9ynWD271VGy
	qLbkCJCP6F56UeC21gc0kBKa2G+GjHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779814330;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ulxZaNwE5fHGgsQ6wkRw9s7pLCl0iqpZIt2pUpFK/jU=;
	b=6y7v3yT2aJu73aSwKtl3mpc/EffFVYZNWEKIJao3TG3J0Vqbp+SLRDlgoTDwgKCI/e9C/A
	zKM66hTBifBSs7Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE6715A2E6;
	Tue, 26 May 2026 16:52:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 48DTLbrPFWoLPwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 26 May 2026 16:52:10 +0000
Date: Tue, 26 May 2026 18:52:05 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: DEV_STATS item related minor fixes
Message-ID: <20260526165205.GH12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1775553952.git.wqu@suse.com>
 <20260525130658.GC12792@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525130658.GC12792@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [0.79 / 50.00];
	REPLYTO_EQ_TO_ADDR(5.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spamd-Bar: /
X-Rspamd-Queue-Id: DD44A66D21
X-Spam-Flag: NO
X-Spam-Score: 0.79
X-Spam-Level: 
X-Rspamd-Action: no action

On Mon, May 25, 2026 at 03:06:59PM +0200, David Sterba wrote:
> On Tue, Apr 07, 2026 at 07:03:57PM +0930, Qu Wenruo wrote:
> > Qu Wenruo (4):
> >   btrfs: remove the dev stats item for replace target device
> >   btrfs: remove the dev stats item when removing a device
> >   btrfs: always update/create the dev stats item when adding a new
> >     device
> >   btrfs: avoid unnecessary dev stats updates
> 
> Please add the series to for-next, thanks.

Now merged to for-next.
