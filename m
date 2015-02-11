Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbbBKSlN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 13:41:13 -0500
Date: Wed, 11 Feb 2015 19:41:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 24/24] Btrfs: sysfs: add check if super kobject is
 already initialized
Message-ID: <20150211184111.GK28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
 <1423439785-10260-25-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423439785-10260-25-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Missing signed-off-by

On Mon, Feb 09, 2015 at 07:56:25AM +0800, Anand Jain wrote:
> ---
>  fs/btrfs/sysfs.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index f8358d2..5c555da 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -750,10 +750,14 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
>  	int error = 0;
>  
>  	while (fs_devs) {
> -		init_completion(&fs_devs->kobj_unregister);
> -		fs_devs->super_kobj.kset = btrfs_kset;
> -		error = kobject_init_and_add(&fs_devs->super_kobj,
> +		if (!fs_devs->super_kobj.state_initialized) {
> +			init_completion(&fs_devs->kobj_unregister);
> +			fs_devs->super_kobj.kset = btrfs_kset;
> +			error = kobject_init_and_add(&fs_devs->super_kobj,
>  				&btrfs_ktype, parent, "%pU", fs_devs->fsid);
> +		} else {
> +			error = -EINVAL;
> +		}
>  		if (!follow_seed)
>  			return error;
>  		parent = &fs_devs->super_kobj;
> -- 
> 2.0.0.153.g79dcccc
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
