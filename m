Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1213E3DB8
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 16:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776271439; cv=none; b=rGatcUtCRAFKku7d5VT2ql2f/WZGdkUfR4xAjc/tweHTuH/n/9mQibcWY2C9rjDby9a4RROrRWSvZjy6yUrW2pVdsgaA5ZP1F2FQTres3lxDucpIMdmxOzsO7wYa6cHvbl9sUCUyJFhFsKn85UFYnyR1O8tEF/cW+dUyTz8SjC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776271439; c=relaxed/simple;
	bh=Da+aaNYOipa8DuPHmwhnh88Xp9N7CVrjhzpZoDzE7x0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nI9iZxW7UFUNc6mgCdO4gmVv7uIpn57Uz0rNW7S2OH0BMPBZlpW1Lag2rejzvN3FFB667wK+D5p6uxnNkKSz6JZPJyNXmlQNAtBX8uaJo2LsMO1YEzf9/J0vEzVwsQ2qunjZWl81ANSMShk2wTHUb+E+POm3mO92Ia1WcOh7Wj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hvjCEjJO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=C4dTPthX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hvjCEjJO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=C4dTPthX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hvjCEjJO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="C4dTPthX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hvjCEjJO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="C4dTPthX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 21AD36A875;
	Wed, 15 Apr 2026 16:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776271431;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QZGsK3Jp4UqZ+cwIJ63MbU4WUqd9E9g6bxNsNQo4tKY=;
	b=hvjCEjJOomYTW7VbvBYyDK8Fb9BecgXgD6IptFOq/LnjJUnKj7pZMBVmjNLY+vg3vA5ZQq
	NN8HXFXhha/k7lnoi4yBrXWq7x3tXBx6yol+1/PDPM/qLTWj8gsDrlm/ps95Ixzt7RizIH
	Z1Q+cZalR0xgZGwXreFGy0ImccD1dmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776271431;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QZGsK3Jp4UqZ+cwIJ63MbU4WUqd9E9g6bxNsNQo4tKY=;
	b=C4dTPthX12DLBx6Z1w/de8H2neu+PBdB04I1DggVN/xzPdEXAX7tE2+rFTJ50JxQvQu2cR
	tmGBB74AyORBGhCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hvjCEjJO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=C4dTPthX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776271431;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QZGsK3Jp4UqZ+cwIJ63MbU4WUqd9E9g6bxNsNQo4tKY=;
	b=hvjCEjJOomYTW7VbvBYyDK8Fb9BecgXgD6IptFOq/LnjJUnKj7pZMBVmjNLY+vg3vA5ZQq
	NN8HXFXhha/k7lnoi4yBrXWq7x3tXBx6yol+1/PDPM/qLTWj8gsDrlm/ps95Ixzt7RizIH
	Z1Q+cZalR0xgZGwXreFGy0ImccD1dmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776271431;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QZGsK3Jp4UqZ+cwIJ63MbU4WUqd9E9g6bxNsNQo4tKY=;
	b=C4dTPthX12DLBx6Z1w/de8H2neu+PBdB04I1DggVN/xzPdEXAX7tE2+rFTJ50JxQvQu2cR
	tmGBB74AyORBGhCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 028174BAE5;
	Wed, 15 Apr 2026 16:43:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8dFBO0bA32kdJgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 15 Apr 2026 16:43:50 +0000
Date: Wed, 15 Apr 2026 18:43:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, wqu@suse.com,
	boris@bur.io
Subject: Re: [PATCH v3] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
Message-ID: <20260415164345.GR12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260413171440.116041-1-mark@harmstone.com>
 <20260414020739.GK12792@twin.jikos.cz>
 <e1861274-8d36-4a79-8092-aa7e2ba39240@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1861274-8d36-4a79-8092-aa7e2ba39240@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 21AD36A875

On Wed, Apr 15, 2026 at 02:56:49PM +0100, Mark Harmstone wrote:
> >> When using the --reflink option added in btrfs-progs v6.16.1, we can forgo
> >> reading the data entirely, resulting a ~2200% speed-up on the same test
> >> (128s to 6s).
> > 
> > Repeated mkfs is a specific use case, normaly it happens just once but I
> > understand that for preparing various images the time savings are
> > significiant.
> > 
> > Once this ioctl is available I think the deduplication tools will make
> > use of it as an initial filter before actually doing the real
> > deduplication of extents.
> 
> IIRC the mathematics of the birthday paradox is that for an n-bit hash, 
> you need 2^(n/2) sectors to have a 50% chance of a collision.
> 
> For the 32-bit hashes, that means a 50% chance of a collision every 256 
> MB. For the 256-bit hashes, that's 2^140 bytes... whatever that works 
> out as. So the dedupe logic would no doubt be that for larger hash sizes 
> GET_CSUMS itself will be sufficient.

It's used as a hint in the initial filter (e.g. in
https://github.com/lakshmipathi/dduper), the final deduplication does
full byte compariison (memcmp() inside vfs_dedupe_file_range_compare()).
