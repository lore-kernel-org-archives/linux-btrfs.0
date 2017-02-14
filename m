Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37035 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754201AbdBNThW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 14:37:22 -0500
Date: Tue, 14 Feb 2017 11:36:26 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 21/29] btrfs: remove unused parameter from create_snapshot
Message-ID: <20170214193626.GE31091@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <f4031b3ded1796ebf212a2b2c94e17344f625540.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f4031b3ded1796ebf212a2b2c94e17344f625540.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:26AM +0100, David Sterba wrote:
> The name parameters have never been used, as the name is passed via the
> dentry.
>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e8c7c313c113..91188a2ac5a1 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -656,7 +656,7 @@ static void btrfs_wait_for_no_snapshoting_writes(struct btrfs_root *root)
>  }
>  
>  static int create_snapshot(struct btrfs_root *root, struct inode *dir,
> -			   struct dentry *dentry, char *name, int namelen,
> +			   struct dentry *dentry,
>  			   u64 *async_transid, bool readonly,
>  			   struct btrfs_qgroup_inherit *inherit)
>  {
> @@ -871,7 +871,7 @@ static noinline int btrfs_mksubvol(const struct path *parent,
>  		goto out_up_read;
>  
>  	if (snap_src) {
> -		error = create_snapshot(snap_src, dir, dentry, name, namelen,
> +		error = create_snapshot(snap_src, dir, dentry,
>  					async_transid, readonly, inherit);
>  	} else {
>  		error = create_subvol(dir, dentry, name, namelen,
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
