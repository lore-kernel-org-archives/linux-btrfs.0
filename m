Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61034368964
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 18:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772130882; cv=none; b=ieZEADu1eZWzmS+xIeO4Arhpylu1oqoA2FkiKfbBNDeTGoKTBDwTLr7F+BmXiqJ95DCtNaqQ59ZuEdTx1F7YTfhF04Uy7jFaeytJgMWlJ8fphm10IzIetGK/BXd13lqQ3S5Hkj8thYXFuH8UNiL7MwuNqKBl/brnb9EoP2NH5+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772130882; c=relaxed/simple;
	bh=OK0UAJKK82kJWQiaQzB+7NeehzwmBu3lV9qjd4oqOZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAdXfKnq86ZpvOjM1A7/SP/z/qMgY7nCCqMetuOeBoRJX4xNyZi4apVBsSbCxLB7NhfdmKGah+dFpUkUHEq1S4sk2MTXGfwLSSspscyChLoT5YfoiMtfLNIOTx82+AS2CRlRcIL3ntGdfPlq2D6M9qbAuWOXyQfpPJNgWMY0bDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QwNEjzjW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kdn0qK7N; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QwNEjzjW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kdn0qK7N; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QwNEjzjW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kdn0qK7N";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QwNEjzjW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kdn0qK7N"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 65B773FDC7;
	Thu, 26 Feb 2026 18:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772130879;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OK0UAJKK82kJWQiaQzB+7NeehzwmBu3lV9qjd4oqOZg=;
	b=QwNEjzjWCf3SloHNbXZdPDE8DyXp18uc2FF4U0U8f31gfCJrYCv0msG+jqqJQ1R9PsBGtw
	/wAW0rDvTZhVUWfhXR2m6l5HFnPDv9LdusEFaoq8BnsCY9Lntp39eCrFCAonov8ny24TCe
	F8ZtXUR485GMLdY2Wni7VtvX2QZ7VQ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772130879;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OK0UAJKK82kJWQiaQzB+7NeehzwmBu3lV9qjd4oqOZg=;
	b=Kdn0qK7N9Jq+/Tkl9imsqwaTFfY30sq24C3M3dEq/672/UkFE2sNH9KXfF7lZafiJnliKj
	h5TKhIRSWbu2jiCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QwNEjzjW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kdn0qK7N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772130879;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OK0UAJKK82kJWQiaQzB+7NeehzwmBu3lV9qjd4oqOZg=;
	b=QwNEjzjWCf3SloHNbXZdPDE8DyXp18uc2FF4U0U8f31gfCJrYCv0msG+jqqJQ1R9PsBGtw
	/wAW0rDvTZhVUWfhXR2m6l5HFnPDv9LdusEFaoq8BnsCY9Lntp39eCrFCAonov8ny24TCe
	F8ZtXUR485GMLdY2Wni7VtvX2QZ7VQ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772130879;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OK0UAJKK82kJWQiaQzB+7NeehzwmBu3lV9qjd4oqOZg=;
	b=Kdn0qK7N9Jq+/Tkl9imsqwaTFfY30sq24C3M3dEq/672/UkFE2sNH9KXfF7lZafiJnliKj
	h5TKhIRSWbu2jiCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C0603EA62;
	Thu, 26 Feb 2026 18:34:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l/4xEj+SoGlrHAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 26 Feb 2026 18:34:39 +0000
Date: Thu, 26 Feb 2026 19:34:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: WenRuo Qu <wqu@suse.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: remove the folio ref count ASSERT() from
 btrfs_free_comp_folio()
Message-ID: <20260226183438.GH26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <30541df912ac4a2dd502796a823558fe1d88baa0.1772065237.git.wqu@suse.com>
 <ea88634d-d52a-4eea-832f-528177e82321@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea88634d-d52a-4eea-832f-528177e82321@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 65B773FDC7

On Thu, Feb 26, 2026 at 06:43:07AM +0000, Johannes Thumshirn wrote:
> On 2/26/26 1:21 AM, Qu Wenruo wrote:
> > Inside btrfs_free_compr_folio() we have an ASSERT() to make sure when we
> > free the folio it should only have one reference (by btrfs).
> >
> > However there is never any guarantee that btrfs is the only holder of
> > the folio. Memory management may have acquired that folio for whatever
> > reasons.
> >
> > I do not think we should poke into the very low-level implementation
> > of memory management code, and I didn't find any fs code really using
> > folio_ref_count() other than during debugging output.
> >
> > Just remove the ASSERT() to avoid false triggering.
> >
> Just curious, did this trigger any bug or did you find it by coincidence?

With other tests' workload it was triggered by btrfs/011 on a machine
with 1G of memory.
