Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36696 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdBOV3e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:29:34 -0500
Date: Wed, 15 Feb 2017 13:27:40 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 18/29] btrfs: remove unused parameter from
 btrfs_fill_super
Message-ID: <20170215212740.GH19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <a644ec1f6d10a61e4f0f5fcb313cf9d0894e9876.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a644ec1f6d10a61e4f0f5fcb313cf9d0894e9876.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:16AM +0100, David Sterba wrote:
> Never used for anything meaningful since we have our own superblock
> filler.
> 
Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/super.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 93ed29c2a38b..da687dc79cce 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1114,7 +1114,7 @@ static int get_default_subvol_objectid(struct btrfs_fs_info *fs_info, u64 *objec
>  
>  static int btrfs_fill_super(struct super_block *sb,
>  			    struct btrfs_fs_devices *fs_devices,
> -			    void *data, int silent)
> +			    void *data)
>  {
>  	struct inode *inode;
>  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
> @@ -1611,8 +1611,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  	} else {
>  		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
>  		btrfs_sb(s)->bdev_holder = fs_type;
> -		error = btrfs_fill_super(s, fs_devices, data,
> -					 flags & MS_SILENT ? 1 : 0);
> +		error = btrfs_fill_super(s, fs_devices, data);
>  	}
>  	if (error) {
>  		deactivate_locked_super(s);
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
