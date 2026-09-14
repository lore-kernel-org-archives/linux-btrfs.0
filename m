Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BE8352030
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406330; cv=none; b=TVdIrM7g1e8QHZqi4ekj2nqidTrOkgqGEaytQ2vlbA3FsucRQIjDWExigeY1XfRh128Muqzo/qOKaaqwYyBF04ILvynp5ijilucvqnsFeFfToO7Wz0tbl2Sfhx3yfwvmDM1jcdRHV1iAe0HIgj46daCcm1xFCjYx69SEyZmTowU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406330; c=relaxed/simple;
	bh=oBG/4STPLIJe/F50/Im4oQJft9CWfu6LLrKNDoCS8Fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sLlOO2WmA5mjGSMMIaJ6boKuNYSQPwDziAeUKVAbGLrb+Z1WhwdwHEUg0fF81GXaen67rGdCQDphp+otKxf3+MlzqZW+fRhPEzTtoV+pc10KqqNeF2tP1KEzzLRCjBYVxEIBrIBtTvzsaVU938XUTnf9LrkbVODQAZJJUmrHttA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zaE0OiM+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bQNJACse; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PWfjQ7Rb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PhIjTwAG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zaE0OiM+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bQNJACse";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PWfjQ7Rb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PhIjTwAG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 13DA121D64;
	Mon, 14 Sep 2026 17:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789406317;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9LyCldth/IQVBcfQweoZoiJIyWarhhCdI1wPSJHE1Fs=;
	b=zaE0OiM+s5Y0FdPKD5s5gwPIH5usl9EGIJp/mEpMRwsaOtABRZ40dBAn2ugJliadfw2uw3
	fnWBQ6Xm8wmNkzbOmqZMGby8Wqfm+jHO55cQmW4ryvfqKxBJdF1/xr75nK5C/xYaxzpD52
	ySbdY0onqITNGLG9pyRKlCVGWvH/UXY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789406317;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9LyCldth/IQVBcfQweoZoiJIyWarhhCdI1wPSJHE1Fs=;
	b=bQNJACsev7kvXoPf82LuH9dkV84DG/UwgSCgKluJfjpAotwJhSqVdY8RAsshIgyb7/Upka
	eBVjZxw+OloMhXDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789406313;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9LyCldth/IQVBcfQweoZoiJIyWarhhCdI1wPSJHE1Fs=;
	b=PWfjQ7RbFnpdCDmj5TaQs+RSHPn9IBOhGKFxxKBlOf3UeVsyrh8PmGW0P12wIPPotR+9ht
	NHv1/t2XxQRQRrYmoOBCSsDxvg7gtJwRnlkYGNogElYASHV5fp4YXQgi2EDhDNpQzHQcHE
	LkQi7WhFC4f8w+yEh2dCkbxbU39Jy38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789406313;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9LyCldth/IQVBcfQweoZoiJIyWarhhCdI1wPSJHE1Fs=;
	b=PhIjTwAGi/Dah8JEGzi6P0jQtW67UaIcFhnEDPh+QX3GQYpUcPj++7s+Spkb+c8GIBKxtj
	EYRwgqM7VMmqJCBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D2F151368C;
	Mon, 14 Sep 2026 17:18:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bupJM2gsqGr4XwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 14 Sep 2026 17:18:32 +0000
Date: Mon, 14 Sep 2026 19:18:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: docs: discourage root btrfs usage without
 an initramfs
Message-ID: <20260914171831.GP54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <c0fbd931a33a130a51f215fc0712954edb18b654.1789205131.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0fbd931a33a130a51f215fc0712954edb18b654.1789205131.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.com:email,twin.jikos.cz:mid];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Sat, Sep 12, 2026 at 06:55:32PM +0930, Qu Wenruo wrote:
> For multi-device btrfs, device scanning is required before mounting, and
> without an initramfs it's impossible to mount a multi-device btrfs.
> 
> Even if the rootfs is a single-device btrfs, there is nothing preventing
> the end user to add a device to that btrfs, and fail the next boot.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  Documentation/mkfs.btrfs.rst | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/mkfs.btrfs.rst b/Documentation/mkfs.btrfs.rst
> index 0d3d6051b0e7..0bc7b7ac3808 100644
> --- a/Documentation/mkfs.btrfs.rst
> +++ b/Documentation/mkfs.btrfs.rst
> @@ -346,6 +346,10 @@ devices to scan at the time of mount.
>          before all block devices are discovered. The waiting is usually done on the
>          initramfs/initrd systems.
>  
> +        Thus using btrfs as a rootfs without an initramfs is not recommended.
> +        Adding a new device to the rootfs can easily cause the next boot to fail, as
> +        there is no way to register all devices prior to mounting.

That's not a good placement, we should write a full section how to use
btrfs without initrd and what are the caveats. A paragraph burried in
mkfs will probably never got noticed.

> +
>  .. warning::
>          RAID5/6 has known problems and should not be used in production.
>  
> -- 
> 2.55.0
> 
