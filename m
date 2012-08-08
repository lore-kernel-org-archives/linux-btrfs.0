Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:46870 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030476Ab2HHRTF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 13:19:05 -0400
Date: Wed, 8 Aug 2012 19:19:00 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix enospc problems when deleting a subvol
Message-ID: <20120808171900.GZ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1344442379-5645-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1344442379-5645-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 08, 2012 at 12:12:59PM -0400, Josef Bacik wrote:
> Subvol delete is a special kind of awful where we use the global reserve to
> cover the ENOSPC requirements.  The problem is once we're done removing
> everything we do a btrfs_update_inode(), which by default will try to do the
> delayed update stuff which will use it's own reserve.  There will be no
> space in this reserve and we'll return ENOSPC.  So instead use
> btrfs_update_inode_fallback() which will just fallback to updating the inode
> item in the case of enospc.  This is fine because the global reserve covers
> the space requirements for this.  With this patch I can now delete a subvol
> on a problem image Dave Sterba sent me.  Thanks,

Thanks for the fix, tested on my side as well.

> Reported-by: David Sterba <dave@jikos.cz>
Tested-by: David Sterba <dsterba@suse.cz>

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 7ab714f..1a58373 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3172,7 +3172,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>  	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
>  	inode_inc_iversion(dir);
>  	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
> -	ret = btrfs_update_inode(trans, root, dir);
> +	ret = btrfs_update_inode_fallback(trans, root, dir);
>  	if (ret)
>  		btrfs_abort_transaction(trans, root, ret);
>  out:
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
