Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40814 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbeIKEeC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 00:34:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id s13-v6so11243687pfi.7
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 16:37:38 -0700 (PDT)
Date: Mon, 10 Sep 2018 16:37:36 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: tests: move testing members of struct
 btrfs_root to the end
Message-ID: <20180910233736.GA16436@vader>
References: <cover.1536599879.git.dsterba@suse.com>
 <f8b15d6ea41fc91c7e8608352cd242722c4c1b3b.1536599879.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f8b15d6ea41fc91c7e8608352cd242722c4c1b3b.1536599879.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2018 at 07:22:26PM +0200, David Sterba wrote:
> The data used only for tests are better placed at the end of the
> structure so that they don't change the structure layout. All new
> members of btrfs_root should be placed before.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 45b7029d0f23..ee05857cc8ac 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1203,11 +1203,6 @@ struct btrfs_root {
>  
>  	u64 highest_objectid;
>  
> -#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> -	/* only used with CONFIG_BTRFS_FS_RUN_SANITY_TESTS is enabled */
> -	u64 alloc_bytenr;
> -#endif
> -
>  	u64 defrag_trans_start;
>  	struct btrfs_key defrag_progress;
>  	struct btrfs_key defrag_max;
> @@ -1280,6 +1275,10 @@ struct btrfs_root {
>  	spinlock_t qgroup_meta_rsv_lock;
>  	u64 qgroup_meta_rsv_pertrans;
>  	u64 qgroup_meta_rsv_prealloc;
> +
> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> +	u64 alloc_bytenr;
> +#endif
>  };
>  
>  struct btrfs_file_private {
> -- 
> 2.18.0
> 
