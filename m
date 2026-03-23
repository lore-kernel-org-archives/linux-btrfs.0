Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE8931F9A8
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 18:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292052; cv=none; b=qBi0BregVgIYhMtcql+glkJl6AYCvREpq5RIS3b1zWGRm9k8nvfSYaMtHWVph6dqcKJ2O5+mwCbhHKfWh2WG/QhEXF3djg6o140CMCWTLfic/1Vkg0CgTR6+vU8N4ZLcL+1BW9koXR+okzyBwSnwo/zUCgNu+xFh5XRD9NB370o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292052; c=relaxed/simple;
	bh=VDv+q/enA+xXRgE6WsOluGaGDn1jr3HwwdN9L6iuJ54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HmHtMDuS7lj9hq0i8B0dj+6RzA4iZLRgMAyes9EEaqrc9iG0BTj6WFBv7IruvShc+pReXc2OBW7F34wnY2tE3ydE6hUc/Idyva5Z+10pIN5GUxGPPY2vHQ627aVnwoaPPh6xnY2p3VmWHwlFmAa0V1nJYN9+7Vyz3jX5Bfzc9gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y9x7LUtb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wCPUPUdT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y9x7LUtb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wCPUPUdT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y9x7LUtb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wCPUPUdT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y9x7LUtb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wCPUPUdT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BAE4A5BD63;
	Mon, 23 Mar 2026 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774292049;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=31hhltaXf/LO2FzPwCMK/yZJoy2bfBw8kjriSVXfPwU=;
	b=Y9x7LUtbiavST7vO6gqJIvGZNu1QavyaBHwegWCEJPBcUHnNlTKj4E/ltvbx1NTViBjK/2
	xygH9qxrx6PL/U4gx0rEQUbEOwnmGV6Tfm0IMeGpxB0m/PhjAPd6n1QD4eoTS9+8EgbAOh
	dDY/hGskLGH7VwQbuPjgetSqbxrArCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774292049;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=31hhltaXf/LO2FzPwCMK/yZJoy2bfBw8kjriSVXfPwU=;
	b=wCPUPUdTAe9e2okZESkU/MwIflcDOoE6RGS2iAFti2DvGsZOHoKXZ1266qXfuvLjYDO7/D
	Ff71s/lLVXxxsuAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774292049;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=31hhltaXf/LO2FzPwCMK/yZJoy2bfBw8kjriSVXfPwU=;
	b=Y9x7LUtbiavST7vO6gqJIvGZNu1QavyaBHwegWCEJPBcUHnNlTKj4E/ltvbx1NTViBjK/2
	xygH9qxrx6PL/U4gx0rEQUbEOwnmGV6Tfm0IMeGpxB0m/PhjAPd6n1QD4eoTS9+8EgbAOh
	dDY/hGskLGH7VwQbuPjgetSqbxrArCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774292049;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=31hhltaXf/LO2FzPwCMK/yZJoy2bfBw8kjriSVXfPwU=;
	b=wCPUPUdTAe9e2okZESkU/MwIflcDOoE6RGS2iAFti2DvGsZOHoKXZ1266qXfuvLjYDO7/D
	Ff71s/lLVXxxsuAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90D4943A12;
	Mon, 23 Mar 2026 18:54:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zo41IlGMwWlLNQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 18:54:09 +0000
Date: Mon, 23 Mar 2026 19:54:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Yochai E <echelonh@gmail.com>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
	Yochai Eisenrich <yochaie@sweet.security>,
	David Sterba <dsterba@suse.com>, security@kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fs: btrfs: fix btrfs_ioctl_space_info() slot_count
 TOCTOU which can lead to info-leak
Message-ID: <20260323185400.GQ5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260322063935.3951728-1-echelonh@gmail.com>
 <20260323142633.GL5735@twin.jikos.cz>
 <CACo1jfiWUVViXh7FTeWyFpubudq-qF4=hJZOFcEF0n0OZLVQtQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACo1jfiWUVViXh7FTeWyFpubudq-qF4=hJZOFcEF0n0OZLVQtQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	URIBL_BLOCKED(0.00)[twin.jikos.cz:mid,sweet.security:email,suse.cz:replyto,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:email,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Mon, Mar 23, 2026 at 05:03:47PM +0200, Yochai E wrote:
> On Mon, Mar 23, 2026 at 4:26 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Sun, Mar 22, 2026 at 08:39:35AM +0200, Yochai Eisenrich wrote:
> > > From: Yochai Eisenrich <yochaie@sweet.security>
> > >
> > > btrfs_ioctl_space_info() has a TOCTOU race between two passes over the
> > > block group RAID type lists. The first pass counts entries to determine
> > > the allocation size, then the second pass fills the buffer. The
> > > groups_sem rwlock is released between passes, allowing concurrent block
> > > group removal to reduce the entry count.
> > >
> > > When the second pass fills fewer entries than the first pass counted,
> > > copy_to_user() copies the full alloc_size bytes including trailing
> > > uninitialized kmalloc bytes to userspace.
> >
> > This sounds correct.
> >
> > > Fix by copying only total_spaces entries (the actually-filled count from
> > > the second pass) instead of alloc_size bytes, and switch to kzalloc so
> > > any future copy size mismatch cannot leak heap data.
> >
> > Trying to hit this race looks very hard though, reducing number of block
> > group types is quite rare.
> 
> I agree that this may not be your btrfs typical behavior, but I wouldn't
> have raised the issue if I wasn't able to prove it. I can send the PoC
> code your way if you're interested - it leaks kernel data. A malicious
> user can utilize a fresh btrfs disk over e.g. zram to trigger the issue.

I believe you, the pattern for leaking data works, I'd apply the fix
even without a PoC. Using zeroing allocations in ioctls should be used
by default, this one was missing it.

For a user to trigger that I don't see how this can be well timed with
just passively check the space info ioctl ("btrfs fi df") when the
administrator runs the rebalance command and the block group number
decreases. Like on an installed system it takes the defaults and stays
like that forever.

Active user would have to be able to mkfs an image (trivial) and have it
mounted (possible), which on itself opens a lot of other options.
FS_USERNS_MOUNT is usually not enabled for that reason.

> > The change to kzalloc looks like best fix, for all ioctls that are
> > exposed to userspace. Copying the exact number makes sense. The other
> > case (copying too much) has been fixed in 51788b1bdd0d68 ("btrfs:
> > prevent heap corruption in btrfs_ioctl_space_info()").
> 
> Just to make sure we're on the same page:
> 1. Following the above, do you approve of the copy_to_user fix I
>     suggested?

Yeah it's ok. For normal case there's no difference, the user side will
read up to args.total_spaces which matches the valid data, and ignore the
empty slot. Attacker will find zeros there.

> 2. I think it makes sense to treat other ioctl kmallocs in a different
>     patch, no?

Yes, one thing per patch. I was mentioning that as further work as it's
good to look for the similar problems in other code.
