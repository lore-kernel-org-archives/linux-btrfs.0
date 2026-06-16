Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096F0309DDF
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 20:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781641373; cv=none; b=KMarug/yEaCvXZgW4ctpM76DsypzGXGyEnvIPZVbpcS9Tk8UZyeANKjUV2zOFjQJPSF3SLqsllHwfa3CM/XR0kKsqY5/oqNum8k3Y5f2PR6SmxDTLtF8vw6GMJupDY0furrpWRNIB/2rMDrM2qEb7WsXtf5jQSOevT8ZBgPblZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781641373; c=relaxed/simple;
	bh=VEsk0tRzh4F97ofKAoiC42o/+nFpeWYyOWCuRT5EVe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXfsNu9gLdmsK3u5RnWYTHVuVInLbKkzgC4GkLK25CakJFxvcrCAFIFIldvV+wmnGRLfnSzIV264ywPsdiwgy9zcPKyEivmaTEO8BbpZx3RtLB51tq8s6FzJ5wi+mhk1cWoRQTS1epSM6/Xk4/eAksoRGwa5XsRIDpqT2yMuoKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yOEC2Jrv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OHApq7jm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MXAoFmoX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=84zl9z9c; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yOEC2Jrv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OHApq7jm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MXAoFmoX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="84zl9z9c"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 204DF7624C;
	Tue, 16 Jun 2026 20:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781641370;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Evuujen2g6w0rGWTwfw8OrzlK9X4qxNWR4tGgOBuHb4=;
	b=yOEC2Jrvwtqjki/X86D4IbUb935D4fJWOcNGwEt4SsnH98DNHhm4C1jlpUWrqHa60R4UQ7
	pNIL4hMfTjN9BlEiOLI88zM/wsV5L9AF0ZHy0stI2ImQfrF40lN++l8/ifoaTd0WMbp2S8
	wAqMhAovGrhDBsyckewudN4/K0pIN0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781641370;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Evuujen2g6w0rGWTwfw8OrzlK9X4qxNWR4tGgOBuHb4=;
	b=OHApq7jmG6mnnkPBeZP0D2cCDUs8mo8KaaGNQ4Cyj9YKlzjDdfB48rGTVJ1GVxwaWNZYXY
	jesy3NjWv7aLLVDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781641369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Evuujen2g6w0rGWTwfw8OrzlK9X4qxNWR4tGgOBuHb4=;
	b=MXAoFmoXn55ShGW13mwDXTCUlTfHkm3rRHcruA/9/A1sZyvy/qXPmGPOh8w4gJfzIjel1r
	Sqb8E3zarAW1wtYL3Ks7FEgP2ofHrVqFnopO/3GZotKCcDgnL17x13+OZrufshzaZpLnO7
	s2IwaBTwspujHAxD3TnOlf/ANgL/2mo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781641369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Evuujen2g6w0rGWTwfw8OrzlK9X4qxNWR4tGgOBuHb4=;
	b=84zl9z9c7BUkG1Vuun0ezSr0/MMbklm+BrD/D6rBVe968DZ2uZo/aB2M14hfcAF0/5D0GZ
	cZbuyTjVtFHNqxBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 025DC779A8;
	Tue, 16 Jun 2026 20:22:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xndNO5iwMWqfRgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 16 Jun 2026 20:22:48 +0000
Date: Tue, 16 Jun 2026 22:22:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: lzo: add error message for invalid headers
Message-ID: <20260616202247.GB306614@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <205f9c2da68cc36dbaa604b6bdd462ff871b2b83.1780872810.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <205f9c2da68cc36dbaa604b6bdd462ff871b2b83.1780872810.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Mon, Jun 08, 2026 at 08:23:49AM +0930, Qu Wenruo wrote:
> Inside btrfs we always pair -EUCLEAN error with an error message to
> indicate which data is corrupted.
> 
> However there are 3 cases inside lzo decompression where there is no
> error message for corrupted headers.
> 
> Add those missing error messages to show exactly where the corruption
> is.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/lzo.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index 6e4aa22853ab..488167b32a48 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -552,17 +552,26 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
>  	size_t max_segment_len = workspace_buf_length(fs_info);
>  	int ret;
>  
> -	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2))
> +	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * 2)) {
> +		btrfs_err(fs_info, "invalid header length, has %zu expect (%u, %zu)",
> +			  srclen, LZO_LEN, max_segment_len + LZO_LEN * 2);

Other messages say it's for 'lzo' ("lzo header ..."), otherwise it it's
not clear if the header is not for the tree nodes. It's a minor edit you
can do in for-next.

Reviewed-by: David Sterba <dsterba@suse.com>
