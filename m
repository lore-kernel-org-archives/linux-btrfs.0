Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45230 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbeIHBpF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 21:45:05 -0400
Received: by mail-pg1-f193.google.com with SMTP id x26-v6so7543044pge.12
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 14:02:22 -0700 (PDT)
Date: Fri, 7 Sep 2018 14:02:20 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/11] btrfs: open code btrfs_dev_replace_stats_inc
Message-ID: <20180907210220.GF29245@vader>
References: <cover.1536331604.git.dsterba@suse.com>
 <111cb329e58b7b24af11c248e861859997cbfc89.1536331604.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <111cb329e58b7b24af11c248e861859997cbfc89.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2018 at 04:55:06PM +0200, David Sterba wrote:
> The wrapper is too trivial, open coding does not make it less readable.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/dev-replace.h |  5 -----
>  fs/btrfs/scrub.c       | 11 ++++-------
>  2 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
> index 39f022c457ff..1c91bf9ef39a 100644
> --- a/fs/btrfs/dev-replace.h
> +++ b/fs/btrfs/dev-replace.h
> @@ -29,9 +29,4 @@ void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace);
>  void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace);
>  void btrfs_dev_replace_set_lock_blocking(struct btrfs_dev_replace *dev_replace);
>  
> -static inline void btrfs_dev_replace_stats_inc(atomic64_t *stat_value)
> -{
> -	atomic64_inc(stat_value);
> -}
> -
>  #endif
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 4bcc275f7612..902819d3cf41 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1124,7 +1124,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>  
>  			if (scrub_write_page_to_dev_replace(sblock_other,
>  							    page_num) != 0) {
> -				btrfs_dev_replace_stats_inc(
> +				atomic64_inc(
>  					&fs_info->dev_replace.num_write_errors);
>  				success = 0;
>  			}
> @@ -1564,8 +1564,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
>  		if (btrfsic_submit_bio_wait(bio)) {
>  			btrfs_dev_stat_inc_and_print(page_bad->dev,
>  				BTRFS_DEV_STAT_WRITE_ERRS);
> -			btrfs_dev_replace_stats_inc(
> -				&fs_info->dev_replace.num_write_errors);
> +			atomic64_inc(&fs_info->dev_replace.num_write_errors);
>  			bio_put(bio);
>  			return -EIO;
>  		}
> @@ -1592,8 +1591,7 @@ static void scrub_write_block_to_dev_replace(struct scrub_block *sblock)
>  
>  		ret = scrub_write_page_to_dev_replace(sblock, page_num);
>  		if (ret)
> -			btrfs_dev_replace_stats_inc(
> -				&fs_info->dev_replace.num_write_errors);
> +			atomic64_inc(&fs_info->dev_replace.num_write_errors);
>  	}
>  }
>  
> @@ -1726,8 +1724,7 @@ static void scrub_wr_bio_end_io_worker(struct btrfs_work *work)
>  			struct scrub_page *spage = sbio->pagev[i];
>  
>  			spage->io_error = 1;
> -			btrfs_dev_replace_stats_inc(&dev_replace->
> -						    num_write_errors);
> +			atomic64_inc(&dev_replace->num_write_errors);
>  		}
>  	}
>  
> -- 
> 2.18.0
> 
