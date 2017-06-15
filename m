Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45454 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbdFOVHQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 17:07:16 -0400
Subject: Re: [PATCH] btrfs: use GFP_KERNEL in btrfs_init_dev_replace_tgtdev
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20170615151510.2781-1-dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <83448935-de7d-8d03-38d8-3ac64c0235b9@oracle.com>
Date: Fri, 16 Jun 2017 05:12:28 +0800
MIME-Version: 1.0
In-Reply-To: <20170615151510.2781-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/15/2017 11:15 PM, David Sterba wrote:
> The function is called from ioctl context and we don't hold any locks
> that take part in writeback. Right now it's only fs_info::volume_mutex.

  yeah volume_mutex is fine.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/dev-replace.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index c6cd1d599c36..f7df85509125 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -242,7 +242,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>   		goto error;
>   	}
>   
> -	name = rcu_string_strdup(device_path, GFP_NOFS);
> +	name = rcu_string_strdup(device_path, GFP_KERNEL);
>   	if (!name) {
>   		kfree(device);
>   		ret = -ENOMEM;
> 
