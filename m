Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:44923 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab2FVRQT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 13:16:19 -0400
Message-ID: <4FE4A860.1040606@fusionio.com>
Date: Fri, 22 Jun 2012 13:16:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: David Sterba <dsterba@suse.cz>, "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: join DEV_STATS ioctls to one
References: <1340368239-8152-1-git-send-email-dsterba@suse.cz> <4FE49CC4.6030606@giantdisaster.de>
In-Reply-To: <4FE49CC4.6030606@giantdisaster.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2012 12:26 PM, Stefan Behrens wrote:
> On Fri, 22 Jun 2012 14:30:39 +0200, David Sterba wrote:
>> Hi Chris,
>>
>> please consider this patch for 3.5-rc before it goes final. Thanks.
>>
>> From: David Sterba <dsterba@suse.cz>
>>
>> Commit c11d2c236cc260b36 (Btrfs: add ioctl to get and reset the device
>> stats) introduced two ioctls doing almost the same thing distinguished
>> by just the ioctl number which encodes "do reset after read". I have
>> suggested
>>
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16604.html
>>
>> to implement it via the ioctl args. This hasn't happen, and I think we
>> should use a more clean way to pass flags and should not waste ioctl
>> numbers.
>>
>> CC: Stefan Behrens <sbehrens@giantdisaster.de>
>> Signed-off-by: David Sterba <dsterba@suse.cz>
>> ---
>>   fs/btrfs/ioctl.c   |   16 ++++++++--------
>>   fs/btrfs/ioctl.h   |    6 ++++--
>>   fs/btrfs/volumes.c |    5 ++---
>>   fs/btrfs/volumes.h |    3 +--
>>   4 files changed, 15 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 0e92e57..670c5d2 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3063,19 +3063,21 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
>>   }
>>
>>   static long btrfs_ioctl_get_dev_stats(struct btrfs_root *root,
>> -				      void __user *arg, int reset_after_read)
>> +				      void __user *arg)
>>   {
>>   	struct btrfs_ioctl_get_dev_stats *sa;
>>   	int ret;
>>
>> -	if (reset_after_read && !capable(CAP_SYS_ADMIN))
>> -		return -EPERM;
>> -
>>   	sa = memdup_user(arg, sizeof(*sa));
>>   	if (IS_ERR(sa))
>>   		return PTR_ERR(sa);
>>
>> -	ret = btrfs_get_dev_stats(root, sa, reset_after_read);
>> +	if ((sa->flags & BTRFS_DEV_STATS_RESET) && !capable(CAP_SYS_ADMIN)) {
>> +		kfree(sa);
>> +		return -EPERM;
>> +	}
>> +
>> +	ret = btrfs_get_dev_stats(root, sa);
>>
>>   	if (copy_to_user(arg, sa, sizeof(*sa)))
>>   		ret = -EFAULT;
>> @@ -3473,9 +3475,7 @@ long btrfs_ioctl(struct file *file, unsigned int
>>   	case BTRFS_IOC_BALANCE_PROGRESS:
>>   		return btrfs_ioctl_balance_progress(root, argp);
>>   	case BTRFS_IOC_GET_DEV_STATS:
>> -		return btrfs_ioctl_get_dev_stats(root, argp, 0);
>> -	case BTRFS_IOC_GET_AND_RESET_DEV_STATS:
>> -		return btrfs_ioctl_get_dev_stats(root, argp, 1);
>> +		return btrfs_ioctl_get_dev_stats(root, argp);
>>   	}
>>
>>   	return -ENOTTY;
>> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
>> index 497c530..c4089c5 100644
>> --- a/fs/btrfs/ioctl.h
>> +++ b/fs/btrfs/ioctl.h
>> @@ -285,9 +285,13 @@ enum btrfs_dev_stat_values {
>>   	BTRFS_DEV_STAT_VALUES_MAX
>>   };
>>
>> +/* Reset statistics after reading; needs SYS_ADMIN capability */
>> +#define	BTRFS_DEV_STATS_RESET		(1ULL << 0)
>> +
>>   struct btrfs_ioctl_get_dev_stats {
>>   	__u64 devid;				/* in */
>>   	__u64 nr_items;				/* in/out */
>> +	__u64 flags;				/* in/out */
>>
>>   	/* out values: */
>>   	__u64 values[BTRFS_DEV_STAT_VALUES_MAX];
>> @@ -361,7 +365,5 @@ struct btrfs_ioctl_get_dev_stats {
>>   					struct btrfs_ioctl_ino_path_args)
>>   #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>>   				      struct btrfs_ioctl_get_dev_stats)
>> -#define BTRFS_IOC_GET_AND_RESET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
>> -					struct btrfs_ioctl_get_dev_stats)
>>
>>   #endif
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 8a3d259..661e6ca 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -4871,8 +4871,7 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *dev)
>>   }
>>
>>   int btrfs_get_dev_stats(struct btrfs_root *root,
>> -			struct btrfs_ioctl_get_dev_stats *stats,
>> -			int reset_after_read)
>> +			struct btrfs_ioctl_get_dev_stats *stats)
>>   {
>>   	struct btrfs_device *dev;
>>   	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
>> @@ -4890,7 +4889,7 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
>>   		printk(KERN_WARNING
>>   		       "btrfs: get dev_stats failed, not yet valid\n");
>>   		return -ENODEV;
>> -	} else if (reset_after_read) {
>> +	} else if (stats->flags & BTRFS_DEV_STATS_RESET) {
>>   		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++) {
>>   			if (stats->nr_items > i)
>>   				stats->values[i] =
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 74366f2..e673589 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -292,8 +292,7 @@ struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
>>   void btrfs_dev_stat_print_on_error(struct btrfs_device *device);
>>   void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
>>   int btrfs_get_dev_stats(struct btrfs_root *root,
>> -			struct btrfs_ioctl_get_dev_stats *stats,
>> -			int reset_after_read);
>> +			struct btrfs_ioctl_get_dev_stats *stats);
>>   int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
>>   int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
>>   			struct btrfs_fs_info *fs_info);
>>
>
> I still do not understand your reason and the benefit of your change.
> The reset command and the read command are two completely different
> operations. Therefore I assigned two different ioctl commands. Then you
> can use strace to see which command is sent, and you can also grep the
> sources without additional effort.

If the difference in behaviour between two different ioctls is indicated 
by a single flag to the same function then there is no reason it cannot 
be implemented in one ioctl with a flag in the ioctl arguments.  I'd 
rather not waste ioctl numbers.  Thanks,

Josef
