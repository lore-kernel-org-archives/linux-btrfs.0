Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB05FC10F05
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 21:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8106B206C0
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 21:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfDAVlG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 17:41:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:41326 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726030AbfDAVlG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 17:41:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5F0B0ABA1;
        Mon,  1 Apr 2019 21:41:04 +0000 (UTC)
Date:   Mon, 1 Apr 2019 16:41:02 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/15] dax: Introduce IOMAP_F_COW for copy-on-write
Message-ID: <20190401214102.bn4giybeqpbvdbb3@merlin>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-5-rgoldwyn@suse.de>
 <20190401043851.GO26298@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401043851.GO26298@dastard>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 15:38 01/04, Dave Chinner wrote:
> On Tue, Mar 26, 2019 at 02:02:50PM -0500, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > The IOMAP_F_COW is a flag to notify dax that it needs to copy
> > the data from iomap->cow_addr to iomap->addr, if the start/end
> > of I/O are not page aligned.
> 
> I see what you are trying to do here, but this is kinda gross.
> 
> > This also introduces dax_to_dax_copy() which performs a copy
> > from one part of the device to another, to a maximum of one page.
> > 
> > Question: Using iomap.cow_addr == 0 means the CoW is to be copied
> > (or memset) from a hole. Would this be better handled through a flag?
> 
> That's what all these checks in the iomap code do:
> 

This is using iomap->flags not type.

> 	if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN)
> 
> Oh, wait, you're trying to map two ranges in a single iomap and then
> infer state from information that got chucked away.... IOWs, you're
> doing it wrong - iomap algorithms are driven by how we manipulate
> iomaps to do data operations efficiently, not how we copy data page
> by page.
> 
> IOWs, what we really should have here is two iomaps - a source
> and a destination iomap. The source is a read mapping of the
> current address (where we are going to copy the data from), the
> destination is the post-cow allocation mapping (where the data
> goes).
> 
> Now you just copy the data from one map to the other iterating
> source mappings until the necessary range of the destination has
> been covered.  And you can check if the source map is IOMAP_HOLE or
> IOMAP_UNWRITTEN and hence optimise the copy (i.e. zero the new
> allocation) before copying in the new data.

Won't that be inefficient? With CoW we only need to write the first
and last block. Again, that is not required if the offset/end
offset is block aligned. After that, it falls back to the
regular write path of performing dax_copy_to_iter().
We don't deal with IOMAP_UNWRITTEN in dax, though other
filesystems in the future may use CoW without dax.

Besides, what you are suggesting will not fit well with the
current iomap iterator code and would require another function
altogether. It is better suited for like file comparison range:
patch [11/16]. This would end up complicating/bloating the code.

> 
> Even better, only do the source mapping if the write isn't
> page/filesystem block aligned, and hence only do the slow path
> copying if a source mapping exists....
> 

The code already does this.
After Darrick's suggestion, we can even do away with cow_pos, so
only the read address of cow_addr will exist.

> > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > index 0fefb5455bda..391785de1428 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> > @@ -35,6 +35,7 @@ struct vm_fault;
> >  #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
> >  #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
> >  #define IOMAP_F_BUFFER_HEAD	0x04	/* file system requires buffer heads */
> > +#define IOMAP_F_COW		0x08	/* cow before write */
> 
> "Copy on write before write"? :)

Yes, I could use a better comment. Thanks for pointing.

-- 
Goldwyn
