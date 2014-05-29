Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaE2N3l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 09:29:41 -0400
Date: Thu, 29 May 2014 15:29:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 3/4] btrfs: dev replace should replace the sysfs entry
Message-ID: <20140529132939.GD29992@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
 <1401096626-13210-4-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401096626-13210-4-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 26, 2014 at 05:30:25PM +0800, Anand Jain wrote:
> when we replace the device its corresponding sysfs
> entry has to be replaced as well
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 9f22905..f4f8728 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -36,6 +36,7 @@
>  #include "check-integrity.h"
>  #include "rcu-string.h"
>  #include "dev-replace.h"
> +#include "sysfs.h"
>  
>  static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  				       int scrub_ret);
> @@ -562,6 +563,10 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
>  	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
>  
> +	/* replace the sysfs entry */
> +	rm_device_membership(fs_info, src_device);
> +	add_device_membership(fs_info, tgt_device);
> +
>  	btrfs_rm_dev_replace_blocked(fs_info);
>  
>  	btrfs_rm_dev_replace_srcdev(fs_info, src_device);

569         btrfs_rm_dev_replace_unblocked(fs_info);
570

The comment that follows says

571         /*
572          * this is again a consistent state where no dev_replace procedure
573          * is running, the target device is part of the filesystem, the
574          * source device is not part of the filesystem anymore and its 1st
575          * superblock is scratched out so that it is no longer marked to
576          * belong to this filesystem.
577          */

and I think this is the right place to put the sysfs updates, because the
srcdev is processed.
