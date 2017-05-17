Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34394 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750944AbdEQSdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 14:33:21 -0400
Date: Wed, 17 May 2017 20:32:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] Btrfs: record error if one block has failed to retry
Message-ID: <20170517183222.GL4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
 <1492478187-24875-5-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492478187-24875-5-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 06:16:25PM -0700, Liu Bo wrote:
> In the nocsum case of dio read endio, it will return immediately if an
> error got returned when repairing, which left the rest blocks unrepaired.
> The behavior is different from how buffered read endio works in the same
> case.  This changes it to record error only and go on repairing the rest
> blocks.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
>  fs/btrfs/inode.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index fca2f1f..cc46d21 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7942,6 +7942,7 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
>  	u32 sectorsize;
>  	int nr_sectors;
>  	int ret;
> +	int err;
>  
>  	fs_info = BTRFS_I(inode)->root->fs_info;
>  	sectorsize = fs_info->sectorsize;
> @@ -7962,8 +7963,10 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
>  				pgoff, start, start + sectorsize - 1,
>  				io_bio->mirror_num,
>  				btrfs_retry_endio_nocsum, &done);
> -		if (ret)
> -			return ret;
> +		if (ret) {
> +			err = ret;
> +			goto next;
> +		}
>  
>  		wait_for_completion(&done.done);
>  
> @@ -7972,6 +7975,7 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
>  			goto next_block_or_try_again;
>  		}
>  
> +next:
>  		start += sectorsize;
>  
>  		if (nr_sectors--) {
> @@ -7980,7 +7984,7 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
>  		}
>  	}
>  
> -	return 0;
> +	return err;
>  }
>  
>  static void btrfs_retry_endio(struct bio *bio)
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
