Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753597AbeDTHuS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 03:50:18 -0400
Subject: Re: [PATCH v2 12/16] btrfs: track running balance in a simpler way
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <6d512cf2c8f825592703ee0d45c51f22396e6078.1524146556.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6ab5bdc1-45a2-d0a4-cdc7-587731c4103a@oracle.com>
Date: Fri, 20 Apr 2018 15:52:24 +0800
MIME-Version: 1.0
In-Reply-To: <6d512cf2c8f825592703ee0d45c51f22396e6078.1524146556.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/20/2018 12:33 AM, David Sterba wrote:
> Currently fs_info::balance_running is 0 or 1 and does not use the
> semantics of atomics. The pause and cancel check for 0, that can happen
> only after __btrfs_balance exits for whatever reason.
> 
> Parallel calls to balance ioctl may enter btrfs_ioctl_balance multiple
> times but will block on the balance_mutex that protects the
> fs_info::flags bit.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/ctree.h   |  6 +++++-
>   fs/btrfs/disk-io.c |  1 -
>   fs/btrfs/ioctl.c   |  6 +++---
>   fs/btrfs/volumes.c | 18 ++++++++++--------
>   4 files changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 011cb9a8a967..fda94a264eb7 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -726,6 +726,11 @@ struct btrfs_delayed_root;
>    * (device replace, resize, device add/delete, balance)
>    */
>   #define BTRFS_FS_EXCL_OP			16
> +/*
> + * Indicate that balance has been set up from the ioctl and is in the main
> + * phase. The fs_info::balance_ctl is initialized.
> + */
> +#define BTRFS_FS_BALANCE_RUNNING		17


  Change looks good to me as such and its a good idea to drop
    fs_info::balance_running;

  However instead of making BTRFS_FS_BALANCE_RUNNING part of
    btrfs_fs_info::flags
  pls make it part of
    btrfs_balance_control::flags

  Because:
  We already have BTRFS_BALANCE_RESUME there.
  And at fs_info level BTRFS_FS_EXCL_OP tells someone excl is running.
  And if its a balance (either in running or implicit-paused state)
  then btrfs_fs_info::balance_ctl is not NULL.

Thanks, Anand

>   
>   struct btrfs_fs_info {
>   	u8 fsid[BTRFS_FSID_SIZE];
> @@ -991,7 +996,6 @@ struct btrfs_fs_info {
>   	/* restriper state */
>   	spinlock_t balance_lock;
>   	struct mutex balance_mutex;
> -	atomic_t balance_running;
>   	atomic_t balance_pause_req;
>   	atomic_t balance_cancel_req;
>   	struct btrfs_balance_control *balance_ctl;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c0482ecea11f..b62559dfb053 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2168,7 +2168,6 @@ static void btrfs_init_balance(struct btrfs_fs_info *fs_info)
>   {
>   	spin_lock_init(&fs_info->balance_lock);
>   	mutex_init(&fs_info->balance_mutex);
> -	atomic_set(&fs_info->balance_running, 0);
>   	atomic_set(&fs_info->balance_pause_req, 0);
>   	atomic_set(&fs_info->balance_cancel_req, 0);
>   	fs_info->balance_ctl = NULL;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 7c99f74c200e..3dfd5ab2807b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4506,7 +4506,7 @@ void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
>   
>   	bargs->flags = bctl->flags;
>   
> -	if (atomic_read(&fs_info->balance_running))
> +	if (test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags))
>   		bargs->state |= BTRFS_BALANCE_STATE_RUNNING;
>   	if (atomic_read(&fs_info->balance_pause_req))
>   		bargs->state |= BTRFS_BALANCE_STATE_PAUSE_REQ;
> @@ -4558,7 +4558,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>   	mutex_lock(&fs_info->balance_mutex);
>   	if (fs_info->balance_ctl) {
>   		/* this is either (2) or (3) */
> -		if (!atomic_read(&fs_info->balance_running)) {
> +		if (!test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags)) {
>   			mutex_unlock(&fs_info->balance_mutex);
>   			/*
>   			 * Lock released to allow other waiters to continue,
> @@ -4567,7 +4567,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>   			mutex_lock(&fs_info->balance_mutex);
>   
>   			if (fs_info->balance_ctl &&
> -			    !atomic_read(&fs_info->balance_running)) {
> +			    !test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags)) {
>   				/* this is (3) */
>   				need_unlock = false;
>   				goto locked;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e95cc2f09fdd..a766d2f988c1 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3886,13 +3886,14 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>   		spin_unlock(&fs_info->balance_lock);
>   	}
>   
> -	atomic_inc(&fs_info->balance_running);
> +	ASSERT(!test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
> +	set_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
>   	mutex_unlock(&fs_info->balance_mutex);
>   
>   	ret = __btrfs_balance(fs_info);
>   
>   	mutex_lock(&fs_info->balance_mutex);
> -	atomic_dec(&fs_info->balance_running);
> +	clear_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
>   
>   	if (bargs) {
>   		memset(bargs, 0, sizeof(*bargs));
> @@ -4031,16 +4032,16 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
>   		return -ENOTCONN;
>   	}
>   
> -	if (atomic_read(&fs_info->balance_running)) {
> +	if (test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags)) {
>   		atomic_inc(&fs_info->balance_pause_req);
>   		mutex_unlock(&fs_info->balance_mutex);
>   
>   		wait_event(fs_info->balance_wait_q,
> -			   atomic_read(&fs_info->balance_running) == 0);
> +			   !test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
>   
>   		mutex_lock(&fs_info->balance_mutex);
>   		/* we are good with balance_ctl ripped off from under us */
> -		BUG_ON(atomic_read(&fs_info->balance_running));
> +		BUG_ON(test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
>   		atomic_dec(&fs_info->balance_pause_req);
>   	} else {
>   		ret = -ENOTCONN;
> @@ -4066,10 +4067,10 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
>   	 * if we are running just wait and return, balance item is
>   	 * deleted in btrfs_balance in this case
>   	 */
> -	if (atomic_read(&fs_info->balance_running)) {
> +	if (test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags)) {
>   		mutex_unlock(&fs_info->balance_mutex);
>   		wait_event(fs_info->balance_wait_q,
> -			   atomic_read(&fs_info->balance_running) == 0);
> +			   !test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
>   		mutex_lock(&fs_info->balance_mutex);
>   	} else {
>   		mutex_unlock(&fs_info->balance_mutex);
> @@ -4085,7 +4086,8 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
>   		}
>   	}
>   
> -	BUG_ON(fs_info->balance_ctl || atomic_read(&fs_info->balance_running));
> +	BUG_ON(fs_info->balance_ctl ||
> +		test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
>   	atomic_dec(&fs_info->balance_cancel_req);
>   	mutex_unlock(&fs_info->balance_mutex);
>   	return 0;
> 
