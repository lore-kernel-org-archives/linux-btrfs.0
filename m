Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA563A05CC
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 14:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779545897; cv=none; b=lJzboZvdYIdLy1Ii8CVljvlJJ4WZLYCzpO3Rfy5gj+c2CsboR+hgts8+6y9VsvA72XE0v56Pgw4Uw4dZ3mgXVgq8Hu9XKVIjXLCoZ+jgHZDjS+fQar0oimQryryt8D6EsJcswrqdSgavzkDpdHbmRCLtcLJN/V8B8H0Tkj4/vxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779545897; c=relaxed/simple;
	bh=hd0w6ccUZ3PXgdzwefuqTMnrJlF1MkjfP0CXXjH77ig=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AR4yhMm4Cja5e/O5exVhEdAAODaxTNEudYhZjkhtXXDh47DFgI/jJPTUXoC0iKicW6Da8uGZtFj07qad5d+HXK9Lc4+cU6tbuS2XjYRTbvukVApAGcvoN6A5XrnduBF8mmrfx/2pPLBmtXcyslQIoDKOko5UI/VumFbxXY39sCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3Tzm2icQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JmA70iiV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3Tzm2icQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JmA70iiV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3Tzm2icQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JmA70iiV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3Tzm2icQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JmA70iiV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 299916AB8E;
	Sat, 23 May 2026 14:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779545894;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XJMbiBjDY3Ese3h1GI6+nEWT/DSX4C0eFOFKbSd/S7M=;
	b=3Tzm2icQ6UKQ9r5Z52kln/vPP0+z7qttd8jyOJwyBOZO4YyejzCTvR563v7osZCbnkR3NQ
	oeas1jxbLdu24XkIJsm3oMayT9sxf2OI771U6esg1BtLW9eypvZDEJgtxvWvSaro/J+PlX
	v9BFtalPCVMF5t1A6VLBhyD7BbRo3V0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779545894;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XJMbiBjDY3Ese3h1GI6+nEWT/DSX4C0eFOFKbSd/S7M=;
	b=JmA70iiVSeBf3CkhzbvNU0/5V4RclApyGKkjVOUd7AqHjHGecaixbFcne5eHueOUaU8dq5
	pf0avTaeFlPE8XCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3Tzm2icQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JmA70iiV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779545894;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XJMbiBjDY3Ese3h1GI6+nEWT/DSX4C0eFOFKbSd/S7M=;
	b=3Tzm2icQ6UKQ9r5Z52kln/vPP0+z7qttd8jyOJwyBOZO4YyejzCTvR563v7osZCbnkR3NQ
	oeas1jxbLdu24XkIJsm3oMayT9sxf2OI771U6esg1BtLW9eypvZDEJgtxvWvSaro/J+PlX
	v9BFtalPCVMF5t1A6VLBhyD7BbRo3V0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779545894;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XJMbiBjDY3Ese3h1GI6+nEWT/DSX4C0eFOFKbSd/S7M=;
	b=JmA70iiVSeBf3CkhzbvNU0/5V4RclApyGKkjVOUd7AqHjHGecaixbFcne5eHueOUaU8dq5
	pf0avTaeFlPE8XCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 10435593A8;
	Sat, 23 May 2026 14:18:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u0tMAya3EWqIKAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 23 May 2026 14:18:14 +0000
Date: Sat, 23 May 2026 16:18:08 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 7.0
Message-ID: <20260523141808.GB183694@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260509235151.2070978-1-dsterba@suse.com>
 <20260522232533.GA316642@tik.uni-stuttgart.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522232533.GA316642@tik.uni-stuttgart.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 299916AB8E
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On Sat, May 23, 2026 at 01:25:33AM +0200, Ulli Horlacher wrote:
> On Sun 2026-05-10 (01:51), David Sterba wrote:
> 
> > btrfs-progs version 7.0 have been released.
> 
> Thanks.
> This version correct some bugs in the Ubuntu 24 btrfs package.
> 
> 
> > Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
> > Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
> > Release: https://github.com/kdave/btrfs-progs/releases/tag/v7.0
> 
> To get the newest version of btrfs.box.static I have written this script:
> 
> root@fex:/opt/btrfs-tools# cat btrfs-update
> #!/bin/bash
> 
> bbs=btrfs.box.static
> cd /opt/btrfs-tools/bin || exit 1
> vv -s btrfs
> rm -f $bbs
> curl -sS -D- https://github.com/kdave/btrfs-progs/releases/latest |\
> perl -ne 's/^location: (\S+)/wget -q $1\/'$bbs'/ and s:/tag/:/download/: and print' |sh -x
> if [[ $(file $bbs) =~ executable ]]; then
>   cat $bbs > btrfs
>   del $bbs
> fi
> btrfs --version
> 
> 
> Yes, it works but it is ... ugly :-}
> 
> Is there a more elegant solution?

Maybe it is, right now the place is the release web page (click to
download), or you can use the 'gh' command line tool (gh release
download). Using basic tools like curl, perl is more environment proof
but you'd have to put to a script.
