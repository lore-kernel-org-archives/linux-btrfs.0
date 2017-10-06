Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752292AbdJFRgE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:36:04 -0400
Date: Fri, 6 Oct 2017 19:34:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, nborisov@suse.com
Subject: Re: [PATCH v3 1/5] btrfs: Move leaf and node validation checker to
 tree-checker.c
Message-ID: <20171006173420.GX3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170929064849.15086-1-quwenruo.btrfs@gmx.com>
 <20170929064849.15086-2-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170929064849.15086-2-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 06:48:45AM +0000, Qu Wenruo wrote:
> It's no doubt the comprehensive tree block checker will become larger
> and larger, so move them into their own file is quite reasonable.
> 
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> ---
>  fs/btrfs/Makefile       |   2 +-
>  fs/btrfs/ctree.h        |   4 +
>  fs/btrfs/disk-io.c      | 284 +-------------------------------------------
>  fs/btrfs/tree-checker.c | 309 ++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 317 insertions(+), 282 deletions(-)
>  create mode 100644 fs/btrfs/tree-checker.c
> 
> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> index 962a95aefb81..88255e133ade 100644
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
>  	   export.o tree-log.o free-space-cache.o zlib.o lzo.o zstd.o \
>  	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
>  	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
> -	   uuid-tree.o props.o hash.o free-space-tree.o
> +	   uuid-tree.o props.o hash.o free-space-tree.o tree-checker.o
>  
>  btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
>  btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index ea9c5648ff70..6b7c6fcbc5d5 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3732,4 +3732,8 @@ static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
>  #endif
>  	return 0;
>  }
> +
> +/* Tree block validation checker */
> +int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf);
> +int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node);
>  #endif

Please add tree-checker.h for such definitions.
