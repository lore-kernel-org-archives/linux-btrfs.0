Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01BF17745
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897865; cv=none; b=CRcc4gJKkfumO7Wdjj2s9qeWQhKN9iShIwAVbPQjaUGQiwyqWpRJgqGHj3RAFqKkQ3A+OfalyzocofJZQDyO4fMzt3x1AbSlRHzrkFuSiNZ9h4+Bp0rDIIPcSMAFUpQ5Ez7wokNxbo6i34dgmQZhN48+iMNwgOmvmo9YIWx92yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897865; c=relaxed/simple;
	bh=KJxaozxQKzdHwlq6Icpf+O2ddtYq4S/vS7ur/lgTJJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ny3jmC/wYXcRMQOUbzNMxGYCBWUGtAjRQnDjVGUhy2VZHTq5JVPtYI1u/8lAdFJQE1yOYAhJANbSjTownnLSreeJvTpWA2EahAZZEREMWu11EHV6eJ77wofNt23CXh5LrzE0VmAChiKkuKTWZHtr4KewAr5KCvjzDjPGzvuoQpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=cRfCoqK0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JBEYOzqI; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="cRfCoqK0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JBEYOzqI"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2B6031400109;
	Wed, 27 May 2026 12:04:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Wed, 27 May 2026 12:04:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779897863; x=1779984263; bh=txsDdTx9Lp
	m528B6/LtW6E+yr0hZ3DRoaLhKRKdFoxs=; b=cRfCoqK0srJbJpJkguEQSGzSfP
	fUSP4Lsug9o8jed1rPJjy7JARiVcmO/s3xHjucZ/zAYGv0fjT6HbAgPJs/oxMohE
	eeH2pU8fKn6xreHYC1CMdaSGvNtzNsr/Sugde9SDqlW/X74xdL4m7Q4dWQOryRvO
	7RR1FKTjACHL8+lq5OzDOvs21ZCyRaHi+KyLrEMvH32lZBrhE8vmDkJqGP45PoYk
	aUjRqPk6TBpO3BY5jnf38LbO2xvzn4uCoBfcJ1a+8E6Qc0pFlLHC/XMPl5u8i5qg
	wQKe68STqFpZAExNK5Cj5NQTE+zAU5WFzj2WZ2xioeOPB1WaffbNzmfAhHKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779897863; x=1779984263; bh=txsDdTx9Lpm528B6/LtW6E+yr0hZ3DRoaLh
	KRKdFoxs=; b=JBEYOzqIF2oc9YfAn28PXZpDoRKDjRXxFgM5Dc88peh+8I6w0um
	vIiIX/dd3r7UambrYTbZxiYXnFSr0+tTYwijYQIvEV6tfTNA3yqGMfCBu2OLo8O3
	ZTc74Ke4BXSkNB5I0jzc3Hxt++i9Ssbyouu0R1UyGsx8DjfR90Mh4+9PMorMe6Iu
	mFgGwRDn12eWax9Oh2VP/ANcnaBMT6LKYvh4fKSe3pxufveHwZMtiSF2MWOdvDv+
	E8CQdkuaftdxfUPfavVGQZOhRpd1mLiM8XauV5B2j8EHVR7Utb4eU0pi4NSgFzla
	R1JqCWbvKo6N6PIMMeixhB9OPE8jdwHmXnw==
X-ME-Sender: <xms:BxYXaumpxnqdmAfRQWYDwGlnSHjgdmZhBf2b-Iv3HAAS5TleAeo72Q>
    <xme:BxYXar1NnUyDyo4tZHjCD7oC1Wl0MA6my60wQuU1lx1fuvKtn1QFM6X1Fi0mRG6Rh
    TYhQEeXH3QrAU4VDrhSgo-yr3OZ07Dx4ciGDhH_dMJv9t0pz2HPFPc>
X-ME-Received: <xmr:BxYXaqTdVrdYb6pKHtSuedx9k6Rhb4Aoy0FLrv1OjyyfYHkdQAmBRr4KO2YyFW6cqYwrqGt6xgmAlJaVKu1IMl7SEnI>
X-ME-Proxy-Cause: dmFkZTGBO2Y0ATYpcffAASf6TOIRg7KHm72DbrskGqP/Yct+QNvRwDOn1Ph/VcRuh+8e/W
    MXZ9Yj2iD9Ro9mZc/qrufWwPjyD23jihmoCzok3pzF0BfAjT0BR8Zi5LcMGv0HZo4+/gZR
    Lix+jhbX9YTJkYN+6BagHP8qFsaK16SfsSEC2HmFLx01XJqoVdT2U4YZF10nsTV2Hq8oj5
    vdlRSH4UJT6/2qdmgE4W83hZCQWQaZPz+jIMXxjL3Fno3fWcrSx/tzV560cx7wA1GZ5NHi
    /M5ah3ICxQfZaEtoV2gHm/vaHTRZGzDR+TD/gpw2CxZr8HPp3HGYxENYOztayT7PehxuO0
    A56xkh8NVD3NGMTbtNmyLwX+jIXF2GLFjq9zpwKgYIf5HQ6YQvOuNXFpOfcMucjdr/i0B1
    UXd5h8PI4iJBI3gcLLRP56iBzLRUVUvoghDCJUt9SmjmvsDIvKWZRMSBcBjlHkVviP9Okz
    SY8HmEWR2ZAeSIvms2J0X2IeAIsiHFthlKeeRkFjwv8Gy7sad8i9MhtkARSXsm9xgL1Zx7
    QB78ZXw7HWH132CohGOqeXtjrjjLqvrKr/K8Vs4ZtvDN42tj12PU53AuXbfgmzmfGZR+cA
    vYr//iH2+6u+R5GmEmFAl9m7MmU8h9xRCVLayAX3v0ZMjhUm6fI2+orUNJAQ
X-ME-Proxy: <xmx:BxYXatv_J86N5a0tM0eFut4aa967jGGVszfI3DeRS6ooF7_1jDGChw>
    <xmx:BxYXavYvkWjD5WPW4WWBoNF8Yfp2nzspXievc6opRBI9D42vFk_G4A>
    <xmx:BxYXaitbSB9YlYOE53duy0hiGmd69adtenBpcobPL5ZAsdKKiJhCKg>
    <xmx:BxYXahEm8IQAKKGkCU6zOZd8SfD3fp4AcjHKgZpOruXK34zzmQ9Ikw>
    <xmx:BxYXapRpUc0gfGnYISNYM-FC_12QvFHI3mZM1d8IRiZYJ4YhIIKQdSiY>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 May 2026 12:04:22 -0400 (EDT)
Date: Wed, 27 May 2026 09:04:09 -0700
From: Boris Burkov <boris@bur.io>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use shifts for sectorsize and nodesize
Message-ID: <20260527160409.GC1981571@zen.localdomain>
References: <20260527111652.944584-1-dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527111652.944584-1-dsterba@suse.com>

On Wed, May 27, 2026 at 01:16:52PM +0200, David Sterba wrote:
> Convert more multiplications of sectorsize or nodesize to use the
> shifts. The remaining cases are multiplications by constants that
> compiler can optimize by itself, and in tests.
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/delalloc-space.c | 4 ++--
>  fs/btrfs/disk-io.c        | 2 +-
>  fs/btrfs/file-item.c      | 2 +-
>  fs/btrfs/relocation.c     | 4 ++--
>  fs/btrfs/transaction.c    | 2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 0970799d0aa443..5d5ff5a0280844 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -279,7 +279,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
>  	 *
>  	 * This is overestimating in most cases.
>  	 */
> -	qgroup_rsv_size = (u64)outstanding_extents * fs_info->nodesize;
> +	qgroup_rsv_size = ((u64)outstanding_extents << fs_info->nodesize_bits);
>  
>  	spin_lock(&block_rsv->lock);
>  	block_rsv->size = reserve_size;
> @@ -309,7 +309,7 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
>  	 * for an inode update.
>  	 */
>  	*meta_reserve += inode_update;
> -	*qgroup_reserve = nr_extents * fs_info->nodesize;
> +	*qgroup_reserve = (nr_extents << fs_info->nodesize_bits);
>  }
>  
>  int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e6ed52f5cd6d99..590da1ba5de485 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -563,7 +563,7 @@ static bool btree_dirty_folio(struct address_space *mapping,
>  			continue;
>  		}
>  		spin_unlock_irqrestore(&subpage->lock, flags);
> -		cur = page_start + cur_bit * fs_info->sectorsize;
> +		cur = page_start + (cur_bit << fs_info->sectorsize_bits);
>  
>  		eb = find_extent_buffer(fs_info, cur);
>  		ASSERT(eb);
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 82ae4a2afd3471..9f6454e9db8186 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -1309,7 +1309,7 @@ int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
>  
>  	index += ins_size;
>  	ins_size /= csum_size;
> -	total_bytes += ins_size * fs_info->sectorsize;
> +	total_bytes += (ins_size << fs_info->sectorsize_bits);
>  
>  	if (total_bytes < sums->len) {
>  		btrfs_release_path(path);
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 67af02e732d0ce..8212abc2d13652 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1560,7 +1560,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
>  	 * and * 2 since we have two trees to COW.
>  	 */
>  	reserve_level = max_t(int, 1, btrfs_root_level(root_item));
> -	min_reserved = fs_info->nodesize * reserve_level * 2;
> +	min_reserved = (reserve_level << fs_info->nodesize_bits) * 2;

Is it nicer to just add 1 to the shift operand?

>  	memset(&next_key, 0, sizeof(next_key));
>  
>  	while (1) {
> @@ -2558,7 +2558,7 @@ static int relocate_cowonly_block(struct btrfs_trans_handle *trans,
>  
>  	nr_levels = max(btrfs_header_level(root->node) - block->level, 0) + 1;
>  
> -	num_bytes = fs_info->nodesize * nr_levels;
> +	num_bytes = (nr_levels << fs_info->nodesize_bits);
>  	ret = refill_metadata_space(trans, rc, num_bytes);
>  	if (ret) {
>  		btrfs_put_root(root);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index a289a8fa237c8a..2263cb6bd8ca47 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -631,7 +631,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
>  	 * the appropriate flushing if need be.
>  	 */
>  	if (num_items && root != fs_info->chunk_root) {
> -		qgroup_reserved = num_items * fs_info->nodesize;
> +		qgroup_reserved = (num_items << fs_info->nodesize_bits);
>  		/*
>  		 * Use prealloc for now, as there might be a currently running
>  		 * transaction that could free this reserved space prematurely
> -- 
> 2.54.0
> 
