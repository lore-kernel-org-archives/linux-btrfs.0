Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B64A222597
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271031; cv=none; b=V2Y6Iz7OP60wDk5GXkXbYU1IE+ZmscZPfIdjdu+LXCHDiP4Bq3UQj5/9+fWKnwFnUzI3TtVjlgE1HMo51fyCg59lLEsZznf76qjyHAsfzHsD2jmIaCAVbcn8ITiWpHd3QL8aJwbrJYFdQb/A6rj6OZlrrSqK6yJ3CMHxtv3ejp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271031; c=relaxed/simple;
	bh=cTcR8gAOEzCQoZKviGUs+zhO+7blfdbH1drNBEEWB0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EENvFAQn/oTGe8WG792KeeTH8+9DmmOaYmGej29Ogv/JQIL7QuWVN02CiV3udqPVkSA7rc4/5bVeXFqnXV/JxIrthA0uYtn4/ubCjQCUoGm/0xoZr/K5xvIUNdoogsY5douX3mcL/Skf+6B82dgciY1fWny8VWS3ompcmIdKphQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Ueg+njt/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Uefv1mLv; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Ueg+njt/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Uefv1mLv"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id D48F91D000DB;
	Thu, 24 Sep 2026 13:30:28 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 24 Sep 2026 13:30:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1790271028; x=1790357428; bh=MEZ4XbcnMu
	8TCwl7tKcJ+M4GRzJMjwoHZfsE47wixuk=; b=Ueg+njt/WANKK9i8XOS45L3ZdQ
	5NjNOCYIU8d53tScIw0bijGe60IxMwd2EZLbmfvUWMlWPm6WeyAL6aPhbH8hAQBC
	8aMaPTJzsrfRTfjI6ycE4wnS/KB59u1StnnOzfOrVY0AOQ+4lxZrCwjrG1mVAjix
	MUU+JFk0XZiRRKd+RQtpwjAGtA/QA/XMcPSwsp9r8POleHPsVKkXA034wl6qcXAs
	ISW6hS+4ZH0spfj2+ArKrRTrSZfSr+YpnSqqbsczWHkCjw0LSPA6z/E6RTu+472X
	+vGxtgxaWMZ0IxyqVMwnpqNn1AfhRKxkEhPpXJjSTbykKjrZSe+7siUYkn4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790271028; x=1790357428; bh=MEZ4XbcnMu8TCwl7tKcJ+M4GRzJMjwoHZfs
	E47wixuk=; b=Uefv1mLvhiCtVEyn4yKnRm/MxzG3+/r+t9LQaiK2ygGmExcC/C6
	Dgc/7MRFv8UyVjYlUFJRfRADaDKAXE5LDtJ+7k3YAZS64teGZ4D8aH1yQxF4Qr7l
	t9csQF7B7R9XAKoj9yxcsfqsL0rXDkT7JVnAvg8VCtBc1YKas4ADl2p51ADLvXWm
	uMbOf9qNXvaAcesZ2pkDiYOhKmfqCQRJ7N63YF7kPhvGAIiuCqYpY7X5PX/0nswf
	G8aSYbyXF/tZdLyt4X03Y5E8i73X8yC5RaNWdNI22whv5s2pDCG4nlqqct72HB3M
	6vX1HxVubVo0Avl0nQrqHY4qAJhrp0CIbyQ==
X-ME-Sender: <xms:NF61auA007F2eEWs9wIsq-Nj4ODhGF8Ixpi6eEjbLOVywnw49JyEag>
    <xme:NF61auhigk_w7R0QbUsRxKRP2L9t8RR8DKb8XZ48Y6xbhum8fjo_ijt4nBnVcor6f
    ZVUNDiAEdy9Xo8gfaXrOmfCBKLUokG_gtIi4H_Ha2gUicierhyEmxpN>
X-ME-Received: <xmr:NF61avOCiZHgs043HuNPuJk2M_D1Juilh5jyjTCWLN9ZI6NYO551TTI>
X-ME-Proxy-Cause: dmFkZTGDX5bWLxUwfVch6/JDR6keSNRPPXmLkUkPKySFAhZm6WpXg8jFk3q2adz8J07w+6
    MxKOVsOdiCAeNiNkXIkiT9V4s4jPj3X6EY0PWqxg8gIao9YuJ1g0cNq1QQe5BUo6AzvM4Z
    zAiL65zDBUVZs05oEQCEznkQ+9eehi3GYToD6NKkq6FCSxebJjQygoRuB1srl4CwASE5OU
    ts8B1D2cqORvXwDAzH5TtsyPAijP9DO7OBecB6THmzoK111z6wdQXk53LIiWNEWn/OfiPi
    BsEDRsrC9S2MHy2UTyix5vkpVQbecrCgiwXuOC2+7dVhITPnDojpOFlKwvWhQWj9qww/Hj
    pGsFUZxyI4vmdlJoM90DjxEHVwSBJejqgjQObM0dMGj1YTywaXHzhso7f2lOsCv0ymSCiQ
    vUV/4qfco+A/J0XS6ngiPN9jen4+umPeFUDNyfnj1k0CX2gCo4F/I2aZEqrV849zLdUTdT
    y0J9STebs1KN9nO98X2VveLlasOjAbz0/Jz3SnCSWiD20Ms+90EthNbB7X+q8YS7iduTB+
    A35Ccksoa9FY5XQtaBb1bBTdNUXu5RglvWciz42y3cuAA320dcORcpoOS4yMqVzodkpezT
    zgW+Kh8MfYSlYEmQQFujowg1NY3zKmwkMNPyLSF5ypRHoVzWXxLUnyuXx+8g
X-ME-Proxy: <xmx:NF61an5cER2FRdM1fNuB-CtYE9yjsVRTS414RPcmkKVeqy1m_j0BoQ>
    <xmx:NF61al0TbGuFBAUH-QhmAi9lyyU-o6Hpogz-G4GvsCcNJs8FnYEUqw>
    <xmx:NF61aga4vfNyCIC4NadXzkSFsxtmW5iyX1JvzO4_G7FV4ylfS1TETA>
    <xmx:NF61alBxOfAkBTDNHUd2Ar7Xo7A_d-LOdbxTn-Pz1W9-EiJNFHWu3A>
    <xmx:NF61aoMzlHFoi-j61qp1cofEPXnhxcu8RZn1X480xHIcFhayi7isLbCS>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Sep 2026 13:30:28 -0400 (EDT)
Date: Thu, 24 Sep 2026 10:30:29 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 4/6] btrfs: introduce compression for delayed bbio
Message-ID: <20260924173029.GB2146908@zen.localdomain>
References: <cover.1789687750.git.wqu@suse.com>
 <8836d526f71544e21557b428cc697b44dc060d62.1789687750.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8836d526f71544e21557b428cc697b44dc060d62.1789687750.git.wqu@suse.com>

On Fri, Sep 18, 2026 at 09:00:29AM +0930, Qu Wenruo wrote:
> The compressed write path inside a delayed bbio is mostly the same as
> regular compression, but with some differences:
> 
> - The error handling should not touch folio flags
>   It will be handled by the parent delayed bbio.
>   And those folios already have WRITEBACK flag set, not the LOCKED flag
>   of the async submission path.
> 
> - A successful compression will lead to a child compressed bio
>   That compressed bio will be properly submitted, and if there are no
>   more pending IOs of the delayed bbio, end the delayed bbio.
> 
>   There is a minor note, since we're going through the regular
>   extent_writepage_io() path, we can have multiple bbios for the same
>   delayed ordered extent.
> 
>   This means we may have a slightly lower compression ratio if for
>   whatever reason the writeback path chooses to submit a smaller bio.
> 
> - No sequential execution of data extent reservation
>   The existing async thread has one quirk related to the ordered
>   function execution, which is not suitable for this call site.
> 
>   After the compressed bio is submitted, we can no longer touch the
>   child compressed bio (it could finish immediately and also finish the
>   parent delayed bbio).
>   Meanwhile the async ordered function needs different entries to handle
>   the workload and free involved structures.
> 
>   These will be the major changes compared to the existing compressed
>   write.
> 
> - No extra blkcg/write flag inheritance
>   This is a missing feature compared to the older async compression.
>   This needs to be implemented in the future, but priority shouldn't be
>   that high.

I believe there is reservation double counting, detailed inline. 

> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/inode.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 113 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2d6a581d977b..fbc0e5426d45 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7696,14 +7696,126 @@ struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
>  	return em;
>  }
>  
> +static void end_bbio_delayed_compressed(struct btrfs_bio *bbio)
> +{
> +	struct delayed_bio_private *dbp = bbio->private;
> +	struct btrfs_bio *parent = dbp->delayed_bbio;
> +	struct folio_iter fi;
> +
> +	bio_for_each_folio_all(fi, &bbio->bio)
> +		btrfs_free_compr_folio(fi.folio);
> +	btrfs_bio_end_io(parent, bbio->bio.bi_status);
> +	bio_put(&bbio->bio);
> +}
> +
> +static bool try_submit_compressed(struct btrfs_bio *parent)
> +{
> +	struct delayed_bio_private *dbp = parent->private;
> +	struct btrfs_inode *inode = parent->inode;
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct btrfs_key ins;
> +	struct compressed_bio *cb;
> +	struct extent_state *cached = NULL;
> +	struct extent_map *em;
> +	struct btrfs_ordered_extent *ordered;
> +	struct btrfs_file_extent file_extent;
> +	u64 alloc_hint;
> +	const u32 len = bio_get_size(&parent->bio);
> +	const u64 fileoff = parent->file_offset;
> +	const u64 end = fileoff + len - 1;
> +	u32 compressed_size;
> +	int compress_type = fs_info->compress_type;
> +	int compress_level = fs_info->compress_level;
> +	int ret;
> +
> +	if (!btrfs_inode_can_compress(inode) ||
> +	    !inode_need_compress(inode, fileoff, end, false))
> +		return false;
> +
> +	if (inode->defrag_compress > 0 &&
> +	    inode->defrag_compress < BTRFS_NR_COMPRESS_TYPES) {
> +		compress_type = inode->defrag_compress;
> +		compress_level = inode->defrag_compress_level;
> +	} else if (inode->prop_compress) {
> +		compress_type = inode->prop_compress;
> +	}
> +	cb = btrfs_compress_bio(inode, fileoff, len, compress_type,
> +				compress_level, 0);
> +	if (IS_ERR(cb))
> +		return false;
> +
> +	round_up_last_block(cb, fs_info->sectorsize);
> +	compressed_size = cb->bbio.bio.bi_iter.bi_size;
> +	/* If no space is saved, abort and mark the inode NOCOMPRESS. */
> +	if (compressed_size >= len) {
> +		if (!btrfs_test_opt(fs_info, FORCE_COMPRESS) &&
> +		    !inode->prop_compress)
> +			inode->flags |= BTRFS_INODE_NOCOMPRESS;
> +		cleanup_compressed_bio(cb);
> +		return false;
> +	}
> +
> +	alloc_hint = btrfs_get_extent_allocation_hint(inode, fileoff, len);
> +	ret = btrfs_reserve_extent(inode->root, len,
> +				   compressed_size, compressed_size,
> +				   0, alloc_hint, &ins, true, true);

This consumes bytes_may_use and moves it to bytes_reserved

> +	if (ret < 0) {
> +		cleanup_compressed_bio(cb);
> +		return false;
> +	}
> +	btrfs_lock_extent(&inode->io_tree, fileoff, end, &cached);
> +	file_extent.disk_bytenr = ins.objectid;
> +	file_extent.disk_num_bytes = ins.offset;
> +	file_extent.ram_bytes = len;
> +	file_extent.num_bytes = len;
> +	file_extent.offset = 0;
> +	file_extent.compression = cb->compress_type;
> +
> +	cb->bbio.bio.bi_iter.bi_sector = ins.objectid >> SECTOR_SHIFT;
> +	em = btrfs_create_io_em(inode, fileoff, &file_extent, BTRFS_ORDERED_COMPRESSED);
> +	if (IS_ERR(em)) {
> +		ret = PTR_ERR(em);
> +		goto out_free_reserve;
> +	}
> +	btrfs_free_extent_map(em);
> +
> +	ordered = btrfs_alloc_ordered_extent(inode, fileoff, &file_extent,
> +					     1U << BTRFS_ORDERED_COMPRESSED);
> +	if (IS_ERR(ordered)) {
> +		btrfs_drop_extent_map_range(inode, fileoff, end, false);
> +		ret = PTR_ERR(ordered);

Now this fails with ENOMEM

> +		goto out_free_reserve;
> +	}
> +	cb->bbio.ordered = ordered;
> +	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
> +	btrfs_unlock_extent(&inode->io_tree, fileoff, end, &cached);
> +
> +	cb->bbio.end_io = end_bbio_delayed_compressed;
> +	cb->bbio.private = dbp;
> +	atomic_inc(&parent->pending_ios);
> +	btrfs_submit_bbio(&cb->bbio, 0);
> +	return true;
> +
> +out_free_reserve:
> +	btrfs_dec_block_group_reservations(fs_info, ins.objectid);

We free bytes_reserved, so bytes_may_use and bytes_reserved both no
longer reflect the reservation.

> +	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, true);
> +	btrfs_unlock_extent(&inode->io_tree, fileoff, end, &cached);
> +	cleanup_compressed_bio(cb);
> +	return false;

And fallback to uncompressed submission in run_delayed_bbio() which
calls btrfs_reserve_extent() again.

> +}
> +
>  static void run_delayed_bbio(struct work_struct *work)
>  {
>  	struct delayed_bio_private *dbp = container_of(work, struct delayed_bio_private, work);
>  	struct btrfs_bio *parent = dbp->delayed_bbio;
>  
> -	/* Compressed and uncompressed fallback is not yet implemented. */
> +	if (try_submit_compressed(parent))
> +		goto finish;
> +
> +	/* Uncompressed fallback is not yet implemented. */
>  	ASSERT(0);

Sorry hard to reply across patches, but clearly it is still OK in this
version :)

>  
> +finish:
>  	/*
>  	 * Any real compressed/uncompressed bios have increased
>  	 * parent->pending_ios, the last caller of btrfs_bio_end_io()
> -- 
> 2.55.0
> 
