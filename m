Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35433 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754389AbdLTJaf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 04:30:35 -0500
Subject: Re: [PATCH v2 2/2] btrfs: handle volume split brain condition for
 dynamically reappearing device
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171220080403.12702-1-anand.jain@oracle.com>
 <20171220080403.12702-2-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3b2b817f-fe6f-defc-c78c-9e26faddf95a@suse.com>
Date: Wed, 20 Dec 2017 11:30:33 +0200
MIME-Version: 1.0
In-Reply-To: <20171220080403.12702-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.12.2017 10:04, Anand Jain wrote:
> When the missing device reappears and joins the RAID group, and if there
> are no more missing device at the volume level, then reset the
> BTRFS_SUPER_FLAG_VOL_MOVED_ON flag.

You should rename the flag here as well. Also I believe the changelog
can be simplified:

When the last missing device in a RAID group joins we know the split
brain situation is resolved and we reset the SUPER_FLAG_DEGRADED.

> 
> This patch is on top of the patch [1] in the ML.
> [1] btrfs: handle dynamically reappearing missing device
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> On top of misc-next kdave.
> v2:
>  Rename to BTRFS_SUPER_FLAG_DEGRADED.
> 
>  fs/btrfs/volumes.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 65d10f38dd99..32571f4fa72b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -858,6 +858,10 @@ static noinline int device_list_add(const char *path,
>  
>  			fs_devices->missing_devices--;
>  			clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
> +			if (!fs_devices->missing_devices)
> +				btrfs_set_super_flags(fs_info->super_copy,
> +						      fs_info->super_copy->flags &
> +						      ~BTRFS_SUPER_FLAG_DEGRADED);
>  
>  			if (test_bit(BTRFS_DEV_STATE_WRITEABLE,
>  				     &device->dev_state) &&
> 
