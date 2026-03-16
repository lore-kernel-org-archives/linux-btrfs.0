Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631EC374735
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 09:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773653055; cv=none; b=IZ/bofqSTQwe60L5oGTzYX+jptackD6J7bXQWpde3B0aH8RqnqWiK8URr0V7oatyZotZsZiqavypRarjW5Eteba5I6vGKwdKi0O/1F3DNA2rQVujuu5WyTxZXsR2h+3RdWocZMSBX5lJkuK4umcokz3690FBFIjtXFi3jjgGXLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773653055; c=relaxed/simple;
	bh=4s0dQGyo4gKkJJmdOurgqmRnq4a8uvHmJP2Rri+MnJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulnk5mklObcr9DQc4j0vs3beneNqfC2ck5T+YQQZtc5PuTCU8gnp+lIFAQKMwunu0TYkZ3BnOW1ohxWfk81iSdk6YzRT9vzlxRFm0GL/k14D0gHwwWU8DMcQ+hOE2xBf+ma0ly5h8wOTEUUvOsjc1qgckTbYtieGvO8n7NGnDQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mOhszz0L; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jJD7Cn3e; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mOhszz0L; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jJD7Cn3e; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mOhszz0L";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jJD7Cn3e";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mOhszz0L";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jJD7Cn3e"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 840555BCC3;
	Mon, 16 Mar 2026 09:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773653052;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xooqxCHwYiniiSZpnV6TWlRnFi+U0iKcDOZDUzYP8OI=;
	b=mOhszz0L+CPWThy+tjk/l9yehA0ak9JID2T14TZiEqJEix+jjZ21fe5Jz21zkXWrGn7/8Z
	RdSylPX0lfITzCQ2Vj2zj6whiModAbCGO35Jp4VnLJLnam0SCYrqBxfeLMgfY4suM71XPZ
	P+s7yjoD0Ob1dwxDmbgvZQ2bJioKST8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773653052;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xooqxCHwYiniiSZpnV6TWlRnFi+U0iKcDOZDUzYP8OI=;
	b=jJD7Cn3e31p6iosGZeQ+iMkql96UaGRWBCN9O8hW7pZbuzgKENJ3THaNbtqHWfyznqwMkO
	T45lCxIHmUxaN+BA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mOhszz0L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jJD7Cn3e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773653052;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xooqxCHwYiniiSZpnV6TWlRnFi+U0iKcDOZDUzYP8OI=;
	b=mOhszz0L+CPWThy+tjk/l9yehA0ak9JID2T14TZiEqJEix+jjZ21fe5Jz21zkXWrGn7/8Z
	RdSylPX0lfITzCQ2Vj2zj6whiModAbCGO35Jp4VnLJLnam0SCYrqBxfeLMgfY4suM71XPZ
	P+s7yjoD0Ob1dwxDmbgvZQ2bJioKST8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773653052;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xooqxCHwYiniiSZpnV6TWlRnFi+U0iKcDOZDUzYP8OI=;
	b=jJD7Cn3e31p6iosGZeQ+iMkql96UaGRWBCN9O8hW7pZbuzgKENJ3THaNbtqHWfyznqwMkO
	T45lCxIHmUxaN+BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D5AE4273B;
	Mon, 16 Mar 2026 09:24:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wiukFjzMt2lnGAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 16 Mar 2026 09:24:12 +0000
Date: Mon, 16 Mar 2026 10:24:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: Filipe Manana <fdmanana@kernel.org>, dsterba@suse.cz,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-btrfs@vger.kernel.org, boris@bur.io, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: fix potential segfault in balance_remap_chunks()
Message-ID: <20260316092403.GR5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260225103535.18430-1-mark@harmstone.com>
 <20260225150835.GF26902@twin.jikos.cz>
 <CAL3q7H4dT5aXaw7UsNfWNLccme=HcvbsrgCMuXzNZQRxV1mxjQ@mail.gmail.com>
 <1bbe10ea-90f2-45f2-915e-5895bd0039cf@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1bbe10ea-90f2-45f2-915e-5895bd0039cf@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 840555BCC3

On Mon, Mar 09, 2026 at 06:00:30PM +0000, Mark Harmstone wrote:
> On 25/02/2026 3.17 pm, Filipe Manana wrote:
> > On Wed, Feb 25, 2026 at 3:10 PM David Sterba <dsterba@suse.cz> wrote:
> >>
> >> On Wed, Feb 25, 2026 at 10:35:31AM +0000, Mark Harmstone wrote:
> >>> Fix a potential segfault in balance_remap_chunks(): if we quit early
> >>> because btrfs_inc_block_group_ro() fails, all the remaining items in the
> >>> chunks list will still have their bg value set to NULL. It's thus not
> >>> safe to dereference this pointer without checking first.
> >>>
> >>> Link: https://lore.kernel.org/linux-btrfs/20260125120717.1578828-1-clm@meta.com/
> >>> Reported-by: Chris Mason <clm@fb.com>
> >>> Fixes: 81e5a4551c32 ("btrfs: allow balancing remap tree")
> >>> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> >>> ---
> >>>   fs/btrfs/volumes.c | 18 ++++++++++--------
> >>>   1 file changed, 10 insertions(+), 8 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> >>> index e15e138c515b..18911cdd2895 100644
> >>> --- a/fs/btrfs/volumes.c
> >>> +++ b/fs/btrfs/volumes.c
> >>> @@ -4288,17 +4288,19 @@ static int balance_remap_chunks(struct btrfs_fs_info *fs_info, struct btrfs_path
> >>>
> >>>                rci = list_first_entry(chunks, struct remap_chunk_info, list);
> >>>
> >>> -             spin_lock(&rci->bg->lock);
> >>> -             is_unused = !btrfs_is_block_group_used(rci->bg);
> >>> -             spin_unlock(&rci->bg->lock);
> >>> +             if (rci->bg) {
> >>> +                     spin_lock(&rci->bg->lock);
> >>> +                     is_unused = !btrfs_is_block_group_used(rci->bg);
> >>> +                     spin_unlock(&rci->bg->lock);
> >>>
> >>> -             if (is_unused)
> >>> -                     btrfs_mark_bg_unused(rci->bg);
> >>
> >> Not related to the patch but isn't this pattern inherently racy?
> >>
> >> The "used" is read under lock but then btrfs_mark_bg_unused() is outside
> >> of the lock so the status can change. This can be seen it more places,
> >> but they seem to be related to the remap tree feature.
> > 
> > It's not a problem since when attempting to delete unused bgs we skip
> > any if they are actually used.
> > It's done not just for this type of race but also for the case where
> > after added to the unused list, it becomes used before the cleaner
> > kthread runs to delete unused bgs.
> 
> Yes, the unused list means less "these BGs are definitely unused", more 
> "these BGs are worth considering as maybe unused".

So if there's a question or need for clarification in a patch thread
please add it as a comment (commit updated).
