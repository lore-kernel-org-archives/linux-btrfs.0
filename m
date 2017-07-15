Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21878 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdGOEqX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Jul 2017 00:46:23 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH] btrfs: allow defrag compress to override NOCOMPRESS
 attribute
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20170713131844.706-1-dsterba@suse.com>
Message-ID: <43b258b2-b808-5301-f832-44c4274aae38@oracle.com>
Date: Sat, 15 Jul 2017 12:52:34 +0800
MIME-Version: 1.0
In-Reply-To: <20170713131844.706-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 07/13/2017 09:18 PM, David Sterba wrote:
> Currently, the BTRFS_INODE_NOCOMPRESS will prevent any compression on a
> given file, except when the mount is force-compress. As users have
> reported on IRC, this will also prevent compression when requested by
> defrag (btrfs fi defrag -c file).
>
> The nocompress flag is set automatically by filesystem when the ratios
> are bad and the user would have to manually drop the bit in order to
> make defrag -c work. This is not good from the usability perspective.
> 
> This patch will raise priority for the defrag -c over nocompress, ie.
> any file with NOCOMPRESS bit set will get defragmented. The bit will
> remain untouched.
> 
> Alternate option was to also drop the nocompress bit and keep the
> decision logic as is, but I think this is not the right solution.


Now the compression set through property will act same as
'-o compress-force'. Before this patch is was like '-o compress'.
I am ok to fix that patch with a new patch.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/inode.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5d3c6ac960fd..ea2f02ec0394 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -399,12 +399,14 @@ static inline int inode_need_compress(struct inode *inode)
>   	/* force compress */
>   	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
>   		return 1;
> +	/* force compress when called from defrag */
> +	if (BTRFS_I(inode)->force_compress)
> +		return 1;
>   	/* bad compression ratios */
>   	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
>   		return 0;
>   	if (btrfs_test_opt(fs_info, COMPRESS) ||
> -	    BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
> -	    BTRFS_I(inode)->force_compress)
> +	    BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS)
>   		return 1;
>   	return 0;
>   }
> 
