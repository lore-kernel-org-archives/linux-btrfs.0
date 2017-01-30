Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:40199 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbdA3VCZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 16:02:25 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0UKMm2V005147
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 20:22:49 GMT
Date: Mon, 30 Jan 2017 12:21:00 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix leak of subvolume writers counter
Message-ID: <20170130202100.GB10490@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1485583614-26225-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485583614-26225-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 28, 2017 at 06:06:54AM +0000, fdmanana@kernel.org wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> When falling back from a nocow write to a regular cow write, we were
> leaking the subvolume writers counter in 2 situations, preventing
> snapshot creation from ever completing in the future, as it waits
> for that counter to go down to zero before the snapshot creation
> starts.
> 
> In run_delalloc_nocow, maybe not release subv_writers conter,
> will lead to create snapshot hang.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> [Improved changelog and subject]
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/inode.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a713d9d..7221d66 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1404,10 +1404,16 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  			 * either valid or do not exist.
>  			 */
>  			if (csum_exist_in_range(fs_info, disk_bytenr,
> -						num_bytes))
> +						num_bytes)) {
> +				if (!nolock)
> +					btrfs_end_write_no_snapshoting(root);
>  				goto out_check;
> -			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr))
> +			}
> +			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr)) {
> +				if (!nolock)
> +					btrfs_end_write_no_snapshoting(root);
>  				goto out_check;
> +			}
>  			nocow = 1;
>  		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
>  			extent_end = found_key.offset +
> -- 
> 2.7.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
