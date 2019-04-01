Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF60AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 04:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8837520856
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 04:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfDAEi4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 00:38:56 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:30146 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725860AbfDAEi4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 00:38:56 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 01 Apr 2019 15:08:53 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1hAoii-0004KM-1n; Mon, 01 Apr 2019 15:38:52 +1100
Date:   Mon, 1 Apr 2019 15:38:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 04/15] dax: Introduce IOMAP_F_COW for copy-on-write
Message-ID: <20190401043851.GO26298@dastard>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-5-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326190301.32365-5-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:02:50PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> The IOMAP_F_COW is a flag to notify dax that it needs to copy
> the data from iomap->cow_addr to iomap->addr, if the start/end
> of I/O are not page aligned.

I see what you are trying to do here, but this is kinda gross.

> This also introduces dax_to_dax_copy() which performs a copy
> from one part of the device to another, to a maximum of one page.
> 
> Question: Using iomap.cow_addr == 0 means the CoW is to be copied
> (or memset) from a hole. Would this be better handled through a flag?

That's what all these checks in the iomap code do:

	if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN)

Oh, wait, you're trying to map two ranges in a single iomap and then
infer state from information that got chucked away.... IOWs, you're
doing it wrong - iomap algorithms are driven by how we manipulate
iomaps to do data operations efficiently, not how we copy data page
by page.

IOWs, what we really should have here is two iomaps - a source
and a destination iomap. The source is a read mapping of the
current address (where we are going to copy the data from), the
destination is the post-cow allocation mapping (where the data
goes).

Now you just copy the data from one map to the other iterating
source mappings until the necessary range of the destination has
been covered.  And you can check if the source map is IOMAP_HOLE or
IOMAP_UNWRITTEN and hence optimise the copy (i.e. zero the new
allocation) before copying in the new data.

Even better, only do the source mapping if the write isn't
page/filesystem block aligned, and hence only do the slow path
copying if a source mapping exists....

> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 0fefb5455bda..391785de1428 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -35,6 +35,7 @@ struct vm_fault;
>  #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
>  #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
>  #define IOMAP_F_BUFFER_HEAD	0x04	/* file system requires buffer heads */
> +#define IOMAP_F_COW		0x08	/* cow before write */

"Copy on write before write"? :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
