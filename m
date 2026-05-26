Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45460150997
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 16:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813215; cv=none; b=WheXBcXidcmz9AnSPz3mU4cwkIl8NgFD8lG0YGAtu74fe6ZD6PkFuHhE7f0Xvkej62YO2spA/GCl7wd37x9IMJ9GLT+zc4TeBCPhhQ98mRGZCxQXCU/MStI/FGclYu+Ep851V7q7V6LxFKRFAsCi/HkToKY5ui8A38gdTGFGCBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813215; c=relaxed/simple;
	bh=UlneO2i4vGB+ZckuNzdH+Th2bJY2e+9zVgZFFvAtBgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GRMYpgu+OkrVO0WAwKOPgS3tzzq4ndYTpom/UHB4VtzoITjUu5+IkgXjRXRNwKZqvig0SIo+Q4O2boYq0aFZDZKhKiCDtellXccH7jMvk4G3AodUd8Fkbu6XO1bYmOJOwL2eG1LI6/fBcpl25UlwrWpvvZzZmdbKX1MvtrtTYz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OEuCqkQp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BEvxVlE+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OEuCqkQp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BEvxVlE+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OEuCqkQp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BEvxVlE+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OEuCqkQp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BEvxVlE+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 463176AA9F;
	Tue, 26 May 2026 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779813212;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QQYeog/22D8H8NSJ9iEmNCIdnbeiXzbnQk61eeLV7w=;
	b=OEuCqkQpdNp64K3ENtVJHXUICFr79qRs7KdlLEGBKvKvPsJY+hVpVCnY8K6aJzQEKfiZks
	72SZp3Pq2+5nAjMTu1gj3O43PCHz88JvQnM56y/UT2n5w4yPXAtMnILgYqwiIujlwPhiSU
	MMYQHXsyaJfdmroDccc5b+fPG89U0zA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779813212;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QQYeog/22D8H8NSJ9iEmNCIdnbeiXzbnQk61eeLV7w=;
	b=BEvxVlE+fQv1UWNmocK8VP0PMNJiGKin6Ic/faxMFKrsPfGdNaockevWdPm/RS2ULbsT3G
	CNjCyPUnGqe7HDAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OEuCqkQp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BEvxVlE+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779813212;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QQYeog/22D8H8NSJ9iEmNCIdnbeiXzbnQk61eeLV7w=;
	b=OEuCqkQpdNp64K3ENtVJHXUICFr79qRs7KdlLEGBKvKvPsJY+hVpVCnY8K6aJzQEKfiZks
	72SZp3Pq2+5nAjMTu1gj3O43PCHz88JvQnM56y/UT2n5w4yPXAtMnILgYqwiIujlwPhiSU
	MMYQHXsyaJfdmroDccc5b+fPG89U0zA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779813212;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QQYeog/22D8H8NSJ9iEmNCIdnbeiXzbnQk61eeLV7w=;
	b=BEvxVlE+fQv1UWNmocK8VP0PMNJiGKin6Ic/faxMFKrsPfGdNaockevWdPm/RS2ULbsT3G
	CNjCyPUnGqe7HDAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 258F05A2D3;
	Tue, 26 May 2026 16:33:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hcOMCFzLFWo7LAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 26 May 2026 16:33:32 +0000
Date: Tue, 26 May 2026 18:33:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anajain.sg@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com,
	Anand Jain <asj@kernel.org>
Subject: Re: [PATCH v3 2/2] btrfs: derive f_fsid from on-disk fsuuid and dev_t
Message-ID: <20260526163329.GG12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1777281686.git.asj@kernel.org>
 <1420378f88b69562c4c77fe72bc7286408d995d2.1777281686.git.asj@kernel.org>
 <d1a3223f-489a-4769-ab0e-7620dedc3274@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1a3223f-489a-4769-ab0e-7620dedc3274@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 463176AA9F
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.71 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.71

On Mon, May 04, 2026 at 10:28:58PM +0800, Anand Jain wrote:
> On 27/4/26 18:18, Anand Jain wrote:
> > f_fsid depends on fs_devices->fsid and subvol root id.
> > 
> > For cloned devices either same as the source or dynamical generated
> > at mount won't suite because tools like fanotify and ima depends on it.
> > 
> > Switch to a stable derivation using the persistent on-disk fsuuid +
> > root id + devt of the block device for the single device filesystem
> > when temp_fsid is active.
> > This is consistent as long as the device remains unchanged/replace
> > (excludes btrfs device replace secnario for now).
> > 
> 
> David,
> 
> The changelog was inaccurate per Sashiko. I missed updating it to
> reflect the final implementation.
> I have corrected it below to match the current code changes.
> I hope below change log can be used during merge.

Changelog replaced and patches added to for-next. Thanks.
