Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:18552 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbcDNDCX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Apr 2016 23:02:23 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
	by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u3E2HQI8010153
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 02:17:26 GMT
Subject: Re: [PATCH] Btrfs: remove BUG_ON()'s in btrfs_map_block
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <1460480080-27063-1-git-send-email-jbacik@fb.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <570EFD84.90104@oracle.com>
Date: Thu, 14 Apr 2016 10:16:36 +0800
MIME-Version: 1.0
In-Reply-To: <1460480080-27063-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/13/2016 12:54 AM, Josef Bacik wrote:
> btrfs_map_block can go horribly wrong in the face of fs corruption, lets agree
> to not be assholes and panic at any possible chance things are all fucked up.
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>   fs/btrfs/volumes.c | 22 ++++++++++++++++++++--
>   1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e2b54d5..ba8216b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5278,7 +5278,18 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
>   	stripe_nr = div64_u64(stripe_nr, stripe_len);
>
>   	stripe_offset = stripe_nr * stripe_len;
> -	BUG_ON(offset < stripe_offset);
> +	if (offset < stripe_offset) {
> +		btrfs_crit(fs_info, "stripe math has gone wrong, "
> +			   "stripe_offset=%llu, offset=%llu, start=%llu, "


> +			   "logical=%llu, stripe_len=%llu\n",

  btrfs_crit adds \n suffix by its own.

> +			   (unsigned long long)stripe_offset,
> +			   (unsigned long long)offset,
> +			   (unsigned long long)em->start,
> +			   (unsigned long long)logical,
> +			   (unsigned long long)stripe_len);
> +		free_extent_map(em);
> +		return -EINVAL;
> +	}
>
>   	/* stripe_offset is the offset of this block in its stripe*/
>   	stripe_offset = offset - stripe_offset;
> @@ -5519,7 +5530,14 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
>   				&stripe_index);
>   		mirror_num = stripe_index + 1;
>   	}
> -	BUG_ON(stripe_index >= map->num_stripes);
> +	if (stripe_index >= map->num_stripes) {
> +		btrfs_crit(fs_info, "stripe index math went horribly wrong, "

> +			   "got stripe_index=%lu, num_stripes=%lu\n",

  -same-

Thanks, Anand

> +			   (unsigned long)stripe_index,
> +			   (unsigned long)map->num_stripes);
> +		ret = -EINVAL;
> +		goto out;
> +	}
>
>   	num_alloc_stripes = num_stripes;
>   	if (dev_replace_is_ongoing) {
>
