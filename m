Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DF538E8D0
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 21:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788213476; cv=none; b=OEGjmWV/TKsVS3f/kTGZ8SlmFzdN8j/im/1LtKzDD4omMBAjZtICSzbTMGbd7noBUowvLzJ56GShqklRvBTxahm/ud1HLqxTZ/NUiBCLTFPKP1jdGQUZ2Lrp7pg51eaddd30dtkaDffVh6AHNwvEpuB3gKOOEubdimNI2IiTNLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788213476; c=relaxed/simple;
	bh=Wg2MQ4H/ZtH0Km9ICdl3uFcwvsp6VBy4yN128x1bv2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gHzChUV6BKti0nsG8u1z7l7rQqZCfG66JTp8dTLymLUr90eEMEyHd/V2L9KOZ4Ej4nK97SL6Snxs3H9SUciw+RtYBT0II0TW2Sd8IWOALOQ6+hcHYBx8ZDVYLNXXghFgqj0n7iVfcYH0wnYwb98k/oqKDLny0vOBjC4JbvxoLVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=pD0DQFSu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=flHQ/7sA; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="pD0DQFSu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="flHQ/7sA"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 4A2B1EC0222;
	Mon, 31 Aug 2026 17:57:54 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 31 Aug 2026 17:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1788213474; x=1788299874; bh=a4RZVwvQts
	BUCOA3GLD7O49pMqq+5/alp83vNpQ8l+E=; b=pD0DQFSu6uifBNxzOCEXN2RGQh
	4hx7yx5NGkjiliPn6B5h/fYAL2vqQURmC0OPwzvBONJ7Gpx+xzNymQuhE1+B5Q7/
	rEoB/wk/rMe1wqCVyt2Tr8q5PuVGxOAyezemqwbXbbOdqBU38dYVFwGW3DFJ1DkD
	ikn14MSzFcebr0LKITgJ3q3s0kY7ZykMQNAfFAIOV3eOOmGjD5ByY/yCtTebzwS3
	8umMrvGPr6fbxULv1yIHBYGehLHJWkapDFlriJQ1OmA2YAEjrtKwbeOf4z0e6IYT
	a4rEn35ogQTqRJBjot+Prt+9TG4XXTuem4xEDb1pVQX8KqAMtpIIhdvCOdZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788213474; x=1788299874; bh=a4RZVwvQtsBUCOA3GLD7O49pMqq+5/alp83
	vNpQ8l+E=; b=flHQ/7sA/kIEkLCHBCZl3BCJY8Ncw5ZlNhoMgsaA+YOzVDke2t9
	JzAF3S2USnFbb0RFZ55HqcZfP4jYcgw1Ip2Uku/GgDgNla6I94dfW9qIyv1Nuch2
	eFdASwPfIOerE9E8bQwciRvPVFiyRs/vNrHISUhOJ9RmjiZHte4MDRo+jwz5POkK
	8Z/3DVf6WBbAxUBjK8huE9IoN9lUQKcSulVgvoqiRzMN+UfWVWM+vSaft94rnNQQ
	tv4FuUFp2tnl5TAVPjecM2XOv6Xx5LilTgpYH5QL46sgyV9X5MQOM7Twaw8S+I93
	lmDgSG3AcldnEVWRd/TzzXj7N67Xby9ZMnw==
X-ME-Sender: <xms:4viVagBq9zyxp6kBUCoYWBlVHcsmXICWx2LDPdXxICXs1KF1OqAA8g>
    <xme:4viVap8ZZqg-eC514JzvFiEyGQCvPivjz75RlwLh6FtNnIJ5Mbj6TZl3P4MRqOio5
    bOFixtwT-Z6Z7Axob3JGZQdbHRT4ADpJKsg0X9Hs4k2pp4j-bbDU6I>
X-ME-Received: <xmr:4viVag_LjyOlx-jiZzcQx1A7yuUrSYcV0ofFQZmpMNFMzS765U73A_fztXxS_ijViy05l7eN3C2lqkR-6Fo0fRwWX1Q>
X-ME-Proxy-Cause: dmFkZTEXVG33A4gXwpikdRAsYaq9QTbL4MXjxgongF7orcLQ/7sdus+f5xFUCNIZxs7wAb
    HfKNAV07l6vvtUK8jtjIrFwBpjGosTsYG+4mvgsIEGZIzvE8Wj1fd01UimBNa4T5c3kfnD
    2V3UvJ9fm4q64EKs8uunDRgm9UhUNuh213Pacx0eTLixRYsqV8jgXTBR754Zcgk/RgFd+L
    vJUjFjVqR4qghl8d/ZjhvKtdS1GrldzsHJL+L0tMwe1TfNc4gWElI0nzdq3/cr+X+a8avP
    QUurG4/zr+aTvxbXZGusgUQDNCKh1Da/8YiPs9y7WPDspEWTlIPLq1Aa6Y7ySSyo2GBBck
    4199MBTsdNqEeeVQT2avVVN9BeP3ZmpY4wgEZ45RaA9t6mNkJMnOH01MTUS6CnQEVfe0UA
    UCXScjApQchT4YEGf3dlm5zhNeV/UJCWZ27nwC3szpQjTgrqd3Ra948pqcaXRA4ASjXtB9
    jByThbzmfG6WHOy5adsXy0i213IUKWl8QNjSi8gfTCVo5PRhNyOhUOUejECdiYthfi79l8
    xJlsF/stgS8bbnmEOS/cj85x9TAyp2qgvJkepLdDfme/kx8bQEkmN5t3i9Ab0wjU6EeD+T
    gUpn0iDopII12DMfVx5gwudtfK216T7SoQIb8Xjx0YkVQpFjBDVaBjwW+jZQ
X-ME-Proxy: <xmx:4viVagdzR3EQW58iWMlMkjOYMwwycdQgO6lC-57FpT5SqLNz_xp5Rw>
    <xmx:4viVapG_mfOuaHIMrbJ1QNB-Q2uF-CZGUV71WYaNE--kWF3QNng1Iw>
    <xmx:4viVaudX0DzedYTfaJ9JUwmeIZK2dX4uywku_8pj62DerMkaG1s4bg>
    <xmx:4viVajEBdtxVynjVodmxQwYs2knwKQc9DPkgychIo1bKgJvdjZplaw>
    <xmx:4viVaqV4RjS5TSuKZ2ZSK9qYsNqws2b6ZQ9tJgol11LuYmV16Jqd0Ffj>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 17:57:53 -0400 (EDT)
Date: Mon, 31 Aug 2026 14:57:14 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH] btrfs: set space_info before adding new free space in
 btrfs_make_block_group()
Message-ID: <20260831215714.GD325502@zen.localdomain>
References: <20260824164758.2012077-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824164758.2012077-1-johannes.thumshirn@wdc.com>

On Mon, Aug 24, 2026 at 06:47:58PM +0200, Johannes Thumshirn wrote:
> btrfs_make_block_group() calls btrfs_add_new_free_space() before
> assigning cache->space_info. On a zoned filesystem that ends up in
> __btrfs_add_free_space_zoned(), which dereferences
> block_group->space_info and thus hits a NULL pointer dereference when a
> non-initial free space range is added (e.g. during relocation).
> 
> Assign cache->space_info before the btrfs_add_new_free_space() call.
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/block-group.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 830460a40e86..ee182369254c 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -3074,21 +3074,25 @@ struct btrfs_block_group *btrfs_make_block_group(struct btrfs_trans_handle *tran
>  		return ERR_PTR(ret);
>  	}
>  
> -	ret = btrfs_add_new_free_space(cache, chunk_offset, chunk_offset + size, NULL);
> -	btrfs_free_excluded_extents(cache);
> -	if (ret) {
> -		btrfs_put_block_group(cache);
> -		return ERR_PTR(ret);
> -	}
> -
>  	/*
>  	 * Ensure the corresponding space_info object is created and
>  	 * assigned to our block group. We want our bg to be added to the rbtree
>  	 * with its ->space_info set.
> +	 *
> +	 * On a zoned filesystem btrfs_add_new_free_space() ends up in
> +	 * __btrfs_add_free_space_zoned(), which dereferences
> +	 * block_group->space_info, so it has to be set beforehand.
>  	 */
>  	cache->space_info = space_info;
>  	ASSERT(cache->space_info);
>  
> +	ret = btrfs_add_new_free_space(cache, chunk_offset, chunk_offset + size, NULL);
> +	btrfs_free_excluded_extents(cache);
> +	if (ret) {
> +		btrfs_put_block_group(cache);
> +		return ERR_PTR(ret);
> +	}
> +
>  	ret = btrfs_add_block_group_cache(cache);
>  	if (ret) {
>  		btrfs_remove_free_space_cache(cache);
> -- 
> 2.55.0
> 
