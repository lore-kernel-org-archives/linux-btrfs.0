Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CD633B6D3;
	Fri, 17 Jul 2026 20:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784319489; cv=none; b=gcGaear80c+8Weo1YkkIASX6GOB6tTUZ3j8WFI4MCuNx0rj7G7039bJ/z1aquJWmKz99pRmAZton/PFLTZFw4HMCC0421vSPe+g9RAyvtTbzQchC18y5TdHmWXYge+lKxTgDDY4/hW1ES+m43iPiX8KcW4MDhYB/FlZjRJn46Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784319489; c=relaxed/simple;
	bh=DGfAoUOE2UQawP2OxkwCcY94zeZxhYRGK6QehuhRpbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHyUYDFMWe1KrwaoXTQB/yvrntekpw5EjBFSzK8hHxwLmozqX7azb6xrxQp25rASffXA0VH2SYgLn/y3koNxIBc6QGdmisxRAcNkyfiWJ/e2ilxIqde+aUmTVJFH2HLGuUtNcBsXcwJWhYvos7n7B6ORErdVEMNLcDMd0S+E2zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=S/KDRgRW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kLIkYC2X; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="S/KDRgRW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kLIkYC2X"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id A3AB21D00119;
	Fri, 17 Jul 2026 16:18:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 17 Jul 2026 16:18:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784319486; x=1784405886; bh=N8GQiWZQFR
	eVeUzyIhET0hYjQGIOYiS2Viap9TAOyuw=; b=S/KDRgRWhQ25O/TSXyJwEyMKS9
	FnL7A+lHhQhys5tKatBeF8BdlsoS5QbdKK/1G4sUx2zOUGfPT3Q8xdPT8PZpIn/e
	QfhXoaV6qLO1UQ+ZVZxf0BJZumAgIwOC8JdZb/9MuThRWeerA90DNx+CiWEmPN9G
	ezXQ7VYN0UpNOHijbdV9dybWjvYWxQQADX161TlXm6FzbUHXwOnv4jdTpwiycc7H
	lBat4OUKHUMNCbzIf21hOx0EmGdh0KF213v+IScFYzLnsfZkWME6nhyMFEfhRxA/
	0gKY1nyfETHh1an305PNvNj4gQWoCQo7nZt5m8mrXu0nmQO+GNeC8UB5+ygA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784319486; x=1784405886; bh=N8GQiWZQFReVeUzyIhET0hYjQGIOYiS2Via
	p9TAOyuw=; b=kLIkYC2XvqQpzilUie6C9oV2s3Ns2T9+DfnV+PrXLyq52rfIuKT
	Sbtii7e2y039QSbAx4jyyw+oJCT9trBiY/J0B83+IBPbVkb7TZNB5GeMOmiMU6Qq
	Q/4TcykYMRalX09CBJGf67ezAr7OaevVn55scHzVujq76Nad1DtO3PDJ6Kym6G8C
	EHD7ImYoM3AMiOgREZIFhQph1LgRYSaJ6luaJB7K9yJJcQcTn4pmwTRnQnS6+jdl
	LSaBVskqwDt0F0BvJNvZuKFKH4Ad3TGIugtp+exbwqk+RsQ682yQw+3msjr7fOc6
	DXrr6rBrhmhXzrn6QAncI4+fXvBO0IT8wmw==
X-ME-Sender: <xms:_o1aai9L72urxJA9PMy4oXhDVwgYtPwJLeGYAeZ4BXNOlnh5hz5QsA>
    <xme:_o1aasCssOdc06UVT19Uz4_eaO0fHj_qQPHuFkYQg4wQQH_ym1EymTGp5HyE8ptJ1
    lA-5yvvLMKNGlc2bLpxTnjPI95_AICLtatVM8GqpDoJ2OmtLhJZt-8>
X-ME-Received: <xmr:_o1aavTc44jlGGdsxEP_qpVgA6UG4emQ2UZaEGCeUCQGxarxYefGODhXN3Jz_BtyM2Fanx3J93t_jzUng1ko1J4OwyE>
X-ME-Proxy-Cause: dmFkZTEp4VLN8UNatxjtjNlXDw615hXCDJXjEmAyUzet/LRA+2UxfLLbcFMZlLIepOi46m
    vQd+o3RLDS7L0SabDxla/wPUb+OgzyjwAvO+CHOjK0oAvpnGKN/0Wlnx3xG1UhpAsXqtv5
    TIc/soGpVwrMq+wH7OhndGU54lHK8AJ8UUW/iM0lmrf0GlVTwZPnKRnvOcqpB0Jko69BCq
    eJrvOrABlZDAm+IzgUtHACR6QVIs2IDG5LsefZULpsyGvSLhTf6o1s93MMkse01CwhFCgE
    kRpMvqZE+o6FOZ8jvJxGI+q1Y2TYoS+TRpGs3PJTH8L05gJNikKijJGfJu4S1ViFZVpWj3
    fBsZNhFQ3tg0G6Gb5A9znTUuJtjL8D1/FfVKezD/hI1djGeyj878TVmHjM2oTtsxq+Qqfc
    EXzyzWiZK4oSsqOig++WWDYtrPDUM3ymJLZFzAxF6Q1/OCTG9McgAu4Bcs3oefQ0n3m6QT
    VyTJD5F92WykPdfAVxh7sZO238+TdLRQfZxhizB019wpaMON6RBk9cokl1iA7nc9Brswk3
    KzL6HUrrwXZsqXiz4duxAXCYXi/2WKOn0WIX/SNvYNMBgGUzNvYm75EGPiSw39KgqwpBnh
    9Se+W3A7Gobm3IrQnx8iAvL+ieSl2+u3cnEA+ZVprRuJ4BLH6aQr7ZsCpdhg
X-ME-Proxy: <xmx:_o1aartqqNkwDrtAFWsFg_nCX88-pP2gxZ2bZ50JCmBJEehgmRaT2A>
    <xmx:_o1aaj3qBZlBmOKuKxnnCsD_NKmMJrfhYv6cms1z0hA6iL2Mkjys2A>
    <xmx:_o1aakWOAU1eBUC4q_LLj7Ku_Z0_WArQUqJbiPTL49hwFZjxFpkgVg>
    <xmx:_o1aamJtWxgU2tV-QrePvv9UAfh3QT-74ywx_yN1JpWAxMUg9PwMqg>
    <xmx:_o1aak9StJ5glWZ9tpL0JYDWGK54iBlfl0bpul0R2vcpfonoCA2POsjS>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Jul 2026 16:18:05 -0400 (EDT)
Date: Fri, 17 Jul 2026 13:18:05 -0700
From: Boris Burkov <boris@bur.io>
To: Jeff Layton <jlayton@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@fb.com
Subject: Re: [PATCH 3/4] btrfs: handle ENOMEM from btrfs_insert_dir_item()
 without aborting
Message-ID: <20260717201805.GB142812@zen.localdomain>
References: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
 <20260717-btrfs-enomem-v1-3-cdc9c0e265d0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717-btrfs-enomem-v1-3-cdc9c0e265d0@kernel.org>

On Fri, Jul 17, 2026 at 12:52:38PM -0400, Jeff Layton wrote:
> Now that btrfs_insert_dir_item() returns -ENOMEM before modifying the
> btree (thanks to delayed dir index pre-allocation), callers can handle
> ENOMEM gracefully instead of aborting the transaction.
> 
> In btrfs_add_link(), add -ENOMEM to the set of recoverable errors
> alongside -EEXIST and -EOVERFLOW. The fail_dir_item cleanup path
> unwinds the inode_ref/root_ref and returns the error to userspace.
> 
> In btrfs_create_new_inode(), when btrfs_add_link() fails with -ENOMEM,
> convert the newly-created inode into an orphan instead of aborting.
> This is done by clearing nlink and adding an orphan item, which ensures
> btrfs_evict_inode() will delete the INODE_ITEM and INODE_REF, and
> crash-recovery will clean it up via orphan processing. If
> btrfs_orphan_add() itself fails, we fall back to aborting.
> 
> This turns a filesystem-killing transaction abort into a graceful
> -ENOMEM return to userspace for create(), mkdir(), mknod(), symlink(),
> and link() operations under memory pressure.
> 
> Assisted-by: LLM
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/btrfs/inode.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b7b4e6177135..4d9947ae08f7 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6676,7 +6676,20 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
>  	} else {
>  		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
>  				     false, BTRFS_I(inode)->dir_index);
> -		if (unlikely(ret)) {
> +		if (ret == -ENOMEM) {
> +			/*
> +			 * The ENOMEM came before the DIR_ITEM was inserted,
> +			 * so the btree has our INODE_ITEM + INODE_REF but no
> +			 * directory entry. Convert this into an orphan so
> +			 * eviction (or crash-recovery) cleans up the inode.
> +			 */
> +			clear_nlink(inode);
> +			ret = btrfs_orphan_add(trans, BTRFS_I(inode));
> +			if (unlikely(ret))
> +				btrfs_abort_transaction(trans, ret);

I feel like the crux of this series to me is whether you have practical
conditions where the allocation of the delayed_node is failing, but the
allocations involved in btrfs_orphan_add() succeed. It allocates a
btrfs_path and has to walk the btree which might have to read the node
at every level which might need to allocate 16k extent buffers and
extent buffer objects and xarray storage for each one. For size
reference, on my build (maybe debug..?) a delayed_node is 552 bytes,
while a btrfs_path is 112 and an extent_buffer is 432. So they are
pretty similar in size (not to mention the 16k of node file backed
memory we are sort of likely to have to allocate if we are under
reclaim)

Were you able to reproduce this issue and help in practice or is this a
theoretical / structural improvement?

With that said, all the prealloc wiring looks good to me in general, and
it seems to be a pretty clean win for the "name exists" case in the next
patch.

Thanks,
Boris

> +			ret = -ENOMEM;
> +			goto discard;
> +		} else if (unlikely(ret)) {
>  			btrfs_abort_transaction(trans, ret);
>  			goto discard;
>  		}
> @@ -6738,7 +6751,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
>  
>  	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
>  				    btrfs_inode_type(inode), index, NULL);
> -	if (ret == -EEXIST || ret == -EOVERFLOW)
> +	if (ret == -EEXIST || ret == -EOVERFLOW || ret == -ENOMEM)
>  		goto fail_dir_item;
>  	else if (unlikely(ret)) {
>  		btrfs_abort_transaction(trans, ret);
> 
> -- 
> 2.55.0
> 
