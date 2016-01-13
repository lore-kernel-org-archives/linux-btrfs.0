Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21922 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbcAMSQR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 13:16:17 -0500
Date: Wed, 13 Jan 2016 10:16:11 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] Btrfs: clean up an error code in btrfs_init_space_info()
Message-ID: <20160113181611.GB13918@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20160113122117.GB19993@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160113122117.GB19993@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2016 at 03:21:17PM +0300, Dan Carpenter wrote:
> If we return 1 here, then the caller treats it as an error and returns
> -EINVAL.  It causes a static checker warning to treat positive returns
> as an error.
> 
> Fixes: 1aba86d67f34 ('Btrfs: fix easily get into ENOSPC in mixed case')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I would appreciate a little review here.  This patch doesn't change
> behavior, but it's possible that we had intended to do something else.
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 60cc139..64649f8e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10586,7 +10586,7 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
>  
>  	disk_super = fs_info->super_copy;
>  	if (!btrfs_super_root(disk_super))
> -		return 1;
> +		return -EINVAL;

Thank you for this, Dan.

While we're here, I'd suggest to remove this check as tree_root->node has already been readed from btrfs_super_root().

Thanks,

-liubo

>  
>  	features = btrfs_super_incompat_flags(disk_super);
>  	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
