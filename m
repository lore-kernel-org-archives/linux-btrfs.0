Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E77470E82;
	Mon,  7 Sep 2026 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778374; cv=none; b=VB8jSr0BHkIhH3hMnqzC6YtKF9zK4oPxhCTNZbZjJ239ErYL3F8ox8EiqcadA2fejio7uVb6hjBvOQlhz6WwWMPuz2WbjqUb0hl1GcicKrPQEZ75sO0vMji053XQIQAce9cRWcE58cWnqOS54sBaIxdhPtdEPHIfNrtut//Utn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778374; c=relaxed/simple;
	bh=N28ewpX7N3bA9g71+nxi0rT5L9WfPwSDg+4CKITd+kU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTW4WuMnZEsuCACrGXLTD0EbfDkIreToyyDKkJjT9+jchwk99XwscAgnVvi10stab697LUb2wHSMQkZAdfT7mJSupG/gbsSP3MrHJtHBRd+aUBk92mr2+c0ztcuK9F1zQVWoa2n51/BmCMOfT+J+uiV8REEjHTm5lqm1cTvLwLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JXjNGmxO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UzSQcXFi; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gzM1bwSE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=neOUEfFz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JXjNGmxO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UzSQcXFi";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gzM1bwSE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="neOUEfFz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2249A21B06;
	Mon,  7 Sep 2026 10:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788778367;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BDnhj+puPtBkSBVY2DyQxuswoBH00trO9jNNn96qX1U=;
	b=JXjNGmxOaYewBO940hXPNqX6OOK1NvQNKDkJFMHpn9f1EjxGtfvabP/3OfLP29CCnB99Qj
	pYsER4JLLN7kENkqzn6Pn2KsjdH5zI7KxslwkxudanjewDtU0FaS55s1Q7A0QBPajoEZ4K
	A4rlo5wNwvm8dQRzh5TXznBWYrpWjfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788778367;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BDnhj+puPtBkSBVY2DyQxuswoBH00trO9jNNn96qX1U=;
	b=UzSQcXFidQEJ/7xzjpI/BLHqaBIjtDMxSbdm9tkUaxoJSPajJ7XivfMFK+NtWm1zEEtJG4
	iYKX5KhEnE+btjBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gzM1bwSE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=neOUEfFz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788778363;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BDnhj+puPtBkSBVY2DyQxuswoBH00trO9jNNn96qX1U=;
	b=gzM1bwSElxWMTcfhxn5gV1hKTex2bqJcd/rVrGb3ZGHUyFMNMqe5B3dlJi8IuCs+Prv3KZ
	tE+c8aNYEOhClGc9hA7B91rMZSJiZz05NleXyQf/n/FQsjRC6iH2m9k/h2YxW3HNC8j0Js
	BdTkk3MaAjDiAd+/KCqIW+D9FRKUoOI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788778363;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BDnhj+puPtBkSBVY2DyQxuswoBH00trO9jNNn96qX1U=;
	b=neOUEfFzHMlypFUUYpR58iEYSkNHuQD/sNRu5CNKQc9FODs7sSBXF7QBOpPydwdawZpor/
	zo4HuG6qL2+ZTuAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF5CF13432;
	Mon,  7 Sep 2026 10:52:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 55Q0OnqXnmrmTgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 10:52:42 +0000
Date: Mon, 7 Sep 2026 12:52:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@fb.com
Subject: Re: [PATCH v3 1/6] btrfs: use an on-stack path in
 btrfs_insert_orphan_item()
Message-ID: <20260907105237.GT9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
 <20260811-btrfs-enomem-v3-1-46a993fc3fe5@kernel.org>
 <20260820120428.GA9053@suse.cz>
 <e69401476a5241e73d3f81c5cf74229bfc31a044.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e69401476a5241e73d3f81c5cf74229bfc31a044.camel@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 2249A21B06
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Thu, Aug 20, 2026 at 08:49:52AM -0400, Jeff Layton wrote:
> On Thu, 2026-08-20 at 14:04 +0200, David Sterba wrote:
> > On Tue, Aug 11, 2026 at 02:14:54PM -0400, Jeff Layton wrote:
> > > btrfs_insert_orphan_item() allocated a btrfs_path with btrfs_alloc_path()
> > > which returns -ENOMEM on failure. It is called from btrfs_orphan_add(),
> > > so a path allocation failure there turns a recoverable error into a
> > > transaction abort.
> > > 
> > > btrfs_path is only ~112 bytes, so allocate it on the stack instead.
> > 
> > 112 is too much for on-stack, we've avoided that for btrfs_path in
> > particular, except some justified cases. This means in general the
> > beginning of call stack like ioctl, syscall handler and such. Otherwise
> > we assume there are other layers in the IO stack, like block device
> > drivers (DM), NFS, encoding layers or networking (iscsi), and obviously
> > the lowest level device drivers.
> > 
> > The trade off with possible allocation failure vs stack consumption
> > needs to be argued in the changelog, "is just 112" is not sufficient.
> >
> > Getting back the consumed stack space is painful, we've been reducing
> > unneeded or redundant parameters of functions for years. The gains are
> > like -8 bytes here and -8 bytes there, allocation of +112 wipes that out.
> > 
> > If the place of allocation is critical we can consider that but we have
> > too many of them, anywhere during the transaction commit path or
> > irreversible metadata changes. Possibly using __GFP_HIGH could work, but
> > I haven't explored that.
> > 
> > Qu added the patches to for-next but I had no chance to look closely at
> > this patchset yet and am hesitant to leave it like that.
> 
> Fair critique. These days I think we're mostly ~16k stacks, but it can
> certainly get deep given the right layering.
> 
> In this case, failing this allocation can lead to aborting the fs, so
> it seemed justified. This is a GFP_NOFS allocation too, so it can
> easily fail, even though it's small.

The MM guys say that small NOFS allocations are technically "nofail",
but with cgroup limit it can fail under normal circumstances too. We got
reports from syzbot and other tools that can trigger the memory
allocation failures in places difficult to handle (e.g. extent state
tree changes) but this practically never happens.
