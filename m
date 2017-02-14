Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23483 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdBNCAs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 21:00:48 -0500
Date: Mon, 13 Feb 2017 17:59:53 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/29] btrfs: remove unused parameter from
 write_dev_supers
Message-ID: <20170214015953.GB24037@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <6a514256c5f13576cc002182224e39be8a2bc05e.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6a514256c5f13576cc002182224e39be8a2bc05e.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:36AM +0100, David Sterba wrote:
> The barriers are handled by the caller.
>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 48846d215e97..43e71457c193 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3410,7 +3410,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
>   */
>  static int write_dev_supers(struct btrfs_device *device,
>  			    struct btrfs_super_block *sb,
> -			    int do_barriers, int wait, int max_mirrors)
> +			    int wait, int max_mirrors)
>  {
>  	struct buffer_head *bh;
>  	int i;
> @@ -3752,7 +3752,7 @@ static int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>  		flags = btrfs_super_flags(sb);
>  		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
>  
> -		ret = write_dev_supers(dev, sb, do_barriers, 0, max_mirrors);
> +		ret = write_dev_supers(dev, sb, 0, max_mirrors);
>  		if (ret)
>  			total_errors++;
>  	}
> @@ -3775,7 +3775,7 @@ static int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>  		if (!dev->in_fs_metadata || !dev->writeable)
>  			continue;
>  
> -		ret = write_dev_supers(dev, sb, do_barriers, 1, max_mirrors);
> +		ret = write_dev_supers(dev, sb, 1, max_mirrors);
>  		if (ret)
>  			total_errors++;
>  	}
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
