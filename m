Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BE636C5A2
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 19:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773430979; cv=none; b=KyIfCUy2vytKQyyBlc3vLY+YF8vdMI4XsX3J+INaZ6z7mtOG/B2ZXiwGYYQstJ31acYVdwDMYmXC8lJRbinbBbcnvgXqDA+ky79LZKKjAn8t9qxXtLD3gSlduOTrRPCjxd/foGJCGcSvh8jUVv4BU+mNw473VfqIE9m+zq7bHxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773430979; c=relaxed/simple;
	bh=t08Kqt7AOiFPbqXlGcBPwIEXLYQgOicwnRdAIhldDZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ozo+YbphlbdPyH/VjfLRmpBuSop6l1exbu0aRecUOrmDbKnIxxkEGLMIs0M8oMchTb17Lzd8seNOkpebKWkM6c3HhYFqp3Pgv0+/4BrEZKlOPYe7HnWNcrAd1xhgNFXW9unUXXNfEkeheWrg6GjK6RXUD9ZpY40dTrcMENjGRf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0Ak2C9sR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/yh1M8ku; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0Ak2C9sR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/yh1M8ku; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0Ak2C9sR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/yh1M8ku";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0Ak2C9sR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/yh1M8ku"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5CB734DA9D;
	Fri, 13 Mar 2026 19:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773430976;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8PnflOzKrS/8Sic/AlV62ujFgnggtoY8LBBlyqYS5lo=;
	b=0Ak2C9sR0kKmkIPCT9J/yeeU6a96yQsAi4bAEmVVIuTIYLylR/EOQ8E+GtQuUdxuBFkapS
	FauEvAqE/Nt//5GK6r+LmAPu2EYKQcD9veu4XHynxeTeNMvZHcdm1razUbxopKBz104A5C
	Jc7/ASCxQB6/VJN1/UpB3jxs/R0XNUU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773430976;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8PnflOzKrS/8Sic/AlV62ujFgnggtoY8LBBlyqYS5lo=;
	b=/yh1M8kuw8O3vMpwX+UA1dsvHNG6eBoEeL9cExkO/DQvEKLNkeIWMYN1xuivS0MDge06aE
	5TZAsTtTyHrQehBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773430976;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8PnflOzKrS/8Sic/AlV62ujFgnggtoY8LBBlyqYS5lo=;
	b=0Ak2C9sR0kKmkIPCT9J/yeeU6a96yQsAi4bAEmVVIuTIYLylR/EOQ8E+GtQuUdxuBFkapS
	FauEvAqE/Nt//5GK6r+LmAPu2EYKQcD9veu4XHynxeTeNMvZHcdm1razUbxopKBz104A5C
	Jc7/ASCxQB6/VJN1/UpB3jxs/R0XNUU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773430976;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8PnflOzKrS/8Sic/AlV62ujFgnggtoY8LBBlyqYS5lo=;
	b=/yh1M8kuw8O3vMpwX+UA1dsvHNG6eBoEeL9cExkO/DQvEKLNkeIWMYN1xuivS0MDge06aE
	5TZAsTtTyHrQehBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F846406C1;
	Fri, 13 Mar 2026 19:42:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mOxID8BotGlHeAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 13 Mar 2026 19:42:56 +0000
Date: Fri, 13 Mar 2026 20:42:47 +0100
From: David Sterba <dsterba@suse.cz>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: dsterba@suse.com, clm@fb.com, wqu@suse.com, osandov@fb.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH v2] btrfs: tree-checker: introduce checks for
 FREE_SPACE_BITMAP
Message-ID: <20260313194247.GK5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260310105606.2134142-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310105606.2134142-1-gality369@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,fb.com,vger.kernel.org,gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Tue, Mar 10, 2026 at 06:56:06PM +0800, ZhengYuan Huang wrote:
> Introduce checks for FREE_SPACE_BITMAP item, which include:
> 
> - Key alignment check
>   Same as FREE_SPACE_EXTENT, the objectid is the logical bytenr of the
>   free space, and offset is the length of the free space, so both
>   should be aligned to the fs block size. 
> 
> - Non-zero range check
>   A zero key->offset would describe an empty bitmap, which is invalid.
> 
> - Item size check
>   The item must hold exactly DIV_ROUND_UP(key->offset >> sectorsize_bits,
>   BITS_PER_BYTE) bytes.  A mismatch indicates a truncated or otherwise
>   corrupt bitmap item; without this check, the bitmap loading path would
>   walk past the end of the leaf and trigger a NULL dereference in
>   assert_eb_folio_uptodate().
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> [CHANGELOG]
> v2:
> - Move the FREE_SPACE_BITMAP item size validation from
>   load_free_space_bitmaps() in free-space-tree.c into tree-checker, so
>   corrupt bitmap items are rejected when the leaf is read from disk.
> - Drop the extent_buffer_test_bit() range check added in v1.
> - Rework the fix to follow Qu Wenruo's suggested tree-checker based
>   validation.
> ---
>  fs/btrfs/tree-checker.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index c10b4c242acf..0f12fe462b6c 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1901,6 +1901,42 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
>  	return 0;
>  }
>  
> +static int check_free_space_bitmap(struct extent_buffer *leaf,
> +				   struct btrfs_key *key, int slot)
> +{
> +	struct btrfs_fs_info *fs_info = leaf->fs_info;
> +	const u32 blocksize = fs_info->sectorsize;
> +	u32 expected_item_size;
> +
> +	if (unlikely(!IS_ALIGNED(key->objectid, blocksize) ||
> +		     !IS_ALIGNED(key->offset, blocksize))) {
> +		generic_err(leaf, slot,
> +			    "free space bitmap key range is not aligned to %u, has (%llu %u %llu)",

We have a format specifier macro for keys, KEY_FMT, I'll fix it in git.

> +			    blocksize, key->objectid, key->type, key->offset);
