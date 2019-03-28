Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E238CC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA37021773
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfC1OKH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 10:10:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:40342 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbfC1OKH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 10:10:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17D1EB11E;
        Thu, 28 Mar 2019 14:10:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4D1ABDA8D8; Thu, 28 Mar 2019 15:11:18 +0100 (CET)
Date:   Thu, 28 Mar 2019 15:11:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] btrfs: Preallocate chunks in cow_file_range_async
Message-ID: <20190328141118.GI29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190312152030.31987-1-nborisov@suse.com>
 <20190312152030.31987-2-nborisov@suse.com>
 <20190327172308.GA29086@twin.jikos.cz>
 <04687d49-6642-54bf-1a8f-18f6b54465a0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <04687d49-6642-54bf-1a8f-18f6b54465a0@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 02:49:30PM +0200, Nikolay Borisov wrote:
> 
> 
> On 27.03.19 г. 19:23 ч., David Sterba wrote:
> > On Tue, Mar 12, 2019 at 05:20:24PM +0200, Nikolay Borisov wrote:
> >> @@ -1190,45 +1201,71 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
> >>  				unsigned int write_flags)
> >>  {
> >>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> >> -	struct async_cow *async_cow;
> >> +	struct async_cow *ctx;
> >> +	struct async_chunk *async_chunk;
> >>  	unsigned long nr_pages;
> >>  	u64 cur_end;
> >> +	u64 num_chunks = DIV_ROUND_UP(end - start, SZ_512K);
> >> +	int i;
> >> +	bool should_compress;
> >>  
> >>  	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
> >>  			 1, 0, NULL);
> >> -	while (start < end) {
> >> -		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
> >> -		BUG_ON(!async_cow); /* -ENOMEM */
> >> +
> >> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
> >> +	    !btrfs_test_opt(fs_info, FORCE_COMPRESS)) {
> >> +		num_chunks = 1;
> >> +		should_compress = false;
> >> +	} else {
> >> +		should_compress = true;
> >> +	}
> >> +
> >> +	ctx = kmalloc(struct_size(ctx, chunks, num_chunks), GFP_NOFS);
> > 
> > This leads to OOM due to high order allocation. And this is worse than
> > the previous state, where there are many small allocation that could
> > potentially fail (but most likely will not due to GFP_NOSF and size <
> > PAGE_SIZE).
> > 
> > So this needs to be reworked to avoid the costly allocations or reverted
> > to the previous state.
> 
> Right, makes sense. In order to have a simplified submission logic I
> think to rework the allocation to have a loop that allocates a single
> item for every chunk or alternatively switch to using kvmalloc? I think
> the fact that vmalloced memory might not be contiguous is not critical
> for the metadata structures in this case?

kvmalloc would work here, though there is some overhead involved
compared to bare kmalloc (the mappings). As the call happens on writeout
path, I'd be cautious about unnecessary overhead.

If looping over the range works, then we can allocate the largest size
that does not require kvmalloc (PAGE_ALLOC_COSTLY_ORDER) and then reuse
it for each iteration.
