Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F04C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 23:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2257020880
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 23:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfDAXHA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 19:07:00 -0400
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:35687 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbfDAXHA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 19:07:00 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl2.internode.on.net with ESMTP; 02 Apr 2019 09:36:55 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1hB60z-0005VL-7L; Tue, 02 Apr 2019 10:06:53 +1100
Date:   Tue, 2 Apr 2019 10:06:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/15] dax: Introduce IOMAP_F_COW for copy-on-write
Message-ID: <20190401230653.GT23020@dastard>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-5-rgoldwyn@suse.de>
 <20190401043851.GO26298@dastard>
 <20190401214102.bn4giybeqpbvdbb3@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401214102.bn4giybeqpbvdbb3@merlin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 01, 2019 at 04:41:02PM -0500, Goldwyn Rodrigues wrote:
> On 15:38 01/04, Dave Chinner wrote:
> > On Tue, Mar 26, 2019 at 02:02:50PM -0500, Goldwyn Rodrigues wrote:
> > > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > > 
> > > The IOMAP_F_COW is a flag to notify dax that it needs to copy
> > > the data from iomap->cow_addr to iomap->addr, if the start/end
> > > of I/O are not page aligned.
> > 
> > I see what you are trying to do here, but this is kinda gross.
> > 
> > > This also introduces dax_to_dax_copy() which performs a copy
> > > from one part of the device to another, to a maximum of one page.
> > > 
> > > Question: Using iomap.cow_addr == 0 means the CoW is to be copied
> > > (or memset) from a hole. Would this be better handled through a flag?
> > 
> > That's what all these checks in the iomap code do:
> > 
> 
> This is using iomap->flags not type.

Yes, I know. The fact that you tell me this (when it was obvious)
indicates to me that you didn't understand what I was saying.

i.e. the gross hack here is that this patch is trying to define a
new iomap type - both behaviourally and iomap content - via adding
a modifier flag rather than defining a new iomap->type. That's the
gross hack, and everything stems from that.

i.e. the "bloating" of the struct iomap is caused because the flag
modifier (IOMAP_F_COW) can't use parts of the iomap that are defined
for specific iomap types. e.g. IOMAP_INLINE type uses ->inline_data,
and so it can't be re-used by a iomap flag modifier such as
IOMAP_F_COW.

However, if we define a new type for this "need multiple mappings"
iomap rather than a flag, we don't need any new fields in the struct
iomap because we can use what already exists in the iomap.

> > 	if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN)
> > 
> > Oh, wait, you're trying to map two ranges in a single iomap and then
> > infer state from information that got chucked away.... IOWs, you're
> > doing it wrong - iomap algorithms are driven by how we manipulate
> > iomaps to do data operations efficiently, not how we copy data page
> > by page.
> > 
> > IOWs, what we really should have here is two iomaps - a source
> > and a destination iomap. The source is a read mapping of the
> > current address (where we are going to copy the data from), the
> > destination is the post-cow allocation mapping (where the data
> > goes).
> > 
> > Now you just copy the data from one map to the other iterating
> > source mappings until the necessary range of the destination has
> > been covered.  And you can check if the source map is IOMAP_HOLE or
> > IOMAP_UNWRITTEN and hence optimise the copy (i.e. zero the new
> > allocation) before copying in the new data.
> 
> Won't that be inefficient? With CoW we only need to write the first
> and last block.

You're assuming that partial data overwrites are the only case where
this dax-to-dax copy of a file range is required. That assumption is
false.

i.e. FALLOC_FL_UNSHARE_RANGE for DAX requires iterating over the
entire source range and copying all the contents to the newly
allocated destination range.  The partial block copying is just a
short version of this limited to a single block.

Sure, btrfs doesn't support FALLOC_FL_UNSHARE_RANGE, but if you're
going to be adding support for reflink to DAX, the infrastructure
needs to provide support for performing FALLOC_FL_UNSHARE_RANGE
to break extent sharing efficiently.

> Again, that is not required if the offset/end
> offset is block aligned. After that, it falls back to the
> regular write path of performing dax_copy_to_iter().
> We don't deal with IOMAP_UNWRITTEN in dax,

Yes we do. fallocate() can lay down unwritten extents, and we can
both read and write to them. See, for example, dax_iomap_actor()
called from dax_iomap_rw() via iomap_apply() - it does not call
dax_copy_to_iter() for reads if the range is IOMAP_HOLE or
IOMAP_UNWRITTEN.

> though other
> filesystems in the future may use CoW without dax.

That makes no sense. :/

> Besides, what you are suggesting will not fit well with the
> current iomap iterator code and would require another function
> altogether.

I'm not concerned about that - I would much prefer we do things
cleanly and properly rather than make expedient hacks for
questionable benefit that we'll have to completely rework or remove
the moment we implement DAX+reflink support in XFS.

> After Darrick's suggestion, we can even do away with cow_pos, so
> only the read address of cow_addr will exist.

As I mentioned earlier, even that is not necessary.

This is DAX - the iomap API and mapping functions can already return
pointers to inline data, and DAX can effectively be considered
inline data for the purposes of reading data.

As I said, the problem here is you are trying to use flags to define
a new type of iomap operation requires two mappings rather than one.
IMO, we should be defining an IOMAP_DAX_COW /type/ and then define
it to contain and behave as follows:

	- new destination region for data to be copied into is the
	  same setup as IOMAP_MAPPED
	- existing shared data that may be needed for reading is
	  mapped direct to device address by ->iomap_begin into
	  iomap->inline_data
	- if the iomap infrastructure needs to copy original source
	  data into destination, it copies directly from the memory
	  address in iomap->inline_data into the directly mapped DAX
	  desitination via memcpy().

This covers both the partial write COW case you are concerned with
here, and the full-extent range copy case that
FALLOC_FL_UNSHARE_RANGE requires.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
