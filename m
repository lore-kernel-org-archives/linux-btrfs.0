Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F09E26D4DD
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 14:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779545169; cv=none; b=t16hDr7yLJj3hAwKAJxhv0OSSgPIAKJMjhDsnthH2Ru6d81HwvySc0wQ965bsgVnuZlwzv9SF8/YsyDat9F/CL0EsHhySrHuIhJC/DGg8op34cQTqnAYsak5kHRWiy8N59C/lpw+wA8FZ0QMfJ9sL37XlZx/gB4hY6wdBfa8imE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779545169; c=relaxed/simple;
	bh=t+XW+g5JcHB7ZU29L0MkmzCSa7xoE2ajVQzI33Nm2bQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=suvnV22foqCtuTCC8RLe+hE6Ax20XvFGaSezPx6NvnYqaRB/X6efYAhZJNeVoPlhcVzxmVzGAkWOCaNNSTMrIhPH59f7FVqYEMWZp9L3/bBh+ihoaiC11iU4d707tDtCH9eyOIeoN3wRfmjoV9vhdcytlj2JjwPei7mJ9rqLiDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QTAmspV4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=B0arAqVQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QTAmspV4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=B0arAqVQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QTAmspV4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="B0arAqVQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QTAmspV4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="B0arAqVQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6DB263BDB;
	Sat, 23 May 2026 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779545166;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R14rckRkNox2QsdBBLDxJJDwey8MvDP3YKuXQnqdDjs=;
	b=QTAmspV49b9gvulku1BFZdBr/89Q+ZH/deMKzxHtyFuCKrJLNa7uNaTsVBp71WSNwuk9Jb
	HUFRdveqBqr/2/xAmSqXx3Xop4B/DQ6viVJXzv2SYSua06OmKVrx5IbPZSQfA0mrBHaVcx
	rGDP4neb2OabnYJj3g+Tv2UUyQ/aafY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779545166;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R14rckRkNox2QsdBBLDxJJDwey8MvDP3YKuXQnqdDjs=;
	b=B0arAqVQw5eGIJ2pX67Ijg7ZL1z1eeocG8SfSAn2kBr3o/JA3pEAJ3nt9+AFO+fBPTpsIH
	th96mMLSEP4iI2Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779545166;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R14rckRkNox2QsdBBLDxJJDwey8MvDP3YKuXQnqdDjs=;
	b=QTAmspV49b9gvulku1BFZdBr/89Q+ZH/deMKzxHtyFuCKrJLNa7uNaTsVBp71WSNwuk9Jb
	HUFRdveqBqr/2/xAmSqXx3Xop4B/DQ6viVJXzv2SYSua06OmKVrx5IbPZSQfA0mrBHaVcx
	rGDP4neb2OabnYJj3g+Tv2UUyQ/aafY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779545166;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R14rckRkNox2QsdBBLDxJJDwey8MvDP3YKuXQnqdDjs=;
	b=B0arAqVQw5eGIJ2pX67Ijg7ZL1z1eeocG8SfSAn2kBr3o/JA3pEAJ3nt9+AFO+fBPTpsIH
	th96mMLSEP4iI2Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A3D24593A8;
	Sat, 23 May 2026 14:06:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1m95J060EWqiHQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 23 May 2026 14:06:06 +0000
Date: Sat, 23 May 2026 16:06:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
Message-ID: <20260523140601.GA183694@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260522181411.2487732-1-willy@infradead.org>
 <20260522223855.GA29010@twin.jikos.cz>
 <ahDtLYinnFX5CBcE@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahDtLYinnFX5CBcE@casper.infradead.org>
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

On Sat, May 23, 2026 at 12:56:29AM +0100, Matthew Wilcox wrote:
> On Sat, May 23, 2026 at 12:38:55AM +0200, David Sterba wrote:
> > On Fri, May 22, 2026 at 07:14:06PM +0100, Matthew Wilcox (Oracle) wrote:
> > > All of these were discovered through auditing the (mis)uses of the folio
> > > API throughout the kernel; I haven't been specifically reviewing btrfs,
> > > nor testing.
> > > 
> > > Matthew Wilcox (Oracle) (3):
> > >   Revert "btrfs: fix the file offset calculation inside
> > >     btrfs_decompress_buf2page()"
> > 
> > Why do you do the revert? It does not seem suitable for this case, we
> > use reverts if we want to get back to the original behaviour, or when
> > removing a patch from a long series to avoid a rebase. Merging the first
> > and second patch makes more sense to me.
> 
> The revert is for a patch which was merged into v6.16.  Since the fix
> for page_offset() was merged into v6.15, af566bdaff54 should never have
> been merged, and it can safely be reverted.

That it can be safely/cleanly reverted does not matter, you could say
that about many other patches. If the code was wrong then fix it in a
"forward" manner, no need for revert, namely for code from a year ago.
