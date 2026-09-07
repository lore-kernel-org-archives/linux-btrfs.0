Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33213481665;
	Mon,  7 Sep 2026 12:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788784566; cv=none; b=FiUIkPGew55t0aWFRiQDJjBldOSaBm76X0f8jcrOPi01riKOWR34Hz1yF8jkBuJjpl1l5Xm1JSzYwS2xb/C1WIiXgeo+kLkgD9PMl835K46jZLR+prdnHIA+vP1Co0NM3zyJi9nvDVHBZTv7SgffDVBOezRyOrUrXTFOZ1vpLuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788784566; c=relaxed/simple;
	bh=FcK8ECtyHz/1bCKBWJbMe804PvZEKCJiARxb2edenec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PHGDe3zLIGf+NcQkmXXEo5L8vWXRZ3CyVzRKSE9K7WtCAEHMMnpaApn4jB9PVlHDEitcr38JDNLkrSz7ZhZmLDxZfN5d9EE2k5knEoCfH2BmNc1mmN4W1DUMllIloPyFrrE+U5PpV6GZMlXlRo9Hm/FudidgQbk/Zf+jTjyJvas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KjzMLEJ4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GuIq4xeG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pWOKiedL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9Cmaa5de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KjzMLEJ4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GuIq4xeG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pWOKiedL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9Cmaa5de"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D2BF31F393;
	Mon,  7 Sep 2026 12:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788784559;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ed8/rSn/tadqDWXWLwChn47Bl+pOCC0z2dFG2zTtTGk=;
	b=KjzMLEJ4s3Ytv1uRKnNBXyiAsbYwPImqXVv2KiGBwiae2uPP0LpHo5ETOfclVi4KNjWhR0
	q/UbsJqs6sO5x389/fBjTkTs1VWRSAq+qqXxSZxTenEdT/Ou+XApe7Nfpjl2StlLge1EyK
	p3ElH0p1TD6xkKaLLMgJESR82byH0fo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788784559;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ed8/rSn/tadqDWXWLwChn47Bl+pOCC0z2dFG2zTtTGk=;
	b=GuIq4xeGZS1B/EQsV36QVxk9KsVH2EByQmY/X3JrbfLT240+lB0mt4gJjoFPwPMcVg0kHC
	VntjWbnfytlqs7AA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pWOKiedL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9Cmaa5de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788784554;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ed8/rSn/tadqDWXWLwChn47Bl+pOCC0z2dFG2zTtTGk=;
	b=pWOKiedLRF3TTgSXCvthDvu4Sb8HmW/NM9kdpuaD+NCEcAMU1wKyip5i7gN8xfRzlL+/rG
	G27K1ZJ9y5HtuhSmqXtBVcRizO6nb1bxKYtM9SVEDqdAa7NNF0LBI6/qHegw2BrgmFWEFq
	i10h03OeMnjT0PYF9mpaguHtrgGBWSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788784554;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ed8/rSn/tadqDWXWLwChn47Bl+pOCC0z2dFG2zTtTGk=;
	b=9Cmaa5deXc3zxzRlWq2qAnnfIBnjpEgavEPN29dwUkYio0L7mE0bazGD7laRrW8YUdqpOM
	VNKBU9497WMWFKDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF5081339B;
	Mon,  7 Sep 2026 12:35:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +O+XKqqvnmpJNgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 12:35:54 +0000
Date: Mon, 7 Sep 2026 14:35:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Daniel Vacek <neelx@suse.com>,
	Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: reflow comments left awkward by the typo fixes
Message-ID: <20260907123549.GW9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260907114153.39900-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907114153.39900-1-hemanth.selam@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: D2BF31F393
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
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
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO

On Mon, Sep 07, 2026 at 05:11:53PM +0530, Hemanth Selam wrote:
> Removing the repeated words in rbio_orig_end_io() and
> rmw_assemble_write_bios() left two comments reading oddly: one now starts
> its second sentence in lower case and wraps early, and the other fits on a
> single line.  Reflow both, as Daniel Vacek pointed out.
> 
> Comments only, no functional changes.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

No need to send such patches if thery're an immediate followup, the
change can be done at commit time. This saves time on both sides.
