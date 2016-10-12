Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47540 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751982AbcJLDmG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 23:42:06 -0400
Subject: Re: [RFC] btrfs: make max inline data can be equal to sectorsize
To: Chris Murphy <lists@colorremedies.com>
References: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
 <CAJCQCtRQpDiHh4bnm5H0dVkCt+JNLYBu23O_Z6ddpo550e2ngw@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57FDAF92.8040707@cn.fujitsu.com>
Date: Wed, 12 Oct 2016 11:35:46 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRQpDiHh4bnm5H0dVkCt+JNLYBu23O_Z6ddpo550e2ngw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

On 10/11/2016 11:49 PM, Chris Murphy wrote:
> On Tue, Oct 11, 2016 at 12:47 AM, Wang Xiaoguang
> <wangxg.fnst@cn.fujitsu.com> wrote:
>> If we use mount option "-o max_inline=sectorsize", say 4096, indeed
>> even for a fresh fs, say nodesize is 16k, we can not make the first
>> 4k data completely inline, I found this conditon causing this issue:
>>    !compressed_size && (actual_end & (root->sectorsize - 1)) == 0
>>
>> If it retuns true, we'll not make data inline. For 4k sectorsize,
>> 0~4094 dara range, we can make it inline, but 0~4095, it can not.
>> I don't think this limition is useful, so here remove it which will
>> make max inline data can be equal to sectorsize.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/inode.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index ea15520..c0db393 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -267,8 +267,6 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
>>          if (start > 0 ||
>>              actual_end > root->sectorsize ||
>>              data_len > BTRFS_MAX_INLINE_DATA_SIZE(root) ||
>> -           (!compressed_size &&
>> -           (actual_end & (root->sectorsize - 1)) == 0) ||
>>              end + 1 < isize ||
>>              data_len > root->fs_info->max_inline) {
>>                  return 1;
>> --
>> 2.9.0
>
> Before making any further changes to inline data, does it make sense
> to find the source of corruption Zygo has been experiencing? That's in
> the "btrfs rare silent data corruption with kernel data leak" thread.
Yes, agree.
Also Zygo has sent a patch to fix that bug this morning :)

Regards,
XIaoguang Wang

>
>



