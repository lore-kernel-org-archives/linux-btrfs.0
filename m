Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17273 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752416AbdBPAJp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 19:09:45 -0500
Date: Wed, 15 Feb 2017 16:08:45 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 26/29] btrfs: remove unused parameter from __add_inode_ref
Message-ID: <20170216000845.GN19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <6ab7d2d469a0a929ce89feaf9bd8938dd3c1754f.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6ab7d2d469a0a929ce89feaf9bd8938dd3c1754f.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:41AM +0100, David Sterba wrote:
> Unused since the helper has been split, eb used in the caller.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/tree-log.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 62dd138018b5..3806853cde08 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -994,7 +994,6 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
>  				  struct btrfs_root *log_root,
>  				  struct btrfs_inode *dir,
>  				  struct btrfs_inode *inode,
> -				  struct extent_buffer *eb,
>  				  u64 inode_objectid, u64 parent_objectid,
>  				  u64 ref_index, char *name, int namelen,
>  				  int *search_done)
> @@ -1310,7 +1309,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  			if (!search_done) {
>  				ret = __add_inode_ref(trans, root, path, log,
>  						      BTRFS_I(dir),
> -						      BTRFS_I(inode), eb,
> +						      BTRFS_I(inode),
>  						      inode_objectid,
>  						      parent_objectid,
>  						      ref_index, name, namelen,
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
