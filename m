Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8829B3845A6;
	Tue, 18 Aug 2026 12:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787055280; cv=none; b=TJqSAyblvZK+y1HOFuGJNdEpKBPrSlIGz8XtsMOHssfO73b/iQ1faoG5mMGRzPDtse3J1uoDIJA0coZK6bsQy2ShP4d5RH6C2/fn+LMBEWzTPS97vi/pwxVhKTSK4XhntAF657l929gjyJDq2uQxI26/ve8oJE9E+UAJ1kuZKMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787055280; c=relaxed/simple;
	bh=yvP7rqx/Ugc6VqcOhVBArY0h8lXXKsMaP2fGT4S2r78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DyW9Th9Vx4KctPEBJBkK5aCUK69j+k6zaaXl/6wdF8mySiz0hsD5MOZxvtycATY3bEXNuJ4XfPm8je4gEMRDxGHTfRQaGm8I51RR8fjrYIuMPPLw1L0G+VMhJEo+kgVTk8tjbl0f56VFkuRblvyvr1TdX07OdyPsFCn2WX6run0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=y+7lRhTM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sepKea5M; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dHBT15vv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uKEfd36f; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="y+7lRhTM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sepKea5M";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dHBT15vv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uKEfd36f"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 782D53E56;
	Tue, 18 Aug 2026 12:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787055207;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4CvobojYtru1KplgVKX5ZCwO82HEpFDVCxJdVFzbwY=;
	b=y+7lRhTMny0nu8l6kUfoPvFHTaCNPuu6TH1We1Hq5a5/IOKkyXlKREvh+gECq83nIntbET
	m/7d0k18H7grm6AR8XgJxWpfAHlpwWYQNwl35mcsUPOv9u+PsMImumMtjC0rdJzIXzaPqc
	INsBwBKMeYkDIDJ57mtDiB92dtei4/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787055207;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4CvobojYtru1KplgVKX5ZCwO82HEpFDVCxJdVFzbwY=;
	b=sepKea5M8SYHZ2Kn7KIoXCdiIVEzT9UMUuS4KLArlvOxgJ/PFaJxXTyYsRG5YfnaRshMGv
	DMIS3806OOz46tDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787055203;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4CvobojYtru1KplgVKX5ZCwO82HEpFDVCxJdVFzbwY=;
	b=dHBT15vvBq9W3x0geBHgG+s8osm0iwf8+OF0mbvDY/xaoL6iqvj7atZg7u9yyUrPBAuyXx
	Iv8K2I9AcG048Mozx55XwWs8EJHGh/RIvSSLw7kdsUEfk1j+I9zu+cjIWqERGB69Wuw3an
	ml1jFiSqYddb8WGyx+ASkZ76j3/IXpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787055203;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4CvobojYtru1KplgVKX5ZCwO82HEpFDVCxJdVFzbwY=;
	b=uKEfd36fegqkpjR2/gKiTddljw/79c6ruAdZf+xRK60iKUV4vULqMt4ksxvHw1d3ncTGyz
	UAkOPrwuisVwWABg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C2C522BA;
	Tue, 18 Aug 2026 12:13:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wWs0GmNMhGopewAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 18 Aug 2026 12:13:23 +0000
Date: Tue, 18 Aug 2026 14:13:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Laurent Lyaudet <laurent.lyaudet@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC] "final" flag for a directory
Message-ID: <20260818121131.GD54102@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAB1LBmsQ2xFHQeEDFspwpFSNkiFUefBCn559EJsfEz5ZUAXYiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB1LBmsQ2xFHQeEDFspwpFSNkiFUefBCn559EJsfEz5ZUAXYiA@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Mon, Aug 17, 2026 at 04:26:31PM +0200, Laurent Lyaudet wrote:
> I had an idea about adding a boolean flag "final" on directories in an
> advanced filesystem.
> In the same way, the "final" keyword on a class in OOP can be added to
> declare no subclass can exist,
> the "final" boolean flag on a directory could be added to say that the
> directory has no/must not have any subdirectory.

Do you have an existing use case for that?

> So here we see that 2 flags could be added:
> - a configuration flag "must_be_final" forbidding to create a subdirectory,

I see two possible semantics of that:

- final, no subdirectories exist and new ones cannot be created
- no new subdirectories can be created, but some may exist

Also given how other attributes behave once set they can be unset. This
is up to the user, and possibly a restricted operation.

> - a status flag "is_final" telling that no subdirectory currently exists.

When the filesystem tracks the number of subdirectories already, then
it's an easy check. Otherwise a full search must be done, atomically wrt
creating new subdirectories.

> I think it may allow some small optimizations.
> With a very limited search on the Internet, I found no similar thing before,
> but I do assume that I'm not the first one to have this idea of
> marking the pseudo-leaves of the filesystem tree.

> Please, let me know if this should be discussed elsewhere.

If fsdevel is not interested we can still discuss it on btrfs
mailinglist. I've been collecting ideas for new file attributes (listed
below), but not all are generic enough for other filesystems (e.g.
nodatasum).

The fileattr interface (wrapping the old flags and XFLAGs) has some
spare bits and is on the VFS layer, this would be ideal but I don't know
if it's viable if there would be just one filesystem.

- noinline (reusing NOTAIL), nosymlink, nodatasum, nodefrag, noautodefrag,
  "new directory is subvolume" (reusing TOPDIR)

Some of them may need an incompat bit so it would be better to add them
all at once rather than one by one.
