Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:65092 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbdI0LwY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 07:52:24 -0400
Subject: Re: [PATCH] btrfs: take the error path out if
 btrfs_attach_transaction() fails
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170927095052.22663-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <952a7d17-bdfa-2659-5e5e-0e8a59b0c62b@gmx.com>
Date: Wed, 27 Sep 2017 19:52:11 +0800
MIME-Version: 1.0
In-Reply-To: <20170927095052.22663-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月27日 17:50, Anand Jain wrote:
> btrfs_init_new_device() calls btrfs_attach_transaction() to
> commit sys chunks, however take the error path out if it fails.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Thanks,
Qu

> ---
>   fs/btrfs/volumes.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index fad3b10a1f81..b526d13a74da 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2494,7 +2494,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>   		if (IS_ERR(trans)) {
>   			if (PTR_ERR(trans) == -ENOENT)
>   				return 0;
> -			return PTR_ERR(trans);
> +			ret = PTR_ERR(trans);
> +			goto error_sysfs;
>   		}
>   		ret = btrfs_commit_transaction(trans);
>   	}
> 
