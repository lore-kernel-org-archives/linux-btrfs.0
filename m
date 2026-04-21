Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E3F23B61B
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2026 03:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776742402; cv=none; b=IULteCcoFjQTEjBH1pAlCo0aOFX9b6Diktd74vtF7rTmciB4sYeYbTUyOGdQNv4AYkqxBzbH47D4LDhSdjmjiGULjruWEZBgJshOGqRcN2OPvK7ijfhlWTwD7GU/hHZP0+DCl8x5D+qe2uIm2MJRNet4o+XtTmfqhXn/Uw81J7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776742402; c=relaxed/simple;
	bh=xrlRtv6qliBlRIAJpHhc4AXU3Q5xkbtruEB4iYA21Us=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l5b9DRWF+ubmG7fgVJcFDaaJ6k+lTAnsAGvBuuqBMyUOXZj9fX6aS1Y7MAUNlkKSLzVBZdXpcnv5sCjs6n1JcPbgXDODTVHYbH2s0KtBb7OqxA7Ib3BvTnl3sF1vSpVMmvRK2rpNv/4w1pZYwLQg11XzL+pQaXtL4jMCxBUOfXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qfsKBP5S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uaLLqXm9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qfsKBP5S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uaLLqXm9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qfsKBP5S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uaLLqXm9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qfsKBP5S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uaLLqXm9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F3DD96A7DB;
	Tue, 21 Apr 2026 03:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776742400;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rUH9aV16+5e1cd0/UD82SRdoqx0/zz9VH8bs0oZR3jE=;
	b=qfsKBP5Sh32IZ/eWgkH/vFYgRJD4jEJsVYKDN1+1UuKlPxW/w4gWGTStHKM0Sko+I322lv
	X7MZAVI+b9J5l0kuBRNoqnRxzz+O75U7XOiOMBdVxlPLIDMxdKFE89TiURkfXxA5Bp0jI7
	cPsGm931RWXowCktNV17j1BQuJ0BeFU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776742400;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rUH9aV16+5e1cd0/UD82SRdoqx0/zz9VH8bs0oZR3jE=;
	b=uaLLqXm9TR52fdxhPEmf+Sj8EsqOXzo+I9qiZxWXjHykizTcw2QN8mxUaLVPVfzFx+7MSm
	5TyPEjTYahbGTeAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776742400;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rUH9aV16+5e1cd0/UD82SRdoqx0/zz9VH8bs0oZR3jE=;
	b=qfsKBP5Sh32IZ/eWgkH/vFYgRJD4jEJsVYKDN1+1UuKlPxW/w4gWGTStHKM0Sko+I322lv
	X7MZAVI+b9J5l0kuBRNoqnRxzz+O75U7XOiOMBdVxlPLIDMxdKFE89TiURkfXxA5Bp0jI7
	cPsGm931RWXowCktNV17j1BQuJ0BeFU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776742400;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rUH9aV16+5e1cd0/UD82SRdoqx0/zz9VH8bs0oZR3jE=;
	b=uaLLqXm9TR52fdxhPEmf+Sj8EsqOXzo+I9qiZxWXjHykizTcw2QN8mxUaLVPVfzFx+7MSm
	5TyPEjTYahbGTeAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9BA7593AF;
	Tue, 21 Apr 2026 03:33:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id edTyNP/v5ml8SwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Apr 2026 03:33:19 +0000
Date: Tue, 21 Apr 2026 05:33:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
Subject: Re: [PATCH] btrfs: annotate lockless read of defrag_bytes in
 should_nocow()
Message-ID: <20260421033318.GE12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260401022153.743576-1-zzzccc427@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401022153.743576-1-zzzccc427@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[fb.com,suse.com,vger.kernel.org,gmail.com];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Wed, Apr 01, 2026 at 10:21:53AM +0800, Cen Zhang wrote:
> should_nocow() reads inode->defrag_bytes without holding inode->lock,
> while btrfs_set_delalloc_extent() and btrfs_clear_delalloc_extent()
> update it under that spinlock.
> 
> This is a data race.  The read is a quick check used to decide whether
> to fall back to COW for a NOCOW inode: if defrag_bytes is non-zero and
> the range is tagged EXTENT_DEFRAG, we force COW so that defragmentation
> can rewrite the extent.  Reading a stale value is harmless because:
> 
>   - A missed increment may skip COW once, but the defrag pass will
>     redo the extent later.
>   - A stale non-zero may force an unnecessary COW, which is a minor
>     efficiency loss, not a correctness issue.
> 
> On 64-bit platforms an aligned u64 load is naturally atomic so tearing
> cannot happen.  On 32-bit platforms u64 may tear, but we only test for
> zero vs non-zero, so the heuristic stays correct regardless.
> 
> Add READ_ONCE() to prevent the compiler from caching or splitting the
> load and to document the intentional lock-free pattern.

As it's explained it's ok to do the unlocked read but of that that the
dara_race() is more convenient, we do not really need the READ_ONCE
semantics.
