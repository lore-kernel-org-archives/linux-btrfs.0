Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A626948F03C
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 16:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404127; cv=none; b=pWqbO7wgSjVSiSkfHbrH/v2VcdYb31IcS53mtojuYuZ39CJwNoGnxXZXaxawivYttxxonYYrRK80Vr0MD9TRECuL5xakpgZp+r0yExAEHXDzuuWgVzBjw8PD8JZW+5ij0YLMks2f+D+xFy22l4nkhox9yUqwpBRu/7JAt8ixkyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404127; c=relaxed/simple;
	bh=MmDnWVfHEyb1aMJ7TNHnms3Blgmwi3a8NH6snnCYdHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4vA4sxUwRQCT7BtncXiOQmhAunFE37ahwzcRtxnQiTsHs4gQE/giOiKv/LtSWqwQpmuiCBTb/fLxDhbBX3GSHghY7WB1GrMfmOi/MA2Dtt/Nakxb7E+PlnGYiYYM9FttTLNZ4eQcjWzpGUBXe4pE0L01TmbnA3lJlLsbSThgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=REGSteQw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=I3zvb5eH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IVWtQfp3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=amciDlPu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="REGSteQw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="I3zvb5eH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IVWtQfp3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="amciDlPu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5F0D61FD80;
	Mon, 14 Sep 2026 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789404118;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3s21xkPZLHMJIFxHHy9a3+sReBFRMlyXO+ov9dQpp0=;
	b=REGSteQwK7xj8FkIj6oj8rcqNaWXCgzNc4yfAP580rZG4I2/QL7ZEkZ/biGyhqjRLHNl7Y
	hJ+SJaOZcy501/IIZ1Ac26Ope+UfLgJVzu0aZoPThEBp15tpFhoShhDVZvPf1AT+eOcuTs
	VF1cErurbgzHPAd6YWSZ39QT8ld7Ra0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789404118;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3s21xkPZLHMJIFxHHy9a3+sReBFRMlyXO+ov9dQpp0=;
	b=I3zvb5eHtk22hB0qB5cLURj6FaQBBJG4GR2YTUJIhKLiMnnxMVisCYCcNU4yND93WN8CCq
	qfKwj5qnC6RLlnAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IVWtQfp3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=amciDlPu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789404114;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3s21xkPZLHMJIFxHHy9a3+sReBFRMlyXO+ov9dQpp0=;
	b=IVWtQfp3zJPdTNZmT1pKgja1kRGELAD9zMUJs+Jlh2lxsDEbXXo4zxwgxW8a6ipugsJidn
	wNZ6Vw60iCKQG8j7qstrvDMMLFPLxDqZajU924h7GV+9PvFg3GDIXUMr3ozdsdz3artI3A
	TvIX6yKKGy89FGnQ2/nZ8Bc1byzqP7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789404114;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3s21xkPZLHMJIFxHHy9a3+sReBFRMlyXO+ov9dQpp0=;
	b=amciDlPubsfuKP/twrmUdEYdxE3rdx7zttmbOiDHReWhnZa/X6VBrwCFoB4JAaXtBlhyis
	HftWRJbi3JzdQtDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 043D613515;
	Mon, 14 Sep 2026 16:41:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id chVfANIjqGqdOQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 16:41:54 +0000
Date: Mon, 14 Sep 2026 18:41:48 +0200
From: David Sterba <dsterba@suse.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Anand Suveer Jain <asj@kernel.org>, dsterba@suse.cz,
	linux-btrfs@vger.kernel.org, thiago.macieira@intel.com,
	dave.hansen@intel.com
Subject: Re: [PATCH] btrfs: derive f_fsid with dev_t only when temp_fsid is
 active
Message-ID: <20260914164148.GM54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org>
 <0691a903-cc82-4ad7-8264-cddbf146d00e@kernel.org>
 <91E0EA5B-BFD2-4B8A-8408-4F561D5E0777@infradead.org>
 <c04f73b1-cf55-40ef-bb47-d518603bcd8c@kernel.org>
 <f130860f8e12c46688a7fcc158f3f34fa042e47e.camel@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f130860f8e12c46688a7fcc158f3f34fa042e47e.camel@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 5F0D61FD80
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Mon, Sep 14, 2026 at 12:47:53PM +0200, David Woodhouse wrote:
> On Mon, 2026-09-14 at 16:28 +0800, Anand Suveer Jain wrote:
> > 
> > 
> > > > . For stable kernels, this flag will keep the new f_fsid derivation
> > > > disabled by default.
> > 
> > 
> > > No. That still gives you a broken fsid on upgrading to the next major kernel, doesn't it?
> > 
> > Upgrading to a _major_ kernel would require an extra step to re-encrypt
> > with the new FSID _for some configs_.
> > A one-time operational overhead.
> 
> I'm not keen on that. The documentation is fairly poor, but historical
> behaviour and expectation is that the FSID is supposed to be *stable*.
> You're not supposed to randomly change it from one kernel to the next.

That's what I consider sane and would like to preserve. We allow users
to change the UUID by tools, but this means the user is aware of that
and initiating such action.

> Won't this also trigger some incremental backup schemes to re-archive
> every file as it seems the {fsid, ino} has changed?

This is a good point, I don't know if backup tools do that but it's
quite natual thing to do.
