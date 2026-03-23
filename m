Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC231A680D
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 14:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276002; cv=none; b=fa4bovsW3LfDbCC2CQ3UKWwqNuf9kHSyO2Ife1dxowl4Pox/oPHedpnubF0iZrnGdHGK75IMQKcBjIvayURqGjC9IPRo+AOs/GoVmULIp7ehsqB5A2+zH3Uze3BTtYqWCROvI/LCPYKIlRFVqwmP6dBMR/d+DKRH0mD9/dgFC9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276002; c=relaxed/simple;
	bh=yFuO9l4v59FwE9QqkHGGI1Folh/vvPierNnd2GavNcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PeITu5g+Oed6EVGREKVx1nJcA4lpmaT+qgw1XpQMycVKrtg9NynKlz9GfV04HmpdpfpEboOag+5qLIp39GcQ26pUoWn5Y/AajZvZ4h2TONL/4pPy/8dhBOuCGUeP5k+pe7ZcOdtMrJmVJ4YhU1CaLKobdIKyOm3KLf6Wl+LyGB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YXqjh6IS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LwKMy8ur; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YXqjh6IS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LwKMy8ur; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YXqjh6IS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LwKMy8ur";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YXqjh6IS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LwKMy8ur"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2AB8B4D39D;
	Mon, 23 Mar 2026 14:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774275999;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nFHhJOx3HEjN7c3yNzE3J/yxq0A7ZMMVN0SyYCaaJQ8=;
	b=YXqjh6IS5Ur1r2RfjJaw+NiLyH5BSOjivtZ114Qon/5rwO9wIjnlBWUGuQyZuy+2BAzW4U
	ejl9iUZhPCcJB3y8UVkXpezuWxQD0QZhySWlntU8Jy52LFn4N7Ku7pXAXITwa4O5brbSr1
	vRzkYyfkLgHgSw0X1cVkG2uLptWRKts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774275999;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nFHhJOx3HEjN7c3yNzE3J/yxq0A7ZMMVN0SyYCaaJQ8=;
	b=LwKMy8ur7S9cl6VvdAR6iBcOqV4NKlEEyY4be89pCDD5w2jbx28gRmjSfYfwYG+/085eNF
	uHexSWxSVtq7IFBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YXqjh6IS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LwKMy8ur
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774275999;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nFHhJOx3HEjN7c3yNzE3J/yxq0A7ZMMVN0SyYCaaJQ8=;
	b=YXqjh6IS5Ur1r2RfjJaw+NiLyH5BSOjivtZ114Qon/5rwO9wIjnlBWUGuQyZuy+2BAzW4U
	ejl9iUZhPCcJB3y8UVkXpezuWxQD0QZhySWlntU8Jy52LFn4N7Ku7pXAXITwa4O5brbSr1
	vRzkYyfkLgHgSw0X1cVkG2uLptWRKts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774275999;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nFHhJOx3HEjN7c3yNzE3J/yxq0A7ZMMVN0SyYCaaJQ8=;
	b=LwKMy8ur7S9cl6VvdAR6iBcOqV4NKlEEyY4be89pCDD5w2jbx28gRmjSfYfwYG+/085eNF
	uHexSWxSVtq7IFBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0CAFB43906;
	Mon, 23 Mar 2026 14:26:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UOjiAp9NwWlXHAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 14:26:39 +0000
Date: Mon, 23 Mar 2026 15:26:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Yochai Eisenrich <echelonh@gmail.com>
Cc: Chris Mason <clm@fb.com>, Yochai Eisenrich <yochaie@sweet.security>,
	David Sterba <dsterba@suse.com>, security@kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fs: btrfs: fix btrfs_ioctl_space_info() slot_count
 TOCTOU which can lead to info-leak
Message-ID: <20260323142633.GL5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260322063935.3951728-1-echelonh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322063935.3951728-1-echelonh@gmail.com>
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
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.cz:replyto,sweet.security:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto]
X-Rspamd-Queue-Id: 2AB8B4D39D
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Sun, Mar 22, 2026 at 08:39:35AM +0200, Yochai Eisenrich wrote:
> From: Yochai Eisenrich <yochaie@sweet.security>
> 
> btrfs_ioctl_space_info() has a TOCTOU race between two passes over the
> block group RAID type lists. The first pass counts entries to determine
> the allocation size, then the second pass fills the buffer. The
> groups_sem rwlock is released between passes, allowing concurrent block
> group removal to reduce the entry count.
> 
> When the second pass fills fewer entries than the first pass counted,
> copy_to_user() copies the full alloc_size bytes including trailing
> uninitialized kmalloc bytes to userspace.

This sounds correct.

> Fix by copying only total_spaces entries (the actually-filled count from
> the second pass) instead of alloc_size bytes, and switch to kzalloc so 
> any future copy size mismatch cannot leak heap data.

Trying to hit this race looks very hard though, reducing number of block
group types is quite rare.

The change to kzalloc looks like best fix, for all ioctls that are
exposed to userspace. Copying the exact number makes sense. The other
case (copying too much) has been fixed in 51788b1bdd0d68 ("btrfs:
prevent heap corruption in btrfs_ioctl_space_info()").

> 
> Fixes: 7fde62bffb57 ("Btrfs: buffer results in the space_info ioctl")
> 
> Signed-off-by: Yochai Eisenrich <echelonh@gmail.com>

Added to for-next, thanks.
