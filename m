Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE3A448B9D;
	Mon, 17 Aug 2026 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786982228; cv=none; b=AMtHAqOaw+r8/5u2ZXtmvwqCVnLt0whXTPvAmUzeXAsDrVHm7IDzQD2021JnNxfsBrek4FEH4tsI+KdQGScrhofo33mMFCqXf5JcrHGzNEcI4DbaIjAy9HyfzYUauPv9ustEW5Q1FjEUhlF8oiKY78arDxWFRR/zX63MHZ2C6fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786982228; c=relaxed/simple;
	bh=IrKCjYc4Rmsa45E5XjTGt04B/1aRkCsMhxslWtv2yUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CVsk2e7EoQ0ZcrBFXt8xqENH4sue/gKvpDkrJ+rqXxkT4wby390iSKbQPmHfPjxHKMII5cU4ibGIZo6BUYz2iYX2lM3WQEi3uTA4RxuoCPRsRTP2ll7U3g6iNLLberY0b2fqnww8yrawgBeFiAaZBk9KN7dee+VPUt0JT57wObs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZJSlEVDG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DcLq16KS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IXRWYcAa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9gPwYX+g; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZJSlEVDG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DcLq16KS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IXRWYcAa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9gPwYX+g"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4B4933E06;
	Mon, 17 Aug 2026 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786982221;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wHdSOfPy90IFQJytN7lL8FFAWR/v2A0jnUPM/K9Uvbs=;
	b=ZJSlEVDGrCb/GtfsWEZeHSeA4hiSFDFKapSj1SV7d7dTAzL+gZlmGd6HJMbc2FiZ70bLCT
	1+NYGfK/lob50xgKaH8WLL8qWxSsE8KXiQ7t83fivNo/61l4qjI63fSD9jaT3fYw82Cz/g
	GHVmWI6ZvcZul8AcsVFumUX66vQQhIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786982221;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wHdSOfPy90IFQJytN7lL8FFAWR/v2A0jnUPM/K9Uvbs=;
	b=DcLq16KSNtw+msnbIEv0etepUV6CYD7sDNq5g3QnkwJ8HQ9/st6EEAjQVfaYXH3yx9pi0W
	KwG+fpj6JLID1tBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IXRWYcAa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9gPwYX+g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786982217;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wHdSOfPy90IFQJytN7lL8FFAWR/v2A0jnUPM/K9Uvbs=;
	b=IXRWYcAaOh4tqptoPc1yNVetWgCXoLfLIV3vgUJm+8/ZT2pbbV1MeGm0udtA1jW4O4BIqL
	K+wrH9xtMNA0XsJPUwT68kfg9Az+HgoiyBn1hzWA5lnLFkFeLwzfyeclmkyo6CKwzc4UFL
	RK2FP+vxk2ngadouvXnjbzkW5RpxBdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786982217;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wHdSOfPy90IFQJytN7lL8FFAWR/v2A0jnUPM/K9Uvbs=;
	b=9gPwYX+gcD13uUdzOcGtgb7E3sN6SYqmrtHZizna3dyH2jAxIzYAyaS5AnDLvQse301e2E
	sTBazfL7eEb55JBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33B0C79544;
	Mon, 17 Aug 2026 15:56:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VdNmDEkvg2oMWwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 17 Aug 2026 15:56:57 +0000
Date: Mon, 17 Aug 2026 17:56:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Yichong Chen <chenyichong@uniontech.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, Boris Burkov <boris@bur.io>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: retry verity reads for not-uptodate Merkle
 folios
Message-ID: <20260817155652.GC54102@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260722025435.1493093-1-chenyichong@uniontech.com>
 <aoJ6ZP-jKQoWwuXT@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoJ6ZP-jKQoWwuXT@casper.infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4B4933E06
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:mid,suse.cz:dkim,suse.cz:replyto];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Mon, Aug 17, 2026 at 04:05:08AM +0100, Matthew Wilcox wrote:
> On Wed, Jul 22, 2026 at 10:54:35AM +0800, Yichong Chen wrote:
> > btrfs_read_merkle_tree_page() can find a folio in the mapping that is not
> > uptodate.  After taking the folio lock, the current code treats that state
> > as a read error and returns -EIO.
> > 
> > That can make a previous transient read failure sticky.  If the failed read
> > left a not-uptodate folio in the mapping, later callers find that folio and
> > fail instead of retrying the read.
> > 
> > Keep the existing page-cache insertion and locking order, but retry the
> > Merkle item read when a not-uptodate folio is found in the mapping.  Also
> > unlock the folio when read_key_bytes() fails so that a later caller can
> > lock it and retry the read.
> > 
> > Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
> 
> I object to this Fixes line.  I didn't introduce this problem; it was
> already there before 06ed09351b67.

You're right, however we need to keep the patch as-is because that would
require a rebase and delay sending the main 7.3 pull request, it's below
22 patches.
