Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44386 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbeIHBeC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 21:34:02 -0400
Received: by mail-pl1-f195.google.com with SMTP id ba4-v6so7088111plb.11
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 13:51:22 -0700 (PDT)
Date: Fri, 7 Sep 2018 13:51:20 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: qgroup: Remove deprecated feature support in
 btrfs_qgorup_inhert()
Message-ID: <20180907205120.GE29245@vader>
References: <20180831022930.3465-1-wqu@suse.com>
 <20180831022930.3465-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180831022930.3465-4-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:29:30AM +0800, Qu Wenruo wrote:
> Since btrfs_validate_inherit() will not allow features like copy
> rfer/excl and limit set, remove these dead code.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 57 +----------------------------------------------
>  1 file changed, 1 insertion(+), 56 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 53daf73b0de9..b57577f45ff3 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2301,8 +2301,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
>  
>  	if (inherit) {
>  		i_qgroups = (u64 *)(inherit + 1);
> -		nums = inherit->num_qgroups + 2 * inherit->num_ref_copies +
> -		       2 * inherit->num_excl_copies;
> +		nums = inherit->num_qgroups;
>  		for (i = 0; i < nums; ++i) {
>  			srcgroup = find_qgroup_rb(fs_info, *i_qgroups);
>  
> @@ -2354,23 +2353,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
>  		goto unlock;
>  	}
>  
> -	if (inherit && inherit->flags & BTRFS_QGROUP_INHERIT_SET_LIMITS) {
> -		dstgroup->lim_flags = inherit->lim.flags;
> -		dstgroup->max_rfer = inherit->lim.max_rfer;
> -		dstgroup->max_excl = inherit->lim.max_excl;
> -		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
> -		dstgroup->rsv_excl = inherit->lim.rsv_excl;
> -
> -		ret = update_qgroup_limit_item(trans, dstgroup);
> -		if (ret) {
> -			fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> -			btrfs_info(fs_info,
> -				   "unable to update quota limit for %llu",
> -				   dstgroup->qgroupid);
> -			goto unlock;
> -		}
> -	}
> -
>  	if (srcid) {
>  		srcgroup = find_qgroup_rb(fs_info, srcid);
>  		if (!srcgroup)
> @@ -2413,43 +2395,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
>  		++i_qgroups;
>  	}
>  
> -	for (i = 0; i <  inherit->num_ref_copies; ++i, i_qgroups += 2) {
> -		struct btrfs_qgroup *src;
> -		struct btrfs_qgroup *dst;
> -
> -		if (!i_qgroups[0] || !i_qgroups[1])
> -			continue;
> -
> -		src = find_qgroup_rb(fs_info, i_qgroups[0]);
> -		dst = find_qgroup_rb(fs_info, i_qgroups[1]);
> -
> -		if (!src || !dst) {
> -			ret = -EINVAL;
> -			goto unlock;
> -		}
> -
> -		dst->rfer = src->rfer - level_size;
> -		dst->rfer_cmpr = src->rfer_cmpr - level_size;
> -	}
> -	for (i = 0; i <  inherit->num_excl_copies; ++i, i_qgroups += 2) {
> -		struct btrfs_qgroup *src;
> -		struct btrfs_qgroup *dst;
> -
> -		if (!i_qgroups[0] || !i_qgroups[1])
> -			continue;
> -
> -		src = find_qgroup_rb(fs_info, i_qgroups[0]);
> -		dst = find_qgroup_rb(fs_info, i_qgroups[1]);
> -
> -		if (!src || !dst) {
> -			ret = -EINVAL;
> -			goto unlock;
> -		}
> -
> -		dst->excl = src->excl + level_size;
> -		dst->excl_cmpr = src->excl_cmpr + level_size;
> -	}
> -
>  unlock:
>  	spin_unlock(&fs_info->qgroup_lock);
>  out:
> -- 
> 2.18.0
> 
