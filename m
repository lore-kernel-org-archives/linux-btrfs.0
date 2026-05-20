Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEF338331F
	for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 21:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779313096; cv=none; b=OyxLSOn+TnqrRQEzBmo1lq/XedRUfuZztUNV4VIkEy3TJf2WcdpazcldnQ73gHolBp/61+3wfrieVrtnsM7JxCutot25koT7vuIC3kwQDKYUq++dZMc+/IcS6y8nrskVz6Jta+PMus32O8VEnZTkOZiulGkkrXFd8JVILRvutDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779313096; c=relaxed/simple;
	bh=lACuKlT3T2+9SNuDsf6hWbAt4A+uNEOZFeOptbRX8BQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZa08Bm1qD7luOxDMSzTSk3PfkmSL4bh1KkjuSSNPUP3h5qJT7fOgsEkoP4wsMKL6OKJ6EVS4grPh/MMA/CezG17RjILkYSBvcQflHdriJoDFkE9M21+ljLSTKMLPFk2wPRzOjr5U8qEutnppThqV4Df/qeApYo/VCCae8zLrqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Gjgbb8lM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FFRbLaA2; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Gjgbb8lM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FFRbLaA2"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 15FC7EC01D7;
	Wed, 20 May 2026 17:38:14 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 20 May 2026 17:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779313094; x=1779399494; bh=OBvK0kBtVg
	Q0fqoQa0EUcadbeI0/XBn44RIGb8Xe4dE=; b=Gjgbb8lMDj8yZtVeWX53z86E4p
	R/Ml8TkQd7oBUtaS3e4TmhL9UQIAPCCLSKbK+8jB4DsjA7N5K6qSC8pEZxtYOLZM
	rMHm+DQd7ASyvg1CCubgDy9K9kxHomo7iqN5ncv+nhyu0YzKLn5pWGPbo/mzicc3
	9NjnTnpLt1ietWi3JTQ8kPvtc6JYBl36WiA82z9HvVJTHM9jJBR7jVk3/55MDj2S
	RoXIl0OaKrV2Zxs4JMl5ke8t/MbgZxhT6AGoLo23vDB745deFeR5fdEu1lUo7Nco
	ihP8H3z5lO5UrAcUwhWpJtMVs9BzJZl5oyM+rnUEvWZs1P75sM8+fOCk77Tg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779313094; x=1779399494; bh=OBvK0kBtVgQ0fqoQa0EUcadbeI0/XBn44RI
	Gb8Xe4dE=; b=FFRbLaA2husm0XcCT/VVNzOK27auf9pLPQeQya8ac6ni5C1ePml
	SLS1La0L+DFoTNOM5s7Gz/2H+4PwpmeattyPqCp3m1bm/z6CIPZkdiDjuGqhh1HB
	8q+gT5RVWqLRUidnLFI5wdSA1Y/5x8iiZtwJIXZidjbuxjmIg90rzu236+Ry9hXD
	npy7r3rU5MqiNksRhcuGIAgozThLTLeweXcxGssxu0iepp4A/uKacdSfEgD39DIn
	ngX+7yrCyIfL1GmpExMcVRMU0txQBHcmX588jABRViPb2rd65jgW/Sj3f48ThdIA
	xdza2vJLEZa7sOrlGs640VOvzwALFSO9tZA==
X-ME-Sender: <xms:xSkOaos3Pai2jiO5bK3OmKGdwm2DRjjhoy6R4WVovy9R5TczF5i23Q>
    <xme:xSkOarcnrzgVegyZilC9Ouexj3irzyX6rWGxSx5EsGy-WuNj49sKe_hu3cl8gcrRt
    oapKKWuDv3z8y9ld7ItE5mLkD2Gyt9eDQCnWbNIPdNH0ON_PvTFZAlE>
X-ME-Received: <xmr:xSkOahZJPwOyl_wnQySYyl6dPqRU5Cti_KyVUxzUDAEQ381FiWfyN0z9Fn5b5R2pDMnLWVQ9sfnJvL9k3UE3l2gTGSI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeehjeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeekvd
    ekffejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepfihquhesshhushgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvh
    hgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:xSkOamUrvtnAYTvvuRB-8fzyf0VaBmLJWOOBhS5XwB7Llwmp1Nalkw>
    <xmx:xSkOari11xHs_hEaPALHxRbFen_nzpxjcHF4clBtUkc07CXgJU8-sA>
    <xmx:xSkOasWaUxkTKqwfIGHTO8-Za8FujKAPaYRokicbMi4dN9kPRTSd-Q>
    <xmx:xSkOaqOW1kQiv5McMgHqWrB47nEWarJNLVZw75YWBtcNX72uDHSkwQ>
    <xmx:xikOasZhXqWvFx31WVhIuIXRFbwkHpl3xJ81vriUfAU-zJdI8S_NgAB5>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 20 May 2026 17:38:13 -0400 (EDT)
Date: Wed, 20 May 2026 14:38:11 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/6] btrfs: add skeleton for delayed btrfs bio
Message-ID: <20260520213811.GA1479855@zen.localdomain>
References: <cover.1778902677.git.wqu@suse.com>
 <d8b91a2081c898c548545c8b7c0aff6f463766c4.1778902677.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8b91a2081c898c548545c8b7c0aff6f463766c4.1778902677.git.wqu@suse.com>

On Sat, May 16, 2026 at 01:15:14PM +0930, Qu Wenruo wrote:
> The objective of such new delayed btrfs bio infrastructure is to allow
> compressed write to go the regular extent_writepage_io() path, without
> going through the async submission path.
> 
> This will make it easier to align our write path to iomap.
> 
> The core ideas of delayed btrfs bio are:
> 
> - A placeholder ordered extent created at delalloc time
>   No space is reserved at that time, and is not implemented in this
>   patch.
> 
> - A delayed extent map created at delalloc time
>   It will have a special disk_bytenr (-4) to indicate the range is
>   delayed.
>   And a new EXTENT_FLAG_DELAYED flag.
> 

What is the protection for current callers of btrfs_get_extent() which
use em->disk_bytenr? Many of them have specific logic for hole/inline
em, are we sure none of them need to handle em->disk_bytenr == EXTENT_MAP_DELAYED ?

> - Delayed btrfs bios will be limited to BTRFS_MAX_COMPRESSED size
>   As only compression will go through delayed btrfs bio.
> 
> - Delayed btrfs bios will have @is_delayed flag set
>   And such bio will have 0 as bi_sector, but will never be submitted
>   directly through btrfs_submit_bio().

What is the purpose of using a false bbio as an async placeholder?

Is it to allow keeping the "submission" code the same, though it is sort
of a no-op submission?

Put a different way, is this for convenience because real and delayed
bio submission share a bunch of delayed-agnostic folio logic, or is it
important for some kind of bbio to exist at the end of the writeback
pass?

> 
>   Currently the submission of a delayed btrfs bio is not here yet, and
>   will be implemented by later patches.
> 
> - Btrfs bio assembly mostly follows the regular path
>   There are several small exceptions:
>   * btrfs_bio_is_contig() needs to handle delayed disk_bytenr/bbio
>   * New bbio needs to have its is_delayed flag set if disk_bytenr
>     is EXTENT_MAP_DELAYED
> 
> - Real ordered extents will be created at bbio submission time
>   This part is not implemented in this patch.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/bio.c         |  1 +
>  fs/btrfs/bio.h         |  3 +++
>  fs/btrfs/btrfs_inode.h |  3 +++
>  fs/btrfs/extent_io.c   | 29 ++++++++++++++++++++++++----
>  fs/btrfs/extent_map.h  |  9 ++++++++-
>  fs/btrfs/inode.c       | 43 +++++++++++++++++++++++++++++++++++++++++-
>  6 files changed, 82 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index cc0bd03048ba..1d418226ded9 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -908,6 +908,7 @@ void btrfs_submit_bbio(struct btrfs_bio *bbio, int mirror_num)
>  {
>  	/* If bbio->inode is not populated, its file_offset must be 0. */
>  	ASSERT(bbio->inode || bbio->file_offset == 0);
> +	ASSERT(!bbio->is_delayed);
>  
>  	assert_bbio_alignment(bbio);
>  
> diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
> index 303ed6c7103d..49ebdc7ce6e6 100644
> --- a/fs/btrfs/bio.h
> +++ b/fs/btrfs/bio.h
> @@ -99,6 +99,9 @@ struct btrfs_bio {
>  	/* Whether the bio is written using zone append. */
>  	bool can_use_append:1;
>  
> +	/* If the bio is delayed (aka, no backing OE). */
> +	bool is_delayed:1;
> +
>  	/*
>  	 * This member must come last, bio_alloc_bioset will allocate enough
>  	 * bytes for entire btrfs_bio but relies on bio being last.
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index d5d81f9546c3..49ac6164f122 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -636,5 +636,8 @@ u64 btrfs_get_extent_allocation_hint(struct btrfs_inode *inode, u64 start,
>  struct extent_map *btrfs_create_io_em(struct btrfs_inode *inode, u64 start,
>  				      const struct btrfs_file_extent *file_extent,
>  				      int type);
> +struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
> +					   u64 start, u32 length);
> +void btrfs_submit_delayed_write(struct btrfs_bio *bbio);
>  
>  #endif
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8cf1e4c5105f..7adf8e80ba36 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -181,12 +181,16 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
>  
>  	/* Caller should ensure the bio has at least some range added */
>  	ASSERT(bbio->bio.bi_iter.bi_size);
> -
> +	/* Delayed bbio is only for write. */
> +	if (bbio->is_delayed)
> +		ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
>  	bio_set_csum_search_commit_root(bio_ctrl);
>  
>  	if (btrfs_op(&bbio->bio) == BTRFS_MAP_READ &&
>  	    bio_ctrl->compress_type != BTRFS_COMPRESS_NONE)
>  		btrfs_submit_compressed_read(bbio);
> +	else if (bbio->is_delayed)
> +		btrfs_submit_delayed_write(bbio);
>  	else
>  		btrfs_submit_bbio(bbio, 0);
>  
> @@ -709,6 +713,14 @@ static bool btrfs_bio_is_contig(struct btrfs_bio_ctrl *bio_ctrl,
>  	struct bio *bio = &bio_ctrl->bbio->bio;
>  	const sector_t sector = disk_bytenr >> SECTOR_SHIFT;
>  
> +	/* One is delayed bbio and one is not, definitely not contig. */
> +	if (bio_ctrl->bbio->is_delayed != (disk_bytenr == EXTENT_MAP_DELAYED))
> +		return false;
> +
> +	/* For delayed bbio, only need to check if the file range is contig. */
> +	if (bio_ctrl->bbio->is_delayed)
> +		return bio_ctrl->next_file_offset == file_offset;
> +
>  	if (bio_ctrl->compress_type != BTRFS_COMPRESS_NONE) {
>  		/*
>  		 * For compression, all IO should have its logical bytenr set
> @@ -734,7 +746,13 @@ static int alloc_new_bio(struct btrfs_inode *inode,
>  
>  	bbio = btrfs_bio_alloc(BIO_MAX_VECS, bio_ctrl->opf, inode,
>  			       file_offset, bio_ctrl->end_io_func, NULL);
> -	bbio->bio.bi_iter.bi_sector = disk_bytenr >> SECTOR_SHIFT;
> +	if (disk_bytenr == EXTENT_MAP_DELAYED) {
> +		bbio->is_delayed = true;
> +		bbio->bio.bi_iter.bi_sector = 0;
> +	} else {
> +		bbio->is_delayed = false;
> +		bbio->bio.bi_iter.bi_sector = disk_bytenr >> SECTOR_SHIFT;
> +	}
>  	bbio->bio.bi_write_hint = inode->vfs_inode.i_write_hint;
>  	bio_ctrl->bbio = bbio;
>  	bio_ctrl->len_to_oe_boundary = U32_MAX;
> @@ -761,7 +779,7 @@ static int alloc_new_bio(struct btrfs_inode *inode,
>  		}
>  		bio_ctrl->len_to_oe_boundary = min_t(u32, U32_MAX,
>  				ordered->file_offset +
> -				ordered->disk_num_bytes - file_offset);
> +				ordered->num_bytes - file_offset);
>  		bbio->ordered = ordered;
>  
>  		/*
> @@ -1722,7 +1740,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
>  	ASSERT(IS_ALIGNED(em->len, sectorsize));
>  
>  	block_start = btrfs_extent_map_block_start(em);
> -	disk_bytenr = btrfs_extent_map_block_start(em) + extent_offset;
> +	if (block_start == EXTENT_MAP_DELAYED)
> +		disk_bytenr = block_start;
> +	else
> +		disk_bytenr = block_start + extent_offset;
>  
>  	ASSERT(!btrfs_extent_map_is_compressed(em));
>  	ASSERT(block_start != EXTENT_MAP_HOLE);
> diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
> index 6f685f3c9327..2342f2a9a333 100644
> --- a/fs/btrfs/extent_map.h
> +++ b/fs/btrfs/extent_map.h
> @@ -13,7 +13,8 @@
>  struct btrfs_inode;
>  struct btrfs_fs_info;
>  
> -#define EXTENT_MAP_LAST_BYTE ((u64)-4)
> +#define EXTENT_MAP_LAST_BYTE ((u64)-5)
> +#define EXTENT_MAP_DELAYED ((u64)-4)
>  #define EXTENT_MAP_HOLE ((u64)-3)
>  #define EXTENT_MAP_INLINE ((u64)-2)
>  
> @@ -30,6 +31,12 @@ enum {
>  	ENUM_BIT(EXTENT_FLAG_LOGGING),
>  	/* This em is merged from two or more physically adjacent ems */
>  	ENUM_BIT(EXTENT_FLAG_MERGED),
> +	/*
> +	 * This real on-disk extent allocation is delayed until bio submission.
> +	 * For now it's only a placeholder with EXTENT_MAP_DELAYED as
> +	 * its disk_bytenr.
> +	 */
> +	ENUM_BIT(EXTENT_FLAG_DELAYED),
>  };
>  
>  /*
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 973a89301baa..4b85ba6ddf48 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7406,10 +7406,51 @@ struct extent_map *btrfs_create_io_em(struct btrfs_inode *inode, u64 start,
>  		return ERR_PTR(ret);
>  	}
>  
> -	/* em got 2 refs now, callers needs to do btrfs_free_extent_map once. */
> +	/* em got 2 refs now, callers need to do btrfs_free_extent_map once. */
>  	return em;
>  }
>  
> +struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
> +					   u64 start, u32 length)
> +{
> +	struct extent_map *em;
> +	int ret;
> +
> +	em = btrfs_alloc_extent_map();
> +	if (!em)
> +		return ERR_PTR(-ENOMEM);
> +
> +	em->start = start;
> +	em->len = length;
> +	em->disk_bytenr = EXTENT_MAP_DELAYED;
> +	em->disk_num_bytes = 0;
> +	em->ram_bytes = 0;
> +	em->generation = -1;
> +	em->offset = 0;
> +	em->flags = EXTENT_FLAG_DELAYED | EXTENT_FLAG_PINNED;
> +
> +	ret = btrfs_replace_extent_map_range(inode, em, true);
> +	if (ret) {
> +		btrfs_free_extent_map(em);
> +		return ERR_PTR(ret);
> +	}
> +
> +	/* em got 2 refs now, callers need to do btrfs_free_extent_map once. */
> +	return em;
> +}
> +
> +void btrfs_submit_delayed_write(struct btrfs_bio *bbio)
> +{
> +	ASSERT(bbio->is_delayed);
> +
> +	/*
> +	 * Not yet implemented, and should not hit this path as we have no
> +	 * caller to create delayed extent map.
> +	 */
> +	ASSERT(0);
> +	bio_put(&bbio->bio);
> +}
> +
>  /*
>   * For release_folio() and invalidate_folio() we have a race window where
>   * folio_end_writeback() is called but the subpage spinlock is not yet released.
> -- 
> 2.54.0
> 
