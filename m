Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21889 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756161AbdDSAfl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 20:35:41 -0400
Subject: Re: [PATCH] btrfs: qgroup: move noisy underflow warning to debugging
 build
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>
References: <20170418150939.6743-1-dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <0f4b71aa-f174-8fca-5b74-bc6fe6f25956@cn.fujitsu.com>
Date: Wed, 19 Apr 2017 08:35:37 +0800
MIME-Version: 1.0
In-Reply-To: <20170418150939.6743-1-dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/18/2017 11:09 PM, David Sterba wrote:
> The WARN_ON and warning from report_reserved_underflow can become very
> noisy and is visible unconditionally although this is namely for
> debugging. The patch "btrfs: Add WARN_ON for qgroup reserved underflow"
> (18dc22c19bef520cca11ce4c0807ac9dec48d31f) went to 4.11-rc1 and the plan
> was to get the fix as well, but this hasn't happened.
> 
> CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks for that.
Qu

> ---
> 
> This is going to be submitted for 4.11
> 
>   fs/btrfs/qgroup.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a59801dc2a34..afbea61d957e 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1042,9 +1042,12 @@ static void report_reserved_underflow(struct btrfs_fs_info *fs_info,
>   				      struct btrfs_qgroup *qgroup,
>   				      u64 num_bytes)
>   {
> -	btrfs_warn(fs_info,
> +#ifdef CONFIG_BTRFS_DEBUG
> +	WARN_ON(qgroup->reserved < num_bytes);
> +	btrfs_debug(fs_info,
>   		"qgroup %llu reserved space underflow, have: %llu, to free: %llu",
>   		qgroup->qgroupid, qgroup->reserved, num_bytes);
> +#endif
>   	qgroup->reserved = 0;
>   }
>   /*
> @@ -1075,7 +1078,7 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>   	qgroup->excl += sign * num_bytes;
>   	qgroup->excl_cmpr += sign * num_bytes;
>   	if (sign > 0) {
> -		if (WARN_ON(qgroup->reserved < num_bytes))
> +		if (qgroup->reserved < num_bytes)
>   			report_reserved_underflow(fs_info, qgroup, num_bytes);
>   		else
>   			qgroup->reserved -= num_bytes;
> @@ -1100,7 +1103,7 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>   		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>   		qgroup->excl += sign * num_bytes;
>   		if (sign > 0) {
> -			if (WARN_ON(qgroup->reserved < num_bytes))
> +			if (qgroup->reserved < num_bytes)
>   				report_reserved_underflow(fs_info, qgroup,
>   							  num_bytes);
>   			else
> @@ -2469,7 +2472,7 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>   
>   		qg = unode_aux_to_qgroup(unode);
>   
> -		if (WARN_ON(qg->reserved < num_bytes))
> +		if (qg->reserved < num_bytes)
>   			report_reserved_underflow(fs_info, qg, num_bytes);
>   		else
>   			qg->reserved -= num_bytes;
> 


