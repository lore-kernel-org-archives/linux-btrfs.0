Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5E63B28D
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 16:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764343; cv=none; b=rDavUS4oJ6PP1VB76ZoR3nJ4kn2iFNZ9sMPNWCwMEW7JOzrozcGMIAwhQy9VNlPBCTDeYgpTKZ9aWrLYG1qT2hcMKp2BvJyVkik/3g/As7QNl343y23fApKKXqH8RvHmNTtTfQo9Yx54En3phbNo/QAuoB9gzBTsbjOzB15GM1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764343; c=relaxed/simple;
	bh=iPuLcOthixCqngdl35GeSO2T5C9XTkuVQt4YpJaEACE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loB+P8JuzzgeoU6aofi+4zzGn0YzTF1XfPjW+EtsbPnZ7lV3TKtNgP2PEJTAMOnZoi/2hra4nxJ0I3TiMpZgzAN6cWwYQMl+hWUQQbCzo1DFAkcDasLlMsM4ITf2Oku5NLSnFxeZ/8TIeISgSPcVntoRqEiQxdwEAjYKUmeUbiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k5Rxyc+D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1VHqCCHw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k5Rxyc+D; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1VHqCCHw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k5Rxyc+D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1VHqCCHw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k5Rxyc+D";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1VHqCCHw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 865B64D300;
	Tue, 17 Mar 2026 16:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773764340;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E95rkyVonCX4yHuNP56VuGW9FQyv/T5zaaF+1NIPUBc=;
	b=k5Rxyc+DHRYZi3AcGgbhCuftbIaZU3BLYYksh8djo+/IHnWB2qi6t4+1jU29560cd1BOcu
	EpdqYovVyPxxZMw3+XugMOnwUL8LGAjMDJBqmDbjM7zS0RUG4uCCddNR9Vi6MnMtHky1oR
	smFPEP07K+E2pJcr25SpOFxs6QqWgKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773764340;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E95rkyVonCX4yHuNP56VuGW9FQyv/T5zaaF+1NIPUBc=;
	b=1VHqCCHwhUhpF1Dy3XNIQAws+2cgnnaWXyZmkb6Ba6J3NBhBTLTrZbhKbscCNqo76QM1HE
	bak/B8chQD0dTcBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773764340;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E95rkyVonCX4yHuNP56VuGW9FQyv/T5zaaF+1NIPUBc=;
	b=k5Rxyc+DHRYZi3AcGgbhCuftbIaZU3BLYYksh8djo+/IHnWB2qi6t4+1jU29560cd1BOcu
	EpdqYovVyPxxZMw3+XugMOnwUL8LGAjMDJBqmDbjM7zS0RUG4uCCddNR9Vi6MnMtHky1oR
	smFPEP07K+E2pJcr25SpOFxs6QqWgKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773764340;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E95rkyVonCX4yHuNP56VuGW9FQyv/T5zaaF+1NIPUBc=;
	b=1VHqCCHwhUhpF1Dy3XNIQAws+2cgnnaWXyZmkb6Ba6J3NBhBTLTrZbhKbscCNqo76QM1HE
	bak/B8chQD0dTcBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 705F24273B;
	Tue, 17 Mar 2026 16:19:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ld49G/R+uWkQdQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 17 Mar 2026 16:19:00 +0000
Date: Tue, 17 Mar 2026 17:18:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Illia Bobyr <illia.bobyr@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: balance: usage range filter not working
Message-ID: <20260317161859.GV5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260218073357.3897563-1-illia.bobyr@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218073357.3897563-1-illia.bobyr@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.987];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Tue, Feb 17, 2026 at 11:33:24PM -0800, Illia Bobyr wrote:
> When range support was added to the usage filter, a bug was
> introduced, as `BTRFS_BALANCE_ARGS_USAGE` is set unconditionally, even
> when `BTRFS_BALANCE_ARGS_USAGE_RANGE` is also set.
> 
> If `BTRFS_BALANCE_ARGS_USAGE` is set, `BTRFS_BALANCE_ARGS_USAGE_RANGE` is
> ignored, see `fs/btrfs/volumes.c:should_balance_chunk()`.
> 
> Signed-off-by: Illia Bobyr <illia.bobyr@gmail.com>

Added to devel, thanks.
