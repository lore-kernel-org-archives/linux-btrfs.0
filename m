Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42453 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752120AbdI2R6U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 13:58:20 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42F04ABB3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 17:58:19 +0000 (UTC)
Date: Fri, 29 Sep 2017 19:56:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [PATCH v3 2/2] btrfs: Remove received_uuid during received
 snapshot ro->rw switch
Message-ID: <20170929175645.GV31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170927140007.GH31640@twin.jikos.cz>
 <1506585198-32494-1-git-send-email-nborisov@suse.com>
 <1506585198-32494-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506585198-32494-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 28, 2017 at 10:53:18AM +0300, Nikolay Borisov wrote:
> Currently when a read-only snapshot is received and subsequently its ro property
> is set to false i.e. switched to rw-mode the received_uuid of that subvol remains
> intact. However, once the received volume is switched to RW mode we cannot
> guaranteee that it contains the same data, so it makes sense to remove the
> received uuid. The presence of the received_uuid can also cause problems when
> the volume is being send.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> v3:
>  * Rework the patch considering latest feedback from David Sterba i.e. 
>  explicitly use btrfs_end_transaction 
> 
>  fs/btrfs/ioctl.c | 36 +++++++++++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ee4ee7cbba72..c0374125cec2 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1811,6 +1811,17 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>  		goto out_drop_sem;
>  
>  	root_flags = btrfs_root_flags(&root->root_item);
> +
> +	/*
> +	 * 1 - root item
> +	 * 1 - uuid item
> +	 */
> +	trans = btrfs_start_transaction(root, 2);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out_drop_sem;
> +	}
> +
>  	if (flags & BTRFS_SUBVOL_RDONLY) {
>  		btrfs_set_root_flags(&root->root_item,
>  				     root_flags | BTRFS_ROOT_SUBVOL_RDONLY);
> @@ -1824,22 +1835,33 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>  			btrfs_set_root_flags(&root->root_item,
>  				     root_flags & ~BTRFS_ROOT_SUBVOL_RDONLY);
>  			spin_unlock(&root->root_item_lock);
> +			if (!btrfs_is_empty_uuid(root->root_item.received_uuid)) {
> +				ret = btrfs_uuid_tree_rem(trans, fs_info,
> +                                          root->root_item.received_uuid,
> +                                          BTRFS_UUID_KEY_RECEIVED_SUBVOL,
> +                                          root->root_key.objectid);
> +
> +				if (ret && ret != -ENOENT) {
> +					btrfs_abort_transaction(trans, ret);
> +					btrfs_end_transaction(trans);
> +					goto out_reset;
> +				}
> +
> +				memset(root->root_item.received_uuid, 0,
> +				       BTRFS_UUID_SIZE);
> +			}
>  		} else {
>  			spin_unlock(&root->root_item_lock);
>  			btrfs_warn(fs_info,
>  				   "Attempt to set subvolume %llu read-write during send",
>  				   root->root_key.objectid);
>  			ret = -EPERM;
> -			goto out_drop_sem;
> +			btrfs_abort_transaction(trans, ret);
> +			btrfs_end_transaction(trans);
> +			goto out_reset;

Adding the transaction before the "if (flags & BTRFS_SUBVOL_RDONLY)"
condition makes it much worse. The "is subvolume in send" test is
supposed to be lightweight and should not shoot down the whole
filesystem. The usecase is explained in 2c68653787f91c62f8.

Also the received_uuid must be changed under the root_item_lock.

I think it should be fine to keep the transaction start where it is,
change the received_uuid eventually and let it commit. You can set the
transaction units to 2 unconditionally.

>  		}
>  	}
>  
> -	trans = btrfs_start_transaction(root, 1);
> -	if (IS_ERR(trans)) {
> -		ret = PTR_ERR(trans);
> -		goto out_reset;
> -	}
> -
>  	ret = btrfs_update_root(trans, fs_info->tree_root,
>  				&root->root_key, &root->root_item);
>  	if (ret < 0) {
