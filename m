Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED13C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 03:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A6F22146E
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 03:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbfDCDUP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 23:20:15 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:30080 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbfDCDUO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 23:20:14 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail07.adl2.internode.on.net with ESMTP; 03 Apr 2019 13:50:11 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1hBWRe-0007CX-IN; Wed, 03 Apr 2019 14:20:10 +1100
Date:   Wed, 3 Apr 2019 14:20:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/15] dax: Introduce IOMAP_F_COW for copy-on-write
Message-ID: <20190403032010.GX23020@dastard>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-5-rgoldwyn@suse.de>
 <20190401043851.GO26298@dastard>
 <20190401214102.bn4giybeqpbvdbb3@merlin>
 <20190401230653.GT23020@dastard>
 <20190403015631.eogm76qw5fwo235p@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403015631.eogm76qw5fwo235p@merlin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 02, 2019 at 08:56:31PM -0500, Goldwyn Rodrigues wrote:
> On 10:06 02/04, Dave Chinner wrote:
> > On Mon, Apr 01, 2019 at 04:41:02PM -0500, Goldwyn Rodrigues wrote:
> > > After Darrick's suggestion, we can even do away with cow_pos, so
> > > only the read address of cow_addr will exist.
> > 
> > As I mentioned earlier, even that is not necessary.
> > 
> > This is DAX - the iomap API and mapping functions can already return
> > pointers to inline data, and DAX can effectively be considered
> > inline data for the purposes of reading data.
> > 
> > As I said, the problem here is you are trying to use flags to define
> > a new type of iomap operation requires two mappings rather than one.
> > IMO, we should be defining an IOMAP_DAX_COW /type/ and then define
> > it to contain and behave as follows:
> > 
> > 	- new destination region for data to be copied into is the
> > 	  same setup as IOMAP_MAPPED
> > 	- existing shared data that may be needed for reading is
> > 	  mapped direct to device address by ->iomap_begin into
> > 	  iomap->inline_data
> > 	- if the iomap infrastructure needs to copy original source
> > 	  data into destination, it copies directly from the memory
> > 	  address in iomap->inline_data into the directly mapped DAX
> > 	  desitination via memcpy().
> > 
> > This covers both the partial write COW case you are concerned with
> > here, and the full-extent range copy case that
> > FALLOC_FL_UNSHARE_RANGE requires.
> > 
> 
> Ok, understood. However, we may have to differentiate between a CoW
> with FALLOC_FL_UNSHARE_RANGE because CoW will only (conditionally)
> copy the first and the last block wheras FALLOC_FL_UNSHARE_RANGE
> will copy the whole range. So, should it be another type?

I don't see why that would be necessary. The calling contexts are
completely different, but both know exactly what they have to copy
from the iomap's inline data. They fact they copy different parts of
data from the iomap doesn't mean we need different types of iomaps
for them...

> Also, this would require iomap_begin to translate block->dax address
> which I suppose can be a function in the dax code.

bdev_dax_pgoff() + dax_direct_access() should already provide what
we need here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
