Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B953438C2A7
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 22:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779489544; cv=none; b=CjFp/40xrSwtkcO3ItFwTuSVHUwR3LDvyTJyyIOB9BNFqeWSuWZvBQyJWrmbSRfVYr8xX/eYGuVFxOGxI2WHARO5vqLhApARpIkEzCzcZyvfqekShcFxaSNgE1EFruegzv7JuJRf6QG8/9CHJyvGr7dG158RyjJwye6r5m6C15Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779489544; c=relaxed/simple;
	bh=aYu5O6vknhbn9Su9Q8J1vq9kxgbUZxSdAZLZ+bbMgvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fu+/JYOTuW5pwnZE3XaWee+jBe2Kh/DzZaSCcKeKEKv08GEAfMJdLdL2/cq/WmAK0kHdEXXFofJFOhiI6MwkK/3KOls1iDXV2QxM8FDatIWVME2Z0OofoswKw+SIL3I8eH8TVNbM4k8XxHt4X0lJUcmNu9wz9wW5BYmpop8FETo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nccy8dSp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jaUqpp0f; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nccy8dSp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jaUqpp0f; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nccy8dSp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jaUqpp0f";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nccy8dSp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jaUqpp0f"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A66C56C0D3;
	Fri, 22 May 2026 22:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779489540;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H9WvBJDj991PC50czCZk8DBKpDYXBfIDeh0IRX1rfLM=;
	b=nccy8dSpZdwEuhPwnFB5A90Hhbgb0YU4pv5KzTwanAuiOA1ETMn850M1oPuBiLyAdBo+tv
	kpwPBxYw3wmvjgKJ7sODzGn2tyZ5Yc3b0aJvpqLPG4r1fKt7BWCaBIgpsIJNF4AfTveaAY
	NPGmwJJHeUZcuyl7CBMLaJDHlUJodPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779489540;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H9WvBJDj991PC50czCZk8DBKpDYXBfIDeh0IRX1rfLM=;
	b=jaUqpp0fpicKxfPA5bWWoBs5S9PbILDbdVp2jDQgrtm/BSzSeK+VNhUumL6jPJ0t90DSti
	BibNuX1Az+il9+CA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nccy8dSp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jaUqpp0f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779489540;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H9WvBJDj991PC50czCZk8DBKpDYXBfIDeh0IRX1rfLM=;
	b=nccy8dSpZdwEuhPwnFB5A90Hhbgb0YU4pv5KzTwanAuiOA1ETMn850M1oPuBiLyAdBo+tv
	kpwPBxYw3wmvjgKJ7sODzGn2tyZ5Yc3b0aJvpqLPG4r1fKt7BWCaBIgpsIJNF4AfTveaAY
	NPGmwJJHeUZcuyl7CBMLaJDHlUJodPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779489540;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H9WvBJDj991PC50czCZk8DBKpDYXBfIDeh0IRX1rfLM=;
	b=jaUqpp0fpicKxfPA5bWWoBs5S9PbILDbdVp2jDQgrtm/BSzSeK+VNhUumL6jPJ0t90DSti
	BibNuX1Az+il9+CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 86251593A8;
	Fri, 22 May 2026 22:39:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vjcaIATbEGpAPgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 22 May 2026 22:39:00 +0000
Date: Sat, 23 May 2026 00:38:55 +0200
From: David Sterba <dsterba@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
Message-ID: <20260522223855.GA29010@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260522181411.2487732-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522181411.2487732-1-willy@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Queue-Id: A66C56C0D3
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	internal_greylist_whitelist(0.00)[2a07:de40:b281:104:10:150:64:97];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Fri, May 22, 2026 at 07:14:06PM +0100, Matthew Wilcox (Oracle) wrote:
> All of these were discovered through auditing the (mis)uses of the folio
> API throughout the kernel; I haven't been specifically reviewing btrfs,
> nor testing.
> 
> Matthew Wilcox (Oracle) (3):
>   Revert "btrfs: fix the file offset calculation inside
>     btrfs_decompress_buf2page()"

Why do you do the revert? It does not seem suitable for this case, we
use reverts if we want to get back to the original behaviour, or when
removing a patch from a long series to avoid a rebase. Merging the first
and second patch makes more sense to me.
