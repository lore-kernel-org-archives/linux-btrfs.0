Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F4A405ADC
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365996; cv=none; b=COGM/bJwH0UMr68mhzLvDlFDp2EjmZFJyC8/j7A7lYFRHfxHAy8Z9b+B8P+kpS3JQngQxc97O+WG4gAEGzfO7o981VWm7uifwmRZJG/JywfS0CnKLNolt0UDRooKH1yd1bZXq7gTR9hhf6W2SIptMdHA478vo8mNRgEyuAYttQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365996; c=relaxed/simple;
	bh=8jF9whR5OFSAmDFIy8w3nAh/zmT1K2z5jPukEi3msjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGcQeZdNZHok3eodEDHDyaHN2fMVvXHy8yBqPoJgvGKL1P3fQW1wDGdpBzXkNVEFchHHJjDN7B8ZGhALZ01LDydG+vYRm2de758VpIbPHrdb8DVI2367orcGhDVrt+TFBxAW2Vf08mXlcDd6eYUft8DKvR8GxgiiDDpdEjDsWyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L8o1ktEi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cQJw28IE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L8o1ktEi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cQJw28IE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L8o1ktEi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cQJw28IE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L8o1ktEi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cQJw28IE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 442CD4D201;
	Tue, 24 Mar 2026 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774365993;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gy6EAi9ScIFfXy7AMj8MBfW6do9j71H3ABECesSv97A=;
	b=L8o1ktEiaxQkwTwf7HGUadr2DX+z/A5YzU4A8x3AqL/aLZdtjNSYJtRU0ZCbeoD/l6kr4b
	vaqfxRsqzHQGWVNi9laFO01+rxM2GCNBAa1WKL0L19Qx6QRsNh6o5DQ9vG7MM0JUZgKgpo
	lm3zaVHxOWcdVORgbHMuOK5RtHYwLI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774365993;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gy6EAi9ScIFfXy7AMj8MBfW6do9j71H3ABECesSv97A=;
	b=cQJw28IEGuu2S4ffBnF1b7eTxVZMlaGXtxgtlgsoy6WxMHleCjA91PsTTPg8S0xHd9DP/K
	3pxeD7y50Py3hrCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774365993;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gy6EAi9ScIFfXy7AMj8MBfW6do9j71H3ABECesSv97A=;
	b=L8o1ktEiaxQkwTwf7HGUadr2DX+z/A5YzU4A8x3AqL/aLZdtjNSYJtRU0ZCbeoD/l6kr4b
	vaqfxRsqzHQGWVNi9laFO01+rxM2GCNBAa1WKL0L19Qx6QRsNh6o5DQ9vG7MM0JUZgKgpo
	lm3zaVHxOWcdVORgbHMuOK5RtHYwLI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774365993;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gy6EAi9ScIFfXy7AMj8MBfW6do9j71H3ABECesSv97A=;
	b=cQJw28IEGuu2S4ffBnF1b7eTxVZMlaGXtxgtlgsoy6WxMHleCjA91PsTTPg8S0xHd9DP/K
	3pxeD7y50Py3hrCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 292D843EE3;
	Tue, 24 Mar 2026 15:26:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id McXbCSmtwmnaJAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 24 Mar 2026 15:26:33 +0000
Date: Tue, 24 Mar 2026 16:26:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Dave Chen <davechen@synology.com>
Cc: dsterba@suse.cz, cccheng@synology.com, dsterba@suse.com,
	linux-btrfs@vger.kernel.org, robbieko@synology.com
Subject: Re: [PATCH] btrfs: fix unnecessary flush on close when truncating
 zero-sized files
Message-ID: <20260324152627.GV5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260323140748.GK5735@twin.jikos.cz>
 <20260324054039.887316-1-davechen@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324054039.887316-1-davechen@synology.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Tue, Mar 24, 2026 at 01:40:39PM +0800, Dave Chen wrote:
> On Mon, Mar 23, 2026 at 03:07:48PM +0100, David Sterba wrote:
> > Does this have a measurable impact? Truncating 0 -> 0 without any
> > intermediate writes could happen but I kind of doubt it's worth
> > optimizing. I'm not against adding the patch but would like to know if
> > it's fixing some problem for you. Thanks.
> 
> Yes, this comes from a real workload. We have a backup service that
> creates temporary files via mkstemp(), closes them, and later reopens
> them with O_TRUNC for writing. The O_TRUNC is defensive -- the file is
> always empty at that point, but the temp file creation and usage are in
> separate components, so removing it from userspace isn't straightforward.
> 
> This pattern repeats for a large number of files per backup job, and
> each close() triggers an unnecessary filemap_flush().
> 
> When oldsize is already 0, the flag provides no protection -- there is
> no data being truncated away, so the filemap_flush() on close serves
> no purpose. The fix simply makes the condition match what the comment
> already describes.

Thanks, I'll add the workload description to changelog.
