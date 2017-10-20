Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18782 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753166AbdJTReg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 13:34:36 -0400
Subject: Re: [PATCH] btrfs: clean up btrfs_dev_stat_inc() usage
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171020095059.3730-1-anand.jain@oracle.com>
 <20171020152717.GR3521@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <884912c4-9590-b17c-5e35-3e4f9c417e67@oracle.com>
Date: Sat, 21 Oct 2017 01:34:26 +0800
MIME-Version: 1.0
In-Reply-To: <20171020152717.GR3521@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/20/2017 11:27 PM, David Sterba wrote:
> On Fri, Oct 20, 2017 at 05:50:59PM +0800, Anand Jain wrote:
>> btrfs_end_bio() is using btrfs_dev_stat_inc() and then
>> btrfs_dev_stat_print_on_error() separately instead
>> use btrfs_dev_stat_inc_and_print() directly.
>>
>> No need to worry about print lines one for read/write
>> and another if the source of IO request is flush, since
>> as mentioned in this patch
>>   [patch] btrfs: REQ_PREFLUSH does not use btrfs_end_bio() completion callback
> 
> I don't see such patch merged, I've only found
> https://patchwork.kernel.org/patch/9619949/
> so the remark in the changelog is insufficient to understand what you're
> referring to.
> 
> This patch itself looks good but the changelog should be improved.

  Sure will update.

Thanks, Anand


>> there isn't any IO which is doing that.
>>
>> This consolidation is a preparatory patch to add device
>> critical error handling in btrfs_dev_stat_inc_and_print()
>> and can be renamed as needed.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index efaf85dd91b0..d1d8aa226bff 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6004,15 +6004,14 @@ static void btrfs_end_bio(struct bio *bio)
>>   			dev = bbio->stripes[stripe_index].dev;
>>   			if (dev->bdev) {
>>   				if (bio_op(bio) == REQ_OP_WRITE)
>> -					btrfs_dev_stat_inc(dev,
>> +					btrfs_dev_stat_inc_and_print(dev,
>>   						BTRFS_DEV_STAT_WRITE_ERRS);
>>   				else
>> -					btrfs_dev_stat_inc(dev,
>> +					btrfs_dev_stat_inc_and_print(dev,
>>   						BTRFS_DEV_STAT_READ_ERRS);
>>   				if (bio->bi_opf & REQ_PREFLUSH)

  With reference to the un-merged patch I meant to say it never
  reaches this part since the

>> -					btrfs_dev_stat_inc(dev,
>> +					btrfs_dev_stat_inc_and_print(dev,
>>   						BTRFS_DEV_STAT_FLUSH_ERRS);



>> -				btrfs_dev_stat_print_on_error(dev);
>>   			}
>>   		}
>>   	}
>> -- 
>> 2.13.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
