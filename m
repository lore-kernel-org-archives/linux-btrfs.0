Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34863EBF37
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 11:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781265413; cv=none; b=tkh7hWUte4ttQS2YulFLhRkBFUyIyjeveBiaiQ2CE8u5regmOhWYcyAjWseOe7kejuH5uAKnil1nS9NMAtWLz2mwZmfniAI+Tptb3mZmjSHpLdO5F6gluVNFbQ/2tAoZsRXegIPKqGsB5nq66xodQ1RllqDwKxPvNokl/PMMkEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781265413; c=relaxed/simple;
	bh=DsT2ugqgAKpNVVS5UvL05RTdzxuZNCDGgIVz4KsCJqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PD7SxYNe6Sv95FdAahRxy46ZrgXb3o1JJxaa68jHqwUjjn0TQESMj82tG5pnsNZRtpv7lXfyIwIMWMz2wlp8pbBYtggffj3MWYAE8HJYKfKWRtkWZ4J7XK/f3FKSRLn9W1z7BYPNMy0Zb9+2gYegtl60rrNRxNamOeEPqraaw8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RS8hqV4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RS8hqV4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ECA1F00A3A;
	Fri, 12 Jun 2026 11:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781265406;
	bh=Ma+U4kDmzrA3/AwGbrvPedkw9CCGdVukqcblrP38Has=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RS8hqV4za7Yd2/eDKYMvkrHON170YOot5vfMe/ks7vscxG3LEfHX7y+tq7yk3ETWk
	 bCcWWiJwIKhNUWGslFgl2FnwVb4F+IS5trXFny6CNh+MGbNSEgikPGYM70t4tDwh02
	 VQDjo7ZL9K6ej40h8mxfzBErb+GhT4CrPVRKhZhL702PqJ7IOOfoquVJAxD/8nw6iQ
	 qIijjpJORyjLzowIWTbXnCcGBOGt+1oY49UPKSWfeFu6QaIBPJCFOlzt5YE7uQNnLH
	 9y2aKlg/uNVH3ZORwYPuw6zO41PsMPw3WDgfsVq6uwi9KDUvxVvDkgBCC/FNvVfbc5
	 LM+0PXZt5mRpg==
Message-ID: <3e3b0ed7-85d5-4461-95ec-b9a387db7553@kernel.org>
Date: Fri, 12 Jun 2026 20:56:44 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: don't force read-only on transient -EAGAIN
 from reloc merge
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>
References: <20260612100429.214341-1-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260612100429.214341-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/12/26 19:04, Johannes Thumshirn wrote:
> On a zoned FS, btrfs_delayed_refs_rsv_refill() returns -EAGAIN whenever
> the over-committed metadata plus the zone_unusable bytes exceeds the
> usable size in a metadata block-group to avoid heavy over-commit of
> metadata and early ENOSPC in one transaction.
> 
> If this happens while doing reclaim, the transaction is getting
> aborted.
> 
> Treat -EAGAIN as a soft, retryable condition in case of block-group
> reclaim.
> 
> Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
> Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/block-group.c | 11 ++++++++++-
>  fs/btrfs/relocation.c  | 14 ++++++++++----
>  2 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index ab76a5173272..5fc0c20d8e51 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -2047,6 +2047,13 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
>  
>  	trace_btrfs_reclaim_block_group(bg);
>  	ret = btrfs_relocate_chunk(fs_info, bg->start, false);
> +	if (ret == -EAGAIN) {
> +		ASSERT(btrfs_is_zoned(fs_info));
> +		btrfs_dec_block_group_ro(bg);
> +		btrfs_debug(fs_info, "deferring reclaim of chunk %llu",
> +			    bg->start);
> +		return ret;
> +	}
>  	if (ret) {
>  		btrfs_dec_block_group_ro(bg);
>  		btrfs_err(fs_info, "error relocating chunk %llu",
> @@ -2113,7 +2120,9 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_info *fs_info, unsigned int limi
>  		spin_unlock(&fs_info->unused_bgs_lock);
>  		ret = btrfs_reclaim_block_group(bg, &reclaimed);
>  
> -		if (ret && !READ_ONCE(space_info->periodic_reclaim))
> +		if (ret == -EAGAIN)
> +			btrfs_link_bg_list(bg, &retry_list);
> +		else if (ret && !READ_ONCE(space_info->periodic_reclaim))
>  			btrfs_link_bg_list(bg, &retry_list);

Why not:

		if (ret == -EAGAIN ||
		    (ret && !READ_ONCE(space_info->periodic_reclaim)))
			btrfs_link_bg_list(bg, &retry_list);

>  		btrfs_put_block_group(bg);
>  
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 74687c75f763..b2dea3c3b23a 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1871,7 +1871,7 @@ int prepare_to_merge(struct reloc_control *rc, int err)
>  }
>  
>  static noinline_for_stack
> -void merge_reloc_roots(struct reloc_control *rc)
> +int merge_reloc_roots(struct reloc_control *rc)
>  {
>  	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
>  	struct btrfs_root *root;
> @@ -1971,7 +1971,8 @@ void merge_reloc_roots(struct reloc_control *rc)
>  	}
>  out:
>  	if (ret) {
> -		btrfs_handle_fs_error(fs_info, ret, NULL);
> +		if (ret != -EAGAIN)
> +			btrfs_handle_fs_error(fs_info, ret, NULL);
>  		free_reloc_roots(&reloc_roots);
>  
>  		/* new reloc root may be added */
> @@ -1996,6 +1997,7 @@ void merge_reloc_roots(struct reloc_control *rc)
>  	 *
>  	 * The remaining nodes will be cleaned up by put_reloc_control().
>  	 */
> +	return ret;
>  }
>  
>  static void free_block_list(struct rb_root *blocks)
> @@ -3725,7 +3727,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>  	 */
>  	err = prepare_to_merge(rc, err);
>  
> -	merge_reloc_roots(rc);
> +	ret = merge_reloc_roots(rc);
> +	if (ret && !err)
> +		err = ret;
>  
>  	rc->merge_reloc_tree = false;
>  	unset_reloc_control(rc);
> @@ -5694,7 +5698,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
>  	if (ret)
>  		goto out_unset;
>  
> -	merge_reloc_roots(rc);
> +	ret = merge_reloc_roots(rc);
> +	if (ret)
> +		goto out_unset;
>  
>  	unset_reloc_control(rc);
>  


-- 
Damien Le Moal
Western Digital Research
