Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533D22309AA
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781532363; cv=none; b=EX2lVAiDM9WXGbO3L/P511LemyYaMAM0xBmlphMtDl8wRSjnShgGcHIdEJAHBaquFuhgz/xvHNmlHi2CE+DEiW/YNti2r0MA4v+e/9HqGy61du8+hTCnedo/Y+zsLtVZRUYha6d17x4bRlY7wCskQtMfBxH351qSN5696w6rK0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781532363; c=relaxed/simple;
	bh=5BDqmPEOvoG1mtorDGanBspp/emcajFm3Bkp3YA09do=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dN0OGLmHvYzZategh4p6qIglzyssENRRRLoZdQJPTmTgYM5cb+QbLzE/ZylwCvr+lafiSaaHODePOtChXVrGU4+VSui5sG2kM78318H30rlpMKsely4Fr0qRH32HbuNeCrFnp7ysRbjDYMCGVDYAjDFAwp+lWx5vqKbUJjcBTNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=js76ctiM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oiRx/eHa; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tsNaZL/E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hD8Woc+8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="js76ctiM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oiRx/eHa";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tsNaZL/E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hD8Woc+8"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 373D7759C9;
	Mon, 15 Jun 2026 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781532360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rBSdCtv34bn/hplPtiTmEooXDLtqlMvCmtsmMRteMiU=;
	b=js76ctiMDIjNrieVhT1yDD8Ac1yA5KQBves5GjH4QEQLcy0yXBC2gkIaUSYcf51Ta12t8u
	sIFdvuystPxn/xj/l9h+FryNWTRvCVJrujJvB+DWgz6JVkZn/zD3J/S+MNv+SKiWmZDmg4
	a4/Hwiv5NJkfKUxkChYLAjVvNhWED00=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781532360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rBSdCtv34bn/hplPtiTmEooXDLtqlMvCmtsmMRteMiU=;
	b=oiRx/eHajFosbn+DaKRRKfWt4ZnN1BEaAR0Y8ofb5MEy5agUZb+cVPGPnStozi7O4PU1m9
	JIXC4UWAHU5m+JDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="tsNaZL/E";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hD8Woc+8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781532359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rBSdCtv34bn/hplPtiTmEooXDLtqlMvCmtsmMRteMiU=;
	b=tsNaZL/ExPgi1BTD0DHyPbWpbUgKiq2cJ3i5IEsarc5wo1ymHZjN9Bi3Bh+IuNfdVNSUbv
	qL8giPux6feDdPVX1+AgZ+L0GGaRT4X/GEoVOTOQhNvmbX/Y7PkL3wGo0AoDkHIeu4bkU5
	cqHNi9w/xcNW6nLYmvutHNMCHPaq6Ms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781532359;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rBSdCtv34bn/hplPtiTmEooXDLtqlMvCmtsmMRteMiU=;
	b=hD8Woc+8LjyMousKWi0ub2pXBulL/uoI8j5D+U6H90y07ogyr43Rp4YEFElJ5/8U3ddi9e
	h5+j1Pmx26j9cvAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BF41779A7;
	Mon, 15 Jun 2026 14:05:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ItqyCscGMGr3VgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 15 Jun 2026 14:05:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C513DA12D2; Mon, 15 Jun 2026 16:05:54 +0200 (CEST)
Date: Mon, 15 Jun 2026 16:05:54 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 2/6] block: allow making a block device unfreezable
Message-ID: <4fnvv6oi7v7cmykzcy6uyhwlecublc3i4fl2iaufluj64bpntj@khndroceczdx>
References: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
 <20260615-work-super-freeze_deny_upstream-v1-2-a6c72b840e7d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-work-super-freeze_deny_upstream-v1-2-a6c72b840e7d@kernel.org>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 373D7759C9
X-Spam-Score: -4.01

On Mon 15-06-26 15:18:05, Christian Brauner wrote:
> Add bdev_deny_freeze() and bdev_allow_freeze(), modeled on
> deny_write_access()/allow_write_access().  bd_fsfreeze_count becomes a
> signed counter: > 0 counts active freezes, < 0 counts deniers, and the
> two regimes are mutually exclusive.  bdev_freeze() refuses with -EBUSY
> while a deny is held, and bdev_deny_freeze() refuses while the device is
> frozen.
> 
> A filesystem that mutates a device's membership (a btrfs device add,
> remove or replace) denies freezing on the device for the duration, so a
> claim a freeze walk might act on is never added or torn down behind the
> freezer's back.
> 
> The deny/allow helpers are a single atomic on bd_fsfreeze_count and take
> no lock, so they can be called while holding s_umount without inverting
> against bdev_freeze()'s bd_fsfreeze_mutex -> s_umount order.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Just one nit below but regardless feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> +/**
> + * bdev_allow_freeze - allow freezing a block device again
> + * @bdev: block device
> + *
> + * Undo one bdev_deny_freeze().
> + */
> +void bdev_allow_freeze(struct block_device *bdev)
> +{
> +	atomic_inc(&bdev->bd_fsfreeze_count);
> +}
> +EXPORT_SYMBOL_GPL(bdev_allow_freeze);

Perhaps we can add WARN_ON_ONCE(atomic_read(&bdev->bd_fsfreeze_count) >= 0)
to catch unbalanced bdev_allow_freeze()?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
