Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56410 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbeBEGoJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Feb 2018 01:44:09 -0500
Subject: Re: [PATCH v3] btrfs: print error if primary super block write fails
From: Anand Jain <anand.jain@oracle.com>
To: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Howard McLauchlan <hmclauchlan@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Omar Sandoval <osandov@osandov.com>,
        Josef Bacik <jbacik@fb.com>
References: <20180202190901.10988-1-hmclauchlan@fb.com>
 <bc22e369-9f13-348b-0227-7822f8660752@oracle.com>
Message-ID: <3739e239-ab36-d08c-d386-05dc04a3ad18@oracle.com>
Date: Mon, 5 Feb 2018 14:45:21 +0800
MIME-Version: 1.0
In-Reply-To: <bc22e369-9f13-348b-0227-7822f8660752@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/05/2018 02:38 PM, Anand Jain wrote:
> 
> 
> On 02/03/2018 03:09 AM, Howard McLauchlan wrote:
>> Presently, failing a primary super block write but succeeding in at
>> least one super block write in general will appear to users as if
>> nothing important went wrong.
> 
>> However, upon unmounting and re-mounting,
>> the file system will be in a rolled back state.
> 
> Right.! In case of non-datasync-IO, or where applications depend on the
> transcation_commit() to confirm the IO.
> 
> David, Qu,
> 
>   In this context (single disk btrfs, the write to primary SB has
>   been failing but read is fine), if a system is rebooted and continues
>   the production the data loss is eminent!!!. btrfs_err() won't help to
>   avoid the data loss nor we could blame the user for not taking any
>   action on the btrfs_err().

  I am wrong. I missed the return -1 which this patch adds. Which
  means it is choice a. as below. But IMO better would have been
  choice b. though.


>   IMHO there are two choices to fix a. put the FS to read-only on the
>   first write fail to the primary SB b. read backup SB at the time of
>   the mount, as suggested [1]. Choice b is more appropriate, you may
>   need to reconsider your opinion.
> 
>     [1]  https://patchwork.kernel.org/patch/10101725/

Thanks, Anand

> 
> Thanks, Anand
> 
> 
>> This was discovered
>> with a BCC program that uses bpf_override_return() to fail super block
>> writes.
>>
>> This patch outputs an error clarifying that the primary super block
>> write has failed, so users can expect potentially erroneous behaviour.
>> It also forces wait_dev_supers() to return an error to its caller if
>> the primary super block write fails.
>>
>> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
>> ---
>> V3: Rewrote boolean setting logic for clarity
>> V2: Added devid to output, removed unnecessary fs_info parameter
>>
>>   fs/btrfs/disk-io.c | 15 ++++++++++++++-
>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 5da18ebc9222..6ef32eb94669 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3298,6 +3298,7 @@ static int wait_dev_supers(struct btrfs_device 
>> *device, int max_mirrors)
>>       struct buffer_head *bh;
>>       int i;
>>       int errors = 0;
>> +    bool primary_failed = false;
>>       u64 bytenr;
>>       if (max_mirrors == 0)
>> @@ -3314,11 +3315,16 @@ static int wait_dev_supers(struct btrfs_device 
>> *device, int max_mirrors)
>>                         BTRFS_SUPER_INFO_SIZE);
>>           if (!bh) {
>>               errors++;
>> +            if (i == 0)
>> +                primary_failed = true;
>>               continue;
>>           }
>>           wait_on_buffer(bh);
>> -        if (!buffer_uptodate(bh))
>> +        if (!buffer_uptodate(bh)) {
>>               errors++;
>> +            if (i == 0)
>> +                primary_failed = true;
>> +        }
>>           /* drop our reference */
>>           brelse(bh);
>> @@ -3327,6 +3333,13 @@ static int wait_dev_supers(struct btrfs_device 
>> *device, int max_mirrors)
>>           brelse(bh);
>>       }
>> +    /* log error, force error return */
>> +    if (primary_failed) {
>> +        btrfs_err(device->fs_info, "error writing primary super block 
>> to device %llu",
>> +              device->devid);
>> +        return -1;
>> +    }
>> +
>>       return errors < i ? 0 : -1;
>>   }
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
