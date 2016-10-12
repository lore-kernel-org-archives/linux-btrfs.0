Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40697 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754719AbcJLRKu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 13:10:50 -0400
Subject: Re: [PATCH 1/2] btrfs: try to satisfy metadata requests when every
 flush_space() returns
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1474441173-31049-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <64702aa8-206f-d167-a4c7-0303864a1e23@fb.com>
 <57FDE5EA.2050700@cn.fujitsu.com>
CC: <dsterba@suse.cz>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <53fbfe64-741b-892d-c7c8-5f842382bb03@fb.com>
Date: Wed, 12 Oct 2016 13:08:40 -0400
MIME-Version: 1.0
In-Reply-To: <57FDE5EA.2050700@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/12/2016 03:27 AM, Wang Xiaoguang wrote:
> hi,
>
> On 10/07/2016 09:16 PM, Josef Bacik wrote:
>> On 09/21/2016 02:59 AM, Wang Xiaoguang wrote:
>>> In flush_space()->shrink_delalloc(), if can_overcommit() returns true,
>>> though no bytes added to space_info, we still may satisfy some requests.
>>>
>>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/extent-tree.c | 39 +++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 39 insertions(+)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 38c2df8..fdfc97f 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -4960,6 +4960,43 @@ static void wake_all_tickets(struct list_head *head)
>>>  }
>>>
>>>  /*
>>> + * This function must be protected by btrfs_space_info's lock.
>>> + */
>>> +static void try_to_wake_tickets(struct btrfs_root *root,
>>> +                struct btrfs_space_info *space_info)
>>> +{
>>> +    struct reserve_ticket *ticket;
>>> +    struct list_head *head = &space_info->priority_tickets;
>>> +    enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_NO_FLUSH;
>>> +    u64 used;
>>> +
>>> +again:
>>> +    while (!list_empty(head)) {
>>> +        ticket = list_first_entry(head, struct reserve_ticket,
>>> +                      list);
>>> +        used = space_info->bytes_used +
>>> +            space_info->bytes_reserved + space_info->bytes_pinned +
>>> +            space_info->bytes_readonly + space_info->bytes_may_use;
>>> +
>>> +        if (used + ticket->bytes <= space_info->total_bytes ||
>>> +            can_overcommit(root, space_info, ticket->bytes, flush)) {
>>> +            space_info->bytes_may_use += ticket->bytes;
>>> +            list_del_init(&ticket->list);
>>> +            ticket->bytes = 0;
>>> +            space_info->tickets_id++;
>>> +            wake_up(&ticket->wait);
>>> +        } else
>>> +            return;
>>> +    }
>>> +
>>> +    if (head == &space_info->priority_tickets) {
>>> +        head = &space_info->tickets;
>>> +        flush = BTRFS_RESERVE_FLUSH_ALL;
>>> +        goto again;
>>> +    }
>>> +}
>>> +
>>> +/*
>>>   * This is for normal flushers, we can wait all goddamned day if we want
>>> to.  We
>>>   * will loop and continuously try to flush as long as we are making progress.
>>>   * We count progress as clearing off tickets each time we have to loop.
>>> @@ -4995,6 +5032,8 @@ static void btrfs_async_reclaim_metadata_space(struct
>>> work_struct *work)
>>>          ret = flush_space(fs_info->fs_root, space_info, to_reclaim,
>>>                  to_reclaim, flush_state);
>>>          spin_lock(&space_info->lock);
>>> +        if (!ret)
>>> +            try_to_wake_tickets(fs_info->fs_root, space_info);
>>>          if (list_empty(&space_info->tickets)) {
>>>              space_info->flush = 0;
>>>              spin_unlock(&space_info->lock);
>>>
>>
>> So first off I have no problems with this patch, it seems reasonable to me.
>>
>> However I'm curious to see where it helped.  The only time can_overcommit()
>> would suddenly start returning true where it wouldn't have before without
>> actually adding space to the space_info would be when we've dropped an empty
>> block group (or added a new drive) and suddenly fs_info->free_chunk_space is
>> larger than it was.  Is that what you were observing?  Thanks,
> I think you're right. I don't add new drive when doing my big files create and
> delete test, so
> it maybe "remove useless chunks" causing can_overcommit() returns true, but I
> don't know
> how to observe this in codes, sorry. And this patch can really help to fix my
> enospc issue :)
>
> Meanwhile, in shrink_delalloc(), if can_overcommit() returns true,
> shrink_delalloc()
> will not shrink delalloc bytes any more, in this case we should check whether
> some tickcts' requests can overcommit, if some can, we can satisfy them timely
> and directly.
>
> I notice original btrfs codes before your patch "Btrfs: introduce ticketed
> enospc infrastructure"
> will have over_commit try when every flush_space() returns, so here we may also
> need to do it, thanks.
>

Oh so you are deleting big files, that could free up block groups which would 
make can_overcommit() suddenly start returning true.  That makes sense.  You can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
