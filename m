Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243B43C4563;
	Mon, 21 Sep 2026 12:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995322; cv=none; b=bk72lQHyaAn/QgDuYOzGvnxwCksCUyg+Xc797aHn/+ir3DLSObbXcVCPS8+xEkvywe/zOVStRbyjOGLs0nTVLvQ8yayEmYn5MAaDeYU3h94NevxtqRULYvE9VFkeKPZoBshblX8ry3GmGFLwEzaB5g+7QYgTGil0BYe1ROAB9Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995322; c=relaxed/simple;
	bh=OSh3sXhZwy8pWGMgrj5o5cqYqNMnxGydsHdIyEvxb7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjFyiFl03Kb/WynRd0w79g4ftgn8yjFeGuIgkR8Bdr7kEJDqrtziuYTxFfgpWxASK5JO4f4hfHZWP6QQnCZYb/UF1YG87m7fTebUh2NOllA9/drsPbriCT8t8Wzu2RSJbBUQXpFuboh6d8Bksx1IUIHtdQy2h0NAFjLBo76sdmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=04lg39jo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UK0HrAw2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mDFdaJpd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5ciDG+Ju; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="04lg39jo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UK0HrAw2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mDFdaJpd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5ciDG+Ju"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 889C321A6E;
	Mon, 21 Sep 2026 12:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789995314;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SKloclEIQkofMQ62/pJyxJwJsl4EoZ+U1dPnW4VpfZE=;
	b=04lg39joq1xcfY4IJuLQquGTWqtkapsaT54MkgPSZiOP9JnUL+Q0Gx4m5WMVIp0hUcxQXX
	BXlopVygZkay8u+4E9j3ars/j4627j87Qnh6tCq8wlWStP+Vh/cogoQ4NLMlakd7EeXmF2
	NJthGzzw0X+w58wxAlnFiXtnLDrXro4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789995314;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SKloclEIQkofMQ62/pJyxJwJsl4EoZ+U1dPnW4VpfZE=;
	b=UK0HrAw21V3OI442yq8Uo49s189ukQrzVD57hu3a4u5IWMWm7Uma3KF3IW20v8M7uTOxtc
	qSA7na0uGm3FxwAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mDFdaJpd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5ciDG+Ju
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789995310;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SKloclEIQkofMQ62/pJyxJwJsl4EoZ+U1dPnW4VpfZE=;
	b=mDFdaJpdVWxD06ypqtjWtfXhzWANEL8sjclVhZAeCWkFYOxQs62wtjKbd4BiD9FfByOoEJ
	84ckNLxg3mkbCo1AyVMl/duhvP2hOj1Xw5AGpf1PYjbTrDIc/Q04mmMTksum6Wla2k1hen
	x1W0NQx87T94WotShcFCjO3OLZWVKms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789995310;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SKloclEIQkofMQ62/pJyxJwJsl4EoZ+U1dPnW4VpfZE=;
	b=5ciDG+JugkUCgklj3GmjCYb4rfMJqrPnz+bzJ7WEDOQj//kL9k43ya+zvfIeFq17wpvrW/
	spd/e2ZQcYi0ekDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5BB5A1368D;
	Mon, 21 Sep 2026 12:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dkYQDi4psWp3XAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Sep 2026 12:55:10 +0000
Date: Mon, 21 Sep 2026 14:55:09 +0200
From: David Sterba <dsterba@suse.cz>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	linux-kernel@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use assign_bit() where applicable
Message-ID: <20260921125509.GD54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260920022730.3145797-1-peng.fan@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920022730.3145797-1-peng.fan@oss.nxp.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 889C321A6E
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nxp.com:email,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Sun, Sep 20, 2026 at 10:27:29AM +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Convert open-coded if/else with set_bit/clear_bit and their
> non-atomic __set_bit/__clear_bit variants to the assign_bit/__assign_bit
> API.
> 
> Done with Coccinelle semantic patch:
>     // set_bit -> clear_bit => assign_bit
> 
>     @@
>     expression cond, bit, addr;
>     @@
> 
>     -if (cond)
>     -        set_bit(bit, addr);
>     -else
>     -        clear_bit(bit, addr);
>     +assign_bit(bit, addr, cond);
> 
>     // clear_bit -> set_bit => assign_bit
> 
>     @@
>     expression cond, bit, addr;
>     @@
> 
>     -if (cond)
>     -        clear_bit(bit, addr);
>     -else
>     -        set_bit(bit, addr);
>     +assign_bit(bit, addr, !cond);
> 
>     // __set_bit -> __clear_bit => __assign_bit
> 
>     @@
>     expression cond, bit, addr;
>     @@
> 
>     -if (cond)
>     -        __set_bit(bit, addr);
>     -else
>     -        __clear_bit(bit, addr);
>     +__assign_bit(bit, addr, cond);
> 
>     // __clear_bit -> __set_bit => __assign_bit
> 
>     @@
>     expression cond, bit, addr;
>     @@
> 
>     -if (cond)
>     -        __clear_bit(bit, addr);
>     -else
>     -        __set_bit(bit, addr);
>     +__assign_bit(bit, addr, !cond);
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

Added to for-next, thanks.
