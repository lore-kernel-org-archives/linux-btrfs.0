Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A29C563FD6;
	Wed,  9 Sep 2026 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962660; cv=none; b=R5pgohQvaZEZVAypHB1pXM9E0InLQQHHpBY+JYnK1+ZreBeQF0mSnfUi53U8wxwKLQNM77kOQbji47/W5w561M38EAe1dMicP887IZWMNAkgIRlNH+eQjVitr5ncTSfMvBPkPUWYp1xlp3D3hJj8MZUIr94J1/1msM8w2uIRX1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962660; c=relaxed/simple;
	bh=3rs8b4Ko2wVhQJJe5ZlB4Fq5AtYvbtQpcPHM7TIxMrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o8mxUOKCs+qGsglfDo6JgwRiy284+4pwYDATGVFgjoZD5eOL8Rn7Id1/wqVUsC9OeznVrT2rkYhGoOQ5alssY7l+eFNBNLvhItzW5PW1Eu1rTcbh7pR3g6e+g0c/dVD6NyDBU9qQGBkH/GNwbIAo5qpVNqwtEUXsrp5oNLfhuGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mKfRUM5z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AxUmGF07; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KgLizKET; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3Mz08+BI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mKfRUM5z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AxUmGF07";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KgLizKET";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3Mz08+BI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 255611FF84;
	Wed,  9 Sep 2026 14:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788962652;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORmuwsP/Vox4hcpH4q82OYzLsLdhV49jjKM0EmIfzZ4=;
	b=mKfRUM5zinivaWajXQuquchWM2Uy+Eka1GnQWWf/EdGyVdXhz247zJD0tmTex06rOGRlho
	GwZyGCjHw7wnw3TXrzWgFFaJUQHtK+ygOvkHecoriu+QooS/9R7AL6J7uGLacn5BEgVJ5I
	9wMkos9JK7s6yUmIpU+4M/xTFTfoWps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788962652;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORmuwsP/Vox4hcpH4q82OYzLsLdhV49jjKM0EmIfzZ4=;
	b=AxUmGF07NQczlpuT6VQyRM62cShgLOcOCoffP6LSXaxmHmlcJuaPkPTL3itxxZWnGnQXh+
	nxCqEX+4yWSlEICA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KgLizKET;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3Mz08+BI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788962648;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORmuwsP/Vox4hcpH4q82OYzLsLdhV49jjKM0EmIfzZ4=;
	b=KgLizKETrG2DrL7D8CPqHYwrW/OXIJNYHs+T28QrO0CCXXgBRRdtky8xgRmm17gfGDzSmi
	yOzb7X100DGXJswHotjPFJsUDC3sHiTDnpke+/spc1ao1QSKIhFpyci3lJecZLHVSmHu2M
	ZdLeYe5yv7dxQ+Ool8RcgwORPki9FFM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788962648;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORmuwsP/Vox4hcpH4q82OYzLsLdhV49jjKM0EmIfzZ4=;
	b=3Mz08+BI5d/JUKY+fn4nOl07hO4pqKTC0FkzlTjiQp0DvbGTbP4kC073TS+IOgfJpEV6UB
	i5w+p/UtlCcbngCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF49E13185;
	Wed,  9 Sep 2026 14:04:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W4hUNldnoWqBHQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 09 Sep 2026 14:04:07 +0000
Date: Wed, 9 Sep 2026 16:03:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] btrfs: convert some struct page users to folios
Message-ID: <20260909140351.GL9053@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
 <f4a415f9-1e3a-4b26-a2a4-61bcc98eb39f@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f4a415f9-1e3a-4b26-a2a4-61bcc98eb39f@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 255611FF84
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid,suse.cz:replyto,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Wed, Sep 09, 2026 at 03:40:47PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/9/8 05:49, Tal Zussman 写道:
> > This series converts three areas of btrfs that still use struct page:
> > 
> > 1. The extent-io tests. test_find_delalloc() uses the page APIs, and the
> >     extent buffer memory checks assume one page per folio.
> > 
> > 2. Compression. btrfs_compr_pool_scan() walks the folio pool as struct
> >     page, the last use of page->lru in btrfs, and the heuristic sampler
> >     is the last caller of find_get_page().
> > 
> > 3. Super block reads. btrfs_read_disk_super() and the zoned super block
> >     log comparison are the last page cache lookups by page in btrfs.
> > 
> > Tested with KASAN, lockdep, DEBUG_VM and the btrfs selftests enabled.
> > xfstests' compress group under compress=zstd and the btrfs group both
> > pass.
> 
> Now pushed to for-next branch.

Tal, please send the cast removal I asked for in patch 5 separately. Thanks.
