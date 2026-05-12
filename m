Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F963DC86D
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607329; cv=none; b=b3Udnow8AYhqbklgYRcpXRHdtp0oIWMn8jePSobhPoZoMvqmb0T9e4vHueL42UUN3gy+0+DjFh/cUFqGEDvZJzWtu0qCTbX7dEKyHZqkFFy6RatUp4RCWiKELpBSxWbUNPjzvFfRMyljSdvgbDFoyQNbsX6Y5qNIYpcW/51o3/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607329; c=relaxed/simple;
	bh=nDWPzYH9MhON6AmEkgJQI9LLViEVtbjDwSPtnDd8GSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMVcbH34LD1klAVKJyDAPJwQlp8H9avkk9Ffkmweb0Hf0hOqk5RidXFCjqNbW4sA6z0DnIayTHZ3Ez1QI/1kO08CSt7tmizDWcBSmtHxAWhJi9Fwyep8pASniBkCnHE7VwZLbdWuut7PDpS4ReAFv6W6dFBdmjW6dLMriMAFwoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UD/jjqDy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0abc2jqO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UD/jjqDy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0abc2jqO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UD/jjqDy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0abc2jqO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UD/jjqDy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0abc2jqO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 399126B16D;
	Tue, 12 May 2026 17:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778607326;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PxtZMEHIr+GRXZUkZG63Zsk6iE5I8cc2EfIYoHG+6GI=;
	b=UD/jjqDyadYNAP8rSUGqD1XRqEYyK4vOrtniZF4kS6il8APXNjEnMWJb+by5mrkeEniqfJ
	c7BRvhiVEOnMoivmpeyYB4CRRGUnXYPhIXvV5NKRY9NfzLj5KZgVQNZFHu8dmZkOeMGhMu
	wzdHkbPx8DPrZ0dJXkP5smgGrcwpsJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778607326;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PxtZMEHIr+GRXZUkZG63Zsk6iE5I8cc2EfIYoHG+6GI=;
	b=0abc2jqOo2t5PAr3i2XJWRpu+uoeHXGQTzs7ecZZmeMirnQBUpzuItUTIPgEOfM5biOG0v
	wXz3dUqUxT+1shBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778607326;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PxtZMEHIr+GRXZUkZG63Zsk6iE5I8cc2EfIYoHG+6GI=;
	b=UD/jjqDyadYNAP8rSUGqD1XRqEYyK4vOrtniZF4kS6il8APXNjEnMWJb+by5mrkeEniqfJ
	c7BRvhiVEOnMoivmpeyYB4CRRGUnXYPhIXvV5NKRY9NfzLj5KZgVQNZFHu8dmZkOeMGhMu
	wzdHkbPx8DPrZ0dJXkP5smgGrcwpsJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778607326;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PxtZMEHIr+GRXZUkZG63Zsk6iE5I8cc2EfIYoHG+6GI=;
	b=0abc2jqOo2t5PAr3i2XJWRpu+uoeHXGQTzs7ecZZmeMirnQBUpzuItUTIPgEOfM5biOG0v
	wXz3dUqUxT+1shBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1AADD593A9;
	Tue, 12 May 2026 17:35:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LdrLBd5kA2oUTgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 12 May 2026 17:35:26 +0000
Date: Tue, 12 May 2026 19:35:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] btrfs: remove folio ordered flag
Message-ID: <20260512173524.GL2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1778131118.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1778131118.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Thu, May 07, 2026 at 02:59:16PM +0930, Qu Wenruo wrote:
> [CHANGELOG]
> RFC->v1:
> - Replace the folio_test_ordered() inside extent_writepage_io()
>   Now do the check inside alloc_new_bio(), which is already doing the OE
>   search.
> 
>   Now we can detect dirty blocks without an OE at per-block level, much
>   better than the previous per-folio level checks, and without any extra
>   overhead.
> 
> Btrfs has a long history using an internal folio flag called ordered,
> which is to indicate if an fs block is covered by an ordered extent.
> 
> However this means we need to synchronize between ordered extents, which
> are managed by a per-inode ordered tree, and folio flag/subpage bitmap.
> 
> Furthermore with huge folio support, the ordered bitmap can be as large
> as 64 bytes (512 bits), which is not a small amount.
> 
> The series is going to remove folio ordered flag completely, along with
> the ordered subpage bitmap.
> 
> Most call sites of folio_test_ordered() are just inside ASSERT()s, so
> it's not too hard to remove them.
> 
> There are two call sites that utilizing *_folio_test_ordered():
> 
> - Inside extent_writepage_io()
>   The warning left by the legacy COW fixup mechanism.
>   The 1st patch is to introduce a more reliable way to detect dirty
>   blocks without an OE, other than checking the folio ordered flag, now
>   it's doing a per-block level check without introducing new overhead.
> 
> - Inside btrfs_invalidate_folio()
>   We use ordered flag to check if we can skip an ordered extent.
>   This is worked around by using the fact that we have waited for
>   writeback of the folio, so that endio should have already finished for
>   the writeback range. Then check dirty flags to determine if we can skip
>   the OE range.
> 
>   To get a reliable dirty flag for both sub-folio and full-folio cases, we
>   can not clear the folio dirty flag early, so the 2nd patch is
>   introduced to change the folio dirty flag clearing timing, then the
>   3rd patch can remove the folio_test_ordered() usage.
> 
> Then the 4th patch is to remove the remaining folio_test_ordered()
> usage, and finally we can remove the whole ordered flag/subpage bitmap
> completely.
> 
> I tried to hide the ordered flag/bitmap behind DEBUG, but unfortunately
> the subpage bitmap macros are not that easy to be tweaked to handle
> conditional ordered flags.
> 
> So the ordered flag/bitmap must be either there, or be completely gone.
> I hope enough test runs will cover the removed ASSERT()s.
> 
> Qu Wenruo (5):
>   btrfs: detect dirty blocks without an ordered extent more reliably
>   btrfs: unify folio dirty flag clearing
>   btrfs: use dirty flag to check if an ordered extent needs to be
>     truncated
>   btrfs: remove folio_test_ordered() usage
>   btrfs: remove folio ordered flag and subpage bitmap

Please add it to for-next.
