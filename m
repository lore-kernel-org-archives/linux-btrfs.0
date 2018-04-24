Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60417 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756182AbeDXGW2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 02:22:28 -0400
Subject: Re: [PATCH 1/3] btrfs: simplify counting number of eb pages
To: Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1524523681.git.dsterba@suse.com>
 <faf2e8e2cb4f87f4b418b177256d8950cd8deba1.1524523682.git.dsterba@suse.com>
 <27114496-d14c-7210-a130-3acb39f21677@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8d6068cc-c383-393c-2776-55851093b7a2@gmx.com>
Date: Tue, 24 Apr 2018 14:22:15 +0800
MIME-Version: 1.0
In-Reply-To: <27114496-d14c-7210-a130-3acb39f21677@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月24日 13:59, Nikolay Borisov wrote:
> 
> 
> On 24.04.2018 02:03, David Sterba wrote:
>> The eb length is nodesize, as initialized in __alloc_extent_buffer.
>> Regardless of start, we should always get the same number of pages, so
>> use that fact.
>>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> ---
>>  fs/btrfs/extent_io.h | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
>> index a53009694b16..ee92c1289edd 100644
>> --- a/fs/btrfs/extent_io.h
>> +++ b/fs/btrfs/extent_io.h
>> @@ -454,8 +454,7 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
>>  
>>  static inline unsigned long num_extent_pages(u64 start, u64 len)
>>  {
>> -	return ((start + len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
>> -		(start >> PAGE_SHIFT);
>> +	return len >> PAGE_SHIFT;
> 
> Shouldn't this really be len + PAGE_SIZE -1 or in fact DIV_ROUND_DOWN
> (len, PAGE_SIZE). Because with a nodesize of 4k (and basically less than
> a page size) we can get into a situation where we do:
> 
> 4096 >> 13 = 0
> 
> On powerpc for example we have:
> 
> arch/powerpc/include/asm/page.h:#define PAGE_SHIFT              18
> arch/powerpc/include/asm/page.h:#define PAGE_SHIFT              16
> arch/powerpc/include/asm/page.h:#define PAGE_SHIFT              14

For such case, the fs won't be mounted as we don't have sub-pagesized
nodesize support yet.
So won't hit the problem.

Although a WARN_ON(len < PAGE_SIZE || IS_ALIGNED(start, PAGE_SIZE))
would do no harm here.

Thanks,
Qu

> arch/powerpc/include/asm/page.h:#define PAGE_SHIFT              12
> 
> 
>>  }
>>  
>>  static inline void extent_buffer_get(struct extent_buffer *eb)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
