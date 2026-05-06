Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4A33128CA
	for <linux-btrfs@vger.kernel.org>; Wed,  6 May 2026 21:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778103900; cv=none; b=GAcYqe5KMqjeR1XxsgprTjqjpxzGfwD25186qAZRqABF+db5tIr224xJyPqdWNp03dnOM4s4+ojLmTIF2y3QIg3SzmTWQrSvyLwbi3uHe3YS2aewzUkMS2/JDP1jESADbqB22e5B1otECtkVsQHRB5Atnt2ZJtUYvqMTvdv1vxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778103900; c=relaxed/simple;
	bh=rTcvuvYFe28D7XSiPifDnrgcPEVwmmn8BQRJI5UU94M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qx70+gAh7jkEC7NH9OBaEIisX4jRffaZl1EO5IeDSb664hOsrFCkqJXsjVNbnRBh8YHcZ6jFa53eHWs1VHyDLEm2kycJ6gQ9WN8na5SrfXV7ACe3LVxPhY8yWib+pHGuEDlWkH9REvF/J75ExfHBkP7W0qAOk7HvkoOmpnhUnfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ogz3UBKo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3tDM/ufZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ogz3UBKo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3tDM/ufZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ogz3UBKo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3tDM/ufZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ogz3UBKo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3tDM/ufZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B95B96BFD8;
	Wed,  6 May 2026 21:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778103896;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GLYtl+dv6EElsN8ZkboYjMIQFgfuw1C/BIUR7xoOESk=;
	b=ogz3UBKoOn87ad33uejo5VblIWL64U8IP50ginruO3rBpnlJlgdbrWRrXZ1APu9owTbq/P
	M7Cg/s1duil0I9vDOagblCN9EaUm+2W4YeVRUxQFqAG4leYjpdT6lOpugkIPO+6ghjYan7
	VyRrimouknGPYiZvBvxz7ZNuSRghlEY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778103896;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GLYtl+dv6EElsN8ZkboYjMIQFgfuw1C/BIUR7xoOESk=;
	b=3tDM/ufZE1iAabiC/scDQtQUQJcxIqRllVYmw70BjN2KvezgMvyNPmw5SNtEoBLtG35qLy
	74yyP4S3jTgRHbAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ogz3UBKo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3tDM/ufZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778103896;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GLYtl+dv6EElsN8ZkboYjMIQFgfuw1C/BIUR7xoOESk=;
	b=ogz3UBKoOn87ad33uejo5VblIWL64U8IP50ginruO3rBpnlJlgdbrWRrXZ1APu9owTbq/P
	M7Cg/s1duil0I9vDOagblCN9EaUm+2W4YeVRUxQFqAG4leYjpdT6lOpugkIPO+6ghjYan7
	VyRrimouknGPYiZvBvxz7ZNuSRghlEY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778103896;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GLYtl+dv6EElsN8ZkboYjMIQFgfuw1C/BIUR7xoOESk=;
	b=3tDM/ufZE1iAabiC/scDQtQUQJcxIqRllVYmw70BjN2KvezgMvyNPmw5SNtEoBLtG35qLy
	74yyP4S3jTgRHbAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C7EE593A3;
	Wed,  6 May 2026 21:44:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PCxbJVi2+2mnVQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 06 May 2026 21:44:56 +0000
Date: Wed, 6 May 2026 23:44:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: simplify how first hit is passed to
 __btrfs_abort_transaction()
Message-ID: <20260506214451.GE2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260430141851.14332-1-dsterba@suse.com>
 <0247f301-39ed-4e29-9a68-3a8ff3619006@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0247f301-39ed-4e29-9a68-3a8ff3619006@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Rspamd-Queue-Id: B95B96BFD8
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Fri, May 01, 2026 at 07:54:19AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/30 23:48, David Sterba 写道:
> > Optimize the btrfs_abort_transaction() for size as it (by our
> > convention) must be put right after the error condition is detected.
> > The exact file:line is reported so there's a portion that must be
> > inlined. As this is cold code it bloats functions. In previous patch
> > "btrfs: move transaction abort message to __btrfs_abort_transaction()"
> > the error message was moved to the common helper, saving like 20KiB of
> > btrfs.ko and several instructions per call site and some stack space.
> > 
> > There's little left to be optimized, we need to keep the atomic
> > test_and_set_bit() and to convey that as 'first hit' to
> > __btrfs_abort_transaction().
> > 
> > Right now it's a bool, which takes 8 bytes on stack for each call but
> > it's 1 bit of information. We can encode that to some of the other
> > parameters.
> > 
> > For that let's use the 'error' parameter, by convention it's negative
> > errno so we can reliably detect if it's the first hit or a later error.
> > Also the negation is usually implemented by a single instruction (NEG on
> > x86_64) so the resulting object code is kept short.
> > 
> > This reduces btrfs.ko by 8K and stack in several functions by 8 bytes.
> > 
> > Cumulative effect with the other commit is -30K of btrfs.ko. While the
> > encoding is an implementation detail, it's contained within the API.
> > Making the transaction abort calls very light is desired.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >   fs/btrfs/transaction.c | 13 ++++++++++++-
> >   fs/btrfs/transaction.h | 15 +++++++++------
> >   2 files changed, 21 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 01f66328966f..bbef3ae86ac4 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -2723,12 +2723,23 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_fs_info *fs_info)
> >    *
> >    * We'll complete the cleanup in btrfs_end_transaction and
> >    * btrfs_commit_transaction.
> > + *
> > + * Note: the parameter @error encodes whether the transactin abort was first hit
> > + *       (setting the FS_ERROR state bit in btrfs_abort_transaction())
> > + *       - positive number - first hit
> > + *       - negative number - abort after it was already done
> >    */
> >   void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
> >   				      const char *function,
> > -				      unsigned int line, int error, bool first_hit)
> > +				      unsigned int line, int error)
> >   {
> >   	struct btrfs_fs_info *fs_info = trans->fs_info;
> > +	bool first_hit = false;
> > +
> > +	if (error > 0) {
> > +		error = -error;
> > +		first_hit = true;
> > +	}
> >   
> >   	WRITE_ONCE(trans->aborted, error);
> >   	WRITE_ONCE(trans->transaction->aborted, error);
> > diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> > index f1cb05460cec..e1d4e7330198 100644
> > --- a/fs/btrfs/transaction.h
> > +++ b/fs/btrfs/transaction.h
> > @@ -243,20 +243,23 @@ static inline bool btrfs_abort_should_print_stack(int error)
> >   }
> >   
> >   /*
> > - * Call btrfs_abort_transaction as early as possible when an error condition is
> > - * detected, that way the exact stack trace is reported for some errors.
> > + * Call btrfs_abort_transaction() as early as possible when an error condition
> > + * is detected, that way the exact stack trace is reported for some errors.
> > + *
> > + * Error number must be negative as it encodes wheather it's the first abort.
> 
> What about an ASSERT() for it?
> 
> It's not that rare to forgot the minus sign for immediately error code 
> like "-EIO".

Yes I can add it, but ASSERT is evaluated at run time so this would not
catch "EIO". I have figured out how to do it at compile time, will be in
in v2.

> >    */
> >   #define btrfs_abort_transaction(trans, error)		\
> 
> And I do not like to use macros when inlined function can be used.
> There is no special requirement for things like #name, thus this can be 
> converted to a regular static inline function.

No it can't, static inline changes how __LINE__ and __func__ (and
__FILE__ for that matter) work so we'd get reports from the same
function where the function is defined. While with macro we have the
exact location, this is a standard trick. It's been like that since
forever, 49b25e0540904b ("btrfs: enhance transaction abort
infrastructure").
