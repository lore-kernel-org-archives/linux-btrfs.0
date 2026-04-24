Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD73A3624CE
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 10:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777026518; cv=none; b=tXge/nxz7f4WroS0ytPZsLTezhA2tq4re4WogFyDP/Gif4wHO64JgC8ainB6H+zP43tXdu7GEJIYOksC2J4ZMk32mM2iZdbRc96eeRoi05PvdZ0Dq8+oF++osDyyxNBsPcqp2YCErR6TGSQ6dwFd+y+L3YRyi7uB9Anr+zSWbzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777026518; c=relaxed/simple;
	bh=bbdpdRBxtj/rxkAZJpTS3PCwDY7j7JSemNElw5j270A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A88hBC/MyhlvEPYAzl62OcjNgyrwoVhF4YAN32Q+5/JFqzmnZ/ZiyLJuJfpzW4p57k8iQG0It6OkdaDGhVtLcxQQu+hAxidmaRfO9UAMtsQbN6/RlNICaMXZ0gHt/COOAYtt7j794uGyM0yV0PpcVg5lW6PwfYzmaPxASgoUJf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J1VaSWx5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=B1vCOTRi; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=W47h/h3M; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ttLYr9QF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J1VaSWx5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="B1vCOTRi";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="W47h/h3M";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ttLYr9QF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F00745BD73;
	Fri, 24 Apr 2026 10:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777026515;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ja3knEFjxmK0E/LpIkHkUVIuKljqJ1TqRZjNq+/6Huo=;
	b=J1VaSWx5WE7IKshNPlUGE81XYQVN1xY103+6fs+0n4/77701bDCguXh3yjGtK00y9uOcFa
	AdS99gkqB4QbQ9stZx9Mf8mnQA1C4qrwp616YhTga0LrwJOh+Z9H1N/qnrR+KJevBzHJVG
	CleewEsaPLbrcINKqX6NPHxWYlxgP5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777026515;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ja3knEFjxmK0E/LpIkHkUVIuKljqJ1TqRZjNq+/6Huo=;
	b=B1vCOTRiX3p/ygQxNViL0VlmV73ASsoq3liKzwfAX3laaJjpcKepzKBa/cfYpufxvaxlKY
	aA+CYGMaRqzg0mDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="W47h/h3M";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ttLYr9QF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777026514;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ja3knEFjxmK0E/LpIkHkUVIuKljqJ1TqRZjNq+/6Huo=;
	b=W47h/h3MDQiOd8sFdTZ7xUoE6if9xqI985sv08nJudkGSD4Uuem0aJeqCPbJ3ea1BxWjOx
	WfsA5+nkj092ma1/7vpU/W8m/EkbFrg482/2LxUWly4bONfbJyuULLMJgG/d+VVF+QnMUM
	Ug7UFaSMNH8rEnTKkPJSZC3FM71Pwj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777026514;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ja3knEFjxmK0E/LpIkHkUVIuKljqJ1TqRZjNq+/6Huo=;
	b=ttLYr9QF+w/xTufAoyQc40jIcK3jMMObePyxhXwHXyAmbs+pgf4IyxwOK30mOxkNFN64Um
	ftLtq+QyWiqoSVAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7C43593A4;
	Fri, 24 Apr 2026 10:28:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +oJxNNJF62lBfgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 24 Apr 2026 10:28:34 +0000
Date: Fri, 24 Apr 2026 12:28:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, josef@toxicpanda.com,
	boris@bur.io
Subject: Re: [PATCH] btrfs: don't force DIO writes to be serialized
Message-ID: <20260424102829.GC3906171@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260422140339.417238-1-mark@harmstone.com>
 <20260422205728.GI12792@twin.jikos.cz>
 <850c7c2d-ed97-424f-8ede-4491bacb02ac@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <850c7c2d-ed97-424f-8ede-4491bacb02ac@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: F00745BD73
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Thu, Apr 23, 2026 at 11:04:37AM +0100, Mark Harmstone wrote:
> On 22/04/2026 9.57 pm, David Sterba wrote:
> > On Wed, Apr 22, 2026 at 03:03:35PM +0100, Mark Harmstone wrote:
> >> Before btrfs switched to the new mount API in 2023, we were setting
> >> SB_NOSEC in btrfs_mount_root(). This flag tells the VFS that the
> >> filesystem may have files which don't have security xattrs, enabling it
> >> to do some optimizations.
> >>
> >> Unfortunately this was missed in the transition, meaning that IS_NOSEC
> >> will always return false for a btrfs inode. This means that
> >> btrfs_direct_write() calls will always get the inode lock exclusively,
> >> meaning that DIO writes to the same file will be serialized.
> >>
> >> On my machine, this one-line change results in a ~59% improvement in DIO
> >> throughput:
> > 
> > That's quite an improvement. What's the actual fio script you've used?
> > Also the DIO depends on the block group profile wrt the buffered
> > fallback so that would be good to know too.
> 
> It is. There's a big dropoff in DIO write performance in 6.8 that we 
> never recovered from. I'm going to look into some sort of automated 
> performance so this kind of thing can't happen casually.

As you've used fio for that, please add the test case to the
fstests/tests/perf. Though the 'pref' tests haven't caught up I'd like
to at least collect them in our btrfs/fstests repository.

> This was on a VM with 8 cores and 8GB of RAM, with a real NVMe exposed 
> through PCI passthrough. The figures for XFS and ext4 in comparison are 
> both about ~3GB/s.
> 
> # cat go
> #!/bin/bash
> mkfs.btrfs -f /dev/nvme0n1
> mount /dev/nvme0n1 /mnt/test
> mkdir /mnt/test/nocow
> chattr +C /mnt/test/nocow
> fio /root/test.fio
> 
> # cat /root/test.fio
> [global]
> rw=randwrite
> ioengine=io_uring
> iodepth=64
> size=1g
> direct=1
> startdelay=20
> force_async=4
> ramp_time=5
> runtime=60
> group_reporting=1
> numjobs=32
> time_based
> disk_util=0
> clat_percentiles=0
> disable_lat=1
> disable_clat=1
> disable_slat=1
> filename=/mnt/test/nocow/fiofile
> [test]
> name=test
> bs=4k
> stonewall

Thanks.
