Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B449427F8B;
	Mon, 21 Sep 2026 12:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993623; cv=none; b=Ss7hd6bCela9QhyextHWyIjcDPV00AecaZzL9LTp+z+x926NXBUQSe8kL2z1vkU4uFe04V7ZrYhTyrAF/GSC1i6RQaDWJTSOT0Xlc9Rp4kprS50tkM9rJWv39WL/zwko44ufDJEQKkVtp0owcyJFUQModg19QdCnrdbd6NQgzzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993623; c=relaxed/simple;
	bh=iLDn2/y9elf9xjbQjXoGdAt+cFSH8BtPUQxX7ObRmec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1JWPf11uEM9c/6CJ9hL5nP9RKHsF6rvP0ANYYUDPfymQzP1o9/O0QWcwhthR9JpKwmW5WDtOTdJm6i91xFs2iDJLJxheldVNaywXN9VYTHDkNDQUS2sIT8tY5PkKJ9cN2Dc6wdPwK2WdkTH21ngUNX51PX763Sb/YMOnKSw1+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=icRfcgUh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+jkPJfiA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yoQoA39j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QJDS8jIh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="icRfcgUh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+jkPJfiA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yoQoA39j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QJDS8jIh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2D03221CA9;
	Mon, 21 Sep 2026 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789993616;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZgMNcKf5nnm8Ds1/NwXov5Uj5kfQWAvQQqccvASKDlw=;
	b=icRfcgUhNKr1MukliSqCISy62cLcPuvPZEE1rzTeUGdgVnlBl5EUHQrk0RUcyqkHrZpjWQ
	cQppJsBWu0FnLpu4MhW8cPVpswcpOnRl1HLt6i6Wve9BybWEnvhugSm6lY/FZ9hEh9w4Yd
	+ih3sLA/sqRH8lKy+9lzVgbSAlPZkcY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789993616;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZgMNcKf5nnm8Ds1/NwXov5Uj5kfQWAvQQqccvASKDlw=;
	b=+jkPJfiA2LGoPJR55VjoU1kOjz84Hvs17PVpMyGh2xYykVmRrH8H7pGtLt6iwo3r84oll4
	MEq/4mRnW54rioAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yoQoA39j;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QJDS8jIh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789993612;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZgMNcKf5nnm8Ds1/NwXov5Uj5kfQWAvQQqccvASKDlw=;
	b=yoQoA39jOpowYDC9rxQOSfYRHJA93Zwh7IHUKsuna+EI0yqixqNdvIrufZKT6h3XMPnSt4
	0PN3ioWjB7XZGG5idYLdX4z2iNcQrmlS3HcPwY5GVLgrSsxU9yNnyPfPWnWFRM5zAvnwCL
	JZCsRoLBMK8rIUTzTLtrsPqR/43NxdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789993612;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZgMNcKf5nnm8Ds1/NwXov5Uj5kfQWAvQQqccvASKDlw=;
	b=QJDS8jIhHdcTArYkNY6bTPvVzFqQeTt0iKRfqSHnb/miH0+t5WtKHCsdnuoHT/2PkBiVms
	ipqKbwKGaYsUUmBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA13D13793;
	Mon, 21 Sep 2026 12:26:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZC0tL4sisWrCPQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Sep 2026 12:26:51 +0000
Date: Mon, 21 Sep 2026 14:26:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: Wentao Liang <vulab@iscas.ac.cn>, clm@fb.com, dsterba@suse.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	wqu@suse.com, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix root reference leak in
 handle_indirect_tree_backref()
Message-ID: <20260921122646.GZ54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260916171319.2086756-1-vulab@iscas.ac.cn>
 <20260918191342.GB2956775@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918191342.GB2956775@zen.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2D03221CA9
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:replyto];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Fri, Sep 18, 2026 at 12:13:42PM -0700, Boris Burkov wrote:
> On Wed, Sep 16, 2026 at 05:13:19PM +0000, Wentao Liang wrote:
> > handle_indirect_tree_backref() walks up the tree from @cur, storing the
> > reference returned by btrfs_get_fs_root() in lower->root when the top
> > of the searched path is reached, and dropping it once a node already in
> > the backref cache is found.  If the walk instead reaches
> > BTRFS_MAX_LEVEL without hitting either of those two exits, the
> > reference is neither stored nor dropped and is leaked on return.
> 
> Are you able to reproduce this bug? If so, can you include that
> information in the commit message.

A filesystem with a tree of maximum height consumes a lot of metadata
space and in practice it's difficult to create one. For completeness the
check could be there, we have other impossible condition checks
elsewhere too.
