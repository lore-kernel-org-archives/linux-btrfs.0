Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:3139 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751353AbdKVBoW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 20:44:22 -0500
Subject: Re: [PATCH 1/3] btrfs-progs: check: report more specific info about
 invalid location
To: Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
 <9fd908df-187d-67a1-266f-e885075d81e8@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <7bf3e48d-6081-ee10-4e2e-ad79678f94e2@cn.fujitsu.com>
Date: Wed, 22 Nov 2017 09:48:03 +0800
MIME-Version: 1.0
In-Reply-To: <9fd908df-187d-67a1-266f-e885075d81e8@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/21/2017 07:46 PM, Nikolay Borisov wrote:
> 
> 
> On 21.11.2017 12:15, Su Yue wrote:
>> Previously, it was so useless to print message like
>> "invalid location %d".
>>
>> Let it print objectid and offset of dir_item.
>> Debug is easier now.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   cmds-check.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index a93ac2c88a38..5c15dfb60b9a 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -1635,8 +1635,8 @@ static int process_dir_item(struct extent_buffer *eb,
>>   					  namebuf, len, filetype,
>>   					  key->type, error);
>>   		} else {
>> -			fprintf(stderr, "invalid location in dir item %u\n",
>> -				location.type);
>> +			fprintf(stderr, "invalid location in dir item[%llu %llu]\n",
>> +				key->objectid, key->offset);
> 
> I think it will be good if in addition to the dir item's key you also
> print the invalid type value. I.e. this check is triggered if
> location.type is unrecognizable. So the error message could be something
> like :
> 
> fprintf(stderr, "Unrecognised location.type (%u) in DIR_ITEM[%llu
> %llu]", key->objectid, key->offset);
> 
Thanks. Printing location type is more specific.
I will update the patch.

Thanks,
Su
> Let's not force the user to go and read the code to understand why this
> error happened.
> 
> 
>>   			add_inode_backref(inode_cache, BTRFS_MULTIPLE_OBJECTIDS,
>>   					  key->objectid, key->offset, namebuf,
>>   					  len, filetype, key->type, error);
>>
> 
> 


