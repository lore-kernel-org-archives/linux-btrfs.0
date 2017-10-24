Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751691AbdJXRLd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 13:11:33 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F192AAC0A
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 17:11:31 +0000 (UTC)
Subject: Re: [PATCH 4/6] btrfs: qgroup: Fix wrong qgroup reservation
 inheritance for relationship update
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-5-wqu@suse.com>
Cc: dsterba@suse.cz, jeffm@suse.com
From: Edmund Nadolski <enadolski@suse.de>
Message-ID: <27d2fb87-ff7c-1783-9406-26cdcaec7ab5@suse.de>
Date: Tue, 24 Oct 2017 11:11:29 -0600
MIME-Version: 1.0
In-Reply-To: <20171024083941.21428-5-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/24/2017 02:39 AM, Qu Wenruo wrote:
> When modifying qgroup relationship, for qgroup which only owns exclusive
> extents, we will go through quick update path.
> 
> In quick update path, we will just adding/removing exclusive and reference
> number.
> 
> However we did the opposite for qgroup reservation from the very
> beginning.
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

I'm not sure I understand this inheritance model.  Typically a child
will inherit from one (or more) parents, but this seems to go the
opposite way.  (Perhaps it's just terminology, but I may have missed
something here.)

Can these relationships form a hierarchy (i.e., grandparents,
grandchildren, etc.)?

Thanks,
Ed


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
