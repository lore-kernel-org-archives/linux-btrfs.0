Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42003 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755495AbcKVJit (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 04:38:49 -0500
Date: Tue, 22 Nov 2016 01:38:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/9] btrfs: use bio iterators for the decompression
 handlers
Message-ID: <20161122093846.GA15142@infradead.org>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-2-git-send-email-hch@lst.de>
 <20161119012906.GA7265@dhcp-whq-twvpn-2-vpnpool-10-159-179-20.vpn.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161119012906.GA7265@dhcp-whq-twvpn-2-vpnpool-10-159-179-20.vpn.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 18, 2016 at 05:29:06PM -0800, Liu Bo wrote:
> On Wed, Nov 16, 2016 at 01:52:08PM +0100, Christoph Hellwig wrote:
> > Pass the full bio to the decompression routines and use bio iterators
> > to iterate over the data in the bio.
> 
> One question below,

It would be nice to cut down the email to actually find your question
without running through hundreds+ quoted lines.

> >  	/* copy bytes from the working buffer into the pages */
> >  	while (working_bytes > 0) {
> > -		bytes = min(PAGE_SIZE - *pg_offset,
> > -			    PAGE_SIZE - buf_offset);
> > +		bytes = min_t(unsigned long, bvec.bv_len,
> > +				PAGE_SIZE - buf_offset);
> >  		bytes = min(bytes, working_bytes);
> > -		kaddr = kmap_atomic(page_out);
> > -		memcpy(kaddr + *pg_offset, buf + buf_offset, bytes);
> > +
> > +		kaddr = kmap_atomic(bvec.bv_page);
> > +		memcpy(kaddr + bvec.bv_offset, buf + buf_offset, bytes);
> 
> This doesn't seem to be right, 'bvec.bv_offset' is not updated in the
> following bio_advance(bio, bytes),

Good spot - and this means xfstests doesn't cover this area very
well :(

> shouldn't it be 
> 'kaddr + bvec.bv_offset + bio->bi_iter.bi_bvec_done'?

No, we just need to get a new bvec using bio_iter_iovec after
the call to bio_advance.
