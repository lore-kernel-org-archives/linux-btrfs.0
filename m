Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21260 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752478AbdFOUhw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 16:37:52 -0400
Subject: Re: [PATCH] btrfs: use GFP_KERNEL in btrfs_calc_avail_data_space
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20170615130725.466-1-dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <01c6e628-ad5e-90e6-51ab-df4e30340496@oracle.com>
Date: Fri, 16 Jun 2017 04:44:05 +0800
MIME-Version: 1.0
In-Reply-To: <20170615130725.466-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/15/2017 09:07 PM, David Sterba wrote:
> We don't hold any locks here. Inidirectly called from statfs.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/super.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 4f1cdd5058f1..6f2e68b36362 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1927,7 +1927,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
>   	}
>   
>   	devices_info = kmalloc_array(nr_devices, sizeof(*devices_info),
> -			       GFP_NOFS);
> +			       GFP_KERNEL);
>   	if (!devices_info)
>   		return -ENOMEM;
>   
> 
