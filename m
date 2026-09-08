Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A836E538D90
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 15:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788882021; cv=none; b=lczM90v4Gn2lNUmFQV1hJArmWGSbqDeSBbbu+R4m9lP1FGC+ztFGudCdc1iVrO7U1LxQFqL3vEZOLfct5cc1I+jfjUmR40YbgYJkYM4H3njJ8YpS8erjkue14Bo4qTLm+vwZn4oqL2xzVu38UbcN8bdCC+7zOhptFLNSiBHe/Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788882021; c=relaxed/simple;
	bh=5mf71CsDSjz3HYYtKzoV1pLCIS9XG1Kdy4GK+tsa7j0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+U7wevVBOg3q5s+haFnn7A7xIHy0JBTpbWayyae9WRAHuhpHiyyw8C/DtgHG3fv5mhN1cEInPGczUa32KGfwthncCmDQocApMLGTsPH0v+JkwFKOdF6atid7tvHw+n+sXXylFuxmxCf/8ala6n6I/vesxSB51Km1zOhOKqczig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FfTbFxWp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mam1m9AS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=o7Hnq6MG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RVtg8IVG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FfTbFxWp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mam1m9AS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="o7Hnq6MG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RVtg8IVG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8B501F82E;
	Tue,  8 Sep 2026 15:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788882011;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vC9ruSUkMMoRAEL6VxKBzLbg7A7UQIuxuWOJQpKadmw=;
	b=FfTbFxWp4I1SVhUYORjbLVsar4/0THDqox7U3Mrz7oNuPNrf2nGSOHXNfMyfJ0egxFB16D
	mr0Xv1Q+RBrDFGcDgkWYZkDAZsV9Ik9UOknNQ0fK1C0OG+sLuHT9BCMSrRVPrp68aM9TAX
	qAYef/kzxKpsaZf1uSVeGBFWJ7ATEuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788882011;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vC9ruSUkMMoRAEL6VxKBzLbg7A7UQIuxuWOJQpKadmw=;
	b=mam1m9ASTsJiC3Y1DnCNlGhS/6u2IqqiA5/9Q058h6lar9ON2PtvrwiykM9nUHhPuef5cA
	Y90+kTN8M8T0bvCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788882010;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vC9ruSUkMMoRAEL6VxKBzLbg7A7UQIuxuWOJQpKadmw=;
	b=o7Hnq6MGkK5B18qR+LKplWr3uwX4hKYCkGeuMF7OC5QH6t9aoARnXHxPlmYVPbGDYH+CWi
	+cnppu8qm4LooGgmHmV8AaZQp+GFkgF7UNpjFtRjnRMIjcdc3tQVzaCzx1paIKbDcBZ8+P
	LVK1FnRx9fgf1cGaDKaJjP+25dTSZvc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788882010;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vC9ruSUkMMoRAEL6VxKBzLbg7A7UQIuxuWOJQpKadmw=;
	b=RVtg8IVG74A2UGGjfIN8/dLsDyefIbPDiseaJsGkNr6iplxbYCnav24xp7y5U5OGJqmzBy
	e+r7QN8jQHLW8ICg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B730313332;
	Tue,  8 Sep 2026 15:40:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5MmJLFosoGoMUgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 08 Sep 2026 15:40:10 +0000
Date: Tue, 8 Sep 2026 17:40:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: use kvmalloc() for allocations that can be
 larger than page size
Message-ID: <20260908154009.GD9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1788851649.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1788851649.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spam-Score: -8.00
X-Spam-Flag: NO
X-Spamd-Result: default: False [-8.00 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	URIBL_BLOCKED(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Tue, Sep 08, 2026 at 04:45:38PM +0930, Qu Wenruo wrote:
> With the experimental bs > ps support, btrfs can hit several kmalloc()
> call sites requesting physically contiguous memory that are larger
> than a page, sometimes such allocation can be as large as 64K.
> 
> This means those kmalloc() has a much higher chance to fail if the
> system's available memory is very fragmented on 4K page sized systems.
> 
> And there is already a report that with 64K nodesize, even bs == ps we
> can still hit such kmalloc() failure.
> (https://lore.kernel.org/linux-btrfs/250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com/)
> 
> But we do not really require any physically contiguous memory for a lot
> of kmalloc() call sites, we just want a buffer to save some data
> temporarily.
> 
> So change those possible larger than page size kmalloc() to kvmalloc()
> to reduce the chance of memory allocation failure.
> 
> And since kvmalloc() falls back to kmalloc() if the allocation is not
> larger than a page, it means for most cases it's still calling
> kmalloc(), not affecting the most common cases anyway.

I've asked around, confirming that virtual mappings and allocations are
not a problem on 64bit systems so we can do the kvmalloc as needed.

> The first patch is a special case that affects the existing bs == ps
> cases already.
> The second one only affects bs > ps cases.
> The third one mostly affects bs > ps cases, but can still improve S390's
> hardware accelerated path with 4K page size.

If it's for hardware acceleration the memory can be DMAd then virtual
memory may not work. I haven't found any constraints for the s390
compression, it's a CPU instruction. It's quite possible assume there
are no limitation or the wrapper code falls back to software
compression.
