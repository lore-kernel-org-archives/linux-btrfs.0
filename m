Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9165233F370
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775584912; cv=none; b=Vb1zsBO1U6YNB/3Ub4w8aDXe8rcWxF0OfSvZP0JF0tT00TwBsm38cN1TrfmeGPyy2uz2YS+7x8ig+NZnwBQQtERYrBmPc4lwuxdo2iBBIvjETVUkNh3UUClTddo/N7sqeIqu8oBJ/Of0DRf8cecU9lOP7x38NA9NSUJ+duf9oM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775584912; c=relaxed/simple;
	bh=VkVXSWOKP1Bf225m0BeoWrq8GZFzihh1phtZKFoR838=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sXXWz50IZ1UVUze0tuqYByurRPcobLwQ6/NkAbm2hAE9+E98eHYJiUscI71KVrmg9kH3WwwijS7QCnflEXLmNczWvGlffZqYzlKTgLALtFt3l52zDx0D1ZmghMLd/rHrqw7+j5pfqUscy5l1vvv+n1Tr7wn0/Xr/mkUmP4/xlCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zoMurT96; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N25YgeJL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zoMurT96; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N25YgeJL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zoMurT96";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N25YgeJL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zoMurT96";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N25YgeJL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CD0BF5BCDF;
	Tue,  7 Apr 2026 18:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775584909;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9VAjVd5UA6pQMnCxHjeYGqQiAqISu5fxV9mD5bJ8bw=;
	b=zoMurT96eT4//ycZjoNUeBi6zPlgv844Lob9I9E3VgHHq1cp7EE9A1Uzi0KkDG8zLvX+c/
	bTpmli9li4BTyy6b4x1nBohXdrB83TzEhQd9Pa3hfB+5vNuiyMLWMGu6iQFxb/NIIJpsZR
	KN4PmcvwWssPqF+KVeyZz07I2Tf8PbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775584909;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9VAjVd5UA6pQMnCxHjeYGqQiAqISu5fxV9mD5bJ8bw=;
	b=N25YgeJLBcrB5pCvX+JYs+Rg7antCCnM+Yc4Pn3X1h6TfQHRqezime+92koxftftx21NmL
	DWrqMZJ56d9XRsBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775584909;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9VAjVd5UA6pQMnCxHjeYGqQiAqISu5fxV9mD5bJ8bw=;
	b=zoMurT96eT4//ycZjoNUeBi6zPlgv844Lob9I9E3VgHHq1cp7EE9A1Uzi0KkDG8zLvX+c/
	bTpmli9li4BTyy6b4x1nBohXdrB83TzEhQd9Pa3hfB+5vNuiyMLWMGu6iQFxb/NIIJpsZR
	KN4PmcvwWssPqF+KVeyZz07I2Tf8PbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775584909;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9VAjVd5UA6pQMnCxHjeYGqQiAqISu5fxV9mD5bJ8bw=;
	b=N25YgeJLBcrB5pCvX+JYs+Rg7antCCnM+Yc4Pn3X1h6TfQHRqezime+92koxftftx21NmL
	DWrqMZJ56d9XRsBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B45FF4A0B0;
	Tue,  7 Apr 2026 18:01:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dxHaK41G1WmrZgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 07 Apr 2026 18:01:49 +0000
Date: Tue, 7 Apr 2026 20:01:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3] btrfs: btrfs_log_dev_io_error() on all bio errors
Message-ID: <20260407180133.GF5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <335133ce1989ac89a6de007d4db05f5f4a6c1be2.1775491985.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <335133ce1989ac89a6de007d4db05f5f4a6c1be2.1775491985.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto]
X-Spam-Flag: NO

On Mon, Apr 06, 2026 at 09:15:15AM -0700, Boris Burkov wrote:
> As far as I can tell, we never intentionally constrained ourselves to
> these status codes, and it is misleading and surprising to lack the
> bdev error logging when we get a different error code from the block
> layer. This can lead to jumping to a wrong conclusion like "this
> system didn't see any bio failures but aborted with EIO".
> 
> For example on nvme devices, I observe many failures coming back as
> BLK_STS_MEDIUM. It is apparent that the nvme driver returns a variety of
> BLK_STS_* status values in nvme_error_status().
> 
> So handle the known expected errors and make some noise on the rest
> which we expect won't really happen.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

I'll add it to for-next so it's in the first 7.1 pull request. Thanks.
