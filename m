Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55274 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726963AbeHJNO7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 09:14:59 -0400
Date: Fri, 10 Aug 2018 12:45:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 2/2] btrfs: add helper btrfs_num_devices() to deduce
 num_devices
Message-ID: <20180810104531.GY3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180810055321.19730-1-anand.jain@oracle.com>
 <20180810055321.19730-4-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180810055321.19730-4-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 01:53:21PM +0800, Anand Jain wrote:
> When the replace is running the fs_devices::num_devices also includes
> the replace device, however in some operations like device delete and
> balance it needs the actual num_devices without the repalce devices, so
> now the function btrfs_num_devices() just provides that.
> 
> And here is a scenario how balance and repalce items could co-exist.
> Consider balance is started and paused, now start the replace
> followed by a unmount or power-recycle of the system. During following
> mount, the open_ctree() first restarts the balance so it must check for
> the replace device otherwise our num_devices calculation will be wrong.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v4->v5: uses assert.
> v3->v4: add comment and drop the inline (sorry missed it before)
> v2->v3: update changelog with not so obvious balance and repalce
> co-existance secnario
> v1->v2: add comments
> 
>  fs/btrfs/volumes.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0062615a79be..630f9ec158d0 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1863,6 +1863,21 @@ void btrfs_assign_next_active_device(struct btrfs_device *device,
>  		fs_info->fs_devices->latest_bdev = next_device->bdev;
>  }
>  
> +/* Returns btrfs_fs_devices::num_devices excluding replace device if any */
> +static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
> +{
> +	u64 num_devices = fs_info->fs_devices->num_devices;
> +
> +	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
> +	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> +		ASSERT(num_devices > 0);
> +		num_devices--;
> +	}
> +	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);

I'll move the assert with the updated condition here so it covers also
the non dev-replace case. Otherwise ok.

> +
> +	return num_devices;
> +}
