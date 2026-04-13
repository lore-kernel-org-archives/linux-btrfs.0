Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98713326941
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 17:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102561; cv=none; b=hEX+dzPwTIHbrkI6cHu/rfF2JsR86ykiB2HYELneIZlDxgMEOUGldyvno//0uPaN+dy6JspTQ+WrdpQt0quRTJG5hzFPFiOt6Jdu9XIBXreQ3RMr0JrVDe2SgN/aTm67WXyv8XNxB68eFkOXLuk76Lxgv501+FOO8nvxsFD0Eog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102561; c=relaxed/simple;
	bh=5t7xPeUrIdHwizxkEIeEdZmtFPji8uIkVKw0slaZYRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gGpns9KY0xFJlFaUXg2n9P4DVbtHeFADQuFbinKk00Vy6hM8kuIYTNh3Q/dOgLe9IkC3X2HTZoNJ3Yty4bOS0oWEK9tPQMu6za/SDv6dxiiM/ZY1W9O64kI+5BkIkYZExGU/Tk2xDNyIcqVM4beTUDiRWvOHLdkj+No4nRvrfmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AZcMSh8W; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=C6Zk7+q0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AZcMSh8W; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=C6Zk7+q0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AZcMSh8W";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="C6Zk7+q0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AZcMSh8W";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="C6Zk7+q0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CBCAD5BE85;
	Mon, 13 Apr 2026 17:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776102557;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8yTFWRR8mdheQc63cbeX01C8aoO5dF9nsE+bDXNj3i4=;
	b=AZcMSh8WVlCvgrs6Wh3qVpTMv4h9Rl/VJNWV+LRKJoi7/XXOkALPMyF0iONion6O1Sybpc
	1GUQC+6xnBovFzqkXNEEqmhXFXvfnrlLnrzlDtB6zJwin6keMrWy3X3Cj0ElfVM71d3Jlq
	5Wfr9BChBOS/o1bc/Xb/9EkuFa2nNRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776102557;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8yTFWRR8mdheQc63cbeX01C8aoO5dF9nsE+bDXNj3i4=;
	b=C6Zk7+q0uE36z4THhA4U/eziuWbcXFB0zMdbOqcaoN++Ig/LrH/gEsP91fiLl1ISsE35ei
	F3wXydqcPlDMmtDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AZcMSh8W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=C6Zk7+q0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776102557;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8yTFWRR8mdheQc63cbeX01C8aoO5dF9nsE+bDXNj3i4=;
	b=AZcMSh8WVlCvgrs6Wh3qVpTMv4h9Rl/VJNWV+LRKJoi7/XXOkALPMyF0iONion6O1Sybpc
	1GUQC+6xnBovFzqkXNEEqmhXFXvfnrlLnrzlDtB6zJwin6keMrWy3X3Cj0ElfVM71d3Jlq
	5Wfr9BChBOS/o1bc/Xb/9EkuFa2nNRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776102557;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8yTFWRR8mdheQc63cbeX01C8aoO5dF9nsE+bDXNj3i4=;
	b=C6Zk7+q0uE36z4THhA4U/eziuWbcXFB0zMdbOqcaoN++Ig/LrH/gEsP91fiLl1ISsE35ei
	F3wXydqcPlDMmtDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B27854AFEA;
	Mon, 13 Apr 2026 17:49:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EnNlK50s3WmnRQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Apr 2026 17:49:17 +0000
Date: Mon, 13 Apr 2026 19:49:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: remove COW fixup and checked folio flag
Message-ID: <20260413174912.GA12792@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1775621833.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775621833.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: CBCAD5BE85
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Wed, Apr 08, 2026 at 01:55:30PM +0930, Qu Wenruo wrote:
> For experimental builds we're already rejecting dirty folios which
> don't have ordered flags since v6.15.
> 
> Unfortunately we're not yet removing that COW fixup machanism for
> non-experimental builds even at v7.0, as there are still some error
> corner cases that can lead to dirty folios without ordered flags.
> 
> After those years of testing, we're sure we won't need COW fixup for
> regular cases. Although I want to remove the COW fixup mechanism after
> all known reproducible cases are fixed, I run out of ideas.

I don't know if I understand this correctly, are there known bugs that
the fixup can catch, but there are not known fixes/root causes?

> Furthermore for the future of huge folios (order 9, 2M page on 4K page
> size systems), we can not afford the extra bitmap for a huge folio.
> In that case, a huge folio will need 64 bytes per bitmap, which is no
> longer a small amount.
> 
> I believe it's time to remove the COW fixup mechanism even for
> non-experimental builds, along with the checked folio flags.

Yes please, it has served us well and caused some scars but now it's
dead code.
