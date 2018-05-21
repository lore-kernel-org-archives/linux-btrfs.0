Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48352 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbeEUGfC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 02:35:02 -0400
Subject: Re: [PATCH v2 3/3] btrfs: balance: add kernel log for end or paused
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180516025128.9899-1-anand.jain@oracle.com>
 <20180516025128.9899-4-anand.jain@oracle.com>
 <20180517120640.GJ6649@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <fd85645e-6d15-69ec-2057-c48363ce96f3@oracle.com>
Date: Mon, 21 May 2018 14:37:30 +0800
MIME-Version: 1.0
In-Reply-To: <20180517120640.GJ6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/17/2018 08:06 PM, David Sterba wrote:
> On Wed, May 16, 2018 at 10:51:28AM +0800, Anand Jain wrote:
>> Add a kernel log when the balance ends, either for cancel or completed
>> or if it is paused.
> 
> Missing S-O-B.

  oops. Fixed in v3.

>> ---
>> v1->v2: Moved from 2/3 to 3/3
>>
>>   fs/btrfs/volumes.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index ce68c4f42f94..a4e243a29f5c 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -4053,6 +4053,13 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>>   	ret = __btrfs_balance(fs_info);
>>   
>>   	mutex_lock(&fs_info->balance_mutex);
>> +	if (ret == -ECANCELED && atomic_read(&fs_info->balance_pause_req))
>> +		btrfs_info(fs_info, "balance: paused");
>> +	else if (ret == -ECANCELED && atomic_read(&fs_info->balance_cancel_req))
>> +		btrfs_info(fs_info, "balance: canceled");
>> +	else
>> +		btrfs_info(fs_info, "balance: ended with status: %d", ret);
> 
> Wouldn't that repeat the same once again? There are status messages
> printed already, when eg. balance is cancelled or paused.

  No it won't. They are under if - else if- else. The __btrfs_balance()
  returns ECANCELED for both paused and canceled so bifurcating them
  here is useful.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
