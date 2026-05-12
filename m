Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C31937E30D
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 13:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778592955; cv=none; b=fLHLqelW55PcldIS53WOliEgDVrI/awHHfmXmxdY53SP3gAYDc/8keFjUHFhVLi/rDDJq0tjgHLkwt+POIVPSg/jkew6yC1p+IljRDnoi1ssx+Si9+e+66+NR+krZoJQTIGQA02Mx6InI2gvQ2TLwR+lMbX6KKegvMtAdctpMQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778592955; c=relaxed/simple;
	bh=5mQd+85vtRwt3SVYKAJW1ABFQmEmSdPyF3IZZMeqbEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obtrMBbnUj96LLayuJuoxKpWuEtVz2LsJVMnrPiWt+D9IqC4yHybSxpIoeii4mpj9pLZFLThpy7yeXEOCgYjHQiUevMDESLm87qJpEB9H+LWKQCZ4q2s0JCc0FKujSfez03AmXOHIFjSJythhYVVofz7yWnoYjW48ArWah+4Yhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d36nQYIn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mTlCu0wW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d36nQYIn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mTlCu0wW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d36nQYIn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mTlCu0wW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d36nQYIn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mTlCu0wW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9B8486C1DD;
	Tue, 12 May 2026 13:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778592952;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5mQd+85vtRwt3SVYKAJW1ABFQmEmSdPyF3IZZMeqbEc=;
	b=d36nQYInWHnKbgrICcurF5hYRboLvtKT7AeYOcV/+4dluXZ994XKV85nOmH2bNcDTQlo00
	P9g+ww/RdsyPr4Z7ZWWgO1ZRgCUNbnADRgDdIMHTk5RCqDKfEe0yfDma/xynUqCZt3rury
	GcKNRp3+Dtpy9LySPRPLFIzHjp+aZa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778592952;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5mQd+85vtRwt3SVYKAJW1ABFQmEmSdPyF3IZZMeqbEc=;
	b=mTlCu0wWIacuJ7e6uEwCBiTeYs2+Ni/uJrXEzj+uMzOJAPJqHrru/E6bDqNX6Da9ti7IWC
	1e4gWG1rVjGPiYDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d36nQYIn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mTlCu0wW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778592952;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5mQd+85vtRwt3SVYKAJW1ABFQmEmSdPyF3IZZMeqbEc=;
	b=d36nQYInWHnKbgrICcurF5hYRboLvtKT7AeYOcV/+4dluXZ994XKV85nOmH2bNcDTQlo00
	P9g+ww/RdsyPr4Z7ZWWgO1ZRgCUNbnADRgDdIMHTk5RCqDKfEe0yfDma/xynUqCZt3rury
	GcKNRp3+Dtpy9LySPRPLFIzHjp+aZa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778592952;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5mQd+85vtRwt3SVYKAJW1ABFQmEmSdPyF3IZZMeqbEc=;
	b=mTlCu0wWIacuJ7e6uEwCBiTeYs2+Ni/uJrXEzj+uMzOJAPJqHrru/E6bDqNX6Da9ti7IWC
	1e4gWG1rVjGPiYDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D060593A9;
	Tue, 12 May 2026 13:35:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AMAvIrgsA2qYXAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 12 May 2026 13:35:52 +0000
Date: Tue, 12 May 2026 15:35:51 +0200
From: David Sterba <dsterba@suse.cz>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
	r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] btrfs: lock balance status ioctls against shutdown
Message-ID: <20260512133551.GI2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260512065342.537219-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512065342.537219-1-gality369@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:dkim,twin.jikos.cz:mid];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,fb.com,vger.kernel.org,gmail.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:dkim,twin.jikos.cz:mid]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9B8486C1DD
X-Spam-Level: 

On Tue, May 12, 2026 at 02:53:41PM +0800, ZhengYuan Huang wrote:
> BTRFS_IOC_BALANCE_PROGRESS and BTRFS_IOC_BALANCE_CTL only take fs_info
> and then touch fs_info->balance_mutex and balance state directly. They
> do not pin the superblock against shutdown and they do not reject a
> dying superblock before taking balance_mutex.

So the reproducer is a number of processes querying the balance status
and there's a filesystem unmount running in parallel, right?

This can be considered as a general pattern and maybe more ioctls need
the 'want write' protection. We do have it for all the write actions,
but as can be seen here it's for the read-only ones too.
