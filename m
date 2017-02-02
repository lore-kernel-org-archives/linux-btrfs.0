Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19427 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750934AbdBBTLW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 14:11:22 -0500
Date: Thu, 2 Feb 2017 11:11:15 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove duplicated find_get_pages_contig
Message-ID: <20170202191115.GE6550@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1485807990-17973-1-git-send-email-bo.li.liu@oracle.com>
 <20170202184243.GE16723@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170202184243.GE16723@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 07:42:43PM +0100, David Sterba wrote:
> On Mon, Jan 30, 2017 at 12:26:30PM -0800, Liu Bo wrote:
> > This creates a helper to manipulate page bits to avoid duplicate uses.
> 
> This seems too short for what the patch does. It adds a new page ops bit
> that would deserve a separate patch. Please try to split it to smaller
> parts.

Hmm..the newly added 'PAGE_LOCK' is only used in lock_delalloc_pages in
order to make the helper lock pages.

I could firstly introduce the helper from extent_clear_unlock_delalloc()
, then introduce the new 'PAGE_LOCK' and make lock_delalloc_pages and
__unlock_for_delalloc to use the helper, does it sound better to review
and bisect?

> 
> > +static noinline void __unlock_for_delalloc(struct inode *inode,
> > +					   struct page *locked_page,
> > +					   u64 start, u64 end)
> > +{
> > +	unsigned long page_ops = PAGE_UNLOCK;
> 
> Used only once, not necessary IMO.

OK.

> 
> > +
> > +	ASSERT(locked_page);
> > +	__process_pages_contig(inode->i_mapping, locked_page,
> > +			       start >> PAGE_SHIFT, end >> PAGE_SHIFT,
> > +			       page_ops, NULL);
> > +}
> > +
> > +static noinline int lock_delalloc_pages(struct inode *inode,
> > +					struct page *locked_page,
> > +					u64 delalloc_start,
> > +					u64 delalloc_end)
> > +{
> > +	pgoff_t index = delalloc_start >> PAGE_SHIFT;
> > +	pgoff_t start_index = index;
> > +	pgoff_t end_index = delalloc_end >> PAGE_SHIFT;
> > +	unsigned long page_ops = PAGE_LOCK;
> 
> Same here.
> 

OK.

Thanks,

-liubo
> > +	int ret = 0;
> > +
> > +	ASSERT(locked_page);
> > +
> > +	ret = __process_pages_contig(inode->i_mapping, locked_page, start_index,
> > +			       end_index, page_ops, &index);
> > +	if (ret == -EAGAIN) {
> > +		__unlock_for_delalloc(inode, locked_page, delalloc_start,
> > +				      ((u64)index) << PAGE_SHIFT);
> >  	}
> > +
> >  	return ret;
> >  }
