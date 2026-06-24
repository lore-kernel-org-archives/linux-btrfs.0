Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210CE29ACDD
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782275039; cv=none; b=qSv6GUaLncEsCizrwnCEBNZ6sbq4bu3SUazm7vdwlRIiE/4Bjfq792LjsEQlITWwpijQlfcP832OBlNAeF0epQo8DBYBsXhKmYDJ2dFjM9X9EnbYPhppM+5NdAO9NxQfpWYCadFo785vlB2URMELgGdUf8Ue+/eGqvrKJ17XJgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782275039; c=relaxed/simple;
	bh=ICALXq+0NhaxTVdMb3JbSVkvmilQI7wwRQJh+kksBmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czs2cf9AI8NgcDaBCVB9jDq85A+T7nyShFdpUxcKHf9JRCWMCyCsvUvmMUdlo2qFBIjvGExjXYrQzX/Q6upsiPqFCX41rW1fMP9PkBfzQ2++73r9OTpKFNeo5srdPH21H588sR+/2VsrcbQqugFoMtxswCPadalieyMpmLYz/us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=O/nwruKN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HOcRbXAO; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="O/nwruKN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HOcRbXAO"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6C1907A014C;
	Wed, 24 Jun 2026 00:23:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 24 Jun 2026 00:23:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1782275037; x=1782361437; bh=GS30WT2r+N
	uGlXRwmBgN8+kbDXS+shSojMMs6aRH6p4=; b=O/nwruKN7FWb4DgD8YKKnj7Bly
	FXa5TkUVD8BaAMojkmt1cB59SQMY+jTWJbOSpj7TVBRMPReP3xXok0sBn47jm9cJ
	fCAaqsuNR+0nV0q5vJkn59zfcfNeQoL3Oz6la0WLyOAGH/U1fcthWDw97NzB2/Ob
	XEc1sRbn8tIh4AutvhTG0pirTqFKS4sj+n3m8cF+7EFigHCPpiFUy+onH4HvH+MT
	qDrtCP0einhNnKsQdtkKFibeVCq+o5FAzLOENXMbix+bfvBlq81lNp4TRV+YYYzG
	R/a+tx0rMwbb3WD1takOz3nWFY/SQERSFtL0iXi6IdyVvjEAJjjMS5wrSq/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1782275037; x=1782361437; bh=GS30WT2r+NuGlXRwmBgN8+kbDXS+shSojMM
	s6aRH6p4=; b=HOcRbXAOgksCb1IJcz+SW7uBb2+XwW/Gup4BhYFXLbGxvKCh1Mt
	WFGjxFWUkeFVkamHh1q6wOKNfPtj7O0hC0aEvvOAYfShEWLmv4KCxRIcZWQ4I58A
	f7Tlx86MHQ5lVTsbI9wd89t2kpHrfagzzZyR492s+snPHAvPCcnLGlR/k5pza/8u
	VJzKelpFkS3HDS/sSN/CRKJrim2jvtDv6Es7P64Lp9trL5BLVbeYRVD0U7EYOl4g
	HngcrAjjasYi689epVJYu3oJ3FMFjTwfnOO+ApL2Oz7Qjrkl4/Pc6aqJixncnvNH
	W31VS78JZPHarAQF1HFHVVxZrfM36mnT5hg==
X-ME-Sender: <xms:3Vs7atqhkC-Csymf9ksmR7Vi8mpVnRSC_rnpFnmOXoigXrzqO5XGBQ>
    <xme:3Vs7alplikuRI5BAKXazGlgEl_wD82354KoLqq3mvfSlNwLciryh3YhBNtiapDvoi
    LX7RHW2LB5u4dYRWFvxT-UVZTDjFsrRP4w6YOkNZMaPtLqPZzDFNQ>
X-ME-Received: <xmr:3Vs7an35PDB_tv8K8YC5ew-oS1lELb3H6pEI-AUinKFzUcbBSGhkX3OJhT2TAXBDbZ7km4lAkvwtaQEszSftKphh5l8>
X-ME-Proxy-Cause: dmFkZTGL3XewYNeXF18yEj9t8uKr7XHOBAM6ERDvl/et0aO5bOfQqzsG/dxJ5Tylw9kIwf
    UX+88o2ftqh4OUuachbreXYxAYhJOO818QmZ5gLWJP2ZdMXuDGm3B9f0jbV62IjzC4BqMM
    /AVIo4aWAAYjOXgDlsUtk/bh84JB0FlO1FgGA7PrutP3z3m5VLW+hyVg8Aa7lE0mv9tjqn
    dsrgepthKOrSXFiKOJFl6PVdWC8EbmqIM+a5f4cs9EH036R0ix6B5/JMMAwW2XeJGy+NM5
    qrsU/r2KvGTmv4B1WY/DyZx8ii1mDn0EktjG8KKqEjaPVkuG/yZ9k+JRUpZJrtLnxbQwtF
    6CcKRiQeFBRVN71lvr+/9+WJDgyEXh0VtALN3yN9ICX8fUgPvcX3dpr2hUZvhK+2wtD10I
    SNSKWazwu4MkT4hLcJov/S9uCNtIdzw0OO4vD/TF4C52iR+RtA2EEujfj7wEU22Ud1yfpO
    EyDKCQV86EO5Z1AKOFBZuNIXKepgPor3PrXO7wUkSG1Ii7Qotb0UOd8Hfomzllijw6x1JJ
    JMY4nkHdS+QId0+ZVYSHNjvMbAu3cMUD77kGpkHZmwjUZ/bJC+65Nid7EQI8zH/Lv3RvtH
    5kLH7LH4+DUstgoU4dKfPPZ3a+iIznIpvxdJjYmQcGprpU8cRJyK4dJ1PPjg
X-ME-Proxy: <xmx:3Vs7akDRMt-I5E2Ixz2Yg7vwvJ32Zk4xfslt2amPL5m1VtL7AHt0yQ>
    <xmx:3Vs7avcVaQFblPi1mfW3DMyOUO3c-MCHOB4OsS7RLMZvcoWn5xDENg>
    <xmx:3Vs7apgvxhLsvwS7dhD8zT284s51-dSFDsghN5R774vkGCM2wZJDvQ>
    <xmx:3Vs7anqG2ZjKpkC-k6uOPNvbacsc49FcXb__4vT44Z3IIwFXId6Mwg>
    <xmx:3Vs7as03y0kvn9oIczda2KzaAj5D7RPfYI0xXaT_ZfaKYcymIC5tPA8b>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Jun 2026 00:23:56 -0400 (EDT)
Date: Tue, 23 Jun 2026 21:22:55 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use correct type for sectorsize/nodesize/blocksize
Message-ID: <20260624042255.GB2011094@zen.localdomain>
References: <f12af6d49a5b04bd7ff537bcdabee176b54416f6.1782274357.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f12af6d49a5b04bd7ff537bcdabee176b54416f6.1782274357.git.wqu@suse.com>

On Wed, Jun 24, 2026 at 01:42:42PM +0930, Qu Wenruo wrote:
> Btrfs' nodesize and sectorsize are all u32 values, there is no need to
> use u64 for local usage.
> 
> Furthermore some call sites also use "blocksize" or "bs" for sectorsize,
> also change them to use the minimal type u32 instead.
> 
> Since we're here, also reorder those local variables so that they won't
> cause extra holes for stack memory, and consitify the
> sectorsize/nodesize/blocksize/bs usage.
> 

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 12 ++++++------
>  fs/btrfs/fiemap.c  |  4 ++--
>  fs/btrfs/file.c    |  4 ++--
>  fs/btrfs/inode.c   |  4 ++--
>  fs/btrfs/reflink.c |  8 ++++----
>  fs/btrfs/send.c    |  2 +-
>  6 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 0a7d80da9c94..fa5922a21e51 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2390,8 +2390,8 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
>  int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
>  			 const struct btrfs_super_block *sb, int mirror_num)
>  {
> -	u64 nodesize = btrfs_super_nodesize(sb);
> -	u64 sectorsize = btrfs_super_sectorsize(sb);
> +	const u32 nodesize = btrfs_super_nodesize(sb);
> +	const u32 sectorsize = btrfs_super_sectorsize(sb);
>  	int ret = 0;
>  	const bool ignore_flags = btrfs_test_opt(fs_info, IGNORESUPERFLAGS);
>  
> @@ -2433,24 +2433,24 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
>  	 */
>  	if (unlikely(!is_power_of_2(sectorsize) || sectorsize < BTRFS_MIN_BLOCKSIZE ||
>  		     sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE)) {
> -		btrfs_err(fs_info, "invalid sectorsize %llu", sectorsize);
> +		btrfs_err(fs_info, "invalid sectorsize %u", sectorsize);
>  		ret = -EINVAL;
>  	}
>  
>  	if (unlikely(!btrfs_supported_blocksize(sectorsize))) {
>  		btrfs_err(fs_info,
> -			"sectorsize %llu not yet supported for page size %lu",
> +			"sectorsize %u not yet supported for page size %lu",
>  			sectorsize, PAGE_SIZE);
>  		ret = -EINVAL;
>  	}
>  
>  	if (unlikely(!is_power_of_2(nodesize) || nodesize < sectorsize ||
>  		     nodesize > BTRFS_MAX_METADATA_BLOCKSIZE)) {
> -		btrfs_err(fs_info, "invalid nodesize %llu", nodesize);
> +		btrfs_err(fs_info, "invalid nodesize %u", nodesize);
>  		ret = -EINVAL;
>  	}
>  	if (unlikely(nodesize != le32_to_cpu(sb->__unused_leafsize))) {
> -		btrfs_err(fs_info, "invalid leafsize %u, should be %llu",
> +		btrfs_err(fs_info, "invalid leafsize %u, should be %u",
>  			  le32_to_cpu(sb->__unused_leafsize), nodesize);
>  		ret = -EINVAL;
>  	}
> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
> index 6263e837093e..1da1ccea5b03 100644
> --- a/fs/btrfs/fiemap.c
> +++ b/fs/btrfs/fiemap.c
> @@ -641,9 +641,9 @@ static int extent_fiemap(struct btrfs_inode *inode,
>  	u64 prev_extent_end;
>  	u64 range_start;
>  	u64 range_end;
> -	const u64 sectorsize = inode->root->fs_info->sectorsize;
> -	bool stopped = false;
> +	const u32 sectorsize = inode->root->fs_info->sectorsize;
>  	int ret;
> +	bool stopped = false;
>  
>  	cache.entries_size = PAGE_SIZE / sizeof(struct btrfs_fiemap_entry);
>  	cache.entries = kmalloc_objs(struct btrfs_fiemap_entry,
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index a2a2df2df786..df8f6f565070 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2888,8 +2888,8 @@ enum {
>  static int btrfs_zero_range_check_range_boundary(struct btrfs_inode *inode,
>  						 u64 offset)
>  {
> -	const u64 sectorsize = inode->root->fs_info->sectorsize;
>  	struct extent_map *em;
> +	const u32 sectorsize = inode->root->fs_info->sectorsize;
>  	int ret;
>  
>  	offset = round_down(offset, sectorsize);
> @@ -2916,9 +2916,9 @@ static int btrfs_zero_range(struct inode *inode,
>  	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
>  	struct extent_map *em;
>  	struct extent_changeset *data_reserved = NULL;
> +	const u32 sectorsize = fs_info->sectorsize;
>  	int ret;
>  	u64 alloc_hint = 0;
> -	const u64 sectorsize = fs_info->sectorsize;
>  	const u64 orig_start = offset;
>  	const u64 orig_end = offset + len - 1;
>  	u64 alloc_start = round_down(offset, sectorsize);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ebd1387fcc76..ea772ec788f9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -860,11 +860,11 @@ static void compress_file_range(struct btrfs_work *work)
>  	struct btrfs_inode *inode = async_chunk->inode;
>  	struct btrfs_fs_info *fs_info = inode->root->fs_info;
>  	struct compressed_bio *cb = NULL;
> -	u64 blocksize = fs_info->sectorsize;
>  	u64 start = async_chunk->start;
>  	u64 end = async_chunk->end;
>  	u64 actual_end;
>  	u64 i_size;
> +	const u32 blocksize = fs_info->sectorsize;
>  	u32 cur_len;
>  	int ret = 0;
>  	unsigned long total_compressed = 0;
> @@ -2865,7 +2865,6 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>  				       u64 qgroup_reserved)
>  {
>  	struct btrfs_root *root = inode->root;
> -	const u64 sectorsize = root->fs_info->sectorsize;
>  	BTRFS_PATH_AUTO_FREE(path);
>  	struct extent_buffer *leaf;
>  	struct btrfs_key ins;
> @@ -2875,6 +2874,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>  	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
>  	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
>  	struct btrfs_drop_extents_args drop_args = { 0 };
> +	const u32 sectorsize = root->fs_info->sectorsize;
>  	int ret;
>  
>  	path = btrfs_alloc_path();
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index 9a49d2ecb949..5205b508127c 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -691,7 +691,7 @@ static int btrfs_extent_same_range(struct btrfs_inode *src, u64 loff, u64 len,
>  	const u64 end = dst_loff + len - 1;
>  	struct extent_state *cached_state = NULL;
>  	struct btrfs_fs_info *fs_info = src->root->fs_info;
> -	const u64 bs = fs_info->sectorsize;
> +	const u32 bs = fs_info->sectorsize;
>  	int ret;
>  
>  	/*
> @@ -760,10 +760,10 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>  	struct inode *inode = file_inode(file);
>  	struct inode *src = file_inode(file_src);
>  	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
> -	int ret;
>  	u64 len = olen;
> -	u64 bs = fs_info->sectorsize;
>  	u64 end;
> +	const u32 bs = fs_info->sectorsize;
> +	int ret;
>  
>  	/*
>  	 * VFS's generic_remap_file_range_prep() protects us from cloning the
> @@ -841,8 +841,8 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  {
>  	struct btrfs_inode *inode_in = BTRFS_I(file_inode(file_in));
>  	struct btrfs_inode *inode_out = BTRFS_I(file_inode(file_out));
> -	u64 bs = inode_out->root->fs_info->sectorsize;
>  	u64 wb_len;
> +	const u32 bs = inode_out->root->fs_info->sectorsize;
>  	int ret;
>  
>  	if (!(remap_flags & REMAP_FILE_DEDUP)) {
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index d664e470fd77..48a6667053d8 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -6038,9 +6038,9 @@ static int send_write_or_clone(struct send_ctx *sctx,
>  			       struct clone_root *clone_root)
>  {
>  	int ret = 0;
> +	const u32 bs = sctx->send_root->fs_info->sectorsize;
>  	u64 offset = key->offset;
>  	u64 end;
> -	u64 bs = sctx->send_root->fs_info->sectorsize;
>  	struct btrfs_file_extent_item *ei;
>  	u64 disk_byte;
>  	u64 data_offset;
> -- 
> 2.54.0
> 
