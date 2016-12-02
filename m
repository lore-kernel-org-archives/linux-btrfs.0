Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33459 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbcLBWcn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Dec 2016 17:32:43 -0500
Received: by mail-pg0-f41.google.com with SMTP id 3so111971979pgd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Dec 2016 14:32:43 -0800 (PST)
Date: Fri, 2 Dec 2016 14:32:36 -0800
From: Omar Sandoval <osandov@osandov.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/18] btrfs: call functions that overwrite their root
 parameter with fs_info
Message-ID: <20161202223236.GA17540@vader.DHCP.thefacebook.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
 <1480655258-15400-2-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480655258-15400-2-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 02, 2016 at 12:07:21AM -0500, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> There are 11 functions that accept a root parameter and immediately
> overwrite it.  We can pass those an fs_info pointer instead.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/ctree.h            |  4 ++--
>  fs/btrfs/disk-io.c          |  4 ++--
>  fs/btrfs/extent-tree.c      | 17 +++++++-------
>  fs/btrfs/file-item.c        |  5 ++---
>  fs/btrfs/free-space-cache.c |  5 ++---
>  fs/btrfs/free-space-cache.h |  2 +-
>  fs/btrfs/transaction.c      |  9 ++++----
>  fs/btrfs/tree-log.c         |  6 ++---
>  fs/btrfs/volumes.c          | 55 +++++++++++++++++++++------------------------
>  fs/btrfs/volumes.h          |  4 ++--
>  10 files changed, 52 insertions(+), 59 deletions(-)
> 

[snip]

>  int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
> -		       struct btrfs_root *root, u64 chunk_offset)
> +		       struct btrfs_fs_info *fs_info, u64 chunk_offset)
>  {
> +	struct btrfs_root *root = fs_info->chunk_root;
>  	struct extent_map_tree *em_tree;
>  	struct extent_map *em;
>  	struct btrfs_root *extent_root = root->fs_info->extent_root;
> @@ -2812,8 +2811,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
>  	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
>  
>  	/* Just in case */
> -	root = root->fs_info->chunk_root;
> -	em_tree = &root->fs_info->mapping_tree.map_tree;
> +	em_tree = &fs_info->mapping_tree.map_tree;

I think this "Just in case" comment was referring to the reassignment of
the root, so it's just confusing now.
