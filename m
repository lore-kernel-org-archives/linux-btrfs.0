Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89338C282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 16:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65B7120821
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 16:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732874AbfDQQjf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:39:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:54946 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729641AbfDQQjf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 12:39:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D3FEB11A;
        Wed, 17 Apr 2019 16:39:33 +0000 (UTC)
Date:   Wed, 17 Apr 2019 11:39:30 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, david@fromorbit.com, willy@infradead.org, hch@lst.de,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org
Subject: Re: [PATCH 14/18] dax: memcpy before zeroing range
Message-ID: <20190417163930.fpwvcj55rnzgo7dh@merlin>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-15-rgoldwyn@suse.de>
 <20190417154504.GC4740@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417154504.GC4740@magnolia>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  8:45 17/04, Darrick J. Wong wrote:
> On Tue, Apr 16, 2019 at 11:41:50AM -0500, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > However, this needed more iomap fields, so it was easier
> > to pass iomap and compute inside the function rather
> > than passing a log of arguments.
> > 
> > Note, there is subtle difference between iomap_sector and
> > dax_iomap_sector(). Can we replace dax_iomap_sector with
> > iomap_sector()? It would need pos & PAGE_MASK though or else
> > bdev_dax_pgoff() return -EINVAL.
> > 
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > ---
> >  fs/dax.c              | 14 ++++++++++----
> >  fs/iomap.c            |  9 +--------
> >  include/linux/dax.h   | 11 +++++------
> >  include/linux/iomap.h |  6 ++++++
> >  4 files changed, 22 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index abbe4a79f219..af94909640ea 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1055,11 +1055,15 @@ static bool dax_range_is_aligned(struct block_device *bdev,
> >  	return true;
> >  }
> >  
> > -int __dax_zero_page_range(struct block_device *bdev,
> > -		struct dax_device *dax_dev, sector_t sector,
> > -		unsigned int offset, unsigned int size)
> > +int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
> > +			  unsigned int offset, unsigned int size)
> >  {
> > -	if (dax_range_is_aligned(bdev, offset, size)) {
> > +	sector_t sector = dax_iomap_sector(iomap, pos & PAGE_MASK);
> > +	struct block_device *bdev = iomap->bdev;
> > +	struct dax_device *dax_dev = iomap->dax_dev;
> > +
> > +	if (!(iomap->type == IOMAP_DAX_COW) &&
> > +	    dax_range_is_aligned(bdev, offset, size)) {
> >  		sector_t start_sector = sector + (offset >> 9);
> >  
> >  		return blkdev_issue_zeroout(bdev, start_sector,
> > @@ -1079,6 +1083,8 @@ int __dax_zero_page_range(struct block_device *bdev,
> >  			dax_read_unlock(id);
> >  			return rc;
> >  		}
> > +		if (iomap->type == IOMAP_DAX_COW)
> > +			memcpy(iomap->inline_data, kaddr, offset);
> 
> I'm confused, why are we copying into the source page before zeroing
> some part of the dax device?

Clearly my testing was not good enough. This should be -
memcpy(kaddr, iomap->inline_data, offset);

We copy the part which is not zeroed to new location.

> 
> >  		memset(kaddr + offset, 0, size);
> >  		dax_flush(dax_dev, kaddr + offset, size);
> >  		dax_read_unlock(id);
> > diff --git a/fs/iomap.c b/fs/iomap.c
> > index abdd18e404f8..90698c854883 100644
> > --- a/fs/iomap.c
> > +++ b/fs/iomap.c
> > @@ -98,12 +98,6 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
> >  	return written ? written : ret;
> >  }
> >  
> > -static sector_t
> > -iomap_sector(struct iomap *iomap, loff_t pos)
> > -{
> > -	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
> > -}
> > -
> >  static struct iomap_page *
> >  iomap_page_create(struct inode *inode, struct page *page)
> >  {
> > @@ -990,8 +984,7 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
> >  static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
> >  		struct iomap *iomap)
> >  {
> > -	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev,
> > -			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
> > +	return __dax_zero_page_range(iomap, pos, offset, bytes);
> >  }
> >  
> >  static loff_t
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index a11bc7b1f526..892c478d7073 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -9,6 +9,7 @@
> >  
> >  typedef unsigned long dax_entry_t;
> >  
> > +struct iomap;
> >  struct iomap_ops;
> >  struct dax_device;
> >  struct dax_operations {
> > @@ -161,13 +162,11 @@ int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
> >                  loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops);
> >  
> >  #ifdef CONFIG_FS_DAX
> > -int __dax_zero_page_range(struct block_device *bdev,
> > -		struct dax_device *dax_dev, sector_t sector,
> > -		unsigned int offset, unsigned int length);
> > +int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
> > +		unsigned int offset, unsigned int size);
> >  #else
> > -static inline int __dax_zero_page_range(struct block_device *bdev,
> > -		struct dax_device *dax_dev, sector_t sector,
> > -		unsigned int offset, unsigned int length)
> > +static inline int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
> > +		unsigned int offset, unsigned int size)
> >  {
> >  	return -ENXIO;
> >  }
> > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > index 6e885c5a38a3..3a803566dea1 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> > @@ -7,6 +7,7 @@
> >  #include <linux/mm.h>
> >  #include <linux/types.h>
> >  #include <linux/mm_types.h>
> > +#include <linux/blkdev.h>
> >  
> >  struct address_space;
> >  struct fiemap_extent_info;
> > @@ -120,6 +121,11 @@ static inline struct iomap_page *to_iomap_page(struct page *page)
> >  	return NULL;
> >  }
> >  
> > +static inline sector_t iomap_sector(struct iomap *iomap, loff_t pos)
> > +{
> > +	        return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
> 
> Why the double indent?

Ahh.. I will fix this.

> 
> --D
> 
> > +}
> > +
> >  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
> >  		const struct iomap_ops *ops);
> >  int iomap_readpage(struct page *page, const struct iomap_ops *ops);
> > -- 
> > 2.16.4
> > 
> 

-- 
Goldwyn
