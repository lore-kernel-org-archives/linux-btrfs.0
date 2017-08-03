Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:38682 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdHCPZH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 11:25:07 -0400
Received: by mail-yw0-f194.google.com with SMTP id p68so1009296ywg.5
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Aug 2017 08:25:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e19d649f-8ee6-fade-f4d9-c303a2e01fcc@fb.com>
References: <20170727185255.5122-1-fdmanana@kernel.org> <e19d649f-8ee6-fade-f4d9-c303a2e01fcc@fb.com>
From: Wang Shilong <wangshilong1991@gmail.com>
Date: Thu, 3 Aug 2017 23:25:05 +0800
Message-ID: <CAP9B-QnAMtTHGxTe-A72uK_1m-vmAxSKj-No63R3NSXjwE=b1g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: avoid unnecessarily locking inode when clearing a range
To: Chris Mason <clm@fb.com>
Cc: fdmanana@kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 3, 2017 at 11:00 PM, Chris Mason <clm@fb.com> wrote:
>
>
> On 07/27/2017 02:52 PM, fdmanana@kernel.org wrote:
>>
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> If the range being cleared was not marked for defrag and we are not
>> about to clear the range from the defrag status, we don't need to
>> lock and unlock the inode.
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
>
> Thanks Filipe, looks like it goes all the way back to:
>
> commit 47059d930f0e002ff851beea87d738146804726d
> Author: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Date:   Thu Jul 3 18:22:07 2014 +0800
>
>     Btrfs: make defragment work with nodatacow option
>
> I can't see how the inode lock is required here.

This blames to me, thanks for fixing it.

Reviewed-by: Wang Shilong <wangshilong1991@gmail.com>

>
> Reviewed-by: Chris Mason <clm@fb.com>
>
> -chris
>
>> ---
>>   fs/btrfs/inode.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index eb495e956d53..51c45c0a8553 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -1797,10 +1797,11 @@ static void btrfs_clear_bit_hook(void
>> *private_data,
>>         u64 len = state->end + 1 - state->start;
>>         u32 num_extents = count_max_extents(len);
>>   -     spin_lock(&inode->lock);
>> -       if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG))
>> +       if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG)) {
>> +               spin_lock(&inode->lock);
>>                 inode->defrag_bytes -= len;
>> -       spin_unlock(&inode->lock);
>> +               spin_unlock(&inode->lock);
>> +       }
>>         /*
>>          * set_bit and clear bit hooks normally require _irqsave/restore
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
