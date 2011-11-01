From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 17/21] Btrfs: allow for pausing restriper
Date: Tue, 01 Nov 2011 12:46:28 +0100
Message-ID: <4EAFDC14.9040200@gmx.net>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com> <1314129722-31601-18-git-send-email-idryomov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-18-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 23.08.2011 22:01, Ilya Dryomov wrote:
> Implement an ioctl for pausing restriper.  This pauses the relocation,
> but restripe is still considered to be "in progress": restriper item is
> not deleted, other volume operations cannot be started, etc.  If paused
> in the middle of profile changing operation we will continue making
> allocations with the target profile.
> 
> Add a hook to close_ctree() to be able to pause restriper and free it's
> data structures on unmount.  (It's safe to unmount when restriper is in
> 'paused' state, we will resume with the same parameters on the next
> mount)
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/btrfs/disk-io.c |    3 +++
>  fs/btrfs/ioctl.c   |    2 ++
>  fs/btrfs/ioctl.h   |    1 +
>  fs/btrfs/volumes.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
>  fs/btrfs/volumes.h |    2 ++
>  5 files changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 662a6e6..7db5c50 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2542,6 +2542,9 @@ int close_ctree(struct btrfs_root *root)
>  	fs_info->closing = 1;
>  	smp_mb();
>  
> +	/* pause restriper and free restripe_ctl */
> +	btrfs_pause_restripe(root->fs_info, 1);
> +
>  	btrfs_scrub_cancel(root);
>  
>  	/* wait for any defraggers to finish */
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index d8bdb67..61978ac 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2921,6 +2921,8 @@ static long btrfs_ioctl_restripe_ctl(struct btrfs_root *root,
>  	switch (cmd) {
>  	case BTRFS_RESTRIPE_CTL_CANCEL:
>  		return btrfs_cancel_restripe(root->fs_info);
> +	case BTRFS_RESTRIPE_CTL_PAUSE:
> +		return btrfs_pause_restripe(root->fs_info, 0);
>  	}
>  
>  	return -EINVAL;
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 4f6ead5..e468d5b 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -110,6 +110,7 @@ struct btrfs_ioctl_fs_info_args {
>  };
>  
>  #define BTRFS_RESTRIPE_CTL_CANCEL	1
> +#define BTRFS_RESTRIPE_CTL_PAUSE	2
>  
>  struct btrfs_restripe_args {
>  	__u64 profiles;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index cd43368..65deaa7 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2555,7 +2555,8 @@ static int __btrfs_restripe(struct btrfs_root *dev_root)
>  	while (1) {
>  		struct btrfs_fs_info *fs_info = dev_root->fs_info;
>  
> -		if (test_bit(RESTRIPE_CANCEL_REQ, &fs_info->restripe_state)) {
> +		if (test_bit(RESTRIPE_CANCEL_REQ, &fs_info->restripe_state) ||
> +		    test_bit(RESTRIPE_PAUSE_REQ, &fs_info->restripe_state)) {
>  			ret = -ECANCELED;
>  			goto error;
>  		}
> @@ -2730,7 +2731,9 @@ do_restripe:
>  	mutex_lock(&fs_info->restripe_mutex);
>  	clear_bit(RESTRIPE_RUNNING, &fs_info->restripe_state);
>  
> -	if (test_bit(RESTRIPE_CANCEL_REQ, &fs_info->restripe_state)) {
> +	if (test_bit(RESTRIPE_CANCEL_REQ, &fs_info->restripe_state) ||
> +	    (!test_bit(RESTRIPE_PAUSE_REQ, &fs_info->restripe_state) &&
> +	     !test_bit(RESTRIPE_CANCEL_REQ, &fs_info->restripe_state))) {
>  		mutex_lock(&fs_info->volume_mutex);
>  
>  		unset_restripe_control(fs_info);
> @@ -2858,6 +2861,43 @@ out:
>  	return ret;
>  }

I don't see a difference in what CANCEL_REQ and PAUSE_REQ do, so it seems
one of them would be enough.

>  
> +int btrfs_pause_restripe(struct btrfs_fs_info *fs_info, int unset)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&fs_info->restripe_mutex);
> +	if (!fs_info->restripe_ctl) {
> +		ret = -ENOTCONN;
> +		goto out;
> +	}
> +
> +	/* only running restripe can be paused */
> +	if (!test_bit(RESTRIPE_RUNNING, &fs_info->restripe_state)) {
> +		ret = -ENOTCONN;
> +		goto out_unset;
> +	}
> +
> +	set_bit(RESTRIPE_PAUSE_REQ, &fs_info->restripe_state);
> +	while (test_bit(RESTRIPE_RUNNING, &fs_info->restripe_state)) {
> +		mutex_unlock(&fs_info->restripe_mutex);
> +		wait_event(fs_info->restripe_wait,
> +			   !test_bit(RESTRIPE_RUNNING,
> +				     &fs_info->restripe_state));
> +		mutex_lock(&fs_info->restripe_mutex);
> +	}
> +	clear_bit(RESTRIPE_PAUSE_REQ, &fs_info->restripe_state);
> +
> +out_unset:
> +	if (unset) {
> +		mutex_lock(&fs_info->volume_mutex);
> +		unset_restripe_control(fs_info);
> +		mutex_unlock(&fs_info->volume_mutex);
> +	}
> +out:
> +	mutex_unlock(&fs_info->restripe_mutex);
> +	return ret;
> +}
> +

This looks very similar to cancel_restripe. It should be easy to
merge them to one function without making a mess out of it.

>  /*
>   * shrinking a device means finding all of the device extents past
>   * the new size, and then following the back refs to the chunks.
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index dd1fa7f..b8c234a 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -204,6 +204,7 @@ struct map_lookup {
>   */
>  #define RESTRIPE_RUNNING	0
>  #define RESTRIPE_CANCEL_REQ	1
> +#define RESTRIPE_PAUSE_REQ	2
>  
>  struct btrfs_restripe_args;
>  struct restripe_control {
> @@ -261,6 +262,7 @@ int btrfs_balance(struct btrfs_root *dev_root);
>  int btrfs_restripe(struct restripe_control *rctl, int resume);
>  int btrfs_recover_restripe(struct btrfs_root *tree_root);
>  int btrfs_cancel_restripe(struct btrfs_fs_info *fs_info);
> +int btrfs_pause_restripe(struct btrfs_fs_info *fs_info, int unset);
>  int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
>  int find_free_dev_extent(struct btrfs_trans_handle *trans,
>  			 struct btrfs_device *device, u64 num_bytes,

