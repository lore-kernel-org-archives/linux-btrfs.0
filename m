Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39735 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbdBPALj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 19:11:39 -0500
Date: Wed, 15 Feb 2017 16:10:33 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 25/29] btrfs: remove unused parameter from
 clone_copy_inline_extent
Message-ID: <20170216001033.GO19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <3f8bfd048583e3c93e834305b46152b05c76b70a.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3f8bfd048583e3c93e834305b46152b05c76b70a.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:38AM +0100, David Sterba wrote:
> Never used.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ioctl.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 1f13f8416d29..b9e6f8a4f760 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3383,8 +3383,7 @@ static void clone_update_extent_map(struct inode *inode,
>   * data into the destination inode's inline extent if the later is greater then
>   * the former.
>   */
> -static int clone_copy_inline_extent(struct inode *src,
> -				    struct inode *dst,
> +static int clone_copy_inline_extent(struct inode *dst,
>  				    struct btrfs_trans_handle *trans,
>  				    struct btrfs_path *path,
>  				    struct btrfs_key *new_key,
> @@ -3763,7 +3762,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>  				size -= skip + trim;
>  				datal -= skip + trim;
>  
> -				ret = clone_copy_inline_extent(src, inode,
> +				ret = clone_copy_inline_extent(inode,
>  							       trans, path,
>  							       &new_key,
>  							       drop_start,
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
