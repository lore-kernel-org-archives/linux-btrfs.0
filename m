Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A731370D53
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 19:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776887460; cv=none; b=PnjC9iegTEzARY6URNR55SvATFX2q3NG5HrWN0FXRhTKcvEe7KyUQKu66dJ/xbUMwGB4JxSoc1IKoAKwxK9e9ED38aVCLrDhwzkFY9PBXxbLJ53J/6wt75+rG61KYd01hJ28VaGLPyhvHXLtKvlQBfEkfqq75wGK16eGiYZdnQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776887460; c=relaxed/simple;
	bh=oGwxkStVRnus6ngIbLuCSAQGTvszvgSvRt7m8lcWj3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYVU4vmFPFQaIRYUOs4d42cmyBoLkVVkH+4VR7RA+enm4QXuVlwnXflKMymWdpN8QzDbMPhLOTlCs6H/2V6XwTQiq47SHP607zc6C+ANxVYYUCDs5WnLPHt/CbDfe1rcrKO8Vs+SswGEtNhu4ILXuQD66jCgpxrcmjbvZp9yi2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XC2jUsY1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1PExj0Ac; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rMU0njKd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HQ+fbKDu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XC2jUsY1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1PExj0Ac";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rMU0njKd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HQ+fbKDu"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 985946A82C;
	Wed, 22 Apr 2026 19:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776887457;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vkkFxrZ900Jt6MWOxGvDmJgbAnqq994N4iZig80rN/A=;
	b=XC2jUsY1+xzH5iRpF+f4EsoICQOPHVQuxYqCA7ixrCv819phaVX93QX3Th6g1pXxOCFVvr
	b9VyuLEIbugAhifV4+Jfp6LghBWep1DAVko+Ss7n7g0kDQBcrerjZT9ZF1FSCeKi1hK412
	Zf9gBe/r7fRfNxVh3jWYG8MMCe0gWU4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776887457;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vkkFxrZ900Jt6MWOxGvDmJgbAnqq994N4iZig80rN/A=;
	b=1PExj0Ac7WczV6vQ3UbEXebhu5LaFHTZzLnTtv1Rl1sssIxV+4jvhL9L7Y+9aLHaTa52gd
	xfs0wE37iPMsxmDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776887456;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vkkFxrZ900Jt6MWOxGvDmJgbAnqq994N4iZig80rN/A=;
	b=rMU0njKdpBc69HzfMmfUIgYAj/O2bSjLpeZIyOfP0mzkTH5rTEsi/e43O87siXzp0nuopd
	1SEbjE0XGAwCCM+PRNgnAJQZ4OBOvUOL9NLEZOiFmqkF0ykbfhMQywLVmip1vAk9y1MVNd
	U+wOVKJgXiMQqbgSMZGL9TzMQu6wlRU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776887456;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vkkFxrZ900Jt6MWOxGvDmJgbAnqq994N4iZig80rN/A=;
	b=HQ+fbKDuzcohFBFxYQNaGVDKc3Blm9Jj2wP9GCKhRiHH4NI0W/yXYugNc++fm2CGiXjhHm
	3sW0TI1snVuAU2BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E396593AF;
	Wed, 22 Apr 2026 19:50:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I3XkHaAm6WkBHwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 22 Apr 2026 19:50:56 +0000
Date: Wed, 22 Apr 2026 21:50:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: use QSTR() in __btrfs_ioctl_snap_create
Message-ID: <20260422195051.GH12792@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260422123633.100798-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422123633.100798-4-thorsten.blum@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Wed, Apr 22, 2026 at 02:36:36PM +0200, Thorsten Blum wrote:
> Drop the length argument and use the simpler QSTR().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Added to for-next, thanks.
