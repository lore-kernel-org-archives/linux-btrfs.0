Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409ED2E54AA
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 03:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777348396; cv=none; b=gQQmwpiRllp6ScM3obkHOnnnQDxN7eLkk/lvY2829nqsaup/rW9qgSk3gJpH5aGogw2PT3ABpI/CPNXx8l4aU18QyrBcNgagC6llgJtZNtfgKAihMuQxjSfoYaL10r/69kF2EmasCkG4TE1a+m0Mw2fGp+du7CBw9anxa7EDw/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777348396; c=relaxed/simple;
	bh=8G8uW9cxpR1hQAfIj2hKf+eBbcmoTcTPWInieBoDbBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCmxFffBMeODnH4KoW8xX89fut76ZDtrSrfe5O5qBUzjSVgnLrSL2LrGQpLpY/yVjrpvP46lSdHune+xEibM7v2LAZvYHQCs55iHl4TcrRLy9Qids3ijvz5lIqY5BNQFYnyv1mzXMac8gu0WVnTKZCTfdv5aNKqu3mB46c5etbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=akB6HmKZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HzQrvIJS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DQ8dKVPO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nBBmeW7x; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="akB6HmKZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HzQrvIJS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DQ8dKVPO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nBBmeW7x"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 48E976A91F;
	Tue, 28 Apr 2026 03:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777348393;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r+vKfGL9stJPEbfwl+wfcUBhvJUwV06iC3McCiPwOTg=;
	b=akB6HmKZmpVljgwlWwFwBPNnETK67wExDOTCvJOD0na75SehGpihmWPkDNLYnULr8WbqPL
	FtJvUEumpT56WxLhNQefeba05tAju1v/Wl3eijmNCWBeRrJHbnZbzBEChvtBJanM25yeUl
	ZVnKVxMY4TWrMpAmzu/7kkgFcSkdMdU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777348393;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r+vKfGL9stJPEbfwl+wfcUBhvJUwV06iC3McCiPwOTg=;
	b=HzQrvIJSHIaM1ZUt42+KK9IQxMvU1GZXNw/BEXrh69xqRoR6nkTIH20OEWqZn9R8LsxBJJ
	DivTFfjtM6ccsoBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777348392;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r+vKfGL9stJPEbfwl+wfcUBhvJUwV06iC3McCiPwOTg=;
	b=DQ8dKVPORIqFUxKi1C+WGIW6tc/P8CzftYk7lVU8znws3kGDSdBW+NlsuSMlFVs5O2wb07
	kmHyDK2rcfP7guj5ATp1nXyb8ssY5r9gnpH02mndz5DdnP2uEiHjIG5vH9zfH1zbdGXheV
	6xzVNHT6UJurnv/Z7hpfFbxEVV18bYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777348392;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r+vKfGL9stJPEbfwl+wfcUBhvJUwV06iC3McCiPwOTg=;
	b=nBBmeW7xPfoebiXd4OGvdVaEQZFFCIBmT+85S57a+maUFXPMHT+89of/YR+me1ivSAZC4T
	RSU4IfRo5WUdt8Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2978F593B0;
	Tue, 28 Apr 2026 03:53:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n686CSgv8GlTKAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 28 Apr 2026 03:53:12 +0000
Date: Tue, 28 Apr 2026 05:53:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: enable cross-folio readahead for bs < ps and
 large folio cases
Message-ID: <20260428035302.GE3906171@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1777189624.git.wqu@suse.com>
 <4eaa4b5b1839aecd6a2bed8f995e8430fcea8ba0.1777189624.git.wqu@suse.com>
 <20260427132155.GJ12792@twin.jikos.cz>
 <af83ea95-fcf2-4405-9d63-2f4e70296105@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af83ea95-fcf2-4405-9d63-2f4e70296105@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmx.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmx.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Tue, Apr 28, 2026 at 07:24:00AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/27 22:51, David Sterba 写道:
> > On Sun, Apr 26, 2026 at 05:21:03PM +0930, Qu Wenruo wrote:
> >> --- a/fs/btrfs/compression.c
> >> +++ b/fs/btrfs/compression.c
> >> @@ -358,10 +358,7 @@ struct compressed_bio *btrfs_alloc_compressed_write(struct btrfs_inode *inode,
> >>    * Add extra pages in the same compressed file extent so that we don't need to
> >>    * re-read the same extent again and again.
> >>    *
> >> - * NOTE: this won't work well for subpage, as for subpage read, we lock the
> >> - * full page then submit bio for each compressed/regular extents.
> >> - *
> >> - * This means, if we have several sectors in the same page points to the same
> >> + * If we have several sectors in the same page points to the same
> > 
> > The sentence seems to be missing some words, or I don't understand
> > what's the meaning here.
> 
> This means the situation like the following:
> 
>        |      Folio range       |
>        | Ext A|    | Ext B|
> 
> Where Ext A and B are backed by the same compressed extent.
> 
> In that case, if we're reading Ext A, the readahead won't work for Ext B.

Ok, so it should read "If we have several sectors inthe same page
that points to the same ...".
