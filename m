Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:42107 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423712AbeCBLAe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 06:00:34 -0500
Received: by mail-ua0-f196.google.com with SMTP id b23so5806548uak.9
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Mar 2018 03:00:33 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <7f7b8437-8def-18be-3e94-6a50c2bfabda@gmx.com>
References: <20180302052254.7059-1-wqu@suse.com> <20180302052254.7059-3-wqu@suse.com>
 <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com> <7f7b8437-8def-18be-3e94-6a50c2bfabda@gmx.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 2 Mar 2018 11:00:32 +0000
Message-ID: <CAL3q7H6YN7-Vd8oaxH_7J41Bfhjor_XyC5NvsC0-tZ_UhfT_=g@mail.gmail.com>
Subject: Re: [PATCH 2/5] btrfs: Always limit inline extent size by
 uncompressed size
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        dsterba@suse.cz
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 2, 2018 at 10:54 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年03月02日 18:46, Filipe Manana wrote:
>> On Fri, Mar 2, 2018 at 5:22 AM, Qu Wenruo <wqu@suse.com> wrote:
>>> Normally when specifying max_inline, we should normally limit it by
>>> uncompressed extent size, as it's the only thing user can control.
>>
>> Why does it matter that users can control it? Will they write less (or
>> more) data to files because stuff won't get inlined?
>> Why do they care about stuff getting inlined or not? That's an
>> implementation detail of btrfs to speed up access to file data and
>> save some space.
>
> Then why we still have max_inline mount option?

My comment was about deciding based on which size to make the decision
(compressed vs uncompressed).

> Just do everything we *think* is best is good enough in that case.
>
> If we provide that mount option to allow *user* to specify the behavior,
> then allow then to do the same control.
>
> Thanks,
> Qu
>
>>
>>> (Control the algorithm and compressed data is almost impossible)
>>>
>>> Since btrfs is providing *TRANSPARENT* compression, max_inline should
>>> behave the same for both plain and compress data.
>>
>> Taking away the benefits of compression for. So now some cases that
>> ended up getting the benefits of inlining won't get them anymore.
>>
>> I don't agree with this change.
>
>
>>
>>>
>>> So this patch will use @inline_len instead of @data_len in
>>> cow_file_range_inline() so user will know their max_inline mount option
>>> works exactly the same for both plain and compressed data extent.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  fs/btrfs/inode.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index e1a7f3cb5be9..48472509239b 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -303,7 +303,7 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
>>>             (!compressed_size &&
>>>             (actual_end & (fs_info->sectorsize - 1)) == 0) ||
>>>             end + 1 < isize ||
>>> -           data_len > fs_info->max_inline) {
>>> +           inline_len > fs_info->max_inline) {
>>>                 return 1;
>>>         }
>>>
>>> --
>>> 2.16.2
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
