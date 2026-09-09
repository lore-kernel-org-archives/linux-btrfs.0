Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A592E492E5D
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 00:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788914693; cv=none; b=s/G9oLs600JSonISMiAR9FxdTxb7u1/Cy+SZsfWXIiMrcWe4mDDobHISEwexUnc0ipcLRCVo9eg3NmX19xW4TEVfXSYoBH6ndWWiCSMQauRZd1f4MAjhwB1jcUbscCk7xApBixawi7r8zmEg3CKA6DIbfYkSwq7Z2+EYnIYVyS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788914693; c=relaxed/simple;
	bh=xmjkoVWXvS9+/Jmn/iBbvj8KgNL4eqgxOrrH6Rl2l2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVyS1NW131jEx/QDQF5xRHisshaOFI+LeEELjY1q+zsF4Frn7d0NjyKRqZTAmjV7CCzVDscY/nP7i6FSh3m5h1QB0GKgUsTyAnmQIsf0LZBWcJB4j/vzhOFupwM9ONpwLrezj8+YpxXCXEZ1BUBBom+eexAmBK/6w9gYHeQl1hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=I38UlZCL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tBP0QP+G; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MXq1Rfa4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1AeWQHNX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="I38UlZCL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tBP0QP+G";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MXq1Rfa4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1AeWQHNX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B97D1FAA8;
	Wed,  9 Sep 2026 00:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788914685;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IkMeyp7w0zUlYQBH9OM2pqn0OTuI8vkurDO5Cjmii60=;
	b=I38UlZCLHw+xkKvdbpqQOpC4ibaczxzzJdh8DgvYOfL0rhW2CoUa4/YOS8JJ0KgOhCfWeD
	xqL+oh2yNWhhywNNhHCK7SiZU46rlJo1GtK0Pll+4sb+sCT7T0z0xlUVT7w2hDS8d1VWuk
	kkgjtt6F9i1Hd1nQjmR96IdKmUWsgMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788914685;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IkMeyp7w0zUlYQBH9OM2pqn0OTuI8vkurDO5Cjmii60=;
	b=tBP0QP+GE6UpVDM0AMAxMSE6d5IzaUoRvVujYI8ZUQsmdOqL2WqEon0mzJow4loh4xAKrY
	LkH89z12cUx0iKDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788914681;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IkMeyp7w0zUlYQBH9OM2pqn0OTuI8vkurDO5Cjmii60=;
	b=MXq1Rfa4249TvcEIlEI/ViX1SbJSflToMct0HLl2Za9ZNLiU1U/Kz/aVO1aZ/4k/5IDeIe
	vVyc7eQWTAiWAA6+PbobtllrvzQ6JWtFC2CiLoJXFwvIja7zxLMCretuIioJS2Hwsn9tnc
	3ZkoTY6lRmxSceL7CihhHz3FV+nt6rU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788914681;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IkMeyp7w0zUlYQBH9OM2pqn0OTuI8vkurDO5Cjmii60=;
	b=1AeWQHNXfO/ZDYCDA4p8HIq6wToMYvDHKHYlu0snEtlBlXwxCPhD9HAn1zZt15UmJHc1ZY
	Budaj4qtu6CAyvDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E14CB1347F;
	Wed,  9 Sep 2026 00:44:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v4e1NviroGqzUwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 09 Sep 2026 00:44:40 +0000
Date: Wed, 9 Sep 2026 02:44:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: btrfs: OOM in split_item().
Message-ID: <20260909004439.GG9053@suse.cz>
Reply-To: dsterba@suse.cz
References: <nka8fLGwxf2NcMXCcuLi4CkGSIKrKG4Sc9IbvTTBG5L6T63w6tImgOKYEmu-pWaoZZFO4Eqg8zDyMggihfvlFRTd1Vubz6E52PVEhU83gn8=@protonmail.com>
 <250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com>
 <20260908131439.GC9053@twin.jikos.cz>
 <962e0f59-ca17-4467-b762-0b225df0d25f@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <962e0f59-ca17-4467-b762-0b225df0d25f@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:replyto,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Sep 09, 2026 at 06:57:59AM +0930, Qu Wenruo wrote:
> 在 2026/9/8 22:44, David Sterba 写道:
> > On Tue, Sep 08, 2026 at 07:45:58AM +0930, Qu Wenruo wrote:
> >> Forwarded for archive purposes, as patchcheck requires a link: tag
> >> following reported-by: tag.
> >>
> >> Meanwhile the original report is only a private mail to me.
> >>
> >> -------- 转发的消息 --------
> >> 主题: 	btrfs: OOM in split_item().
> >> 日期: 	Mon, 07 Sep 2026 20:10:56 +0000
> >> 发件人: 	xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
> >> 收件人: 	wqu@suse.com <wqu@suse.com>
> >>
> >>
> >>
> >> Hello.
> >>
> >> Attached is a kernel log entry showing a strange out of memory issue
> >> that rarely seems to happen.
> >> It's kind of annoying and makes me wish GFP_NOFS would go the way of the
> >> dinosaur.
> > 
> > What is the story behind that? One way or another we will get GPF_NOFS
> > semantics, either the flag or the scoped NOFS and this limits the
> > allocator.
> 
> No extra follow up unfortunately.

For the record, as it was in a separate mail, that GFP_NOFS can
sometimes fail because of page fragmentation and limited options for the
allocator.

> > Using 64k nodes is problematic and so I'd rather people not use it on 4k
> > systems.
> 
> In fact the only problematic part in b-tree operation is exactly the 
> vmalloc() I'm fixing.
> 
> Other than that I see no obvious problem related to 64K nodesize on 4K 
> page systems.

Technically if the allocation has a fallback then there's no problem. In
practice the 64K contiguous memory needs to get shifted for almost every
metadata insertion. COW requires the whole 64K set of pages to be
allocated. So there's a lot of dead weight carried around.

It's a tradeoff, 4K nodesize would need taller b-tree for the same
amount of raw items. This is worse due to lock contention and concurrent
changes. I think the 16K is a reasonable middle ground.

> The way we handle metadata is already vmalloc() like, we allocate page 
> sized folios for 64K nodes anyway.

Yeah, that we've been heading towards large folios also means contiguous
ranges for nodes. Memory management is aware of that and allocator
should provides that by the means of compaction. I don't know how much
it could be improved.
