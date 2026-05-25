Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDEE382F0B
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 13:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779714427; cv=none; b=eq2U14LUV3Fu1sYcb3Ar9a9p6zZnROGLb3o9fBdrQFuWLhSpva4kiaVJ2hqDpVYOfXT8Vy8iae0DtFpnDm5nGbkAGccNpEuF4wpLwUsnwYsWVmRGSk3TfoEUAdIwq97IekfNgj3Q5w2iVRtEWzOstxmW0rmXiHi+10oYggYfFqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779714427; c=relaxed/simple;
	bh=DO+blG4x/Xhr9oBWWRxJjy5O7CN8bCqs5tKWIBGeEYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UnNsE+KudAt/svTKoF79wRxjTUHt4o5c98Q3+16rWAQRoI0cM9TIr/4etYCLLrVrB++vL2ag8FgTwI82yGagP2DB/ab+7UG6Vii9bjoyo2mShd4DWN+H4z07moxbRm6D1sjg+FGTU/NqCJXbuOSy4YvRpmXCV7J1KPPbwROBbFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TqTR+j85; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z/LLtKht; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TqTR+j85; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z/LLtKht; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TqTR+j85";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z/LLtKht";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TqTR+j85";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z/LLtKht"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6791F7582C;
	Mon, 25 May 2026 13:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779714424;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I4SFpGtF/uHxXqn1bVpP8cTj7UeLrPeQFT7flex+f8o=;
	b=TqTR+j85yHe3rxjwvGyPUPAEfOJpHirV4S+I+eFewu68rSWQRCMqEZV9iAZvYya9E8J0aa
	VxijkR0nywndteMK78Sz1X0WcZsYWb7+qwm5G7Sd/MandWwzFjGqxMxFYwdWmGHnLC1Pfh
	0aoIkzyM/yYuKSvY8BRKCFU9/DqKClw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779714424;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I4SFpGtF/uHxXqn1bVpP8cTj7UeLrPeQFT7flex+f8o=;
	b=z/LLtKhtB6KddBjObKQsaQpBYCluwlOJ+2UjiQ0k9dykjPAUyrQsQUCLoF5ZiNQr1QM97n
	NFg7V8JiHh6efPCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TqTR+j85;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="z/LLtKht"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779714424;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I4SFpGtF/uHxXqn1bVpP8cTj7UeLrPeQFT7flex+f8o=;
	b=TqTR+j85yHe3rxjwvGyPUPAEfOJpHirV4S+I+eFewu68rSWQRCMqEZV9iAZvYya9E8J0aa
	VxijkR0nywndteMK78Sz1X0WcZsYWb7+qwm5G7Sd/MandWwzFjGqxMxFYwdWmGHnLC1Pfh
	0aoIkzyM/yYuKSvY8BRKCFU9/DqKClw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779714424;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I4SFpGtF/uHxXqn1bVpP8cTj7UeLrPeQFT7flex+f8o=;
	b=z/LLtKhtB6KddBjObKQsaQpBYCluwlOJ+2UjiQ0k9dykjPAUyrQsQUCLoF5ZiNQr1QM97n
	NFg7V8JiHh6efPCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B2FA59C66;
	Mon, 25 May 2026 13:07:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id raUmEnhJFGo8YAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 13:07:04 +0000
Date: Mon, 25 May 2026 15:06:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: DEV_STATS item related minor fixes
Message-ID: <20260525130658.GC12792@twin.jikos.cz>
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
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 6791F7582C
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO

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
> 
> The 3rd patch is a more generic fix by forcing btrfs to update/create
> DEV_STATS item after a new device is added.
> This means for patched kernels, even there is some old DEV_STATS left,
> the kernel will never re-use them during device add or dev-replace.
> 
> The last one is to reduce unnecessary DEV_STATS updates.
> 
> Qu Wenruo (4):
>   btrfs: remove the dev stats item for replace target device
>   btrfs: remove the dev stats item when removing a device
>   btrfs: always update/create the dev stats item when adding a new
>     device
>   btrfs: avoid unnecessary dev stats updates

Please add the series to for-next, thanks.
