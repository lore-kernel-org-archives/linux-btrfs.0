Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbeIJW6C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 18:58:02 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F5E8AF79
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 18:02:45 +0000 (UTC)
Date: Mon, 10 Sep 2018 20:02:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Make btrfs_find_device_by_path return struct
 btrfs_device
Message-ID: <20180910180228.GW24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180903094614.2667-1-nborisov@suse.com>
 <20180903094614.2667-2-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180903094614.2667-2-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 03, 2018 at 12:46:12PM +0300, Nikolay Borisov wrote:
> Currently this function returns an error code as well as uses one of
> its arguments as a return value for struct btrfs_device. Change the
> function so that it returns btrfs_device directly and use the usual
> "encode error in pointer" mechanics if something goes wrong. No
> functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/volumes.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index da86706123ff..715ea45c6c28 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2096,9 +2096,9 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
>  	call_rcu(&tgtdev->rcu, free_device_rcu);
>  }
>  
> -static int btrfs_find_device_by_path(struct btrfs_fs_info *fs_info,
> -				     const char *device_path,
> -				     struct btrfs_device **device)
> +static struct btrfs_device *
> +btrfs_find_device_by_path(struct btrfs_fs_info *fs_info,
> +			  const char *device_path)

Please don't split the type and function name, I'm going to fix that in
the remaining patches.
