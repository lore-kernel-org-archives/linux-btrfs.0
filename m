Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965704AbdIZRlO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 13:41:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B036AD7A
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 17:41:12 +0000 (UTC)
Date: Tue, 26 Sep 2017 19:39:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [PATCH 1/2] btrfs: Abort transaction if btrfs_update_root fails
 in btrfs_ioctl_subvol_setflags
Message-ID: <20170926173939.GV31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506436062-23825-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506436062-23825-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 26, 2017 at 05:27:41PM +0300, Nikolay Borisov wrote:
> btrfs_update_root can fail for any number of reasons, however the only error
> handling we do is to revert the modified flags, yet we do not abort the
> transaction but proceed to commit it.

AFAICS btrfs_update_root aborts the transaction itself, so it's not
needed in the caller.

> Fix this by explicitly checking if the
> update root routine has failed and abort the transaction.
> 
> Fixes: 0caa102da827 ("Btrfs: Add BTRFS_IOC_SUBVOL_GETFLAGS/SETFLAGS ioctls")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index d6715c2bcdc4..09fcd51f0e8c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1842,8 +1842,11 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>  
>  	ret = btrfs_update_root(trans, fs_info->tree_root,
>  				&root->root_key, &root->root_item);
> +	if (ret < 0)
> +		btrfs_abort_transaction(trans, ret);
>  
>  	btrfs_commit_transaction(trans);

I think the error from commit_transaction should be returned as well if
we get here.

So:

ret = btrfs_update_root();

if (ret < 0) {
	end_transaction();
	goto out_reset;
}

ret = btrfs_commit_transaction();

out_reset:
/* and then as it is */
if (ret)
	btrfs_set_root_flags(...);

etc.



> +
>  out_reset:
>  	if (ret)
>  		btrfs_set_root_flags(&root->root_item, root_flags);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
