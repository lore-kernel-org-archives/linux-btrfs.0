Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC93A49BD82
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 13:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997239; cv=none; b=PupmCT9h5vO8uN7VjxBGfSZUV2RbYV2AJiCycWgM6LuxOAKBciujU+7HFknxRDmGgAHL7esd5xArsACEB4oCxvRq4WUq7uesDn1yHgVVQJJ7UyUdaahiwSSJ1IeHCPGXWeTFLPZIVtp1APcmfQOUlV7dSCbIDw9vxn4S36AVP40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997239; c=relaxed/simple;
	bh=I7I3Rd7X9z0A9REmZiH/NCGsmf4ki8aXY64DPF11dYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMQYQimZHQb22baw/1m350vMCA9owvnv3LNQ6ZnNv8tVUgn/QDbEy2/MvqAviVFlAiljCe7u1U0jE/XsNT/ysKPfodXFphzgqHJJjR9iMJt+NfdsDHiQPO0e/JVFtbxKRzOj+UUEU+qtqxM+gvAOM/AR6Zr1d836gDqC2oSKkM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bqgrapCP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e0IDX/hk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Asq/ZmFh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7l3oQ12m; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bqgrapCP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e0IDX/hk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Asq/ZmFh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7l3oQ12m"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD70921A07;
	Mon, 21 Sep 2026 13:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789997231;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lvY+FothvpaooiOGhFhiaFTfjLtuSVQOkC4HywryI0s=;
	b=bqgrapCPn2T3bKD0kaivJ0hHp6HXXFFuuPLMrZWca7KlgOlL3RnSxjo7/F0mrrWN9aIevR
	0l0fTb9zE4q5EEU170ROWME5YgHE3ctZsPI55/oqXYtQC0e0FsLLzyT/KOFCBmarMdlTaM
	3zAAFQQ4Frud7gSrpkjgtDJA8pPqUzI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789997231;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lvY+FothvpaooiOGhFhiaFTfjLtuSVQOkC4HywryI0s=;
	b=e0IDX/hkJGx8jaUE/al0t55BOEe/h1+e9EH7BYhk68ptK9anpYCQWq9o4hAJkpNYBFvO43
	Z7mngiSvmhqpBgAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Asq/ZmFh";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7l3oQ12m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789997227;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lvY+FothvpaooiOGhFhiaFTfjLtuSVQOkC4HywryI0s=;
	b=Asq/ZmFh9BG6hsOLPc2yoKpbNnzhCPf/0lORivabwd+cJmp8/LAduP0c7WTMgM9CZb6urN
	/tWlVt6ylEEOem9NIrDQ5Sl+1Ql/fV3aLgH2MwqhRl4Fa5CsyR49gTD0S/PiFDnSm4ZZok
	fQFuB1HEOF1/4lNv/kaA0EJ3TkHixPY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789997227;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lvY+FothvpaooiOGhFhiaFTfjLtuSVQOkC4HywryI0s=;
	b=7l3oQ12mESCPmLy3E9FYWuPlif6mbN0A5cQ2x9Jo514i7XHZ54fYlT7akvfBPERU2/VE3a
	8oRAaI4PQtIPyjCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95ED81368D;
	Mon, 21 Sep 2026 13:27:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y/AeHKswsWrOfQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Sep 2026 13:27:07 +0000
Date: Mon, 21 Sep 2026 15:27:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org, boris@bur.io
Subject: Re: [PATCH v2] btrfs: qgroup: use specific errors for simple quota
 rescan
Message-ID: <20260921132706.GG54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260919040249.912597-1-zhudongjiang@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919040249.912597-1-zhudongjiang@fygo.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: BD70921A07
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
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
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Sat, Sep 19, 2026 at 12:02:49PM +0800, Dongjiang Zhu wrote:
> With simple quotas enabled, running:
> 
>   btrfs quota rescan /mnt
> 
> fails with:
> 
>   ERROR: quota rescan failed: Invalid argument
> 
> Starting a qgroup rescan is not supported in simple quota mode.
> Return -EOPNOTSUPP for new rescan requests so userspace can report
> "Operation not supported" instead.
> 
> qgroup_rescan_init() is also called during mount to resume a rescan
> recorded in the qgroup status item. A RESCAN flag in simple quota mode
> represents an inconsistent persisted state, so return -EUCLEAN for this
> case and retain the warning for diagnostics.

I'm not sure EUCLEAN is a good choice here. It means the filesystem is
corrupted, which in a sense it is, but it's not from user inputs or
on-disk state. The 'init-flags' is from calls and this matches more the
assertion pattern.
