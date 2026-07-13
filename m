Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D58335BB4
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 18:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783967718; cv=none; b=BfwT4aa1hel7RiVIOXRC9gBnO9LNTdqzE0YFj2IrJjUqOypc8C8oyooCfpkBrLg1nfVk0b0eq6UzvLhJW+/vHDjFGOumeG2It4/d87+iHxB9G8iJf8ghRaGvnqzsqC0qR2fduZqGIr7L1Ry5ZjfeFNdeM4Km5VlxeH1seuLZa1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783967718; c=relaxed/simple;
	bh=gO43hj00QUMbX6Hl1kz27SMMISYdWOvo3a1NkDoqY70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hP50DvGGdd8qRzT35SdVpt6CFz1mj0gvl7k/F6gBFBc8rRvTe21usOqkYhFtf2WIdQmfSOO1eGJZNY6r0aSoE1o89eU+9UlWKNNJkaRBdmzz3fh0+SEsT/0iouYw2cCL3KQggTfRGtikhd3rcdl/yVM5H4eOaGg7du84PTff2Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Lvczl0c1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tdmLvrc6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vKpkzqR6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rv2a3opP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Lvczl0c1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tdmLvrc6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vKpkzqR6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rv2a3opP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8BDE377A6F;
	Mon, 13 Jul 2026 18:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783967715;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gyyYLVCgbh2lDrdJSvE0jtlq+Hjv06FvQbleHNZ0ATI=;
	b=Lvczl0c1RtIHcrWXX5SWFm7PMIsvTRyn/c1p1w1JV61Bzarw8aRtBrrxKfEjixJYXOQ8CX
	K1ZrqE8kLq1Ax/beMMBz+qPVDUYGDxfeCW8QqtL0GANZ3TmKCiSVH46f7EGIsDAnDcJq8z
	wHMeSZJvF6cfdQYKC6nyo6vZGxICuIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783967715;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gyyYLVCgbh2lDrdJSvE0jtlq+Hjv06FvQbleHNZ0ATI=;
	b=tdmLvrc6RjP8+2YJAieKdLBrGoQrkqPy5Txdk01wqx3O487d4G2J0xGbbiJfubAtt+nRCa
	hqoJuwkij4U7sSAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vKpkzqR6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Rv2a3opP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783967713;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gyyYLVCgbh2lDrdJSvE0jtlq+Hjv06FvQbleHNZ0ATI=;
	b=vKpkzqR6LUJwN3U6jn7z+/C7TdlTwtU5A3aBD9pyiCo6j1OAYTC/rYo1ZY99EsLweRSK8I
	Bz+Fy5tjnJC/iRHV3XwWEMvXQumvGuzSaBuM+/kJVzjZutRshkwSc4gS607z6zHrHTffv3
	1zcidtOAJJtIl8J5zn1kLaOTMKSZxNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783967713;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gyyYLVCgbh2lDrdJSvE0jtlq+Hjv06FvQbleHNZ0ATI=;
	b=Rv2a3opPhKeFrxoyPBoT5b9EXCfh0ytVfQxkeqZUuOF06CUGt34YTQPACluPRr2lQteFm+
	WvprIx+iWBvOS9BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71167779AE;
	Mon, 13 Jul 2026 18:35:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +39bG+EvVWq4HgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Jul 2026 18:35:13 +0000
Date: Mon, 13 Jul 2026 20:35:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhongling0719@126.com
Subject: Re: [PATCH] btrfs: Add missing sctx check in cleanup path
Message-ID: <20260713183508.GA8426@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260707091604.207222-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707091604.207222-1-zenghongling@kylinos.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[126.com];
	FREEMAIL_CC(0.00)[fb.com,suse.com,vger.kernel.org,126.com];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 8BDE377A6F
X-Spam-Score: -4.21

On Tue, Jul 07, 2026 at 05:16:04PM +0800, Hongling Zeng wrote:
> Add sctx NULL check in the sort_clone_roots cleanup path for
> consistency with other cleanup paths in the function.
> 
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> ---
>  fs/btrfs/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 3ae480c7474b..2d81fac03a3d 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -8250,7 +8250,7 @@ long btrfs_ioctl_send(struct btrfs_root *send_root, const struct btrfs_ioctl_sen
>  		free_orphan_dir_info(sctx, odi);
>  	}
>  
> -	if (sort_clone_roots) {
> +	if (sctx && sort_clone_roots) {

The check for sctx is indeed missing but in the else branch the
condition is inside the for loop:

  for (i = 0; sctx && i < clone_sources_to_rollback; i++) {

It would be better to place it there for consistency.

Overall in the function many of the sctx checks can be removed if the
allocation is moved to the beginning.
