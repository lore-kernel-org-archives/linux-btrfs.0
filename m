Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520163E6383
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 10:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784544739; cv=none; b=X6UPjd/fLHMuW3ug2+KQvbkrFT2l42iuRCUeoaruKJX2H0jx6ms8+w9/0Y/OBxJ3kMmTbPgMaCXEGjv09F5r7Tp4JS2nHwV9tAgjW+466/Nu1/zqrvrPQfzJTm4zW6L63qZXNG6Mtj3p4GIPP15ZaI1i6dqHA81nYMXS//Qnh/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784544739; c=relaxed/simple;
	bh=eMgU/DzTgurbsrcSm/6o44Y82L9HhaSwXwlKctHa0uE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORbZvCTsD28JbIsHH36E3It+7m4V1f0qL6+Y05PCerza/RVeUm+7xX890MByoVIHmZL5Sd+igF5HOzXaTx0GJLTisOBe7ot5qg/ifYSux70oxOeqyfE4cbBWGfv9U50ihtAiusnUkSbCjD0lEhm+Q8zdr+zgYIUSotd52aSr7wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bIQvrJYY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ypjxl0pu; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bIQvrJYY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ypjxl0pu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bIQvrJYY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ypjxl0pu";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bIQvrJYY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ypjxl0pu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 558D779EEA;
	Mon, 20 Jul 2026 10:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784544734;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DIFpln3chC5YRc1LC83Lur563AwKDo+8sTHThhbBFMQ=;
	b=bIQvrJYYRm417Wjm8+fVhR1zBkbcQBkjYBZw6pMpFOuySLId7tR2rPqYVpywcFL6/fZrXg
	2d3+IClRK14c1QpBrEItdgAyHGrKSLE5zrgsUL+/m5S+m4Lt0LpRgbs/coKMg1SPZf+1Yu
	PNYGuH5/iEzL69qSwmv9V55L6Xef3lA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784544734;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DIFpln3chC5YRc1LC83Lur563AwKDo+8sTHThhbBFMQ=;
	b=Ypjxl0puZuAV/8wQqZ9p0ib1C+9eJ5NxfBfDOdFClEGpo5sbQhifPRQRylkIWpwc20o9QV
	sueD0PcP90gdNKCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bIQvrJYY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ypjxl0pu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784544734;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DIFpln3chC5YRc1LC83Lur563AwKDo+8sTHThhbBFMQ=;
	b=bIQvrJYYRm417Wjm8+fVhR1zBkbcQBkjYBZw6pMpFOuySLId7tR2rPqYVpywcFL6/fZrXg
	2d3+IClRK14c1QpBrEItdgAyHGrKSLE5zrgsUL+/m5S+m4Lt0LpRgbs/coKMg1SPZf+1Yu
	PNYGuH5/iEzL69qSwmv9V55L6Xef3lA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784544734;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DIFpln3chC5YRc1LC83Lur563AwKDo+8sTHThhbBFMQ=;
	b=Ypjxl0puZuAV/8wQqZ9p0ib1C+9eJ5NxfBfDOdFClEGpo5sbQhifPRQRylkIWpwc20o9QV
	sueD0PcP90gdNKCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 483B1779AA;
	Mon, 20 Jul 2026 10:52:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JJhtEd79XWqQdgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 20 Jul 2026 10:52:14 +0000
Date: Mon, 20 Jul 2026 12:52:05 +0200
From: David Sterba <dsterba@suse.cz>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Boris Burkov <boris@bur.io>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] fs/btrfs: KASAN "args" initialization gripe in
 btrfs_ioctl_get_csums()
Message-ID: <20260720105205.GB10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b2c3772b-f4f1-41a1-8fc2-468c4ac896e8@paulmck-laptop>
 <c4392627-feb6-4353-bf59-eb152997af72@gmx.com>
 <44261d8e-4361-4592-9fcf-b5c8d56220ba@paulmck-laptop>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44261d8e-4361-4592-9fcf-b5c8d56220ba@paulmck-laptop>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 558D779EEA
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmx.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmx.com,bur.io,fb.com,suse.com,vger.kernel.org];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[7];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Tue, Jul 14, 2026 at 03:38:43PM -0700, Paul E. McKenney wrote:
> > > Fix (or at least suppress) this by initializing "args" to "{ 0 }".
> > 
> > This is a little weird, as @args is immediately written with
> > copy_from_user().
> 
> I was wondering about that myself.  Perhaps it refuses to assume that
> the entirety of args is overwritten?
> 
> > So I'd say this may be specific to certain compiler version.
> > Mind to provide the name and version of the compiler?
> 
> gcc version 11.5.0 20240719 (Red Hat 11.5.0-14) (GCC)

The 'maybe-uninitialized' warning occasionaly catches some arch and
compiler combination that does not recognize the effects of
initialization. The versions I see in fs/btrfs log are 10.2,
loongarch64-gcc 12.3.1, gcc8 on m68k or mips, gcc 5 on ppc. Eventually
reported when -Os is enabled.
