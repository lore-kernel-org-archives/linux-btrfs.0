Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53107 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756732AbeEJIX4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 04:23:56 -0400
Subject: Re: [PATCH 05/10] Btrfs: don't release reserve or decrement orphan
 count if orphan item already existed
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
References: <cover.1525932796.git.osandov@fb.com>
 <ea8803dda4166f74f674385d81f96c6b0e8256f5.1525932796.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5332f05d-9f18-8165-b115-d05eab36c156@suse.com>
Date: Thu, 10 May 2018 11:23:54 +0300
MIME-Version: 1.0
In-Reply-To: <ea8803dda4166f74f674385d81f96c6b0e8256f5.1525932796.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.05.2018 09:21, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Currently, if btrfs_insert_orphan_item() fails, we release the reserved
> space and decrement root->orphan_inodes. However, we also ignore -EEXIST
> errors, so we still want the space reservation for when we delete the
> item, and we still need to count the orphan because we're still going to
> decrement root->orphan_inodes from btrfs_orphan_del() later.
> 
> Fixes: 4ef31a45a009 ("Btrfs: fix the error handling wrt orphan items")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/inode.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1460823951d7..e77df96de642 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3408,7 +3408,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
>  	/* insert an orphan item to track this unlinked file */
>  	if (insert) {
>  		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
> -		if (ret) {
> +		if (ret && ret != -EEXIST) {
>  			if (reserve) {
>  				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
>  					  &inode->runtime_flags);
> @@ -3420,14 +3420,11 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
>  			 * decrease ->orphan_inodes after everything is done.
>  			 */
>  			atomic_dec(&root->orphan_inodes);
> -			if (ret != -EEXIST) {
> -				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> -					  &inode->runtime_flags);
> -				btrfs_abort_transaction(trans, ret);
> -				return ret;
> -			}
> +			clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> +				  &inode->runtime_flags);
> +			btrfs_abort_transaction(trans, ret);
> +			return ret;
>  		}
> -		ret = 0;
>  	}
>  
>  	return 0;
> 
