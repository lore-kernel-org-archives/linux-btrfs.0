Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44626 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbeIKEhl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 00:37:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id r1-v6so11237474pgp.11
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 16:41:16 -0700 (PDT)
Date: Mon, 10 Sep 2018 16:41:14 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: tests: group declarations of self-test helpers
Message-ID: <20180910234114.GC16436@vader>
References: <cover.1536599879.git.dsterba@suse.com>
 <f97be987031016b1f48e819261aa69db2c609647.1536599879.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f97be987031016b1f48e819261aa69db2c609647.1536599879.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2018 at 07:22:29PM +0200, David Sterba wrote:

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index ee05857cc8ac..32d2fce4ac53 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3194,9 +3194,6 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
>  				    u64 start, u64 num_bytes, u64 min_size,
>  				    loff_t actual_len, u64 *alloc_hint);
>  extern const struct dentry_operations btrfs_dentry_operations;
> -#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> -void btrfs_test_inode_set_ops(struct inode *inode);
> -#endif
>  
>  /* ioctl.c */
>  long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
> @@ -3709,6 +3706,7 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
>  
>  /* Sanity test specific functions */
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> +void btrfs_test_inode_set_ops(struct inode *inode);
>  void btrfs_test_destroy_inode(struct inode *inode);
>  #endif
>  
> -- 
> 2.18.0
> 
