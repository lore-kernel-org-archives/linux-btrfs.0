Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43553385533
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 09:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773652595; cv=none; b=N/UKBGJZIqdgtuuFYgSyyDybdoqX8hIy2BDeIPfFK8kbkzsvhIXw+6OwuEIYApL1OCjwueMHilNQCFJfpkaxA5F99veY9XeUpYLhkg0CKlBsWrY6IQvXHOY2D1z8N4XX5R+Ws7W9sYN9cZoZwLUv04BAC4DdK5LtdyM2DbV1FcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773652595; c=relaxed/simple;
	bh=1ENVmGtZndegG/Lx0o47iEvfGzi/uS2QfPDF5d+16aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=onet3ZdcdxJ4SPqZplUMqShlj28I9LPNUKI5iZqAwspbprvw+jPFExElo1RPPdxbS7QUrNlVYIpt9QxpLNQtUzRB4vIxm0bL9K8YbLqGA5K6JjHjYyarh37PyDiSJ+2jaz86x2bnk+a38A3/WYFINEMB+qlJFVt1QR2vFwvLK7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KHNCI8HK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4eD6LvMR; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KHNCI8HK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4eD6LvMR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KHNCI8HK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4eD6LvMR";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KHNCI8HK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4eD6LvMR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B1545BD0D;
	Mon, 16 Mar 2026 09:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773652591;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R83f2oy43eeiOElSMIiNfd7ubmoF/oZsKH9+UeyRfCw=;
	b=KHNCI8HKA9jEiCAL702UfrgSHfE28pCq1Vx4XP1PvrL0DTuMI80gXvfwYuO/RW1+wz+flQ
	sRY1RA+vsNKZoXFeW9Um65nwbiNbdJZJ4sgbHDu29LiOvPhxhtJDyNrPvNzBiei5z0MEsK
	Mc1NxSWJv8wAV0UDSFgFsgIM5xZUEbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773652591;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R83f2oy43eeiOElSMIiNfd7ubmoF/oZsKH9+UeyRfCw=;
	b=4eD6LvMRvrIrotjP6udNKNt09QPpHrWFyQWkY60ogecEddMv/GyS5wPl7NnyX10bNjfhNe
	fxejMf9hGXLh5KAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773652591;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R83f2oy43eeiOElSMIiNfd7ubmoF/oZsKH9+UeyRfCw=;
	b=KHNCI8HKA9jEiCAL702UfrgSHfE28pCq1Vx4XP1PvrL0DTuMI80gXvfwYuO/RW1+wz+flQ
	sRY1RA+vsNKZoXFeW9Um65nwbiNbdJZJ4sgbHDu29LiOvPhxhtJDyNrPvNzBiei5z0MEsK
	Mc1NxSWJv8wAV0UDSFgFsgIM5xZUEbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773652591;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R83f2oy43eeiOElSMIiNfd7ubmoF/oZsKH9+UeyRfCw=;
	b=4eD6LvMRvrIrotjP6udNKNt09QPpHrWFyQWkY60ogecEddMv/GyS5wPl7NnyX10bNjfhNe
	fxejMf9hGXLh5KAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 578964273B;
	Mon, 16 Mar 2026 09:16:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yRE6FW/Kt2m4EAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 16 Mar 2026 09:16:31 +0000
Date: Mon, 16 Mar 2026 10:16:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, Johannes.Thumshirn@wdc.com,
	Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2] btrfs: fix use-after-free in move_existing_remap()
Message-ID: <20260316091630.GP5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260306141843.27186-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306141843.27186-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
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
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

Subject changed to btrfs: hold block group reference during entire
move_existing_remap()"

On Fri, Mar 06, 2026 at 02:18:31PM +0000, Mark Harmstone wrote:
> There is a potential use-after-free in move_existing_remap(): we're calling
> btrfs_put_block_group() on dest_bg, then passing it to
> btrfs_add_block_group_free_space() a few lines later.
> 
> Fix this by getting the BG at the start of the function and putting it
> near the end. This also means we're not doing a lookup twice for the
> same thing.
> 
> Link: https://lore.kernel.org/linux-btrfs/20260125123908.2096548-1-clm@meta.com/
> Reported-by: Chris Mason <clm@fb.com>
> Fixes: bbea42dfb91f ("btrfs: move existing remaps before relocating block group")
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> ---
>  fs/btrfs/relocation.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 88b1ec416fe272..1c42c5180bddd5 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4177,6 +4177,8 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
>  	dest_addr = ins.objectid;
>  	dest_length = ins.offset;
>  
> +	dest_bg = btrfs_lookup_block_group(fs_info, dest_addr);
> +
>  	if (!is_data && !IS_ALIGNED(dest_length, fs_info->nodesize)) {
>  		u64 new_length = ALIGN_DOWN(dest_length, fs_info->nodesize);
>  
> @@ -4287,15 +4289,12 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
>  	if (unlikely(ret))
>  		goto end;
>  
> -	dest_bg = btrfs_lookup_block_group(fs_info, dest_addr);
> -
>  	adjust_block_group_remap_bytes(trans, dest_bg, dest_length);
>  
>  	mutex_lock(&dest_bg->free_space_lock);
>  	bg_needs_free_space = test_bit(BLOCK_GROUP_FLAG_NEEDS_FREE_SPACE,
>  				       &dest_bg->runtime_flags);
>  	mutex_unlock(&dest_bg->free_space_lock);
> -	btrfs_put_block_group(dest_bg);
>  
>  	if (bg_needs_free_space) {
>  		ret = btrfs_add_block_group_free_space(trans, dest_bg);
> @@ -4325,13 +4324,13 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
>  			btrfs_end_transaction(trans);
>  		}
>  	} else {
> -		dest_bg = btrfs_lookup_block_group(fs_info, dest_addr);
>  		btrfs_free_reserved_bytes(dest_bg, dest_length, 0);
> -		btrfs_put_block_group(dest_bg);
>  
>  		ret = btrfs_commit_transaction(trans);
>  	}
>  
> +	btrfs_put_block_group(dest_bg);
> +
>  	return ret;
>  }
>  
> -- 
> 2.52.0
> 
