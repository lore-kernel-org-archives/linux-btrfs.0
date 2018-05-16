Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49061 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752321AbeEPOhu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 10:37:50 -0400
Date: Wed, 16 May 2018 16:35:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix BUG trying to resume balance without
 resume flag
Message-ID: <20180516143508.GB6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180430094845.26229-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180430094845.26229-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2018 at 05:48:45PM +0800, Anand Jain wrote:
> We set the BTRFS_BALANCE_RESUME flag in the btrfs_recover_balance(),
> which is not called during the remount. So when resuming from the
> paused balance we hit BUG.
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
> To fix this set the BTRFS_BALANCE_RESUME flag in btrfs_resume_balance_async()
> instead of btrfs_recover_balance().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2: btrfs_resume_balance_async() can be called only from remount or
> mount, we don't need to hold fs_info->balance_lock.

For mount it's ok, there's nothing that can run in parallel, but remount
ro->rw that resumes the balance can be run with the ioctl that checks
balance status in parallel, at any time. As the fs_info::balance_ctl is
set up, btrfs_ioctl_balance_progress will proceed and return the current
status.


> Strictly speaking we should rather keep the balance at the paused state
> unless it is resumed by the user again, that means neither mount nor
> remount-rw should resume the balance automatically, former case needs
> writing balance status to the disk. Which needs compatibility
> verification.  So for now just avoid BUG. 
> 
>  fs/btrfs/volumes.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3e6983a169c4..64bcaf25908b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4115,6 +4115,8 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
>  		return 0;
>  	}
>  
> +	fs_info->balance_ctl->b_flags |= BTRFS_BALANCE_RESUME;

Though there's no update operation on flags, I think it's still better
to add the locks that set the resume status. And a comment why it's
here.

> +
>  	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
>  	return PTR_ERR_OR_ZERO(tsk);
>  }
> @@ -4156,7 +4158,6 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
>  
>  	bctl->fs_info = fs_info;
>  	bctl->flags = btrfs_balance_flags(leaf, item);
> -	bctl->flags |= BTRFS_BALANCE_RESUME;

Also, it does not hurt to leave this here, as it logically matches what
the function does: we found the balance item, thus we set the status
accordingly.

Please update and resend, I'd like to push this to 4.17-rc as it's a
crash fix with a reproducer. Thanks.
