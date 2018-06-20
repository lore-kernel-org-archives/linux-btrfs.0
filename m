Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57251 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752827AbeFTOJA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 10:09:00 -0400
Date: Wed, 20 Jun 2018 16:06:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: fix race between mkfs and mount
Message-ID: <20180620140608.GB24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180604150030.12883-1-anand.jain@oracle.com>
 <20180604150030.12883-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180604150030.12883-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 04, 2018 at 11:00:30PM +0800, Anand Jain wrote:
> In an instrumented testing it is possible that the mount and
> a newer mkfs.btrfs thread on the same device can race and if the new
> mkfs.btrfs wins it will free the older fs_devices, then the mount thread
> will lead to oops.
> 
> Thread1						Thread2
> -------						-------
> mkfs.btrfs -fq /dev/sdb
> mount /dev/sdb /btrfs
> |_btrfs_mount_root()
>   |_btrfs_scan_one_device(... &fs_devices)
> 
> 						mkfs.btrfs -fq /dev/sdb
> 						|_btrfs_contol_ioctl()
> 						  |_btrfs_scan_one_device(... &fs_devices)
> 						    |_::
> 						      |_btrfs_free_stale_devices()
> 
>   |_btrfs_open_devices(fs_devices ..) <-- stale fs_devices.
> 
> Fix this with a mutually exclusive flag BTRFS_VOL_FLAG_EXCL_OPS.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/super.c   |  6 ++++++
>  fs/btrfs/volumes.c | 10 +++++++++-
>  fs/btrfs/volumes.h |  1 +
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index f0c13defc9eb..b60e7cbe39f5 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1565,7 +1565,13 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
>  		goto error_fs_info;
>  	}
>  
> +	if (test_and_set_bit(BTRFS_VOLUME_STATE_EXCL_OPS, &fs_devices->volume_state)) {
> +		error = -EBUSY;

We'd need to wait until the bit is not set instead of BUSY, as the
parallel scan is not really a reason to fail the whole mount.

I'll post the patch series to address this problem today, it utilizes
the uuid_mutex in a similar way you try to do with the new bit, but it
will not lead to EBUSY.
