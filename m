Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1F549E133
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 13:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996745; cv=none; b=jxtLaQrNugtcTkuxAbClHgYGVHmK8FAsj4zoZLt1M58MHRCViHoa7Et4K4bb6Fmo1G9khrhhwLi/G+5Tvw6Op+HWn9DhCH562UTRt6mhzfAnQYAKZnqTDwAs7PDQP00L/9NKYT9nv2rY5Gx9dBV+pmT8kPlgdjI0AnNhKelCcU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996745; c=relaxed/simple;
	bh=RjohMGPRSRCT3aJ6fWB5gjEnKUfiWjFM5hck3P7mP4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FIejymM0GA5iR7g21jc5+1d4WqDJ5MA5yGKDjPO0RoEMtI1UXFMYTZ3oSxw/DHF03Cp/XUd+J4TPSwA/Qd8nUKDaEbIdVReGB/oAl65HBt/1UiIaapziZMUKGwOO/pJ/i6s0QurkDjdhz5sk9LPYiwVGzMvtmTfhOGdN4NiyFTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JGOvDyid; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fd3Hn5TK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Soq9Pq73; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ILgSA+Ao; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JGOvDyid";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fd3Hn5TK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Soq9Pq73";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ILgSA+Ao"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 298C121A90;
	Mon, 21 Sep 2026 13:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789996738;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tOF+SfHQW8XgueZxwrIMSagbbIRoO2Agbkx4zu/PFw=;
	b=JGOvDyidTc1hcqVyPeSFOWZsxCYU4PSj/QQRM3LWNBDGsSXSz2VlWSxbcylFuU+KDy4yqO
	m3aysccVMFeLOAUzRcYlbsM8DYi6iJaGZ9Rux+1KCXS+lzyfQtg3snYHN18Yk4gkcqSf8j
	3SAPgK/ydfhQj7UHeB962r8zTfMGMBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789996738;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tOF+SfHQW8XgueZxwrIMSagbbIRoO2Agbkx4zu/PFw=;
	b=Fd3Hn5TKdTT2NtWEWzrPVi10oYxfQzk23HuG4GhM9MND3xg/KeNoqc9U8J39m85KKs3odz
	3f6ILuSdzzeLpZCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789996734;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tOF+SfHQW8XgueZxwrIMSagbbIRoO2Agbkx4zu/PFw=;
	b=Soq9Pq73X8SOwBFnyIT4Wn8GMb2VgYly0syACzg1h+JrtvOqrjo2Pk2oYPiBoGDvB+6wx3
	PF1Gzvd5wr6d/y8eQKcGNoAg1d21Zq8rW9rhkRf4THgFdxva0Vai+Ge5tLripJCigwH17n
	4k4XnP9qDbgqAhR9Ym0uaKbM84/GCRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789996734;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tOF+SfHQW8XgueZxwrIMSagbbIRoO2Agbkx4zu/PFw=;
	b=ILgSA+AoXYpsjqlOHRvo2m7c65rKe2sh52JMcXAuBcpZm5mzPw/KAol1Hz6iKRrkzfvx/L
	bwNKBgnmfWFWn4AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C2D5D1368D;
	Mon, 21 Sep 2026 13:18:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Au1rHb0usWrtdQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 21 Sep 2026 13:18:53 +0000
Date: Mon, 21 Sep 2026 15:18:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] btrfs: make qgroup rescan work to handle fs freezing
Message-ID: <20260921131844.GF54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1789981860.git.wqu@suse.com>
 <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -8.00
X-Spam-Level: 
X-Spamd-Result: default: False [-8.00 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Mon, Sep 21, 2026 at 06:46:45PM +0930, Qu Wenruo wrote:
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -559,7 +559,7 @@ static bool may_wait_transaction(struct btrfs_fs_info *fs_info, int type)
>  	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
>  		return false;
>  
> -	if (type == TRANS_START)
> +	if ((type & TRANS_START) == TRANS_START)

This does not seem right, the type should be a single number, not a
bitmask

>  #define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
> +#define TRANS_TRY_START		(__TRANS_START | __TRANS_FREEZABLE | __TRANS_TRYLOCK)

If you meant to distinguish normal start and 'try' start then it's check
for two values.
