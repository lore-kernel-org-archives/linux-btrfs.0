Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46542 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388125AbeGWPN4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 11:13:56 -0400
Subject: Re: [PATCH 5/7] btrfs: warn for num_devices below 0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180716145812.20836-1-anand.jain@oracle.com>
 <20180716145812.20836-6-anand.jain@oracle.com>
 <20180723140103.GN26141@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <535b5ee9-b935-6d5d-b7b0-20a46b07b10c@oracle.com>
Date: Mon, 23 Jul 2018 22:15:52 +0800
MIME-Version: 1.0
In-Reply-To: <20180723140103.GN26141@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/23/2018 10:01 PM, David Sterba wrote:
> On Mon, Jul 16, 2018 at 10:58:10PM +0800, Anand Jain wrote:
>> In preparation to de-duplicate a section of code where we deduce the
>> num_devices, use warn instead of bug.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 7f4973fc2b52..0f4c512aa6b4 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -3726,7 +3726,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>>   	num_devices = fs_info->fs_devices->num_devices;
>>   	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>>   	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>> -		BUG_ON(num_devices < 1);
>> +		WARN_ON(num_devices < 1);
> 
> I wonder if there any valid cases when there are 0 devices when balance
> is started, ie. before num_devices gets decremented.

  num_devices counts the in-memory devices of a fsid.
  On a mounted FS num_devices > 0 always.

> The WARN_ON is either redundant or should be turned to a proper sanity
> check.

   Yes is redundant. I suggest to delete it.

Thanks, Anand

>>   		num_devices--;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
