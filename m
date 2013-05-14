Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63355 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab3ENLaS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 07:30:18 -0400
Message-ID: <5192208A.4070802@cn.fujitsu.com>
Date: Tue, 14 May 2013 19:31:22 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/4] Btrfs: remove unnecessary ->s_umount in cleaner_kthread()
References: <1368526843-18000-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368526843-18000-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 14 May 2013 18:20:40 +0800, Miao Xie wrote:
> In order to avoid the R/O remount, we acquired ->s_umount lock during
> we deleted the dead snapshots and subvolumes. But it is unnecessary,
> because we have cleaner_mutex.
> 
> We use cleaner_mutex to protect the process of the dead snapshots/subvolumes
> deletion. And when we remount the fs to be R/O, we also acquire this mutex to
> do cleanup after we change the status of the fs. That is this lock can serialize
> the above operations, the cleaner can be aware of the status of the fs, and if
> the cleaner is deleting the dead snapshots/subvolumes, the remount task will
> wait for it. So it is safe to remove ->s_umount in cleaner_kthread().

According to my test, this patch can also fix the deadlock problem which is caused
by the race between autodefragger and freeze(xfstest 068).

Thanks
Miao

> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/disk-io.c | 40 ++++++++++++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a9df562..cb2bfd1 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1676,24 +1676,40 @@ static void end_workqueue_fn(struct btrfs_work *work)
>  	bio_endio(bio, error);
>  }
>  
> +/*
> + * If we remount the fs to be R/O, the cleaner needn't do anything except
> + * sleeping. This function is used to check the status of the fs.
> + */
> +static inline int need_cleaner_sleep(struct btrfs_root *root)
> +{
> +	return root->fs_info->sb->s_flags & MS_RDONLY;
> +}
> +
>  static int cleaner_kthread(void *arg)
>  {
>  	struct btrfs_root *root = arg;
> +	int again;
>  
>  	do {
> -		int again = 0;
> -
> -		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
> -		    down_read_trylock(&root->fs_info->sb->s_umount)) {
> -			if (mutex_trylock(&root->fs_info->cleaner_mutex)) {
> -				btrfs_run_delayed_iputs(root);
> -				again = btrfs_clean_one_deleted_snapshot(root);
> -				mutex_unlock(&root->fs_info->cleaner_mutex);
> -			}
> -			btrfs_run_defrag_inodes(root->fs_info);
> -			up_read(&root->fs_info->sb->s_umount);
> -		}
> +		again = 0;
>  
> +		/* Make the cleaner go to sleep early. */
> +		if (need_cleaner_sleep(root))
> +			goto sleep;
> +
> +		if (!mutex_trylock(&root->fs_info->cleaner_mutex))
> +			goto sleep;
> +
> +		btrfs_run_delayed_iputs(root);
> +		again = btrfs_clean_one_deleted_snapshot(root);
> +		mutex_unlock(&root->fs_info->cleaner_mutex);
> +
> +		/*
> +		 * The defragger has dealt with the R/O remount, needn't
> +		 * do anything special here.
> +		 */
> +		btrfs_run_defrag_inodes(root->fs_info);
> +sleep:
>  		if (!try_to_freeze() && !again) {
>  			set_current_state(TASK_INTERRUPTIBLE);
>  			if (!kthread_should_stop())
> 

