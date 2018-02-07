Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17171 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753462AbeBGJ1V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 04:27:21 -0500
Subject: Re: [PATCH] btrfs: Don't hardcode the csum size in
 btrfs_ordered_sum_size
To: Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1517995150-28081-1-git-send-email-nborisov@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <e77a1f6b-16e1-c8b5-cfe9-d0275f5c8f25@cn.fujitsu.com>
Date: Wed, 7 Feb 2018 17:32:08 +0800
MIME-Version: 1.0
In-Reply-To: <1517995150-28081-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/07/2018 05:19 PM, Nikolay Borisov wrote:
> Currently the function uses a hardcoded value for the checksum size of
> a sector. This is fine, given that we currently support only a single
> algorithm, whose checksum is 4 bytes == sizeof(u32). Despite not
> having other algorithms, btrfs' design supports using a different
> algorithm whith different space requirements. To future-proof the code
> query the size of the currently used algorithm from the in-memory copy
> of the super block. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/ordered-data.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 56c4c0ee6381..c53e2cfb72d9 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -151,7 +151,9 @@ static inline int btrfs_ordered_sum_size(struct btrfs_fs_info *fs_info,
>   					 unsigned long bytes)
>   {
>   	int num_sectors = (int)DIV_ROUND_UP(bytes, fs_info->sectorsize);
> -	return sizeof(struct btrfs_ordered_sum) + num_sectors * sizeof(u32);
> +	int csum_size = btrfs_super_csum_size(fs_info->super_copy);
> +
> +	return sizeof(struct btrfs_ordered_sum) + num_sectors * csum_size;
>   }
>   
>   static inline void
> 


