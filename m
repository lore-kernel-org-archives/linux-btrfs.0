Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41425 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750917AbdGNHFB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 03:05:01 -0400
Subject: Re: [PATCH] Btrfs: fix unexpected return value of bio_readpage_error
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170713220050.22720-1-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ea29b0c9-d5b1-7dbb-8e51-6659940b42b3@suse.com>
Date: Fri, 14 Jul 2017 10:04:58 +0300
MIME-Version: 1.0
In-Reply-To: <20170713220050.22720-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.07.2017 01:00, Liu Bo wrote:
> With blk_status_t, in bio_readpage_error() may return 1 as now
> ->submit_bio_hook() may not set %ret if it runs without problem.
> 
> This fixes that unexpected return value by changing
> btrfs_check_repairable() to return a bool instead of updating %ret.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent_io.c | 12 ++++++------
>  fs/btrfs/extent_io.h |  4 ++--
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 556484c..098c319 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2258,7 +2258,7 @@ int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
>  	return 0;
>  }
>  
> -int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
> +bool btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
>  			   struct io_failure_record *failrec, int failed_mirror)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> @@ -2274,7 +2274,7 @@ int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
>  		btrfs_debug(fs_info,
>  			"Check Repairable: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d",
>  			num_copies, failrec->this_mirror, failed_mirror);
> -		return 0;
> +		return false;
>  	}
>  
>  	/*
> @@ -2315,10 +2315,10 @@ int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
>  		btrfs_debug(fs_info,
>  			"Check Repairable: (fail) num_copies=%d, next_mirror %d, failed_mirror %d",
>  			num_copies, failrec->this_mirror, failed_mirror);
> -		return 0;
> +		return false;
>  	}
>  
> -	return 1;
> +	return true;
>  }
>  
>  
> @@ -2382,8 +2382,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
>  	if (ret)
>  		return ret;
>  
> -	ret = btrfs_check_repairable(inode, failed_bio, failrec, failed_mirror);
> -	if (!ret) {
> +	if (!btrfs_check_repairable(inode, failed_bio, failrec,
> +				    failed_mirror)) {
>  		free_io_failure(failure_tree, tree, failrec);
>  		return -EIO;
>  	}
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 3fb8513..4f03091 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -539,8 +539,8 @@ void btrfs_free_io_failure_record(struct btrfs_inode *inode, u64 start,
>  		u64 end);
>  int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
>  				struct io_failure_record **failrec_ret);
> -int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
> -			   struct io_failure_record *failrec, int fail_mirror);
> +bool btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
> +			    struct io_failure_record *failrec, int fail_mirror);
>  struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
>  				    struct io_failure_record *failrec,
>  				    struct page *page, int pg_offset, int icsum,
> 
