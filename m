Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60264 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754650AbcJMFqX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 01:46:23 -0400
Subject: Re: [PATCH 1/2] btrfs: introduce priority based delalloc shrink
 mechanism
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1476263029-11879-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <ac29d0ae-d497-9c8b-d6c4-186cce27f336@fb.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57FF1E50.7000706@cn.fujitsu.com>
Date: Thu, 13 Oct 2016 13:40:32 +0800
MIME-Version: 1.0
In-Reply-To: <ac29d0ae-d497-9c8b-d6c4-186cce27f336@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

On 10/13/2016 01:20 AM, Josef Bacik wrote:
> On 10/12/2016 05:03 AM, Wang Xiaoguang wrote:
>> Since commit b02441999efcc6152b87cd58e7970bb7843f76cf, we don't wait all
>> ordered extents, but I run into some enospc errors when doing large file
>> create and delete tests, it's because shrink_delalloc() does not write
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
>> Here we introduce a simple reclaim_priority variable, the higher the
>> value, the higher the priority, 0 is the minimum priority. The core
>> idea is:
>>         if (reclaim_priority >= 3)
>>                 to_reclaim = 
>> percpu_counter_sum_positive(&root->fs_info->delalloc_bytes);
>>         else
>>                 to_reclaim = orig * (2 << (reclaim_priority + 1));
>> As the priority increases, we try wo write more delalloc bytes, here 
>> orig
>> is the number of metadata we want to reserve. Meanwhile if
>> "reclaim_priority >= 3" returns true, we'll also wait all current 
>> ordered
>> extents to finish.
>
> Ok this is closer to what I want but not quite there.  I want to get 
> rid of the magic numbers, so we start with
>
> #define BTRFS_DEFAULT_FLUSH_PRIORITY 3
>
> and once priority == 0 we know it's time to flush and wait for all the 
> things. Then we use the priority as a multiplier, with DEFAULT being 
> no multiplier, so it would look something like this
>
> if (reclaim_priority)
>     to_reclaim = orig * (2 << BTRFS_DEFAULT_FLUSH_PRIORITY - priority);
> else
>     to_reclaim = delalloc_bytes;
> ....
> if (reclaim_priority)
>     items_to_wait = calc_reclaim_items_nr(root, to_reclaim);
> else
>     items_to_wait = -1;
>
>
> and then instead of
>
> if (reclaim_priority > 3) {
>     wake_all_tickets(&space_info->tickets);
> ...
>
> we can change the while loop to be
>
> while ((flush_state <= COMMIT_TRANS) || (--reclaim_priority >= 0));
>
> and move the wake_all_tickets() to outside the loop, and add a
>
> if (flush_state > COMMIT_TRANS)
>     flush_state = FLUSH_DELAYED_ITEMS_NR;
>
> to the start of the do loop.  Does that make sense?  Thanks,
Yes, thanks for your kindly help.
For "wake_all_tickets()", I think we still need to put it in the while loop,
If we move it outside, we need to relock btrfs_space_info's lock, but
here there maybe some race window, some new tickets maybe added in,
we should not wake up them directly and should also do some flush work
for them.

Regards,
Xiaoguang Wang

>
> Josef
>
>



