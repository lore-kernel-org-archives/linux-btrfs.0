Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3625D3EBF02
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2026 23:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769209371; cv=none; b=VHFzoa2IRv/BhhiFyXGtUXdJ/4Fn0lczzRdjWunGeEPuBkqdbQiXk80mzFNt0aGUbiz/gz5cRVjssMRmISUTaOhqKMOKA0xd44nJMhuinf1Go13q0geQn8C8PoSbCBJo6YhYbC+toCRTTIMzv/14gcAZ0FkpF6CsX/nsgXd/dd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769209371; c=relaxed/simple;
	bh=3IkSEuufDEqdGp9rRIh3OVQPcNJ+Naj6pdLVg4qr56E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fJHHXRMb/jmzluhqOTCPlP8l1gaxgpee8x+hCqG60AEbzPHPmM7yTcbGLIFclPcYGL+4jzbx4xNlsJSTXaAgPR0S4MjjR+Zghm6EzdDklqu1retB25TXNgZ4U78H0Bq3xvacS8RjOe5rlMAb7tKIWRj33N2MR2tNEF7ONVfOuqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rBmfVtxN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q6Pt1MxX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rBmfVtxN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q6Pt1MxX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rBmfVtxN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q6Pt1MxX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rBmfVtxN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q6Pt1MxX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 393BA33694;
	Fri, 23 Jan 2026 23:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769209368;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+hQUs46jeP+0nIFdsrJL8pqyiU9+/9cvg7EvZpyfg9g=;
	b=rBmfVtxNR/WadHbC1+YdH32MMV9k7YjPvOTBgwz8Z7GP378k5LkVImz9b4xWMWTlRa/kbu
	giTZCMbAGiawvAqTQRwQc3bnp3LtDK9g0ZZA5TR7lG3avFeB5BJRZtM5Q6NT7zNbI0BhFM
	NXhfK18D8bSbKlQOXSoRmU71MskKuCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769209368;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+hQUs46jeP+0nIFdsrJL8pqyiU9+/9cvg7EvZpyfg9g=;
	b=Q6Pt1MxXhARVrVhzk5musAbx+fMAYZQAfU3hhRINNc0w/MENE+obQr3BBMKkIqZ0acycyO
	ShCtt+uKuQWjlqAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rBmfVtxN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q6Pt1MxX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769209368;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+hQUs46jeP+0nIFdsrJL8pqyiU9+/9cvg7EvZpyfg9g=;
	b=rBmfVtxNR/WadHbC1+YdH32MMV9k7YjPvOTBgwz8Z7GP378k5LkVImz9b4xWMWTlRa/kbu
	giTZCMbAGiawvAqTQRwQc3bnp3LtDK9g0ZZA5TR7lG3avFeB5BJRZtM5Q6NT7zNbI0BhFM
	NXhfK18D8bSbKlQOXSoRmU71MskKuCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769209368;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+hQUs46jeP+0nIFdsrJL8pqyiU9+/9cvg7EvZpyfg9g=;
	b=Q6Pt1MxXhARVrVhzk5musAbx+fMAYZQAfU3hhRINNc0w/MENE+obQr3BBMKkIqZ0acycyO
	ShCtt+uKuQWjlqAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 153D0136AA;
	Fri, 23 Jan 2026 23:02:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ekX0Axj+c2k+FgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 23 Jan 2026 23:02:48 +0000
Date: Sat, 24 Jan 2026 00:02:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs-progs: mkfs: optimize the discard behavior so
 it won't drive me crazy
Message-ID: <20260123230242.GX26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1767936141.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767936141.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 393BA33694
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Fri, Jan 09, 2026 at 04:01:13PM +1030, Qu Wenruo wrote:
> After commit 4b861c186592 ("btrfs-progs: mkfs: discard free space"),
> mkfs.btrfs inside my VM is much slower.
> 
> Previously it takes only around 0.015s, now it takes over 0.750s, which
> is around 50x regression, and that's already when that virtio-blk device
> is already ignoring discard commands.
> 
> It turns out that the main problem is inside how we submit discard
> requests.
> 
> Currently we submit the discard immediately after finding a free space,
> but for DUP profiles (the default one for metadata/system chunks), we
> send a discard request for each mirror.
> 
> Since it's DUP, the two device extents are on the same device, then the
> for next free space we send two discard requests again, meaning we're
> switching between two different dev extents, making the discard requests
> more like some random writes, greatly reduce the peroformance.
> 
> The root fix is in the second patch, where we record and re-order the
> discard requests for each device, so that the eventual requests are all
> in ascending order and are merged when possible.
> 
> The first patch is just a minor cleanup to reduce the call of
> btrfs_map_blocks() by using WRITE for discard.
> 
> With this series, the runtime of mkfs.btrfs is still increased (by the
> free space discarding), but still fast enough that even I can not sense
> it (0.015s - > 0.017s), finally bring back my inner peace.
> 
> Qu Wenruo (2):
>   btrfs-progs: mkfs: discard the logical range in one search
>   btrfs-progs: mkfs: optimise the block group discarding behavior

Thanks, added to devel. I was looking for some funny quote regaring
impatience and going crazy but nothing came out as adequate. Even if
it's reducing time from 0.75 to 0.17s it's that it might seem tolerable
now but in the long run the small delays and peformance drops accumulate
and it's much harder to identify the cause.
