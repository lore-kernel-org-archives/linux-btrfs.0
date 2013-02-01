Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61530 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab3BAHij (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 02:38:39 -0500
Message-ID: <510B7126.6070607@cn.fujitsu.com>
Date: Fri, 01 Feb 2013 15:39:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com, Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] Btrfs: implement unlocked dio write
References: <510A3BB7.4090201@cn.fujitsu.com> <20130201025218.GA7690@liubo.jp.oracle.com> <510B3FB9.6050707@cn.fujitsu.com>
In-Reply-To: <510B3FB9.6050707@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	fri, 01 Feb 2013 12:08:25 +0800, Miao Xie wrote:
> On 	fri, 1 Feb 2013 10:53:30 +0800, Liu Bo wrote:
>> On Thu, Jan 31, 2013 at 05:39:03PM +0800, Miao Xie wrote:
>>> This idea is from ext4. By this patch, we can make the dio write parallel,
>>> and improve the performance.
>>
>> Interesting, AFAIK, ext4 can only do nolock dio write on some
>> conditions(should be a overwrite, file size remains unchanged,
>> no aligned/buffer io in flight), btrfs is ok without any conditions?
> 
> ext4 don't have extent lock, it can not avoid 2 AIO  threads are at work on the same
> unwritten block, so it can not use unlocked dio write for unaligned dio/aio. But btrfs
> has extent lock, it can avoid this problem.

Besides that, btrfs doesn't allow doing a unaligned dio/aio.

I read the code again, found there is a race that several tasks may update i_size at
the same time. There are two methods to fix this problem:
1. just like ext4, don't do unlocked write dio if it is beyond the end of the file
2. use a spin lock to protect i_size update

I want to choose the 2nd one.

Thanks
Miao

> 
> And ext4 need take write lock of ->i_data_sem, when it allocate the free space,
> but in order to avoid truncation and hole punch during dio, it need take the read
> lock of ->i_data_sem before it release ->i_mutex, that is if it isn't a overwrite,
> deadlock will happen, so the unlocked dio of ext4 should be a overwrite. But btrfs
> doesn't have such limitation.
> 
> Thanks
> Miao
> 
>>
>> thanks,
>> liubo
>>
>>>
>>> We needn't worry about the race between dio write and truncate, because the
>>> truncate need wait untill all the dio write end.
>>>
>>> And we also needn't worry about the race between dio write and punch hole,
>>> because we have extent lock to protect our operation.
>>>
>>> I ran fio to test the performance of this feature.
>>>
>>> == Hardware ==
>>> CPU: Intel(R) Core(TM)2 Duo CPU     E7500  @ 2.93GHz
>>> Mem: 2GB
>>> SSD: Intel X25-M 120GB (Test Partition: 60GB)
>>>
>>> == config file ==
>>> [global]
>>> ioengine=psync
>>> direct=1
>>> bs=4k
>>> size=32G
>>> runtime=60
>>> directory=/mnt/btrfs/
>>> filename=testfile
>>> group_reporting
>>> thread
>>>
>>> [file1]
>>> numjobs=1 # 2 4
>>> rw=randwrite
>>>
>>> == result (KBps) ==
>>> write	1	2	4
>>> lock	24936	24738	24726
>>> nolock	24962	30866	32101
>>>
>>> == result (iops) ==
>>> write	1	2	4
>>> lock	6234	6184	6181
>>> nolock	6240	7716	8025
>>>
>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/inode.c | 24 +++++++++++++-----------
>>>  1 file changed, 13 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index d17a04b..091593a 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -6589,31 +6589,33 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
>>>  	struct file *file = iocb->ki_filp;
>>>  	struct inode *inode = file->f_mapping->host;
>>>  	int flags = 0;
>>> -	bool wakeup = false;
>>> +	bool wakeup = true;
>>>  	int ret;
>>>  
>>>  	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
>>>  			    offset, nr_segs))
>>>  		return 0;
>>>  
>>> -	if (rw == READ) {
>>> -		atomic_inc(&inode->i_dio_count);
>>> -		smp_mb__after_atomic_inc();
>>> -		if (unlikely(test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
>>> -				      &BTRFS_I(inode)->runtime_flags))) {
>>> -			inode_dio_done(inode);
>>> -			flags = DIO_LOCKING | DIO_SKIP_HOLES;
>>> -		} else {
>>> -			wakeup = true;
>>> -		}
>>> +	atomic_inc(&inode->i_dio_count);
>>> +	smp_mb__after_atomic_inc();
>>> +	if (rw == WRITE) {
>>> +		mutex_unlock(&inode->i_mutex);
>>> +	} else if (unlikely(test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
>>> +				     &BTRFS_I(inode)->runtime_flags))) {
>>> +		inode_dio_done(inode);
>>> +		flags = DIO_LOCKING | DIO_SKIP_HOLES;
>>> +		wakeup = false;
>>>  	}
>>>  
>>>  	ret = __blockdev_direct_IO(rw, iocb, inode,
>>>  			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
>>>  			iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
>>>  			btrfs_submit_direct, flags);
>>> +
>>>  	if (wakeup)
>>>  		inode_dio_done(inode);
>>> +	if (rw == WRITE)
>>> +		mutex_lock(&inode->i_mutex);
>>>  	return ret;
>>>  }
>>>  
>>> -- 
>>> 1.7.11.7
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

