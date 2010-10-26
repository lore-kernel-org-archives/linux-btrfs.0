From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 1/6] Btrfs: fix deadlock in btrfs_commit_transaction
Date: Tue, 26 Oct 2010 14:46:08 +0800
Message-ID: <4CC67930.4030406@cn.fujitsu.com>
References: <1288033662-21464-1-git-send-email-sage@newdream.net> <1288033662-21464-2-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288033662-21464-2-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2010 03:07 AM, Sage Weil wrote:
> We calculate timeout (either 1 or MAX_SCHEDULE_TIMEOUT) based on whether
> num_writers > 1 or should_grow at the top of the loop.  Then, much much
> later, we wait for that timeout if either num_writers or should_grow is
> true.  However, it's possible for a racing process (calling
> btrfs_end_transaction()) to decrement num_writers such that we wait
> forever instead of for 1.
> 

IMO, there still exists a deadlock with your patch.
===
with your patch:

thread 1:                          thread 2:                       

btrfs_commit_transaction()
  if (num_writers > 1)
    timeout = MAX_TIMEOUT;
	                --------->
                                   __btrfs_end_transaction()
                                     num_writers--;
				     if (wq)  
                                       wake_up();
			<---------
  smp_mb();
  prepare_wait();
  if (num_writers > 1)
    schedule_timeout(MAX);
  else if (should_grow)
    schedule_timeout(1);
===

thread2 also needs a memory_barrier, for without memory_barrier, 
on some CPUs, "if (wq)" may be executed before num_writers--, like
===
thread 1:                          thread 2:                       

btrfs_commit_transaction()
  if (num_writers > 1)
    timeout = MAX_TIMEOUT;
	                --------->
                                   __btrfs_end_transaction()
                                     if (wq)  
                                       wake_up();
			<---------
  smp_mb();
  prepare_wait();
  if (num_writers > 1)
    schedule_timeout(MAX);
  else if (should_grow)
    schedule_timeout(1); 
			---------->
				      num_writers--;
===
then, thread1 may wait forever.

Since wake_up() itself provides a implied wmb, and a wq active check, 
it is better to drop "if (wq)" in __btrfs_end_transaction().


thanks,
liubo

> Fix this by deciding how long to wait when we wait.
> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/btrfs/transaction.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 66e4c66..bf399ea 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -992,7 +992,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  			     struct btrfs_root *root)
>  {
>  	unsigned long joined = 0;
> -	unsigned long timeout = 1;
>  	struct btrfs_transaction *cur_trans;
>  	struct btrfs_transaction *prev_trans = NULL;
>  	DEFINE_WAIT(wait);
> @@ -1063,11 +1062,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  			snap_pending = 1;
>  
>  		WARN_ON(cur_trans != trans->transaction);
> -		if (cur_trans->num_writers > 1)
> -			timeout = MAX_SCHEDULE_TIMEOUT;
> -		else if (should_grow)
> -			timeout = 1;
> -
>  		mutex_unlock(&root->fs_info->trans_mutex);
>  
>  		if (flush_on_commit || snap_pending) {
> @@ -1089,8 +1083,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  				TASK_UNINTERRUPTIBLE);
>  
>  		smp_mb();
> -		if (cur_trans->num_writers > 1 || should_grow)
> -			schedule_timeout(timeout);
> +		if (cur_trans->num_writers > 1)
> +			schedule_timeout(MAX_SCHEDULE_TIMEOUT);
> +		else if (should_grow)
> +			schedule_timeout(1);
>  
>  		mutex_lock(&root->fs_info->trans_mutex);
>  		finish_wait(&cur_trans->writer_wait, &wait);




