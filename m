Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F19649505E;
	Mon,  7 Sep 2026 11:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781108; cv=none; b=juf/0PMc4f1lAhYZYnWETIFAKDpiTAGTY2aChA4CvuzMulEKpomz4um8dhGf9Kb99zLo/m80x3m9EPzopBk0c4RlpQhp8zaklnodmlHknEsFlxg6Se7qgzlNAaM5UjkaX8/Ly1qziIGvJ6pv5Ra0srUI8ALwVoICA8u5spx1z9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781108; c=relaxed/simple;
	bh=OC//2e/8LqOiU6Uoe2z3bfkrYOzO7uszIec4ErixjGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SK9FKn3NrD9jnHDMEyP9j0I1SRgS85om0QipmxCu8dx1pY9Boss3aoDBfTCNnAnmFxd31C/pWXUAEsUtujIJafYnjL5bHZXGz8YSs4F9CU30dh3BmBUOrQ2osmD4ML0RzcwDXRg8wdJjElr1ZljZkm2aL4hKUs6ego4CUl70sv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1Z0IbnjS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9jnpIWrX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0u6bNTQR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XsD/Xjl5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1Z0IbnjS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9jnpIWrX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0u6bNTQR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XsD/Xjl5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F3C7721ADB;
	Mon,  7 Sep 2026 11:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788781100;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHIDN0zHBu6BUmrbqddOm8FetZh3Qu7KSFuCF3AO7ac=;
	b=1Z0IbnjSue0BXisGeKRXvBKJMZ2gJoGTfvpqPXAEXyyO1POyKIIMqvPq9iU43cTgV6Xdqi
	Am0pWYSVVCyPWciSrfTC+1VTTAkjbaNruT/fDhRIrwOmxBYOj82H/xoqcj1JgM7ZbgwQip
	L3+UEks1VTI7YQiaETbFS21SNXW0MgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788781100;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHIDN0zHBu6BUmrbqddOm8FetZh3Qu7KSFuCF3AO7ac=;
	b=9jnpIWrXWRvpzId1+3W2edcdRIaMMB/VD1CCrZB/ZrXyQZosCU4obticyRQI4+wFIKSNAe
	4ANaQUDK5vmoLcCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0u6bNTQR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="XsD/Xjl5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788781096;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHIDN0zHBu6BUmrbqddOm8FetZh3Qu7KSFuCF3AO7ac=;
	b=0u6bNTQRV+/bGo1hUwdVzW6v5tV+bGeqn3TJHTo6ujLKGA15vTeBQ94491LRCGZzdaPPqo
	cflm3fchPuTFdHXnDiolbANGj8gSqHrZj2lYAYLjha8+GzLw4kw0DQagC6g2eo8KXTWhBD
	aPhw1HvOO5an0S0qmo0vqzexHEqG2gg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788781096;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHIDN0zHBu6BUmrbqddOm8FetZh3Qu7KSFuCF3AO7ac=;
	b=XsD/Xjl5tDRxWcPbXkSJLGc3W9XmT2xCk2JKCmhBMWhrNLU2qJuMHoEFudNOCZOM54c1RJ
	yNm4kW28Z/1d2yCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE77A13432;
	Mon,  7 Sep 2026 11:38:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GHo6LieinmrsewAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 11:38:15 +0000
Date: Mon, 7 Sep 2026 13:38:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Jeff Layton <jlayton@kernel.org>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 1/6] btrfs: use an on-stack path in
 btrfs_insert_orphan_item()
Message-ID: <20260907113810.GU9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
 <20260811-btrfs-enomem-v3-1-46a993fc3fe5@kernel.org>
 <20260820120428.GA9053@suse.cz>
 <4624cca9-6bca-4358-a29f-63f11224350a@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624cca9-6bca-4358-a29f-63f11224350a@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: F3C7721ADB
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmx.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmx.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[9];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Fri, Aug 21, 2026 at 07:43:53AM +0930, Qu Wenruo wrote:
> I think you're very inconsistent on on-stack memory usage at least.
> 
> You were fine when I was adding 128bytes for several call sites for the 
> support of huge pages, and I'd argue all those call sites have a deeper 
> stack, because it's on the writeback path.

This is a different structure and different use case than the
btrfs_path. I'm not happy to allocate 128 bytes but there's no other
way, because during writeback allocating memory is risky and making
things worse. And I'm especially watching out for the path on-stack
conversions because they're too tempting to do. For other structures
it's case by case.

> Furthermore, that huge page support is not widely used, but everyone 
> will need to pay that on-stack price.

Huge pages are a performance optimization and it's good that they're
built in ready to be used when needed and not optional. One clear
benefit is fewer TLB misses, large data processing applications like
databases like that, and there are certaily others.  That we allow such
feature at a known cost is fine by me.

> On the other hand, you are also very hesitant on my recent patches 
> removing those 128 bytes usages.

That's the 'paddr' patchset? This has been merged, I don't have problem
with that.

> So your behavior doesn't seem to match what you said here.
> 
> 
> Secondly, your deep-in-the-stack argument doesn't sound solid either.
> 
> Every block file system can be built upon layer of storage stacks, not 
> only btrfs, but *every* block fs as long as there is a chance to do IO.
> This means you're just saying, there can be almost-infinite lower layers 
> under us, so we should not use any extra on-stack memory.

I think you've extrapolated too far, I'm not saying anything like that.
We have to use stack, but it's a constrained resource. If system has
terabytes of memory we still have 16K of stack per task. Since ever
we've been avoiding unnecessary use, there's an optional kernel build
tool to check for excessive use per function, but it cannot see runtime
effects.

For that there's CONFIG_DEBUG_STACK_USAGE, I have it enabled on my
testing setups. Some sample numbers below.

> I do not think this is the sane nor really validated.

It is indeed not sane to assume infinite layers in the IO stack. What I
consider sane and realistic was written in my reply to Jeff, NFS, iscsi,
encryption, DM/MD block device grouping and lowest level drivers.
Leaving enough space for these layers is a courtesy of filesystem and we
as filesystem expect the same from other layers.  The effects of stack
savings are cumulative and preventative.

> If you want to argue if the extra 112 bytes is good or not, give me some 
> data about the on-stack memory usage.

From a VM log, doing some dt, fsx tests, no layering:

[    4.625550] mount (62) used greatest stack depth: 12152 bytes left
[    4.754313] mkdir (67) used greatest stack depth: 11736 bytes left
[   13.243415] modprobe (85) used greatest stack depth: 11216 bytes left
[    3.326249] mount (64) used greatest stack depth: 12152 bytes left
[    4.534019] dircolors (91) used greatest stack depth: 11952 bytes left
[   10.640649] tmux (104) used greatest stack depth: 11824 bytes left
[    3.674336] mount (65) used greatest stack depth: 12152 bytes left
[    3.826533] grep (73) used greatest stack depth: 12064 bytes left
[  205.946252] modprobe (151) used greatest stack depth: 11216 bytes left
[  808.970673] dt (187) used greatest stack depth: 10392 bytes left
[  808.971605] dt (184) used greatest stack depth: 9936 bytes left
[ 1006.541586] kworker/u16:12 (201) used greatest stack depth: 8712 bytes left
[    3.736577] mount (64) used greatest stack depth: 12152 bytes left
[    3.877472] grep (73) used greatest stack depth: 11600 bytes left
[    3.751221] mount (62) used greatest stack depth: 12152 bytes left
[    3.683467] mount (62) used greatest stack depth: 12152 bytes left
[    3.735522] mkdir (67) used greatest stack depth: 12064 bytes left
[  393.206022] modprobe (108) used greatest stack depth: 11216 bytes left
[    4.765551] mount (63) used greatest stack depth: 12152 bytes left
[   30.059666] modprobe (109) used greatest stack depth: 11216 bytes left
[    4.445938] mount (62) used greatest stack depth: 12152 bytes left
[   26.977347] modprobe (110) used greatest stack depth: 11216 bytes left
[    7.119540] mount (64) used greatest stack depth: 12152 bytes left
[    7.849920] grep (73) used greatest stack depth: 11496 bytes left
[    3.606916] mount (63) used greatest stack depth: 12152 bytes left
[    4.504006] chmod (76) used greatest stack depth: 12096 bytes left
[   36.783062] modprobe (109) used greatest stack depth: 11512 bytes left
[  425.057076] fsx.real (3720) used greatest stack depth: 10672 bytes left
[ 3019.822458] kworker/u16:5 (3688) used greatest stack depth: 10576 bytes left
[53621.495082] fsx.real (4015) used greatest stack depth: 10464 bytes left

As a base it's 4-6K for filesystem.

> With the proof that with enough stacked dm layer, that extra 112 bytes 
> are going to cause problem.

In the right combination of configuration and system load it can become
a problem.

> Not to mention I believe some dm drivers are queuing the real submission 
> handling into a workqueue, avoiding further increasing the on-stack 
> memory usage.

Yes, for the same reasons to be nice to other layers (eventually for
performance reasons).

While I don't mind rehearsing some basic kernel knowledge it's a bit
amusing that we have to do it namely for stack usage.
