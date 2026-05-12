Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326253E1727
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 13:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778592493; cv=none; b=dozeFNQTl1TaY0V6lsgPggtipxCAIjVuoE5qQTJxOhN+4aEvNSRnt4TNrrAjKeEg3pDNy4a/sLiy8Gut1EpekIVvmCbFDW+IBdegDKXh8IEf/Hq0SLG4nG+SFBWXYxNqCBzO5CgTWwPRrMytXBom+MtPOTGiHBULkRVXYHLsvSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778592493; c=relaxed/simple;
	bh=c3/EZmzd3qNmL4lGiRHrLuZRO9DrVYRb7D5CcN/MFww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t46rsqiVgHkyYWfLkADnFTCIYE9lHvF6msLq7yBBXzKDKM2K80yKF2Rnf89rSN3wOZitHDzcoshVkwkr1Y8IfUsZWGulbOSvtuyoEeHrDoXd7nERrLPHuRyxTV3uxZ9XbnXAsv8fUlnYUBFD0VjAVC1ZnLKOlrMnSycqo9SC9Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fpy2+wEL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BJoc/dVm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fpy2+wEL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BJoc/dVm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fpy2+wEL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BJoc/dVm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fpy2+wEL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BJoc/dVm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 85CC175F04;
	Tue, 12 May 2026 13:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778592490;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VWdpUKrIbrrBkyJW2Y0fLYzpHCir8hUxm+jVWnS/F44=;
	b=fpy2+wELO9kGLB0XOuuWfUZiU4upBy9+aj7U7hq7TGsW6fZGIPhvdlOX/TWsWR5bgA3UCT
	bwi8bb+TgCwpnJkl97sKZ/XLPuRhwVHPD2na7vzF6AgsE271DFP9ij0Knj+ZIAswUsnSPU
	wzeJGhj89sEUlB7U5lzw6uT/bGFqY50=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778592490;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VWdpUKrIbrrBkyJW2Y0fLYzpHCir8hUxm+jVWnS/F44=;
	b=BJoc/dVmI+VKA2Vm7sfPSaCcPON1Y0jyW7EOkgcNT/H8xfCb+QdDmuzJBvX2WPhEZ8UlUZ
	oDtLTKzO/ZxbNcCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778592490;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VWdpUKrIbrrBkyJW2Y0fLYzpHCir8hUxm+jVWnS/F44=;
	b=fpy2+wELO9kGLB0XOuuWfUZiU4upBy9+aj7U7hq7TGsW6fZGIPhvdlOX/TWsWR5bgA3UCT
	bwi8bb+TgCwpnJkl97sKZ/XLPuRhwVHPD2na7vzF6AgsE271DFP9ij0Knj+ZIAswUsnSPU
	wzeJGhj89sEUlB7U5lzw6uT/bGFqY50=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778592490;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VWdpUKrIbrrBkyJW2Y0fLYzpHCir8hUxm+jVWnS/F44=;
	b=BJoc/dVmI+VKA2Vm7sfPSaCcPON1Y0jyW7EOkgcNT/H8xfCb+QdDmuzJBvX2WPhEZ8UlUZ
	oDtLTKzO/ZxbNcCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63FDA593A9;
	Tue, 12 May 2026 13:28:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6UnZF+oqA2ryVAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 12 May 2026 13:28:10 +0000
Date: Tue, 12 May 2026 15:28:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] btrfs: lock balance status ioctls against shutdown
Message-ID: <20260512132801.GH2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260512065342.537219-1-gality369@gmail.com>
 <78e451d1-cc71-4e30-9ee8-903439f584cd@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78e451d1-cc71-4e30-9ee8-903439f584cd@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmx.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.com];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,suse.com,fb.com,vger.kernel.org];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto]
X-Spam-Level: 

On Tue, May 12, 2026 at 08:10:58PM +0930, Qu Wenruo wrote:
> > do not pin the superblock against shutdown and they do not reject a
> > dying superblock before taking balance_mutex.
> > 
> > During unmount, btrfs_put_super() runs close_ctree(), which pauses
> > balance and tears down filesystem state, and btrfs_kill_super() later
> > frees fs_info. If a balance status/control ioctl races with that
> > teardown, it can enter mutex locking on a stale balance_mutex. The
> > optimistic mutex spin path only tolerates speculative owner reads while
> > the mutex object itself remains valid, so a stale mutex can surface as
> > the observed task_struct UAF in owner_on_cpu().
> > 
> > [FIX]
> > Take s_umount in read mode around BALANCE_CTL and BALANCE_PROGRESS, and
> > bail out once the superblock is already dying. This gives the read-only
> > balance status ioctls a shutdown barrier without changing their
> > semantics to require a writable mount.
> 
> Why not just follow btrfs_ioctl_balance() to take mnt_want_write_file()?
> 
> Balance is always a read-write operation, there is no read-only balance.
> Thus I think it's completely fine to call mnt_want_write_file() even for 
> btrfs_ioctl_balance_progress() and btrfs_ioctl_balance_ctl().
> 
> And this avoids unnecessary low-level access to s_umount.

Not just s_umount, mnt_want_write_file() also handles fs freezing and
other internal VFS things, the S_* state is not enough.
