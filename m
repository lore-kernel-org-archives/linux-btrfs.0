Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220EB3451B2
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 19:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107351; cv=none; b=OaCKfweKnouUU3iMwiMV/3KctZuUv7YKZFOOzkJZdDKIfdnUYHqxhXepAuDPrqzrmN+RK9IhxiHP2ahInJ5KUvJZwZ5jti6gn2MAA4lfM/CJSOsRZ563gFhh7YL3z4EeZea3NjmIqEpbXBybD+H2nIhFPoIwFY6ieNyDTrkeYOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107351; c=relaxed/simple;
	bh=wOG/AqvPFs0iz0aa8AbPoF6IzkI41g2+jkUwbQoHh88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+Muj8Y3TXT/XmNYaS+KmWFhZRHphrcafBSJK6/HoYnImwOjmeQiHWXcPG+fZxAloQx/LIix+YZgdZ/Havd1obhkfdhRC1Bv26wzhLvlq0LqiYQ3lxQUN/BCbxzwD8h6Cy2dLBgxoRo28Z8iJii4ENoBN4YUGHmk0y/1tU7qrgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vDFpLELa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+BQ3M21L; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vDFpLELa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+BQ3M21L; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vDFpLELa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+BQ3M21L";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vDFpLELa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+BQ3M21L"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C2D75BDB5;
	Mon, 13 Apr 2026 19:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776107348;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e25CTTS+gWZFZCqJDz7/wzend1bd3lim0PZK1E+fQ+Y=;
	b=vDFpLELaUC1Yd7ktXS1yp3Sr9nxFiCNc7ADkL29l90as+J+KFz993R6EOkEjDTnnkeLaWD
	pmwlEFPn3yfZimK0yNs8Q8YezJ3UYOaIAOUalkNwe4E3M998O9U0NQY1ZeQ+59L44rl41j
	7YkAnW1+Rkdvmdr2OLGNKcklRMkl1dk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776107348;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e25CTTS+gWZFZCqJDz7/wzend1bd3lim0PZK1E+fQ+Y=;
	b=+BQ3M21L3aoKHcbr0ldTLd755WUg+Yed90CrD/qvMYycLP1uiBEpojjISL2YhwD8Zw4GpK
	dwiBjl1B7h13V0Dw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vDFpLELa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+BQ3M21L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776107348;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e25CTTS+gWZFZCqJDz7/wzend1bd3lim0PZK1E+fQ+Y=;
	b=vDFpLELaUC1Yd7ktXS1yp3Sr9nxFiCNc7ADkL29l90as+J+KFz993R6EOkEjDTnnkeLaWD
	pmwlEFPn3yfZimK0yNs8Q8YezJ3UYOaIAOUalkNwe4E3M998O9U0NQY1ZeQ+59L44rl41j
	7YkAnW1+Rkdvmdr2OLGNKcklRMkl1dk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776107348;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e25CTTS+gWZFZCqJDz7/wzend1bd3lim0PZK1E+fQ+Y=;
	b=+BQ3M21L3aoKHcbr0ldTLd755WUg+Yed90CrD/qvMYycLP1uiBEpojjISL2YhwD8Zw4GpK
	dwiBjl1B7h13V0Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E1984B03A;
	Mon, 13 Apr 2026 19:09:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TiYzB1Q/3WmKEQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Apr 2026 19:09:08 +0000
Date: Mon, 13 Apr 2026 21:09:02 +0200
From: David Sterba <dsterba@suse.cz>
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] btrfs: fix raid stripe search missing entries at
 leaf boundaries
Message-ID: <20260413190902.GI12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260413065249.2320122-1-robbieko@synology.com>
 <20260413065249.2320122-3-robbieko@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413065249.2320122-3-robbieko@synology.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3C2D75BDB5

On Mon, Apr 13, 2026 at 02:52:33PM +0800, robbieko wrote:
> In btrfs_delete_raid_extent(), the search key uses offset=0. When the
> target stripe entry is the first item on a leaf, btrfs_search_slot()
> may land on the previous leaf and decrementing the slot from nritems
> still points to the wrong entry, causing the stripe extent to be
> silently missed.
> 
> Fix this by searching with offset=(u64)-1 instead. Since no real stripe
> entry has this offset, btrfs_search_slot() always returns 1 with the
> slot pointing past the last matching objectid entry. Then unconditionally
> decrement the slot with a proper slots[0]==0 early-exit check to handle
> the case where no matching entry exists.
> 
> Signed-off-by: robbieko <robbieko@synology.com>
> ---
>  fs/btrfs/raid-stripe-tree.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
> index 5c519e161331..d35efe74aa1b 100644
> --- a/fs/btrfs/raid-stripe-tree.c
> +++ b/fs/btrfs/raid-stripe-tree.c
> @@ -98,14 +98,26 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handle *trans, u64 start, u64 le
>  	while (1) {
>  		key.objectid = start;
>  		key.type = BTRFS_RAID_STRIPE_KEY;
> -		key.offset = 0;
> +		key.offset = (u64)-1;
>  
>  		ret = btrfs_search_slot(trans, stripe_root, &key, path, -1, 1);
>  		if (ret < 0)
>  			break;
>  
> -		if (path->slots[0] == btrfs_header_nritems(path->nodes[0]))
> -			path->slots[0]--;
> +		/*
> +		 * Search with offset=(u64)-1 ensures we land on the correct
> +		 * leaf even when the target entry is the first item on a leaf.
> +		 * Since no real entry has offset=(u64)-1, ret is always 1 and

This would be good to handle, not just assumed. A corruption or fuzzed
image inserting the unexpected key with offset will continue while it
should not. Handled as an EUCLEAN, like it's in many other places after
searching for tree items. I'm not sure if it's 100% covered everywhere
but this case fits the pattern.
