Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41655 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbcDAXx7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 19:53:59 -0400
Subject: Re: [PATCH 12/12] btrfs: check device for critical errors and mark
 failed
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
 <1459261349-32206-13-git-send-email-anand.jain@oracle.com>
 <20160329224118.GD27148@jeknote.loshitsa1.net>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56FF0A15.3060604@oracle.com>
Date: Sat, 2 Apr 2016 07:53:57 +0800
MIME-Version: 1.0
In-Reply-To: <20160329224118.GD27148@jeknote.loshitsa1.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/30/2016 06:41 AM, Yauhen Kharuzhy wrote:
> On Tue, Mar 29, 2016 at 10:22:29PM +0800, Anand Jain wrote:
>> Write and Flush errors are considered as critical errors,
>> upon which the device will be brought offline and marked as
>> failed. Write and Flush errors are identified using device
>> error statistics.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>
>> btrfs: check for failed device and hot replace
>>
>> This patch creates casualty_kthread to check for the failed
>> devices, and triggers device replace.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/ctree.h   |   2 +
>>   fs/btrfs/disk-io.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   fs/btrfs/disk-io.h |   2 +
>>   fs/btrfs/volumes.c |   1 +
>>   fs/btrfs/volumes.h |   4 ++
>>   5 files changed, 169 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 2c185a8e92f0..36f1c29e00a0 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1569,6 +1569,7 @@ struct btrfs_fs_info {
>>   	struct mutex tree_log_mutex;
>>   	struct mutex transaction_kthread_mutex;
>>   	struct mutex cleaner_mutex;
>> +	struct mutex casualty_mutex;
>>   	struct mutex chunk_mutex;
>>   	struct mutex volume_mutex;
>>
>> @@ -1686,6 +1687,7 @@ struct btrfs_fs_info {
>>   	struct btrfs_workqueue *extent_workers;
>>   	struct task_struct *transaction_kthread;
>>   	struct task_struct *cleaner_kthread;
>> +	struct task_struct *casualty_kthread;
>>   	int thread_pool_size;
>>
>>   	struct kobject *space_info_kobj;
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index b99329e37965..650e26e0acda 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1869,6 +1869,153 @@ sleep:
>>   	return 0;
>>   }
>>
>> +static int btrfs_check_and_handle_casualty(void *arg)
>> +{
>> +	int ret;
>> +	int found = 0;
>> +	struct btrfs_device *device;
>> +	struct btrfs_root *root = arg;
>> +	struct btrfs_fs_info *fs_info = root->fs_info;
>> +	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>> +
>> +	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
>> +	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>> +		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
>> +		return -EBUSY;
>> +	}
>> +	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
>> +
>> +	ret = btrfs_check_devices(fs_devices);
>> +	if (ret == 1) {
>> +		/*
>> +		 * There were some casualties, and if its beyond a
>> +		 * chunk group can tolerate, then FS will already
>> +		 * be in readonly, so check that. And that's best
>> +		 * btrfs could do as of now and no replace will help.
>> +		 */
>> +		if (fs_info->sb->s_flags & MS_RDONLY)
>> +			return -EROFS;
>> +
>> +		mutex_lock(&fs_devices->device_list_mutex);
>> +		rcu_read_lock();
>> +		list_for_each_entry_rcu(device,
>> +				&fs_devices->devices, dev_list) {
>> +			if (device->failed) {
>> +				found = 1;
>> +				break;
>> +			}
>> +		}
>> +		rcu_read_unlock();
>> +		mutex_unlock(&fs_devices->device_list_mutex);
>> +	}
>> +
>> +	/*
>> +	 * We are using the replace code which should be interrupt-able
>> +	 * during unmount, and as of now there is no user land stop
>> +	 * request that we support and this will run until its complete
>> +	 */
>> +	if (found)
>> +		ret = btrfs_auto_replace_start(root, device);
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * A kthread to check if any auto maintenance be required. This is
>> + * multithread safe, and kthread is running only if
>> + * fs_info->casualty_kthread is not NULL, fixme: atomic ?
>> + */
>> +static int casualty_kthread(void *arg)
>> +{
>> +	int ret;
>> +	int again;
>> +	struct btrfs_root *root = arg;
>> +
>> +	do {
>> +		again = 0;
>> +
>> +		if (btrfs_need_cleaner_sleep(root))
>> +			goto sleep;
>> +
>> +		if (!mutex_trylock(&root->fs_info->casualty_mutex))
>> +			goto sleep;
>> +
>> +		if (btrfs_need_cleaner_sleep(root)) {
>> +			mutex_unlock(&root->fs_info->casualty_mutex);
>> +			goto sleep;
>> +		}
>> +
>> +		ret = btrfs_check_and_handle_casualty(arg);
>> +		if (ret == -EROFS) {
>> +			/*
>> +			 * When checking and fixing the devices, the
>> +			 * FS may be marked as RO in some situations.
>> +			 * And on ROFS casualty thread has no work.
>> +			 * So optimize here, to stop this thread until
>> +			 * FS is back to RW.
>> +			 */
>> +		}
>> +		mutex_unlock(&root->fs_info->casualty_mutex);
>> +
>> +sleep:
>> +		if (!try_to_freeze() && !again) {
>
> This block was copy-pasted from the cleaner_kthread(). 'again' variable
> is not used in reality, and using of try_to_freeze() in the cleaner_kthread()
> was eliminated in 'for-linus-4.6' mason's branch in the commit
> 838fe188 'btrfs: cleaner_kthread() doesn't need explicit freeze'.
> casualty_kthread() isn't marked as freezabe too,
> so this check can be removed entirely.


Thanks this is fixed in v3.

Anand

>
>> +			set_current_state(TASK_INTERRUPTIBLE);
>> +			if (!kthread_should_stop())
>> +				schedule();
>> +			__set_current_state(TASK_RUNNING);
>> +		}
>> +	} while (!kthread_should_stop());
>> +
>> +	return 0;
>> +}
>> +
>
