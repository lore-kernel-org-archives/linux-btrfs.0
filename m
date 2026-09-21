Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9784C42F709;
	Mon, 21 Sep 2026 12:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993949; cv=none; b=jomvPtbkdU/OvvvtTpDW2WnRGvRprWokIYK4g+7Mc9ig/u1sYlikPkdvB1jTp7LqV/FQaUWuXnFJt+Xc9JgWp7SRRmwL20XaUrC+F+f/ptsbgjjEglooL0xlq3tmxTg8x9HTq2vZ8iiwRE8KmfvcAE3kdCIxTvQ1Tdzbyz3W3JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993949; c=relaxed/simple;
	bh=l+H3QJdJdfvHQJ/ks7uhfidYOkzNs3zmM8oqQLL8qdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPp4FejAKC8l4D4iiXXmPAMVwlwCdPIkdmWs96Axjjo8CamLoDz2CPtNLvuTZRF8VYO2QXc0VeEi+Rc72KqxOS3FS4l71iSyE50xPSPKx60PeesjaSCfquqxxXD+k2UIixsI9Pjvox+VCQwa/H3IaEMpvb0s43Xflh8NvHB0868=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=trt8T8s2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZCVbbH9I; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TgScos2X; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fu8GhJvw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="trt8T8s2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZCVbbH9I";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TgScos2X";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fu8GhJvw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6700E1F7C8;
	Mon, 21 Sep 2026 12:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789993942;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lymV5lZu31oRkntNKb+RbfpUYP+Rlqpqs2tg1VXQIkM=;
	b=trt8T8s2f77xVWd4+/APDjxjnMqSWYBgbGYK9pwNLAPTV9esvaDEZnVNim8A/Bazo7xJUt
	3ruz5ChJSES1a0G+r8LziBmBcBGyAk/+akKMih5pgTtEgWAlfW4pC63x2xOtsSspstE7X5
	5EAaWLqQ59ssUxLEHmqr1EEnKdsVSj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789993942;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lymV5lZu31oRkntNKb+RbfpUYP+Rlqpqs2tg1VXQIkM=;
	b=ZCVbbH9IFn3RmSAP0QHypt0NRiOCWyqrvDQFazANO6MhzUc5RhP0BdfJeshFxoe0rvXZUI
	6lH52K7NxAb9raAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TgScos2X;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fu8GhJvw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789993938;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lymV5lZu31oRkntNKb+RbfpUYP+Rlqpqs2tg1VXQIkM=;
	b=TgScos2XpSlP/SR7irKSGeeKd6T7aB4vVNFZDCMOVJTzHI+eKniHWyT8Za182rbsPyv9/R
	5zg8gFMV6+1CvKU1339OQii3a0R2oF+THWkGD4SAzI4eCT746nkETE+k79Vii+oxRDxTJV
	0N7tk+0jO6c3x6wckITC6+2OFFrpsZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789993938;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lymV5lZu31oRkntNKb+RbfpUYP+Rlqpqs2tg1VXQIkM=;
	b=Fu8GhJvwwl5lVtYSZONy1rk1LSxAHTjJBg2IPuBsOfXY+LiYH2DLVkut0ksskJL9LHxXqm
	WFyAwivcKBkD/ZCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E78E13793;
	Mon, 21 Sep 2026 12:32:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7FB6A9IjsWrEQwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Sep 2026 12:32:18 +0000
Date: Mon, 21 Sep 2026 14:32:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: clm@fb.com, dsterba@suse.com, josef@toxicpanda.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	naohiro.aota@wdc.com, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix block group reference leak in
 btrfs_repair_one_zone()
Message-ID: <20260921123216.GB54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260916171716.2087024-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916171716.2087024-1-vulab@iscas.ac.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 6700E1F7C8
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,iscas.ac.cn:email,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Wed, Sep 16, 2026 at 05:17:16PM +0000, Wentao Liang wrote:
> btrfs_repair_one_zone() hands the block group reference taken by
> btrfs_lookup_block_group() over to relocating_repair_kthread(), which
> drops it.  However the return value of kthread_run() is not checked,
> so when the kernel thread fails to spawn, nothing executes the put and
> the block group reference is leaked.
> 
> Check kthread_run() and drop the reference if the thread failed to
> start.
> 
> Fixes: f7ef5287a63d ("btrfs: zoned: relocate block group to repair IO failure in zoned filesystems")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Added to for-next, thanks.
