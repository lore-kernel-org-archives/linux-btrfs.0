Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2728 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751569AbaIABGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 21:06:34 -0400
Message-ID: <5403C692.4000705@cn.fujitsu.com>
Date: Mon, 1 Sep 2014 09:06:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>, Filipe David Manana <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Avoid trucating page or punching hole in a already
 existed hole.
References: <1401434170-30695-1-git-send-email-quwenruo@cn.fujitsu.com> <20140827081953.GA15994@localhost.localdomain> <CAL3q7H5R_nemONu2T2Fzwb7hCVEz7S+Zv0ctSfvRwe3LBHP11Q@mail.gmail.com> <20140827103412.GA24545@localhost.localdomain>
In-Reply-To: <20140827103412.GA24545@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Avoid trucating page or punching hole in a 
already existed hole.
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Manana <fdmanana@gmail.com>
Date: 2014年08月27日 18:34
> [snip]
>>> Why do we round_up lockstart but round_down lockend?
>>>
>>> For [0,4095], then lockstart is 4096 and lockend is (u64)-1, any thoughts?
>> Seems odd, but is it a problem for that case?
>> The same_page check below makes us return without locking the range in
>> the iotree using the computed values for lockstart and lockend.
> No problems so far luckily, but it's odd.
>
> thanks,
> -liubo
Sorry for the late replay. Off for serval days....

IMO, round up the start and round down the end is the correct way.

As shown in the following case(and is the most common case).
0        4K        8K        12K        16K
|    Data    |    Data    |    Data    |    Data    |
     |-------------Hole range--------|
     |-Zero--|--Hole extent--|-Zero--|

As the graph shows, the hole extent is the range aligned to page size and
*inside the hoped hole range*.

So, I round up start(offset) and round down end(offset + len) to get the
page aligned range.

Also, as mentioned by Filipe, for range in same page, it will be handled
specially without hitting the normal routine.

Thanks,
Qu

>>> thanks,
>>> -liubo
>>>
>>>> +     same_page = ((offset >> PAGE_CACHE_SHIFT) ==
>>>> +                 ((offset + len - 1) >> PAGE_CACHE_SHIFT));
>>>> +
>>>>        /*
>>>>         * We needn't truncate any page which is beyond the end of the file
>>>>         * because we are sure there is no data there.
>>>> @@ -2205,8 +2252,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>>>>        if (same_page && len < PAGE_CACHE_SIZE) {
>>>>                if (offset < ino_size)
>>>>                        ret = btrfs_truncate_page(inode, offset, len, 0);
>>>> -             mutex_unlock(&inode->i_mutex);
>>>> -             return ret;
>>>> +             goto out_only_mutex;
>>>>        }
>>>>
>>>>        /* zero back part of the first page */
>>>> @@ -2218,12 +2264,39 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>>>>                }
>>>>        }
>>>>
>>>> -     /* zero the front end of the last page */
>>>> -     if (offset + len < ino_size) {
>>>> -             ret = btrfs_truncate_page(inode, offset + len, 0, 1);
>>>> -             if (ret) {
>>>> -                     mutex_unlock(&inode->i_mutex);
>>>> -                     return ret;
>>>> +     /* Check the aligned pages after the first unaligned page,
>>>> +      * if offset != orig_start, which means the first unaligned page
>>>> +      * including serveral following pages are already in holes,
>>>> +      * the extra check can be skipped */
>>>> +     if (offset == orig_start) {
>>>> +             /* after truncate page, check hole again */
>>>> +             len = offset + len - lockstart;
>>>> +             offset = lockstart;
>>>> +             ret = find_first_non_hole(inode, &offset, &len);
>>>> +             if (ret < 0)
>>>> +                     goto out_only_mutex;
>>>> +             if (ret && !len) {
>>>> +                     ret = 0;
>>>> +                     goto out_only_mutex;
>>>> +             }
>>>> +             lockstart = offset;
>>>> +     }
>>>> +
>>>> +     /* Check the tail unaligned part is in a hole */
>>>> +     tail_start = lockend + 1;
>>>> +     tail_len = offset + len - tail_start;
>>>> +     if (tail_len) {
>>>> +             ret = find_first_non_hole(inode, &tail_start, &tail_len);
>>>> +             if (unlikely(ret < 0))
>>>> +                     goto out_only_mutex;
>>>> +             if (!ret) {
>>>> +                     /* zero the front end of the last page */
>>>> +                     if (tail_start + tail_len < ino_size) {
>>>> +                             ret = btrfs_truncate_page(inode,
>>>> +                                             tail_start + tail_len, 0, 1);
>>>> +                             if (ret)
>>>> +                                     goto out_only_mutex;
>>>> +                             }
>>>>                }
>>>>        }
>>>>
>>>> @@ -2299,6 +2372,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>>>>        BUG_ON(ret);
>>>>        trans->block_rsv = rsv;
>>>>
>>>> +     cur_offset = lockstart;
>>>> +     len = lockend - cur_offset;
>>>>        while (cur_offset < lockend) {
>>>>                ret = __btrfs_drop_extents(trans, root, inode, path,
>>>>                                           cur_offset, lockend + 1,
>>>> @@ -2339,6 +2414,14 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>>>>                                              rsv, min_size);
>>>>                BUG_ON(ret);    /* shouldn't happen */
>>>>                trans->block_rsv = rsv;
>>>> +
>>>> +             ret = find_first_non_hole(inode, &cur_offset, &len);
>>>> +             if (unlikely(ret < 0))
>>>> +                     break;
>>>> +             if (ret && !len) {
>>>> +                     ret = 0;
>>>> +                     break;
>>>> +             }
>>>>        }
>>>>
>>>>        if (ret) {
>>>> @@ -2372,6 +2455,7 @@ out_free:
>>>>   out:
>>>>        unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
>>>>                             &cached_state, GFP_NOFS);
>>>> +out_only_mutex:
>>>>        mutex_unlock(&inode->i_mutex);
>>>>        if (ret && !err)
>>>>                err = ret;
>>>> --
>>>> 1.9.3
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> -- 
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>   Unreasonable men adapt the world to themselves.
>>   That's why all progress depends on unreasonable men."

