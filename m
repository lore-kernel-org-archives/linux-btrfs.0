Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59665 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754906AbeBOI3N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 03:29:13 -0500
Subject: Re: [PATCH] btrfs: remove unused function btrfs_async_submit_limit()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180215033607.14236-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e86cf203-fb50-d12c-39f1-1918d10c6acf@suse.com>
Date: Thu, 15 Feb 2018 10:29:10 +0200
MIME-Version: 1.0
In-Reply-To: <20180215033607.14236-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.02.2018 05:36, Anand Jain wrote:
> Commit [1] removed the need to use btrfs_async_submit_limit(), so
> delete it.
> 
> [1]
>  commit 736cd52e0c720103f52ab9da47b6cc3af6b083f6
>   Btrfs: remove nr_async_submits and async_submit_draining
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/disk-io.c | 8 --------
>  fs/btrfs/disk-io.h | 1 -
>  2 files changed, 9 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index aca906971abe..c412ad1f103b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -709,14 +709,6 @@ blk_status_t btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
>  	return 0;
>  }
>  
> -unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
> -{
> -	unsigned long limit = min_t(unsigned long,
> -				    info->thread_pool_size,
> -				    info->fs_devices->open_devices);
> -	return 256 * limit;
> -}
> -
>  static void run_one_async_start(struct btrfs_work *work)
>  {
>  	struct async_submit_bio *async;
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 301151a50ac1..e2ac6a14150a 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -133,7 +133,6 @@ blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>  			u64 bio_offset, void *private_data,
>  			extent_submit_bio_hook_t *submit_bio_start,
>  			extent_submit_bio_hook_t *submit_bio_done);
> -unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
>  int btrfs_write_tree_block(struct extent_buffer *buf);
>  void btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
>  int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
> 
