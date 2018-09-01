Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43567 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbeIAEYw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2018 00:24:52 -0400
Received: by mail-yw1-f66.google.com with SMTP id l189-v6so5641234ywb.10
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 17:14:57 -0700 (PDT)
Date: Fri, 31 Aug 2018 17:14:52 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/35] btrfs: protect space cache inode alloc with nofs
Message-ID: <20180901001452.GC29370@vader>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-10-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830174225.2200-10-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:41:59PM -0400, Josef Bacik wrote:
> If we're allocating a new space cache inode it's likely going to be
> under a transaction handle, so we need to use memalloc_nofs_save() in
> order to avoid deadlocks, and more importantly lockdep messages that
> make xfstests fail.

Could use a comment where we call memalloc_nofs_save(). Otherwise,

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/free-space-cache.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index c3888c113d81..db93a5f035a0 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -10,6 +10,7 @@
>  #include <linux/math64.h>
>  #include <linux/ratelimit.h>
>  #include <linux/error-injection.h>
> +#include <linux/sched/mm.h>
>  #include "ctree.h"
>  #include "free-space-cache.h"
>  #include "transaction.h"
> @@ -47,6 +48,7 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
>  	struct btrfs_free_space_header *header;
>  	struct extent_buffer *leaf;
>  	struct inode *inode = NULL;
> +	unsigned nofs_flag;
>  	int ret;
>  
>  	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
> @@ -68,7 +70,9 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
>  	btrfs_disk_key_to_cpu(&location, &disk_key);
>  	btrfs_release_path(path);
>  
> +	nofs_flag = memalloc_nofs_save();
>  	inode = btrfs_iget(fs_info->sb, &location, root, NULL);
> +	memalloc_nofs_restore(nofs_flag);
>  	if (IS_ERR(inode))
>  		return inode;
>  
> -- 
> 2.14.3
> 
