Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812904;
	b=QBeifwYiVZa6B7SC5wnUrHUJS+1nXgN3gj3LvIFw8KpxkQt6STvZHUSJnXFjQzXRXUi1
	 fUzdlFfqug2iv3o/q+t2bVctlnP5rYCZN1fSOnV3OZMioWbVd4ckXrOCLTsx8/Evo6f8w
	 fIfQ4jFYELC+RO7+pmgn4IScWCFQx+sKK7n1aBpSELfgikMSODHf1wsGIqxtgbKKpYR/e
	 HinX5m3EpEzNHBfnGp0U4Mw1B7VmSfxI3eYFXjfOsvF6FfU5CaMcb591HqRg0URo0YHkN
	 sVgZIwU6PoeME/4SdDRBPH3NoIu3XxPRqUgVMORfo6OoqZwZOyWq9nhyo8AmSfsmtnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812904;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=98wUAFWsnH7wXRC0JdYUGBPjsM4ozmsKLpTKK79GFcg=;
	b=W9jAeTj7U+UO1n80Rwuy8mi9GLKf2hnydedExLxVe/0N7snW9X9ykNpd2ezL+aUflscG
	 FmT+F5nWKtt/1BRmQfzCnPNPxT8E30mXi75Oq2uaPRAXhchWRTi6UxOqTIKyVYWp1ZWqB
	 dIC/On0COr6spdIclVajzR1jgNRPZoO/swJnAjBwvZfVy75UnW8l/pQDzvzAQDCMGo4w/
	 XzagmwF0DEaeFC49bs0Nv2wJf3YbiSYBA1vUmHwrfwJpGNeE5aap39dCxI8in3RAJ6/2a
	 O1h4retKdQcYiV/aPoyeqjCfpEU4e19PhcotFZJM2Z+HAk8mVw8uUIiddFgR0lIH2FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="s/vCsddx";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="YNkKDQx/";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="s/vCsddx";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="YNkKDQx/";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FA3606A326;
	Wed,  4 Nov 2026 17:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02FA3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=s/vCsddx;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YNkKDQx/;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=s/vCsddx;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YNkKDQx/
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F87A21E37;
	Wed,  4 Nov 2026 17:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793812902;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98wUAFWsnH7wXRC0JdYUGBPjsM4ozmsKLpTKK79GFcg=;
	b=s/vCsddxWHhCWIgwkhD4iCS0kmH+5sxQaiC5PTsyV5CVIatgCEZY1KTzDiO9iO+Vp7E2ea
	qZzbuwRlfO/RAQxotdjJ+hymODWBlaqjmxx6PtEBDdE94CzZo+i8O40enPZ6V+e5b0TuJE
	pL+tnfY0Iu40m0EQrG2HAF4ShpS8iVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793812902;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98wUAFWsnH7wXRC0JdYUGBPjsM4ozmsKLpTKK79GFcg=;
	b=YNkKDQx/7/tVOEE4FRZ2LEdkRrxB0FhfMeslBedN1bJvi1Id3+PlCyMeKZyjSNT+KEzoFX
	AQ429Pp7vjvf5+AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793812902;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98wUAFWsnH7wXRC0JdYUGBPjsM4ozmsKLpTKK79GFcg=;
	b=s/vCsddxWHhCWIgwkhD4iCS0kmH+5sxQaiC5PTsyV5CVIatgCEZY1KTzDiO9iO+Vp7E2ea
	qZzbuwRlfO/RAQxotdjJ+hymODWBlaqjmxx6PtEBDdE94CzZo+i8O40enPZ6V+e5b0TuJE
	pL+tnfY0Iu40m0EQrG2HAF4ShpS8iVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793812902;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98wUAFWsnH7wXRC0JdYUGBPjsM4ozmsKLpTKK79GFcg=;
	b=YNkKDQx/7/tVOEE4FRZ2LEdkRrxB0FhfMeslBedN1bJvi1Id3+PlCyMeKZyjSNT+KEzoFX
	AQ429Pp7vjvf5+AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C968134A5;
	Wed,  4 Nov 2026 17:21:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 45vQM6Vp62rnIwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 04 Nov 2026 17:21:42 +0000
Date: Wed, 4 Nov 2026 18:21:40 +0100
From: David Sterba <dsterba@suse.cz>
To: socketpair@gmail.com
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>, Mark Harmstone <mark@harmstone.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: tag all metadata I/O with REQ_META
Message-ID: <20261104172140.GB4186782@suse.cz>
Reply-To: dsterba@suse.cz
References: <20261104-btrfs-sb-read-req-meta-v1-1-e06b4d059897@gmail.com>
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
In-Reply-To: <20261104-btrfs-sb-read-req-meta-v1-1-e06b4d059897@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-13.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto]
X-Spam-Score: -13.00
X-Spam-Level: 
X-Spam-Flag: NO

On Wed, Nov 04, 2026 at 03:38:13PM +0500, Mark Korenberg via B4 Relay wrote:
> Not tested: the remap relocation part, btrfs-progs 7.1 here cannot
> create a remap-tree filesystem.  Mark, could you give it a look?

Remap tree is experimental feature in btrfs-progs, so you'd have to do
custom build with './configure --enable-experimental', then
'mkfs.btrfs -O list-all' will contain 'remapt-ree'.
