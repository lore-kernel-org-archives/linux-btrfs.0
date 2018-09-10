Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38136 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbeIKEj4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 00:39:56 -0400
Received: by mail-pg1-f196.google.com with SMTP id t84-v6so9409539pgb.5
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 16:43:30 -0700 (PDT)
Date: Mon, 10 Sep 2018 16:43:29 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: tests: polish ifdefs around testing helper
Message-ID: <20180910234329.GD16436@vader>
References: <cover.1536599879.git.dsterba@suse.com>
 <7a6c4814d8467999d9a9eb12906ff28a3f90b284.1536599879.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7a6c4814d8467999d9a9eb12906ff28a3f90b284.1536599879.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2018 at 07:22:31PM +0200, David Sterba wrote:
> Avoid the inline ifdefs and use two sections for self-tests enabled and
> disabled.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 32d2fce4ac53..8dafc7bb6ad8 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3708,17 +3708,20 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>  void btrfs_test_inode_set_ops(struct inode *inode);
>  void btrfs_test_destroy_inode(struct inode *inode);
> -#endif
>  
>  static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
>  {
> -#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>  	if (unlikely(test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO,
>  			      &fs_info->fs_state)))
>  		return 1;
> -#endif
>  	return 0;

How about just:

	return test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_state);

We can probably get away without the unlikely() considering that no one
sane is going to run a kernel with CONFIG_BTRFS_FS_RUN_SANITY_TESTS in
production.
