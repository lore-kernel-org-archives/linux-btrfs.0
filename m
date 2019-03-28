Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89DBC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA4320823
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbfC1PKr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 11:10:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:54544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbfC1PKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 11:10:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A8E72AC94
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2019 15:10:45 +0000 (UTC)
Subject: Re: [PATCH 1/7] btrfs: Preallocate chunks in cow_file_range_async
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20190312152030.31987-1-nborisov@suse.com>
 <20190312152030.31987-2-nborisov@suse.com>
 <20190327172308.GA29086@twin.jikos.cz>
 <04687d49-6642-54bf-1a8f-18f6b54465a0@suse.com>
 <20190328141118.GI29086@twin.jikos.cz>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <fb80bc17-9cf2-cee3-3c16-4075a36cc78a@suse.com>
Date:   Thu, 28 Mar 2019 17:10:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190328141118.GI29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.03.19 г. 16:11 ч., David Sterba wrote:
> On Thu, Mar 28, 2019 at 02:49:30PM +0200, Nikolay Borisov wrote:
>>
>>
>> On 27.03.19 г. 19:23 ч., David Sterba wrote:
>>> On Tue, Mar 12, 2019 at 05:20:24PM +0200, Nikolay Borisov wrote:
>>>> @@ -1190,45 +1201,71 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>>>>  				unsigned int write_flags)
>>>>  {
>>>>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>>>> -	struct async_cow *async_cow;
>>>> +	struct async_cow *ctx;
>>>> +	struct async_chunk *async_chunk;
>>>>  	unsigned long nr_pages;
>>>>  	u64 cur_end;
>>>> +	u64 num_chunks = DIV_ROUND_UP(end - start, SZ_512K);
>>>> +	int i;
>>>> +	bool should_compress;
>>>>  
>>>>  	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
>>>>  			 1, 0, NULL);
>>>> -	while (start < end) {
>>>> -		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
>>>> -		BUG_ON(!async_cow); /* -ENOMEM */
>>>> +
>>>> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
>>>> +	    !btrfs_test_opt(fs_info, FORCE_COMPRESS)) {
>>>> +		num_chunks = 1;
>>>> +		should_compress = false;
>>>> +	} else {
>>>> +		should_compress = true;
>>>> +	}
>>>> +
>>>> +	ctx = kmalloc(struct_size(ctx, chunks, num_chunks), GFP_NOFS);
>>>
>>> This leads to OOM due to high order allocation. And this is worse than
>>> the previous state, where there are many small allocation that could
>>> potentially fail (but most likely will not due to GFP_NOSF and size <
>>> PAGE_SIZE).
>>>
>>> So this needs to be reworked to avoid the costly allocations or reverted
>>> to the previous state.
>>
>> Right, makes sense. In order to have a simplified submission logic I
>> think to rework the allocation to have a loop that allocates a single
>> item for every chunk or alternatively switch to using kvmalloc? I think
>> the fact that vmalloced memory might not be contiguous is not critical
>> for the metadata structures in this case?
> 
> kvmalloc would work here, though there is some overhead involved
> compared to bare kmalloc (the mappings). As the call happens on writeout
> path, I'd be cautious about unnecessary overhead.
> 
> If looping over the range works, then we can allocate the largest size
> that does not require kvmalloc (PAGE_ALLOC_COSTLY_ORDER) and then reuse
> it for each iteration.

I'm afraid I don't understand your hybrid suggestion. Ie something along 
the lines of : 

if (struct_size(ctx, chunks, num_chunks) < ((2 << PAGE_ALLOC_COSTLY_ORDER) * PAGE_SIZE))  {
     use kmalloc
} else { 

????
}

> 
