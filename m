Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34855 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754623AbcKVJiO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 04:38:14 -0500
Subject: Re: [PATCH] btrfs: limit the number of asynchronous delalloc pages to
 reasonable value
To: Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1478597458-29287-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <bf1d53a3-34f5-6b08-2393-71f1c0d5056f@fb.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <58341045.3020609@cn.fujitsu.com>
Date: Tue, 22 Nov 2016 17:30:45 +0800
MIME-Version: 1.0
In-Reply-To: <bf1d53a3-34f5-6b08-2393-71f1c0d5056f@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 11/22/2016 01:59 AM, Chris Mason wrote:
> On 11/08/2016 04:30 AM, Wang Xiaoguang wrote:
>> The current limit of number of asynchronous delalloc pages is (10 * 
>> SZ_1M).
>> For 4K page, the total ram bytes would be 40G, very big value, I 
>> think in
>> most cases, this limit will not work, here I set limit of the number of
>> asynchronous delalloc pages to SZ_1M(4GB ram bytes).
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/inode.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 8e3a5a2..3a910f6 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -1158,7 +1158,7 @@ static int cow_file_range_async(struct inode 
>> *inode, struct page *locked_page,
>>      struct btrfs_root *root = BTRFS_I(inode)->root;
>>      unsigned long nr_pages;
>>      u64 cur_end;
>> -    int limit = 10 * SZ_1M;
>> +    int limit = SZ_1M;
>>
>>      clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, 
>> EXTENT_LOCKED,
>>               1, 0, NULL, GFP_NOFS);
>>
>
> As Dave points out, I didn't use the right units for this, so even 
> though we definitely waited on this limit while it was in development, 
> that was probably a different bug.
>
> Do you have a test case where the regular writeback throttling isn't 
> enough to also throttle the async delalloc pages?  It might be better 
> to just delete the limit entirely.
Sorry, I don't have one. The real limit is 10 * SZ_1M * 4096, 40GB 
memory, too big value,
and I don't see this limit actually takes effect in my test environment. 
I'm OK with removing
this limit :)

Regards,
Xiaoguang Wang
>
> -chris
>
>



