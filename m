Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51850 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751595AbdBTGmk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 01:42:40 -0500
Subject: Re: [PATCH 7/7] Btrfs: convert BUG_ON to WARN_ON
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
 <1487381301-865-8-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b6d3bf2b-7966-741b-548a-8d8210572601@cn.fujitsu.com>
Date: Mon, 20 Feb 2017 14:42:28 +0800
MIME-Version: 1.0
In-Reply-To: <1487381301-865-8-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/18/2017 09:28 AM, Liu Bo wrote:
> These two BUG_ON()s would never be true, ensured by callers' logic.

Never a bad idea to remove BUG_ON.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujits.com>

Thanks,
Qu
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/volumes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 4a334a9..ce74b6c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5170,7 +5170,7 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
>  	unsigned long len = fs_info->sectorsize;
>
>  	em = get_chunk_map(fs_info, logical, len);
> -	BUG_ON(IS_ERR(em));
> +	WARN_ON(IS_ERR(em));
>
>  	map = em->map_lookup;
>  	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
> @@ -5187,7 +5187,7 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
>  	int ret = 0;
>
>  	em = get_chunk_map(fs_info, logical, len);
> -	BUG_ON(IS_ERR(em));
> +	WARN_ON(IS_ERR(em));
>
>  	map = em->map_lookup;
>  	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
>


