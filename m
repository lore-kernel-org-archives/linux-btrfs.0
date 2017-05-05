Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31269 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdEEXIm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 19:08:42 -0400
Subject: Re: [PATCH] btrfs: add framework to handle device flush error as a
 volume
To: dsterba@suse.cz
References: <20170425085831.14999-1-anand.jain@oracle.com>
 <20170505144602.GD10575@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <fdc4e3f0-5bb4-7d88-9026-5d4c488c770d@oracle.com>
Date: Sat, 6 May 2017 07:14:18 +0800
MIME-Version: 1.0
In-Reply-To: <20170505144602.GD10575@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>






>> @@ -3566,6 +3570,33 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
>>  	return 0;
>>  }
>>
>> +static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
>> +{
>> +	int submit_flush_error = 0;
>> +	int dev_flush_error = 0;
>> +	struct btrfs_device *dev;
>> +
>> +	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
>> +		if (!dev->bdev) {
>> +			submit_flush_error++;
>> +			dev_flush_error++;
>> +			continue;
>> +		}
>> +		if (dev->last_flush_error == ENOMEM)
>
> That's -ENOMEM

  My bad, will fix it.

>> +			submit_flush_error++;
>> +		if (dev->last_flush_error && dev->last_flush_error != ENOMEM)
>
> also here.

  yes.

>> +			dev_flush_error++;
>> +	}
>> +
>> +	if (submit_flush_error >
>> +		fsdevs->fs_info->num_tolerated_disk_barrier_failures ||
>> +		dev_flush_error >
>> +		fsdevs->fs_info->num_tolerated_disk_barrier_failures)
>> +		return -EIO;
>
> Can you please reformat this so it's clear what's the condition and
> what's the statement?

  included in v2.

>> +
>> +	return 0;
>> +}
>> +
>>  /*
>>   * send an empty flush down to each device in parallel,
>>   * then wait for them
>> @@ -3593,6 +3624,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>>  		ret = write_dev_flush(dev, 0);
>>  		if (ret)
>>  			errors_send++;
>> +		dev->last_flush_error = ret;
>
> Here the error is set unconditionally, so it always tracks the return
> code, not only the error ...

  Right. So it captures send part of the error, that is when we call
  write_dev_flush(... 0); which returns only -ENOMEM or 0;

>>  	}
>>
>>  	/* wait for all the barriers */
>> @@ -3607,12 +3639,30 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>>  			continue;
>>
>>  		ret = write_dev_flush(dev, 1);
>> -		if (ret)
>> +		if (ret) {
>> +			dev->last_flush_error = ret;
>
> ... while this tracks only the errors. Unless I'm missing something,
> both should be set in a consistent way.

   Actually this is correct, that way I preserve the -ENOMEM; which
   occurred in the send part of the code. And during wait.. we always
   return 0; for -ENOMEM that occurred during send.

------------------------------
@@ -3625,6 +3625,10 @@ static int write_dev_flush(struct btrfs_device 
*device, int wait)
         if (wait) {
                 bio = device->flush_bio;
                 if (!bio)
+                /*
+                 * This means the alloc has failed with ENOMEM, however
+                 * here we return 0, as its not a device error.
+                 */
                         return 0;
------------------------------



>>  			errors_wait++;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Try hard in case of flush. Lets say, in RAID1 we have
>> +	 * the following situation
>> +	 *  dev1: EIO dev2: ENOMEM
>> +	 * this is not a fatal error as we hope to recover from
>> +	 * ENOMEM in the next attempt to flush.
>
> This could still be problematic under some very rare conditions, but I
> don't deem it important at the moment as the memory allocation will be
> gone. Then the comment reflects the current state, which is fine.

  Thanks for mentioning that; though I suspected that way as well;
  I had to put extra effort not to change original logic unless
  there is an identified issue with it. So I instead, I just documented
  the logic in the comments.

  I am sending V2 with the above changes.

Thanks, Anand
