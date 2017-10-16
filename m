Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47383 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752209AbdJPOre (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:47:34 -0400
Date: Mon, 16 Oct 2017 16:45:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove BUG_ON in
 btrfs_rm_dev_replace_free_srcdev()
Message-ID: <20171016144547.GR3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171012090041.7438-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171012090041.7438-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 12, 2017 at 05:00:41PM +0800, Anand Jain wrote:
> That was only an extra check to tackle few bugs around this
> area, now its save to remove it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 332e00e72b86..0a5251a34d58 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2015,16 +2015,12 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
>  	}
>  
>  	btrfs_close_bdev(srcdev);
> -
>  	call_rcu(&srcdev->rcu, free_device);
>  
>  	/*
> -	 * unless fs_devices is seed fs, num_devices shouldn't go
> -	 * zero
> +	 * If this is no devs we rather delete the fs_devices
> +	 * which is true in case of single device seeding fs.

Can you please rephrase the first part of the comment? I'm not sure I
understand what it's trying to say.

>  	 */
> -	BUG_ON(!fs_devices->num_devices && !fs_devices->seeding);

I think we could still keep the check as an ASSERT.

> -
> -	/* if this is no devs we rather delete the fs_devices */
>  	if (!fs_devices->num_devices) {
>  		struct btrfs_fs_devices *tmp_fs_devices;
>  
