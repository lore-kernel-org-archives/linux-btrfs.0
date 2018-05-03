Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60421 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbeECNjH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 09:39:07 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 976B8AD9C
        for <linux-btrfs@vger.kernel.org>; Thu,  3 May 2018 13:39:05 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
References: <20180502211156.9460-1-jeffm@suse.com>
 <20180502211156.9460-2-jeffm@suse.com>
 <c5f71950-25c4-0b12-dbc2-306757db621d@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <c0990ec8-e31a-94a9-0f2c-e677939e06e2@suse.com>
Date: Thu, 3 May 2018 09:39:03 -0400
MIME-Version: 1.0
In-Reply-To: <c5f71950-25c4-0b12-dbc2-306757db621d@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/3/18 3:24 AM, Nikolay Borisov wrote:
> 
> 
> On  3.05.2018 00:11, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> Commit 8d9eddad194 (Btrfs: fix qgroup rescan worker initialization)
>> fixed the issue with BTRFS_IOC_QUOTA_RESCAN_WAIT being racy, but
>> ended up reintroducing the hang-on-unmount bug that the commit it
>> intended to fix addressed.
>>
>> The race this time is between qgroup_rescan_init setting
>> ->qgroup_rescan_running = true and the worker starting.  There are
>> many scenarios where we initialize the worker and never start it.  The
>> completion btrfs_ioctl_quota_rescan_wait waits for will never come.
>> This can happen even without involving error handling, since mounting
>> the file system read-only returns between initializing the worker and
>> queueing it.
>>
>> The right place to do it is when we're queuing the worker.  The flag
>> really just means that btrfs_ioctl_quota_rescan_wait should wait for
>> a completion.
>>
>> Since the BTRFS_QGROUP_STATUS_FLAG_RESCAN flag is overloaded to
>> refer to both runtime behavior and on-disk state, we introduce a new
>> fs_info->qgroup_rescan_ready to indicate that we're initialized and
>> waiting to start.
> 
> Am I correct in my understanding that this qgroup_rescan_ready flag is
> used to avoid qgroup_rescan_init being called AFTER it has already been
> called but BEFORE queue_rescan_worker ? Why wasn't the initial version
> of this patch without this flag sufficient?

No, the race is between clearing the BTRFS_QGROUP_STATUS_FLAG_RESCAN
flag near the end of the worker and clearing the running flag.  The
rescan lock is dropped in between, so btrfs_rescan_init will let a new
rescan request in while we update the status item on disk.  We wouldn't
have queued another worker since that's what the warning catches, but if
there were already tasks waiting for completion, they wouldn't have been
woken since the wait queue list would be reinitialized.  There's no way
to reorder clearing the flag without changing how we handle
->qgroup_flags.  I plan on doing that separately.  This was just meant
to be the simple fix.

That we can use the ready variable to also ensure that we don't let
qgroup_rescan_init be called twice without running the rescan is a nice
bonus.

-Jeff

>>
>> This patch introduces a new helper, queue_rescan_worker, that handles
>> most of the initialization, the two flags, and queuing the worker,
>> including races with unmount.
>>
>> While we're at it, ->qgroup_rescan_running is protected only by the
>> ->qgroup_rescan_mutex.  btrfs_ioctl_quota_rescan_wait doesn't need
>> to take the spinlock too.
>>
>> Fixes: 8d9eddad194 (Btrfs: fix qgroup rescan worker initialization)
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/ctree.h  |  2 ++
>>  fs/btrfs/qgroup.c | 94 +++++++++++++++++++++++++++++++++----------------------
>>  2 files changed, 58 insertions(+), 38 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index da308774b8a4..4003498bb714 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1045,6 +1045,8 @@ struct btrfs_fs_info {
>>  	struct btrfs_workqueue *qgroup_rescan_workers;
>>  	struct completion qgroup_rescan_completion;
>>  	struct btrfs_work qgroup_rescan_work;
>> +	/* qgroup rescan worker is running or queued to run */
>> +	bool qgroup_rescan_ready;
>>  	bool qgroup_rescan_running;	/* protected by qgroup_rescan_lock */
>>  
>>  	/* filesystem state */
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index aa259d6986e1..466744741873 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -101,6 +101,7 @@ static int
>>  qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
>>  		   int init_flags);
>>  static void qgroup_rescan_zero_tracking(struct btrfs_fs_info *fs_info);
>> +static void btrfs_qgroup_rescan_worker(struct btrfs_work *work);
>>  
>>  /* must be called with qgroup_ioctl_lock held */
>>  static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_info,
>> @@ -2072,6 +2073,46 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
>>  	return ret;
>>  }
>>  
>> +static void queue_rescan_worker(struct btrfs_fs_info *fs_info)
>> +{
>> +	mutex_lock(&fs_info->qgroup_rescan_lock);
>> +	if (btrfs_fs_closing(fs_info)) {
>> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +		return;
>> +	}
>> +
>> +	if (WARN_ON(!fs_info->qgroup_rescan_ready)) {
>> +		btrfs_warn(fs_info, "rescan worker not ready");
>> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +		return;
>> +	}
>> +	fs_info->qgroup_rescan_ready = false;
>> +
>> +	if (WARN_ON(fs_info->qgroup_rescan_running)) {
>> +		btrfs_warn(fs_info, "rescan worker already queued");
>> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Being queued is enough for btrfs_qgroup_wait_for_completion
>> +	 * to need to wait.
>> +	 */
>> +	fs_info->qgroup_rescan_running = true;
>> +	init_completion(&fs_info->qgroup_rescan_completion);
>> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +
>> +	memset(&fs_info->qgroup_rescan_work, 0,
>> +	       sizeof(fs_info->qgroup_rescan_work));
>> +
>> +	btrfs_init_work(&fs_info->qgroup_rescan_work,
>> +			btrfs_qgroup_rescan_helper,
>> +			btrfs_qgroup_rescan_worker, NULL, NULL);
>> +
>> +	btrfs_queue_work(fs_info->qgroup_rescan_workers,
>> +			 &fs_info->qgroup_rescan_work);
>> +}
>> +
>>  /*
>>   * called from commit_transaction. Writes all changed qgroups to disk.
>>   */
>> @@ -2123,8 +2164,7 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
>>  		ret = qgroup_rescan_init(fs_info, 0, 1);
>>  		if (!ret) {
>>  			qgroup_rescan_zero_tracking(fs_info);
>> -			btrfs_queue_work(fs_info->qgroup_rescan_workers,
>> -					 &fs_info->qgroup_rescan_work);
>> +			queue_rescan_worker(fs_info);
>>  		}
>>  		ret = 0;
>>  	}
>> @@ -2607,6 +2647,10 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>>  	if (!path)
>>  		goto out;
>>  
>> +	mutex_lock(&fs_info->qgroup_rescan_lock);
>> +	fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_RESCAN;
>> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +
>>  	err = 0;
>>  	while (!err && !btrfs_fs_closing(fs_info)) {
>>  		trans = btrfs_start_transaction(fs_info->fs_root, 0);
>> @@ -2685,47 +2729,27 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
>>  {
>>  	int ret = 0;
>>  
>> -	if (!init_flags &&
>> -	    (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) ||
>> -	     !(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))) {
>> +	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
>>  		ret = -EINVAL;
>>  		goto err;
>>  	}
>>  
>>  	mutex_lock(&fs_info->qgroup_rescan_lock);
>> -	spin_lock(&fs_info->qgroup_lock);
>> -
>> -	if (init_flags) {
>> -		if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
>> -			ret = -EINPROGRESS;
>> -		else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
>> -			ret = -EINVAL;
>> -
>> -		if (ret) {
>> -			spin_unlock(&fs_info->qgroup_lock);
>> -			mutex_unlock(&fs_info->qgroup_rescan_lock);
>> -			goto err;
>> -		}
>> -		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_RESCAN;
>> +	if (fs_info->qgroup_rescan_ready || fs_info->qgroup_rescan_running) {
>> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +		ret = -EINPROGRESS;
>> +		goto err;
>>  	}
>>  
>>  	memset(&fs_info->qgroup_rescan_progress, 0,
>>  		sizeof(fs_info->qgroup_rescan_progress));
>>  	fs_info->qgroup_rescan_progress.objectid = progress_objectid;
>> -	init_completion(&fs_info->qgroup_rescan_completion);
>> -	fs_info->qgroup_rescan_running = true;
>> +	fs_info->qgroup_rescan_ready = true;
>>  
>> -	spin_unlock(&fs_info->qgroup_lock);
>>  	mutex_unlock(&fs_info->qgroup_rescan_lock);
>>  
>> -	memset(&fs_info->qgroup_rescan_work, 0,
>> -	       sizeof(fs_info->qgroup_rescan_work));
>> -	btrfs_init_work(&fs_info->qgroup_rescan_work,
>> -			btrfs_qgroup_rescan_helper,
>> -			btrfs_qgroup_rescan_worker, NULL, NULL);
>> -
>> -	if (ret) {
>>  err:
>> +	if (ret) {
>>  		btrfs_info(fs_info, "qgroup_rescan_init failed with %d", ret);
>>  		return ret;
>>  	}
>> @@ -2785,9 +2809,7 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
>>  
>>  	qgroup_rescan_zero_tracking(fs_info);
>>  
>> -	btrfs_queue_work(fs_info->qgroup_rescan_workers,
>> -			 &fs_info->qgroup_rescan_work);
>> -
>> +	queue_rescan_worker(fs_info);
>>  	return 0;
>>  }
>>  
>> @@ -2798,9 +2820,7 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
>>  	int ret = 0;
>>  
>>  	mutex_lock(&fs_info->qgroup_rescan_lock);
>> -	spin_lock(&fs_info->qgroup_lock);
>>  	running = fs_info->qgroup_rescan_running;
>> -	spin_unlock(&fs_info->qgroup_lock);
>>  	mutex_unlock(&fs_info->qgroup_rescan_lock);
>>  
>>  	if (!running)
>> @@ -2819,12 +2839,10 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
>>   * this is only called from open_ctree where we're still single threaded, thus
>>   * locking is omitted here.
>>   */
>> -void
>> -btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
>> +void btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
>>  {
>>  	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
>> -		btrfs_queue_work(fs_info->qgroup_rescan_workers,
>> -				 &fs_info->qgroup_rescan_work);
>> +		queue_rescan_worker(fs_info);
>>  }
>>  
>>  /*
>>


-- 
Jeff Mahoney
SUSE Labs
