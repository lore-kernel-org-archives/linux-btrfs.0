Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:48985 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754058AbdCTWLX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 18:11:23 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v2KL6mJU020525
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Mar 2017 21:06:48 GMT
Date: Mon, 20 Mar 2017 14:04:20 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: remove redundant parameter from
 reada_start_machine_dev
Message-ID: <20170320210420.GI5540@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1489593696.git.dsterba@suse.com>
 <f8008e872818951e0f38474c6871e9e7e8a671ac.1489593696.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f8008e872818951e0f38474c6871e9e7e8a671ac.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 15, 2017 at 05:02:39PM +0100, David Sterba wrote:
> We can read fs_info from dev.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/reada.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
> index c1fc79cd4b2a..91df381a60ce 100644
> --- a/fs/btrfs/reada.c
> +++ b/fs/btrfs/reada.c
> @@ -649,9 +649,9 @@ static int reada_pick_zone(struct btrfs_device *dev)
>  	return 1;
>  }
>  
> -static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
> -				   struct btrfs_device *dev)
> +static int reada_start_machine_dev(struct btrfs_device *dev)
>  {
> +	struct btrfs_fs_info *fs_info = dev->fs_info;
>  	struct reada_extent *re = NULL;
>  	int mirror_num = 0;
>  	struct extent_buffer *eb = NULL;
> @@ -763,8 +763,7 @@ static void __reada_start_machine(struct btrfs_fs_info *fs_info)
>  		list_for_each_entry(device, &fs_devices->devices, dev_list) {
>  			if (atomic_read(&device->reada_in_flight) <
>  			    MAX_IN_FLIGHT)
> -				enqueued += reada_start_machine_dev(fs_info,
> -								    device);
> +				enqueued += reada_start_machine_dev(device);
>  		}
>  		mutex_unlock(&fs_devices->device_list_mutex);
>  		total += enqueued;
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
