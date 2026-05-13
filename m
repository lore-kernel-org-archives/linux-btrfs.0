Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C74F5477E
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 02:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638417; cv=none; b=NgJIW3MsLT7O+yLumff3kVYjBTHzrOFR7pE/h/G+a8mALUfmrpaGzPBYYwqyC03L7YIfgPow2y8yhFORiVmLdL661PgMcyHrsWZi3ymVOoXC3Y4sCvuAnZMqM8yLvdegn+/N2LZ9k0ON/8MB+NNWhjvKBoKz0jCOPGZbRmMzLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638417; c=relaxed/simple;
	bh=SjndBkjbpL0geMngmeBLBBf7Vu/jLwmws1t+pq/iALo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GE3OPxgV5CW1H2VG46oxrjCykHc4TPtTIC9t4amM9PXytNLStP9VII9V+AyJdAxF9WMrPPBz5p1OZm4ANDeUDUgNwODwe9Tj33yAPGKGjt3VIwyYFuuohifKk+IqFlK/GSIGehPamWMq7P3bnVzUWtfgFy3eXGx/uf1xu47f8fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZDcYbEtm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/JCxKWYZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZDcYbEtm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/JCxKWYZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZDcYbEtm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/JCxKWYZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZDcYbEtm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/JCxKWYZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A7D76B38A;
	Wed, 13 May 2026 02:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778638413;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pelIqflt9v6KFlE3V5KxHgSm7h83b4EvqpMMhsXhr5A=;
	b=ZDcYbEtmozyurc2VPdJx9dE7FT6DOPO9NxB7y+Kpmyt9fNExO64ckzd20Ookv/zqCCcyBT
	6nzm2aOyGiIWiOuzk6ReneCqxJe9H/vio/HrnNh7DSuR4HX5daYsWuDVG9TRPhYE1TXKmb
	i4uW9YshjmZRtTrhyjRHd213m5+iBYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778638413;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pelIqflt9v6KFlE3V5KxHgSm7h83b4EvqpMMhsXhr5A=;
	b=/JCxKWYZ17qkn26mrJgPaVlPosVAavsuJArLHXAKbiAVQlvVHsSE4m+uLKhmJ5I/LAbUPl
	IUVSYMiuPe/AKnDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZDcYbEtm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/JCxKWYZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778638413;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pelIqflt9v6KFlE3V5KxHgSm7h83b4EvqpMMhsXhr5A=;
	b=ZDcYbEtmozyurc2VPdJx9dE7FT6DOPO9NxB7y+Kpmyt9fNExO64ckzd20Ookv/zqCCcyBT
	6nzm2aOyGiIWiOuzk6ReneCqxJe9H/vio/HrnNh7DSuR4HX5daYsWuDVG9TRPhYE1TXKmb
	i4uW9YshjmZRtTrhyjRHd213m5+iBYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778638413;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pelIqflt9v6KFlE3V5KxHgSm7h83b4EvqpMMhsXhr5A=;
	b=/JCxKWYZ17qkn26mrJgPaVlPosVAavsuJArLHXAKbiAVQlvVHsSE4m+uLKhmJ5I/LAbUPl
	IUVSYMiuPe/AKnDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73F02593A9;
	Wed, 13 May 2026 02:13:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XBobHE3eA2rSQQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 13 May 2026 02:13:33 +0000
Date: Wed, 13 May 2026 04:13:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, marc@merlins.org
Subject: Re: [PATCH 0/4] btrfs: squota lifetime fixes
Message-ID: <20260513004543.GM2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1778613519.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1778613519.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 8A7D76B38A
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Tue, May 12, 2026 at 12:34:52PM -0700, Boris Burkov wrote:
> A recent report of read-only filesystems since enabling squotas:
> 
> https://lore.kernel.org/linux-btrfs/adnBhWfJQ1n3hZC8@merlins.org/
> 
> led me to investigate a handful of issues in squotas and find some trivial and
> not so trivial bugs in their lifetime management. The aim of the series is to
> strengthen enforcement of the invariant: "a squota qgroup must outlast extents
> that are accounted to it".
> 
> This series consists of two fixes to squota lifetime bugs and two patches that
> reduce the consequences of errors in lifetime management from full fs goes
> read-only abort to "warning and inaccurate squotas which can be deleted
> eventually"
> 
> Additional improvements to btrfs check and fstests to follow.
> 
> Boris Burkov (4):
>   btrfs: check for subvolume before deleting squota qgroup
>   btrfs: fix squota accounting during enable generation
>   btrfs: clamp to avoid squota underflow
>   btrfs: swallow btrfs_record_squota_delta() enoent

Looks good to me, as much I can understand it. Please add it to
for-next.
