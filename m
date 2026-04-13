Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA82389110
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 18:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776106759; cv=none; b=E+AI47BBlHTsUKlqoiCAKGzfAq9co81nINslulNSgCBVYIFR5B+tcma0zda0n3JgbnOQmuTxSVHZeNloMeb9JWAWJKZeo35XJvKAxSAkiPWRT9fh9IRyS7fhHLUyyeuxfUtHJbRZTwBglQZSRGH3PuKyf296LLZl/w5qepvVfsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776106759; c=relaxed/simple;
	bh=BIFDykBqC9UurrG0Wq4o94vSOSyDVjKt+7WLNlksi6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iAKi7OkUAoDcykStDVtO8v+G4Ox8XHvxUCl9olv8l+6C3conePHg8uKKBaFDOgw/CEnFa6HJ0fFQD+mZdAeVR6jl0g8w3mY5++dFRUnsXaN/WqiwS1dbD6EyebqtLtR5tgIN9FoSGq9gxC4ZU6xmUU0xLLoBwaGx9kZlg64tLic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wpukP5d8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gLRees7W; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wpukP5d8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gLRees7W; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wpukP5d8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gLRees7W";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wpukP5d8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gLRees7W"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 626EF5BD8F;
	Mon, 13 Apr 2026 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776106756;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wVOVqLMTCa1O3SbAzlSybF5naUSqAGahoBLRDQF40bw=;
	b=wpukP5d8VVcjgaCAc1oYBOpm4Rg5jAogCGwMSMyHtq3VCwofJStaNIZHxseE8ICjsTYN1N
	dOVDhhk9mxx/fPmjki6QWTbr74GIksnEp0MGxqhDFUbfFkGXxV8TnMz5Bazcvetndltulj
	pQAMkZnPvIz64BELTQCwsZPu4LZoN1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776106756;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wVOVqLMTCa1O3SbAzlSybF5naUSqAGahoBLRDQF40bw=;
	b=gLRees7Ww67yjoleysn6FaKVkBfXyII/LnGw5f8+zZWSCZWeG84azNCvZqOs3Ul/2XKW9z
	YndVaSo0nH4eiqCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wpukP5d8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gLRees7W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776106756;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wVOVqLMTCa1O3SbAzlSybF5naUSqAGahoBLRDQF40bw=;
	b=wpukP5d8VVcjgaCAc1oYBOpm4Rg5jAogCGwMSMyHtq3VCwofJStaNIZHxseE8ICjsTYN1N
	dOVDhhk9mxx/fPmjki6QWTbr74GIksnEp0MGxqhDFUbfFkGXxV8TnMz5Bazcvetndltulj
	pQAMkZnPvIz64BELTQCwsZPu4LZoN1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776106756;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wVOVqLMTCa1O3SbAzlSybF5naUSqAGahoBLRDQF40bw=;
	b=gLRees7Ww67yjoleysn6FaKVkBfXyII/LnGw5f8+zZWSCZWeG84azNCvZqOs3Ul/2XKW9z
	YndVaSo0nH4eiqCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42B844B030;
	Mon, 13 Apr 2026 18:59:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9gAWEAQ93WlICAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Apr 2026 18:59:16 +0000
Date: Mon, 13 Apr 2026 20:59:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: DEV_STATS item related minor fixes
Message-ID: <20260413185907.GG12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1775553952.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775553952.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 626EF5BD8F
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Tue, Apr 07, 2026 at 07:03:57PM +0930, Qu Wenruo wrote:
> [BACKGROUND]
> DEV_STATS (objectid, not type) items are storing the error counts for
> each device. It's updated every time an error is hit, including
> the following types:
> 
> - READ errors
> - WRITE errors
> - FLUSH errors
>   Above alls are all errors directly returned from the device.
> 
> - CORRUPTION errors
>   Aka, checksum mismatch.
> 
> - GENERATION errors
>   Metadata generation mismatch.
> 
> [MINOR BUGS]
> Recently when debugging an error reported about rejected dev-replace,
> the device tree dump includes a DEV_STATS item for devid 0.
> 
> I'm wondering if that DEV_STATS item will ever be deleted, but
> unfortunately it will never be deleted.
> 
> Normally it's not a big deal, as the DEV_STATS are normally all zeros.
> 
> But if it's not, and a new dev-replace is started and interrupted, at
> the next mount the replace target device will suddenly inherit all the
> error records, giving end users false alerts about a completely good
> device.
> 
> [FIX]
> The first 2 are manually removing the DEV_STATS items when dev-replace
> and dev-removal finishes.

The device stat item is expected by btrfs-progs even if it's just zeros,
otherwise the 'btrfs device stats' prints just 'no stats found'. This
has a high potential to break any monitoring tools or scripts. So please
don't delete the item, and create it empty in case it does not exist.

For the wrong stats on the replaced device the stats should be zero from
the beginning of the operation.
