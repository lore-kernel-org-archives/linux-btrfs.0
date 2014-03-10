Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbaCJXQA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 19:16:00 -0400
Date: Tue, 11 Mar 2014 00:15:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Guangyu Sun <guangyu.sun@oracle.com>
Cc: linux-btrfs@vger.kernel.org, koen.de.wit@oracle.com
Subject: Re: [PATCH] Btrfs: return EPERM when deleting a default subvolume
Message-ID: <20140310231558.GU7004@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1394235706-24780-1-git-send-email-guangyu.sun@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394235706-24780-1-git-send-email-guangyu.sun@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 07, 2014 at 03:41:46PM -0800, Guangyu Sun wrote:
> The error message is confusing:
> 
>  # btrfs sub delete /mnt/mysub/
>  Delete subvolume '/mnt/mysub'
>  ERROR: cannot delete '/mnt/mysub' - Directory not empty
> 
> The error message does not make sense to me: It's not about deleting a
> directory but it's a subvolume, and it doesn't matter if the subvolume is
> empty or not.
> 
> Maybe EPERM or is more appropriate in this case, combined with an explanatory
> kernel log message. (e.g. "subvolume with ID 123 cannot be deleted because
> it is configured as default subvolume.")

Agreed, EPERM is better.

> Reported-by: Koen De Wit <koen.de.wit@oracle.com>
> Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
> ---
>  fs/btrfs/ioctl.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a6d8efa..c380854 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1797,7 +1797,10 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
>  	if (di && !IS_ERR(di)) {
>  		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
>  		if (key.objectid == root->root_key.objectid) {
> -			ret = -ENOTEMPTY;
> +			ret = -EPERM;
> +			printk(KERN_ERR "subvolume %llu cannot be deleted "

Please use btrfs_err instead of bare printk. The message seems a bit
long to me, how about

"deleting default subvolume %llu is not allowed"

> +			       "because it is configured as default "
> +			       "subvolume.\n", key.objectid);
>  			goto out;
>  		}
>  		btrfs_release_path(path);
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
