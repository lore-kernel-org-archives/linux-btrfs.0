Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50312 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab2FOBnH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 21:43:07 -0400
Message-ID: <4FDA94EF.9030601@cn.fujitsu.com>
Date: Fri, 15 Jun 2012 09:50:39 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] Btrfs: use large extent range for read and its endio
References: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com> <1339582751-32029-4-git-send-email-liubo2009@cn.fujitsu.com> <20120614161239.GU32402@twin.jikos.cz>
In-Reply-To: <20120614161239.GU32402@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15/2012 12:12 AM, David Sterba wrote:

> On Wed, Jun 13, 2012 at 06:19:10PM +0800, Liu Bo wrote:
>> we use larger extent state range for both readpages and read endio, so that
>> we can lock or unlock less and avoid most of split ops, then we'll reduce write
>> locks taken at endio time.
>>
>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>> ---
>>  fs/btrfs/extent_io.c |  201 +++++++++++++++++++++++++++++++++++++++++++++-----
>>  1 files changed, 182 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 081fe13..bb66e3c 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -2258,18 +2258,26 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
>>  	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
>>  	struct bio_vec *bvec = bio->bi_io_vec;
>>  	struct extent_io_tree *tree;
>> +	struct extent_state *cached = NULL;
>>  	u64 start;
>>  	u64 end;
>>  	int whole_page;
>>  	int mirror;
>>  	int ret;
>> +	u64 up_start, up_end, un_start, un_end;
>> +	int up_first, un_first;
>> +	int for_uptodate[bio->bi_vcnt];
> 
> The array size depends on an argument, compiler will handle it by
> dynamically expanding the stackframe. What is the expected maximum value
> for bi_vcnt ? There's no hard limit AFAICS, the value gets incremented
> on each page in the bio. If the function is called from the worker
> thread, it's not much of a problem even for values like 128.
> 
> Alternate way to avoid over-limit stack consumption is to declare an
> array to hold a fair number of items (eg. 16), and fall back to kmalloc
> otherwise.
> 


hmm, you're right.  I'm going to use kmalloc with KERNEL_ATOMIC.


>> +	int i = 0;
>> +
>> +	up_start = un_start = (u64)-1;
>> +	up_end = un_end = 0;
>> +	up_first = un_first = 1;
>>  
>>  	if (err)
>>  		uptodate = 0;
>>  
>>  	do {
>>  		struct page *page = bvec->bv_page;
>> -		struct extent_state *cached = NULL;
>>  
>>  		pr_debug("end_bio_extent_readpage: bi_vcnt=%d, idx=%d, err=%d, "
>>  			 "mirror=%ld\n", bio->bi_vcnt, bio->bi_idx, err,
>> @@ -2352,7 +2412,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
>>  			}
>>  			unlock_page(page);
>>  		} else {
>> -			if (uptodate) {
>> +			if (for_uptodate[i++]) {
>>  				check_page_uptodate(tree, page);
>>  			} else {
>>  				clearpageuptodate(page);
>> @@ -2360,6 +2420,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
>>  			}
>>  			check_page_locked(tree, page);
>>  		}
>> +		++bvec;
> 
> can you please move the i++ increments here? From reading the code it's
> not clear on first sight if the sideeffects are ok.
> 


Sure, will update it.

>>  	} while (bvec <= bvec_end);
>>  
>>  	bio_put(bio);
>> @@ -2554,6 +2615,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
>>  
>>  	end = page_end;
>>  	while (1) {
>> +		if (range_lock)
>> +			break;
> 
> with range_lock set, this is equivalent to calling
> 
> 2896	set_page_extent_mapped(page);
> 
> (plus the cleancache code), a few lines above. Is this inteded? It's
> actually called with '1' from a single place, process_batch_pages().
> 


Yeah, I want to skip the lock part, since I've already locked this range of extent.
After that, we'll have a continuous range of extent for read.


>>  		lock_extent(tree, start, end);
>>  		ordered = btrfs_lookup_ordered_extent(inode, start);
>>  		if (!ordered)
>> @@ -3497,6 +3560,59 @@ int extent_writepages(struct extent_io_tree *tree,
>>  	return ret;
>>  }
>>  
>> +struct page_list {
>> +	struct page *page;
>> +	struct list_head list;
>> +};
>> +
>> +static int process_batch_pages(struct extent_io_tree *tree,
>> +			       struct address_space *mapping,
>> +			       struct list_head *lock_pages, int *page_cnt,
>> +			       u64 lock_start, u64 lock_end,
>> +				get_extent_t get_extent, struct bio **bio,
>> +				unsigned long *bio_flags)
>> +{
>> +	u64 page_start;
>> +	struct page_list *plist;
>> +
>> +	while (1) {
>> +		struct btrfs_ordered_extent *ordered = NULL;
>> +
>> +		lock_extent(tree, lock_start, lock_end);
>> +		page_start = lock_start;
>> +		while (page_start < lock_end) {
>> +			ordered = btrfs_lookup_ordered_extent(mapping->host,
>> +							      page_start);
>> +			if (ordered) {
>> +				page_start = ordered->file_offset;
>> +				break;
>> +			}
>> +			page_start += PAGE_CACHE_SIZE;
>> +		}
>> +		if (!ordered)
>> +			break;
> 
> You're leaving the range [lock_start, lock_end) locked after taking this
> branch. Intended?
> 


Yeah, this is what it should be.
Usually we do:

o  lock the range that is going to be sent to read (at read_page)
o  set the range uptodate and unlock it (at end_io)


>> +		unlock_extent(tree, lock_start, lock_end);
>> +		btrfs_start_ordered_extent(mapping->host, ordered, 1);
>> +		btrfs_put_ordered_extent(ordered);
>> +	}
>> +
>> +	plist = NULL;
>> +	while (!list_empty(lock_pages)) {
>> +		plist = list_entry(lock_pages->prev, struct page_list, list);
>> +
>> +		__extent_read_full_page(tree, plist->page, get_extent,
>> +					bio, 0, bio_flags, 1);
>> +		page_cache_release(plist->page);
>> +		list_del(&plist->list);
>> +		plist->page = NULL;
> 
> you can drop this assignment
> 


Sure.

Thanks a lot for reviewing! :)


thanks,
liubo

>> +		kfree(plist);
>> +		(*page_cnt)--;
>> +	}
>> +
>> +	WARN_ON((*page_cnt));
>> +	return 0;
>> +}
>> +
>>  int extent_readpages(struct extent_io_tree *tree,
>>  		     struct address_space *mapping,
>>  		     struct list_head *pages, unsigned nr_pages,
> 


