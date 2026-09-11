Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE273EE1C3
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789149348; cv=none; b=plnwSevkMNaRNOY8vVF2iB4oRWZdriystlwUacIhwdVMZpMbICvHYJUDJklMTaMeNnCv+bv3ej69zQ6z2zBkpe7whEOmnXaO3IJVnAmVvJhVKRA1J7pMBecs4rZtB+NhDZMT6D26UsoVYNAm3nNqrHjJxcli88ulALNXWDBEq+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789149348; c=relaxed/simple;
	bh=9W9N6CYqraQvu8gerE5MWXl4DbfXElXXaRBlLEDqTV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRye7sS55WzSqRleOZT8YILKuy0nQyvN8yAEM4g2p6x4gEvnu0vut+Y/CgB0QC1UzpvE2+7LiuEV0eY8TYnQJ0Fy+b1hEbu4uReJOxMe+gv1UXPcq8z7Ww6GUqat9QhMFYLYL9GopM5uJkOc5DD3evWXCx3CTtQX14xsm2cKHVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PhaUZuHb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aebDd0uT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=r0B//RZD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UDe1I86l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PhaUZuHb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aebDd0uT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="r0B//RZD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UDe1I86l"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8076A21A9A;
	Fri, 11 Sep 2026 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789149340;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lM3tY19XKTLXTc286g14zjQIvRxWkXgQAuFi3Rs0uJk=;
	b=PhaUZuHbWM7xjp604z7Gpym+Q/aD1AyUBc2mjtjN8NalfQ+OYeKqxHPE850Az6ZEe5XrRJ
	Ckfc26Xi50J42XJPnoOveVZe1KhkASHVfq4vcCbb52R7N3UQ1NXw5e1JKf1EjnGgtdF6Gw
	oied3yOOYSNMs+aTbA2p7xC8IRSi2d0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789149340;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lM3tY19XKTLXTc286g14zjQIvRxWkXgQAuFi3Rs0uJk=;
	b=aebDd0uTTiHuOGfpmGMZ+tavR9pf9Hq50kE7qxhu4xyN/IjxPQOwf7iOHZHDHHfwS15QdS
	GSo5llzn4TDU7eAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="r0B//RZD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UDe1I86l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789149336;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lM3tY19XKTLXTc286g14zjQIvRxWkXgQAuFi3Rs0uJk=;
	b=r0B//RZDwAXibEMebh3ungKdfDnTCxEJtzmLzsji2P3r1dp0NzE5I1BwEOzti41h1Y+tKV
	DIzWst8E/XafhimAJx23oZJDWyOouPrW02K3hLZG6ay+OUZ2y2b0DO0J7RGlGaZEojkzrx
	47N1EjfyRroC/tlwvQ6WTviu8CYR6+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789149336;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lM3tY19XKTLXTc286g14zjQIvRxWkXgQAuFi3Rs0uJk=;
	b=UDe1I86lko0tgOfUzj7WRdDoDoVvWVBPkFQxtzZAplZs4IJzKfUoKy2ea5+ZVnP2GlVQY1
	RkWjm2gnIU4gfVAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 267A9136ED;
	Fri, 11 Sep 2026 17:55:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UYm0CJhApGrpTgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 11 Sep 2026 17:55:36 +0000
Date: Fri, 11 Sep 2026 19:55:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: btrfs: OOM in split_item().
Message-ID: <20260911175526.GC54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <nka8fLGwxf2NcMXCcuLi4CkGSIKrKG4Sc9IbvTTBG5L6T63w6tImgOKYEmu-pWaoZZFO4Eqg8zDyMggihfvlFRTd1Vubz6E52PVEhU83gn8=@protonmail.com>
 <250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com>
 <20260908131439.GC9053@twin.jikos.cz>
 <962e0f59-ca17-4467-b762-0b225df0d25f@suse.com>
 <20260909004439.GG9053@suse.cz>
 <f6eed62a-c9f6-4f0f-848e-e99445f46538@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f6eed62a-c9f6-4f0f-848e-e99445f46538@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 8076A21A9A
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Wed, Sep 09, 2026 at 10:36:10AM +0930, Qu Wenruo wrote:
> 在 2026/9/9 10:14, David Sterba 写道:
> > On Wed, Sep 09, 2026 at 06:57:59AM +0930, Qu Wenruo wrote:
> >> 在 2026/9/8 22:44, David Sterba 写道:
> >>> On Tue, Sep 08, 2026 at 07:45:58AM +0930, Qu Wenruo wrote:
> >>>> Forwarded for archive purposes, as patchcheck requires a link: tag
> >>>> following reported-by: tag.
> >>>>
> >>>> Meanwhile the original report is only a private mail to me.
> >>>>
> >>>> -------- 转发的消息 --------
> >>>> 主题: 	btrfs: OOM in split_item().
> >>>> 日期: 	Mon, 07 Sep 2026 20:10:56 +0000
> >>>> 发件人: 	xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
> >>>> 收件人: 	wqu@suse.com <wqu@suse.com>
> >>>>
> >>>>
> >>>>
> >>>> Hello.
> >>>>
> >>>> Attached is a kernel log entry showing a strange out of memory issue
> >>>> that rarely seems to happen.
> >>>> It's kind of annoying and makes me wish GFP_NOFS would go the way of the
> >>>> dinosaur.
> >>>
> >>> What is the story behind that? One way or another we will get GPF_NOFS
> >>> semantics, either the flag or the scoped NOFS and this limits the
> >>> allocator.
> >>
> >> No extra follow up unfortunately.
> > 
> > For the record, as it was in a separate mail, that GFP_NOFS can
> > sometimes fail because of page fragmentation and limited options for the
> > allocator.
> > 
> >>> Using 64k nodes is problematic and so I'd rather people not use it on 4k
> >>> systems.
> >>
> >> In fact the only problematic part in b-tree operation is exactly the
> >> vmalloc() I'm fixing.
> >>
> >> Other than that I see no obvious problem related to 64K nodesize on 4K
> >> page systems.
> > 
> > Technically if the allocation has a fallback then there's no problem. In
> > practice the 64K contiguous memory needs to get shifted for almost every
> > metadata insertion.
> 
> That is not true, at least not for all cases.
> 
> The 64K buffer is only needed when we got a huge item to split. 
> Meanwhile the most common cases of btrfs items are all fixed sized.

We're talking about the whole node, not individual items and the
variable length types you listed below. Any insertion/deletion in the
middle of a 64k node needs to shift the bytes adjacent to the change. On
fuller nodes it means more data.

> - Csum items
>    This is the exact case we're hitting.
> 
>    The point here is, we can use as large as the whole leaf for a csum
>    item.
>    This makes split much harder, requiring a huge buffer for such split.
> 
>    I think we should introduce an artificial limit on the csum item size.
>    Keep it 16K at max should greatly reduce the need for large buffer.
>    And the cost is pretty minimal, just extra btrfs_items.
>    At most it will be 3 * 25 bytes for 64K node size, I think it's
>    definitely acceptable.
> 
>    By that, we also reduce the buffer requirement for such csum item
>    split.

For filesystems with 64k nodes we can do that, the default case of 16k
is unaffected.

> > COW requires the whole 64K set of pages to be
> > allocated. So there's a lot of dead weight carried around.
> > 
> > It's a tradeoff, 4K nodesize would need taller b-tree for the same
> > amount of raw items. This is worse due to lock contention and concurrent
> > changes. I think the 16K is a reasonable middle ground.
> 
> It's a trade-off for nodesize selection, but for this particular csum 
> item split, I think we should fix it no matter if you want to prevent 
> 64K node size or not.
> 
> Personally I do not want to discourage any valid nodesize/sectorsize 
> combination.

The option exists but is not common and brings an overhead, it should be
a conscious or benchmarked choice rather than a guess that bigger nodes
mean better.
