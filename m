Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C84324B1D
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2026 16:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768926818; cv=none; b=i66zbqcuRO/EkDKzqw+jE467Zs5SNNcasQLt+MBx3xjkJ5hIdGdGaqUsb1eHVuQ30F10yMECrmTZDMWOwy0Rti5i9Q+iL2aBmJXAE9Ac6tgS7lLqlaRNHciKG3iD5NUdO4ToK1txorN74t6X0dErn+2L29FQrAWm4i0nMOiIZNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768926818; c=relaxed/simple;
	bh=k2max9IVJMiLzfuv4zcSDMB4gpsDKVvis6hmqixBKf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jvx9V5ifojwSc3rpHQWD5TApmuYN9PRTv16ZC04sjg/qo7J3MNgW7nFD0lvIp6EgCRU6AjFl4ZHmjOsS8fyx+4OIl5PuPaRMu8B5BSfhSAR9pAD2h4kNdaA19tq7hk2z0Bwe4/1qF3P4O1A7txPmJk6c45d39XKwb6s24UGfScY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v5Jn7Yyl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=S78bJC3T; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v5Jn7Yyl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=S78bJC3T; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v5Jn7Yyl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="S78bJC3T";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v5Jn7Yyl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="S78bJC3T"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 49E7A337CF;
	Tue, 20 Jan 2026 16:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768926814;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xt7L1hTxKkaCSSkHbyb/1C9bQ5MdtiJZyuS5EINXuqc=;
	b=v5Jn7Yyl8ll1AFCwBF2GWsEYYCur6JieoZkck2jvgulBziuLP36zYTdt5699JfJrMFKmG+
	no5Qph0DViDpDYTHVgLbM4yipiGi0PRajQnxJ84FQf1VVNKOBv5XMNhEOqHTXXeSuzTUXI
	ugeOvaPiSsxKzO5bV8B9IkYwVN6duwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768926814;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xt7L1hTxKkaCSSkHbyb/1C9bQ5MdtiJZyuS5EINXuqc=;
	b=S78bJC3T6Oz3sjyQNeuSg4cXv75+/kkdqD2BMNlxyW7SWIkpbQwW+CRPe8rbWgcnMm9Vks
	HRCGjThI2JKi3nCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v5Jn7Yyl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S78bJC3T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768926814;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xt7L1hTxKkaCSSkHbyb/1C9bQ5MdtiJZyuS5EINXuqc=;
	b=v5Jn7Yyl8ll1AFCwBF2GWsEYYCur6JieoZkck2jvgulBziuLP36zYTdt5699JfJrMFKmG+
	no5Qph0DViDpDYTHVgLbM4yipiGi0PRajQnxJ84FQf1VVNKOBv5XMNhEOqHTXXeSuzTUXI
	ugeOvaPiSsxKzO5bV8B9IkYwVN6duwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768926814;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xt7L1hTxKkaCSSkHbyb/1C9bQ5MdtiJZyuS5EINXuqc=;
	b=S78bJC3T6Oz3sjyQNeuSg4cXv75+/kkdqD2BMNlxyW7SWIkpbQwW+CRPe8rbWgcnMm9Vks
	HRCGjThI2JKi3nCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3BE7C3EA63;
	Tue, 20 Jan 2026 16:33:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9+VyDl6ub2liXQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 20 Jan 2026 16:33:34 +0000
Date: Tue, 20 Jan 2026 17:33:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: move BTRFS_FEAT_ATTR_INCOMPAT for remap tree
 behind EXPERIMENTAL
Message-ID: <20260120163333.GF26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260120125020.26633-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120125020.26633-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 49E7A337CF
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Tue, Jan 20, 2026 at 12:50:18PM +0000, Mark Harmstone wrote:
> The patch "btrfs: add definitions and constants for remap-tree" added a
> BTRFS_FEAT_ATTR_INCOMPAT for remap tree, but this should have been
> behind a CONFIG_BTRFS_EXPERIMENTAL #ifdef in order to avoid an unused
> variable warning.
> 
> Signed-off-by: Mark Harmstone <mark@harmstone.com>

Folded to for-next, thanks.
