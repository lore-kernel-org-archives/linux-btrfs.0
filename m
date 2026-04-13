Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F60835B634
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 18:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776105715; cv=none; b=DDIhqmWGkexL+brdaIQ156c4N4nwmxS3Tt0EtR1bsH6t7yMrIM9gUsLHY5e0OR7GvJCiwmVFzj26P+DTAc9X7lwvXDYteuT2Zp3xUDwcTdzM6QV9VZsLpUcYOTUTB0YuVBMWw5FBmchRXcuGnE9J8yTxC6cVYPPUSe6VIkfxdhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776105715; c=relaxed/simple;
	bh=iemjGaY5Iucyg/nB99LCm4ziAWrBTh6wKUTWnvwgIQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l80HXXKAtI7EfdECf6QIfTgXspyZu5jAyzmEnqVJ1CjAaG42NmqtE2m74BzBt8CfhL0HI2Pt+Pw0lKKG4JdlhHoT4dC06bxL8ZxBmweIRRAVTM5wfX/Htaa4kwrI8Y36+e/P7K4fLDfeRe/8YzYiONyltngrtRge3RvG58IYgqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IkjJUsri; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Oo3IgTu4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IkjJUsri; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Oo3IgTu4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IkjJUsri";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Oo3IgTu4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IkjJUsri";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Oo3IgTu4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 926896A8B4;
	Mon, 13 Apr 2026 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776105712;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOIhZtcrobl8KyDgfHtChL6K+Qg88qsB6eVKUMzi6Yg=;
	b=IkjJUsriETPfd1C5o+v1dVp+tdUDmZQrVtyYtsVQ7B1N2OOCgZLKyOmSp4DtCaHetjoMGU
	q+bL64iy3Xvrr9ZP1WY5SQGygsVWFPbDYV74OuA8X5yXY+lSV4w9pX2ud29CtBPrWXRSOL
	t6VcPPwLYAV0ApnLok4S47RDcTB/+1c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776105712;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOIhZtcrobl8KyDgfHtChL6K+Qg88qsB6eVKUMzi6Yg=;
	b=Oo3IgTu4++XCcVVpovyUpKQmaLLejr9oB71ywtuswP8GjZTu+DO1iacl+trMhXzS6qJV8c
	F0DcXTsmIozTM9BQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776105712;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOIhZtcrobl8KyDgfHtChL6K+Qg88qsB6eVKUMzi6Yg=;
	b=IkjJUsriETPfd1C5o+v1dVp+tdUDmZQrVtyYtsVQ7B1N2OOCgZLKyOmSp4DtCaHetjoMGU
	q+bL64iy3Xvrr9ZP1WY5SQGygsVWFPbDYV74OuA8X5yXY+lSV4w9pX2ud29CtBPrWXRSOL
	t6VcPPwLYAV0ApnLok4S47RDcTB/+1c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776105712;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOIhZtcrobl8KyDgfHtChL6K+Qg88qsB6eVKUMzi6Yg=;
	b=Oo3IgTu4++XCcVVpovyUpKQmaLLejr9oB71ywtuswP8GjZTu+DO1iacl+trMhXzS6qJV8c
	F0DcXTsmIozTM9BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71BAB4B01F;
	Mon, 13 Apr 2026 18:41:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KISaG/A43Wn4dgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Apr 2026 18:41:52 +0000
Date: Mon, 13 Apr 2026 20:41:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 0/4] btrfs: improve stalls under sudden writeback
Message-ID: <20260413184143.GD12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1775756789.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775756789.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Thu, Apr 09, 2026 at 10:48:47AM -0700, Boris Burkov wrote:
> If you have a system with very large memory (TiBs) and a normal
> percentage based dirty_ratio/dirty_background_ratio like the defaults of
> 20%/10%, then we can theoretically rack up 100s of GiB of dirty pages
> before doing any writeback. This is further exacerbated if we also see a
> sudden drop in the free memory due to a large allocation. If we
> (relatively likely for a large ram system) also have a large disk, we are
> unlikely to do trigger much preemptive metadata reclaim either.
> 
> Once we do start doing writeback with such a large supply, the results
> are somewhat ugly. The delalloc work generates a huge amount of delayed
> refs without proper reservations which sends the metadata space system
> into a tailspin trying to run yet more delalloc to free space.
> Ultimately, the system stalls waiting for huge amounts of ordered
> extents and delayed refs blocking all users in start_transaction() on
> tickets in reserve_space().
> 
> This patch series aims to address these issues in a relatively targeted
> way by improving our reservations for delalloc delayed refs and by doing
> some very basic smoothing of the work in flush_space(). Further work
> could be done to improve flush_space() heuristics and latency but this
> is already a big help on my observed workloads.
> 
> I was able to reproduce stalls on a more "modest" system with 264GiB of
> ram by using a somewhat silly 80% dirty_ratio.
> 
> I was unfortunately unable to reproduce any stalls on a yet smaller
> system with only 32GiB of ram.
> 
> The first 2 patches do the delayed_ref rsv accounting on btrfs_inode,
> mirroring inode->block_rsv.
> The 3th patch is a cleanup to the types counting max extents
> The 4th patch reduces the size of the unit of work in shrink_delalloc()
> to further reduce stalls.
> ---
> Changelog:
> v4:
> - Treat the extent tree data delayed ref as needing reservation for two cow
>   operations.

As this has been reviewed by Filipe, please add it to for-next.  Thanks.
