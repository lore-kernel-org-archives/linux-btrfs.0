Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708270;
	b=GhwEEKYVSJPdzoIcfmUoR0OvKIDHl6l4FwyKBRBVmly4R2vky7kBkfqwZdjStrnUiCrI
	 DQgh/G07Rv9Wh/y4g4I6lyMw3qONGYCdftu1aD7CrmOq33cF792RMZtEAwXZ1QHe3c06S
	 eZ5WA9nmpkfDvFTD6zwQgST846QwJOOmUUEGtRcec/MxeiI8E0lBwz68iaj179xMbp9Bf
	 CusIWPtfQjKAZoFlc3WOK7UO2nUg7oK9m2VF53AEHJXM85g5CE11vcNG3MJM2aVCK04u8
	 KSIth6k/FC1hiBWCYdi3kHn8utXX0k518fpbKVOOjTdUmRp+ouQT9Ag9PLb+FWkWPJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708270;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=rcSC6SHOKAMlPC589ecnuSlpZy8XS2mkiX0DtJsa3g0=;
	b=nEJHOEmttVkEEyF8JRA1ATcisxtD/YTix+VnxPbQfVC6xlA212voTi6Q4zGdHNENFw6A
	 sJvKeP7kX8LZe1YtrRdw6tB0hwn5RzKvMMxnpmp9PrLI/+G/bcanBj30Akg/4nJtg47fQ
	 Xfg3VTta6AoSncIcTAc19+igCSP0uN2oXq7GZJjBMRhNDPKZnjhVDB4mIflupJXnDgFTD
	 7jebKFpq5y3NF3kecqVz/4qtLOXftU/h/Wsvcv2sQuB8WrVCIerYTfaTUXXIUOOonJv/w
	 D6wnRR7fLfEM/K9AR3emGeDTsvUnPObDHDet+0Vr6fgb1muhWbktE+I0N9gYt1pSnnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=WbcyH0Lo;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=NaGNoa1N;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FECM2hlO;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=m2f5Yp+w;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C06606A31C;
	Thu, 26 Nov 2026 15:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16C06606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=WbcyH0Lo;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=NaGNoa1N;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FECM2hlO;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=m2f5Yp+w
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EB9E122187;
	Thu, 26 Nov 2026 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795708268;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rcSC6SHOKAMlPC589ecnuSlpZy8XS2mkiX0DtJsa3g0=;
	b=WbcyH0LolptFMA7LbvLMaInSQLgkW6kDCsN9PmkxmCr1m75fQvwVs0JB9yT4VMyEjCEOyL
	emAYj/IC7B3eKame4NT7C3n36dljEHshy32so42RHeFwywIRDNwEshWuOF43gXqarl9xY0
	9C92e3E4xxUxgOKOaRJJ3EMuoKWtIJc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795708268;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rcSC6SHOKAMlPC589ecnuSlpZy8XS2mkiX0DtJsa3g0=;
	b=NaGNoa1N9puo2XVXv/2p7X30VwIBuBVdtBwWQXdRSUTWM4jZfEGfvQ4m12E2qNX+4ykQnS
	GIu0FMz65RpG+cAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FECM2hlO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m2f5Yp+w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795708267;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rcSC6SHOKAMlPC589ecnuSlpZy8XS2mkiX0DtJsa3g0=;
	b=FECM2hlO7t/TYc80JieKRBWJfO7p2AlF4bXKxfoEHrqsDEJYqLo8CUkt6xwiw5H3mYmTBr
	jyyKk3VT+rOMcIuB1GK4uqlU1zDGbkMQPmUCmuSwnDjwkQKEtAtxWwlgm9auwKIYBA7/TK
	nscnM+Fav0lPUg+a/VAt7B0PlJMZKIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795708267;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rcSC6SHOKAMlPC589ecnuSlpZy8XS2mkiX0DtJsa3g0=;
	b=m2f5Yp+wvWSjKhmv9Dzs9KGxZNLCjfeWxIb8uAlJnSjpkn18S/Tvi/Am0Pl/0GYPITgVbA
	jdYtxGTjd8Ua4ACQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BCC8F134C3;
	Thu, 26 Nov 2026 15:51:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MkGAHWtVCGuDegAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 26 Nov 2026 15:51:07 +0000
Date: Thu, 26 Nov 2026 16:51:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] btrfs: add a maintainer entry profile
Message-ID: <20261126155105.GD3245297@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <0037554862c0d9dce3ddafd1238347e4b16a5079.1795581896.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0037554862c0d9dce3ddafd1238347e4b16a5079.1795581896.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Queue-Id: EB9E122187
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.21 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[4]
X-Spam-Score: -13.21

On Wed, Nov 25, 2026 at 03:16:21PM +1030, Qu Wenruo wrote:
> This new file is mostly based on my personal preferences, focusing on
> how to improve the human readability in the LLM era.
> 
> The new file should also act as a guide for humans that want to be a
> long term contributor to btrfs.

I understandthe motivation but I'm not sure this is the right way. I've
avoided adding the maintainer profile and rather created and updated the
pages in the web documentation,
https://btrfs.readthedocs.io/en/latest/dev/Developer-s-FAQ.html . It's
burried so we can make it more visible, but the visibility problem
applies to the maintainer profile too. The ones who know it exists and
where to find it are rare. IME it always ends up replying to mails with
the link.

I'd rather keep full contribution documentation on the RTD site, this is
more flexible to update. As a compromise we can add the maintainer
profile and add link to the page. We can eventually mention some key
differences from other subsystems to the maintainer file too, but as
Leon also noted there's an overlap and lots of General information.
