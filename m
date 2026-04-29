Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3CD2727FD
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 14:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474770; cv=none; b=VFWRcZh0INZUQNxAryEqO9ejeXST1PhtMdOkfGBHIefYNrFWkzExeDUeYkhpqH0pblvaKWQ3/TSChZai44wzhUdHs9OLFXI6vnbSohct2hkDof4a822xE+WwQxuRVyKDjug4dUCFfeBFMxPwfuzZzOziQiLuMvE4wOMOYj2sCSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474770; c=relaxed/simple;
	bh=PvkDwjkhbiFM+AJxwE98DnAmUQE9HXIcMcd6n7fx9MI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwX2nqtqNnEm5buAzkbXLYO0WRs06OUqoe5O8oZN1kYZbmO1BZsKsYCy3aCP1YD+SOBhCCsBPES2pwto05rgorb8/9QQ6OKN8iDLTwGd8F6z7OYfpojoBYJziblPYauBZNSKQersNQ9K9ccUDCXURAdevvm7SOpLO/tr9IurTQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0F7OPUze; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=09iV04Ym; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EiAqyk20; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LWaCmi3m; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0F7OPUze";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="09iV04Ym";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EiAqyk20";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LWaCmi3m"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A014A6A827;
	Wed, 29 Apr 2026 14:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777474762;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kiy1lHT3QYcyGwF3IROYk84baoxm2bZROmAjHnfdaPM=;
	b=0F7OPUzezTfUYTcd0YgpRrDcYLdBCP5pFzWUntx9UE8TYoV/YpNM2miY4QXn3GBo8hWHo7
	y391gb7RakC7vmlhckVHHeFAsPlIk5yhCo9gRqNKsfXSLUumoYkDpS8sVXYi6PAFW8y2NJ
	n3lclXItJg7g0iU1eqlgN7tMMgpYFUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777474762;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kiy1lHT3QYcyGwF3IROYk84baoxm2bZROmAjHnfdaPM=;
	b=09iV04YmxVjSDoIR9lxG2GveEm25l7wOcGdJwe8e1/gwYfmGow4Jjgvgs+hmscCK0J8CWR
	pOIjGJBWqSgpdVDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777474757;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kiy1lHT3QYcyGwF3IROYk84baoxm2bZROmAjHnfdaPM=;
	b=EiAqyk20mGr6kKtCrKJsH8zwzev0cdK9CostKIGpX+m9tNrERWtl0cMMGl8Da9pB9yWIL5
	anAADS/AO6RB1YatAFlLPTiSzSEEOzTg0uCMoLTIszMQrlLa1nmAia5NW/IaSVxuhJj2i4
	HvjGb29R3rME8tX1okOsZrQpIOvKSgE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777474757;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kiy1lHT3QYcyGwF3IROYk84baoxm2bZROmAjHnfdaPM=;
	b=LWaCmi3mcK8littoCWJ4iGmZAYatNk0wSLcwL6Fv9jhwd3l261kYakH3bkW/u1elptvIN7
	gb1+JCF3phYVNEAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B7BF593B0;
	Wed, 29 Apr 2026 14:59:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PmHtHcUc8mmVBgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 29 Apr 2026 14:59:17 +0000
Date: Wed, 29 Apr 2026 16:59:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: move transaction abort message to
 __btrfs_abort_transaction()
Message-ID: <20260429145916.GR12792@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260428155148.2399-1-dsterba@suse.com>
 <20260429143253.2236286-1-dsterba@suse.com>
 <CAL3q7H5=v-trO08Vx=BTb4FJR0BvSPDzRJyeYrnpb6muVAD07w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H5=v-trO08Vx=BTb4FJR0BvSPDzRJyeYrnpb6muVAD07w@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -3.99
X-Spam-Level: 
X-Spamd-Result: default: False [-3.99 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.19)[-0.943];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:mid,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Apr 29, 2026 at 03:35:55PM +0100, Filipe Manana wrote:
> On Wed, Apr 29, 2026 at 3:33 PM David Sterba <dsterba@suse.com> wrote:
> >
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
> >   --[ cut here ]--
> >   WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa21/0xd30 [btrfs], CPU#11: bonnie++/3377975
> >   ...
> >   --[ end trace ] --
> >   BTRFS error (device dm-0 state A): Transaction aborted (error -28)
> >
> > While previously there would be one more line like:
> >
> >   --[ cut here ]--
> >   BTRFS: Transaction aborted (error -28)
> >   WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa21/0xd30 [btrfs], CPU#11: bonnie++/3377975
> >   ...
> >   --[ end trace ] --
> >
> > This removes about 20KiB of btrfs.ko on a release config.
> >
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >
> > v2:
> > - move message in __btrfs_abort_transaction() under 'first_hit', also to
> >   make the WRITE_ONCE() assignments immediate
> > - savings updated to 20K, it depends on the config and compiler, use an
> >   average of a few setups
> >
> >  fs/btrfs/transaction.c |  8 ++++++--
> >  fs/btrfs/transaction.h | 11 +----------
> >  2 files changed, 7 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 194f581b36f3..184fe976450e 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -2731,8 +2731,12 @@ void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
> >
> >         WRITE_ONCE(trans->aborted, error);
> >         WRITE_ONCE(trans->transaction->aborted, error);
> > -       if (first_hit && error == -ENOSPC)
> > -               btrfs_dump_space_info_for_trans_abort(fs_info);
> > +       if (first_hit) {
> > +               btrfs_err(trans->fs_info, "Transaction %llu aborted (error %d)",
> 
> There's already a local fs_info variable, no need to trans->fs_info.

Ah, copy&paste leftover, I'll fix it in for-next, thanks.
