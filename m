Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F305CC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 08:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A16CC205C9
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 08:50:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A16CC205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbeK2Tyx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 14:54:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:37022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726565AbeK2Tyw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 14:54:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8F8A0AE65;
        Thu, 29 Nov 2018 08:50:11 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] fs: Don't open-code lru_to_page
To:     Michal Hocko <mhocko@kernel.org>
Cc:     linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Steve French <sfrench@samba.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Shakeel Butt <shakeelb@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, devel@lists.orangefs.org,
        linux-mm@kvack.org
References: <20181129075301.29087-1-nborisov@suse.com>
 <20181129075301.29087-2-nborisov@suse.com>
 <20181129081826.GO6923@dhcp22.suse.cz>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <0921bc8f-b899-4925-51f2-a9f45d4c906a@suse.com>
Date:   Thu, 29 Nov 2018 10:50:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181129081826.GO6923@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 29.11.18 г. 10:18 ч., Michal Hocko wrote:
> On Thu 29-11-18 09:52:57, Nikolay Borisov wrote:
>> There are a bunch of filesystems which essentially open-code lru_to_page
>> helper. Change them to using the helper. No functional changes.
> 
> I would just squash the two into a single patch. It makes the first one
> more obvious. Or is there any reason to have them separate?

No reason, just didn't know how people would react so that's why I chose
to send as two separate.

If I squash them who would be the best person to take them ?

> 
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> 
>> ---
>>
>> Since this is a mostly mechanical change I've actually batched all of them in 
>> a single patch. 
>>
>>  fs/afs/file.c        | 5 +++--
>>  fs/btrfs/extent_io.c | 2 +-
>>  fs/ceph/addr.c       | 5 ++---
>>  fs/cifs/file.c       | 3 ++-
>>  fs/ext4/readpage.c   | 2 +-
>>  fs/ocfs2/aops.c      | 3 ++-
>>  fs/orangefs/inode.c  | 2 +-
>>  mm/swap.c            | 2 +-
>>  8 files changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/afs/file.c b/fs/afs/file.c
>> index d6bc3f5d784b..323ae9912203 100644
>> --- a/fs/afs/file.c
>> +++ b/fs/afs/file.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/writeback.h>
>>  #include <linux/gfp.h>
>>  #include <linux/task_io_accounting_ops.h>
>> +#include <linux/mm.h>
>>  #include "internal.h"
>>  
>>  static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
>> @@ -441,7 +442,7 @@ static int afs_readpages_one(struct file *file, struct address_space *mapping,
>>  	/* Count the number of contiguous pages at the front of the list.  Note
>>  	 * that the list goes prev-wards rather than next-wards.
>>  	 */
>> -	first = list_entry(pages->prev, struct page, lru);
>> +	first = lru_to_page(pages);
>>  	index = first->index + 1;
>>  	n = 1;
>>  	for (p = first->lru.prev; p != pages; p = p->prev) {
>> @@ -473,7 +474,7 @@ static int afs_readpages_one(struct file *file, struct address_space *mapping,
>>  	 * page at the end of the file.
>>  	 */
>>  	do {
>> -		page = list_entry(pages->prev, struct page, lru);
>> +		page = lru_to_page(pages);
>>  		list_del(&page->lru);
>>  		index = page->index;
>>  		if (add_to_page_cache_lru(page, mapping, index,
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 19f4b8fd654f..8332c5f4b1c3 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -4104,7 +4104,7 @@ int extent_readpages(struct address_space *mapping, struct list_head *pages,
>>  	u64 prev_em_start = (u64)-1;
>>  
>>  	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
>> -		page = list_entry(pages->prev, struct page, lru);
>> +		page = lru_to_page(pages);
>>  
>>  		prefetchw(&page->flags);
>>  		list_del(&page->lru);
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 8eade7a993c1..5d0c05e288cc 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -306,7 +306,7 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
>>  	struct ceph_osd_client *osdc =
>>  		&ceph_inode_to_client(inode)->client->osdc;
>>  	struct ceph_inode_info *ci = ceph_inode(inode);
>> -	struct page *page = list_entry(page_list->prev, struct page, lru);
>> +	struct page *page = lru_to_page(page_list);
>>  	struct ceph_vino vino;
>>  	struct ceph_osd_request *req;
>>  	u64 off;
>> @@ -333,8 +333,7 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
>>  			if (got)
>>  				ceph_put_cap_refs(ci, got);
>>  			while (!list_empty(page_list)) {
>> -				page = list_entry(page_list->prev,
>> -						  struct page, lru);
>> +				page = lru_to_page(page_list);
>>  				list_del(&page->lru);
>>  				put_page(page);
>>  			}
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 74c33d5fafc8..b16a4d887d17 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -33,6 +33,7 @@
>>  #include <linux/mount.h>
>>  #include <linux/slab.h>
>>  #include <linux/swap.h>
>> +#include <linux/mm.h>
>>  #include <asm/div64.h>
>>  #include "cifsfs.h"
>>  #include "cifspdu.h"
>> @@ -3975,7 +3976,7 @@ readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
>>  
>>  	INIT_LIST_HEAD(tmplist);
>>  
>> -	page = list_entry(page_list->prev, struct page, lru);
>> +	page = lru_to_page(page_list);
>>  
>>  	/*
>>  	 * Lock the page and put it in the cache. Since no one else
>> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
>> index f461d75ac049..6aa282ee455a 100644
>> --- a/fs/ext4/readpage.c
>> +++ b/fs/ext4/readpage.c
>> @@ -128,7 +128,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
>>  
>>  		prefetchw(&page->flags);
>>  		if (pages) {
>> -			page = list_entry(pages->prev, struct page, lru);
>> +			page = lru_to_page(pages);
>>  			list_del(&page->lru);
>>  			if (add_to_page_cache_lru(page, mapping, page->index,
>>  				  readahead_gfp_mask(mapping)))
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index eb1ce30412dc..832c1759a09a 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -30,6 +30,7 @@
>>  #include <linux/quotaops.h>
>>  #include <linux/blkdev.h>
>>  #include <linux/uio.h>
>> +#include <linux/mm.h>
>>  
>>  #include <cluster/masklog.h>
>>  
>> @@ -397,7 +398,7 @@ static int ocfs2_readpages(struct file *filp, struct address_space *mapping,
>>  	 * Check whether a remote node truncated this file - we just
>>  	 * drop out in that case as it's not worth handling here.
>>  	 */
>> -	last = list_entry(pages->prev, struct page, lru);
>> +	last = lru_to_page(pages);
>>  	start = (loff_t)last->index << PAGE_SHIFT;
>>  	if (start >= i_size_read(inode))
>>  		goto out_unlock;
>> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
>> index fe53381b26b1..f038235c64bd 100644
>> --- a/fs/orangefs/inode.c
>> +++ b/fs/orangefs/inode.c
>> @@ -77,7 +77,7 @@ static int orangefs_readpages(struct file *file,
>>  	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
>>  		struct page *page;
>>  
>> -		page = list_entry(pages->prev, struct page, lru);
>> +		page = lru_to_page(pages);
>>  		list_del(&page->lru);
>>  		if (!add_to_page_cache(page,
>>  				       mapping,
>> diff --git a/mm/swap.c b/mm/swap.c
>> index aa483719922e..20b9e9d99652 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -126,7 +126,7 @@ void put_pages_list(struct list_head *pages)
>>  	while (!list_empty(pages)) {
>>  		struct page *victim;
>>  
>> -		victim = list_entry(pages->prev, struct page, lru);
>> +		victim = lru_to_page(pages);
>>  		list_del(&victim->lru);
>>  		put_page(victim);
>>  	}
>> -- 
>> 2.17.1
> 
