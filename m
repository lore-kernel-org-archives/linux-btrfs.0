Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D361A340DB8
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 10:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779704904; cv=none; b=JP8CuRFr3UZbML0kdqUyoqheuQQQHJD5vGVenLin++LYv1CCei1orNCIU3xIUXBVqH9r3yVWXlpRIVNI3YEv3Enh4AgKg1eKg1VXi+WYZVZqZEY4kbfuEBGO12cfCZJAd9sy4IOU8IDqHuwoYnFhq6trp1UvJbMYBuU/qkg2ZAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779704904; c=relaxed/simple;
	bh=Q8eygPbI9MEPB3sANoEhQlfG88yGNqpLzr7LKQdnmBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRYJ3jnYisz7Etjfxr6CfEU/Wy7i57mzL7TsTTr5XTwSJ6jrbVdqFwOvN3G5xbMLusWjV2i7K8jT/HSBtzXm93M2poWqcUbl6vCuIsTQRZfPu5398u+buyPLKUHMvThKlAmbIGAQNo15vdhk3r3aC40mzK1TuZWVf0mIfRWNMCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=V6cbJu/z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tOI4FBMz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=V6cbJu/z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tOI4FBMz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="V6cbJu/z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tOI4FBMz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="V6cbJu/z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tOI4FBMz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1ED576AD63;
	Mon, 25 May 2026 10:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779704901;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=advq+YuhnnfyNsW+mr4ybbLLwBmm8bonYaHsEPmcRaU=;
	b=V6cbJu/zYb5X1edxbk1W762f8pal5d/Pa6eoNc6x/oVieIv4F9TL3G7T3GJud+NZ8LEXHE
	7unuGR9cECsK0wNj7ha/RJi0w4IshE0K+jJVhNEUE6NEKRUS95wHjpsmIqvXzxRxkOdhwy
	K/q1W2ltLj+0+KRGwM8XSiYUGmBcfaI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779704901;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=advq+YuhnnfyNsW+mr4ybbLLwBmm8bonYaHsEPmcRaU=;
	b=tOI4FBMzuDq1weVY4aWdN3pnodAZBm7jSyHPKiy+wuufENMZVNIXTZZdFzpCWxBqk2kqhC
	SL8IP9Dyftb9yDDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779704901;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=advq+YuhnnfyNsW+mr4ybbLLwBmm8bonYaHsEPmcRaU=;
	b=V6cbJu/zYb5X1edxbk1W762f8pal5d/Pa6eoNc6x/oVieIv4F9TL3G7T3GJud+NZ8LEXHE
	7unuGR9cECsK0wNj7ha/RJi0w4IshE0K+jJVhNEUE6NEKRUS95wHjpsmIqvXzxRxkOdhwy
	K/q1W2ltLj+0+KRGwM8XSiYUGmBcfaI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779704901;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=advq+YuhnnfyNsW+mr4ybbLLwBmm8bonYaHsEPmcRaU=;
	b=tOI4FBMzuDq1weVY4aWdN3pnodAZBm7jSyHPKiy+wuufENMZVNIXTZZdFzpCWxBqk2kqhC
	SL8IP9Dyftb9yDDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F133759BC7;
	Mon, 25 May 2026 10:28:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UXmoOkQkFGqLRQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 10:28:20 +0000
Date: Mon, 25 May 2026 12:28:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
Message-ID: <20260525102804.GW12792@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260522181411.2487732-1-willy@infradead.org>
 <20260522223855.GA29010@twin.jikos.cz>
 <ahDtLYinnFX5CBcE@casper.infradead.org>
 <20260523140601.GA183694@suse.cz>
 <ahNaEb4XOBPJIZDk@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahNaEb4XOBPJIZDk@casper.infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Sun, May 24, 2026 at 09:05:37PM +0100, Matthew Wilcox wrote:
> On Sat, May 23, 2026 at 04:06:01PM +0200, David Sterba wrote:
> > On Sat, May 23, 2026 at 12:56:29AM +0100, Matthew Wilcox wrote:
> > > On Sat, May 23, 2026 at 12:38:55AM +0200, David Sterba wrote:
> > > > On Fri, May 22, 2026 at 07:14:06PM +0100, Matthew Wilcox (Oracle) wrote:
> > > > > All of these were discovered through auditing the (mis)uses of the folio
> > > > > API throughout the kernel; I haven't been specifically reviewing btrfs,
> > > > > nor testing.
> > > > > 
> > > > > Matthew Wilcox (Oracle) (3):
> > > > >   Revert "btrfs: fix the file offset calculation inside
> > > > >     btrfs_decompress_buf2page()"
> > > > 
> > > > Why do you do the revert? It does not seem suitable for this case, we
> > > > use reverts if we want to get back to the original behaviour, or when
> > > > removing a patch from a long series to avoid a rebase. Merging the first
> > > > and second patch makes more sense to me.
> > > 
> > > The revert is for a patch which was merged into v6.16.  Since the fix
> > > for page_offset() was merged into v6.15, af566bdaff54 should never have
> > > been merged, and it can safely be reverted.
> > 
> > That it can be safely/cleanly reverted does not matter, you could say
> > that about many other patches. If the code was wrong then fix it in a
> > "forward" manner, no need for revert, namely for code from a year ago.
> 
> The patch should never have been merged.  It didn't make sense at
> the time.  Reverting it is the right approach.  There is no "forward"
> to move it to, other than converting the code to use folios instead of
> pages, which I'm not signing up for right now as that's more involved.

I've read the patches again and you're right. The part I overlooked was
that 2nd and 3rd didn't change the same code, so it's reverting to the
previous state (without a followup).

> The fact that it's been in for a year with nobody reporting the bug just
> shows the lack of 32-bit testing (and users).

Yeah, we don't have 32bit setups for testing and distros have been
gradually removing their 32bit versions and I don't remember any recent
report. In the past it's been mostly from 3rd party testing, not users.
