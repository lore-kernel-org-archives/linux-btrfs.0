Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2078932AAA3
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 15:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777302739; cv=none; b=ZpqCT6bth5bAXfyvrxbLENv/Wc2f9gPpC+A0y8glbU5Y6ZUYIlBa7DUvkFTfbTUolYFIRDMNWaOvMd244spH9UenfErpOt9dxwr35F8XtJGJZP7RqhGO88KQ6P/pgDyD/CzhKvc08obKwp6okZ82eV6lomBR/p3gxsYsz4ut0Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777302739; c=relaxed/simple;
	bh=uIgoYpq7+4aD24KYhAA8UVk+ZjMxRN+A4t2jLp4OEUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XzLPT+h7Or0kjAF8kF4gFtrqdAD5lUwWeaOhCRCF8Ap4X25p0RyFQnSJddmZoYn37xbkvu4GOguu1Y+orP0PePVpEzLuON6Zr9kKK25wh4NDvDc5OOQyClEYdXt99oGHstnrM+iOOehDs/xZ8u49rkXXq2W+MIDK+pTwlaT9DSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mO4116hZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2joLgrTC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mO4116hZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2joLgrTC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mO4116hZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2joLgrTC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mO4116hZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2joLgrTC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 605FB6A83E;
	Mon, 27 Apr 2026 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777302736;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDdUED+hniIbl0fr6Rtof5c0fHqswsZAVupXBdvV6bs=;
	b=mO4116hZzOy80TtWyIBHFfLRQhURbTEhCXfBAnD6X6LZOaXYod61QtSOiTQ3xAZ4EMA6rj
	d5B2Ldp9UbYNEXiYvvH//UhB4lNzUD+BybNd3l+qHA7jzxyZsGd3szv8qtYrkvFTLyg02u
	z4PqXcDa5+eoxV6rxVnSz17VRA0Rm/M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777302736;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDdUED+hniIbl0fr6Rtof5c0fHqswsZAVupXBdvV6bs=;
	b=2joLgrTCkgmBZzMcb9G4yuREw0ZnaUHzX/3Yun46pSYfyxdtRKmIadnNT3bU0ViP0kcrmM
	5Ha/HBhIDUfKGlAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mO4116hZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2joLgrTC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777302736;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDdUED+hniIbl0fr6Rtof5c0fHqswsZAVupXBdvV6bs=;
	b=mO4116hZzOy80TtWyIBHFfLRQhURbTEhCXfBAnD6X6LZOaXYod61QtSOiTQ3xAZ4EMA6rj
	d5B2Ldp9UbYNEXiYvvH//UhB4lNzUD+BybNd3l+qHA7jzxyZsGd3szv8qtYrkvFTLyg02u
	z4PqXcDa5+eoxV6rxVnSz17VRA0Rm/M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777302736;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDdUED+hniIbl0fr6Rtof5c0fHqswsZAVupXBdvV6bs=;
	b=2joLgrTCkgmBZzMcb9G4yuREw0ZnaUHzX/3Yun46pSYfyxdtRKmIadnNT3bU0ViP0kcrmM
	5Ha/HBhIDUfKGlAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46F8A593B0;
	Mon, 27 Apr 2026 15:12:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aOT1ENB872mIQgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 27 Apr 2026 15:12:16 +0000
Date: Mon, 27 Apr 2026 17:12:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove 32bit compat code for VFS inode number
Message-ID: <20260427151214.GP12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260414201208.2749178-1-dsterba@suse.com>
 <2f4c809b-c304-4afd-a604-7adc7e0da8d0@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f4c809b-c304-4afd-a604-7adc7e0da8d0@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 605FB6A83E
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Wed, Apr 15, 2026 at 09:36:21AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/15 05:42, David Sterba 写道:
> > Commit 0b2600f81cefcd ("treewide: change inode->i_ino from unsigned long
> > to u64") sets the inode number type to u64 unconditionally, so we can
> > use it directly as there's no difference on 32bit and 64bit platform. We
> > used to have a copy of the number in our btrfs_inode.
> > 
> > The size of btrfs_inode on 32bit platform is about 688 bytes (after the
> > change).
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> But that treewide patch is not yet in our for-next, we can only merge it 
> after our for-next is rebased.

Done.
