Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AD9443C0F
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 16:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404390; cv=none; b=VY8uaZ/CxxZxrhlF2qMrxCFfpXajzDR41BlENA24Ew9DHYIvcBOuRIC1hDE3A52493D82hScnckRKhziOZbDSuv8vCoHcbKq/NHTwQTGAKjR4J+qidAjVknFaY1bKWVTIAkbueg9LwPkgZEQ3WVcnEYqmMy9/GuHk9kzneb02OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404390; c=relaxed/simple;
	bh=zq2UphsuI++nUi1bmjklUtgXXD5FHtAAcOF8Ndej7ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktz9aFFYgRAiGDpgtt+ftkUSQQuMj3qt1orXcgkLG/DEEAXBp/M97pk6M49MOLZ14ORElrHRhiFIbMkjDnG1xnNx4zWJr46rWiF+pgFDa46IOF8qhYisL46CL+M+miQE+rVt7WM1fogYj/eaiKokId796avBnBeoGdkw+ZnuzN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZOWlZPHl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qk3NhzQS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CvUKAZEE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xtDjI3k7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZOWlZPHl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qk3NhzQS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CvUKAZEE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xtDjI3k7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D85B1F7CC;
	Mon, 14 Sep 2026 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789404383;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Sk3CR2Iljzn0ZAJH+GnoO1UkYLTzGGazbn5l6y2MhM=;
	b=ZOWlZPHlrn2ahf+HfvM1LdBa7pg2zX0HByfe0psI270ik1DoCYZtmKrb7q83zVjELwploX
	0FVOgf7eQKlg5DJOsLOUckbFhzfmmQFQOEiePMn79lc6R/pDKfWsF+4bGU/edIv7wW4r7y
	J1ctzNhYk11hbhD0EAc6RYYWg5NFThw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789404383;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Sk3CR2Iljzn0ZAJH+GnoO1UkYLTzGGazbn5l6y2MhM=;
	b=qk3NhzQS8cK17RgAhM6f9sZZJMdMYmNgq1fLSmgH8jL5emX9/KTjEhaS38iTZNTgqgdnXA
	j4GX3zCsTBpfxzDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CvUKAZEE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xtDjI3k7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789404379;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Sk3CR2Iljzn0ZAJH+GnoO1UkYLTzGGazbn5l6y2MhM=;
	b=CvUKAZEEQFSo+dbXLn28pgsFm6bZTwfUiVKEWOaYmyfwxBgbgf44aGtoefkGOdn7J6XI7t
	Peqt3zd49aFGwSfnWLwgEyM/a7BtdWCOAZvg4Hcgx/3Xp7tn6Z+OSWhEcTMmioVy4MD2cK
	9Mh6d5DoBui1E1rxSQGj41A7lbIrKUs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789404379;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Sk3CR2Iljzn0ZAJH+GnoO1UkYLTzGGazbn5l6y2MhM=;
	b=xtDjI3k7tb3DA7SMRg6WvOzqGcjNyWGH0UuQRe4FmWhTkx5nv50yruhV7MVlcU2Q8Um535
	4WZIb2vKPkP73JAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 199131368C;
	Mon, 14 Sep 2026 16:46:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Dn8IBtskqGpwPgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 16:46:19 +0000
Date: Mon, 14 Sep 2026 18:46:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Suveer Jain <asj@kernel.org>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, dwmw2@infradead.org,
	thiago.macieira@intel.com, dave.hansen@intel.com
Subject: Re: [PATCH] btrfs: derive f_fsid with dev_t only when temp_fsid is
 active
Message-ID: <20260914164617.GN54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org>
 <0691a903-cc82-4ad7-8264-cddbf146d00e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0691a903-cc82-4ad7-8264-cddbf146d00e@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 4D85B1F7CC
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
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Mon, Sep 14, 2026 at 11:42:51AM +0800, Anand Suveer Jain wrote:
> 
> 
> This issue and its current fix (below) have been on my mind, as I wasn't
> fully satisfied with the approach even though it works.
> 
> Now, I think I have a better idea.
> 
> The core issue isn't that the new f_fsid derivation is wrong (recap:
> f_fsid derivation changed from f(UUID) to f(UUID + dev_t)). Rather, the
> problem is that f_fsid changes unexpectedly after an upgrade.
> 
> So we need to address the upgrade behavior, not how f_fsid itself is
> derived.
> 
> My new proposed solution:
> 
>  . Put the new f_fsid derivation behind a compile-time config flag (an
> incompat/opt-in flag).

A compile-time change should be only something really significant for
the whole filesystem. Configs rarely change and except
developers/embedded/custom builds it's hard to change, speaking about
distros.
