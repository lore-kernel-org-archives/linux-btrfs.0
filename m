Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272CA3A3836
	for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 22:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779314428; cv=none; b=RI/lIK5fcuLP7E5plkt2LfEbsYAL3U1Fliv3W68opiW3aod6glI/rwCMIpRISeDA8ZeqSh//UEh4mEnVgNozLvzzKzqbTOyGw0rmSH2DKGuYiOI5ukwYQaIswcGRFlbiVvo+/KUwhGbTpCIcLifD3lpClz5/SnGMbzawbmsBm6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779314428; c=relaxed/simple;
	bh=WyIACWifGlJ80sMN1fzd1iwA8xgXu0FNdLlCaxyPvBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OdF5K12MiSNAM95IrH+GFEM0akVHWRbeE1emVraq/BKD2dJgQ8gjjBpGErglWTQsN3hjr6nZnq2F0RsjdnDUPTcAD/tKdlBH/YaDiOydF5M60x0IJptgXNwKd98u0v6vlHMDfiJdRYpQUVu9Dxbqntb2yq941crlKOpCNo+CeUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=bqvicOpg; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=X8uJQ2xC; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="bqvicOpg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="X8uJQ2xC"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id CD664EC00F2;
	Wed, 20 May 2026 18:00:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 20 May 2026 18:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779314422; x=1779400822; bh=A/9KqnopUA
	ImCW/FsnlSgW0Ioe+eNp+NojMzw0xs0Pg=; b=bqvicOpg4qzaC81agYOnhGTtTw
	RvvWNAMKudikthbCpCU/dBQWZ1qqBUk9Xwvavsy2xQ0IJCpBjmFVRtLARzCyVHqk
	rRSA4+Y4PFX2Id1q2B1mD3uNxW5BO+ldcnSXtRX9dRReAPVA8Abx/o6vI2XQYUtH
	i9NIY1xyxlYM8tzXfvLDXzT4WOSM+8p3jJYlHMA2FnDXjbYeXx6MmY9GgXsLtwwC
	/24shKhkqpLGVx3vKCVBCu2vLVVFkhF9xXFrB5TKHwIn4CkA+CPvpq5EC0RjM79L
	dMEhAkgv6k9f9D6Tbfa8Wx9a7Bb2PERaZ5X5dHH/0+B4kVHy6xeSv1xKnO2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779314422; x=1779400822; bh=A/9KqnopUAImCW/FsnlSgW0Ioe+eNp+NojM
	zw0xs0Pg=; b=X8uJQ2xC1+DbgZYxryMyJMcS8cPoGtU/By0hWbuL+bms77NkHGB
	WKpftrX35FK+KtszqJ3xps4i9DQoAmDIYSNISvJwvtmfYGfss6laLJnL0DNDsv6n
	zJ6scxrb+S4qhQc2PupaKShA2154U5O87esRwA6ri+jHtvw1WP6Art/LicWfR7+k
	4V/596JyL/jxPdSjBtp8glj2KrV6VxpLPfmhlBHE/0902Ph+v+sAAz9A7rJyvEaB
	dQvkmPK1mURPBVoBJlhq3oIJcgS4jiAZm96PEIaecs5bdDk3rdj8miKLZ0Q75tMs
	koPRtdRn9HM9BftKbHcA4mThgXzg1WokMxg==
X-ME-Sender: <xms:9i4OaiB8NefOoQO-VBXtf37thpj3qm2ktyneYT7Hgjc6qUKD017i7w>
    <xme:9i4Oaig5XoXpID5Kfs9hMbR0GSRrmGKOHuqDG_PGh5Sm7uzubQvwmYPjQkSLq1oKp
    tH0_Fk_noHAAdx-bvMvNpsbtxiEsGHK9q0X9om8D6FEJR7MFpWpGTg>
X-ME-Received: <xmr:9i4OajM8oQU86HhXOJvYXX_KLgvMUs68dphOqiuvoynvMEyub7Lhmmf4xAh5O3IuijaVBtdApQGSVBh6NuTxMIYOqWk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeehjeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeekvd
    ekffejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepfihquhesshhushgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvh
    hgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:9i4Oar68miLFDvzo70kULcMkTFL8-pDXuD9IQgXh22znibRI4sfI1w>
    <xmx:9i4Oap2OY253BvUzHnHUJ7WrnXcn5sR64XfnG62aEMwxE17fxyT8DA>
    <xmx:9i4Oakay2K4_3_y1r2sYipiojuIja0BFHJVANsWIQNkzorlOA2Crsw>
    <xmx:9i4OapB-iwrke_9RFrUm1oM0J4euhuHsqjcZ7SiM5PaYLWdhJ8mRmw>
    <xmx:9i4OasOknM7WFOBHZV0UMRD8hl38AoWCIyaiPbZ0smL-Fyv-g4JFjOTK>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 20 May 2026 18:00:22 -0400 (EDT)
Date: Wed, 20 May 2026 15:00:20 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/6] btrfs: add delayed ordered extent support
Message-ID: <20260520220020.GB1479855@zen.localdomain>
References: <cover.1778902677.git.wqu@suse.com>
 <82ca7628a7a96eb8cde8c1a53f7db544fa2f6ef5.1778902677.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82ca7628a7a96eb8cde8c1a53f7db544fa2f6ef5.1778902677.git.wqu@suse.com>

On Sat, May 16, 2026 at 01:15:15PM +0930, Qu Wenruo wrote:
> A delayed ordered extent has the following features:
> 
> - A new BTRFS_ORDERED_DELAYED flag
>   And this new flag must be set along with the BTRFS_ORDERED_REGULAR flag.
> 
> - No allocation of any on-disk space
>   As a delayed ordered extent doesn't take any on-disk space yet, it
>   won't release any reserved data/meta space either.
> 
> - Zero or more real OEs can be added to the parent
>   If a real OE is allocated, it must be inside the parent OE.
>   And such real OE will go through the regular data/meta space
>   reservation path.
> 
> - Children OEs will not be added to the per-inode OE rb-tree nor
>   per-root list
>   Only the parent OE is added to the per-inode rb-tree and per-root
>   list.
>   So anything waiting for ordered extents should only work on the parent
>   one.
> 
>   There is a special corner case to btrfs_wait_ordered_extents(), as
>   delayed parent OEs have 0 disk_bytenr and disk_num_bytes, they will
>   be considered out of the [0, U64_MAX] range.
>   Thus we have to always wait for any delayed OEs of a root, no matter
>   if a block group range is given or not.
> 
> - When the parent OE finishes, all children OEs will also be finished
>   And reserved space handling is all handled by the children OEs.
> 
> - Any range not covered by child OE will be manually cleaned up
> 
> Above features allow us to use the existing ordered extent interfaces
> to allocate new real OEs, and wait for them properly.

I am getting comfortable with the idea of the nested OEs, and thanks for
seriously investigating the question of splitting. Sorry if I
underestimated the difficulty while asking about it before.

Reading this all again gave me another idea that may possibly help with
making things as clear and simple as possible.

I'll blab a bit to set the idea up :)

So a classic OE represents a range of a file that is under IO (just
about 1:1 with bio submitted, finished on bio done)

This new delayed OE lacks the submitted IO (or even space alloc), but
is composed of "real" OEs which are not in the rb-tree. This means the
old finish_one_ordered code can just run on the children and the only
weird part is that deleting the rb_node is a no-op. But the outer one
looks enough like an OE that everyone who looks for an OE finds one and
can treat the delayed one transparently by trying to force it written
or wait for it.

What if instead of having both of these be kinds of OEs, we just split
up the concepts? One is a range of a file which can have one or more OEs
in it and lives in the rb-tree. The other is the classic OE and
represents the I/O, finishing it places the extents, csums, delayed
refs, etc.. Another way of framing this idea is why not have all IOs use
a parent OE with a single child covering the whole range? That way you
always have a parent/child and don't have as much code that has to treat
them transparently. When you look up in the rbtree you always expect a
parent. 

This is of course a wider change (all ordered extent users suddenly care)
so it affects more code. However by not hiding the problem on a flag on
the OE, the OE functions don't have to be a mess of "if parent X else Y"
style logic. If the users of OEs use a narrow interface anyway
(presumably mostly just starting, waiting, cancelling), they don't care
too much which exact object they do that to.

Thanks,
Boris

> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/inode.c        |  76 +++++++++++++++++
>  fs/btrfs/ordered-data.c | 178 ++++++++++++++++++++++++++++++----------
>  fs/btrfs/ordered-data.h |  14 ++++
>  3 files changed, 224 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4b85ba6ddf48..6c4fbd0d4845 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3002,6 +3002,79 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
>  					   update_inode_bytes, oe->qgroup_rsv);
>  }
>  
> +static int finish_delayed_ordered(struct btrfs_ordered_extent *oe)
> +{
> +	struct btrfs_inode *inode = oe->inode;
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct btrfs_ordered_extent *child;
> +	struct btrfs_ordered_extent *tmp;
> +	struct extent_state *cached = NULL;
> +	const u32 nr_bits = oe->num_bytes >> fs_info->sectorsize_bits;
> +	bool io_error = test_bit(BTRFS_ORDERED_IOERR, &oe->flags);
> +	u64 cur = oe->file_offset;
> +	int ret = 0;
> +	int saved_ret = 0;
> +
> +	/* Finish each child OE. */
> +	list_for_each_entry_safe(child, tmp, &oe->child_list, child_list) {
> +		list_del_init(&child->child_list);
> +		refcount_inc(&child->refs);
> +
> +		/* The range should have been marked in the bitmap. */
> +		ASSERT(bitmap_test_range_all_set(oe->child_bitmap,
> +			(child->file_offset - oe->file_offset) >> fs_info->sectorsize_bits,
> +			child->num_bytes >> fs_info->sectorsize_bits));
> +
> +		if (io_error)
> +			set_bit(BTRFS_ORDERED_IOERR, &child->flags);
> +
> +		ret = btrfs_finish_one_ordered(child);
> +		if (ret && !saved_ret)
> +			saved_ret = ret;
> +	}
> +
> +	/* For ranges that don't have a child OE, manually clean them up. */
> +	while (cur < oe->file_offset + oe->num_bytes) {
> +		const u32 cur_bit = (cur - oe->file_offset) >> fs_info->sectorsize_bits;
> +		u32 first_zero;
> +		u32 next_set;
> +		u64 range_start;
> +		u64 range_end;
> +		u32 range_len;
> +
> +		first_zero = find_next_zero_bit(oe->child_bitmap, nr_bits, cur_bit);
> +		if (first_zero >= nr_bits)
> +			break;
> +		next_set = find_next_bit(oe->child_bitmap, nr_bits, first_zero);
> +		ASSERT(next_set > first_zero);
> +
> +		range_start = oe->file_offset + (first_zero << fs_info->sectorsize_bits);
> +		range_len = (next_set - first_zero) << fs_info->sectorsize_bits;
> +		range_end = range_start + range_len - 1;
> +
> +		btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cached);
> +		/*
> +		 * The range has reserved data/metadata but no real OE, thus we have
> +		 * to manually release them.
> +		 */
> +		btrfs_delalloc_release_space(inode, NULL, range_start, range_len, true);
> +		/*
> +		 * Also need to remove/drop the pinned extent map range.
> +		 * Here we do not want the extent map to stay, as they do not represent
> +		 * any real extent map.
> +		 */
> +		btrfs_drop_extent_map_range(inode, range_start, range_end, false);
> +		btrfs_clear_extent_bit(&inode->io_tree, range_start, range_end,
> +				EXTENT_LOCKED | EXTENT_DELALLOC_NEW | EXTENT_DEFRAG |
> +				EXTENT_DO_ACCOUNTING, &cached);
> +		cur = range_end + 1;
> +	}
> +	btrfs_remove_ordered_extent(oe);
> +	btrfs_put_ordered_extent(oe);
> +	btrfs_put_ordered_extent(oe);
> +	return saved_ret;
> +}
> +
>  /*
>   * As ordered data IO finishes, this gets called so we can finish
>   * an ordered extent if the range of bytes in the file it covers are
> @@ -3024,6 +3097,9 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
>  	bool clear_reserved_extent = true;
>  	unsigned int clear_bits = 0;
>  
> +	if (test_bit(BTRFS_ORDERED_DELAYED, &ordered_extent->flags))
> +		return finish_delayed_ordered(ordered_extent);
> +
>  	start = ordered_extent->file_offset;
>  	end = start + ordered_extent->num_bytes - 1;
>  
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index f5f77c33cf59..691dee5334ea 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -155,6 +155,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
>  	u64 qgroup_rsv = 0;
>  	const bool is_nocow = (flags &
>  	       ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)));
> +	const bool is_delayed = test_bit(BTRFS_ORDERED_DELAYED, &flags);
>  
>  	/* Only one type flag can be set. */
>  	ASSERT(has_single_bit_set(flags & BTRFS_ORDERED_EXCLUSIVE_FLAGS),
> @@ -170,6 +171,17 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
>  	if (test_bit(BTRFS_ORDERED_ENCODED, &flags))
>  		ASSERT(test_bit(BTRFS_ORDERED_COMPRESSED, &flags));
>  
> +	/*
> +	 * DELAYED can only be set with REGULAR, no DIRECT/ENCODED, and should
> +	 * not exceed BTRFS_MAX_COMPRESSED size.
> +	 */
> +	if (test_bit(BTRFS_ORDERED_DELAYED, &flags)) {
> +		ASSERT(test_bit(BTRFS_ORDERED_REGULAR, &flags));
> +		ASSERT(!test_bit(BTRFS_ORDERED_DIRECT, &flags));
> +		ASSERT(!test_bit(BTRFS_ORDERED_ENCODED, &flags));
> +		ASSERT(num_bytes <= BTRFS_MAX_COMPRESSED);
> +	}
> +
>  	/*
>  	 * For a NOCOW write we can free the qgroup reserve right now. For a COW
>  	 * one we transfer the reserved space from the inode's iotree into the
> @@ -178,13 +190,16 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
>  	 * completing the ordered extent, when running the data delayed ref it
>  	 * creates, we free the reserved data with btrfs_qgroup_free_refroot().
>  	 */
> -	if (is_nocow)
> -		ret = btrfs_qgroup_free_data(inode, NULL, file_offset, num_bytes, &qgroup_rsv);
> -	else
> -		ret = btrfs_qgroup_release_data(inode, file_offset, num_bytes, &qgroup_rsv);
> -
> -	if (ret < 0)
> -		return ERR_PTR(ret);
> +	if (!is_delayed) {
> +		if (is_nocow)
> +			ret = btrfs_qgroup_free_data(inode, NULL, file_offset,
> +						     num_bytes, &qgroup_rsv);
> +		else
> +			ret = btrfs_qgroup_release_data(inode, file_offset,
> +							num_bytes, &qgroup_rsv);
> +		if (ret < 0)
> +			return ERR_PTR(ret);
> +	}
>  
>  	entry = kmem_cache_zalloc(btrfs_ordered_extent_cache, GFP_NOFS);
>  	if (!entry) {
> @@ -216,19 +231,23 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
>  	INIT_LIST_HEAD(&entry->root_extent_list);
>  	INIT_LIST_HEAD(&entry->work_list);
>  	INIT_LIST_HEAD(&entry->bioc_list);
> +	INIT_LIST_HEAD(&entry->child_list);
>  	init_completion(&entry->completion);
> +	RB_CLEAR_NODE(&entry->rb_node);
>  
>  	/*
>  	 * We don't need the count_max_extents here, we can assume that all of
>  	 * that work has been done at higher layers, so this is truly the
>  	 * smallest the extent is going to get.
>  	 */
> -	spin_lock(&inode->lock);
> -	btrfs_mod_outstanding_extents(inode, 1);
> -	spin_unlock(&inode->lock);
> +	if (!is_delayed) {
> +		spin_lock(&inode->lock);
> +		btrfs_mod_outstanding_extents(inode, 1);
> +		spin_unlock(&inode->lock);
> +	}
>  
>  out:
> -	if (IS_ERR(entry) && !is_nocow)
> +	if (IS_ERR(entry) && !is_nocow && !is_delayed)
>  		btrfs_qgroup_free_refroot(inode->root->fs_info,
>  					  btrfs_root_id(inode->root),
>  					  qgroup_rsv, BTRFS_QGROUP_RSV_DATA);
> @@ -236,12 +255,43 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
>  	return entry;
>  }
>  
> +static void add_child_oe(struct btrfs_ordered_extent *parent,
> +			 struct btrfs_ordered_extent *child)
> +{
> +	struct btrfs_inode *inode = parent->inode;
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	const u32 start_bit = (child->file_offset - parent->file_offset) >>
> +			      fs_info->sectorsize_bits;
> +	const u32 nr_bits = child->num_bytes >> fs_info->sectorsize_bits;
> +
> +	lockdep_assert_held(&inode->ordered_tree_lock);
> +	/* Basic flags check for parent and child. */
> +	ASSERT(test_bit(BTRFS_ORDERED_DELAYED, &parent->flags));
> +	ASSERT(!test_bit(BTRFS_ORDERED_DELAYED, &child->flags));
> +
> +	/* Child should not belong to any parent yet. */
> +	ASSERT(list_empty(&child->child_list));
> +
> +	/* Child should be fully inside parent's range. */
> +	ASSERT(child->file_offset >= parent->file_offset);
> +	ASSERT(child->file_offset + child->num_bytes <=
> +	       parent->file_offset + parent->num_bytes);
> +
> +	/* There should be no existing child in the range. */
> +	ASSERT(bitmap_test_range_all_zero(parent->child_bitmap, start_bit, nr_bits));
> +
> +	list_add_tail(&child->child_list, &parent->child_list);
> +
> +	bitmap_set(parent->child_bitmap, start_bit, nr_bits);
> +}
> +
>  static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
>  {
>  	struct btrfs_inode *inode = entry->inode;
>  	struct btrfs_root *root = inode->root;
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	struct rb_node *node;
> +	bool is_child = false;
>  
>  	trace_btrfs_ordered_extent_add(inode, entry);
>  
> @@ -254,17 +304,25 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
>  	spin_lock(&inode->ordered_tree_lock);
>  	node = tree_insert(&inode->ordered_tree, entry->file_offset,
>  			   &entry->rb_node);
> -	if (unlikely(node)) {
> +	if (node) {
>  		struct btrfs_ordered_extent *exist =
>  			rb_entry(node, struct btrfs_ordered_extent, rb_node);
>  
> -		btrfs_panic(fs_info, -EEXIST,
> +		if (test_bit(BTRFS_ORDERED_DELAYED, &exist->flags)) {
> +			add_child_oe(exist, entry);
> +			is_child = true;
> +		} else {
> +			btrfs_panic(fs_info, -EEXIST,
>  "overlapping ordered extents, existing oe file_offset %llu num_bytes %llu flags 0x%lx, new oe file_offset %llu num_bytes %llu flags 0x%lx",
>  			    exist->file_offset, exist->num_bytes, exist->flags,
>  			    entry->file_offset, entry->num_bytes, entry->flags);
> +		}
>  	}
>  	spin_unlock(&inode->ordered_tree_lock);
>  
> +	/* Child OE shouldn't be added to per-root oe list. */
> +	if (is_child)
> +		return;
>  	spin_lock(&root->ordered_extent_lock);
>  	list_add_tail(&entry->root_extent_list,
>  		      &root->ordered_extents);
> @@ -337,6 +395,20 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
>  	return entry;
>  }
>  
> +struct btrfs_ordered_extent *btrfs_alloc_delayed_ordered_extent(
> +			struct btrfs_inode *inode, u64 file_offset, u32 length)
> +{
> +	struct btrfs_ordered_extent *entry;
> +
> +	entry = alloc_ordered_extent(inode, file_offset, length, length, 0, 0, 0,
> +				     (1UL << BTRFS_ORDERED_REGULAR) |
> +				     (1UL << BTRFS_ORDERED_DELAYED),
> +				     BTRFS_COMPRESS_NONE);
> +	if (!IS_ERR(entry))
> +		insert_ordered_extent(entry);
> +	return entry;
> +}
> +
>  /*
>   * Add a struct btrfs_ordered_sum into the list of checksums to be inserted
>   * when an ordered extent is finished.  If the list covers more than one
> @@ -644,8 +716,9 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry)
>  	struct btrfs_root *root = btrfs_inode->root;
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	struct rb_node *node;
> -	bool pending;
> +	bool pending = false;
>  	bool freespace_inode;
> +	const bool is_delayed = test_bit(BTRFS_ORDERED_DELAYED, &entry->flags);
>  
>  	/*
>  	 * If this is a free space inode the thread has not acquired the ordered
> @@ -654,33 +727,37 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry)
>  	freespace_inode = btrfs_is_free_space_inode(btrfs_inode);
>  
>  	btrfs_lockdep_acquire(fs_info, btrfs_trans_pending_ordered);
> -	/* This is paired with alloc_ordered_extent(). */
> -	spin_lock(&btrfs_inode->lock);
> -	btrfs_mod_outstanding_extents(btrfs_inode, -1);
> -	spin_unlock(&btrfs_inode->lock);
> -	if (root != fs_info->tree_root) {
> -		u64 release;
> +	if (!is_delayed) {
> +		/* This is paired with alloc_ordered_extent(). */
> +		spin_lock(&btrfs_inode->lock);
> +		btrfs_mod_outstanding_extents(btrfs_inode, -1);
> +		spin_unlock(&btrfs_inode->lock);
>  
> -		if (test_bit(BTRFS_ORDERED_ENCODED, &entry->flags))
> -			release = entry->disk_num_bytes;
> -		else
> -			release = entry->num_bytes;
> -		btrfs_delalloc_release_metadata(btrfs_inode, release,
> +		if (root != fs_info->tree_root) {
> +			u64 release;
> +
> +			if (test_bit(BTRFS_ORDERED_ENCODED, &entry->flags))
> +				release = entry->disk_num_bytes;
> +			else
> +				release = entry->num_bytes;
> +			btrfs_delalloc_release_metadata(btrfs_inode, release,
>  						test_bit(BTRFS_ORDERED_IOERR,
>  							 &entry->flags));
> +		}
>  	}
> -
>  	percpu_counter_add_batch(&fs_info->ordered_bytes, -entry->num_bytes,
>  				 fs_info->delalloc_batch);
>  
>  	spin_lock(&btrfs_inode->ordered_tree_lock);
> -	node = &entry->rb_node;
> -	rb_erase(node, &btrfs_inode->ordered_tree);
> -	RB_CLEAR_NODE(node);
> -	if (btrfs_inode->ordered_tree_last == node)
> -		btrfs_inode->ordered_tree_last = NULL;
> -	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
> -	pending = test_and_clear_bit(BTRFS_ORDERED_PENDING, &entry->flags);
> +	if (!RB_EMPTY_NODE(&entry->rb_node)) {
> +		node = &entry->rb_node;
> +		rb_erase(node, &btrfs_inode->ordered_tree);
> +		RB_CLEAR_NODE(node);
> +		if (btrfs_inode->ordered_tree_last == node)
> +			btrfs_inode->ordered_tree_last = NULL;
> +		set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
> +		pending = test_and_clear_bit(BTRFS_ORDERED_PENDING, &entry->flags);
> +	}
>  	spin_unlock(&btrfs_inode->ordered_tree_lock);
>  
>  	/*
> @@ -712,17 +789,20 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry)
>  
>  	btrfs_lockdep_release(fs_info, btrfs_trans_pending_ordered);
>  
> -	spin_lock(&root->ordered_extent_lock);
> -	list_del_init(&entry->root_extent_list);
> -	root->nr_ordered_extents--;
> -
>  	trace_btrfs_ordered_extent_remove(btrfs_inode, entry);
>  
> -	if (!root->nr_ordered_extents) {
> -		spin_lock(&fs_info->ordered_root_lock);
> -		BUG_ON(list_empty(&root->ordered_root));
> -		list_del_init(&root->ordered_root);
> -		spin_unlock(&fs_info->ordered_root_lock);
> +	spin_lock(&root->ordered_extent_lock);
> +	/* For child OEs, they are not added to per-root OEs. */
> +	if (!list_empty(&entry->root_extent_list)) {
> +		list_del_init(&entry->root_extent_list);
> +		root->nr_ordered_extents--;
> +
> +		if (!root->nr_ordered_extents) {
> +			spin_lock(&fs_info->ordered_root_lock);
> +			BUG_ON(list_empty(&root->ordered_root));
> +			list_del_init(&root->ordered_root);
> +			spin_unlock(&fs_info->ordered_root_lock);
> +		}
>  	}
>  	spin_unlock(&root->ordered_extent_lock);
>  	wake_up(&entry->wait);
> @@ -771,8 +851,18 @@ u64 btrfs_wait_ordered_extents(struct btrfs_root *root, u64 nr,
>  		ordered = list_first_entry(&splice, struct btrfs_ordered_extent,
>  					   root_extent_list);
>  
> -		if (range_end <= ordered->disk_bytenr ||
> -		    ordered->disk_bytenr + ordered->disk_num_bytes <= range_start) {
> +		/*
> +		 * Delayed OEs have 0 disk_bytenr and 0 disk_num_bytes, thus
> +		 * they will be considered out of the [0, U64_MAX) range.
> +		 * And we do not know where they will really land until the
> +		 * writeback finished.
> +		 *
> +		 * So here we must exclude delayed OEs from the bg range check,
> +		 * and always wait for them.
> +		 */
> +		if (!test_bit(BTRFS_ORDERED_DELAYED, &ordered->flags) &&
> +		    (range_end <= ordered->disk_bytenr ||
> +		     ordered->disk_bytenr + ordered->disk_num_bytes <= range_start)) {
>  			list_move_tail(&ordered->root_extent_list, &skipped);
>  			cond_resched_lock(&root->ordered_extent_lock);
>  			continue;
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 03e12380a2fd..7d959c439e99 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -13,6 +13,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/wait.h>
>  #include "async-thread.h"
> +#include "compression.h"
>  
>  struct inode;
>  struct page;
> @@ -87,6 +88,12 @@ enum {
>  	 */
>  	BTRFS_ORDERED_DIRECT,
>  
> +	/*
> +	 * Extra bit for delayed OE, can only be set for REGULAR.
> +	 * Can not be set with COMPRESSED/ENCODED/DIRECT.
> +	 */
> +	BTRFS_ORDERED_DELAYED,
> +
>  	BTRFS_ORDERED_NR_FLAGS,
>  };
>  static_assert(BTRFS_ORDERED_NR_FLAGS <= BITS_PER_LONG);
> @@ -155,6 +162,11 @@ struct btrfs_ordered_extent {
>  	/* a per root list of all the pending ordered extents */
>  	struct list_head root_extent_list;
>  
> +	/* Child ordered extent list for delayed OE. */
> +	struct list_head child_list;
> +
> +	unsigned long child_bitmap[BITS_TO_LONGS(BTRFS_MAX_COMPRESSED / BTRFS_MIN_BLOCKSIZE)];
> +
>  	struct btrfs_work work;
>  
>  	struct completion completion;
> @@ -192,6 +204,8 @@ struct btrfs_file_extent {
>  struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
>  			struct btrfs_inode *inode, u64 file_offset,
>  			const struct btrfs_file_extent *file_extent, unsigned long flags);
> +struct btrfs_ordered_extent *btrfs_alloc_delayed_ordered_extent(
> +			struct btrfs_inode *inode, u64 file_offset, u32 length);
>  void btrfs_add_ordered_sum(struct btrfs_ordered_extent *entry,
>  			   struct btrfs_ordered_sum *sum);
>  struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct btrfs_inode *inode,
> -- 
> 2.54.0
> 
