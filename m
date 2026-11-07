Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794013002;
	b=Dhqw05LK+zh3HHUMbchjLq/TyeuVC5NkI8vYjtQHF6Z9VXTaLtpf8Nz20nrJNpO+Jfsc
	 2fL3D1XH424iJ5R8jTgYSYNFHwpBZ4c2s60Z9Zh1kIVoWGiBX+jWQO0moj4CmP2E0RphP
	 ueHRPW5ASCnQdVt60eUFFlGLLnE7uLzWvnsF9cJgzsyueFYspqtOcMBQRr4TFq5IaQGdn
	 wO9D0bqaCaLOMU0/LEFVzTaBgfLffh9nFqzRkEmXY9sVxnvmWXmNQTtIfZOVXxrpcclFm
	 +Cc4Bin9yVgnDpINVl9uqlUmgWESpKwLWh9Bu/DmcdU8+9oEw9o2PMXfF5cATParnPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794013002;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=moK8FoBrjf2gfaaRzRJOFALpzci8unBYEIKmVt+2NIY=;
	b=a9T9jSjiov4iNBbFuj2LBbX85UvM6MAz7U5Jw0AWCyPwtu7YcnAox3+d6uql7wsesd6h
	 No3chjO7iuoF1lneMq3q6WxeY2TLbsjoRM2afW40594zv+aCu06lf+9KNykRT/+oUTjr1
	 GUwYvseSEW/FNfkARK+9cx153WdXr1n4b1obUFIhaZh97Md1AX1cvPeGq67qpO5DOfhr/
	 NLH94yQaWfx6FpwxpQAcqA3ktfUNcUZF7EQs8yEKIvIAv3kksJ3QXFpR7aH74ornA6dV3
	 8J6Zq6GY/5xCaV9X7zIMv4k3APEoXCRBfkS47bkh2m9W2y3qmtFYQOVRhqM17P6L67Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b="YzUZ/Q9d";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=aRTP0E2s;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06901606A326
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2026 00:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06901606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=YzUZ/Q9d;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=aRTP0E2s
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3D05814000CF
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 19:56:41 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 06 Nov 2026 19:56:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1794013001; x=1794099401; bh=moK8FoBrjf
	2gfaaRzRJOFALpzci8unBYEIKmVt+2NIY=; b=YzUZ/Q9dT5F2KFO6KcOdsrcyOG
	CFjDwCzwssX5V+8P6j03B7AuXiW2pixFuLPHtUksvMqnJ9KWK5NYuGKkG8Ir5Tzv
	uOpqXCLZzfFQqMdcJjPp1F7T/VEF4T1SroQEnGJEeAv+u3jZE8IFWXkqFFFrcAPe
	qAapWUqFuCFC5VBkDHZWEmHKS7oj+ig7+loGJGP/ML9MOkvwm8lhLGdXlIArBAtx
	QEYts2/X+tyVOqHaGsqaTQqtmZOD5Ca/qB62lehzmjqXrkUk1xdaZfzUebv9SPNu
	OH0yTCA0+ci19FzSLbu7nRGt0uz/+q7nBJNkYZ86TGY5uUzsTbtRG8HkvcOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794013001; x=1794099401; bh=moK8FoBrjf2gfaaRzRJOFALpzci8unBYEIK
	mVt+2NIY=; b=aRTP0E2s6Kf/7pbjtGd6FZjMHtpeXQtqWotnbtbWj+89F6F7EnG
	ZmiptmUmm7ZTmuS5UxmKd0eq3aHexXWaGfrmjKRJGhSn6cwLp4XiqFMmAlP1nfBV
	XmKC8cxddWEvvOvhG+mxCYSYKzxmI00A2c20X1xWZ0xZPdxUJD5GCGSuJzhuR6Z+
	jQoS9hzT8axcznwdnhTHpFUgZ8xzLlEpSoMti5+5YBUyu5szye2JjaAy9Ve2qgYz
	mb7uTwLxqbT/ankxrsvwhtoqoTaz21HA/utMFAcA39J5qzMy/OAVi6e6SAiKsCUv
	eYvq1VNDtg9uXOyrGLJoYmpzrdKhmb+cJsw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794013001; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:ZsYCvx75nPn9XGux92LEqRh3Ac8LEwO1c8HcwCRqoiUD436
	4wEDg2YMORntDYecBI1GFohkG2dGA0i7i4UQ+rxuehM2Fh4VW+SBm/jhOEV2y5ZM
	JV2ZlHt0P0ViB9UzbJ5Na1Gp+xHCpOWk/HIxRu5GoyAEvsacR4KcDABtZejbproP
	3SypbNIx3q563gxJP2sIZz5sJaF7J8sdJlLtlweHEbZrz5Ib8QSkdfC97ueeA+Mr
	pBkLgMqdo1+A5QEXaoDmJ31KIYMXMw4dljtH7IdjO52GFnnZ2jQMkJJZ/F8URz4e
	aK/FQlynN57Lj7IETOq/JEoC9IUBDjkF9QkWEgw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:cnayl03W5GFeW1h+B+te9AxIR0RKkYWzRoirpj+b898=:0CvWVRrHD+1u4MMjXg7QNxH6BM6dsnk1HGUYtTJrPxI=;
X-ME-Sender: <xms:SXfuagbMu6ZvrU6NDR_kN7yUKz1tvkpJuJIgWR-1NUyiLn-SJTXYkg>
    <xme:SXfuai06nbIyW64A_2YCrslHBYFgAvIMz5U_DbQA4YenKO68USDzZk4_5pa0jSwHs
    JPKlLWXTZcwZ-8pFa9k365vfUJm9mSzGfF7bdb-CHjgKzmgy0z0ru69>
X-ME-Received: <xmr:SXfuaoU7MCvPxVr2GPA9SUczENdrDwG7sT79YHFQPy2jpJ5x1LOO8MhW>
X-ME-Proxy-Cause: dmFkZTFiOjcnUhZTNOLXsS31w5mwj0103BfHrlWLo/FTUTYU3yf9hD56UyRZ4ee5SsRDKz
    OT9qvH0niot26sEgOiA+tLOV8J2nKlWcd6PFB44F5C/07q3Geyje7wgTNWxoX1QSHm/Gra
    eyXZegRM5s0JAUPIvfL8idUqa3kXzCcCCkdc/uR4payCKpfmUSE4P2VrodNLvcWO//EjU4
    dbEqiOIqXx7t9tjGWxLlv6sfzIKqz+7sahCjY8pIhJIqp/LzxQalzUZ6lJYsoVc+2U2Lpd
    852bCmbh0haGdUx88sWcNJ+hoOcLKXhqwJ37uD2byDuya3WEpXKFieoyBRHp8XW/WoauUH
    vVmsfPSszNrVzlQ1bxh70Gxnw8K7pSYJ9wI+NPSG3c03YT0kmSfcHtCT8Spi36086+zgEs
    wGGEB2m4yBHYYc3nmC/o3E3RqfDLT51VrFpLdwY9hAUfCY79PHRymKA8++glHr12tObbbX
    Swz1QVm6TcJGQPmRInJ0ccTLFdJ0giJnhHzf2iBOidLh2ufpWJHI4Zb+CPO7SbZKMAPfyz
    Xf2eE4jQmGfed01MqfI9UDQgL5cyvlghXeldxohqJ92VezxmFVWFhvXWWL3A0XYWCtMPqP
    xt2g0kQIfDBcVSUvZDg6bDHiT1ncY0Eo69wuGcx8l9wBr8Qf6GBRVJkznETg
X-ME-Proxy: <xmx:SXfuakVZadaOkvbaUEMd2-TBfPDnhIAnlkZq0HMwfg3SG2zgDW7gFA>
    <xmx:SXfuavd7DH315dwMcPwdra071--iGCMVab84MZ1FRfTngTt4YMlXXQ>
    <xmx:SXfualUz9vnxXVesNOoITe59l1Q1iRCDDoqfsRw1Q2Ugajo6uE4Z_A>
    <xmx:SXfuagdDIRYNc-HDWdrxSgVJXRB5_LyLK7b2jONh47kJdxR2askBTg>
    <xmx:SXfuahOjVGrS4JlX_R-V7gL5XN3kWnWx4BT7sEl0ESjbgrHVpT5Jd3Q4>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 19:56:40 -0500 (EST)
Date: Fri, 6 Nov 2026 16:56:55 -0800
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v6 17/25] btrfs: zoned: factor out resetting a block
 group in place
Message-ID: <20261107005655.GH401465@zen.localdomain>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
 <20261028182111.160492-18-johannes.thumshirn@wdc.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028182111.160492-18-johannes.thumshirn@wdc.com>

On Wed, Oct 28, 2026 at 07:21:03PM +0100, Johannes Thumshirn wrote:
> Move the code that resets the zones of an unused block group and returns
> its space to the space_info out of btrfs_reset_unused_block_groups() into
> a helper, so it can be reused.
> 
> No functional change.

Reviewed-by: Boris Burkov <boris@bur.io>
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 128 +++++++++++++++++++++++++----------------------
>  1 file changed, 68 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index ffb5b6663914..cec160d03806 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2915,6 +2915,72 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
>  	spin_unlock(&fs_info->relocation_bg_lock);
>  }
>  
> +static int zoned_reset_bg_in_place(struct btrfs_block_group *bg, u64 *reclaimed)
> +{
> +	struct btrfs_fs_info *fs_info = bg->fs_info;
> +	struct btrfs_space_info *space_info = bg->space_info;
> +	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
> +	struct btrfs_chunk_map *map;
> +
> +	*reclaimed = 0;
> +
> +	down_read(&fs_info->dev_replace.rwsem);
> +	map = bg->physical_map;
> +	for (int i = 0; i < map->num_stripes; i++) {
> +		struct btrfs_io_stripe *stripe = &map->stripes[i];
> +		unsigned int nofs_flags;
> +		int ret;
> +
> +		nofs_flags = memalloc_nofs_save();
> +		ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
> +				       stripe->physical >> SECTOR_SHIFT,
> +				       zone_size_sectors);
> +		memalloc_nofs_restore(nofs_flags);
> +
> +		if (ret) {
> +			up_read(&fs_info->dev_replace.rwsem);
> +			return ret;
> +		}
> +	}
> +	up_read(&fs_info->dev_replace.rwsem);
> +
> +	spin_lock(&space_info->lock);
> +	spin_lock(&bg->lock);
> +	ASSERT(!btrfs_is_block_group_used(bg));
> +	if (bg->ro) {
> +		spin_unlock(&bg->lock);
> +		spin_unlock(&space_info->lock);
> +		return 0;
> +	}
> +	*reclaimed = bg->alloc_offset;
> +	bg->zone_unusable = bg->length - bg->zone_capacity;
> +	bg->alloc_offset = 0;
> +	/*
> +	 * The zone was just reset to empty, so alloc_offset went back to
> +	 * the start of the zone. For metadata/system block groups the
> +	 * write pointer must follow it back to the start of the zone;
> +	 * otherwise it stays stale at the previous (finished) zone end,
> +	 * and metadata written into the reused zone would sit behind the
> +	 * write pointer, could never be written out in sequential order,
> +	 * and would be stranded (pinning its folio) until unmount.
> +	 */
> +	if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
> +		bg->meta_write_pointer = bg->start;
> +	/*
> +	 * This holds because we currently reset fully used then freed
> +	 * block group.
> +	 */
> +	ASSERT(*reclaimed == bg->zone_capacity,
> +	       "reclaimed=%llu bg->zone_capacity=%llu", *reclaimed, bg->zone_capacity);
> +	bg->free_space_ctl->free_space += *reclaimed;
> +	btrfs_space_info_update_bytes_zone_unusable(space_info, -*reclaimed);
> +	spin_unlock(&bg->lock);
> +	btrfs_return_free_space(space_info, *reclaimed);
> +	spin_unlock(&space_info->lock);
> +
> +	return 0;
> +}
> +
>  void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
>  {
>  	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
> @@ -3251,7 +3317,6 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
>  int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes)
>  {
>  	struct btrfs_fs_info *fs_info = space_info->fs_info;
> -	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
>  	LIST_HEAD(retry_list);
>  	int ret = 0;
>  
> @@ -3259,7 +3324,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
>  		return 0;
>  
>  	while (num_bytes > 0) {
> -		struct btrfs_chunk_map *map;
>  		struct btrfs_block_group *bg = NULL;
>  		bool found = false;
>  		u64 reclaimed = 0;
> @@ -3301,65 +3365,9 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
>  		list_del_init(&bg->bg_list);
>  		spin_unlock(&fs_info->unused_bgs_lock);
>  
> -		/*
> -		 * Since the block group is fully zone_unusable and we cannot
> -		 * allocate from this block group anymore, we don't need to set
> -		 * this block group read-only.
> -		 */
> -
> -		down_read(&fs_info->dev_replace.rwsem);
> -		map = bg->physical_map;
> -		for (int i = 0; i < map->num_stripes; i++) {
> -			struct btrfs_io_stripe *stripe = &map->stripes[i];
> -			unsigned int nofs_flags;
> -
> -			nofs_flags = memalloc_nofs_save();
> -			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
> -					       stripe->physical >> SECTOR_SHIFT,
> -					       zone_size_sectors);
> -			memalloc_nofs_restore(nofs_flags);
> -
> -			if (ret) {
> -				up_read(&fs_info->dev_replace.rwsem);
> -				goto requeue;
> -			}
> -		}
> -		up_read(&fs_info->dev_replace.rwsem);
> -
> -		spin_lock(&space_info->lock);
> -		spin_lock(&bg->lock);
> -		ASSERT(!btrfs_is_block_group_used(bg));
> -		if (bg->ro) {
> -			spin_unlock(&bg->lock);
> -			spin_unlock(&space_info->lock);
> +		ret = zoned_reset_bg_in_place(bg, &reclaimed);
> +		if (ret || !reclaimed)
>  			goto requeue;
> -		}
> -
> -		reclaimed = bg->alloc_offset;
> -		bg->zone_unusable = bg->length - bg->zone_capacity;
> -		bg->alloc_offset = 0;
> -		/*
> -		 * The zone was just reset to empty, so alloc_offset went back to
> -		 * the start of the zone. For metadata/system block groups the
> -		 * write pointer must follow it back to the start of the zone;
> -		 * otherwise it stays stale at the previous (finished) zone end,
> -		 * and metadata written into the reused zone would sit behind the
> -		 * write pointer, could never be written out in sequential order,
> -		 * and would be stranded (pinning its folio) until unmount.
> -		 */
> -		if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM))
> -			bg->meta_write_pointer = bg->start;
> -		/*
> -		 * This holds because we currently reset fully used then freed
> -		 * block group.
> -		 */
> -		ASSERT(reclaimed == bg->zone_capacity,
> -		       "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
> -		bg->free_space_ctl->free_space += reclaimed;
> -		btrfs_space_info_update_bytes_zone_unusable(space_info, -reclaimed);
> -		spin_unlock(&bg->lock);
> -		btrfs_return_free_space(space_info, reclaimed);
> -		spin_unlock(&space_info->lock);
>  
>  		btrfs_put_block_group(bg);
>  
> -- 
> 2.56.0
> 
