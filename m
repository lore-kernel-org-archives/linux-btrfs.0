Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:54352 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdKLRLZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 12:11:25 -0500
Subject: Re: [PATCH v4] btrfs: Remove received_uuid during received snapshot
 ro->rw switch
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <20171004150039.GE3521@twin.jikos.cz>
 <1507191773-23039-1-git-send-email-nborisov@suse.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <56af8081-3ecb-7a70-0e9a-b05220c608b3@mendix.com>
Date: Sun, 12 Nov 2017 18:11:22 +0100
MIME-Version: 1.0
In-Reply-To: <1507191773-23039-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/05/2017 10:22 AM, Nikolay Borisov wrote:
> Currently when a read-only snapshot is received and subsequently its ro property
> is set to false i.e. switched to rw-mode the received_uuid of that subvol remains
> intact. However, once the received volume is switched to RW mode we cannot
> guaranteee that it contains the same data, so it makes sense to remove the
> received uuid. The presence of the received_uuid can also cause problems when
> the volume is being send.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Suggested-by: David Sterba <dsterba@suse.cz>
> ---
> 
> v4: 
>  * Put the uuid tree removal code after the lightweight 'send in progress' 
>  check and don't move btrfs_start_transaction as suggested by David
>  
> v3:
>  * Rework the patch considering latest feedback from David Sterba i.e. 
>   explicitly use btrfs_end_transaction 
> 
>  fs/btrfs/ioctl.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ee4ee7cbba72..9328c091854b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1775,6 +1775,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>  	struct btrfs_trans_handle *trans;
>  	u64 root_flags;
>  	u64 flags;
> +	bool clear_received_uuid = false;
>  	int ret = 0;
>  
>  	if (!inode_owner_or_capable(inode))
> @@ -1824,6 +1825,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>  			btrfs_set_root_flags(&root->root_item,
>  				     root_flags & ~BTRFS_ROOT_SUBVOL_RDONLY);
>  			spin_unlock(&root->root_item_lock);
> +			clear_received_uuid = true;
>  		} else {
>  			spin_unlock(&root->root_item_lock);
>  			btrfs_warn(fs_info,
> @@ -1840,6 +1842,24 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>  		goto out_reset;
>  	}
>  
> +	if (clear_received_uuid) {
> +	        if (!btrfs_is_empty_uuid(root->root_item.received_uuid)) {
> +	                ret = btrfs_uuid_tree_rem(trans, fs_info,
> +	                                root->root_item.received_uuid,
> +	                                BTRFS_UUID_KEY_RECEIVED_SUBVOL,
> +	                                root->root_key.objectid);
> +
> +	                if (ret && ret != -ENOENT) {
> +	                        btrfs_abort_transaction(trans, ret);
> +	                        btrfs_end_transaction(trans);
> +	                        goto out_reset;
> +	                }
> +
> +	                memset(root->root_item.received_uuid, 0,
> +	                                BTRFS_UUID_SIZE);

Shouldn't we also wipe the other related fields here, like stime, rtime,
stransid, rtransid?

> +	        }
> +	}
> +
>  	ret = btrfs_update_root(trans, fs_info->tree_root,
>  				&root->root_key, &root->root_item);
>  	if (ret < 0) {
> 


-- 
Hans van Kranenburg
