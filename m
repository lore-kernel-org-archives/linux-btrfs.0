Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49803 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751771AbdBBSnR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Feb 2017 13:43:17 -0500
Date: Thu, 2 Feb 2017 19:42:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: remove duplicated find_get_pages_contig
Message-ID: <20170202184243.GE16723@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1485807990-17973-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485807990-17973-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2017 at 12:26:30PM -0800, Liu Bo wrote:
> This creates a helper to manipulate page bits to avoid duplicate uses.

This seems too short for what the patch does. It adds a new page ops bit
that would deserve a separate patch. Please try to split it to smaller
parts.

> +static noinline void __unlock_for_delalloc(struct inode *inode,
> +					   struct page *locked_page,
> +					   u64 start, u64 end)
> +{
> +	unsigned long page_ops = PAGE_UNLOCK;

Used only once, not necessary IMO.

> +
> +	ASSERT(locked_page);
> +	__process_pages_contig(inode->i_mapping, locked_page,
> +			       start >> PAGE_SHIFT, end >> PAGE_SHIFT,
> +			       page_ops, NULL);
> +}
> +
> +static noinline int lock_delalloc_pages(struct inode *inode,
> +					struct page *locked_page,
> +					u64 delalloc_start,
> +					u64 delalloc_end)
> +{
> +	pgoff_t index = delalloc_start >> PAGE_SHIFT;
> +	pgoff_t start_index = index;
> +	pgoff_t end_index = delalloc_end >> PAGE_SHIFT;
> +	unsigned long page_ops = PAGE_LOCK;

Same here.

> +	int ret = 0;
> +
> +	ASSERT(locked_page);
> +
> +	ret = __process_pages_contig(inode->i_mapping, locked_page, start_index,
> +			       end_index, page_ops, &index);
> +	if (ret == -EAGAIN) {
> +		__unlock_for_delalloc(inode, locked_page, delalloc_start,
> +				      ((u64)index) << PAGE_SHIFT);
>  	}
> +
>  	return ret;
>  }
