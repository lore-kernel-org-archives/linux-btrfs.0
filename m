Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35232 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbeIKEhW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 00:37:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id 7-v6so11267297pgf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 16:40:57 -0700 (PDT)
Date: Mon, 10 Sep 2018 16:40:55 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: tests: add separate stub for
 find_lock_delalloc_range
Message-ID: <20180910234055.GB16436@vader>
References: <cover.1536599879.git.dsterba@suse.com>
 <42d07540b52556af89366c9fee628829148bffac.1536599879.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <42d07540b52556af89366c9fee628829148bffac.1536599879.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2018 at 07:22:24PM +0200, David Sterba wrote:
> The helper find_lock_delalloc_range is now conditionally built static,
> dpending on whether the self-tests are enabled or not. There's a macro
> that is suppsed to hide the export, used only once. To discourage
> further use, drop it an add a public stub for the helper required by
> tests.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h                 |  6 ------
>  fs/btrfs/extent_io.c             | 13 ++++++++++++-
>  fs/btrfs/extent_io.h             |  2 +-
>  fs/btrfs/tests/extent-io-tests.c | 10 +++++-----
>  4 files changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2cddfe7806a4..45b7029d0f23 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -41,12 +41,6 @@ extern struct kmem_cache *btrfs_path_cachep;
>  extern struct kmem_cache *btrfs_free_space_cachep;
>  struct btrfs_ordered_sum;
>  
> -#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> -#define STATIC noinline
> -#else
> -#define STATIC static noinline
> -#endif
> -
>  #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
>  
>  #define BTRFS_MAX_MIRRORS 3
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 4dd6faab02bb..06e280d8750c 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1568,7 +1568,7 @@ static noinline int lock_delalloc_pages(struct inode *inode,
>   *
>   * 1 is returned if we find something, 0 if nothing was in the tree
>   */
> -STATIC u64 find_lock_delalloc_range(struct inode *inode,
> +static u64 find_lock_delalloc_range(struct inode *inode,

Now this won't be noinline, was that intentional? It has been since way
back in d352ac68148b ("Btrfs: add and improve comments"), presumably
because Chris wanted it in stack traces.
