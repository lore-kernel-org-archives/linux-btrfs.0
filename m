Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B967C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 12:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30C3F2064C
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 12:21:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30C3F2064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbeJ2VKR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Oct 2018 17:10:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:52280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728602AbeJ2VKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Oct 2018 17:10:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96A77B03C;
        Mon, 29 Oct 2018 12:21:48 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs: Fix error handling in
 btrfs_cleanup_ordered_extents
From:   Nikolay Borisov <nborisov@suse.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.de>,
        David Sterba <DSterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
References: <1540554115-11226-1-git-send-email-nborisov@suse.com>
 <abaee0e6-c865-3402-3352-33dc6a1d4ed7@suse.de>
 <10430924-b70e-4882-15fc-61c0376d83a4@suse.com>
 <86d8a6c9-8492-86c0-40d1-324342ab1e2a@gmx.com>
 <2b939b6c-7606-13ea-bfa0-a709fb634ae5@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <94c6c66e-bdca-8637-2970-d20aa3cd383b@suse.com>
Date:   Mon, 29 Oct 2018 14:21:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <2b939b6c-7606-13ea-bfa0-a709fb634ae5@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 29.10.18 г. 9:51 ч., Nikolay Borisov wrote:
> 
> 
> On 29.10.18 г. 7:53 ч., Qu Wenruo wrote:
>> [snip]
>>>> The cause sounds valid, however would you please explain more about how
>>>> such cleaning on unrelated delalloc range happens?
>>>
>>> So in my case the following happened - 2 block groups were created as
>>> delalloc ranges in the - 0-1m and 1m-128m. Their respective pages were
>>> dirtied, so when page 0 - 0-4k when into writepage_delalloc,
>>> find_lock_delalloc_range would return the range 0-1m. So the call to
>>> fill_delalloc instantiates OE 0-1m and writeback continues as expected.
>>>
>>> Now, when the 2nd page from range 0-1m is again set for writeback and
>>> find_lock_delalloc_range is called with delalloc_start ==  4096 it will
>>> actually return the range 1m-128m.
>>
>> IMHO this looks strange and may need extra investigation.
>>
>> Normally I would expect it returns the range 0~1M or 4K~1M.
> 
> It cannot return 4k-1m since the writeback for the first page has
> already dealt with this range. Also take a look in writepage_delalloc
> how find_lock_delalloc_range is called : for 'start' it's passed the
> page offset, calculated in __extent_writepage. And when
> find_delalloc_range is called it just searches for an extent which ends
> after passed start value. In find_delalloc_range  first    tree_search
> is called which returns the 1m-128m range, then we go in the while(1)
> loop on the first itertaion found is 0 so *end is populated with 128m ,
> found is set to 1 and *start is set to 1m.
> 
> On the second iteration the check  if (found && (state->start !=
> cur_start || (state->state & EXTENT_BOUNDARY)))
> 
> is triggered since the next extent found will have EXTENT_BOUNDARY since
> it will be the next block group from relocation. EXTENT_BOUNDARY will be
> set from relocate_file_extent_cluster' main loop:
> 
>           if (nr < cluster->nr &&
> 
>                     page_start + offset == cluster->boundary[nr]) {
> 
>                         set_extent_bits(&BTRFS_I(inode)->io_tree,
> 
>                                         page_start, page_end,
> 
>                                         EXTENT_BOUNDARY);
> 
>                         nr++;
> 
>                 }

So it seems I was wrong w.r.t to sequence of events that result in the  extra extent being returned. 
Here is what I got after further investigation. First let's look at the relocation side: 


btrfs-4018  [001] ....   186.783244: relocate_file_extent_cluster: Setting EXTENT_BOUNDARY for page: 0000000074cc47c4 page_offset: 0 end: 4095 <- first page of range 0-1m
btrfs-4018  [001] ....   186.783248: relocate_file_extent_cluster: Setting DELALLOC for page: 0000000074cc47c4 page_offset: 0 block group:1104150528 
btrfs-4018  [001] ....   186.783286: relocate_file_extent_cluster: Setting DELALLOC for page: 000000004a28475a page_offset: 4096 block group:1104150528 <- 2nd page of range 0-1m 
btrfs-4018  [001] ....   186.784855: relocate_file_extent_cluster: Setting EXTENT_BOUNDARY for page: 00000000f58f50dc page_offset: 1048576 end: 1052671 < - 1st page of range 1m-128m

Mind the addresses of the given pages, they are all predicated on btrfs_ino == 260, which is the ino for relocation inode. 

So the assumption is that when writing back page 000000004a28475a we cannot really be processing range >1m since it will
be outside of the range for the page, but this is not the case. Now on the writeback side: 

kworker/u12:1-68    [002] ....   188.100471: find_lock_delalloc_range: Processing delalloc range: 0 - 1048575 for page: 0000000074cc47c4 < - writeback for first page of range 0-1m happens 
so we naturally instantiate this range.

kworker/u12:1-68    [002] ...1   188.106523: find_delalloc_range.constprop.25: 1213015261107184058: Got start: 1048576 end 1052671 <- This is output from find_delalloc_range when start (the offset of the passed page to find_lock_delalloc_range is 4096 i.e it's the 2nd page for range 0-1m). So we find 1m - 1m + 4k on the first iteration of the loop in find_delalloc_range, at this point *start = 1048576 and *end = 1052671 and cached_state = the extent _state representing this first 4k range of the larger 1m-128m range.

kworker/u12:1-68    [002] ...1   188.106526: find_delalloc_range.constprop.25: 1213015261107184058: Got start: 1052672 end 135266303 - We loop for the second time, this time we find the 1m+4k - 128m range and actually trigger the (total_bytes >= max_bytes) check

kworker/u12:1-68    [002] ...1   188.106526: find_delalloc_range.constprop.25: 1213015261107184058: returning from total_bytes >= max_bytes

kworker/u12:1-68    [002] ....   188.106528: find_delalloc_range.constprop.25: 1213015261107184058: Returning cached_state->start: 1048576 cached_state->end: 1052671 *start = 1048576 *end = 135266303 <--- this is what is returned from find_delalloc_range - cached_state and *start and *end differ, since *end was set to 128m right before we hit the total_bytes check. 

kworker/u12:1-68    [002] ....   188.106529: find_lock_delalloc_range: Processing delalloc range: 1048576 - 135266303 for page: 000000004a28475a <--- after we return from find_delalloc_range this is what 
fin_lock_delalloc_range is processing - the next delalloc range 1m-128m but the page passed is indeed the 2nd page for the previous range as evident from the address 000000004a28475a
kworker/u12:1-68    [002] ....   188.113870: run_delalloc_nocow: btrfs_reloc_clone_csums err for OE[1048576 134217728] page->offset: 4096 end: 8191 <--- here we just create the OE in run_delalloc_nocow. 

The only thing which I'm now struggling to rationalize is why find_delalloc_range finds an extent_state in the range 1048576-1052671 and then finds another range 1052672 - 135266303, shouldn't in fact it 
find just 1048576 - 135266303. Perhaps it's due to the search being performed in the io_extent tree and not the extent_tree. 

Here is the data_reloc tree :

item 2 key (260 INODE_ITEM 0) itemoff 15951 itemsize 160
		generation 1 transid 30 size 940572672 nbytes 940572672
		block group 0 mode 100600 links 0 uid 0 gid 0 rdev 0
		sequence 8 flags 0x18(NOCOMPRESS|PREALLOC)
		atime 0.0 (1970-01-01 00:00:00)
		ctime 1540814915.362521123 (2018-10-29 12:08:35)
		mtime 0.0 (1970-01-01 00:00:00)
		otime 0.0 (1970-01-01 00:00:00)
	item 3 key (260 EXTENT_DATA 0) itemoff 15898 itemsize 53
		generation 28 type 2 (prealloc)
		prealloc data disk byte 3872391168 nr 1048576
		prealloc data offset 0 nr 1048576
	item 4 key (260 EXTENT_DATA 1048576) itemoff 15845 itemsize 53
		generation 28 type 2 (prealloc)
		prealloc data disk byte 3873439744 nr 134217728
		prealloc data offset 0 nr 134217728

as you can see we have a 0- 1048576 extent and 1048576-134217728. Those correspond to the following data block group being relocated: 

 item 139 key (1104150528 EXTENT_ITEM 1048576) itemoff 11661 itemsize 53
                refs 1 gen 7 flags DATA
                extent data backref root FS_TREE objectid 257 offset 0 count 1
 item 140 key (1104150528 BLOCK_GROUP_ITEM 1073741824) itemoff 11637 itemsize 24
                block group used 940572672 chunk_objectid 256 flags DATA|RAID1
 item 141 key (1105199104 EXTENT_ITEM 134217728) itemoff 11584 itemsize 53
                refs 1 gen 9 flags DATA
                extent data backref root FS_TREE objectid 258 offset 0 count 1











<snip>
