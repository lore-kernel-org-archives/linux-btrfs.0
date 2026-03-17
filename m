Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4E63101B9
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764689; cv=none; b=aE0tE81IwT5Ksb8vbCQwcVl7o1fj+QmYXAvUxW+NBf6FF7Lrg2YKMPsRL4D8C1vvgfAK0PaWFNBXHbg+oU6OJoi+IcMB6Jvjkt1ycr8/LTj9XFLE1HzEs33RFq3EgKOodNYwHnySaKCknHfFkbRiqbOFu8k21sgiB+tqFCZJVhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764689; c=relaxed/simple;
	bh=gWQRvD3kdBhrFN4gOShHMexQxg3xx+OPrFerdONqiqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lLv8KL4M58F0ZCQlqJewyEAHyS/1wwBCowYCTPRS55qEMaKMrtjoJggEnpwY2ZEKqdCn7GSOBs1CiMLcNDcCYCmCo2wkLw/PvTpexS5VGP0A58yyBAiboeUH88f+w5dkslCKC+PZUmCZe2yd1ObY3fyzKUOZS8szW7uu5FT0dvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z1zFlVhK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HhKvFJEu; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z1zFlVhK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HhKvFJEu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z1zFlVhK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HhKvFJEu";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z1zFlVhK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HhKvFJEu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BCCD25BD0E;
	Tue, 17 Mar 2026 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773764686;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=80ULt3RX5SL2v1wxlv+cNAJXCTwiCzDGtecS6+iE17Y=;
	b=z1zFlVhKgPc2wHvm2px8iJfuqIsY9X7VDjUuMq+HbGsFz2Yz59aSKlg2L9qbczYuag8SPZ
	iN0XzW67PYFOvfQjVExZoI33VGZzOFX8TR1gwmHwG7jtpVuSTtNa4AJ5r7eh0hRUULR1z3
	nJqmOF4IP4suPPTwy9kHjUY8wnNQ8nQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773764686;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=80ULt3RX5SL2v1wxlv+cNAJXCTwiCzDGtecS6+iE17Y=;
	b=HhKvFJEup5JgnrljVVB4xB+TEDZ47szQYBhyX/HyBOsQ+PmoZxzngXMfAdrCKn0TbW+fm1
	B5e9SVpWocDy36Aw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=z1zFlVhK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HhKvFJEu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773764686;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=80ULt3RX5SL2v1wxlv+cNAJXCTwiCzDGtecS6+iE17Y=;
	b=z1zFlVhKgPc2wHvm2px8iJfuqIsY9X7VDjUuMq+HbGsFz2Yz59aSKlg2L9qbczYuag8SPZ
	iN0XzW67PYFOvfQjVExZoI33VGZzOFX8TR1gwmHwG7jtpVuSTtNa4AJ5r7eh0hRUULR1z3
	nJqmOF4IP4suPPTwy9kHjUY8wnNQ8nQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773764686;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=80ULt3RX5SL2v1wxlv+cNAJXCTwiCzDGtecS6+iE17Y=;
	b=HhKvFJEup5JgnrljVVB4xB+TEDZ47szQYBhyX/HyBOsQ+PmoZxzngXMfAdrCKn0TbW+fm1
	B5e9SVpWocDy36Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4DB24273B;
	Tue, 17 Mar 2026 16:24:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pMgVKE6AuWkwewAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 17 Mar 2026 16:24:46 +0000
Date: Tue, 17 Mar 2026 17:24:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Christoph Anton Mitterer <calestyo@scientia.org>
Subject: Re: [PATCH] btrfs-progs: docs: add a note for clear_cache mount
 option
Message-ID: <20260317162441.GX5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <bac89ac52147344ab6244beef8c0085552a3aacb.1770438921.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bac89ac52147344ab6244beef8c0085552a3aacb.1770438921.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,scientia.org:email,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BCCD25BD0E

On Sat, Feb 07, 2026 at 03:05:22PM +1030, Qu Wenruo wrote:
> There is a report that "clear_cache,space_cache=v2" mount option didn't
> rebuild the free space tree.
> 
> It turns out that the reporter was relying on the fstab to do the mount,
> and the fstab has specified "ro" mount option. This prevents btrfs to
> enter btrfs_start_pre_rw_mount() thus no free space tree rebuilding.
> 
> Add such note to avoid future confusion.
> 
> Reported-by: Christoph Anton Mitterer <calestyo@scientia.org>
> Link: https://lore.kernel.org/linux-btrfs/f094ddbb70cabd2e329615269519b1844f786629.camel@scientia.org/
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to devel, thanks.
