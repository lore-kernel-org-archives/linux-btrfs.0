Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA508C10F0E
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6869F213F2
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:28:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="utrV0ZTS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfDGH0n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 03:26:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfDGH0n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2019 03:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v8/Bv5FshFzMBI9JmmBkcC29MPHmjSf9f9QzvZCYiB0=; b=utrV0ZTS4wGw3XcsyX+7btlsa
        QjszxFe4MeXZY/aHoy+PU/Whkg7sf+AJ1daEdNZ6Z8iIjPLeLT+/v4x0nqlwy08Gls6I4kb2/xWkx
        Mfh+8CS8Jr4sYBfRzV7hphgy/W68jgxUIhFDAyHVFQ1KsyB8J+QpmJLrOu/o+1YqO+0UhDCzoEO0a
        3xdK6hfBE8Ou47+ea9OHjkhrnGDPIkZwGVsASoP4aMdYGcpuu5Et+hWmn+DhfgbANwJAs9XZFrHCp
        ioHA0ejorR6g2w9C3dXzynfNgPYvO8BhfNFyX8DiTjHspCkPSEwzCaRo6NX6Q8KHWKkFPnQPLJms8
        XSlCNokMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hD2CP-0006oA-E6; Sun, 07 Apr 2019 07:26:41 +0000
Date:   Sun, 7 Apr 2019 00:26:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 04/15] dax: Introduce IOMAP_F_COW for copy-on-write
Message-ID: <20190407072641.GA20624@infradead.org>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-5-rgoldwyn@suse.de>
 <20190401043851.GO26298@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401043851.GO26298@dastard>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 01, 2019 at 03:38:52PM +1100, Dave Chinner wrote:
> On Tue, Mar 26, 2019 at 02:02:50PM -0500, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > The IOMAP_F_COW is a flag to notify dax that it needs to copy
> > the data from iomap->cow_addr to iomap->addr, if the start/end
> > of I/O are not page aligned.
> 
> I see what you are trying to do here, but this is kinda gross.

Even more gross than our current hack where for buffered I/O
we return the previous address but still allocate delalloc blocks
for the COW? ;-)

This whole area is a mine field..

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
> 
> Even better, only do the source mapping if the write isn't
> page/filesystem block aligned, and hence only do the slow path
> copying if a source mapping exists....

I looked into the do two maps instead of the mentioned above existing
gross hack when doing the buffer_head removal for iomap.  The major
issue with it is that we need a way for the second recursive mapping
to not take the inode-wide locks.  I still think it is worth it
(or move to per-fork or range locks) as it defintively is the much
cleaner way to handle it.  I just didn't bother to go there yet
as I wanted the buffer_head removal and thus kept the existing gross
hack for now.  But moving to a two mapping scheme for read-modify-write
ops would be a major improvement for sure.
