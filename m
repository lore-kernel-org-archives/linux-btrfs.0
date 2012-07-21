Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab2GUDlU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 23:41:20 -0400
Message-ID: <500A1BFB.8070108@cn.fujitsu.com>
Date: Sat, 21 Jul 2012 11:03:23 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, jbacik@fusionio.com,
        dave@jikos.cz
Subject: Re: [PATCH v4] Btrfs: improve multi-thread buffer read
References: <1342763193-8733-1-git-send-email-liubo2009@cn.fujitsu.com> <20120720184208.GG3889@lenny.home.zabbo.net>
In-Reply-To: <20120720184208.GG3889@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/21/2012 02:42 AM, Zach Brown wrote:

>> +	struct page *page;
>> +	int i = 0;
>> +	int nr = 0;
> 
> i doesn't need to be initialized.
> 
>>  	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
>> -		struct page *page = list_entry(pages->prev, struct page, lru);
>> +		page = list_entry(pages->prev, struct page, lru);
>>  
>>  		prefetchw(&page->flags);
>>  		list_del(&page->lru);
>>  		if (!add_to_page_cache_lru(page, mapping,
>>  					page->index, GFP_NOFS)) {
>> -			__extent_read_full_page(tree, page, get_extent,
>> +			page_cache_get(page);
>> +			pagepool[nr++] = page;
>> +			if (nr == 16) {
> 
> ARRAY_SIZE(pagepool) instead of duplicating 16.
> 
>> +				for (i = 0; i < nr; i++) {
>> +					__extent_read_full_page(tree,
>> +						pagepool[i], get_extent,
>>  						&bio, 0, &bio_flags);
>> +					page_cache_release(pagepool[i]);
>> +				}
>> +				nr = 0;
>> +			}
>>  		}
>>  		page_cache_release(page);
> 
> It looks like you can optimize away a page cache ref here.  Don't add a
> ref when the page is added to the pool, instead use the existing ref.
> Then only release this ref here if add_to_page_cache_lru() succeeds.
> Then always release the ref when __extent_read_full_page is called on
> the pages in the pool.
> 


Sounds good, it makes btrfs's readpages hook a little different with others' though.

> I'd also invert the nested if()s to reduce the painful indent level:
> 
>   		if (add_to_page_cache_lru(page, mapping,
>   					page->index, GFP_NOFS)) {
> 			page_cache_release(page);
> 			continue;
> 		}
> 
> 		pagepool[nr++] = page;
> 		if (nr < ARRAY_SIZE(pagepool))
> 			continue;
> 
> 		for (i = 0; i < nr; i++) {
> 			__extent_read_full_page(tree, ...
> 
> - z
> 


I'll update it.  Thanks Zach.

thanks,
liubo
