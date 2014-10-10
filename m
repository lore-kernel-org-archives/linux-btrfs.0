Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6009 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751929AbaJJIWl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 04:22:41 -0400
Message-ID: <543797BA.3090103@cn.fujitsu.com>
Date: Fri, 10 Oct 2014 16:24:26 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Eryu Guan <guaneryu@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: return failure if btrfs_dev_replace_finishing()
 failed
References: <1411640894-5160-1-git-send-email-guaneryu@gmail.com> <20141010071331.GG13950@dhcp-13-216.nay.redhat.com>
In-Reply-To: <20141010071331.GG13950@dhcp-13-216.nay.redhat.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 10 Oct 2014 15:13:31 +0800, Eryu Guan wrote:
> On Thu, Sep 25, 2014 at 06:28:14PM +0800, Eryu Guan wrote:
>> device replace could fail due to another running scrub process, but this
>> failure doesn't get returned to userspace.
>>
>> The following steps could reproduce this issue
>>
>> 	mkfs -t btrfs -f /dev/sdb1 /dev/sdb2
>> 	mount /dev/sdb1 /mnt/btrfs
>> 	while true; do
>> 		btrfs scrub start -B /mnt/btrfs >/dev/null 2>&1
>> 	done &
>> 	btrfs replace start -Bf /dev/sdb2 /dev/sdb3 /mnt/btrfs
>> 	# if this replace succeeded, do the following and repeat until
>> 	# you see this log in dmesg
>> 	# BTRFS: btrfs_scrub_dev(/dev/sdb2, 2, /dev/sdb3) failed -115
>> 	#btrfs replace start -Bf /dev/sdb3 /dev/sdb2 /mnt/btrfs
>>
>> 	# once you see the error log in dmesg, check return value of
>> 	# replace
>> 	echo $?
>>
>> Also only WARN_ON if the return code is not -EINPROGRESS.
>>
>> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> 
> Ping, any comments on this patch?
> 
> Thanks,
> Eryu
>> ---
>>  fs/btrfs/dev-replace.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index eea26e1..44d32ab 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -418,9 +418,11 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
>>  			      &dev_replace->scrub_progress, 0, 1);
>>  
>>  	ret = btrfs_dev_replace_finishing(root->fs_info, ret);
>> -	WARN_ON(ret);
>> +	/* don't warn if EINPROGRESS, someone else might be running scrub */
>> +	if (ret != -EINPROGRESS)
>> +		WARN_ON(ret);

picky comment

I prefer WARN_ON(ret && ret != -EINPROGRESS).

>>  
>> -	return 0;
>> +	return ret;

here we will return -EINPROGRESS if scrub is running, I think it better that
we assign some special number to args->result, and then return 0, just like
the case the device replace is running.

Thanks
Miao

>>  
>>  leave:
>>  	dev_replace->srcdev = NULL;
>> @@ -538,7 +540,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>  			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
>>  		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>>  
>> -		return 0;
>> +		return scrub_ret;
>>  	}
>>  
>>  	printk_in_rcu(KERN_INFO
>> -- 
>> 1.8.3.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

