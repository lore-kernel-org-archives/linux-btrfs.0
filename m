Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755BE3DFC88
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 19:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773430738; cv=none; b=o4Fsp9L3g2hG+e8EDX1/FTQ5JF7oFTCuEFQdjslnaS8TpgOxErJIJeK8Nlwims7f8uDaOj9/5AQYVqN7Q11TkmuE9gsumVCMj7LdsW1hfsQa00my9xLrVOn0cDUYYjG79vPa4QaluqPvMdn0AV/Yuo5JKhyuwUjvm6zhY5WmJyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773430738; c=relaxed/simple;
	bh=2bCQb29nUkpxOQVDFi6kbDXMmoY9VNAGMNRG8XkNm0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkVndhBcTTEIDugZhszR4Pwgy9HOM1lW0m0WO7UX6Q6HGxPir18INsyWgEfRRQ05wMejI9JIuU1oJcS1+ynwwkRkfBQBNoRDJGjqYtWAsZl/Iy3r8MnSX+dXSE9QZooEKmiERlNvnaNFsgJ0Rb8nsH3uUbv1sEoPDWr23RH03lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MBElakLw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qewrT6aJ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MBElakLw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qewrT6aJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MBElakLw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qewrT6aJ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MBElakLw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qewrT6aJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 61C8B4DA5A;
	Fri, 13 Mar 2026 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773430728;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oHYzI3iwZBX3Gx5AlMzGQOAOMd+1QSIOAPvo3vVZAB4=;
	b=MBElakLwPgKwoi111O26WuIgckZvdBvbqQhS5yVM+nWvZnsCNC7aGEnvQtZdcFNxIrEyeq
	dMDfIf9jCL8d5BFpzx/1u099n6fm//SeBfXFLfjOlNGnPzVk/HpDxLOEasZyda8P3c/8Hl
	IVGCr6kxIaJy/6ub3zhpqWp6yxk5rws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773430728;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oHYzI3iwZBX3Gx5AlMzGQOAOMd+1QSIOAPvo3vVZAB4=;
	b=qewrT6aJscXxmh8qoQusAVKk5XRHlmgrzTwt6brr95O7c3NIQ9tBc87YAwg0rTWqHgMeYc
	UEkwzyJisvKxrIBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773430728;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oHYzI3iwZBX3Gx5AlMzGQOAOMd+1QSIOAPvo3vVZAB4=;
	b=MBElakLwPgKwoi111O26WuIgckZvdBvbqQhS5yVM+nWvZnsCNC7aGEnvQtZdcFNxIrEyeq
	dMDfIf9jCL8d5BFpzx/1u099n6fm//SeBfXFLfjOlNGnPzVk/HpDxLOEasZyda8P3c/8Hl
	IVGCr6kxIaJy/6ub3zhpqWp6yxk5rws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773430728;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oHYzI3iwZBX3Gx5AlMzGQOAOMd+1QSIOAPvo3vVZAB4=;
	b=qewrT6aJscXxmh8qoQusAVKk5XRHlmgrzTwt6brr95O7c3NIQ9tBc87YAwg0rTWqHgMeYc
	UEkwzyJisvKxrIBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44163406BD;
	Fri, 13 Mar 2026 19:38:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hhR4EMhntGk4dAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 13 Mar 2026 19:38:48 +0000
Date: Fri, 13 Mar 2026 20:38:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: output more info when duplicated ordered
 extent is found
Message-ID: <20260313193847.GJ5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1772874800.git.wqu@suse.com>
 <9568c0c9f72806be005a8ab7c35201229518af2b.1772874800.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9568c0c9f72806be005a8ab7c35201229518af2b.1772874800.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.cz:replyto];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.com:email,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Sat, Mar 07, 2026 at 07:43:37PM +1030, Qu Wenruo wrote:
> During development of a new feature, I triggered that btrfs_panic()
> inside insert_ordered_extent() and spent quite some unnecessary before
> noticing I'm passing incorrect flags when creating a new ordered extent.
> 
> Unfortunately the existing error message is not providing much help.
> 
> Enhance the output to provide file offset, num bytes and flags of both
> existing and new ordered extents.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ordered-data.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index b34a0df282f3..bc88b904d024 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -253,10 +253,15 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
>  	spin_lock(&inode->ordered_tree_lock);
>  	node = tree_insert(&inode->ordered_tree, entry->file_offset,
>  			   &entry->rb_node);
> -	if (unlikely(node))
> +	if (unlikely(node)) {
> +		struct btrfs_ordered_extent *exist =
> +			rb_entry(node, struct btrfs_ordered_extent, rb_node);
> +
>  		btrfs_panic(fs_info, -EEXIST,
> -				"inconsistency in ordered tree at offset %llu",
> -				entry->file_offset);
> +"existing oe file_offset=%llu num_bytes=%llu flags=0x%lx new oe file_offset=%llu num_bytes=%llu flags=0x%lx",

This uses the "key=value" format while this is an exception in the
messages. The tracepoints use "=" as it's main purpose is to print just
a list of values but messages also contain other text. We should keep it
consistent.

> +			    exist->file_offset, exist->num_bytes, exist->flags,
> +			    entry->file_offset, entry->num_bytes, entry->flags);
> +	}
>  	spin_unlock(&inode->ordered_tree_lock);
>  
>  	spin_lock(&root->ordered_extent_lock);
> -- 
> 2.53.0
> 
