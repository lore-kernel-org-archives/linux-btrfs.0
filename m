Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39792 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751332AbeGJKls (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 06:41:48 -0400
Date: Tue, 10 Jul 2018 12:41:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: code reorder in btrfs_prepare_sprout
Message-ID: <20180710104144.GP3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180709083353.14517-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180709083353.14517-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 09, 2018 at 04:33:52PM +0800, Anand Jain wrote:
> No functional change, bring the clone of fs_devices and its
> operations closer, so that it indicates its purpose.
> 
> Also add a comment to indicate why we clone the fs_devices.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b63aae267ebe..0e92969b1adc 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2276,18 +2276,21 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
>  	if (!fs_devices->seeding)
>  		return -EINVAL;
>  
> -	seed_devices = alloc_fs_devices(NULL);
> -	if (IS_ERR(seed_devices))
> -		return PTR_ERR(seed_devices);
> -
> +	/*
> +	 * This step ensures the scanned seed device remains scanned,
> +	 * its not a must for the sprout operation though.
> +	 */
>  	old_devices = clone_fs_devices(fs_devices);
>  	if (IS_ERR(old_devices)) {
>  		kfree(seed_devices);

seed_devices is uninitialized here.

>  		return PTR_ERR(old_devices);
>  	}
> -
>  	list_add(&old_devices->fs_list, &fs_uuids);
>  
> +	seed_devices = alloc_fs_devices(NULL);
> +	if (IS_ERR(seed_devices))
> +		return PTR_ERR(seed_devices);

If this fails, is it ok to leave the old_devices in the list? I think it
would be better to do all the allocations first and then do the rest so
the error handling is a bit simpler.

> +
>  	memcpy(seed_devices, fs_devices, sizeof(*seed_devices));
>  	seed_devices->opened = 1;
>  	INIT_LIST_HEAD(&seed_devices->devices);
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
