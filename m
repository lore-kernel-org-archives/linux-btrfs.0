Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35294 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933467AbeGBKDn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 06:03:43 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6DEB9AEC7
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 10:03:42 +0000 (UTC)
Subject: Re: [PATCH 1/4] btrfs: Refactor loop in
 btrfs_release_extent_buffer_page
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1530106705-27186-1-git-send-email-nborisov@suse.com>
 <1530106705-27186-2-git-send-email-nborisov@suse.com>
 <20180629123508.GQ2287@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <78c98716-d567-e8ca-8978-f951e4d340ae@suse.com>
Date: Mon, 2 Jul 2018 13:03:41 +0300
MIME-Version: 1.0
In-Reply-To: <20180629123508.GQ2287@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.06.2018 15:35, David Sterba wrote:
> On Wed, Jun 27, 2018 at 04:38:22PM +0300, Nikolay Borisov wrote:
>> The purpose of the function is to free all the pages comprising an
>> extent buffer. This can be achieved with a simple for loop rather than
>> the slitghly more involved 'do {} while' construct. So rewrite the
>> loop using a 'for' construct. Additionally we can never have an
>> extent_buffer that is 0 pages so remove the check for index == 0. No
>> functional changes.
> 
> The reversed loop makes sense, the first page is special and used for
> locking the whole extent buffer's pages, as can be seen eg.
> 897ca6e9b4fef86d5dfb6b31 or 4f2de97acee6532b36dd6e99 . Also see current
> alloc_extent_buffer for the locking and managing the private bit.

Turns out  page[0] is not special and it's not used for any special
locking whatsoever. In csum_dirty_buffer this page is used so that when
we submit a multipage eb then we only perform csum calculation once, i.e
when the first page (page[0]) is submitted.
btrfs_release_extent_buffer_page OTOH no longer takes an index but just
an EB and iterates all the pages.

The fact that page0 is unlocked last in alloc_extent_buffer seems to be
an artefact of the code refactoring rather than a deliberate behavior.
Furthermore I've been running tests with sequential unlocking (and
complete removal of the SetPageChecked/ClearPageChecked function from
alloc_extent_buffer) of the pages and didn't observe any problems
whatsoever on both 4g and 1g configuration ( the latter is more likely
to trigger premature page eviction hence trigger any lurking races
between alloc_extent_buffer and btree_releasepage. I will be sending a
patch after I do a bit more testing but so far the results are good.

> 
> So you can still rewrite it as a for loop but would have to preserve the
> logic or provide the reason that it's correct to iterate from 0 to
> num_pages. There are some subltle races regarding pages and extents and
> their presence in various trees, so I'd rather be careful here.
> 
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/extent_io.c | 13 ++++---------
>>  1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index cce6087d6880..4180a3b7e725 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -4641,19 +4641,14 @@ int extent_buffer_under_io(struct extent_buffer *eb)
>>   */
>>  static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
>>  {
>> -	unsigned long index;
>> -	struct page *page;
>> +	int i;
>>  	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
>>  
>>  	BUG_ON(extent_buffer_under_io(eb));
>>  
>> -	index = num_extent_pages(eb->start, eb->len);
>> -	if (index == 0)
>> -		return;
> 
> This check does seem to be redundant.
> 
>> +	for (i = 0; i < num_extent_pages(eb->start, eb->len); i++) {
> 
> I think that the num_extent_pages(...) would be better put to a
> temporary variable so it's not evaluated each time the loop termination
> condition is checked.
> 
>> +		struct page *page = eb->pages[i];
>>  
>> -	do {
>> -		index--;
>> -		page = eb->pages[index];
>>  		if (!page)
>>  			continue;
>>  		if (mapped)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
