Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:23831 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753740AbeEaGmj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 02:42:39 -0400
Subject: Re: [PATCH] Btrfs: checking for NULL instead of IS_ERR
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20180531062111.374pq6lxrmdffun6@kili.mountain>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <d51ba220-ca4c-c79e-51c9-1f3a21ecbde6@jp.fujitsu.com>
Date: Thu, 31 May 2018 15:41:41 +0900
MIME-Version: 1.0
In-Reply-To: <20180531062111.374pq6lxrmdffun6@kili.mountain>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks again.

David, could you apply this on top of my v7 patch in for-next tree?

Regards,
Tomohiro Misono

On 2018/05/31 15:21, Dan Carpenter wrote:
> memdup_user() returns error pointers, it doesn't return NULL.
> 
> Fixes: 01141b08dee5 ("btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ff5018587bd9..d8dd4504bdab 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2791,9 +2791,9 @@ static noinline int btrfs_ioctl_get_subvol_rootref(struct file *file,
>  		return -ENOMEM;
>  
>  	rootrefs = memdup_user(argp, sizeof(*rootrefs));
> -	if (!rootrefs) {
> +	if (IS_ERR(rootrefs)) {
>  		btrfs_free_path(path);
> -		return -ENOMEM;
> +		return PTR_ERR(rootrefs);
>  	}
>  
>  	inode = file_inode(file);
> 
> 

