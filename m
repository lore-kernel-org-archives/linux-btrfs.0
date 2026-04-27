Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3D63C7E0E
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 13:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777296137; cv=none; b=Mg+Xr6Nsu2nnqPgQkXn+nnF7gdTNH/S6woUMJjuf8HeaxKkaaeev5L85vysxGRwWba8giN65uZGRblpLX1E0H+e0qya4AvsGxPe5kxrlAKpHI5TURkAF6gHi8rLNhFJtAUrHGw2DSeEzhKc2j6QNMl4V+xllRMOdiwGMddhilC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777296137; c=relaxed/simple;
	bh=HOxoriyP7eb87H43DSq3w4O+ESdnfppNyhsHzTmTzRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cbvo+CCNzKS5nmMa2uycUvUU6Yth43SOx1w9c+tTC2V5J90iBVO4P6c8taBAojpxZFOKQuMd5Ec6PpIyQLEn9cqBstP5kysGwH1T9eY7TNhgz1ffnatN8Z54hTOh4+7QQBvJDknD4UyKyU39I/ebpi+tgTnzEcyq/Gfqmi4YUeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jZtCCWr/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cf39uczO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jZtCCWr/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cf39uczO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jZtCCWr/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cf39uczO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jZtCCWr/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cf39uczO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4DFC75BCD3;
	Mon, 27 Apr 2026 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777296132;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5IXXoOSsIVGIYIiFhPQNlYUJkiOB4OKTMkHl1Z6HgJ8=;
	b=jZtCCWr/fNMLFXUMRZObf83KjCTKbOlXk+8BaCbK+mvHdPmAZ6z5iEqfcdLEK886kRUcg8
	mA/is7nq+IOzyxJwLwej1wQPl8NV73YV3ZIi5CxsM6vBDyXVvbCzVAe01bLu9xU2YeXwKw
	vcEWXT0/srYSDKpmUtjcxnU3FeU2UEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777296132;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5IXXoOSsIVGIYIiFhPQNlYUJkiOB4OKTMkHl1Z6HgJ8=;
	b=cf39uczOtQk9QsM4hosGNvrtK/tFepef1GTh4N7An/cewAn47EjqVNttkaA8mS61tUTYGs
	0m8I/mj1YDxmpQBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777296132;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5IXXoOSsIVGIYIiFhPQNlYUJkiOB4OKTMkHl1Z6HgJ8=;
	b=jZtCCWr/fNMLFXUMRZObf83KjCTKbOlXk+8BaCbK+mvHdPmAZ6z5iEqfcdLEK886kRUcg8
	mA/is7nq+IOzyxJwLwej1wQPl8NV73YV3ZIi5CxsM6vBDyXVvbCzVAe01bLu9xU2YeXwKw
	vcEWXT0/srYSDKpmUtjcxnU3FeU2UEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777296132;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5IXXoOSsIVGIYIiFhPQNlYUJkiOB4OKTMkHl1Z6HgJ8=;
	b=cf39uczOtQk9QsM4hosGNvrtK/tFepef1GTh4N7An/cewAn47EjqVNttkaA8mS61tUTYGs
	0m8I/mj1YDxmpQBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 372CB593B0;
	Mon, 27 Apr 2026 13:22:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id coZHDQRj72nmUAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 27 Apr 2026 13:22:12 +0000
Date: Mon, 27 Apr 2026 15:21:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: enable cross-folio readahead for bs < ps and
 large folio cases
Message-ID: <20260427132155.GJ12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1777189624.git.wqu@suse.com>
 <4eaa4b5b1839aecd6a2bed8f995e8430fcea8ba0.1777189624.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4eaa4b5b1839aecd6a2bed8f995e8430fcea8ba0.1777189624.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Sun, Apr 26, 2026 at 05:21:03PM +0930, Qu Wenruo wrote:
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -358,10 +358,7 @@ struct compressed_bio *btrfs_alloc_compressed_write(struct btrfs_inode *inode,
>   * Add extra pages in the same compressed file extent so that we don't need to
>   * re-read the same extent again and again.
>   *
> - * NOTE: this won't work well for subpage, as for subpage read, we lock the
> - * full page then submit bio for each compressed/regular extents.
> - *
> - * This means, if we have several sectors in the same page points to the same
> + * If we have several sectors in the same page points to the same

The sentence seems to be missing some words, or I don't understand
what's the meaning here.

>   * on-disk compressed data, we will re-read the same extent many times and
>   * this function can only help for the next page.
>   */
