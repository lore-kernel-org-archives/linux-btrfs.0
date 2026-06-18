Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EDA33F5A2
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 18:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781806513; cv=none; b=Ia+DZw4RIwyXRI1dBy63J9c5/eMMkzjwSJrii3KNDFD5DGuYDjdWzB20tbFCCfdUz45342EYCyoJI6n9eviyDBotUG+5AliFDPCcZh72CTBAnEtR1x6PI0NVC6nriR1p4p/Zho3iF/N4MUA80JObBRHQgWJ+FMJ+hz1vyTl2bok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781806513; c=relaxed/simple;
	bh=PgtpC/25LcT/oM0SWlvp6XPqUtgvOqB+VUQxpaKMU9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szT98ymiG7O9OJMTFv4uhWYMtlSIpRi1CNbdpN+KzeBi8SUNRyXdqqeaEMui/zOLXnOpfm5HC4Z99a3sPXXsCmE+bR9ZdSy54tSoUso5Pu+S33z+u9SqL29dDClWqoAqRquQwqeSraTUqxRIvbwWZaQBYm4At+TP0lRQwFM2zdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nEd+FNxa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eoIwIGff; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nEd+FNxa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eoIwIGff; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nEd+FNxa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eoIwIGff";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nEd+FNxa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eoIwIGff"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47DBA75D16;
	Thu, 18 Jun 2026 18:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781806510;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F4R7pK6aMeUkqrSSX1kw3t8bQW037yojMNoA92KecUA=;
	b=nEd+FNxa/MS5ROBRkb/TJwOl1i982+thi5sCNWdYOLjC312FhbvQo+hTYDeNhAGbS3isPZ
	CvoZkMHNlfg6rbQyP+yEaSscecKFo6qfaqDggTdJ5ePQF3RV6iSEk87kMNqBuXszk0406k
	oKqIqST+CgiUM7WdjPBZw25q9vbXODc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781806510;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F4R7pK6aMeUkqrSSX1kw3t8bQW037yojMNoA92KecUA=;
	b=eoIwIGff2pZDYwrH4F0jtNZbjnFckEq3ZRZc8/H6gytBAhytzSNSF9TLkCFgbaU1qL/cMG
	46yz8FSIGW90X/BA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781806510;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F4R7pK6aMeUkqrSSX1kw3t8bQW037yojMNoA92KecUA=;
	b=nEd+FNxa/MS5ROBRkb/TJwOl1i982+thi5sCNWdYOLjC312FhbvQo+hTYDeNhAGbS3isPZ
	CvoZkMHNlfg6rbQyP+yEaSscecKFo6qfaqDggTdJ5ePQF3RV6iSEk87kMNqBuXszk0406k
	oKqIqST+CgiUM7WdjPBZw25q9vbXODc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781806510;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F4R7pK6aMeUkqrSSX1kw3t8bQW037yojMNoA92KecUA=;
	b=eoIwIGff2pZDYwrH4F0jtNZbjnFckEq3ZRZc8/H6gytBAhytzSNSF9TLkCFgbaU1qL/cMG
	46yz8FSIGW90X/BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BF1B779A8;
	Thu, 18 Jun 2026 18:15:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XLJ9Cq41NGrYeAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 18 Jun 2026 18:15:10 +0000
Date: Thu, 18 Jun 2026 20:15:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove redundant inode NULL check in
 is_data_bbio()
Message-ID: <20260618181508.GC1049224@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20251219084316.1164580-1-zhen.ni@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219084316.1164580-1-zhen.ni@easystack.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.978];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,easystack.cn:email,suse.cz:replyto,twin.jikos.cz:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Fri, Dec 19, 2025 at 04:43:16PM +0800, Zhen Ni wrote:
> After commit 81cea6cd7041 ("btrfs: remove btrfs_bio::fs_info by
> extracting it from btrfs_bio::inode"), the btrfs_bio::inode field is
> mandatory for all btrfs_bio allocations. The NULL check is redundant and
> can be removed.
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
>  fs/btrfs/bio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index fa1d321a2fb8..ce649e265b75 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -29,7 +29,7 @@ struct btrfs_failed_bio {
>  /* Is this a data path I/O that needs storage layer checksum and repair? */
>  static inline bool is_data_bbio(const struct btrfs_bio *bbio)
>  {
> -	return bbio->inode && is_data_inode(bbio->inode);
> +	return is_data_inode(bbio->inode);

Removing the 'bbio->inode' check would be good and as Johannes pointed
out then is_data_bbio() can be replaced by is_data_inode().

If you're still interested, please send an updated patch with that
change. Thanks.
