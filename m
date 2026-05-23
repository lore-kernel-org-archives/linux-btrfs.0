Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EBE257827
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 17:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779556252; cv=none; b=ksh+0t99fotZQOO3mOodSbgnxAhxDsth/0hJsXUCX01dWepksiC4Hza0IVRLztEKnJLBEDXYeNpRE3BxfJ9m/t0k2wnQTm1w02fhyhiGQ5XhAUQClKJC/9a+u9f1mGKI8DP3//psHUFrEEgd/1i+i3AS8LiNKUv1Fn9DiXkMx48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779556252; c=relaxed/simple;
	bh=yA7sLEPVQD9iG4X7vCYWiVgIus4SHA9NY1hCqH3yB78=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/OdE6KwtNAApuSUd3FHSCSnzo/tvqD2ta909wZ8MPN9TAIPhU3JWwNopOIXGBCAgbBL21lGSrbSatXZnbwR3nLdRJss8aIUyhMv0cn2nNS4szK7BoVPQOs89j4GL14Vpyx+H69nI4WgYUAgcOSV3I0FeHb7UhHpf16HHm9y64E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iTaSIbpO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2xGLAgNi; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tfzgQTVu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uTTCI7Wj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iTaSIbpO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2xGLAgNi";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tfzgQTVu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uTTCI7Wj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F15DD68483;
	Sat, 23 May 2026 17:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779556249;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dihrJ+I72uR639CRV+jSDG1crdssIC5iu4MkqqlLfwM=;
	b=iTaSIbpOEgSm/p7/G9pRbv6CN3xQ1LizRZGb4gqPyo4QiX2TiCkPCFkz73zXCOV16y6Kt4
	t52GKrvYIsPHrUCfgwkgH2YNGpB36Y85SIZQCtl73tr03B9P2+IBM6J8J1oQVeAXzl+fL6
	QDUn6EpVHEeEzmcqUx2CNtPEFxitfW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779556249;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dihrJ+I72uR639CRV+jSDG1crdssIC5iu4MkqqlLfwM=;
	b=2xGLAgNiFoGw/n7O/zC4e4RBIZJw6+hCUjdc8wU9LLwVO/MS3EZP8Fj5LVWC6HbhlFGCJ6
	Ho/ZHhzOpJmTCvBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tfzgQTVu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uTTCI7Wj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779556248;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dihrJ+I72uR639CRV+jSDG1crdssIC5iu4MkqqlLfwM=;
	b=tfzgQTVuJMn+3Liwg8lsL2DYFGIH+MxLoydTNX9TEHfQae2moQGRXhUKXAaq4sqGYPvBSq
	YIkp7BVE/gi7fFVJ4GK574aHPk/xJRlg/zOzx5cZYqNWIQmkMFIPDmPfJw9qG7Zt/J37k7
	APF9LEQtmg288fWXpASCjNjBs07pZvU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779556248;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dihrJ+I72uR639CRV+jSDG1crdssIC5iu4MkqqlLfwM=;
	b=uTTCI7WjHYE14lc3o5Kqt/I4XidgEio/3cwPzbX6k8UO1WRRXPXW3uTOvuRd0ujGUiAnH3
	G7U72nvZvCuPaZBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC4F1593A8;
	Sat, 23 May 2026 17:10:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tPqNNZjfEWpNSAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 23 May 2026 17:10:48 +0000
Date: Sat, 23 May 2026 19:10:43 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 7.0
Message-ID: <20260523171043.GH183694@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260509235151.2070978-1-dsterba@suse.com>
 <20260522232533.GA316642@tik.uni-stuttgart.de>
 <20260523141808.GB183694@twin.jikos.cz>
 <20260523163238.GA442860@tik.uni-stuttgart.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523163238.GA442860@tik.uni-stuttgart.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Queue-Id: F15DD68483
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	internal_greylist_whitelist(0.00)[2a07:de40:b281:104:10:150:64:97];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Sat, May 23, 2026 at 06:32:38PM +0200, Ulli Horlacher wrote:
> On Sat 2026-05-23 (16:18), David Sterba wrote:
> 
> > > To get the newest version of btrfs.box.static I have written this script:
> (...)
> > > Yes, it works but it is ... ugly :-}
> > > 
> > > Is there a more elegant solution?
> > 
> > Maybe it is, right now the place is the release web page (click to
> > download)
> 
> I need a script, because I want to automate the download.

It's ok to host such script in the git repository or package it
eventually, if somebody sends it. It should be quite robust regarding
dependencies and potential changes in the web page from where it's
looking up the binaries.

> > or you can use the 'gh' command line tool (gh release download)
> 
> What/where is gh?

Quite confusingly at https://github.com/cli/cli
