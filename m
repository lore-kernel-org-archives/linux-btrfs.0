Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47069 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdK3WJP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 17:09:15 -0500
Subject: Re: [PATCH 2/4] btrfs: SETFLAGS ioctl: use helper for compression
 type conversion
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1512058075.git.dsterba@suse.com>
 <233097e27401c0f3163e7dc7c72442f50309705a.1512058075.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f2ae8299-098a-3e87-2a04-f1b9558043d8@oracle.com>
Date: Fri, 1 Dec 2017 06:08:53 +0800
MIME-Version: 1.0
In-Reply-To: <233097e27401c0f3163e7dc7c72442f50309705a.1512058075.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/01/2017 12:09 AM, David Sterba wrote:
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/ioctl.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e8adebc8c1b0..c41c259d9283 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -307,12 +307,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>   		ip->flags |= BTRFS_INODE_COMPRESS;
>   		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
>   
> -		if (fs_info->compress_type == BTRFS_COMPRESS_LZO)
> -			comp = "lzo";
> -		else if (fs_info->compress_type == BTRFS_COMPRESS_ZLIB)
> -			comp = "zlib";
> -		else
> -			comp = "zstd";

  Bit deviating from the stuff here. Looks like zstd changed the default
  compression algo to zstd (from zlib). I remember seeing your comment
  on that too which I thought is fixed, but now I can't locate. Shouldn't
  this be a bug ?

Thanks, Anand


> +		comp = btrfs_compress_type2str(fs_info->compress_type);
> +		if (!comp || comp[0] == 0)
> +			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
> +
>   		ret = btrfs_set_prop(inode, "btrfs.compression",
>   				     comp, strlen(comp), 0);
>   		if (ret)
> 
