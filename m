Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49679 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932515AbcI3Pn0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 11:43:26 -0400
Subject: Re: [PATCH 1/2] btrfs: Add WARN_ON for qgroup reserved underflow
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20160930011537.4857-1-quwenruo@cn.fujitsu.com>
Cc: rgoldwyn@suse.com
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <3114365b-5060-8d9c-f550-4dc196625b91@suse.de>
Date: Fri, 30 Sep 2016 10:43:22 -0500
MIME-Version: 1.0
In-Reply-To: <20160930011537.4857-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/29/2016 08:15 PM, Qu Wenruo wrote:
> While the reason why qgroup reserved space may underflow is still under
> investigation, such WARN_ON will help us to expose the bug more easily,
> and for end-user we can detect and avoid underflow.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Looks good.

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

> ---
>  fs/btrfs/qgroup.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 8db2e29..8532587 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1061,8 +1061,12 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>  	WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>  	qgroup->excl += sign * num_bytes;
>  	qgroup->excl_cmpr += sign * num_bytes;
> -	if (sign > 0)
> -		qgroup->reserved -= num_bytes;
> +	if (sign > 0) {
> +		if (WARN_ON(qgroup->reserved < num_bytes))
> +			qgroup->reserved = 0;
> +		else
> +			qgroup->reserved -= num_bytes;
> +	}
>  
>  	qgroup_dirty(fs_info, qgroup);
>  
> @@ -1082,8 +1086,12 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>  		qgroup->rfer_cmpr += sign * num_bytes;
>  		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>  		qgroup->excl += sign * num_bytes;
> -		if (sign > 0)
> -			qgroup->reserved -= num_bytes;
> +		if (sign > 0) {
> +			if (WARN_ON(qgroup->reserved < num_bytes))
> +				qgroup->reserved = 0;
> +			else
> +				qgroup->reserved -= num_bytes;
> +		}
>  		qgroup->excl_cmpr += sign * num_bytes;
>  		qgroup_dirty(fs_info, qgroup);
>  
> @@ -2201,7 +2209,10 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>  
>  		qg = u64_to_ptr(unode->aux);
>  
> -		qg->reserved -= num_bytes;
> +		if (WARN_ON(qgroup->reserved < num_bytes))
> +			qgroup->reserved = 0;
> +		else
> +			qgroup->reserved -= num_bytes;
>  
>  		list_for_each_entry(glist, &qg->groups, next_group) {
>  			ret = ulist_add(fs_info->qgroup_ulist,
> 

-- 
Goldwyn
