Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751788AbeEQMNS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 08:13:18 -0400
Date: Thu, 17 May 2018 14:10:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: fix BUG trying to resume balance without
 resume flag
Message-ID: <20180517121036.GK6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180517071651.29404-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180517071651.29404-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2018 at 03:16:51PM +0800, Anand Jain wrote:
> We set the BTRFS_BALANCE_RESUME flag in the btrfs_recover_balance()
> only, which isn't called during the remount. So when resuming from
> the paused balance we hit the BUG.
> 
>  kernel: kernel BUG at fs/btrfs/volumes.c:3890!
>  ::
>  kernel:  balance_kthread+0x51/0x60 [btrfs]
>  kernel:  kthread+0x111/0x130
>  ::
>  kernel: RIP: btrfs_balance+0x12e1/0x1570 [btrfs] RSP: ffffba7d0090bde8
> 
> Reproducer:
>   On a mounted BTRFS.
> 
>   btrfs balance start --full-balance /btrfs
>   btrfs balance pause /btrfs
>   mount -o remount,ro /dev/sdb /btrfs
>   mount -o remount,rw /dev/sdb /btrfs
> 
> To fix this set the BTRFS_BALANCE_RESUME flag in btrfs_resume_balance_async().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
> v2->v3: . Hold fs_info->balance_lock because in remount context there can
> 	be more the one thread accessing the balance_ctl.
> 	. Don't remove the BTRFS_BALANCE_RESUME set at recover_balance
> 	as in the original code.
> 	. Add comments.
> v1->v2: btrfs_resume_balance_async() can be called only from remount or
>         mount, we don't need to hold fs_info->balance_lock.
> 
>  fs/btrfs/volumes.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 40e4259bdd51..c68976856d87 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4112,6 +4112,15 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
>  		return 0;
>  	}
>  
> +	/*
> +	 * A remount ro->rw sequence should continue with the
> +	 * paused balance irrespective of who pauses it, system or
> +	 * the user as of now, so set the resume flag.
> +	 */

Please format comments to full 80 column width. Fixed.
