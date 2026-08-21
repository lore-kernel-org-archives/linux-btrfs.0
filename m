Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F5F372B5E;
	Fri, 21 Aug 2026 16:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787328140; cv=none; b=WbYu9lWnvlJADZtDZUs9aVwxnwIHE5Tw2Wx4JTnJmzGdBj19C4LqWhX1HEvdXR1Jyit6m8gWtL/lRecgGWa+Ewnpuh6OkDMOThQhY3bUwTDFNcm/UFqgAo/1iZadwxXV3vBg1W1TQAbs/J1XMjnl2KKhn+36BUbguch5kZE5vfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787328140; c=relaxed/simple;
	bh=ESkC3Rde5D8pov44/P5BrSIGRORhcM94NLbqclr1hYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxsj+Zl1jtJ4wCtbZjngYlHr1+rnVbyLdPUsyIoRwtE1THQ5otCLQL1h86MqGlEyQpiq7bqtP7yRIpZXa3u34YWs+HXX7N4pqvyPC6dQKzQc3robFO1sUIQ7ABsaaNja9w/kltKM42cClIANFyBm3Me6KZoDo+N10ZKUGFoBZL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nfq2oyeB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qsziZ4Nc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Nxvamtne; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XYvBlyCw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nfq2oyeB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qsziZ4Nc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Nxvamtne";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XYvBlyCw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7DAAF3F63;
	Fri, 21 Aug 2026 16:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787328126;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ijhBKBq6y9Jmu20hK56ZxvM19gWHEFBKJAIe3E584U=;
	b=nfq2oyeB1HCwb2FFncMrUDFB55u0Bo2aRPwVeK+R0FmdR4AZRB/svjC0wHRy/KFPrhFIPP
	1bqebu42+Keo0kAfdpyUur9oUiKYp7Dea8tDficL4cU2EVMFn0FsIus9hWNWVSRfsASyaB
	GyWXO1VUhB4ANmyA4QdJRUwlzUOVutI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787328126;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ijhBKBq6y9Jmu20hK56ZxvM19gWHEFBKJAIe3E584U=;
	b=qsziZ4Nc6lUraMwsK49oIP+C6hLMoK1Ewpcf4fwk4Nqf7GyU//uOufSVgZDHyX/Y5UjpoF
	2S+lDoDYKsfCwZDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787328122;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ijhBKBq6y9Jmu20hK56ZxvM19gWHEFBKJAIe3E584U=;
	b=NxvamtneCvh2QUd7D1ZfZ7uPUphMQRCfBC/kJwS0xfA+yK5nWYzLJTYkOQbJV1qBiR8j/W
	iD0ja4Vv04ul+uCjSHvYnCtcfg3qKDkpFX7uxYzhCtbSFpbKUQND+9Ho0a/67XefTJQbtN
	u893+tNcu7QNzhEuzniK1dKhMzrZx80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787328122;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ijhBKBq6y9Jmu20hK56ZxvM19gWHEFBKJAIe3E584U=;
	b=XYvBlyCwxmP3DUbCnUjEw2pc+fVKxR0S3ryN3HZCkEhjNtKJqr1MpJIW5Q2FqOe5DNnsom
	RRKguKCKzxawUoAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 666DF26F8;
	Fri, 21 Aug 2026 16:02:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AZTVGHp2iGouKwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 21 Aug 2026 16:02:02 +0000
Date: Fri, 21 Aug 2026 18:02:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: clm@fb.com, dsterba@suse.com, boris@bur.io, willy@infradead.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] btrfs: retry verity reads for not-uptodate Merkle
 folios
Message-ID: <20260821160201.GC9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260817054837.1740374-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817054837.1740374-1-chenyichong@uniontech.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-3.98 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.18)[-0.906];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -3.98
X-Spam-Level: 

On Mon, Aug 17, 2026 at 01:48:37PM +0800, Yichong Chen wrote:
> btrfs_read_merkle_tree_page() can find a folio in the mapping that is not
> uptodate.  After taking the folio lock, the current code treats that state
> as a read error and returns -EIO.
> 
> That can make a previous transient read failure sticky.  If the failed read
> left a not-uptodate folio in the mapping, later callers find that folio and
> fail instead of retrying the read.
> 
> Keep the existing page-cache insertion and locking order, but retry the
> Merkle item read when a not-uptodate folio is found in the mapping.  Also
> unlock the folio when read_key_bytes() fails so that a later caller can
> lock it and retry the read.
> 
> Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
> v5:
> - Drop the Fixes tag, as Matthew pointed out that 06ed09351b67 did not
>   introduce the original !uptodate-page handling.

This was merged as commit 8cc569696dac51 ("btrfs: retry verity reads for
not-uptodate Merkle folios")
