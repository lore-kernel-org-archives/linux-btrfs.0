Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B221FC7
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 20:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776891453; cv=none; b=pmTds//uMZzKob6aglUk8ZE6i2KsQ+UAsy3fCJdCNETKnNlwEaMVJ63VliKHkmZcTEVQewR2KGBQ7xwp9rSJOgiPWlMuXcFPKeG4tulBFfLCERA5Sa627Xt3kt6SUtlN8439DrvQ4hDGX2NWWLBvw/w5mez5u8PcC+QkRRYZQug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776891453; c=relaxed/simple;
	bh=TMAf9Mc3BNwTxQ4msMH8Qgo7tZD4WAUABXbSrgrWqHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pe+BLDDkn35p9Y5F1WZLW3pjNOqRXn1HxfSTbq8QgKQCMLFDiZxEhjIOKwQ80qDkSEIVKfaerDFO1s03BM8P9/B0Q/gy55fZchnqztTiV3rAeryB0E7M8Xqb0VjUf9Bx3JYySOcVIC+SKEd2Ch6gyKNUR1Z1w5Y57kZ9zpQH1+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MNIIEy2J; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O0tqfi8/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MNIIEy2J; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O0tqfi8/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MNIIEy2J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O0tqfi8/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MNIIEy2J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O0tqfi8/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7507A6A82C;
	Wed, 22 Apr 2026 20:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776891449;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dkhi5w1uWzF58dPEHy8QbgUblzVzGMn3fwzI5FmZbSU=;
	b=MNIIEy2JFXNZXO9NK3NMyiUxlxku6ErCWcwensS20/VAbTgSODBWuU2RW8tRq7eGgV0WG9
	vlY0bzDMW5bJ6yNrEjX8FX5O30FQcz56WPtLA07KhU3WkOmuerRzQ2hzFpFpwoUJm0xN45
	zUnth4JSfQQnOiKL0Zj4pktFrrrLTCY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776891449;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dkhi5w1uWzF58dPEHy8QbgUblzVzGMn3fwzI5FmZbSU=;
	b=O0tqfi8/CaI+Y4lHX1s7dsbzVfV4AsNTZNWp6IOfFcwGFdPSwQhMooI0JalGIPnJrnhWHN
	OiHwMakrnlu6nkAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MNIIEy2J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="O0tqfi8/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776891449;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dkhi5w1uWzF58dPEHy8QbgUblzVzGMn3fwzI5FmZbSU=;
	b=MNIIEy2JFXNZXO9NK3NMyiUxlxku6ErCWcwensS20/VAbTgSODBWuU2RW8tRq7eGgV0WG9
	vlY0bzDMW5bJ6yNrEjX8FX5O30FQcz56WPtLA07KhU3WkOmuerRzQ2hzFpFpwoUJm0xN45
	zUnth4JSfQQnOiKL0Zj4pktFrrrLTCY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776891449;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dkhi5w1uWzF58dPEHy8QbgUblzVzGMn3fwzI5FmZbSU=;
	b=O0tqfi8/CaI+Y4lHX1s7dsbzVfV4AsNTZNWp6IOfFcwGFdPSwQhMooI0JalGIPnJrnhWHN
	OiHwMakrnlu6nkAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C2C1593AF;
	Wed, 22 Apr 2026 20:57:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xyhPFjk26WnTXQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 22 Apr 2026 20:57:29 +0000
Date: Wed, 22 Apr 2026 22:57:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, josef@toxicpanda.com, boris@bur.io
Subject: Re: [PATCH] btrfs: don't force DIO writes to be serialized
Message-ID: <20260422205728.GI12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260422140339.417238-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422140339.417238-1-mark@harmstone.com>
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
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 7507A6A82C
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Wed, Apr 22, 2026 at 03:03:35PM +0100, Mark Harmstone wrote:
> Before btrfs switched to the new mount API in 2023, we were setting
> SB_NOSEC in btrfs_mount_root(). This flag tells the VFS that the
> filesystem may have files which don't have security xattrs, enabling it
> to do some optimizations.
> 
> Unfortunately this was missed in the transition, meaning that IS_NOSEC
> will always return false for a btrfs inode. This means that
> btrfs_direct_write() calls will always get the inode lock exclusively,
> meaning that DIO writes to the same file will be serialized.
> 
> On my machine, this one-line change results in a ~59% improvement in DIO
> throughput:

That's quite an improvement. What's the actual fio script you've used?
Also the DIO depends on the block group profile wrt the buffered
fallback so that would be good to know too.
