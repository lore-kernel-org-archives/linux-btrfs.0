Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49132 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753044AbbIHIuh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 04:50:37 -0400
Subject: Re: [PATCH] btrfs: trival fix of __btrfs_set_acl error handling
To: Sheng Yong <shengyong1@huawei.com>, <linux-btrfs@vger.kernel.org>
References: <1441702002-109706-1-git-send-email-shengyong1@huawei.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55EEA159.5060306@cn.fujitsu.com>
Date: Tue, 8 Sep 2015 16:50:33 +0800
MIME-Version: 1.0
In-Reply-To: <1441702002-109706-1-git-send-email-shengyong1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sheng Yong wrote on 2015/09/08 08:46 +0000:
> * If the allocation failed, don't free to free it, even though kfree
>    allows to free a NULL pointer.
> * If posix_acl_to_xattr() failed, cleanup the allocation and return
>    the error directly.
So, what's the point?
For me, I didn't see the pros of the change.
As kfree() allow NULL pointer, why not use it?

Thanks,
Qu
>
> Signed-off-by: Sheng Yong <shengyong1@huawei.com>
> ---
>   fs/btrfs/acl.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 9a0124a..6d01d09 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -103,18 +103,18 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
>   	if (acl) {
>   		size = posix_acl_xattr_size(acl->a_count);
>   		value = kmalloc(size, GFP_NOFS);
> -		if (!value) {
> -			ret = -ENOMEM;
> -			goto out;
> -		}
> +		if (!value)
> +			return -ENOMEM;
>
>   		ret = posix_acl_to_xattr(&init_user_ns, acl, value, size);
> -		if (ret < 0)
> -			goto out;
> +		if (ret < 0) {
> +			kfree(value);
> +			return ret;
> +		}
>   	}
>
>   	ret = __btrfs_setxattr(trans, inode, name, value, size, 0);
> -out:
> +
>   	kfree(value);
>
>   	if (!ret)
>
