Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4D235F610
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 03:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776490; cv=none; b=OwNtzcmea9QDYkxs5T3Jh6jMfXdyoKTr+cJp0i7OY2cq8s0eeR8XNMP3TESvvstnp3Mb5lsK+HRrkCG8GS6dzAbFq0SH10uNmuJWCUW1scQm5erbspSdZM9pZZFRXHQogF9WZ8evd8QxWLGw7YnZ4xZ/c/Oro0R8P+Esse1mSfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776490; c=relaxed/simple;
	bh=gZXSmX31g+ypICGIBIIbsJpeOsvlq8amh+uD199YuZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1yTvGQ+RYCHdbZaDsWVRc/ajRCf7rftx+Zn6vKMDL+sgqqytMU8wHAGObRdLUZ0HYJ3xtB+Eut7pvwp6e88V7wPMT3WQpwa5XlpBsKSUPgSkW8IBtjjRNSEmkY9M9Crsk53n5w+7hNFjqWpkIlAQUh3XJ8iaUoWoUTa0tnCJ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KJGnJXHH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=m5NM0TQz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KJGnJXHH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=m5NM0TQz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KJGnJXHH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="m5NM0TQz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KJGnJXHH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="m5NM0TQz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3E73E3E09;
	Thu, 23 Jul 2026 03:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784776485;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cZC06j0IzCuL/OjCF7UfWAKX21n9ZKYlpyeWSyTMK24=;
	b=KJGnJXHHhwCQ1dHemRgm8+vZsk73JmDpudJgcCE3RSHm5j0eLXBgTLl/A6WGF9yt/0iKq5
	VFAVwGuDxcizu7uSUeqheiJU9/nHe4Wn7PyropMWnpJomJQIESkAyPh85pGxDtJGJQ/KzY
	gGKgCwk5gFRMJGt7RM/zLOnEvWab/Tg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784776485;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cZC06j0IzCuL/OjCF7UfWAKX21n9ZKYlpyeWSyTMK24=;
	b=m5NM0TQzx6JEDh0k6xtt+cQYhyPJS9GLlTPPSG5N/HwmZLjTMyF8ioKLKE+nin/yueji/E
	AhSkNT6VlHRxlSDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784776485;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cZC06j0IzCuL/OjCF7UfWAKX21n9ZKYlpyeWSyTMK24=;
	b=KJGnJXHHhwCQ1dHemRgm8+vZsk73JmDpudJgcCE3RSHm5j0eLXBgTLl/A6WGF9yt/0iKq5
	VFAVwGuDxcizu7uSUeqheiJU9/nHe4Wn7PyropMWnpJomJQIESkAyPh85pGxDtJGJQ/KzY
	gGKgCwk5gFRMJGt7RM/zLOnEvWab/Tg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784776485;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cZC06j0IzCuL/OjCF7UfWAKX21n9ZKYlpyeWSyTMK24=;
	b=m5NM0TQzx6JEDh0k6xtt+cQYhyPJS9GLlTPPSG5N/HwmZLjTMyF8ioKLKE+nin/yueji/E
	AhSkNT6VlHRxlSDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E8F3779B5;
	Thu, 23 Jul 2026 03:14:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uOkuCyWHYWqIUwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 23 Jul 2026 03:14:45 +0000
Date: Thu, 23 Jul 2026 05:14:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Boris Burkov <boris@bur.io>, Matthew Wilcox <willy@infradead.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: retry verity reads for not-uptodate Merkle
 folios
Message-ID: <20260723031444.GP10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260722025435.1493093-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722025435.1493093-1-chenyichong@uniontech.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Wed, Jul 22, 2026 at 10:54:35AM +0800, Yichong Chen wrote:
> btrfs_read_merkle_tree_page() can find a folio in the mapping that is not
> uptodate.  After taking the folio lock, the current code treats that state
> as a read error and returns -EIO.
> 
> That can make a previous transient read failure sticky.  If the failed read
> left a not-uptodate folio in the mapping, later callers find that folio and
> fail instead of retrying the read.
> 
> Keep the existing page-cache insertion and locking order, but retry the
> Merkle item read when a not-uptodate folio is found in the mapping.  Also
> unlock the folio when read_key_bytes() fails so that a later caller can
> lock it and retry the read.
> 
> Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
> Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
> v4:
> - Add a comment explaining the locked uptodate recheck.
> - Add Boris' Reviewed-by.
> 
> v3:
> - Keep the existing filemap_add_folio() and read ordering.
> - Retry the Merkle item read when a not-uptodate folio is found, as
>   suggested by Boris.
> - Unlock the folio on read_key_bytes() failure so later callers can retry.
> 
> v2:
> - Avoid calling filemap_remove_folio(), which is not exported.
> - Add the folio to the page cache only after read_key_bytes() succeeds.
> ---
>  fs/btrfs/verity.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 983365a73541..1133a56c0568 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -720,14 +720,18 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
>  			goto out;
>  
>  		folio_lock(folio);
> -		/* If it's not uptodate after we have the lock, we got a read error. */
> -		if (!folio_test_uptodate(folio)) {
> +		/* Folio was truncated from mapping. */
> +		if (!folio->mapping) {
>  			folio_unlock(folio);
>  			folio_put(folio);
> -			return ERR_PTR(-EIO);
> +			goto again;
>  		}
> -		folio_unlock(folio);
> -		goto out;
> +		/* Another reader may have filled the folio while we waited. */
> +		if (folio_test_uptodate(folio)) {
> +			folio_unlock(folio);
> +			goto out;
> +		}
> +		goto read_folio;

With that new label the main loop becomes a less readable, previously
there was just again and out. From a distance the loop likes a big while
from again: to read_key_bytes, so this may be a good followup cleanup
(if the end result is reasonable).

>  	}
>  
>  	folio = filemap_alloc_folio(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS),
> @@ -744,6 +748,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
>  		return ERR_PTR(ret);
>  	}
>  
> +read_folio:
>  	/*
>  	 * Merkle item keys are indexed from byte 0 in the merkle tree.
>  	 * They have the form:
> @@ -753,6 +758,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
>  	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
>  			     folio_address(folio), PAGE_SIZE, folio);
>  	if (ret < 0) {
> +		folio_unlock(folio);
>  		folio_put(folio);
>  		return ERR_PTR(ret);
>  	}
