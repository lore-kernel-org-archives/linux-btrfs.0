Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:46003 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754191AbcLABmb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 20:42:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 01 Dec 2016 09:42:23 +0800
From: robbieko <robbieko@synology.com>
To: fdmanana@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix infinite loop when tree log recovery
In-Reply-To: <CAL3q7H7F=fiETSd5SVwq=EPP9gKK0-tRvwA_N6N=yFrujKGYMA@mail.gmail.com>
References: <1475832647-14012-1-git-send-email-robbieko@synology.com>
 <CAL3q7H7F=fiETSd5SVwq=EPP9gKK0-tRvwA_N6N=yFrujKGYMA@mail.gmail.com>
Message-ID: <ecb6ff393956132565b191bdc38875b0@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

Thank you for your review.
I have seen your modified change log with below
     Btrfs: fix tree search logic when replaying directory entry deletes
     Btrfs: fix deadlock caused by fsync when logging directory entries
     Btrfs: fix enospc in hole punching
So what's the next step ?
modify patch change log and then send again ?

Thanks.
robbieko

Filipe Manana 於 2016-12-01 00:53 寫到:
> On Fri, Oct 7, 2016 at 10:30 AM, robbieko <robbieko@synology.com> 
> wrote:
>> From: Robbie Ko <robbieko@synology.com>
>> 
>> if log tree like below:
>> leaf N:
>>         ...
>>         item 240 key (282 DIR_LOG_ITEM 0) itemoff 8189 itemsize 8
>>                 dir log end 1275809046
>> leaf N+1:
>>         item 0 key (282 DIR_LOG_ITEM 3936149215) itemoff 16275 
>> itemsize 8
>>                 dir log end 18446744073709551615
>>         ...
>> 
>> when start_ret > 1275809046, but slot[0] never >= nritems,
>> so never go to next leaf.
> 
> This doesn't explain how the infinite loop happens. Nor exactly how
> any problem happens.
> 
> It's important to have detailed information in the change logs. I
> understand that english isn't your native tongue (it's not mine
> either, and I'm far from mastering it), but that's not an excuse to
> not express all the important information in detail (we can all live
> with grammar errors and typos, and we all do such errors frequently).
> 
> I've added this patch to my branch at
> https://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/log/?h=for-chris-4.10
> but with a modified changelog and subject.
> 
> The results of the wrong logic that decides when to move to the next
> leaf are unpredictable, and it won't always result in an infinite
> loop. We are accessing a slot that doesn't point to an item, to a
> memory location containing garbage to something unexpected, and in the
> worst case that location is beyond the last page of the extent buffer.
> 
> Thanks.
> 
> 
>> 
>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>> ---
>>  fs/btrfs/tree-log.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>> 
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index ef9c55b..e63dd99 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -1940,12 +1940,11 @@ static noinline int find_dir_range(struct 
>> btrfs_root *root,
>>  next:
>>         /* check the next slot in the tree to see if it is a valid 
>> item */
>>         nritems = btrfs_header_nritems(path->nodes[0]);
>> +       path->slots[0]++;
>>         if (path->slots[0] >= nritems) {
>>                 ret = btrfs_next_leaf(root, path);
>>                 if (ret)
>>                         goto out;
>> -       } else {
>> -               path->slots[0]++;
>>         }
>> 
>>         btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> --
>> 1.9.1
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



