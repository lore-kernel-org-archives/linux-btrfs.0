Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45783 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751912AbdJXMBR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 08:01:17 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12688ADFE
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 12:01:16 +0000 (UTC)
Subject: Re: [PATCH 4/6] btrfs: qgroup: Fix wrong qgroup reservation
 inheritance for relationship update
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-5-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a386a6bc-5add-a09f-e7ac-bc557bbcbfa2@suse.com>
Date: Tue, 24 Oct 2017 15:01:15 +0300
MIME-Version: 1.0
In-Reply-To: <20171024083941.21428-5-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.10.2017 11:39, Qu Wenruo wrote:
> When modifying qgroup relationship, for qgroup which only owns exclusive
> extents, we will go through quick update path.
> 
> In quick update path, we will just adding/removing exclusive and reference
> number.
> 
> However we did the opposite for qgroup reservation from the very
> beginning.

I'm afraid this sentence doesn't give much information about what's
really going on.

> 
> In fact, we should also inherit the qgroup reservation space, just like
> exclusive and reference numbers.
> 
> Fix by using the newly introduced
> qgroup_rsv_increase/decrease_by_qgroup() function call.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 39 ++++++++++++++++++---------------------
>  1 file changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 7b89da9589c1..ba6f60fd0e96 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1069,21 +1069,24 @@ static void report_reserved_underflow(struct btrfs_fs_info *fs_info,
>  #endif
>  	qgroup->reserved = 0;
>  }
> +
>  /*
> - * The easy accounting, if we are adding/removing the only ref for an extent
> - * then this qgroup and all of the parent qgroups get their reference and
> - * exclusive counts adjusted.
> + * The easy accounting, we're updating qgroup relationship whose child qgroup
> + * only have exclusive extents.
> + * In this case, we only need to update the rfer/excl, and inherit rsv from
> + * child qgroup (@src)
>   *
>   * Caller should hold fs_info->qgroup_lock.
>   */
>  static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>  				    struct ulist *tmp, u64 ref_root,
> -				    u64 num_bytes, int sign)
> +				    struct btrfs_qgroup *src, int sign)
>  {
>  	struct btrfs_qgroup *qgroup;
>  	struct btrfs_qgroup_list *glist;
>  	struct ulist_node *unode;
>  	struct ulist_iterator uiter;
> +	u64 num_bytes = src->excl;
>  	int ret = 0;
>  
>  	qgroup = find_qgroup_rb(fs_info, ref_root);
> @@ -1096,13 +1099,12 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>  	WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>  	qgroup->excl += sign * num_bytes;
>  	qgroup->excl_cmpr += sign * num_bytes;
> -	if (sign > 0) {
> -		trace_qgroup_update_reserve(fs_info, qgroup, -(s64)num_bytes);
> -		if (qgroup->reserved < num_bytes)
> -			report_reserved_underflow(fs_info, qgroup, num_bytes);
> -		else
> -			qgroup->reserved -= num_bytes;
> -	}
> +
> +	/* *Inherit* qgroup rsv info from @src */
> +	if (sign > 0)
> +		qgroup_rsv_increase_by_qgroup(qgroup, src);
> +	else
> +		qgroup_rsv_decrease_by_qgroup(qgroup, src);


I'm a bit confused by the semantics of the 'sign' variable. So what you
are doing is that if sign is > 0 then you are "adding a relationship"
i.e. adding 'src reservation to 'qgroup', presumably because the src is
a child of qgroup? So you are handling both adding and deletion in the
if statement?

However, before that apparently only deleting a relation ship was
handled by that same if (And I believe that was wrong since if sign > 0
then we should be adding bytes but here we are subtracting). SO the bug
being fixed by this commit are actually 2 bugs:

1. Completely missing the "adding a relation ship case"
2. Incorrect hanlding of sign < 0, since this was handled by the sign >
0 case?



>  
>  	qgroup_dirty(fs_info, qgroup);
>  
> @@ -1122,15 +1124,10 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>  		qgroup->rfer_cmpr += sign * num_bytes;
>  		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>  		qgroup->excl += sign * num_bytes;
> -		if (sign > 0) {
> -			trace_qgroup_update_reserve(fs_info, qgroup,
> -						    -(s64)num_bytes);
> -			if (qgroup->reserved < num_bytes)
> -				report_reserved_underflow(fs_info, qgroup,
> -							  num_bytes);
> -			else
> -				qgroup->reserved -= num_bytes;
> -		}
> +		if (sign > 0)
> +			qgroup_rsv_increase_by_qgroup(qgroup, src);
> +		else
> +			qgroup_rsv_decrease_by_qgroup(qgroup, src);
>  		qgroup->excl_cmpr += sign * num_bytes;
>  		qgroup_dirty(fs_info, qgroup);
>  
> @@ -1173,7 +1170,7 @@ static int quick_update_accounting(struct btrfs_fs_info *fs_info,
>  	if (qgroup->excl == qgroup->rfer) {
>  		ret = 0;
>  		err = __qgroup_excl_accounting(fs_info, tmp, dst,
> -					       qgroup->excl, sign);
> +					       qgroup, sign);
>  		if (err < 0) {
>  			ret = err;
>  			goto out;
> 
