Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFA9286417
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 14:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274887; cv=none; b=mXbtwj8kUYGTISJdY0XSuH1gcvsY5QDDnViySGJTydM4ZhPS3ttbRAKfw14gU07O5intIylZHNGhxqhnyWxhieEwH4mhIbvfkrNyWpVxUn7uN7h2BMxciZsFk233xCHf5AdWJbjXCpjphbpWcj925FocCkwFTi1dSEoUT5pEZmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274887; c=relaxed/simple;
	bh=kcTYSu7dPO0FXZjwiV57Xhv1b8m6x8FgvDU7lPHXgMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m7gFZqvEPepI3tm8Lt3HVzjglePZr6fyW17VikdE/qQMZVRhC7Z5fKRmy0W4LXEOZJz5PpJJZZZVIwfIALtqCGZf94j2y4linxx7J6Xtnvn458YxDLz0bmLtMZbkTiPKNI33+OPTsKHDQZfPLz4s3As+xQjumlpg0NcPvRo9A7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=13swHOHs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JYtDmdJM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=13swHOHs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JYtDmdJM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="13swHOHs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JYtDmdJM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="13swHOHs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JYtDmdJM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6B1055BE62;
	Mon, 23 Mar 2026 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774274884;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x6+4OoAkf3Jz/tQGhHTTRyC/8Jz5P778knW6ePE8rjs=;
	b=13swHOHsm1PUZG4YYrknpffalpeuh6gBQLJuppAwFPy8iyULL6DMj1diQvFw3rwrK1kki1
	g3Qp9NH5+oHv9wXX+qxF+3Vm3XlPFIICh7EVrrb9s2wW1+pIm5U5F+xHVK9IHNIP3NHvOp
	UCmlLPakflbQ4lJo1YSwd+sfEmJ5+5k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774274884;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x6+4OoAkf3Jz/tQGhHTTRyC/8Jz5P778knW6ePE8rjs=;
	b=JYtDmdJMJMM0cwSwBMiy8O2cWG5FtMtETYYpe5veNzoGFKfXG643qogKfAry8fXBsIXTuy
	WQQt8lglRAqSKdDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=13swHOHs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JYtDmdJM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774274884;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x6+4OoAkf3Jz/tQGhHTTRyC/8Jz5P778knW6ePE8rjs=;
	b=13swHOHsm1PUZG4YYrknpffalpeuh6gBQLJuppAwFPy8iyULL6DMj1diQvFw3rwrK1kki1
	g3Qp9NH5+oHv9wXX+qxF+3Vm3XlPFIICh7EVrrb9s2wW1+pIm5U5F+xHVK9IHNIP3NHvOp
	UCmlLPakflbQ4lJo1YSwd+sfEmJ5+5k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774274884;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x6+4OoAkf3Jz/tQGhHTTRyC/8Jz5P778knW6ePE8rjs=;
	b=JYtDmdJMJMM0cwSwBMiy8O2cWG5FtMtETYYpe5veNzoGFKfXG643qogKfAry8fXBsIXTuy
	WQQt8lglRAqSKdDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50E1D438F4;
	Mon, 23 Mar 2026 14:08:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +/OTE0RJwWmqCAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 14:08:04 +0000
Date: Mon, 23 Mar 2026 15:07:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Dave Chen <davechen@synology.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, cccheng@synology.com,
	robbieko@synology.com
Subject: Re: [PATCH] btrfs: fix unnecessary flush on close when truncating
 zero-sized files
Message-ID: <20260323140748.GK5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260323034322.105163-1-davechen@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323034322.105163-1-davechen@synology.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 6B1055BE62

On Mon, Mar 23, 2026 at 11:43:22AM +0800, Dave Chen wrote:
> In btrfs_setsize(), when a file is truncated to size 0, the
> BTRFS_INODE_FLUSH_ON_CLOSE flag is unconditionally set to ensure
> pending writes get flushed on close. This flag was designed to protect
> the "truncate-then-rewrite" pattern, where an application truncates a
> file with existing data down to zero and writes new content, ensuring
> the new data reaches disk on close.
> 
> However, when a file already has a size of 0 (e.g., a newly created
> file opened with O_CREAT | O_TRUNC), oldsize and newsize are both 0.
> In this case, setting BTRFS_INODE_FLUSH_ON_CLOSE is unnecessary because
> no "good data" was truncated away. The subsequent filemap_flush() in
> btrfs_release_file() then triggers avoidable writeback that disrupts
> the normal delayed writeback batching, adding I/O overhead.

Does this have a measurable impact? Truncating 0 -> 0 without any
intermediate writes could happen but I kind of doubt it's worth
optimizing. I'm not against adding the patch but would like to know if
it's fixing some problem for you. Thanks.
