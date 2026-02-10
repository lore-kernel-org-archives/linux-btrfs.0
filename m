Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6393F1F03EF
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2026 19:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770750166; cv=none; b=txN3vVQnIdCLYWCCKOpX24wbXC10sOkGMwugjQDnHRX7wksgbEZcEtfTD6LVFlzq3fmCaLT1CljivKf/Se6QS3n/v0GftePSzI1JD1r+89Hhcc/eyQgdUfq36R0C/f5S2MTr+NgwfLBcvj8Fm7W7+FxEx5YdX8rxnJTSjCeJz4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770750166; c=relaxed/simple;
	bh=8qWCxFV1TdSx019FrIYCAexHS5r7Lee0HihwMZRigf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWz4TMzfvP/ta7DyQeiI3P/Y8UEnyrHa6YZLvHsD9Ssvr15m5FCyHsQwuJEmhcpkU8vF0e3OzthXz8vO7h8SOnPcDn2oHhRhr4dgLZCla9X73Bvng49r1bXhkk0ZNksNN3s7i91UuxV698+9jatfr1ARbWeH6jn6H15MIw+u6qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=toDKQsFe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eDC1P7oz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=toDKQsFe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eDC1P7oz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="toDKQsFe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eDC1P7oz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="toDKQsFe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eDC1P7oz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6DF193E71C;
	Tue, 10 Feb 2026 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770750158;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K97PwrY1TTnmOaRjcXIKfYMQQSxATAofaiT+Hcmd4xo=;
	b=toDKQsFevsHuqHugGJuds53mmnG4cdvzyClOgL4E4h9CP3XxSlO/1bmujbIXxcz8I9YqJt
	b7HDut4z+pvRdwzHEVToyD9m1naBmm1VEnvpCJxuNCwAvHtfD06GhWTc9EFU/OXXAJIU45
	cWSVAHzlCvDAn9TNoXYOyz9DG1BV9U4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770750158;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K97PwrY1TTnmOaRjcXIKfYMQQSxATAofaiT+Hcmd4xo=;
	b=eDC1P7ozT05bBj9xonFR5UUfrHA95eh0UHV3nz7Is54b1OvuQevs+jctCQFO3ewB51eucN
	yZCDD+rP2Ab1r4DQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=toDKQsFe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eDC1P7oz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770750158;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K97PwrY1TTnmOaRjcXIKfYMQQSxATAofaiT+Hcmd4xo=;
	b=toDKQsFevsHuqHugGJuds53mmnG4cdvzyClOgL4E4h9CP3XxSlO/1bmujbIXxcz8I9YqJt
	b7HDut4z+pvRdwzHEVToyD9m1naBmm1VEnvpCJxuNCwAvHtfD06GhWTc9EFU/OXXAJIU45
	cWSVAHzlCvDAn9TNoXYOyz9DG1BV9U4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770750158;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K97PwrY1TTnmOaRjcXIKfYMQQSxATAofaiT+Hcmd4xo=;
	b=eDC1P7ozT05bBj9xonFR5UUfrHA95eh0UHV3nz7Is54b1OvuQevs+jctCQFO3ewB51eucN
	yZCDD+rP2Ab1r4DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5640B3EA62;
	Tue, 10 Feb 2026 19:02:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8AvpFM6Ai2kpMgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 10 Feb 2026 19:02:38 +0000
Date: Tue, 10 Feb 2026 20:02:33 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove pointless out label in
 qgroup_account_snapshot()
Message-ID: <20260210190233.GE26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b9fdf03c58efd3a7f53472de443054e6c2d9ba69.1770725404.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9fdf03c58efd3a7f53472de443054e6c2d9ba69.1770725404.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 6DF193E71C
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Tue, Feb 10, 2026 at 12:10:27PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The 'out' label is pointless as there are no cleanups to perform there,
> we can replace every goto with a direct return.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
