Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823273176EF
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777472393; cv=none; b=ISw7n+YVoKqo019vfZ3L/yrwkvGVyAR4A0l3kkmMc8BENsBiheAECoyfM7wjgW3LngLlCe1BcwLyQRnb5WW/loEel7a+arZwpKqIf1ACeNAy1CJEjrvVx2B/0Nb8BiuODRBERoIFGor1MRQj9moqd2/g8EYubGh+uakFqGc9tJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777472393; c=relaxed/simple;
	bh=BRARi0QMKgEyP5dbO+MF5BOyUPKzRDsZ3hg6K0bE408=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mOqTEjYUh+uhjiIfDsfX8N2z7V2Cj//B8CgJIXfdoExyjj572t83078XgoOt7TlZtS5wAN6SGmeYzNwb7r4fWW8Zp5o/AUyq9OmDq91dCofmsQVV7eN27wzAHL8XMNUjnpkHPz6HY0f9UBc39+MXBRdhiPke4Ve/jM76mQrMV3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vUAnQRNs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BGdLdU/C; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jhirRma9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gSRAszWz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vUAnQRNs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BGdLdU/C";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jhirRma9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gSRAszWz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 672D05BD15;
	Wed, 29 Apr 2026 14:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777472385;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rEWOorgXv60JlvQJ7qXL7hASGAKWgcPh43lhauJnbNA=;
	b=vUAnQRNsGXuYYdwKE9MpdeU/dme6YyEU4AqTSuPyFm0XiN29XctIQMu7BZxhNw+Uzm7yDn
	Mu13prJMFgQv3J4kMY5uq8q4bhsUSHS5E0P2xg7nb9maR0dWhOaH8EaiBn6tUFK8DnB49n
	oSJqbD/fxZAwQx031a/0eWB799uxqzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777472385;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rEWOorgXv60JlvQJ7qXL7hASGAKWgcPh43lhauJnbNA=;
	b=BGdLdU/CWMXzyXDTs2fEVqsL9EfBOKByYtnrmFGWFDHgVQrUl3R4Zap0usCyZKUarf77RD
	x3zXLu8vppURgdCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jhirRma9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gSRAszWz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777472381;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rEWOorgXv60JlvQJ7qXL7hASGAKWgcPh43lhauJnbNA=;
	b=jhirRma9EIQOcQibn51W0/h4g8esUgXUAC63Ri+swPVTgMIUZ2iaK4wtREMDYUZNG6u4N3
	Am+KilZtle2SOgGLHy+Xa7KAcIJh1S3vlJI3IHAz9VDyTqtMvxzknPSeJd6+V6zAWLhOeh
	1CS+gd8U+Nz//HpNW8A64kFPu4zcJWA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777472381;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rEWOorgXv60JlvQJ7qXL7hASGAKWgcPh43lhauJnbNA=;
	b=gSRAszWzJxVpO3ySPeNaYL2YMMdEnm3gI4gdh9VvLZtJNBqsGgRR9Yq4qYpZp/EHllfci6
	gF1pVJKUWnc+XwDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50229593B0;
	Wed, 29 Apr 2026 14:19:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1w5VE30T8mlkXQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 29 Apr 2026 14:19:41 +0000
Date: Wed, 29 Apr 2026 16:19:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: move transaction abort message to
 __btrfs_abort_transaction()
Message-ID: <20260429141939.GJ3906171@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260428155148.2399-1-dsterba@suse.com>
 <f910a267-a99d-4007-a5ee-a186471697a8@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f910a267-a99d-4007-a5ee-a186471697a8@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmx.com];
	FREEMAIL_ENVRCPT(0.00)[gmx.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 672D05BD15
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Wed, Apr 29, 2026 at 08:15:39AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/29 01:21, David Sterba 写道:
> > The btrfs_abort_transaction() is called at the location where we want to
> > report the abort. It must be a macro so we get the correct line and
> > stack trace. This inlines the necessary code and the rest is pushed to
> > __btrfs_abort_transaction().
> > 
> > There's a possibility to reduce the inlined code if we move the message
> > to the helper function as well, without loss of information. The
> > difference is only that the WARN will not print it inside the stack
> > report but after:
> > 
> >    --[ cut here ]--
> >    WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa21/0xd30 [btrfs], CPU#11: bonnie++/3377975
> >    ...
> >    --[ end trace ] --
> >    BTRFS error (device dm-0 state A): Transaction aborted (error -28)
> > 
> > While previously there would be one more line like:
> > 
> >    --[ cut here ]--
> >    BTRFS: Transaction aborted (error -28)
> >    WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa21/0xd30 [btrfs], CPU#11: bonnie++/3377975
> >    ...
> >    --[ end trace ] --
> > 
> > This removes about 22KiB of btrfs.ko on a release config.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >   fs/btrfs/transaction.c |  3 +++
> >   fs/btrfs/transaction.h | 11 +----------
> >   2 files changed, 4 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 194f581b36f3..5125cb20ef85 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -2729,6 +2729,9 @@ void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
> >   {
> >   	struct btrfs_fs_info *fs_info = trans->fs_info;
> >   
> > +	btrfs_err(trans->fs_info, "Transaction %llu aborted (error %d)",
> > +		  trans->transid, error);
> > +
> 
> This message will be outputted for every btrfs_abort_transaction() call.
> 
> Shouldn't we move it behind first_hit check?

Right, we should, to keep the previous behaviour. I'll update it,
thanks.
