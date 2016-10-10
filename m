Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7297 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750717AbcJJJDc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 05:03:32 -0400
Subject: Re: [RFC 3/3] btrfs: make shrink_delalloc() try harder to reclaim
 metadata space
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1474441173-31049-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1474536319-22659-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <29f1f270-00dd-c788-ba08-634ad73c5b15@fb.com>
CC: <dsterba@suse.cz>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57FB5744.5060109@cn.fujitsu.com>
Date: Mon, 10 Oct 2016 16:54:28 +0800
MIME-Version: 1.0
In-Reply-To: <29f1f270-00dd-c788-ba08-634ad73c5b15@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 10/07/2016 09:24 PM, Josef Bacik wrote:
> On 09/22/2016 05:25 AM, Wang Xiaoguang wrote:
>> Since commit b02441999efcc6152b87cd58e7970bb7843f76cf, we don't wait all
>> ordered extents, but I run into some enospc errors when doing large file
>> create and delete test, it's because shrink_delalloc() does not write
>> enough delalloc bytes and wait them finished:
>>     From: Miao Xie <miaox@cn.fujitsu.com>
>>     Date: Mon, 4 Nov 2013 23:13:25 +0800
>>     Subject: [PATCH] Btrfs: don't wait for the completion of all the 
>> ordered extents
>>
>>     It is very likely that there are lots of ordered extents in the 
>> filesytem,
>>     if we wait for the completion of all of them when we want to 
>> reclaim some
>>     space for the metadata space reservation, we would be blocked for 
>> a long
>>     time. The performance would drop down suddenly for a long time.
>>
>> But since Josef introduced "Btrfs: introduce ticketed enospc 
>> infrastructure",
>> shrink_delalloc() starts to be run asynchronously, then If we want to 
>> reclaim
>> metadata space, we can try harder, after all, false enospc error is not
>> acceptable.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/extent-tree.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 46c2a37..f7c420b 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4721,7 +4721,7 @@ static void shrink_delalloc(struct btrfs_root 
>> *root, u64 to_reclaim, u64 orig,
>>          if (trans)
>>              return;
>>          if (wait_ordered)
>> -            btrfs_wait_ordered_roots(root->fs_info, items,
>> +            btrfs_wait_ordered_roots(root->fs_info, -1,
>>                           0, (u64)-1);
>>          return;
>>      }
>> @@ -4775,6 +4775,14 @@ skip_async:
>>          }
>>          delalloc_bytes = percpu_counter_sum_positive(
>> &root->fs_info->delalloc_bytes);
>> +        if (loops == 2) {
>> +            /*
>> +             * Try to write all current delalloc bytes and wait all
>> +             * ordered extents to have a last try.
>> +             */
>> +            to_reclaim = delalloc_bytes;
>> +            items = -1;
>> +        }
>>      }
>>  }
>>
>>
>
> The problem is if the outstanding ordered extents aren't enough to 
> actually return the space we need we end up flushing and waiting 
> longer when we should have just committed the transaction.  Think for 
> example if we are slowly writing to a few files and rapidly removing 
> thousands of files.  In this case all of our space is tied up in 
> pinned, so we'd be better off not waiting on ordered extents and 
> instead committing the transaction.
Yes, I see, writing ordered extents are involved in disk writes, which 
are much slow.

>
> I think instead what we should do is have a priority set, so instead 
> of doing commit_cycles in btrfs_async_reclaim_metadata_space, we 
> instead have priority, and set it to say 3.  Then we pass this 
> priority down to all of the flushers, and use it as a multiplier in 
> delalloc for the number of items we'll wait on. Once we hit priority 0 
> we wait for all the things.  This way we do the easy pass first and 
> hope it works, if not we try harder the next time through, etc until 
> we throw all caution to the wind and wait for anything we can find.  
> Thanks,
OK, thanks for your suggestions, I'll try to write a better version, thanks.

Regards,
Xiaoguang Wang
>
> Josef
>
>



