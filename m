Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F19B2EC56E
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 09:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725494; cv=none; b=W0iP9MIqlPYijRBEqvAz8izlhhn9rbN0f2x846bM/XkiFTUy1PMQlDLf6qGTq7yCIIs7CKpbOXeVq2PrWRR6ztlhnf6tpkHF2O3wKJ0FWLR49r4Z5B1SxkzhGZr8FOgsASwUm7BZMwnb572bp9uKdLtRITOtru/YddzrkNTIy1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725494; c=relaxed/simple;
	bh=aSKW/q31CLG7ZxYD1ztFZUs+6ZErQIGFcthneHNfnSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JiWN7q4jZ2vbJEm8MYa4ig2KPFoaonVEifA1eKzyOHnHafjRj5jbi1HBr8Hj/nGTGOSBzwA2OfgkVR1r1qeG7elIPO+3eGxkEduD1zZSAyKh4kum5caLGHVxliPzlo3aaqoOWHWUNSOhBWueEYLsJ7SRUcrLIGHziBHOKfSjgXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=P9NJn70a; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+lf3FR1f; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UCqRZnYR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CrzsclEX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="P9NJn70a";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+lf3FR1f";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UCqRZnYR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CrzsclEX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 03CE721DE5;
	Fri, 18 Sep 2026 09:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789725487;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F7hvC/Iznm5YvBftxeSJSNnTArnyUY3xoNIylpOwb3Q=;
	b=P9NJn70aixO6eVGHfwuKiut+ioEXSIU9asfyRzSq1n2StilOwBnmTLjCKx6aZl+N7PkYQ2
	KNE2hckuX84VaSbqgbmaj/a7jcErQweBPrtJH/1VynbI88+8dnFDXKr9l1oiUBwZnGAfRg
	tC36uMYCzagNE/OfhrUiWoUrkWBHf0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789725487;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F7hvC/Iznm5YvBftxeSJSNnTArnyUY3xoNIylpOwb3Q=;
	b=+lf3FR1fI74Eeafb2YJ0uoqn9yTQpDVntb42bobdBEs9CQRa8VX4THUpjj4qmpX2q5meUu
	mOI3y7DgOZ+HrOAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789725483;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F7hvC/Iznm5YvBftxeSJSNnTArnyUY3xoNIylpOwb3Q=;
	b=UCqRZnYRIeVsBqTt2U215YqvftAkzlqbMptudZqdgmUogI4YfOdIdpYCyhVYkmtxgC9Cj9
	ZMcwFGw8WAboK3kBllo5Y290Cin2xUY7sw+oLZck75AJG+YirJFWPnvqdNKm1eXbdhEakb
	vnIqVVwEjD0CZO9y+0KtWiPUYpFI4wA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789725483;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F7hvC/Iznm5YvBftxeSJSNnTArnyUY3xoNIylpOwb3Q=;
	b=CrzsclEXA5v1vp5zcfnMEk5ndpgTXtEiOq29eZoqyJwQdeA1wp5YruFE7gDgmeeTSzBK+H
	29EAtSPytDDE3OBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF4401348F;
	Fri, 18 Sep 2026 09:58:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JrIWKioLrWplWAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 18 Sep 2026 09:58:02 +0000
Date: Fri, 18 Sep 2026 11:57:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 01/17] btrfs: stop enabling the v1 space cache from
 the on-disk state
Message-ID: <20260918095757.GX54722@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
 <20260916-btrfs-remove-v1-space-cache-v3-1-10ebde03b96f@columbia.edu>
 <20260917041202.74A691F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917041202.74A691F00893@smtp.kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Thu, Sep 17, 2026 at 04:12:02AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] btrfs: FREE_SPACE_TREE option leaks on invalid RO remounts
> --
> 
> commit 6751f883b4d1cad106e74cd1b62922302a1c3544
> Author: Tal Zussman <tz2294@columbia.edu>
> 
> btrfs: stop enabling the v1 space cache from the on-disk state
> 
> This commit prevents the v1 space cache from being automatically enabled
> based on the on-disk state. Remounts of read-only filesystems with an old
> cache no longer start a transaction, and space cache cleanup happens
> unconditionally upon a read-write mount.
> 
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 464129b1b0d4c..77443ded6db39 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> [ ... ]
> > @@ -1535,10 +1529,6 @@ static int btrfs_reconfigure(struct fs_context *fc)
> >  			btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
> >  			btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
> >  		}
> > -		if (btrfs_free_space_cache_v1_active(fs_info)) {
> > -			btrfs_clear_opt(fs_info->mount_opt, FREE_SPACE_TREE);
> > -			btrfs_set_opt(fs_info->mount_opt, SPACE_CACHE);
> > -		}
> >  	}
> >  
> >  	ret = 0;
> 
> [Severity: Medium]
> Does removing the v1 space cache check here allow the FREE_SPACE_TREE option
> to leak on invalid read-only remounts?
> 
> If a user with a filesystem using the v1 space cache attempts a read-only
> remount with "space_cache=v2", the kernel emits a warning that this is only
> supported on a read-write remount and intends to reject it.
> 
> However, because the v1_active check that previously reverted the
> FREE_SPACE_TREE option was removed without an unconditional fallback, the
> option appears to silently leak into fs_info->mount_opt in
> btrfs_reconfigure().
> 
> If the user later performs a standard read-write remount, could the kernel
> see the leaked option and unexpectedly create the v2 free space tree?

This looks valid, though the consequences are not disatrous but still
unexpected to create FST.
