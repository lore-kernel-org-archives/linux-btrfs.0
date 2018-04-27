Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758615AbeD0Qgh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 12:36:37 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C618AAC64
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 16:36:36 +0000 (UTC)
Date: Fri, 27 Apr 2018 18:34:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: qgroup, don't try to insert status item after
 ENOMEM in rescan worker
Message-ID: <20180427163403.GG21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180426192351.473-1-jeffm@suse.com>
 <20180426192351.473-3-jeffm@suse.com>
 <471d8f08-ee33-80c7-67be-d35d5df6f166@suse.com>
 <20180427154425.GB21272@twin.jikos.cz>
 <b688d761-ff7f-2fe8-484d-f29eac58a0b5@suse.com>
 <eec3082b-a8e2-1adb-f1f9-27c20a92dbd3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eec3082b-a8e2-1adb-f1f9-27c20a92dbd3@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 12:11:00PM -0400, Jeff Mahoney wrote:
> If we fail to allocate memory for a path, don't bother trying to
> insert the qgroup status item.  We haven't done anything yet and it'll
> fail also.  Just print an error and be done with it.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/qgroup.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 8de423a0c7e3..b795bad54705 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2648,7 +2648,6 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>  			btrfs_end_transaction(trans);
>  	}
>  
> -out:
>  	btrfs_free_path(path);
>  
>  	mutex_lock(&fs_info->qgroup_rescan_lock);
> @@ -2684,13 +2683,13 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>  
>  	if (btrfs_fs_closing(fs_info)) {
>  		btrfs_info(fs_info, "qgroup scan paused");
> -	} else if (err >= 0) {
> +		err = 0;
> +	} else if (err >= 0)
>  		btrfs_info(fs_info, "qgroup scan completed%s",
>  			err > 0 ? " (inconsistency flag cleared)" : "");
> -	} else {
> +out:
> +	if (err < 0)
>  		btrfs_err(fs_info, "qgroup scan failed with %d", err);

Ah right, with the err = 0 in the fs_closing check we won't see both
messages reported, "qgroup scan paused" and "qgroup scan failed with %d".

Reviewed-by: David Sterba <dsterba@suse.com>

> -	}
> -
>  done:
>  	mutex_lock(&fs_info->qgroup_rescan_lock);
>  	fs_info->qgroup_rescan_running = false;
> -- 
> 2.12.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
