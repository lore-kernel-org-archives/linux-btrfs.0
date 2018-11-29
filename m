Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C30C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 11:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFD222081C
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 11:38:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFD222081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbeK2Wnr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 17:43:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbeK2Wnr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 17:43:47 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C75030001E8;
        Thu, 29 Nov 2018 11:38:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ADAD462997;
        Thu, 29 Nov 2018 11:38:41 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3D9801809546;
        Thu, 29 Nov 2018 11:38:41 +0000 (UTC)
Date:   Thu, 29 Nov 2018 06:38:40 -0500 (EST)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
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
Message-ID: <1231450124.37408874.1543491520867.JavaMail.zimbra@redhat.com>
In-Reply-To: <0921bc8f-b899-4925-51f2-a9f45d4c906a@suse.com>
References: <20181129075301.29087-1-nborisov@suse.com> <20181129075301.29087-2-nborisov@suse.com> <20181129081826.GO6923@dhcp22.suse.cz> <0921bc8f-b899-4925-51f2-a9f45d4c906a@suse.com>
Subject: Re: [PATCH 2/2] fs: Don't open-code lru_to_page
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.116.136, 10.4.195.28]
Thread-Topic: Don't open-code lru_to_page
Thread-Index: f6plNFJ2u+TeYP0RguagIH0cNHPblQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 29 Nov 2018 11:38:43 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


> >> There are a bunch of filesystems which essentially open-code lru_to_page
> >> helper. Change them to using the helper. No functional changes.
> > 
> > I would just squash the two into a single patch. It makes the first one
> > more obvious. Or is there any reason to have them separate?
> 
> No reason, just didn't know how people would react so that's why I chose
> to send as two separate.
> 
> If I squash them who would be the best person to take them ?

For squashed version:
Acked-by: Pankaj gupta <pagupta@redhat.com>

> 
> > 
> >> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > 
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > 
> >> ---
> >>
> >> Since this is a mostly mechanical change I've actually batched all of them
> >> in
> >> a single patch.
> >>
> >>  fs/afs/file.c        | 5 +++--
> >>  fs/btrfs/extent_io.c | 2 +-
> >>  fs/ceph/addr.c       | 5 ++---
> >>  fs/cifs/file.c       | 3 ++-
> >>  fs/ext4/readpage.c   | 2 +-
> >>  fs/ocfs2/aops.c      | 3 ++-
> >>  fs/orangefs/inode.c  | 2 +-
> >>  mm/swap.c            | 2 +-
> >>  8 files changed, 13 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/fs/afs/file.c b/fs/afs/file.c
> >> index d6bc3f5d784b..323ae9912203 100644
> >> --- a/fs/afs/file.c
> >> +++ b/fs/afs/file.c
> >> @@ -17,6 +17,7 @@
> >>  #include <linux/writeback.h>
> >>  #include <linux/gfp.h>
> >>  #include <linux/task_io_accounting_ops.h>
> >> +#include <linux/mm.h>
> >>  #include "internal.h"
> >>  
> >>  static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
> >> @@ -441,7 +442,7 @@ static int afs_readpages_one(struct file *file, struct
> >> address_space *mapping,
> >>  	/* Count the number of contiguous pages at the front of the list.  Note
> >>  	 * that the list goes prev-wards rather than next-wards.
> >>  	 */
> >> -	first = list_entry(pages->prev, struct page, lru);
> >> +	first = lru_to_page(pages);
> >>  	index = first->index + 1;
> >>  	n = 1;
> >>  	for (p = first->lru.prev; p != pages; p = p->prev) {
> >> @@ -473,7 +474,7 @@ static int afs_readpages_one(struct file *file, struct
> >> address_space *mapping,
> >>  	 * page at the end of the file.
> >>  	 */
> >>  	do {
> >> -		page = list_entry(pages->prev, struct page, lru);
> >> +		page = lru_to_page(pages);
> >>  		list_del(&page->lru);
> >>  		index = page->index;
> >>  		if (add_to_page_cache_lru(page, mapping, index,
> >> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> >> index 19f4b8fd654f..8332c5f4b1c3 100644
> >> --- a/fs/btrfs/extent_io.c
> >> +++ b/fs/btrfs/extent_io.c
> >> @@ -4104,7 +4104,7 @@ int extent_readpages(struct address_space *mapping,
> >> struct list_head *pages,
> >>  	u64 prev_em_start = (u64)-1;
> >>  
> >>  	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
> >> -		page = list_entry(pages->prev, struct page, lru);
> >> +		page = lru_to_page(pages);
> >>  
> >>  		prefetchw(&page->flags);
> >>  		list_del(&page->lru);
> >> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> >> index 8eade7a993c1..5d0c05e288cc 100644
> >> --- a/fs/ceph/addr.c
> >> +++ b/fs/ceph/addr.c
> >> @@ -306,7 +306,7 @@ static int start_read(struct inode *inode, struct
> >> ceph_rw_context *rw_ctx,
> >>  	struct ceph_osd_client *osdc =
> >>  		&ceph_inode_to_client(inode)->client->osdc;
> >>  	struct ceph_inode_info *ci = ceph_inode(inode);
> >> -	struct page *page = list_entry(page_list->prev, struct page, lru);
> >> +	struct page *page = lru_to_page(page_list);
> >>  	struct ceph_vino vino;
> >>  	struct ceph_osd_request *req;
> >>  	u64 off;
> >> @@ -333,8 +333,7 @@ static int start_read(struct inode *inode, struct
> >> ceph_rw_context *rw_ctx,
> >>  			if (got)
> >>  				ceph_put_cap_refs(ci, got);
> >>  			while (!list_empty(page_list)) {
> >> -				page = list_entry(page_list->prev,
> >> -						  struct page, lru);
> >> +				page = lru_to_page(page_list);
> >>  				list_del(&page->lru);
> >>  				put_page(page);
> >>  			}
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index 74c33d5fafc8..b16a4d887d17 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -33,6 +33,7 @@
> >>  #include <linux/mount.h>
> >>  #include <linux/slab.h>
> >>  #include <linux/swap.h>
> >> +#include <linux/mm.h>
> >>  #include <asm/div64.h>
> >>  #include "cifsfs.h"
> >>  #include "cifspdu.h"
> >> @@ -3975,7 +3976,7 @@ readpages_get_pages(struct address_space *mapping,
> >> struct list_head *page_list,
> >>  
> >>  	INIT_LIST_HEAD(tmplist);
> >>  
> >> -	page = list_entry(page_list->prev, struct page, lru);
> >> +	page = lru_to_page(page_list);
> >>  
> >>  	/*
> >>  	 * Lock the page and put it in the cache. Since no one else
> >> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> >> index f461d75ac049..6aa282ee455a 100644
> >> --- a/fs/ext4/readpage.c
> >> +++ b/fs/ext4/readpage.c
> >> @@ -128,7 +128,7 @@ int ext4_mpage_readpages(struct address_space
> >> *mapping,
> >>  
> >>  		prefetchw(&page->flags);
> >>  		if (pages) {
> >> -			page = list_entry(pages->prev, struct page, lru);
> >> +			page = lru_to_page(pages);
> >>  			list_del(&page->lru);
> >>  			if (add_to_page_cache_lru(page, mapping, page->index,
> >>  				  readahead_gfp_mask(mapping)))
> >> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> >> index eb1ce30412dc..832c1759a09a 100644
> >> --- a/fs/ocfs2/aops.c
> >> +++ b/fs/ocfs2/aops.c
> >> @@ -30,6 +30,7 @@
> >>  #include <linux/quotaops.h>
> >>  #include <linux/blkdev.h>
> >>  #include <linux/uio.h>
> >> +#include <linux/mm.h>
> >>  
> >>  #include <cluster/masklog.h>
> >>  
> >> @@ -397,7 +398,7 @@ static int ocfs2_readpages(struct file *filp, struct
> >> address_space *mapping,
> >>  	 * Check whether a remote node truncated this file - we just
> >>  	 * drop out in that case as it's not worth handling here.
> >>  	 */
> >> -	last = list_entry(pages->prev, struct page, lru);
> >> +	last = lru_to_page(pages);
> >>  	start = (loff_t)last->index << PAGE_SHIFT;
> >>  	if (start >= i_size_read(inode))
> >>  		goto out_unlock;
> >> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> >> index fe53381b26b1..f038235c64bd 100644
> >> --- a/fs/orangefs/inode.c
> >> +++ b/fs/orangefs/inode.c
> >> @@ -77,7 +77,7 @@ static int orangefs_readpages(struct file *file,
> >>  	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
> >>  		struct page *page;
> >>  
> >> -		page = list_entry(pages->prev, struct page, lru);
> >> +		page = lru_to_page(pages);
> >>  		list_del(&page->lru);
> >>  		if (!add_to_page_cache(page,
> >>  				       mapping,
> >> diff --git a/mm/swap.c b/mm/swap.c
> >> index aa483719922e..20b9e9d99652 100644
> >> --- a/mm/swap.c
> >> +++ b/mm/swap.c
> >> @@ -126,7 +126,7 @@ void put_pages_list(struct list_head *pages)
> >>  	while (!list_empty(pages)) {
> >>  		struct page *victim;
> >>  
> >> -		victim = list_entry(pages->prev, struct page, lru);
> >> +		victim = lru_to_page(pages);
> >>  		list_del(&victim->lru);
> >>  		put_page(victim);
> >>  	}
> >> --
> >> 2.17.1
> > 
> 
> 
