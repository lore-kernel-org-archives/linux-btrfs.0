Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE17330B11
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 11:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784546368; cv=none; b=T1GEPy173HRuwJv6xRlQsA1CZluzh8sa1sPk1mQ1TQUXoCjyYSICsRX13PV6qXgitx0ZmJtKU/nzEWU/Q28FwfLM3MKmOk5BlCp4u/prYfXecga/8Up+mfyhDuKT7cGF59cGDsj126OuBRlBlY2QJlyPL2TzC2k9MsWkmYbEC7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784546368; c=relaxed/simple;
	bh=0/7vyfn3ez2gQVNAZTrNqxNynKaQbM82xBSRTVyMLVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQacpXXPkQ/97qn/MSM2FW+n9uy78VcjTXBqg22izijNL1HYYPoix/caiA7yMtVTO1DjljYsg3YwEBAoZHyuTy7NT5CsrUsUb+K75obB5pNam2n+OwehrSNabsegFS+VsrZO+orS8TlviioSiSjCwttS5qeil9iZeLeX/FwEp9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yX7kGdlH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5PJz4dnP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x5euKueh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IQXrD4ih; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yX7kGdlH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5PJz4dnP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x5euKueh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IQXrD4ih"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9AD873DF9;
	Mon, 20 Jul 2026 11:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784546363;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T32nYv4gIl3iKHMR4R1EXlrLvwS5FcxtQ883X4X50no=;
	b=yX7kGdlH9LcO6Xm3qqSKCjlAaOdJBBtBvOaBA5N6fdb9W4VMGj4GblZpG/2pDizYviiAkj
	kqe63U04ZznJoHPgbr4FYmX+ej8G+rAoK93/sQgHQ6KXKr3dLgQUHFjxY8E7LqJrUXh0p+
	sqJQFpha1xglnWilVvsukTn1hTdmHHc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784546363;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T32nYv4gIl3iKHMR4R1EXlrLvwS5FcxtQ883X4X50no=;
	b=5PJz4dnPEzEYKeD2JtKML8A0rven5RkFae947gPMx0qAo+31coLRyUhuwH71jEOkxvmF69
	8MjDO9ZcOagRKnBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x5euKueh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IQXrD4ih
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784546362;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T32nYv4gIl3iKHMR4R1EXlrLvwS5FcxtQ883X4X50no=;
	b=x5euKuehojfz/cho1rRNd4Gix8GJRzrowd7zgwWdBw2VNrzTHCdfZbljHTqxRVij+s8ls0
	DAyRImGTMlLFJYf37MyGrlcnp3vs9kgv5S2sXH9o5czf6pYpPl3O6JeA1B/DJEGboGFle7
	JnUpJfW213etazRzAIebq8+74IPJAFM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784546362;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T32nYv4gIl3iKHMR4R1EXlrLvwS5FcxtQ883X4X50no=;
	b=IQXrD4ihJBBRx8wCPFseKwW6/4ot2vkUCvu3qqocm17ULLemyeKuVa3+bLq8m6n5szcgx5
	4Pk6KATI1w1fK/BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A8CA779AA;
	Mon, 20 Jul 2026 11:19:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PyEmHToEXmoMEgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 20 Jul 2026 11:19:22 +0000
Date: Mon, 20 Jul 2026 13:19:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Guanghui Yang <3497809730@qq.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: drop recovered reloc root refs on recovery failure
Message-ID: <20260720111913.GE10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <tencent_73CA9825AA069E0BC5194FA9102FB7618807@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_73CA9825AA069E0BC5194FA9102FB7618807@qq.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9AD873DF9
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[qq.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto,suse.cz:dkim,qq.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Sun, Jul 12, 2026 at 04:22:32AM +0000, Guanghui Yang wrote:
> During relocation recovery, each fs root gets a reference to its relocation
> root. If loading or adding a later root fails, or if the first transaction
> commit fails, btrfs_recover_relocation() jumps to out_unset before
> merge_reloc_roots() and clean_dirty_subvols().
> 
> put_reloc_control() drops the list-owned relocation root references, but it
> does not clear fs_root->reloc_root or drop the references owned by those
> pointers. Mount cleanup only drops them when BTRFS_FS_ERROR is set, so an
> error such as -ENOMEM while processing a later root can leave references
> behind.
> 
> Keep temporary references to the fs roots associated during recovery. On
> failure, clear their reloc_root pointers and drop the corresponding
> references. Once the first transaction commit succeeds, drop only the
> temporary fs root references and let the normal merge and cleanup paths
> handle the relocation roots.
> 
> Fault injection on a pending-relocation image confirmed the cleanup gap.
> With an injected first-commit failure, 25 fs roots had reloc_root set with
> fs_error=0. With this fix, the same failure path drops that count to 0
> before mount fails.
> 
> Fixes: f44deb7442ed ("btrfs: hold a ref on the root->reloc_root")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guanghui Yang <3497809730@qq.com>

Added to for-next, thanks.
