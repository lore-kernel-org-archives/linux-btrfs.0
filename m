Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B72C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 18:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2F55205F4
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 18:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbfC0S67 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:58:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:48526 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389406AbfC0S66 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 14:58:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D1F65B027;
        Wed, 27 Mar 2019 18:58:55 +0000 (UTC)
Date:   Wed, 27 Mar 2019 13:58:53 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/15] dax: Introduce IOMAP_F_COW for copy-on-write
Message-ID: <20190327185853.cxb6oou3bwla3jsy@merlin>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-5-rgoldwyn@suse.de>
 <20190327175414.GB1172@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327175414.GB1172@magnolia>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10:54 27/03, Darrick J. Wong wrote:
> On Tue, Mar 26, 2019 at 02:02:50PM -0500, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > The IOMAP_F_COW is a flag to notify dax that it needs to copy
> > the data from iomap->cow_addr to iomap->addr, if the start/end
> > of I/O are not page aligned.
> > 
> > This also introduces dax_to_dax_copy() which performs a copy
> > from one part of the device to another, to a maximum of one page.
> > 
> > Question: Using iomap.cow_addr == 0 means the CoW is to be copied
> > (or memset) from a hole. Would this be better handled through a flag?
> > 
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > ---
> >  fs/dax.c              | 36 ++++++++++++++++++++++++++++++++++++
> >  include/linux/iomap.h |  3 +++
> >  2 files changed, 39 insertions(+)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index ca0671d55aa6..e254535dd830 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1051,6 +1051,28 @@ static bool dax_range_is_aligned(struct block_device *bdev,
> >  	return true;
> >  }
> >  
> > +static void dax_to_dax_copy(struct iomap *iomap, loff_t pos, void *daddr,
> > +			    size_t len)
> > +{
> > +	loff_t blk_start, blk_pg;
> > +	void *saddr;
> > +	ssize_t map_len;
> > +
> > +	/* A zero address is a hole. */
> > +	if (iomap->cow_addr == 0) {
> > +		memset(daddr, 0, len);
> > +		return;
> > +	}
> > +
> > +	blk_start = iomap->cow_addr + pos - iomap->cow_pos;
> > +	blk_pg = round_down(blk_start, PAGE_SIZE);
> > +
> > +	map_len = dax_direct_access(iomap->dax_dev, PHYS_PFN(blk_pg), PAGE_SIZE,
> > +			&saddr, NULL);
> > +	saddr += blk_start - blk_pg;
> > +	memcpy(daddr, saddr, len);
> > +}
> > +
> >  int __dax_zero_page_range(struct block_device *bdev,
> >  		struct dax_device *dax_dev, sector_t sector,
> >  		unsigned int offset, unsigned int size)
> > @@ -1143,6 +1165,20 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> >  			break;
> >  		}
> >  
> > +		if (iomap->flags & IOMAP_F_COW) {
> > +			loff_t pg_end = round_up(end, PAGE_SIZE);
> > +			/*
> > +			 * Copy the first part of the page
> > +			 * Note: we pass offset as length
> > +			 */
> > +			if (offset)
> > +				dax_to_dax_copy(iomap, pos - offset, kaddr, offset);
> > +
> > +			/* Copy the last part of the range */
> > +			if (end < pg_end)
> > +				dax_to_dax_copy(iomap, end, kaddr + offset + length, pg_end - end);
> > +		}
> > +
> >  		map_len = PFN_PHYS(map_len);
> >  		kaddr += offset;
> >  		map_len -= offset;
> > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > index 0fefb5455bda..391785de1428 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> 
> Probably a good idea to cc the iomap maintainers on this (entire
> patchset)... <cough>

Yup. Will include you and Christoph in the future iterations. This will
not be the last iteration for this patchset.

Looks like fsdevel and btrfs was too narrow a list ;)

> 
> --D
> 
> > @@ -35,6 +35,7 @@ struct vm_fault;
> >  #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
> >  #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
> >  #define IOMAP_F_BUFFER_HEAD	0x04	/* file system requires buffer heads */
> > +#define IOMAP_F_COW		0x08	/* cow before write */
> >  
> >  /*
> >   * Flags that only need to be reported for IOMAP_REPORT requests:
> > @@ -59,6 +60,8 @@ struct iomap {
> >  	u64			length;	/* length of mapping, bytes */
> >  	u16			type;	/* type of mapping */
> >  	u16			flags;	/* flags for mapping */
> > +	u64			cow_addr; /* read address to perform CoW */
> > +	loff_t			cow_pos; /* file offset of cow_addr */
> >  	struct block_device	*bdev;	/* block device for I/O */
> >  	struct dax_device	*dax_dev; /* dax_dev for dax operations */
> >  	void			*inline_data;
> > -- 
> > 2.16.4
> > 
> 

-- 
Goldwyn
