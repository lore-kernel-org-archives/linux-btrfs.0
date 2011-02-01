From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix return value check of btrfs_start_transaction()
Date: Tue, 01 Feb 2011 11:15:32 +0900
Message-ID: <4D476CC4.6030902@jp.fujitsu.com>
References: <201101200619.AA00004@T-ITOH1.jp.fujitsu.com> <20110120160959.GB6609@dhcp231-156.rdu.redhat.com> <4D38C980.3020001@jp.fujitsu.com> <4D392265.1020003@jp.fujitsu.com> <1296251516-sup-9915@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296251516-sup-9915@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

(2011/01/29 6:53), Chris Mason wrote:
> Excerpts from Tsutomu Itoh's message of 2011-01-21 01:06:29 -0500:
>> (2011/01/21 8:47), Tsutomu Itoh wrote:
>>> (2011/01/21 1:09), Josef Bacik wrote:
>>>> I'd rather we go through and have these things return an error than do a
>>>> BUG_ON().  We're moving towards a more stable BTRFS, not one that panics more
>>>> often :).
>>>
>>> Yes, I also think so.
>>> This patch is my first step.
>>>
>>> My modification policy is as follows:
>>>
>>> 1. short term
>>>  - To more stable BTRFS, the part that should be corrected is clarified. 
>>>  - The panic is not done by the NULL pointer reference etc.
>> This means, even if temporary increase BUG_ON()...
>>
>> In addition, I think that an important memory allocation should retry several times. 
>> So, I propose the following patches as this sample.
>>
>>>
>>> 2. long term
>>>  - BUG_ON() is decreased by using the forced-readonly framework(already posted by Liu Bo),
>>>    etc. 
>>
>>
>> This patch retries kmem_cache_alloc() in start_transaction() several times. 
> 
> Thanks for working on these, it's really good to see these error checks
> going on.
> 
> We don't want to loop on kmem_cache_alloc(), for allocations less than
> 4KB, the allocator only returns NULL if the box has gone into OOM
> anyway.  By the time we get these, things have gone horribly wrong.
> 
> If we really can't fail, we can use GFP_NOFAIL, which loops for us.

I agree to your opinion, and please ignore following patch.
But, please apply http://marc.info/?l=linux-btrfs&m=129550441505242&w=2

Thanks,
Itoh

> 
> -chris
> 
>>
>> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> ---
>>  fs/btrfs/transaction.c |   22 +++++++++++++++++++++-
>>  1 file changed, 21 insertions(+), 1 deletion(-)
>>
>> diff -urNp linux-2.6.38-rc1/fs/btrfs/transaction.c linux-2.6.38-rc1.new/fs/btrfs/transaction.c
>> --- linux-2.6.38-rc1/fs/btrfs/transaction.c    2011-01-19 08:14:02.000000000 +0900
>> +++ linux-2.6.38-rc1.new/fs/btrfs/transaction.c    2011-01-21 14:08:02.000000000 +0900
>> @@ -22,6 +22,7 @@
>>  #include <linux/writeback.h>
>>  #include <linux/pagemap.h>
>>  #include <linux/blkdev.h>
>> +#include <linux/ratelimit.h>
>>  #include "ctree.h"
>>  #include "disk-io.h"
>>  #include "transaction.h"
>> @@ -175,6 +176,25 @@ static int may_wait_transaction(struct b
>>      return 0;
>>  }
>>  
>> +#define MAX_ITERATIONS 10
>> +
>> +static struct btrfs_trans_handle *alloc_trans_handle(void)
>> +{
>> +    struct btrfs_trans_handle *ret;
>> +    int i = 0;
>> +
>> +    ret = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
>> +    if (!ret) {
>> +        pr_notice_ratelimited("ENOMEM in %s, retrying.\n", __func__);
>> +        do {
>> +            yield();
>> +            ret = kmem_cache_alloc(btrfs_trans_handle_cachep,
>> +                        GFP_NOFS);
>> +        } while (!ret && i++ < MAX_ITERATIONS);
>> +    }
>> +    return ret;
>> +}
>> +
>>  static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
>>                              u64 num_items, int type)
>>  {
>> @@ -185,7 +205,7 @@ static struct btrfs_trans_handle *start_
>>      if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
>>          return ERR_PTR(-EROFS);
>>  again:
>> -    h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
>> +    h = alloc_trans_handle();
>>      if (!h)
>>          return ERR_PTR(-ENOMEM);
>>  

