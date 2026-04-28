Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA822C3252
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777389426; cv=none; b=ImE5mDZBDiXkC3LSrgWGc4ZBmkIAWLmOjWkD5A2b/KjzlDkb8q5STpeWr3zEXDBKyOy/BM+YBiOsypLfOfutCsM+BLjFb92bYDJ0W7eAYzJegl2PqqUCRrwGq7IB+7ummYuGBwvp5zalVOIuAv6RfIwJFlo9w/grEN4f99ydSns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777389426; c=relaxed/simple;
	bh=HqT79Jv/LzvfW2LFj4U+IRlCxKb/K+fegux1cYGnDLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeMNO6cO+4zq1fu8rJiJYlsTNDwGwuq99fVu+MwhcrZIdzoCG/txqiBd0hO8ALNWo9uVFOUoKMn4l4GT3ntOS3SexUbGFyQFF2IYyMRwe+iX6dz9ZoazGZcQ3OsRBym/GqyNffEd/13MzfLWwQ5DhDWOSDt7Fc6THb+X7o51Jy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OHVTEnny; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VNCtkUHm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OHVTEnny; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VNCtkUHm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OHVTEnny";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VNCtkUHm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OHVTEnny";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VNCtkUHm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 05B145BD58;
	Tue, 28 Apr 2026 15:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777389422;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGbnNoNdVyQ5LbhaxAVvEr1+2vxI3SS2DqwwarmPIEo=;
	b=OHVTEnnyB2iz22S9h6ZK0OsaqwHv6X3+omBrBsztC5i9z1AkKWcMANjd+db+3OxrOUdhYq
	7dXE8nsD1TNT2jv9dQbUYkoZ61pYOhQRvdJcrokKN4KcMv8MJXR5SCbrYhivG6m024WxeH
	nmwNQD0C5JFNueTDlmcUOU4DUznygME=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777389422;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGbnNoNdVyQ5LbhaxAVvEr1+2vxI3SS2DqwwarmPIEo=;
	b=VNCtkUHmWCVwQ6yG+IBRL3J4lwPiByT/ndZHzwkR2uYbAQjHFrDzOOgpvnUa5uJ4wolvr5
	t3TUs1+d09LwlcAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OHVTEnny;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VNCtkUHm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777389422;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGbnNoNdVyQ5LbhaxAVvEr1+2vxI3SS2DqwwarmPIEo=;
	b=OHVTEnnyB2iz22S9h6ZK0OsaqwHv6X3+omBrBsztC5i9z1AkKWcMANjd+db+3OxrOUdhYq
	7dXE8nsD1TNT2jv9dQbUYkoZ61pYOhQRvdJcrokKN4KcMv8MJXR5SCbrYhivG6m024WxeH
	nmwNQD0C5JFNueTDlmcUOU4DUznygME=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777389422;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGbnNoNdVyQ5LbhaxAVvEr1+2vxI3SS2DqwwarmPIEo=;
	b=VNCtkUHmWCVwQ6yG+IBRL3J4lwPiByT/ndZHzwkR2uYbAQjHFrDzOOgpvnUa5uJ4wolvr5
	t3TUs1+d09LwlcAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8843593B0;
	Tue, 28 Apr 2026 15:17:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1hiROG3P8GnBWwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 28 Apr 2026 15:17:01 +0000
Date: Tue, 28 Apr 2026 17:17:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	AHN SEOK-YOUNG <iamsyahn@gmail.com>,
	Teng Liu <27rabbitlt@gmail.com>
Subject: Re: [PATCH v3] btrfs: warn about extent buffer that can not be
 released
Message-ID: <20260428151700.GG3906171@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4ac4a9f2c599841b00f39f3be082432f43130f3e.1776379191.git.wqu@suse.com>
 <20260427154805.GQ12792@twin.jikos.cz>
 <f94d6fe3-e4a5-42ac-bf2b-47d126dbd46b@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f94d6fe3-e4a5-42ac-bf2b-47d126dbd46b@gmx.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmx.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,suse.com,vger.kernel.org,gmail.com];
	RCVD_COUNT_TWO(0.00)[2];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 05B145BD58

On Tue, Apr 28, 2026 at 07:31:50AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/28 01:18, David Sterba 写道:
> [...]
> >>   
> >> +static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)
> > 
> > This is too close to the generic invalidate_inode_pages2, please add
> > btrfs_ prefix.
> 
> Sure, and I'll try to get a better name for it, as we also have 
> btree_invalidate_folio().
> 
> [...]
> >> --- a/fs/btrfs/transaction.h
> >> +++ b/fs/btrfs/transaction.h
> >> @@ -255,13 +255,13 @@ do {								\
> >>   		__first = true;					\
> >>   		if (WARN(btrfs_abort_should_print_stack(error),	\
> >>   			KERN_ERR				\
> >> -			"BTRFS: Transaction aborted (error %d)\n",	\
> >> -			(error))) {					\
> >> +			"BTRFS: Transaction %llu aborted (error %d)\n",	\
> >> +			(trans)->transid, (error))) {			\
> >>   			/* Stack trace printed. */			\
> >>   		} else {						\
> >>   			btrfs_err((trans)->fs_info,			\
> >> -				  "Transaction aborted (error %d)",	\
> >> -				  (error));			\
> >> +			"Transaction %llu aborted (error %d)",	\
> >> +				  (trans)->transid, (error));	\
> > 
> > Adding the transaction number adds like 4KiB of object code because the
> > calls are inlined so we can have exact location and stack.
> > 
> > It could be possibly moved to __btrfs_abort_transaction() but with some
> > additinal shuffling of the code from macro to the handler.
> > 
> 
> I can remove the transid part, as it doesn't contribute to the final bug 
> that got pinned down.
> 
> It's mostly a precautious debug feature.

I have found a way how to reclaim 22K of object code, so the transaction
id can stay. I'll post the patch once you send v2.
