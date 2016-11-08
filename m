Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36094 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933204AbcKHL1x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 06:27:53 -0500
Received: by mail-lf0-f65.google.com with SMTP id o20so10819517lfg.3
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Nov 2016 03:27:30 -0800 (PST)
Date: Tue, 8 Nov 2016 06:27:12 -0500
From: Sanidhya Solanki <lkml.page@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 2/3] btrfs: Add trace point for qgroup reserved space
Message-ID: <20161108062712.180770ba@ad>
In-Reply-To: <20161108022044.686-2-quwenruo@cn.fujitsu.com>
References: <20161108022044.686-1-quwenruo@cn.fujitsu.com>
        <20161108022044.686-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue,  8 Nov 2016 10:20:43 +0800
Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> Introduce the following trace points:
> qgroup_update_reserve
> qgroup_meta_reserve
> 
> These trace points are handy to trace qgroup reserve space related
> problems.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> Although I hope these trace points will not be used again.
> 
> v2:
>   None
> v3:
>   Separate from trace point timing modification patch.
> ---
>  fs/btrfs/qgroup.c            | 15 +++++++++++++++
>  include/trace/events/btrfs.h | 43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index fc0c64e..c00f962 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1068,6 +1068,8 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>  	qgroup->excl += sign * num_bytes;
>  	qgroup->excl_cmpr += sign * num_bytes;
>  	if (sign > 0) {
> +		trace_qgroup_update_reserve(fs_info, qgroup->qgroupid,
> +					    qgroup->reserved, (s64)-num_bytes);
>  		if (WARN_ON(qgroup->reserved < num_bytes))
>  			report_reserved_underflow(fs_info, qgroup,
>  						  num_bytes);
> @@ -1094,6 +1096,9 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>  		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>  		qgroup->excl += sign * num_bytes;
>  		if (sign > 0) {
> +			trace_qgroup_update_reserve(fs_info, qgroup->qgroupid,
> +						    qgroup->reserved,
> +						    (s64)-num_bytes);
>  			if (WARN_ON(qgroup->reserved < num_bytes))
>  				report_reserved_underflow(fs_info, qgroup,
>  							  num_bytes);
> @@ -2178,6 +2183,8 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
>  
>  		qg = u64_to_ptr(unode->aux);
>  
> +		trace_qgroup_update_reserve(fs_info, qg->qgroupid,
> +					    qg->reserved, num_bytes);
>  		qg->reserved += num_bytes;
>  	}
>  
> @@ -2223,6 +2230,8 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>  
>  		qg = u64_to_ptr(unode->aux);
>  
> +		trace_qgroup_update_reserve(fs_info, qg->qgroupid,
> +					    qg->reserved, (s64)-num_bytes);
>  		if (WARN_ON(qgroup->reserved < num_bytes))
>  			report_reserved_underflow(fs_info, qgroup, num_bytes);
>  		else
> @@ -2706,6 +2715,8 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes)
>  		return 0;
>  
>  	BUG_ON(num_bytes != round_down(num_bytes, root->nodesize));
> +	trace_qgroup_meta_reserve(root->fs_info, root->objectid,
> +				  (s64)num_bytes);
>  	ret = qgroup_reserve(root, num_bytes);
>  	if (ret < 0)
>  		return ret;
> @@ -2724,6 +2735,8 @@ void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
>  	reserved = atomic_xchg(&root->qgroup_meta_rsv, 0);
>  	if (reserved == 0)
>  		return;
> +	trace_qgroup_meta_reserve(root->fs_info, root->objectid,
> +				  (s64)-reserved);
>  	qgroup_free(root, reserved);
>  }
>  
> @@ -2736,6 +2749,8 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
>  	BUG_ON(num_bytes != round_down(num_bytes, root->nodesize));
>  	WARN_ON(atomic_read(&root->qgroup_meta_rsv) < num_bytes);
>  	atomic_sub(num_bytes, &root->qgroup_meta_rsv);
> +	trace_qgroup_meta_reserve(root->fs_info, root->objectid,
> +				  (s64)-num_bytes);
>  	qgroup_free(root, num_bytes);
>  }

Why is there a hyphen in some places after "(s64)" and not in others? Is that supposed to be
type casting or something else?

Sanidhya
