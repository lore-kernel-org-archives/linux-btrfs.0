Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42504 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbeIQXJF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 19:09:05 -0400
Received: by mail-pf1-f193.google.com with SMTP id l9-v6so7882753pff.9
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 10:40:42 -0700 (PDT)
Date: Mon, 17 Sep 2018 10:40:40 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4 v2] btrfs: tests: polish ifdefs around testing helper
Message-ID: <20180917174040.GA6409@vader>
References: <20180911191447.GA26631@vader>
 <20180914164203.19235-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180914164203.19235-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2018 at 06:42:03PM +0200, David Sterba wrote:
> Avoid the inline ifdefs and use two sections for self-tests enabled and
> disabled.
> 
> Though there could be no ifdef and unconditional test_bit of
> BTRFS_FS_STATE_DUMMY_FS_INFO, the static inline can help to optimize out
> any code that would depend on conditions using btrfs_is_testing.
> 
> As this is only for the testing code, drop unlikely().

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> 
> v2:
> - remove unlikely
> - simplify to: return test_bit(...)
> 
>  fs/btrfs/ctree.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 32d2fce4ac53..1656ada9200b 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3708,17 +3708,17 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>  void btrfs_test_inode_set_ops(struct inode *inode);
>  void btrfs_test_destroy_inode(struct inode *inode);
> -#endif
>  
>  static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
>  {
> -#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> -	if (unlikely(test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO,
> -			      &fs_info->fs_state)))
> -		return 1;
> -#endif
> +	return test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_state);
> +}
> +#else
> +static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
> +{
>  	return 0;
>  }
> +#endif
>  
>  static inline void cond_wake_up(struct wait_queue_head *wq)
>  {
> -- 
> 2.18.0
> 
