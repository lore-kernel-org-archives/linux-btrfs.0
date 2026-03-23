Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC0733B970
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 19:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774295036; cv=none; b=hFHZqpvrUqijts/An8HSqZaC3HcbhShxJv5dksRkKFXZ4a5Mb2e7DBi9Tp5CyUfQMJYBXLTjTJXDiq0R1nq63cxFrNNQeyvqTvGwLe7skCwIBSg2BpNY+7uCEd6aCqt/VKEHcGGfRz8/+gB73NPciNnuWRkS+AItrkRqEwTnJTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774295036; c=relaxed/simple;
	bh=NpNegiL9ZUDp2GovSiXgrampPyhGpMenuPj99vfR9fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mg4JefFmtHyUhkJ9+KcDJWF2CqKvtXHR5ldp8GHXZcDyiwMqY7pxTZYdVGWo5pDmIc34K1m8umIelvYusuof1Lu75f38nBUN3KMb6gWDrkZE9j3MxkXWR2wIs2U/zBK0yab+y6GVza3CGwFctVUE9/pTMhxRnj+gxP2R8WMA934=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xmITdSsY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z8O94N8s; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xmITdSsY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z8O94N8s; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xmITdSsY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z8O94N8s";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xmITdSsY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z8O94N8s"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC31B4D38C;
	Mon, 23 Mar 2026 19:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774295033;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9g1CMIU+wCU3fy0GhK2yIW+ulfTzT+ZQR9Hw7wf6SwY=;
	b=xmITdSsYHjIXn4IZYltd8rSbP9yVzRUDlsjbA+QtQoLVRyqJ+rHZdVx3LZ63Jw7QjXajh+
	8/RIzOTggAR+F/3bRDixLWzv/t6VASY9MjbUBptEoP07iZ9edN3EGo26Zp7xwPphWYr/Jw
	9pWOK6zYb4za4yWYgAoSm9hciQg9sUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774295033;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9g1CMIU+wCU3fy0GhK2yIW+ulfTzT+ZQR9Hw7wf6SwY=;
	b=z8O94N8snOiby8ImvKjyW0F4Ad67vpfAlzZ6PgDgQmLKKfbT0ayiL/Xmny/j61WtE4ViJ+
	tmoa7LSZg6rZlgCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774295033;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9g1CMIU+wCU3fy0GhK2yIW+ulfTzT+ZQR9Hw7wf6SwY=;
	b=xmITdSsYHjIXn4IZYltd8rSbP9yVzRUDlsjbA+QtQoLVRyqJ+rHZdVx3LZ63Jw7QjXajh+
	8/RIzOTggAR+F/3bRDixLWzv/t6VASY9MjbUBptEoP07iZ9edN3EGo26Zp7xwPphWYr/Jw
	9pWOK6zYb4za4yWYgAoSm9hciQg9sUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774295033;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9g1CMIU+wCU3fy0GhK2yIW+ulfTzT+ZQR9Hw7wf6SwY=;
	b=z8O94N8snOiby8ImvKjyW0F4Ad67vpfAlzZ6PgDgQmLKKfbT0ayiL/Xmny/j61WtE4ViJ+
	tmoa7LSZg6rZlgCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A52A43A44;
	Mon, 23 Mar 2026 19:43:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TfibIfmXwWkgaAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 19:43:53 +0000
Date: Mon, 23 Mar 2026 20:43:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add remap-tree checks to check_block_group_item()
Message-ID: <20260323194348.GS5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260323172619.152258-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323172619.152258-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:replyto,harmstone.com:email];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Mon, Mar 23, 2026 at 05:26:13PM +0000, Mark Harmstone wrote:
> Add some write-time checks for block group items relating to the remap
> tree.
> 
> Here we're checking:
> * That the REMAPPED or METADATA_REMAP flags aren't set unless the
>   REMAP_TREE incompat flag is also set
> * That `remap_bytes` isn't more than the size of the block group
> * That `identity_remap_count` isn't more than the number of sectors in
>   the block group
> 
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> ---
>  fs/btrfs/tree-checker.c | 42 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 495d1dd61e66c2..cad23f3fadfd34 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -777,6 +777,48 @@ static int check_block_group_item(struct extent_buffer *leaf,
>  			BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA);
>  		return -EUCLEAN;
>  	}
> +
> +	if (unlikely(!btrfs_fs_incompat(fs_info, REMAP_TREE) &&
> +		     type == BTRFS_BLOCK_GROUP_METADATA_REMAP)) {
> +		block_group_err(leaf, slot,
> +"invalid type, METADATA_REMAP set but REMAP_TREE incompat flag not set");
> +		return -EUCLEAN;
> +	}
> +
> +	if (unlikely(!btrfs_fs_incompat(fs_info, REMAP_TREE) &&
> +		     flags & BTRFS_BLOCK_GROUP_REMAPPED)) {
> +		block_group_err(leaf, slot,
> +"invalid flags, REMAPPED set but REMAP_TREE incompat flag not set");
> +		return -EUCLEAN;
> +	}
> +
> +	if (item_size == sizeof(struct btrfs_block_group_item_v2)) {
> +		struct btrfs_block_group_item_v2 *bgi2;
> +		u64 remap_bytes;
> +		u32 identity_remap_count;
> +
> +		bgi2 = btrfs_item_ptr(leaf, slot, struct btrfs_block_group_item_v2);
> +
> +		remap_bytes = btrfs_block_group_v2_remap_bytes(leaf, bgi2);
> +
> +		if (unlikely(remap_bytes > key->offset)) {
> +			block_group_err(leaf, slot,
> +				"invalid remap_bytes, have %llu expect [0, %llu]",
> +					remap_bytes, key->offset);
> +			return -EUCLEAN;
> +		}
> +
> +		identity_remap_count = btrfs_block_group_v2_identity_remap_count(leaf, bgi2);
> +		if (unlikely((u64)identity_remap_count >
> +			     key->offset / fs_info->sectorsize)) {

64bit / 32bit may not work on all arches, we have the sectorize_bits to
avoid it.

> +			block_group_err(leaf, slot,
> +				"invalid identity_remap_count, have %u expect [0, %llu]",
> +					identity_remap_count,
> +					key->offset / fs_info->sectorsize);
> +			return -EUCLEAN;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.52.0
> 
